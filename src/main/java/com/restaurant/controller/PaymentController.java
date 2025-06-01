package com.restaurant.controller;

import com.restaurant.entity.*;
import com.restaurant.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/employee/payment")
public class PaymentController {

    @Autowired
    private TableService tableService;
    @Autowired
    private ServiceSessionService serviceSessionService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private OrderDetailService orderDetailService;
    @Autowired
    private PaymentService paymentService;
    @Autowired
    private PromotionService promotionService;

    // 1. Hiển thị danh sách bàn cần thanh toán
    @RequestMapping(value = "/tables", method = RequestMethod.GET)
    public String listTablesForPayment(Model model) {
        List<RestaurantTable> tables = tableService.findAll();
        List<RestaurantTable> tablesToPay = new ArrayList<>();
        for (RestaurantTable t : tables) {
            if ("SERVING".equals(t.getStatus()) || "PENDING_PAYMENT".equals(t.getStatus())) {
                tablesToPay.add(t);
            }
        }
        model.addAttribute("tables", tablesToPay);
        return "employee/payment-table-list";
    }

    // Method showPaymentDetail đã được loại bỏ vì không còn sử dụng trang payment-detail.jsp
    // Tất cả xử lý thanh toán đã được chuyển sang modal trong menu.jsp

    // 3. Xác nhận thanh toán
    @RequestMapping(value = "/{tableId}/confirm", method = RequestMethod.POST)
    public String confirmPayment(
            @PathVariable("tableId") Long tableId,
            @RequestParam(value = "voucherCode", required = false) String voucherCode,
            @RequestParam("paymentMethod") String paymentMethod,
            HttpSession httpSession,
            Model model,
            RedirectAttributes redirectAttributes) {

        ServiceSession session = serviceSessionService.findActiveByTableId(tableId);
        if (session == null) {
            redirectAttributes.addFlashAttribute("paymentError", "Không tìm thấy phiên phục vụ cho bàn này!");
            return "redirect:/employee/table/" + tableId + "/menu";
        }
        List<Order> orders = orderService.findBySessionId(session.getSessionId());
        List<OrderDetail> allDetails = new ArrayList<>();
        for (Order order : orders) {
            allDetails.addAll(orderDetailService.findByOrderId(order.getOrderId()));
        }
        // Kiểm tra còn món PENDING hay PROCESSING không
        boolean hasPendingOrProcessing = allDetails.stream()
                .anyMatch(
                        d -> "PENDING".equalsIgnoreCase(d.getStatus()) || "PROCESSING".equalsIgnoreCase(d.getStatus()));
        if (hasPendingOrProcessing) {
            redirectAttributes.addFlashAttribute("paymentError", "Vẫn còn món đang chờ hoặc đang chế biến, không thể thanh toán!");
            return "redirect:/employee/table/" + tableId + "/menu";
        }
        // Tính tổng tiền các món (không tính món tặng và đã huỷ)
        BigDecimal total = BigDecimal.ZERO;
        for (OrderDetail detail : allDetails) {
            if ((detail.getIsGift() == null || !detail.getIsGift())
                    && !"CANCELLED".equalsIgnoreCase(detail.getStatus())) {
                total = total.add(detail.getPrice().multiply(BigDecimal.valueOf(detail.getQuantity())));
            }
        }
        
        // Khuyến mãi từ session (thường là Happy Hour hoặc promotion tự động)
        BigDecimal sessionDiscount = BigDecimal.ZERO;
        Promotion sessionPromo = null;
        if (session.getPromotionId() != null) {
            Promotion promo = promotionService.findById(session.getPromotionId());
            if (promo != null && promo.isActive()) {
                sessionPromo = promo;
                sessionDiscount = promotionService.calculateDiscount(promo, total);
            }
        }
        
        // Voucher (khuyến mãi theo mã nhập)
        BigDecimal voucherDiscount = BigDecimal.ZERO;
        Promotion voucherPromo = null;
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            Promotion promo = promotionService.findByVoucherCode(voucherCode.trim());
            if (promo != null && promo.isActive()) {
                // Kiểm tra xem voucher còn có thể sử dụng được không (chưa vượt max_usage)
                if (!promotionService.isPromotionUsable(promo.getPromotionId())) {
                    redirectAttributes.addFlashAttribute("paymentError", "Voucher '" + voucherCode + "' đã hết lượt sử dụng!");
                    return "redirect:/employee/table/" + tableId + "/menu";
                }
                
                // Tính voucher discount theo scope (ALL/CATEGORY/DISH)
                voucherDiscount = promotionService.calculateVoucherDiscountByScope(promo, allDetails);
                
                // Kiểm tra điều kiện đơn hàng tối thiểu
                if (voucherDiscount.compareTo(BigDecimal.ZERO) > 0) {
                    voucherPromo = promo;
                } else {
                    redirectAttributes.addFlashAttribute("paymentError", "Voucher '" + voucherCode + "' không áp dụng được cho các món đã chọn hoặc chưa đủ điều kiện tối thiểu!");
                    return "redirect:/employee/table/" + tableId + "/menu";
                }
            } else {
                redirectAttributes.addFlashAttribute("paymentError", "Mã voucher '" + voucherCode + "' không hợp lệ hoặc đã hết hạn!");
                return "redirect:/employee/table/" + tableId + "/menu";
            }
        }
        
