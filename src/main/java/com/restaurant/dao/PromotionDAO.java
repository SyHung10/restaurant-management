package com.restaurant.dao;

import com.restaurant.entity.Promotion;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class PromotionDAO {

    @Autowired
    private SessionFactory sessionFactory;

    public PromotionDAO() {
        // TODO Auto-generated constructor stub
    }

    public void save(Promotion promotion) {
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(promotion);
    }

    public void delete(Long id) {
        Session session = sessionFactory.getCurrentSession();
        Promotion promotion = (Promotion) session.get(Promotion.class, id);
        if (promotion != null) {
            session.delete(promotion);
        }
    }

    public Promotion findById(Long id) {
        Session session = sessionFactory.getCurrentSession();
        return (Promotion) session.get(Promotion.class, id);
    }

    @SuppressWarnings("unchecked")
    public List<Promotion> findAll() {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from Promotion").list();
    }

    public Promotion findByVoucherCode(String voucherCode) {
        Session session = sessionFactory.openSession();
        try {
            return (Promotion) session
                    .createQuery("from Promotion where voucherCode = :voucherCode and status = 'ACTIVE'")
                    .setParameter("voucherCode", voucherCode)
                    .uniqueResult();
        } finally {
            session.close();
        }
    }

    /**
     * Đếm số lần sử dụng voucher từ bảng Payment
     */
    public long countUsageByPromotionId(Long promotionId) {
        Session session = sessionFactory.openSession();
        try {
            Number count = (Number) session
                    .createQuery("select count(*) from Payment where promotionId = :promotionId")
                    .setParameter("promotionId", promotionId)
                    .uniqueResult();
            return count != null ? count.longValue() : 0L;
        } finally {
            session.close();
        }
    }
}
