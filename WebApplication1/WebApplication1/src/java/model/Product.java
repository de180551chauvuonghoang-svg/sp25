    package model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Product Model class mapping với bảng Product_YourID
 */
public class Product {
    private String productID;
    private String productName;
    private long price;
    private LocalDate importDate;
    private String category;

    // Constructor mặc định
    public Product() {
    }

    // Constructor đầy đủ
    public Product(String productID, String productName, long price, LocalDate importDate, String category) {
        this.productID = productID;
        this.productName = productName;
        this.price = price;
        this.importDate = importDate;
        this.category = category;
    }

    // Getter và Setter
    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public LocalDate getImportDate() {
        return importDate;
    }

    public void setImportDate(LocalDate importDate) {
        this.importDate = importDate;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    // Utility methods
    public String getFormattedPrice() {
        return String.format("%,d VND", price);
    }

    public String getFormattedImportDate() {
        return importDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    // toString method
    @Override
    public String toString() {
        return "Product{" +
                "productID='" + productID + '\'' +
                ", productName='" + productName + '\'' +
                ", price=" + price +
                ", importDate=" + importDate +
                ", category='" + category + '\'' +
                '}';
    }
}