package model;

import java.sql.Timestamp;

public class CartItem {
    private int id;
    private Product product;
    private int quantity;
    private Timestamp addedDate;
    private Timestamp updatedDate;

    // Default constructor
    public CartItem() {
    }

    // Constructor with product and quantity (for compatibility)
    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    // Full constructor
    public CartItem(int id, Product product, int quantity, Timestamp addedDate, Timestamp updatedDate) {
        this.id = id;
        this.product = product;
        this.quantity = quantity;
        this.addedDate = addedDate;
        this.updatedDate = updatedDate;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(Timestamp addedDate) {
        this.addedDate = addedDate;
    }

    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", product=" + product +
                ", quantity=" + quantity +
                ", addedDate=" + addedDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}