package com.restaurant.service;

import com.restaurant.dao.OrderDAO;
import com.restaurant.entity.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class OrderService {
    @Autowired
    private OrderDAO orderDAO;

    public void save(Order order) {
        orderDAO.save(order);
    }

    public void delete(Long id) {
        orderDAO.delete(id);
    }

    public Order findById(Long id) {
        return orderDAO.findById(id);
    }

    public List<Order> findAll() {
        return orderDAO.findAll();
    }

    public List<Order> findBySessionId(Long sessionId) {
        return orderDAO.findBySessionId(sessionId);
    }

    public List<Order> findByTableId(Long tableId) {
        return orderDAO.findByTableId(tableId);
    }
}
