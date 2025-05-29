package com.restaurant.controller;

import com.restaurant.entity.Category;
import com.restaurant.entity.Employee;
import com.restaurant.entity.Menu;
import com.restaurant.entity.RestaurantTable;
import com.restaurant.service.CategoryService;
import com.restaurant.service.EmployeeService;
import com.restaurant.service.MenuService;
import com.restaurant.service.TableService;
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
import java.util.List;

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

    // Trang dashboard chính
    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String showDashboard(Model model) {
        model.addAttribute("tables", tableService.findAll());
        model.addAttribute("menus", menuService.findAll());
        model.addAttribute("employees", employeeService.findAll());
        model.addAttribute("categories", categoryService.findAll());
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
    public String listMenus(Model model) {
        model.addAttribute("menus", menuService.findAll());
        return "manager/menu-list";
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
                // Tạo thư mục lưu ảnh nếu chưa tồn tại
                String uploadPath = servletContext.getRealPath("/resources/images/menu");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Nếu đang cập nhật món ăn và có ảnh cũ, xóa ảnh cũ
                if (menu.getDishId() != null && menu.getImageUrl() != null && !menu.getImageUrl().isEmpty()) {
                    String oldImagePath = servletContext.getRealPath(menu.getImageUrl());
                    File oldImageFile = new File(oldImagePath);
                    if (oldImageFile.exists()) {
                        oldImageFile.delete();
                    }
                }

                // Tạo tên file duy nhất
                String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                String filePath = uploadPath + File.separator + fileName;

                // Lưu file vào thư mục
                File dest = new File(filePath);
                imageFile.transferTo(dest);

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
}