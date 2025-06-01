package com.restaurant.dao;

import com.restaurant.entity.Payment;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
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

    public BigDecimal getTodayRevenue() {
        Session session = sessionFactory.openSession();
        try {
            // Tính ngày bắt đầu và kết thúc của hôm nay
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            Date startOfDay = cal.getTime();
            
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            Date endOfDay = cal.getTime();
            
            // Query tổng final_amount trong ngày hôm nay
            Object result = session.createQuery(
                "SELECT COALESCE(SUM(p.finalAmount), 0) FROM Payment p " +
                "WHERE p.paymentTime >= :startOfDay AND p.paymentTime <= :endOfDay"
            )
            .setParameter("startOfDay", startOfDay)
            .setParameter("endOfDay", endOfDay)
            .uniqueResult();
            
            if (result != null) {
                return (BigDecimal) result;
            }
            return BigDecimal.ZERO;
        } finally {
            session.close();
        }
    }
}
