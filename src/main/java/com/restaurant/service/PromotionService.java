package com.restaurant.service;

import com.restaurant.dao.PromotionDAO;
import com.restaurant.entity.Promotion;
import com.restaurant.entity.Menu;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@Transactional
public class PromotionService {

    @Autowired
    private PromotionDAO promotionDAO;
    
    @Autowired
    private MenuService menuService;

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

    public List<Promotion> findActivePromotions() {
        return promotionDAO.findActivePromotions();
    }

    public List<Promotion> findByScopeType(String scopeType) {
        return promotionDAO.findByScopeType(scopeType);
    }

    public List<Promotion> findByScopeTypeAndTargetId(String scopeType, Long targetId) {
        return promotionDAO.findByScopeTypeAndTargetId(scopeType, targetId);
    }

    public List<Promotion> findApplicablePromotions(BigDecimal orderAmount) {
        return promotionDAO.findApplicablePromotions(orderAmount);
    }

    public List<Promotion> findApplicablePromotions(String scopeType, Long targetId, BigDecimal orderAmount) {
        return promotionDAO.findApplicablePromotions(scopeType, targetId, orderAmount);
    }

    public Long countByStatus(String status) {
        return promotionDAO.countByStatus(status);
    }

    public Long countByScopeType(String scopeType) {
        return promotionDAO.countByScopeType(scopeType);
    }

    public Long countByDiscountType(boolean isPercent) {
        return promotionDAO.countByDiscountType(isPercent);
    }

    // Đếm số lượt sử dụng của promotion
    public Long countUsageByPromotionId(Long promotionId) {
        return promotionDAO.countUsageByPromotionId(promotionId);
    }

    // Kiểm tra xem promotion có thể sử dụng được không
    public boolean isPromotionUsable(Long promotionId) {
        return promotionDAO.isPromotionUsable(promotionId);
    }

