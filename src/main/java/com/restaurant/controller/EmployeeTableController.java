package com.restaurant.controller;

import com.restaurant.entity.RestaurantTable;
import com.restaurant.entity.Menu;
import com.restaurant.entity.Order;
import com.restaurant.entity.OrderDetail;
import com.restaurant.entity.ServiceSession;
import com.restaurant.entity.Category;
import com.restaurant.service.TableService;
import com.restaurant.service.MenuService;
import com.restaurant.service.OrderService;
import com.restaurant.service.OrderDetailService;
import com.restaurant.service.ServiceSessionService;
import com.restaurant.service.CategoryService;
import com.restaurant.dto.OrderDetailView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping("/employee/table")
public class EmployeeTableController {

    @Autowired
    private TableService tableService;
    @Autowired
    private MenuService menuService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private OrderDetailService orderDetailService;
    @Autowired
    private ServiceSessionService serviceSessionService;
    @Autowired
    private CategoryService categoryService;

    // 1. Hiển thị danh sách bàn
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String listTables(Model model,
            @RequestParam(value = "floor", required = false) Integer floor,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        List<RestaurantTable> allTables = tableService.findAll();

        // Lọc theo các tiêu chí nếu được cung cấp
        if (floor != null || status != null) {
            List<RestaurantTable> filteredTables = new ArrayList<>();
            for (RestaurantTable table : allTables) {
                boolean floorMatch = floor == null || table.getFloor().equals(floor);
                boolean statusMatch = status == null || status.isEmpty() || table.getStatus().equals(status);

                if (floorMatch && statusMatch) {
                    filteredTables.add(table);
                }
            }
            allTables = filteredTables;
        }

        // Lấy danh sách các tầng và trạng thái duy nhất để hiển thị trong bộ lọc
        Set<Integer> floors = new HashSet<>();
        Set<String> statuses = new HashSet<>();

        for (RestaurantTable table : tableService.findAll()) {
            floors.add(table.getFloor());
            statuses.add(table.getStatus());
        }

        // Phân trang
        int pageSize = 12; // Số bàn mỗi trang
        int totalTables = allTables.size();
        int totalPages = (int) Math.ceil((double) totalTables / pageSize);

        // Đảm bảo page hợp lệ
        if (page < 1)
            page = 1;
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        // Lấy phân đoạn bàn cho trang hiện tại
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalTables);

        List<RestaurantTable> tablesForCurrentPage;
        if (fromIndex < totalTables) {
            tablesForCurrentPage = allTables.subList(fromIndex, toIndex);
        } else {
            tablesForCurrentPage = new ArrayList<>();
        }

        model.addAttribute("tables", tablesForCurrentPage);
        model.addAttribute("floors", floors);
        model.addAttribute("statuses", statuses);
        model.addAttribute("selectedFloor", floor);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalTables", totalTables);

