package com.restaurant.controller;

import com.restaurant.entity.Order;
import com.restaurant.entity.OrderDetail;
import com.restaurant.service.OrderDetailService;
import com.restaurant.service.OrderService;
import com.restaurant.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/employee/orderDetail")
public class EmployeeOrderController {

    @Autowired
    private OrderDetailService orderDetailService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private MenuService menuService;

    /**
     * Cập nhật số lượng món đã đặt
     */
    @RequestMapping(value = "/{id}/updateQuantity", method = RequestMethod.POST)
    public String updateQuantity(@PathVariable("id") Long orderDetailId,
            @RequestParam("quantity") Integer quantity,
            @RequestParam("tableId") Long tableId,
            RedirectAttributes redirectAttrs) {
        try {
            OrderDetail orderDetail = orderDetailService.findById(orderDetailId);
            if (orderDetail == null) {
                redirectAttrs.addFlashAttribute("errorMessage", "Không tìm thấy thông tin món");
                return "redirect:/employee/table/" + tableId + "/menu";
            }

            // Chỉ cho phép cập nhật món PENDING
            if (!"PENDING".equals(orderDetail.getStatus())) {
                redirectAttrs.addFlashAttribute("errorMessage", "Chỉ có thể cập nhật món đang chờ chế biến");
                return "redirect:/employee/table/" + tableId + "/menu";
            }

            // Cập nhật số lượng
            orderDetail.setQuantity(quantity);
            orderDetailService.save(orderDetail);

            redirectAttrs.addFlashAttribute("successMessage", "Đã cập nhật số lượng món thành công");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        
        return "redirect:/employee/table/" + tableId + "/menu";
    }

    /**
     * Hủy món đã đặt
     */
    @RequestMapping(value = "/{id}/cancel", method = RequestMethod.POST)
    public String cancelOrderDetail(@PathVariable("id") Long orderDetailId,
            @RequestParam("reason") String reason,
            @RequestParam("tableId") Long tableId,
            RedirectAttributes redirectAttrs) {
        try {
            OrderDetail orderDetail = orderDetailService.findById(orderDetailId);
            if (orderDetail == null) {
                redirectAttrs.addFlashAttribute("errorMessage", "Không tìm thấy thông tin món");
                return "redirect:/employee/table/" + tableId + "/menu";
            }

            // Chỉ cho phép hủy món PENDING
            if (!"PENDING".equals(orderDetail.getStatus())) {
                redirectAttrs.addFlashAttribute("errorMessage", "Chỉ có thể hủy món đang chờ chế biến");
                return "redirect:/employee/table/" + tableId + "/menu";
            }

            // Cập nhật trạng thái và lý do hủy
            orderDetail.setStatus("CANCELLED");
            orderDetail.setCancelReason(reason);
            orderDetailService.save(orderDetail);

            // Kiểm tra nếu tất cả các món trong đơn hàng đều đã bị hủy
            Long orderId = orderDetail.getOrderId();
            List<OrderDetail> allOrderDetails = orderDetailService.findByOrderId(orderId);

            boolean allCancelled = true;
            for (OrderDetail detail : allOrderDetails) {
                if (!"CANCELLED".equals(detail.getStatus())) {
                    allCancelled = false;
                    break;
                }
            }

            // Nếu tất cả món đều đã bị hủy, cập nhật trạng thái đơn hàng thành CANCELLED
            if (allCancelled) {
                Order order = orderService.findById(orderId);
                if (order != null) {
                    order.setStatus("CANCELLED");
                    orderService.save(order);
                }
            }

            redirectAttrs.addFlashAttribute("successMessage", "Đã hủy món thành công");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        
        return "redirect:/employee/table/" + tableId + "/menu";
    }
}