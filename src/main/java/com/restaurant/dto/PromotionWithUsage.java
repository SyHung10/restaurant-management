package com.restaurant.dto;

import com.restaurant.entity.Promotion;

/**
 * DTO để chứa thông tin promotion kèm theo số lần sử dụng
 */
public class PromotionWithUsage {
    private Promotion promotion;
    private long usageCount;
    private boolean available;

    public PromotionWithUsage() {
    }

    public PromotionWithUsage(Promotion promotion, long usageCount) {
        this.promotion = promotion;
        this.usageCount = usageCount;
        this.available = calculateAvailable();
    }

    /**
     * Tính toán xem voucher có còn available hay không
     */
    private boolean calculateAvailable() {
        if (promotion == null || !"ACTIVE".equals(promotion.getStatus())) {
            return false;
        }
        
        // Chỉ kiểm tra với voucher type
        if (!"VOUCHER".equals(promotion.getType())) {
            return true;
        }
        
        // Kiểm tra max usage
        if (promotion.getMaxUsage() != null && promotion.getMaxUsage() > 0) {
            return usageCount < promotion.getMaxUsage();
        }
        
        return true;
    }

    // Getters and Setters
    public Promotion getPromotion() {
        return promotion;
    }

    public void setPromotion(Promotion promotion) {
        this.promotion = promotion;
        this.available = calculateAvailable();
    }

    public long getUsageCount() {
        return usageCount;
    }

    public void setUsageCount(long usageCount) {
        this.usageCount = usageCount;
        this.available = calculateAvailable();
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    /**
     * Tính phần trăm sử dụng (nếu có max usage)
     */
    public double getUsagePercentage() {
        if (promotion != null && promotion.getMaxUsage() != null && promotion.getMaxUsage() > 0) {
            return ((double) usageCount / promotion.getMaxUsage()) * 100;
        }
        return 0;
    }

    /**
     * Số lượt còn lại có thể sử dụng
     */
    public long getRemainingUsage() {
        if (promotion != null && promotion.getMaxUsage() != null && promotion.getMaxUsage() > 0) {
            return Math.max(0, promotion.getMaxUsage() - usageCount);
        }
        return -1; // Unlimited
    }
} 