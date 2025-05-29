package com.restaurant.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "Promotion")
public class Promotion implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "promotion_id")
    private Long promotionId;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "start_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startTime;

    @Column(name = "end_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endTime;

    @Column(name = "discount_percent", precision = 5, scale = 2)
    private BigDecimal discountPercent;

    @Column(name = "voucher_code", length = 50)
    private String voucherCode;

    @Column(name = "discount_value", precision = 10, scale = 2)
    private BigDecimal discountValue;

    @Column(name = "is_percent", nullable = false)
    private Boolean isPercent = false;

    @Column(name = "max_usage")
    private Integer maxUsage;

    @Column(name = "status", nullable = false, length = 20)
    private String status = "ACTIVE";

    @Column(name = "order_minimum", nullable = false, precision = 10, scale = 2)
    private BigDecimal orderMinimum = BigDecimal.ZERO;

    @Column(name = "scope_type", nullable = false, length = 20)
    private String scopeType = "ALL";

    @Column(name = "target_id")
    private Long targetId;

    // Constructors
    public Promotion() {
    }

    // Getters and Setters
    public Long getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(Long promotionId) {
        this.promotionId = promotionId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public Boolean getIsPercent() {
        return isPercent;
    }

    public void setIsPercent(Boolean isPercent) {
        this.isPercent = isPercent;
    }

    public Integer getMaxUsage() {
        return maxUsage;
    }

    public void setMaxUsage(Integer maxUsage) {
        this.maxUsage = maxUsage;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getOrderMinimum() {
        return orderMinimum;
    }

    public void setOrderMinimum(BigDecimal orderMinimum) {
        this.orderMinimum = orderMinimum;
    }

    public String getScopeType() {
        return scopeType;
    }

    public void setScopeType(String scopeType) {
        this.scopeType = scopeType;
    }

    public Long getTargetId() {
        return targetId;
    }

    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }

    // Utility methods
    public boolean isActive() {
        return "ACTIVE".equals(this.status);
    }

    public boolean isPercentageDiscount() {
        return Boolean.TRUE.equals(this.isPercent);
    }

    public boolean isFixedAmountDiscount() {
        return Boolean.FALSE.equals(this.isPercent);
    }

    public boolean isApplicableToAll() {
        return "ALL".equals(this.scopeType);
    }

    public boolean isApplicableToCategory() {
        return "CATEGORY".equals(this.scopeType);
    }

    public boolean isApplicableToDish() {
        return "DISH".equals(this.scopeType);
    }

    @Override
    public String toString() {
        return "Promotion{" +
                "promotionId=" + promotionId +
                ", name='" + name + '\'' +
                ", status='" + status + '\'' +
                ", scopeType='" + scopeType + '\'' +
                '}';
    }
}
