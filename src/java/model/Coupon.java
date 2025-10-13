package model;

import java.sql.Timestamp;

public class Coupon {
    private int id;
    private String code;
    private String name;
    private String description;
    private String discountType; // "percentage" hoặc "fixed_amount"
    private double discountValue;
    private Double minOrderAmount;
    private Double maxDiscountAmount;
    private Timestamp startDate;
    private Timestamp endDate;
    private Integer usageLimit;
    private int usageCount;
    private boolean isActive;
    private int createdBy;
    private Timestamp createdDate;
    private Timestamp updatedDate;

    // Default constructor
    public Coupon() {
    }

    // Constructor với các thông tin cơ bản
    public Coupon(String code, String name, String discountType, double discountValue) {
        this.code = code;
        this.name = name;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.isActive = true;
        this.usageCount = 0;
    }

    // Full constructor
    public Coupon(int id, String code, String name, String description, String discountType, 
                  double discountValue, Double minOrderAmount, Double maxDiscountAmount,
                  Timestamp startDate, Timestamp endDate, Integer usageLimit, int usageCount,
                  boolean isActive, int createdBy, Timestamp createdDate, Timestamp updatedDate) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderAmount = minOrderAmount;
        this.maxDiscountAmount = maxDiscountAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageLimit = usageLimit;
        this.usageCount = usageCount;
        this.isActive = isActive;
        this.createdBy = createdBy;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public Double getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(Double minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public Double getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(Double maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public Integer getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(Integer usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getUsageCount() {
        return usageCount;
    }

    public void setUsageCount(int usageCount) {
        this.usageCount = usageCount;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    // Utility methods
    public boolean isPercentageDiscount() {
        return "percentage".equals(discountType);
    }

    public boolean isFixedAmountDiscount() {
        return "fixed_amount".equals(discountType);
    }

    public boolean isExpired() {
        return endDate != null && System.currentTimeMillis() > endDate.getTime();
    }

    public boolean isNotStarted() {
        return startDate != null && System.currentTimeMillis() < startDate.getTime();
    }

    public boolean isUsageLimitReached() {
        return usageLimit != null && usageCount >= usageLimit;
    }

    public boolean isValid() {
        return isActive && !isExpired() && !isNotStarted() && !isUsageLimitReached();
    }

    public int getRemainingUses() {
        if (usageLimit == null) {
            return -1; // Unlimited
        }
        return Math.max(0, usageLimit - usageCount);
    }

    /**
     * Tính toán số tiền giảm giá cho đơn hàng
     * @param orderAmount Tổng tiền đơn hàng
     * @return Số tiền được giảm
     */
    public double calculateDiscountAmount(double orderAmount) {
        if (!isValid()) {
            return 0;
        }

        if (minOrderAmount != null && orderAmount < minOrderAmount) {
            return 0;
        }

        double discountAmount = 0;

        if (isPercentageDiscount()) {
            discountAmount = orderAmount * discountValue / 100;
            // Áp dụng giới hạn giảm giá tối đa nếu có
            if (maxDiscountAmount != null && discountAmount > maxDiscountAmount) {
                discountAmount = maxDiscountAmount;
            }
        } else if (isFixedAmountDiscount()) {
            discountAmount = discountValue;
            // Không được giảm quá số tiền đơn hàng
            if (discountAmount > orderAmount) {
                discountAmount = orderAmount;
            }
        }

        return discountAmount;
    }

    @Override
    public String toString() {
        return "Coupon{" +
                "id=" + id +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", discountType='" + discountType + '\'' +
                ", discountValue=" + discountValue +
                ", minOrderAmount=" + minOrderAmount +
                ", maxDiscountAmount=" + maxDiscountAmount +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", usageLimit=" + usageLimit +
                ", usageCount=" + usageCount +
                ", isActive=" + isActive +
                '}';
    }
}