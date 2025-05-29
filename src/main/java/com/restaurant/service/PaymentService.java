package com.restaurant.service;

import com.restaurant.dao.PaymentDAO;
import com.restaurant.entity.Payment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class PaymentService {
    @Autowired
    private PaymentDAO paymentDAO;

    public void save(Payment payment) {
        paymentDAO.save(payment);
    }

    public void delete(Long id) {
        paymentDAO.delete(id);
    }

    public Payment findById(Long id) {
        return paymentDAO.findById(id);
    }

    public List<Payment> findAll() {
        return paymentDAO.findAll();
    }

    public List<Payment> findBySessionId(Long sessionId) {
        return paymentDAO.findBySessionId(sessionId);
    }

    public List<Payment> findByEmployeeId(Long employeeId) {
        return paymentDAO.findByEmployeeId(employeeId);
    }
}
