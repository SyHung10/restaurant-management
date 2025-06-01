package com.restaurant.controller;

import com.restaurant.entity.Category;
import com.restaurant.entity.Employee;
import com.restaurant.entity.Menu;
import com.restaurant.entity.RestaurantTable;
import com.restaurant.entity.Order;
import com.restaurant.entity.OrderDetail;
import com.restaurant.service.CategoryService;
import com.restaurant.service.EmployeeService;
import com.restaurant.service.MenuService;
import com.restaurant.service.TableService;
import com.restaurant.service.OrderService;
import com.restaurant.service.OrderDetailService;
import com.restaurant.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager")
public class ManagerDashboardController {

    @Autowired
    private TableService tableService;

    @Autowired
    private MenuService menuService;

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private ServletContext servletContext;

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderDetailService orderDetailService;

    @Autowired
    private PaymentService paymentService;

    // Trang dashboard chính
    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String showDashboard(Model model) {
        model.addAttribute("tables", tableService.findAll());
        model.addAttribute("menus", menuService.findAll());
        model.addAttribute("employees", employeeService.findAll());
        model.addAttribute("categories", categoryService.findAll());
        
        // Lấy doanh thu thực tế từ bảng payment
        BigDecimal todayRevenue = paymentService.getTodayRevenue();
        model.addAttribute("todayRevenue", todayRevenue);
        
        return "manager/dashboard";
    }

    // === Quản lý bàn ===
    @RequestMapping(value = "/tables", method = RequestMethod.GET)
    public String listTables(Model model) {
        model.addAttribute("tables", tableService.findAll());
        return "manager/table-list";
    }

    @RequestMapping(value = "/tables/new", method = RequestMethod.GET)
    public String newTableForm(Model model) {
        model.addAttribute("table", new RestaurantTable()); // Sửa từ Table thành RestaurantTable
        return "manager/table-form";
    }

    @RequestMapping(value = "/tables/save", method = RequestMethod.POST)
    public String saveTable(@ModelAttribute("table") RestaurantTable table) { // Sửa từ Table thành RestaurantTable
        tableService.save(table);
        return "redirect:/manager/tables";
    }

    @RequestMapping(value = "/tables/edit/{id}", method = RequestMethod.GET)
    public String editTableForm(@PathVariable("id") Long id, Model model) {
        RestaurantTable table = tableService.findById(id); // Sửa từ Table thành RestaurantTable
        model.addAttribute("table", table);
        return "manager/table-form";
    }

    @RequestMapping(value = "/tables/delete/{id}", method = RequestMethod.GET)
    public String deleteTable(@PathVariable("id") Long id) {
        tableService.delete(id);
        return "redirect:/manager/tables";
    }

