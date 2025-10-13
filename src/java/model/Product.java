package model;

public class Product {
    private int id;
    private String name;
    private double price;
    private String description;
    private int stock;
    private String importDate; // Using String for simplicity, matching JSP date input
    private String status; // AVAILABLE, OUT_OF_STOCK

    // Default constructor
    public Product() {
    }

    // Full constructor
    public Product(int id, String name, double price, String description, int stock, String importDate) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.stock = stock;
        this.importDate = importDate;
        this.status = stock > 0 ? "AVAILABLE" : "OUT_OF_STOCK";
    }

    // Full constructor with status
    public Product(int id, String name, double price, String description, int stock, String importDate, String status) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.stock = stock;
        this.importDate = importDate;
        this.status = status;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getStock() { return stock; }
    public void setStock(int stock) { 
        this.stock = stock; 
        // Auto-update status based on stock
        this.status = stock > 0 ? "AVAILABLE" : "OUT_OF_STOCK";
    }

    public String getImportDate() { return importDate; }
    public void setImportDate(String importDate) { this.importDate = importDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Helper methods
    public boolean isAvailable() {
        return "AVAILABLE".equals(status) && stock > 0;
    }

    public boolean isOutOfStock() {
        return "OUT_OF_STOCK".equals(status) || stock == 0;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", description='" + description + '\'' +
                ", stock=" + stock +
                ", importDate='" + importDate + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
