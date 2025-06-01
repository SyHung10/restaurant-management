package com.restaurant.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import com.restaurant.entity.Employee;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // Chặn cache trình duyệt
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            Employee user = (Employee) session.getAttribute("loggedInUser");
            String role = user.getRole();
            String uri = request.getRequestURI();

            // Manager được vào tất cả
            if ("MANAGER".equalsIgnoreCase(role)) {
                return true;
            }

            // Kitchen chỉ được vào /kitchen/**
            if ("KITCHEN".equalsIgnoreCase(role) && uri.contains("/kitchen")) {
                return true;
            }

            // Counter chỉ được vào /employee/**
            if ("COUNTER".equalsIgnoreCase(role) && uri.contains("/employee")) {
                return true;
            }

            // Nếu không đúng quyền, xóa session và chuyển về login
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        response.sendRedirect(request.getContextPath() + "/login");
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
                          ModelAndView modelAndView) throws Exception {
        // Không cần xử lý gì ở đây
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler,
                               Exception ex) throws Exception {
        // Không cần xử lý gì ở đây
    }
}