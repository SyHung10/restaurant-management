package com.restaurant.service;

import com.restaurant.dao.PromotionDAO;
import com.restaurant.entity.Promotion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class PromotionService {

    @Autowired
    private PromotionDAO promotionDAO;

    public PromotionService() {
        // TODO Auto-generated constructor stub
    }

    public void save(Promotion promotion) {
        promotionDAO.save(promotion);
    }

    public void delete(Long id) {
        promotionDAO.delete(id);
    }

    public Promotion findById(Long id) {
        return promotionDAO.findById(id);
    }

    public List<Promotion> findAll() {
        return promotionDAO.findAll();
    }

    public Promotion findByVoucherCode(String voucherCode) {
        return promotionDAO.findByVoucherCode(voucherCode);
    }

    /**
     * Đếm số lần sử dụng voucher
     */
    public long countUsageByPromotionId(Long promotionId) {
        return promotionDAO.countUsageByPromotionId(promotionId);
    }

    /**
     * Kiểm tra xem voucher có còn sử dụng được hay không
     */
    public boolean isVoucherAvailable(Promotion promotion) {
        if (promotion == null || !"ACTIVE".equals(promotion.getStatus())) {
            return false;
        }
        
        // Chỉ kiểm tra với voucher type
        if (!"VOUCHER".equals(promotion.getType())) {
            return true;
        }
        
        // Kiểm tra max usage
        if (promotion.getMaxUsage() != null && promotion.getMaxUsage() > 0) {
            long currentUsage = countUsageByPromotionId(promotion.getPromotionId());
            return currentUsage < promotion.getMaxUsage();
        }
        
        return true;
    }
}