    // === Quản lý món ăn ===
    @RequestMapping(value = "/menus", method = RequestMethod.GET)
    public String listMenus(
            @RequestParam(value = "fromDate", required = false) String fromDateStr,
            @RequestParam(value = "toDate", required = false) String toDateStr,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "status", required = false) String status,
            Model model) throws Exception {
        
        // Parse ngày tương tự như kitchen controller
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

        // Lấy đơn hàng theo khoảng thời gian (clone logic từ kitchen)
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

        // Tính báo cáo doanh thu (clone logic từ kitchen)
        Map<Long, BigDecimal> revenueMap = new HashMap<>();
        Map<Long, Integer> orderCountMap = new HashMap<>();
        Map<Long, Integer> cancelCountMap = new HashMap<>();
        BigDecimal totalRevenue = BigDecimal.ZERO;

        for (Order order : filteredOrders) {
            List<OrderDetail> details = orderDetailService.findByOrderId(order.getOrderId());
            for (OrderDetail od : details) {
                Long dishId = od.getDishId();
                Menu menu = menuService.findById(dishId);
                BigDecimal price = BigDecimal.valueOf(menu.getPrice());
                int qty = od.getQuantity();

                // Doanh thu chỉ tính món không bị hủy
                BigDecimal rev = revenueMap.getOrDefault(dishId, BigDecimal.ZERO);
                if (!"CANCELLED".equals(od.getStatus())) {
                    BigDecimal itemRevenue = price.multiply(BigDecimal.valueOf(qty));
                    rev = rev.add(itemRevenue);
                    totalRevenue = totalRevenue.add(itemRevenue);
                }
                revenueMap.put(dishId, rev);

                // Đếm số lượng
                orderCountMap.put(dishId, orderCountMap.getOrDefault(dishId, 0) + qty);
                if ("CANCELLED".equals(od.getStatus())) {
                    cancelCountMap.put(dishId, cancelCountMap.getOrDefault(dishId, 0) + qty);
                }
            }
        }

        // Lấy danh sách món ăn và filter
        List<Menu> menus = menuService.findAll();
        List<Menu> filteredMenus = new ArrayList<>();
        
        for (Menu menu : menus) {
            boolean categoryMatch = categoryId == null || menu.getCategory().getCategoryId().equals(categoryId);
            boolean statusMatch = status == null || status.isEmpty() || menu.getStatus().equals(status);
            
            if (categoryMatch && statusMatch) {
                filteredMenus.add(menu);
            }
        }

        // Thêm dữ liệu vào model
        model.addAttribute("menus", filteredMenus);
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("revenueMap", revenueMap);
        model.addAttribute("orderCountMap", orderCountMap);
        model.addAttribute("cancelCountMap", cancelCountMap);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("fromDate", fromDateStr);
        model.addAttribute("toDate", toDateStr);
        
        return "manager/menu-management";
    }

    @RequestMapping(value = "/menus/new", method = RequestMethod.GET)
    public String newMenuForm(Model model) {
        model.addAttribute("menu", new Menu());
        model.addAttribute("categories", categoryService.findAllActive());
        return "manager/menu-form";
    }

    @RequestMapping(value = "/menus/save", method = RequestMethod.POST)
    public String saveMenu(@ModelAttribute("menu") Menu menu,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            Model model) {
        // Xử lý upload ảnh nếu có
        if (imageFile != null && !imageFile.isEmpty()) {
            // Kiểm tra định dạng file
            String originalFilename = imageFile.getOriginalFilename();
            String fileExtension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
            if (!fileExtension.equals(".jpg") && !fileExtension.equals(".jpeg") &&
                    !fileExtension.equals(".png") && !fileExtension.equals(".gif")) {
                model.addAttribute("errorMessage", "Chỉ chấp nhận file ảnh .jpg, .jpeg, .png, .gif");
                model.addAttribute("menu", menu);
                model.addAttribute("categories", categoryService.findAllActive());
                return "manager/menu-form";
            }

            try {
                // Lưu vào source directory (để persistent và chia sẻ với team)
                String projectPath = System.getProperty("user.dir");
                String sourceUploadPath = projectPath + "/src/main/webapp/resources/images/menu";
                File sourceUploadDir = new File(sourceUploadPath);
                if (!sourceUploadDir.exists()) {
                    sourceUploadDir.mkdirs();
                }

                // Lưu vào runtime directory (để server có thể serve ngay)
                String runtimeUploadPath = servletContext.getRealPath("/resources/images/menu");
                File runtimeUploadDir = new File(runtimeUploadPath);
                if (!runtimeUploadDir.exists()) {
                    runtimeUploadDir.mkdirs();
                }

                // Nếu đang cập nhật món ăn và có ảnh cũ, xóa ảnh cũ ở cả 2 nơi
                if (menu.getDishId() != null && menu.getImageUrl() != null && !menu.getImageUrl().isEmpty()) {
                    String oldFileName = menu.getImageUrl().substring(menu.getImageUrl().lastIndexOf("/") + 1);
                    
                    // Xóa ảnh cũ ở source
                    File oldSourceFile = new File(sourceUploadPath + File.separator + oldFileName);
                    if (oldSourceFile.exists()) {
                        oldSourceFile.delete();
                    }
                    
                    // Xóa ảnh cũ ở runtime
                    String oldRuntimePath = servletContext.getRealPath(menu.getImageUrl());
                    File oldRuntimeFile = new File(oldRuntimePath);
                    if (oldRuntimeFile.exists()) {
                        oldRuntimeFile.delete();
                    }
                }

                // Tạo tên file duy nhất
                String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();

                // Lưu file vào source directory
                File sourceDestFile = new File(sourceUploadPath + File.separator + fileName);
                imageFile.transferTo(sourceDestFile);

                // Copy file từ source sang runtime directory
                File runtimeDestFile = new File(runtimeUploadPath + File.separator + fileName);
                java.nio.file.Files.copy(sourceDestFile.toPath(), runtimeDestFile.toPath(), 
                    java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                // Cập nhật đường dẫn ảnh vào đối tượng menu
                menu.setImageUrl("/resources/images/menu/" + fileName);
            } catch (IOException e) {
                e.printStackTrace();
                model.addAttribute("errorMessage", "Có lỗi xảy ra khi tải lên ảnh: " + e.getMessage());
                model.addAttribute("menu", menu);
                model.addAttribute("categories", categoryService.findAllActive());
                return "manager/menu-form";
            }
        }

        menuService.save(menu);
        return "redirect:/manager/menus";
    }

    @RequestMapping(value = "/menus/edit/{id}", method = RequestMethod.GET)
    public String editMenuForm(@PathVariable("id") Long id, Model model) {
        Menu menu = menuService.findById(id);
        model.addAttribute("menu", menu);
        model.addAttribute("categories", categoryService.findAllActive());
        return "manager/menu-form";
    }

    @RequestMapping(value = "/menus/delete/{id}", method = RequestMethod.GET)
    public String deleteMenu(@PathVariable("id") Long id) {
        // Lấy thông tin menu trước khi xóa để biết đường dẫn ảnh
        Menu menu = menuService.findById(id);
        if (menu != null && menu.getImageUrl() != null && !menu.getImageUrl().isEmpty()) {
            // Xóa file ảnh
            String imagePath = servletContext.getRealPath(menu.getImageUrl());
            File imageFile = new File(imagePath);
            if (imageFile.exists()) {
                imageFile.delete();
            }
        }

        // Xóa menu từ cơ sở dữ liệu
        menuService.delete(id);
        return "redirect:/manager/menus";
    }

    // Chuyển đổi trạng thái món ăn
    @RequestMapping(value = "/menus/toggle-status/{id}", method = RequestMethod.GET)
    public String toggleMenuStatus(@PathVariable("id") Long id) {
        Menu menu = menuService.findById(id);
        if (menu != null) {
            // Đảo ngược trạng thái hiện tại
            if ("AVAILABLE".equals(menu.getStatus())) {
                menu.setStatus("UNAVAILABLE");
            } else {
                menu.setStatus("AVAILABLE");
            }
            menuService.save(menu);
        }
        return "redirect:/manager/menus";
    }

    // === Quản lý nhân viên ===
    @RequestMapping(value = "/employees", method = RequestMethod.GET)
    public String listEmployees(Model model) {
        model.addAttribute("employees", employeeService.findAll());
        return "manager/employee-list";
    }

    @RequestMapping(value = "/employees/new", method = RequestMethod.GET)
    public String newEmployeeForm(Model model) {
        model.addAttribute("employee", new Employee());
        return "manager/employee-form";
    }

    @RequestMapping(value = "/employees/save", method = RequestMethod.POST)
    public String saveEmployee(@ModelAttribute("employee") Employee employee) {
        employeeService.save(employee);
        return "redirect:/manager/employees";
    }

    @RequestMapping(value = "/employees/edit/{id}", method = RequestMethod.GET)
    public String editEmployeeForm(@PathVariable("id") Long id, Model model) {
        Employee employee = employeeService.findById(id);
        model.addAttribute("employee", employee);
        return "manager/employee-form";
    }

    @RequestMapping(value = "/employees/delete/{id}", method = RequestMethod.GET)
    public String deleteEmployee(@PathVariable("id") Long id) {
        employeeService.delete(id);
        return "redirect:/manager/employees";
    }

    // === Quản lý danh mục ===
    @RequestMapping(value = "/categories", method = RequestMethod.GET)
    public String listCategories(Model model) {
        model.addAttribute("categories", categoryService.findAll());
        return "manager/category-list";
    }

    @RequestMapping(value = "/categories/new", method = RequestMethod.GET)
    public String newCategoryForm(Model model) {
        model.addAttribute("category", new Category());
        return "manager/category-form";
    }

    @RequestMapping(value = "/categories/save", method = RequestMethod.POST)
    public String saveCategory(@ModelAttribute("category") Category category) {
        categoryService.save(category);
        return "redirect:/manager/categories";
    }

    @RequestMapping(value = "/categories/edit/{id}", method = RequestMethod.GET)
    public String editCategoryForm(@PathVariable("id") Long id, Model model) {
        Category category = categoryService.findById(id);
        model.addAttribute("category", category);
        return "manager/category-form";
    }

    @RequestMapping(value = "/categories/delete/{id}", method = RequestMethod.GET)
    public String deleteCategory(@PathVariable("id") Long id) {
        // Kiểm tra nếu có menu sử dụng danh mục này
        List<Menu> menus = menuService.findByCategoryId(id);
        if (menus != null && !menus.isEmpty()) {
            // Nếu có menu sử dụng danh mục, không cho phép xóa
            return "redirect:/manager/categories?error=Không thể xóa danh mục đang được sử dụng bởi " + menus.size()
                    + " món ăn";
        }

        categoryService.delete(id);
        return "redirect:/manager/categories";
    }

    // Thêm method để change status từ manager
    @RequestMapping(value = "/menu/{id}/change-status", method = RequestMethod.POST)
    public String changeMenuStatusFromManager(@PathVariable("id") Long menuId,
            @RequestParam("newStatus") String newStatus,
            @RequestParam(value = "fromDate", required = false) String fromDateStr,
            @RequestParam(value = "toDate", required = false) String toDateStr,
            @RequestParam(value = "categoryId", required = false) String categoryIdStr,
            @RequestParam(value = "status", required = false) String statusFilter) {
        
        Menu menu = menuService.findById(menuId);
        if (menu != null) {
            menu.setStatus("AVAILABLE".equals(newStatus) ? "AVAILABLE" : "UNAVAILABLE");
            menuService.save(menu);
        }
        
        // Redirect với tất cả parameters để giữ filter
        String redirectUrl = "/manager/menus";
        List<String> params = new ArrayList<>();
        
        if (fromDateStr != null && !fromDateStr.isEmpty()) {
            params.add("fromDate=" + fromDateStr);
        }
        if (toDateStr != null && !toDateStr.isEmpty()) {
            params.add("toDate=" + toDateStr);
        }
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            params.add("categoryId=" + categoryIdStr);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            params.add("status=" + statusFilter);
        }
        
        if (!params.isEmpty()) {
            redirectUrl += "?" + String.join("&", params);
        }
        
        return "redirect:" + redirectUrl;
    }
}