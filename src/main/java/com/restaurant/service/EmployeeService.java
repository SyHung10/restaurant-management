package com.restaurant.service; // Đổi từ com.nhahang.service

import com.restaurant.dao.EmployeeDAO; // Đổi từ com.nhahang.dao
import com.restaurant.entity.Employee; // Đổi từ com.nhahang.model
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class EmployeeService {

    @Autowired
    private EmployeeDAO employeeDAO;

    public EmployeeService() {
        // TODO Auto-generated constructor stub
    }

    public void save(Employee employee) {
        employeeDAO.save(employee);
    }

    public void delete(Long id) {
        employeeDAO.delete(id);
    }

    public Employee findById(Long id) {
        return employeeDAO.findById(id);
    }

    public List<Employee> findAll() {
        return employeeDAO.findAll();
    }

    public Employee findByUsernameAndPassword(String username, String password) {
        return employeeDAO.findByUsernameAndPassword(username, password);
    }
}