package com.restaurant.controller;

import com.restaurant.dto.OrderDetailView;
import com.restaurant.entity.Order;
import com.restaurant.entity.OrderDetail;
import com.restaurant.entity.Promotion;
import com.restaurant.entity.Menu;
import com.restaurant.service.OrderDetailService;
import com.restaurant.service.OrderService;
import com.restaurant.service.MenuService;
import com.restaurant.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Comparator;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.math.BigDecimal;

@Controller
@RequestMapping("/kitchen")
public class KitchenController {

    @Autowired
    private OrderDetailService orderDetailService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private MenuService menuService;

    @Autowired
    private CategoryService categoryService;

    // Hiển thị danh sách món PENDING
    @RequestMapping(value = "/pending", method = RequestMethod.GET)
    public String listPending(Model model) {
        // Lấy tất cả OrderDetail pending và processing
        List<OrderDetail> pendingDetails = orderDetailService.findByStatus("PENDING");
        List<OrderDetail> processingDetails = orderDetailService.findByStatus("PROCESSING");

        // Gộp 2 danh sách
        List<OrderDetail> allDetails = new ArrayList<>();
        allDetails.addAll(pendingDetails);
        allDetails.addAll(processingDetails);

        // Map sang OrderDetailView để có tên món
        List<OrderDetailView> pendingList = new ArrayList<>();
        for (OrderDetail od : allDetails) {
            Menu menu = menuService.findById(od.getDishId());
            pendingList.add(new OrderDetailView(od, menu));
        }
        model.addAttribute("pendingList", pendingList);
        return "kitchen/pending-list";
    }

    // Bếp nhấn "Bắt đầu nấu" cho món
    @RequestMapping(value = "/orderDetail/{id}/startCooking", method = RequestMethod.POST)
    public String startCooking(@PathVariable("id") Long detailId) {
        // Cập nhật status món thành PROCESSING
        OrderDetail detail = orderDetailService.findById(detailId);
        detail.setStatus("PROCESSING");
        orderDetailService.save(detail);

        // Cập nhật trạng thái order nếu cần
        Long orderId = detail.getOrderId();
        Order order = orderService.findById(orderId);
        if ("PENDING".equals(order.getStatus())) {
            order.setStatus("PROCESSING");
            orderService.save(order);
        }

        return "redirect:/kitchen/pending";
    }

    // Bếp nhấn Done cho món
    @RequestMapping(value = "/orderDetail/{id}/done", method = RequestMethod.POST)
    public String markDone(@PathVariable("id") Long detailId) {
        // Cập nhật status món
        OrderDetail detail = orderDetailService.findById(detailId);
        detail.setStatus("SERVED");
        orderDetailService.save(detail);
        // Kiểm tra còn món pending hoặc processing trong đơn này không
        Long orderId = detail.getOrderId();
        List<OrderDetail> remainingPending = orderDetailService.findByOrderIdAndStatus(orderId, "PENDING");
        List<OrderDetail> remainingProcessing = orderDetailService.findByOrderIdAndStatus(orderId, "PROCESSING");

        if (remainingPending.isEmpty() && remainingProcessing.isEmpty()) {
            // Cập nhật trạng thái order
            Order order = orderService.findById(orderId);
            order.setStatus("SERVED");
            orderService.save(order);
        }
        return "redirect:/kitchen/pending";
    }

    // Bếp huỷ món - hiển thị trang form hủy món
    @RequestMapping(value = "/orderDetail/{id}/cancelForm", method = RequestMethod.GET)
    public String cancelForm(@PathVariable("id") Long detailId, Model model) {
        OrderDetail detail = orderDetailService.findById(detailId);
        Menu menu = menuService.findById(detail.getDishId());
        model.addAttribute("orderDetail", detail);
        model.addAttribute("menu", menu);
        return "kitchen/cancel-form";
    }

