package com.restaurant.dao;

import com.restaurant.entity.ServiceSession;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ServiceSessionDAO {
    @Autowired
    private SessionFactory sessionFactory;

    public void save(ServiceSession session) {
        Session s = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = s.beginTransaction();
            s.saveOrUpdate(session);
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
            ServiceSession session = (ServiceSession) s.get(ServiceSession.class, id);
            if (session != null) {
                s.delete(session);
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

    public ServiceSession findById(Long id) {
        Session s = sessionFactory.openSession();
        try {
            return (ServiceSession) s.get(ServiceSession.class, id);
        } finally {
            s.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<ServiceSession> findAll() {
        Session s = sessionFactory.openSession();
        try {
            return s.createQuery("from ServiceSession").list();
        } finally {
            s.close();
        }
    }

    // Tìm session đang ACTIVE cho 1 bàn
    public ServiceSession findActiveByTableId(Long tableId) {
        Session s = sessionFactory.openSession();
        try {
            // Sử dụng LIKE để tìm trong chuỗi table_id
            // Format: "1,3,5" -> tìm ",3," hoặc "3," hoặc ",3" hoặc "3"
            String pattern = "%," + tableId + ",%";
            String startPattern = tableId + ",%";
            String endPattern = "%," + tableId;
            String exactPattern = tableId.toString();
            
            return (ServiceSession) s.createQuery("from ServiceSession where status = 'ACTIVE' AND " +
                    "(tableId LIKE :pattern OR tableId LIKE :startPattern OR tableId LIKE :endPattern OR tableId = :exactPattern)")
                    .setParameter("pattern", pattern)
                    .setParameter("startPattern", startPattern)
                    .setParameter("endPattern", endPattern)
                    .setParameter("exactPattern", exactPattern)
                    .uniqueResult();
        } finally {
            s.close();
        }
    }

    // Tìm tất cả session theo tableId
    @SuppressWarnings("unchecked")
    public List<ServiceSession> findByTableId(Long tableId) {
        Session s = sessionFactory.openSession();
        try {
            // Sử dụng LIKE để tìm trong chuỗi table_id
            String pattern = "%," + tableId + ",%";
            String startPattern = tableId + ",%";
            String endPattern = "%," + tableId;
            String exactPattern = tableId.toString();
            
            return s.createQuery("from ServiceSession where " +
                    "(tableId LIKE :pattern OR tableId LIKE :startPattern OR tableId LIKE :endPattern OR tableId = :exactPattern)")
                    .setParameter("pattern", pattern)
                    .setParameter("startPattern", startPattern)
                    .setParameter("endPattern", endPattern)
                    .setParameter("exactPattern", exactPattern)
                    .list();
        } finally {
            s.close();
        }
    }
}
