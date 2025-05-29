package com.restaurant.dao;

import com.restaurant.entity.OrderDetail;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class OrderDetailDAO {
    @Autowired
    private SessionFactory sessionFactory;

    public void save(OrderDetail orderDetail) {
        Session s = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = s.beginTransaction();
            s.saveOrUpdate(orderDetail);
            tx.commit();
        } catch (Exception e) {
            if (tx != null)
                tx.rollback();
            e.printStackTrace();
        } finally {
            s.close();
        }
    }

    public void delete(Long id) {
        Session s = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = s.beginTransaction();
            OrderDetail orderDetail = (OrderDetail) s.get(OrderDetail.class, id);
            if (orderDetail != null) {
                s.delete(orderDetail);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null)
                tx.rollback();
            e.printStackTrace();
        } finally {
            s.close();
        }
    }

    public OrderDetail findById(Long id) {
        Session s = sessionFactory.openSession();
        try {
            return (OrderDetail) s.get(OrderDetail.class, id);
        } finally {
            s.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<OrderDetail> findAll() {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from OrderDetail").list();
        } finally {
            s.close();
        }
    }

    // Tìm tất cả OrderDetail theo orderId
    @SuppressWarnings("unchecked")
    public List<OrderDetail> findByOrderId(Long orderId) {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from OrderDetail where orderId = :orderId")
                    .setParameter("orderId", orderId)
                    .list();
        } finally {
            s.close();
        }
    }

    // Tìm tất cả OrderDetail theo dishId
    @SuppressWarnings("unchecked")
    public List<OrderDetail> findByDishId(Long dishId) {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from OrderDetail where dishId = :dishId")
                    .setParameter("dishId", dishId)
                    .list();
        } finally {
            s.close();
        }
    }

    // Tìm tất cả OrderDetail theo status
    @SuppressWarnings("unchecked")
    public List<OrderDetail> findByStatus(String status) {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from OrderDetail where status = :status")
                    .setParameter("status", status)
                    .list();
        } finally {
            s.close();
        }
    }

    // Tìm OrderDetail theo orderId và status
    @SuppressWarnings("unchecked")
    public List<OrderDetail> findByOrderIdAndStatus(Long orderId, String status) {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from OrderDetail where orderId = :orderId and status = :status")
                    .setParameter("orderId", orderId)
                    .setParameter("status", status)
                    .list();
        } finally {
            s.close();
        }
    }

    // Cập nhật trạng thái OrderDetail
    public void updateStatus(Long orderDetailId, String status) {
        Session s = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = s.beginTransaction();
            s.createQuery("update OrderDetail set status = :status where orderDetailId = :orderDetailId")
                    .setParameter("status", status)
                    .setParameter("orderDetailId", orderDetailId)
                    .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null)
                tx.rollback();
            e.printStackTrace();
        } finally {
            s.close();
        }
    }
}