    // Xác nhận huỷ món
    @RequestMapping(value = "/orderDetail/{id}/cancel", method = RequestMethod.POST)
    public String cancelDetail(@PathVariable("id") Long detailId,
            @RequestParam("reason") String reason) {
        OrderDetail detail = orderDetailService.findById(detailId);
        detail.setStatus("CANCELLED");
        detail.setCancelReason(reason);
        orderDetailService.save(detail);

        // Kiểm tra nếu tất cả các món trong đơn hàng đều đã bị hủy
        Long orderId = detail.getOrderId();
        List<OrderDetail> allOrderDetails = orderDetailService.findByOrderId(orderId);

        boolean allCancelled = true;
        for (OrderDetail od : allOrderDetails) {
            if (!"CANCELLED".equals(od.getStatus())) {
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

        return "redirect:/kitchen/pending";
    }

    // Kanban cho bếp: danh sách order group theo order_id, sort theo order_time ASC
    @RequestMapping(value = "/kanban", method = RequestMethod.GET)
    public String kitchenKanban(
            @RequestParam(value = "fromDate", required = false) String fromDateStr,
            @RequestParam(value = "toDate", required = false) String toDateStr,
            Model model) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        Date from = null, to = null;
        if (fromDateStr != null && !fromDateStr.isEmpty()) {
            Date d = sdf.parse(fromDateStr);
            cal.setTime(d);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            from = cal.getTime();
        }
        if (toDateStr != null && !toDateStr.isEmpty()) {
            Date d = sdf.parse(toDateStr);
            cal.setTime(d);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            to = cal.getTime();
        }
        List<Order> allOrders = orderService.findAll();
        List<Order> filteredOrders = new ArrayList<>();
        for (Order o : allOrders) {
            if (from != null && to != null) {
                if (o.getOrderTime().compareTo(from) >= 0 && o.getOrderTime().compareTo(to) <= 0) {
                    filteredOrders.add(o);
                }
            } else {
                filteredOrders.add(o);
            }
        }
        // Chuẩn bị dữ liệu bảng và overview
        Map<Long, List<OrderDetailView>> orderDetailsMap = new HashMap<>();
        int pendingCount = 0, servedCount = 0, cancelledCount = 0, totalCount = 0;
        Map<Long, Integer> orderPendingMap = new HashMap<>();
        Map<Long, Integer> orderServedMap = new HashMap<>();
        Map<Long, Integer> orderCancelledMap = new HashMap<>();
        Map<Long, Integer> orderTotalMap = new HashMap<>();
        for (Order order : filteredOrders) {
            List<OrderDetail> details = orderDetailService.findByOrderId(order.getOrderId());
            int orderPending = 0, orderServed = 0, orderCancelled = 0;
            List<OrderDetailView> detailViews = new ArrayList<>();
            for (OrderDetail d : details) {
                if ("PENDING".equals(d.getStatus()) || "PROCESSING".equals(d.getStatus()))
                    orderPending++;
                if ("SERVED".equals(d.getStatus()))
                    orderServed++;
                if ("CANCELLED".equals(d.getStatus()))
                    orderCancelled++;
                Menu menu = menuService.findById(d.getDishId());
                detailViews.add(new OrderDetailView(d, menu, order));
            }
            if (orderPending > 0)
                pendingCount++;
            if (orderServed > 0)
                servedCount++;
            if (orderCancelled > 0)
                cancelledCount++;
            if (!details.isEmpty())
                totalCount++;
            orderDetailsMap.put(order.getOrderId(), detailViews);
            orderPendingMap.put(order.getOrderId(), orderPending);
            orderServedMap.put(order.getOrderId(), orderServed);
            orderCancelledMap.put(order.getOrderId(), orderCancelled);
            orderTotalMap.put(order.getOrderId(), details.size());
        }
        filteredOrders.sort(Comparator.comparing(Order::getOrderTime).reversed());
        model.addAttribute("orders", filteredOrders);
        model.addAttribute("orderDetailsMap", orderDetailsMap);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("servedCount", servedCount);
        model.addAttribute("cancelledCount", cancelledCount);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("orderPendingMap", orderPendingMap);
        model.addAttribute("orderServedMap", orderServedMap);
        model.addAttribute("orderCancelledMap", orderCancelledMap);
        model.addAttribute("orderTotalMap", orderTotalMap);
        model.addAttribute("fromDate", fromDateStr);
        model.addAttribute("toDate", toDateStr);
        return "kitchen/pending-list";
    }

    // Đổi trạng thái order
    @RequestMapping(value = "/order/{id}/change-status", method = RequestMethod.POST)
    public String changeOrderStatus(@PathVariable("id") Long orderId, @RequestParam("status") String status,
            @RequestParam(value = "dateType", required = false, defaultValue = "today") String dateType,
            @RequestParam(value = "specificDate", required = false) String specificDate) {
        Order order = orderService.findById(orderId);
        if (order != null) {
            order.setStatus(status);
            orderService.save(order);
        }
        // Giữ lại filter khi reload lại bảng
        String redirectUrl = "/kitchen/kanban?dateType=" + dateType;
        if (specificDate != null && !specificDate.isEmpty()) {
            redirectUrl += "&specificDate=" + specificDate;
        }
        return "redirect:" + redirectUrl;
    }

    // Đổi trạng thái order detail
    @RequestMapping(value = "/orderDetail/{id}/change-status", method = RequestMethod.POST)
    public String changeOrderDetailStatus(@PathVariable("id") Long detailId, @RequestParam("status") String status,
            @RequestParam(value = "dateType", required = false, defaultValue = "today") String dateType,
            @RequestParam(value = "specificDate", required = false) String specificDate) {
        OrderDetail detail = orderDetailService.findById(detailId);
        if (detail != null) {
            detail.setStatus(status);
            orderDetailService.save(detail);
            // Nếu tất cả món đã SERVED thì cập nhật order
            Long orderId = detail.getOrderId();
            List<OrderDetail> details = orderDetailService.findByOrderId(orderId);
            boolean allServed = details.stream().allMatch(d -> "SERVED".equals(d.getStatus()));
            boolean allCancelled = details.stream().allMatch(d -> "CANCELLED".equals(d.getStatus()));
            Order order = orderService.findById(orderId);
            if (allServed && order != null) {
                order.setStatus("SERVED");
                orderService.save(order);
            } else if (allCancelled && order != null) {
                order.setStatus("CANCELLED");
                orderService.save(order);
            }
        }
        // Giữ lại filter khi reload lại bảng
        String redirectUrl = "/kitchen/kanban?dateType=" + dateType;
        if (specificDate != null && !specificDate.isEmpty()) {
            redirectUrl += "&specificDate=" + specificDate;
        }
        return "redirect:" + redirectUrl;
    }

    // Hiển thị trạng thái menu với filter date range và báo cáo doanh thu
    @RequestMapping(value = "/menu-status", method = RequestMethod.GET)
    public String menuStatus(
            @RequestParam(value = "fromDate", required = false) String fromDateStr,
            @RequestParam(value = "toDate", required = false) String toDateStr,
            Model model) throws Exception {
        // Parse ngày
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        java.util.Date from = null, to = null;
        if (fromDateStr != null && !fromDateStr.isEmpty()) {
            java.util.Date d = sdf.parse(fromDateStr);
            cal.setTime(d);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            from = cal.getTime();
        }
        if (toDateStr != null && !toDateStr.isEmpty()) {
            java.util.Date d = sdf.parse(toDateStr);
            cal.setTime(d);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            to = cal.getTime();
        }
        // Lấy đơn hàng theo khoảng thời gian
        List<Order> allOrders = orderService.findAll();
        List<Order> filteredOrders = new ArrayList<>();
        for (Order o : allOrders) {
            if (from != null && to != null) {
                if (o.getOrderTime().compareTo(from) >= 0 && o.getOrderTime().compareTo(to) <= 0) {
                    filteredOrders.add(o);
                }
            } else {
                filteredOrders.add(o);
            }
        }
        // Tính báo cáo
        Map<Long, BigDecimal> revenueMap = new HashMap<>();
        Map<Long, Integer> orderCountMap = new HashMap<>();
        Map<Long, Integer> cancelCountMap = new HashMap<>();
        for (Order order : filteredOrders) {
            List<OrderDetail> details = orderDetailService.findByOrderId(order.getOrderId());
            for (OrderDetail od : details) {
                Long dishId = od.getDishId();
                Menu menu = menuService.findById(dishId);
                BigDecimal price = BigDecimal.valueOf(menu.getPrice());
                int qty = od.getQuantity();
                // doanh thu chỉ tính món không bị hủy
                BigDecimal rev = revenueMap.getOrDefault(dishId, BigDecimal.ZERO);
                if (!"CANCELLED".equals(od.getStatus())) {
                    rev = rev.add(price.multiply(BigDecimal.valueOf(qty)));
                }
                revenueMap.put(dishId, rev);
                orderCountMap.put(dishId, orderCountMap.getOrDefault(dishId, 0) + qty);
                if ("CANCELLED".equals(od.getStatus())) {
                    cancelCountMap.put(dishId, cancelCountMap.getOrDefault(dishId, 0) + qty);
                }
            }
        }
        List<Menu> menus = menuService.findAll();
        model.addAttribute("menus", menus);
        model.addAttribute("revenueMap", revenueMap);
        model.addAttribute("orderCountMap", orderCountMap);
        model.addAttribute("cancelCountMap", cancelCountMap);
        model.addAttribute("fromDate", fromDateStr);
        model.addAttribute("toDate", toDateStr);
        return "kitchen/menu-status";
    }

    // Đổi trạng thái menu
    @RequestMapping(value = "/menu/{id}/change-status", method = RequestMethod.POST)
    public String changeMenuStatus(@PathVariable("id") Long menuId,
            @RequestParam("status") String status,
            @RequestParam(value = "fromDate", required = false) String fromDateStr,
            @RequestParam(value = "toDate", required = false) String toDateStr) {
        Menu menu = menuService.findById(menuId);
        if (menu != null) {
            menu.setStatus("AVAILABLE".equals(status) ? "AVAILABLE" : "UNAVAILABLE");
            menuService.save(menu);
        }
        String redirectUrl = "/kitchen/menu-status";
        if (fromDateStr != null || toDateStr != null) {
            redirectUrl += "?";
            if (fromDateStr != null)
                redirectUrl += "fromDate=" + fromDateStr;
            if (toDateStr != null)
                redirectUrl += "&toDate=" + toDateStr;
        }
        return "redirect:" + redirectUrl;
    }
}
