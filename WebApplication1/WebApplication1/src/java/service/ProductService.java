package service;

import model.Product;
import model.User;
import productDao.IProductDAO;
import productDao.ProductDAO;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Logger;

/**
 * Implementation của IProductService - Business Logic cho Product
 */
public class ProductService implements IProductService {
    
    private static final Logger logger = Logger.getLogger(ProductService.class.getName());
    private final IProductDAO productDAO;
    
    public ProductService() {
        this.productDAO = new ProductDAO();
    }
    
    // Constructor cho testing (dependency injection)
    public ProductService(IProductDAO productDAO) {
        this.productDAO = productDAO;
    }

    @Override
    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }

    @Override
    public List<Product> getProductsForAdmin(User currentUser) {
        if (currentUser == null || !currentUser.isAdmin()) {
            logger.warning("Non-admin user attempted to access admin product view: " + 
                         (currentUser != null ? currentUser.getUserName() : "null"));
            return null;
        }
        
        // Admin: hiển thị products sắp xếp theo Category
        return productDAO.getAllProductsSortedByCategory();
    }

    @Override
    public List<Product> getProductsForUser(User currentUser) {
        if (currentUser == null) {
            logger.warning("Null user attempted to access user product view");
            return null;
        }
        
        if (currentUser.isAdmin()) {
            logger.warning("Admin user attempted to access user product view: " + currentUser.getUserName());
            return null;
        }
        
        // User thường: hiển thị products sắp xếp theo ImportDate
        return productDAO.getProductsSortedByImportDate(false); // Mới nhất trước
    }

    @Override
    public List<Product> getProductsSortedByCategory(User currentUser) {
        if (currentUser == null || !currentUser.isAdmin()) {
            logger.warning("Non-admin user attempted to access category sorted products: " + 
                         (currentUser != null ? currentUser.getUserName() : "null"));
            return null;
        }
        
        return productDAO.getAllProductsSortedByCategory();
    }

    @Override
    public List<Product> searchProductsByMinPrice(Long minPrice, User currentUser) {
        if (currentUser == null) {
            logger.warning("Null user attempted to search products by min price");
            return null;
        }
        
        // Set default value if null
        long min = (minPrice != null) ? minPrice : 0;
        
        // Validate range
        if (min < 0) {
            logger.warning("Invalid min price: " + min);
            return null;
        }
        
        return productDAO.searchProductsByMinPrice(min);
    }

    @Override
    public Product getProductByID(String productID) {
        if (productID == null || productID.trim().isEmpty()) {
            logger.warning("Attempted to get product with null or empty ID");
            return null;
        }
        
        return productDAO.getProductByID(productID.trim());
    }

    @Override
    public boolean addProduct(Product product, User currentUser) {
        // Chỉ admin mới được thêm product
        if (currentUser == null || !currentUser.isAdmin()) {
            logger.warning("Non-admin user attempted to add product: " + 
                         (currentUser != null ? currentUser.getUserName() : "null"));
            return false;
        }
        
        // Validate product data
        String validationError = validateProduct(product);
        if (validationError != null) {
            logger.warning("Product validation failed: " + validationError);
            return false;
        }
        
        // Kiểm tra ProductID đã tồn tại chưa
        if (productDAO.getProductByID(product.getProductID()) != null) {
            logger.warning("Attempted to add product with existing ID: " + product.getProductID());
            return false;
        }
        
        return productDAO.addProduct(product);
    }

    @Override
    public boolean updateProduct(Product product, User currentUser) {
        // Chỉ admin mới được cập nhật product
        if (currentUser == null || !currentUser.isAdmin()) {
            logger.warning("Non-admin user attempted to update product: " + 
                         (currentUser != null ? currentUser.getUserName() : "null"));
            return false;
        }
        
        // Validate product data
        String validationError = validateProduct(product);
        if (validationError != null) {
            logger.warning("Product validation failed: " + validationError);
            return false;
        }
        
        return productDAO.updateProduct(product);
    }

    @Override
    public boolean deleteProduct(String productID, User currentUser) {
        // Chỉ admin mới được xóa product
        if (currentUser == null || !currentUser.isAdmin()) {
            logger.warning("Non-admin user attempted to delete product: " + 
                         (currentUser != null ? currentUser.getUserName() : "null"));
            return false;
        }
        
        if (productID == null || productID.trim().isEmpty()) {
            logger.warning("Attempted to delete product with null or empty ID");
            return false;
        }
        
        return productDAO.deleteProduct(productID.trim());
    }

    @Override
    public List<String> getAllCategories() {
        return productDAO.getAllCategories();
    }

    @Override
    public String validateProduct(Product product) {
        if (product == null) {
            return "Product object cannot be null";
        }
        
        if (product.getProductID() == null || product.getProductID().trim().isEmpty()) {
            return "Product ID cannot be empty";
        }
        
        if (product.getProductID().length() > 10) {
            return "Product ID cannot exceed 10 characters";
        }
        
        if (product.getProductName() == null || product.getProductName().trim().isEmpty()) {
            return "Product name cannot be empty";
        }
        
        if (product.getProductName().length() > 100) {
            return "Product name cannot exceed 100 characters";
        }
        
        if (product.getPrice() <= 0) {
            return "Product price must be greater than 0";
        }
        
        if (product.getImportDate() == null) {
            return "Import date cannot be null";
        }
        
        if (product.getImportDate().isAfter(LocalDate.now())) {
            return "Import date cannot be in the future";
        }
        
        if (product.getCategory() == null || product.getCategory().trim().isEmpty()) {
            return "Category cannot be empty";
        }
        
        if (product.getCategory().length() > 50) {
            return "Category cannot exceed 50 characters";
        }
        
        return null; // No validation errors
    }
}