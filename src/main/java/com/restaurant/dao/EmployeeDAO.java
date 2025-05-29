package com.restaurant.dao;

import com.restaurant.entity.Employee;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class EmployeeDAO {

    @Autowired
    private SessionFactory sessionFactory;

    public EmployeeDAO() {
        // TODO Auto-generated constructor stub
    }

    public void save(Employee employee) {
        Session session = sessionFactory.openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.saveOrUpdate(employee);
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
            Employee employee = (Employee) session.get(Employee.class, id);
            if (employee != null) {
                session.delete(employee);
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

    public Employee findById(Long id) {
        Session session = sessionFactory.openSession();
        try {
            return (Employee) session.get(Employee.class, id);
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Employee> findAll() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from Employee").list();
        } finally {
            session.close();
        }
    }

    public Employee findByUsernameAndPassword(String username, String password) {
        Session s = sessionFactory.openSession();
        try {
            return (Employee) s.createQuery("from Employee where username = :username and password = :password")
                    .setParameter("username", username)
                    .setParameter("password", password)
                    .uniqueResult();
        } finally {
            s.close();
        }
    }
}