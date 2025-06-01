package com.restaurant.dao;

import com.restaurant.entity.Menu;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MenuDAO {

    @Autowired
    private SessionFactory sessionFactory;

    public MenuDAO() {
		// TODO Auto-generated constructor stub
	}

    public void save(Menu menu) {
        Session session = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.saveOrUpdate(menu);
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
            Menu menu = (Menu) session.get(Menu.class, id);
            if (menu != null) {
                session.delete(menu);
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

    public Menu findById(Long id) {
        Session session = sessionFactory.openSession();
        try {
            return (Menu) session.get(Menu.class, id);
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Menu> findAll() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Menu").list();
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Menu> findByStatus(String status) {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Menu where status = :status")
                    .setParameter("status", status)
                    .list();
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Menu> findByCategoryId(Long categoryId) {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Menu where category.categoryId = :categoryId")
                    .setParameter("categoryId", categoryId)
                    .list();
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Menu> findAvailableByCategoryId(Long categoryId) {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Menu where category.categoryId = :categoryId and status = 'AVAILABLE'")
                    .setParameter("categoryId", categoryId)
                    .list();
        } finally {
            session.close();
        }
    }
}