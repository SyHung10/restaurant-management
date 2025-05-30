package com.restaurant.controller;

import com.restaurant.entity.Employee;
import com.restaurant.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;

@Controller
public class LoginController {
    @Autowired
    private EmployeeService employeeService;

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String showLoginForm() {
        return "login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String processLogin(@RequestParam("username") String username,
            @RequestParam("password") String password,
            Model model,
            HttpSession session) {
        Employee employee = employeeService.findByUsernameAndPassword(username, password);
        if (employee != null) {
            session.setAttribute("loggedInUser", employee);
            if ("MANAGER".equalsIgnoreCase(employee.getRole())) {
                return "redirect:/manager/dashboard";
            } else if ("KITCHEN".equalsIgnoreCase(employee.getRole())) {
                // Nếu là nhân viên bếp thì vào trang Kanban (đơn hàng) với filter ngày hôm nay
                String today = LocalDate.now().toString();
                return "redirect:/kitchen/kanban?fromDate=" + today + "&toDate=" + today + "&filterStatus=";
            } else {
                return "redirect:/employee/table/list";
            }
        } else {
            model.addAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            return "login";
        }
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
