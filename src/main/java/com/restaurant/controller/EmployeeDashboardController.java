package com.restaurant.controller;

import com.restaurant.entity.RestaurantTable;
import com.restaurant.service.TableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import javax.servlet.http.HttpSession;
import com.restaurant.entity.Employee;
import com.restaurant.entity.Payment;
import com.restaurant.service.PaymentService;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import java.util.List;

@Controller
@RequestMapping("/employee")
public class EmployeeDashboardController {

    @Autowired
    private TableService tableService;
    @Autowired
    private PaymentService paymentService;

    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String dashboard(HttpSession httpSession,
                             Model model,
                             @RequestParam(value = "fromDate", required = false) String fromDate,
                             @RequestParam(value = "toDate", required = false) String toDate) throws Exception {
        // Table stats
        List<RestaurantTable> tables = tableService.findAll();
        int total = tables.size();
        int serving = 0, pendingPayment = 0, cleaning = 0;
        for (RestaurantTable t : tables) {
            String status = t.getStatus();
            if ("SERVING".equalsIgnoreCase(status)) {
                serving++;
            } else if ("PENDING_PAYMENT".equalsIgnoreCase(status)) {
                pendingPayment++;
            } else if ("CLEANING".equalsIgnoreCase(status)) {
                cleaning++;
            }
        }
        model.addAttribute("totalTables", total);
        model.addAttribute("servingTables", serving);
        model.addAttribute("pendingPaymentTables", pendingPayment);
        model.addAttribute("cleanedTables", cleaning);
        // Default date filter to today if not provided
        SimpleDateFormat sdfFilter = new SimpleDateFormat("yyyy-MM-dd");
        String todayStr = sdfFilter.format(new Date());
        if (fromDate == null || fromDate.isEmpty()) {
            fromDate = todayStr;
        }
        if (toDate == null || toDate.isEmpty()) {
            toDate = todayStr;
        }
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        // Fetch and filter payments of logged-in user
        Employee employee = (Employee) httpSession.getAttribute("loggedInUser");
        Long empId = (employee != null ? employee.getEmployeeId() : null);
        List<Payment> allPayments = paymentService.findByEmployeeId(empId);
        // Parse and normalize dates
        Date fromDateObj = sdfFilter.parse(fromDate);
        Calendar cal = Calendar.getInstance(); cal.setTime(fromDateObj);
        cal.set(Calendar.HOUR_OF_DAY, 0); cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0); cal.set(Calendar.MILLISECOND, 0);
        fromDateObj = cal.getTime();
        Date toDateObj = sdfFilter.parse(toDate);
        cal.setTime(toDateObj);
        cal.set(Calendar.HOUR_OF_DAY, 23); cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59); cal.set(Calendar.MILLISECOND, 999);
        toDateObj = cal.getTime();
        // Filter list
        List<Payment> filtered = new ArrayList<>();
        for (Payment p : allPayments) {
            Date pt = p.getPaymentTime();
            if (!pt.before(fromDateObj) && !pt.after(toDateObj)) {
                filtered.add(p);
            }
        }
        model.addAttribute("payments", filtered);
        return "employee/dashboard";
    }
}