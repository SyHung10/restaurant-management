package com.restaurant.dao;

import com.restaurant.entity.RestaurantTable; // Sử dụng RestaurantTable
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class TableDAO {

    @Autowired
    private SessionFactory sessionFactory;
    public TableDAO() {
		// TODO Auto-generated constructor stub
	}
    public void save(RestaurantTable table) {
        Session session = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.saveOrUpdate(table);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
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
            RestaurantTable table = (RestaurantTable) session.get(RestaurantTable.class, id);
            if (table != null) {
                session.delete(table);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    public RestaurantTable findById(Long id) {
        Session session = sessionFactory.openSession();
        try {
            return (RestaurantTable) session.get(RestaurantTable.class, id);
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<RestaurantTable> findAll() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from RestaurantTable").list(); // Sử dụng RestaurantTable
        } finally {
            session.close();
        }
    }
}