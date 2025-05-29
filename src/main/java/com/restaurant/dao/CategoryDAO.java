package com.restaurant.dao;

import com.restaurant.entity.Category;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CategoryDAO {

    @Autowired
    private SessionFactory sessionFactory;

    public CategoryDAO() {
        // TODO Auto-generated constructor stub
    }

    public void save(Category category) {
        Session session = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.saveOrUpdate(category);
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
            Category category = (Category) session.get(Category.class, id);
            if (category != null) {
                session.delete(category);
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

    public Category findById(Long id) {
        Session session = sessionFactory.openSession();
        try {
            return (Category) session.get(Category.class, id);
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Category> findAll() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Category order by displayOrder").list();
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Category> findAllActive() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Category where status = 'ACTIVE' order by displayOrder").list();
        } finally {
            session.close();
        }
    }

    public Category findByCode(String code) {
        Session session = sessionFactory.openSession();
        try {
            return (Category) session.createQuery("from Category where code = :code")
                    .setParameter("code", code)
                    .uniqueResult();
        } finally {
            session.close();
        }
    }
}