    /**
     * Tính toán giảm giá cho đơn hàng
     */
    public BigDecimal calculateDiscount(Promotion promotion, BigDecimal orderAmount) {
        if (promotion == null || !promotion.isActive()) {
            return BigDecimal.ZERO;
        }

        // Kiểm tra giá trị đơn hàng tối thiểu
        if (orderAmount.compareTo(promotion.getOrderMinimum()) < 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal discount = BigDecimal.ZERO;
        
        if (promotion.isPercentageDiscount()) {
            // Giảm theo phần trăm
            discount = orderAmount.multiply(promotion.getDiscountPercent())
                    .divide(new BigDecimal("100"));
        } else {
            // Giảm theo giá trị cố định
            discount = promotion.getDiscountValue();
        }

        // Đảm bảo giảm giá không vượt quá giá trị đơn hàng
        return discount.min(orderAmount);
    }

    /**
     * Kiểm tra xem promotion có áp dụng được cho đối tượng không
     */
    public boolean isApplicableFor(Promotion promotion, String scopeType, Long targetId) {
        if (promotion == null || !promotion.isActive()) {
            return false;
        }

        if (promotion.isApplicableToAll()) {
            return true;
        }

        return promotion.getScopeType().equals(scopeType) && 
               promotion.getTargetId().equals(targetId);
    }

    /**
     * Tìm promotion tốt nhất cho đơn hàng
     */
    public Promotion findBestPromotion(String scopeType, Long targetId, BigDecimal orderAmount) {
        List<Promotion> applicablePromotions = findApplicablePromotions(scopeType, targetId, orderAmount);
        
        Promotion bestPromotion = null;
        BigDecimal maxDiscount = BigDecimal.ZERO;
        
        for (Promotion promotion : applicablePromotions) {
            BigDecimal discount = calculateDiscount(promotion, orderAmount);
            if (discount.compareTo(maxDiscount) > 0) {
                maxDiscount = discount;
                bestPromotion = promotion;
            }
        }
        
        return bestPromotion;
    }

    /**
     * Tính toán giảm giá voucher theo scope (ALL/CATEGORY/DISH) dựa trên danh sách OrderDetail
     * @param promotion Voucher promotion
     * @param orderDetails Danh sách chi tiết đơn hàng
     * @return Số tiền được giảm
     */
    public BigDecimal calculateVoucherDiscountByScope(Promotion promotion, List<com.restaurant.entity.OrderDetail> orderDetails) {
        if (promotion == null || !promotion.isActive() || orderDetails == null || orderDetails.isEmpty()) {
            return BigDecimal.ZERO;
        }

        // Tính tổng tiền của cả session (để kiểm tra order_minimum)
        BigDecimal totalSessionAmount = BigDecimal.ZERO;
        for (com.restaurant.entity.OrderDetail detail : orderDetails) {
            // Bỏ qua món tặng và món đã hủy
            if ((detail.getIsGift() != null && detail.getIsGift()) || 
                "CANCELLED".equalsIgnoreCase(detail.getStatus())) {
                continue;
            }
            BigDecimal itemTotal = detail.getPrice().multiply(BigDecimal.valueOf(detail.getQuantity()));
            totalSessionAmount = totalSessionAmount.add(itemTotal);
        }

        // Kiểm tra điều kiện đơn hàng tối thiểu dựa trên TỔNG TIỀN CỦA CẢ SESSION
        if (totalSessionAmount.compareTo(promotion.getOrderMinimum()) < 0) {
            return BigDecimal.ZERO;
        }

        // Tính tổng tiền của các món áp dụng được voucher (để tính discount)
        BigDecimal applicableAmount = BigDecimal.ZERO;
        for (com.restaurant.entity.OrderDetail detail : orderDetails) {
            // Bỏ qua món tặng và món đã hủy
            if ((detail.getIsGift() != null && detail.getIsGift()) || 
                "CANCELLED".equalsIgnoreCase(detail.getStatus())) {
                continue;
            }

            boolean isApplicable = false;
            
            if (promotion.isApplicableToAll()) {
                // Voucher áp dụng cho tất cả món
                isApplicable = true;
            } else if (promotion.isApplicableToCategory()) {
                // Voucher áp dụng cho danh mục cụ thể
                isApplicable = checkCategoryScope(detail.getDishId(), promotion.getTargetId());
            } else if (promotion.isApplicableToDish()) {
                // Voucher áp dụng cho món cụ thể
                isApplicable = detail.getDishId().equals(promotion.getTargetId());
            }

            if (isApplicable) {
                BigDecimal itemTotal = detail.getPrice().multiply(BigDecimal.valueOf(detail.getQuantity()));
                applicableAmount = applicableAmount.add(itemTotal);
            }
        }

        // Nếu không có món nào áp dụng được voucher
        if (applicableAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal discount = BigDecimal.ZERO;
        
        if (promotion.isPercentageDiscount()) {
            // Giảm theo phần trăm - áp dụng trên applicableAmount
            discount = applicableAmount.multiply(promotion.getDiscountPercent())
                    .divide(new BigDecimal("100"));
        } else {
            // Giảm theo giá trị cố định
            discount = promotion.getDiscountValue();
        }

        // Đảm bảo giảm giá không vượt quá giá trị áp dụng được
        return discount.min(applicableAmount);
    }

    /**
     * Helper method để kiểm tra xem món ăn có thuộc category được voucher áp dụng không
     * @param dishId ID món ăn
     * @param targetCategoryId ID danh mục target của voucher
     * @return true nếu món thuộc danh mục
     */
    private boolean checkCategoryScope(Long dishId, Long targetCategoryId) {
        try {
            Menu dish = menuService.findById(dishId);
            return dish != null && dish.getCategory() != null && 
                   dish.getCategory().getCategoryId().equals(targetCategoryId);
        } catch (Exception e) {
            // Nếu có lỗi, return false để tránh crash
            return false;
        }
    }
}
