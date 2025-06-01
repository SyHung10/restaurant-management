package com.restaurant.dao;

import com.restaurant.entity.Promotion;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
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
        return session.createQuery("from Promotion order by promotionId desc").list();
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

    @SuppressWarnings("unchecked")
    public List<Promotion> findActivePromotions() {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from Promotion where status = 'ACTIVE' order by promotionId desc").list();
    }

    @SuppressWarnings("unchecked")
    public List<Promotion> findByScopeType(String scopeType) {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from Promotion where scopeType = :scopeType and status = 'ACTIVE'")
                .setParameter("scopeType", scopeType)
                .list();
    }

    @SuppressWarnings("unchecked")
    public List<Promotion> findByScopeTypeAndTargetId(String scopeType, Long targetId) {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from Promotion where scopeType = :scopeType and targetId = :targetId and status = 'ACTIVE'")
                .setParameter("scopeType", scopeType)
                .setParameter("targetId", targetId)
                .list();
    }

    @SuppressWarnings("unchecked")
    public List<Promotion> findApplicablePromotions(BigDecimal orderAmount) {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from Promotion where status = 'ACTIVE' and orderMinimum <= :orderAmount order by orderMinimum desc")
                .setParameter("orderAmount", orderAmount)
                .list();
    }

    @SuppressWarnings("unchecked")
    public List<Promotion> findApplicablePromotions(String scopeType, Long targetId, BigDecimal orderAmount) {
        Session session = sessionFactory.getCurrentSession();
        StringBuilder hql = new StringBuilder("from Promotion where status = 'ACTIVE' and orderMinimum <= :orderAmount");
        
        if ("ALL".equals(scopeType)) {
            hql.append(" and scopeType = 'ALL'");
        } else {
            hql.append(" and ((scopeType = 'ALL') or (scopeType = :scopeType and targetId = :targetId))");
        }
        
        hql.append(" order by orderMinimum desc");
        
        org.hibernate.Query query = session.createQuery(hql.toString())
                .setParameter("orderAmount", orderAmount);
        
        if (!"ALL".equals(scopeType)) {
            query.setParameter("scopeType", scopeType)
                 .setParameter("targetId", targetId);
        }
        
        return query.list();
    }

    public Long countByStatus(String status) {
        Session session = sessionFactory.getCurrentSession();
        return (Long) session.createQuery("select count(*) from Promotion where status = :status")
                .setParameter("status", status)
                .uniqueResult();
    }

    public Long countByScopeType(String scopeType) {
        Session session = sessionFactory.getCurrentSession();
        return (Long) session.createQuery("select count(*) from Promotion where scopeType = :scopeType")
                .setParameter("scopeType", scopeType)
                .uniqueResult();
    }

    public Long countByDiscountType(boolean isPercent) {
        Session session = sessionFactory.getCurrentSession();
        return (Long) session.createQuery("select count(*) from Promotion where isPercent = :isPercent")
                .setParameter("isPercent", isPercent)
                .uniqueResult();
    }

    // Đếm số lượt sử dụng của promotion từ bảng Payment
    public Long countUsageByPromotionId(Long promotionId) {
        Session session = sessionFactory.getCurrentSession();
        return (Long) session.createQuery("select count(*) from Payment where promotionId = :promotionId")
                .setParameter("promotionId", promotionId)
                .uniqueResult();
    }

    // Kiểm tra xem promotion có thể sử dụng được không (chưa vượt max_usage)
    public boolean isPromotionUsable(Long promotionId) {
        Session session = sessionFactory.getCurrentSession();
        
        // Lấy thông tin promotion
        Promotion promotion = (Promotion) session.get(Promotion.class, promotionId);
        if (promotion == null || !"ACTIVE".equals(promotion.getStatus())) {
            return false;
        }
        
        // Nếu không có giới hạn max_usage, luôn có thể dùng
        if (promotion.getMaxUsage() == null) {
            return true;
        }
        
        // Đếm số lượt đã sử dụng
        Long usageCount = countUsageByPromotionId(promotionId);
        
        // Kiểm tra có vượt quá max_usage không
        return usageCount < promotion.getMaxUsage();
    }
}
