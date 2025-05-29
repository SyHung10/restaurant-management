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
}
