package com.restaurant.dao;

import com.restaurant.entity.Payment;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class PaymentDAO {
    @Autowired
    private SessionFactory sessionFactory;

    public void save(Payment payment) {
        Session session = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.saveOrUpdate(payment);
            tx.commit();
        } catch (Exception e) {
            if (tx != null)
                tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    public void delete(Long id) {
        Session session = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            Payment payment = (Payment) session.get(Payment.class, id);
            if (payment != null) {
                session.delete(payment);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null)
                tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    public Payment findById(Long id) {
        Session session = sessionFactory.openSession();
        try {
            return (Payment) session.get(Payment.class, id);
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Payment> findAll() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Payment").list();
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Payment> findBySessionId(Long sessionId) {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Payment where sessionId = :sessionId")
                    .setParameter("sessionId", sessionId)
                    .list();
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Payment> findByEmployeeId(Long employeeId) {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Payment where employeeId = :employeeId")
                    .setParameter("employeeId", employeeId)
                    .list();
        } finally {
            session.close();
        }
    }
}
