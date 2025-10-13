package model;

import java.sql.Timestamp;

public class CouponUsage {
    private int id;
    private int couponId;
    private int userId;
    private int orderId;
    private double discountAmount;
    private Timestamp usedDate;
    
    // Thông tin bổ sung từ join với các bảng khác
    private Coupon coupon;
    private User user;

    // Default constructor
    public CouponUsage() {
    }

    // Constructor với các thông tin cơ bản
    public CouponUsage(int couponId, int userId, int orderId, double discountAmount) {
        this.couponId = couponId;
        this.userId = userId;
        this.orderId = orderId;
        this.discountAmount = discountAmount;
    }

    // Full constructor
    public CouponUsage(int id, int couponId, int userId, int orderId, double discountAmount, Timestamp usedDate) {
        this.id = id;
        this.couponId = couponId;
        this.userId = userId;
        this.orderId = orderId;
        this.discountAmount = discountAmount;
        this.usedDate = usedDate;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCouponId() {
        return couponId;
    }

    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Timestamp getUsedDate() {
        return usedDate;
    }

    public void setUsedDate(Timestamp usedDate) {
        this.usedDate = usedDate;
    }

    public Coupon getCoupon() {
        return coupon;
    }

    public void setCoupon(Coupon coupon) {
        this.coupon = coupon;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "CouponUsage{" +
                "id=" + id +
                ", couponId=" + couponId +
                ", userId=" + userId +
                ", orderId=" + orderId +
                ", discountAmount=" + discountAmount +
                ", usedDate=" + usedDate +
                '}';
    }
}