        // Tính số tiền cuối cùng
        BigDecimal finalAmount = total.subtract(sessionDiscount).subtract(voucherDiscount);
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0)
            finalAmount = BigDecimal.ZERO;

        // Lưu Payment
        Employee employee = (Employee) httpSession.getAttribute("loggedInUser");
        Payment payment = new Payment();
        payment.setSessionId(session.getSessionId());
        payment.setEmployeeId(employee != null ? employee.getEmployeeId() : null);
        payment.setTotalAmount(total);
        payment.setVoucherDiscount(voucherDiscount);
        payment.setFinalAmount(finalAmount);
        payment.setPaymentMethod(paymentMethod);
        payment.setPaymentTime(new Date());
        
        // Ưu tiên voucher trước session promotion
        if (voucherPromo != null) {
            payment.setPromotionId(voucherPromo.getPromotionId());
        } else if (sessionPromo != null) {
            payment.setPromotionId(sessionPromo.getPromotionId());
        }
        paymentService.save(payment);

        // Cập nhật trạng thái session và tất cả bàn trong session
        session.setStatus("COMPLETED");
        serviceSessionService.save(session);
        
        // Lấy tất cả bàn trong session để cập nhật trạng thái
        List<Order> sessionOrders = orderService.findBySessionId(session.getSessionId());
        Set<Long> sessionTableIds = new HashSet<>();
        for (Order order : sessionOrders) {
            sessionTableIds.add(order.getTableId());
        }
        
        // Cập nhật trạng thái tất cả bàn trong session thành CLEANING
        for (Long tId : sessionTableIds) {
            RestaurantTable sessionTable = tableService.findById(tId);
            if (sessionTable != null) {
                sessionTable.setStatus("CLEANING");
                tableService.save(sessionTable);
                }
            }

        model.addAttribute("payment", payment);
        RestaurantTable currentTable = tableService.findById(tableId);
        model.addAttribute("table", currentTable);
        // Redirect về menu với thông báo thành công
        return "redirect:/employee/table/" + tableId + "/menu?paymentSuccess=true&amount=" + finalAmount;
        }

    // Method applyVoucher đã được loại bỏ vì không còn sử dụng
    // Voucher được xử lý trực tiếp trong modal thanh toán qua form submission
    
    // 4. Kiểm tra voucher trước khi thanh toán
    @RequestMapping(value = "/{tableId}/check-voucher", method = RequestMethod.POST)
    public String checkVoucher(
            @PathVariable("tableId") Long tableId,
            @RequestParam("voucherCode") String voucherCode,
            Model model) {

        ServiceSession session = serviceSessionService.findActiveByTableId(tableId);
        if (session == null) {
            model.addAttribute("voucherError", "Không tìm thấy phiên phục vụ cho bàn này!");
            return "employee/voucher-result";
        }

        List<Order> orders = orderService.findBySessionId(session.getSessionId());
        List<OrderDetail> allDetails = new ArrayList<>();
        for (Order order : orders) {
            allDetails.addAll(orderDetailService.findByOrderId(order.getOrderId()));
        }

        // Tính tổng tiền các món (không tính món tặng và đã huỷ)
        BigDecimal total = BigDecimal.ZERO;
        for (OrderDetail detail : allDetails) {
            if ((detail.getIsGift() == null || !detail.getIsGift())
                    && !"CANCELLED".equalsIgnoreCase(detail.getStatus())) {
                total = total.add(detail.getPrice().multiply(BigDecimal.valueOf(detail.getQuantity())));
            }
        }

        // Kiểm tra voucher
        BigDecimal voucherDiscount = BigDecimal.ZERO;
        String message = "";
        boolean isValid = false;

        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            Promotion promo = promotionService.findByVoucherCode(voucherCode.trim());
            if (promo != null && promo.isActive()) {
                // Kiểm tra xem voucher còn có thể sử dụng được không (chưa vượt max_usage)
                if (!promotionService.isPromotionUsable(promo.getPromotionId())) {
                    message = "Voucher '" + voucherCode + "' đã hết lượt sử dụng!";
                } else {
                    // Tính voucher discount theo scope (ALL/CATEGORY/DISH)
                    voucherDiscount = promotionService.calculateVoucherDiscountByScope(promo, allDetails);
                    
                    if (voucherDiscount.compareTo(BigDecimal.ZERO) > 0) {
                        // Voucher hợp lệ
                        message = "Áp dụng voucher thành công! Giảm " + voucherDiscount + "đ";
                        isValid = true;
                    } else {
                        message = "Voucher '" + voucherCode + "' không áp dụng được cho các món đã chọn hoặc chưa đủ điều kiện tối thiểu!";
                    }
                }
            } else {
                message = "Mã voucher '" + voucherCode + "' không hợp lệ hoặc đã hết hạn!";
            }
        }

        BigDecimal finalAmount = total.subtract(voucherDiscount);
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0)
            finalAmount = BigDecimal.ZERO;

        model.addAttribute("isValid", isValid);
        model.addAttribute("message", message);
        model.addAttribute("voucherDiscount", voucherDiscount);
        model.addAttribute("finalAmount", finalAmount);
        model.addAttribute("total", total);

        return "employee/voucher-result";
    }

    /**
     * Hiển thị lịch sử thanh toán của nhân viên đăng nhập, có thể filter theo ngày.
     */
    @RequestMapping(value = "/history", method = RequestMethod.GET)
    public String paymentHistory(
            @RequestParam(value = "fromDate", required = false) String fromDateStr,
            @RequestParam(value = "toDate", required = false) String toDateStr,
            HttpSession httpSession,
            Model model) throws Exception {
        // Lấy nhân viên đang đăng nhập
        Employee employee = (Employee) httpSession.getAttribute("loggedInUser");
        Long empId = (employee != null ? employee.getEmployeeId() : null);
        // Lấy tất cả thanh toán của nhân viên
        List<Payment> payments = paymentService.findByEmployeeId(empId);
        // Parse và filter theo fromDate/toDate nếu có
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date from = null, to = null;
        if (fromDateStr != null && !fromDateStr.isEmpty()) {
            from = sdf.parse(fromDateStr);
            Calendar cal = Calendar.getInstance();
            cal.setTime(from);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            from = cal.getTime();
        }
        if (toDateStr != null && !toDateStr.isEmpty()) {
            to = sdf.parse(toDateStr);
            Calendar cal = Calendar.getInstance();
            cal.setTime(to);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            to = cal.getTime();
        }
        // Filter list
        List<Payment> filtered = new ArrayList<>();
        for (Payment p : payments) {
            Date pt = p.getPaymentTime();
            boolean ok = true;
            if (from != null && pt.before(from)) ok = false;
            if (to != null && pt.after(to)) ok = false;
            if (ok) filtered.add(p);
        }
        model.addAttribute("payments", filtered);
        model.addAttribute("fromDate", fromDateStr);
        model.addAttribute("toDate", toDateStr);
        return "employee/payment-history";
    }
}