        return "employee/table-list";
    }

    // 2. Hiển thị trang menu cho bàn
    @RequestMapping(value = "/{tableId}/menu", method = RequestMethod.GET)
    public String showMenu(@PathVariable("tableId") Long tableId, Model model) {
        RestaurantTable table = tableService.findById(tableId);
        List<Category> categories = categoryService.findAllActive();
        model.addAttribute("table", table);
        model.addAttribute("categories", categories);

        // Load danh sách món ăn theo từng danh mục
        Map<Long, List<Menu>> menuByCategory = new HashMap<>();
        for (Category category : categories) {
            menuByCategory.put(category.getCategoryId(),
                    menuService.findAvailableByCategoryId(category.getCategoryId()));
        }
        model.addAttribute("menuByCategory", menuByCategory);

        // Thêm: load danh sách món đã đặt và tính toán thanh toán
        ServiceSession session = serviceSessionService.findActiveByTableId(tableId);
        List<OrderDetailView> orderDetailViews = new ArrayList<>();
        List<RestaurantTable> sessionTables = new ArrayList<>(); // Danh sách tất cả bàn trong session
        java.math.BigDecimal paymentTotal = java.math.BigDecimal.ZERO;
        
        if (session != null) {
            // Lấy tất cả bàn trong session từ table_id string
            List<Long> sessionTableIds = session.getTableIds();
            
            // Lấy thông tin tất cả bàn trong session
            for (Long tId : sessionTableIds) {
                RestaurantTable sessionTable = tableService.findById(tId);
                if (sessionTable != null) {
                    sessionTables.add(sessionTable);
                }
            }
            
            // Lấy tất cả orders trong session
            List<Order> sessionOrders = orderService.findBySessionId(session.getSessionId());
            
            for (Order o : sessionOrders) {
                for (OrderDetail d : orderDetailService.findByOrderId(o.getOrderId())) {
                    orderDetailViews.add(new OrderDetailView(d, menuService.findById(d.getDishId()), o));
                }
            }
            
            // Tính tổng tiền các món (không tính món tặng và đã hủy)
            for (OrderDetailView odv : orderDetailViews) {
                if ((odv.getOrderDetail().getIsGift() == null || !odv.getOrderDetail().getIsGift())
                        && !"CANCELLED".equalsIgnoreCase(odv.getOrderDetail().getStatus())) {
                    paymentTotal = paymentTotal.add(odv.getOrderDetail().getPrice()
                            .multiply(java.math.BigDecimal.valueOf(odv.getOrderDetail().getQuantity())));
                }
            }
            
            model.addAttribute("sessionId", session.getSessionId());
            model.addAttribute("session", session);
        }
        
        model.addAttribute("orderDetailViews", orderDetailViews);
        model.addAttribute("sessionTables", sessionTables); // Tất cả bàn trong session
        model.addAttribute("paymentTotal", paymentTotal);
        model.addAttribute("finalAmount", paymentTotal);

        // Thêm danh sách tất cả bàn (trừ bàn hiện tại) cho modal thêm bàn phụ
        List<RestaurantTable> availableTables = new ArrayList<>();
        List<RestaurantTable> allTables = tableService.findAll();
        for (RestaurantTable t : allTables) {
            if (!t.getTableId().equals(tableId)) {
                availableTables.add(t);
            }
        }
        model.addAttribute("availableTables", availableTables);

        return "employee/menu"; // Trả về view menu.jsp
    }

    // 3. Đặt món cho bàn (submit form chọn món)
    @RequestMapping(value = "/{tableId}/order", method = RequestMethod.POST)
    public String placeOrder(
            @PathVariable("tableId") Long tableId,
            @RequestParam("numPeople") Integer numPeople,
            @RequestParam("dishIds") List<Long> dishIds,
            @RequestParam("quantities") List<Integer> quantities,
            Model model) {

        // Tìm hoặc tạo ServiceSession ACTIVE cho bàn
        ServiceSession session = serviceSessionService.findActiveByTableId(tableId);
        RestaurantTable table = tableService.findById(tableId);
        if (session == null) {
            session = new ServiceSession();
            session.setTableId(tableId.toString()); // Chỉ lưu ID bàn chính
            session.setNumPeople(numPeople);
            session.setStartTime(new Date());
            session.setStatus("ACTIVE");
            serviceSessionService.save(session);
            // Cập nhật trạng thái bàn sang "SERVING" khi bắt đầu phục vụ
            table.setStatus("SERVING");
            tableService.save(table);
        }

        // Tạo Order mới
        Order order = new Order();
        order.setSessionId(session.getSessionId());
        order.setTableId(tableId);
        order.setOrderTime(new Date());
        order.setStatus("PENDING");
        orderService.save(order);

        // Lưu các OrderDetail
        for (int i = 0; i < dishIds.size(); i++) {
            if (quantities.get(i) != null && quantities.get(i) > 0) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderId(order.getOrderId());
                detail.setDishId(dishIds.get(i));
                detail.setQuantity(quantities.get(i));
                Menu menu = menuService.findById(dishIds.get(i));
                detail.setPrice(java.math.BigDecimal.valueOf(menu.getPrice()));
                detail.setIsGift(false);
                orderDetailService.save(detail);
            }
        }

        return "redirect:/employee/table/" + tableId + "/menu";
    }

    // 4. Xem lại các món đã đặt của bàn
    @RequestMapping(value = "/{tableId}/orders", method = RequestMethod.GET)
    public String viewOrders(@PathVariable("tableId") Long tableId, Model model) {
        ServiceSession session = serviceSessionService.findActiveByTableId(tableId);
        List<OrderDetailView> orderDetailViews = new ArrayList<>();
        if (session != null) {
            List<Order> orders = orderService.findBySessionId(session.getSessionId());
            for (Order order : orders) {
                List<OrderDetail> details = orderDetailService.findByOrderId(order.getOrderId());
                for (OrderDetail detail : details) {
                    Menu menu = menuService.findById(detail.getDishId());
                    orderDetailViews.add(new OrderDetailView(detail, menu));
                }
            }
        }
        model.addAttribute("orderDetailViews", orderDetailViews);
        model.addAttribute("tableId", tableId);
        return "employee/order-list";
    }

    // 5. Hiển thị trang chọn bàn phụ
    @RequestMapping(value = "/{tableId}/select-additional-tables", method = RequestMethod.GET)
    public String showSelectAdditionalTables(@PathVariable("tableId") Long tableId, Model model) {
        RestaurantTable currentTable = tableService.findById(tableId);
        List<RestaurantTable> availableTables = new ArrayList<>();
        
        for (RestaurantTable table : tableService.findAll()) {
            if (!table.getTableId().equals(tableId) && 
                ("AVAILABLE".equals(table.getStatus()) || "RESERVED".equals(table.getStatus()))) {
                availableTables.add(table);
            }
        }
        
        model.addAttribute("currentTable", currentTable);
        model.addAttribute("availableTables", availableTables);
        return "employee/select-additional-tables";
    }

    // 6. Xử lý thêm bàn phụ
    @RequestMapping(value = "/{tableId}/add-additional-tables", method = RequestMethod.POST)
    public String addAdditionalTables(
            @PathVariable("tableId") Long tableId,
            @RequestParam(value = "additionalTableIds", required = false) List<Long> additionalTableIds,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttrs) {
        
        try {
            if (additionalTableIds == null || additionalTableIds.isEmpty()) {
                redirectAttrs.addFlashAttribute("addTableError", "Vui lòng chọn ít nhất một bàn phụ!");
                return "redirect:/employee/table/" + tableId + "/menu";
            }

            // Tìm session hiện tại của bàn gốc
            ServiceSession session = serviceSessionService.findActiveByTableId(tableId);
            if (session == null) {
                redirectAttrs.addFlashAttribute("errorMessage", "Không tìm thấy session active cho bàn này!");
                return "redirect:/employee/table/" + tableId + "/menu";
            }

            List<String> addedTables = new ArrayList<>();
            for (Long additionalTableId : additionalTableIds) {
                // Kiểm tra bàn phụ có hợp lệ không
                RestaurantTable additionalTable = tableService.findById(additionalTableId);
                if (additionalTable == null) {
                    continue;
                }

                // Chỉ cho phép thêm bàn AVAILABLE hoặc RESERVED
                if ("SERVING".equals(additionalTable.getStatus()) || 
                    "PENDING_PAYMENT".equals(additionalTable.getStatus()) || 
                    "PAID".equals(additionalTable.getStatus()) ||
                    "CLEANING".equals(additionalTable.getStatus())) {
                    continue;
                }

                // Thêm table ID vào session
                session.addTableId(additionalTableId);
                
                // Cập nhật trạng thái bàn phụ thành SERVING
                additionalTable.setStatus("SERVING");
                tableService.save(additionalTable);

                // KHÔNG tạo Order mới - bàn phụ sẽ chia sẻ các Order của bàn chính
                // Lý do: Khi gọi món, người dùng sẽ chỉ định bàn nào gọi món đó
                // Tất cả bàn trong session sẽ thấy chung danh sách món đã gọi

                addedTables.add("T" + additionalTable.getTableNumber());
            }

            // Lưu session đã cập nhật
            if (!addedTables.isEmpty()) {
                serviceSessionService.save(session);
            }

            if (addedTables.isEmpty()) {
                redirectAttrs.addFlashAttribute("addTableError", "Không có bàn nào được thêm!");
            } else {
                redirectAttrs.addFlashAttribute("addTableSuccess", 
                    "Đã thêm " + addedTables.size() + " bàn thành công: " + String.join(", ", addedTables));
            }
            
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("addTableError", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return "redirect:/employee/table/" + tableId + "/menu";
    }

    // 7. Hoàn thành dọn dẹp bàn
    @RequestMapping(value = "/{tableId}/complete-cleaning", method = RequestMethod.POST)
    public String completeTableCleaning(@PathVariable("tableId") Long tableId, 
                                      RedirectAttributes redirectAttrs) {
        try {
            RestaurantTable table = tableService.findById(tableId);
            if (table == null) {
                redirectAttrs.addFlashAttribute("errorMessage", "Không tìm thấy bàn!");
                return "redirect:/employee/table/list";
            }

            if (!"CLEANING".equals(table.getStatus())) {
                redirectAttrs.addFlashAttribute("errorMessage", "Bàn này không ở trạng thái đang dọn dẹp!");
                return "redirect:/employee/table/list";
            }

            // Chuyển trạng thái từ CLEANING về AVAILABLE
            table.setStatus("AVAILABLE");
            tableService.save(table);

            redirectAttrs.addFlashAttribute("successMessage", 
                "Đã hoàn thành dọn dẹp bàn " + table.getTableNumber() + ". Bàn sẵn sàng phục vụ!");

        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }

        return "redirect:/employee/table/list";
    }
}
