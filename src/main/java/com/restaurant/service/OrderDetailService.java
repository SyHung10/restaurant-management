package com.restaurant.service;

import com.restaurant.dao.OrderDetailDAO;
import com.restaurant.entity.OrderDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class OrderDetailService {
    @Autowired
    private OrderDetailDAO orderDetailDAO;

    public void save(OrderDetail orderDetail) {
        orderDetailDAO.save(orderDetail);
    }

    public void delete(Long id) {
        orderDetailDAO.delete(id);
    }

    public OrderDetail findById(Long id) {
        return orderDetailDAO.findById(id);
    }

    public List<OrderDetail> findAll() {
        return orderDetailDAO.findAll();
    }

    public List<OrderDetail> findByOrderId(Long orderId) {
        return orderDetailDAO.findByOrderId(orderId);
    }

    public List<OrderDetail> findByDishId(Long dishId) {
        return orderDetailDAO.findByDishId(dishId);
    }

    // Cập nhật trạng thái OrderDetail
    public void updateStatus(Long orderDetailId, String status) {
        orderDetailDAO.updateStatus(orderDetailId, status);
    }

    public List<OrderDetail> findByStatus(String status) {
        return orderDetailDAO.findByStatus(status);
    }

    public List<OrderDetail> findByOrderIdAndStatus(Long orderId, String status) {
        return orderDetailDAO.findByOrderIdAndStatus(orderId, status);
    }
}
