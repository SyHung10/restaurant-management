package com.restaurant.dao;

import com.restaurant.entity.Order;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class OrderDAO {
    @Autowired
    private SessionFactory sessionFactory;

    public void save(Order order) {
        Session s = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = s.beginTransaction();
            s.saveOrUpdate(order);
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
            Order order = (Order) s.get(Order.class, id);
            if (order != null) {
                s.delete(order);
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

    public Order findById(Long id) {
        Session s = sessionFactory.openSession();
        try {
            return (Order) s.get(Order.class, id);
        } finally {
            s.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Order> findAll() {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from Order").list();
        } finally {
            s.close();
        }
    }

    // Tìm tất cả order theo sessionId
    @SuppressWarnings("unchecked")
    public List<Order> findBySessionId(Long sessionId) {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from Order where sessionId = :sessionId")
                    .setParameter("sessionId", sessionId)
                    .list();
        } finally {
            s.close();
        }
    }

    // Tìm tất cả order theo tableId
    @SuppressWarnings("unchecked")
    public List<Order> findByTableId(Long tableId) {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from Order where tableId = :tableId")
                    .setParameter("tableId", tableId)
                    .list();
        } finally {
            s.close();
        }
    }
}
