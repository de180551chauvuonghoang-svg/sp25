package controller;

import model.Product;
import model.User;
import service.IProductService;
import service.ProductService;

import java.util.List;
import java.util.logging.Logger;


public class ProductController {
    
    private static final Logger logger = Logger.getLogger(ProductController.class.getName());
    private IProductService productService;
    
    public ProductController() {
        productService = new ProductService();
    }
    
    /**
     * Lấy danh sách sản phẩm theo role của user
     */
    public List<Product> getProductsForUser(User currentUser) {
        if (currentUser == null) {
            logger.warning("Null user attempted to access products");
            return null;
        }
        
        try {
            if (currentUser.isAdmin()) {
                // Admin: lấy sản phẩm sắp xếp theo Category
                return productService.getProductsForAdmin(currentUser);
            } else {
                // User: lấy sản phẩm sắp xếp theo ngày nhập
                return productService.getProductsForUser(currentUser);
            }
        } catch (Exception e) {
            logger.severe("Error getting products for user: " + e.getMessage());
            return null;
        }
    }
    
   
    public List<Product> searchProductsByMinPrice(Long minPrice, User currentUser) {
        if (currentUser == null) {
            logger.warning("Null user attempted to search products by min price");
            return null;
        }
        
        try {
            return productService.searchProductsByMinPrice(minPrice, currentUser);
        } catch (Exception e) {
            logger.severe("Error searching products by min price: " + e.getMessage());
            return null;
        }
    }
    
   
    public List<String> getAllCategories() {
        try {
            return productService.getAllCategories();
        } catch (Exception e) {
            logger.severe("Error getting categories: " + e.getMessage());
            return null;
        }
    }
    
   
    public boolean addProduct(Product product, User currentUser) {
        if (currentUser == null || !currentUser.isAdmin()) {
            logger.warning("Non-admin user attempted to add product");
            return false;
        }
        
        try {
            return productService.addProduct(product, currentUser);
        } catch (Exception e) {
            logger.severe("Error adding product: " + e.getMessage());
            return false;
        }
    }
    
   
    public boolean updateProduct(Product product, User currentUser) {
        if (currentUser == null || !currentUser.isAdmin()) {
            logger.warning("Non-admin user attempted to update product");
            return false;
        }
        
        try {
            return productService.updateProduct(product, currentUser);
        } catch (Exception e) {
            logger.severe("Error updating product: " + e.getMessage());
            return false;
        }
    }
    
 
    public boolean deleteProduct(String productID, User currentUser) {
        if (currentUser == null || !currentUser.isAdmin()) {
            logger.warning("Non-admin user attempted to delete product");
            return false;
        }
        
        try {
            return productService.deleteProduct(productID, currentUser);
        } catch (Exception e) {
            logger.severe("Error deleting product: " + e.getMessage());
            return false;
        }
    }
    
    
    public Product getProductByID(String productID) {
        try {
            return productService.getProductByID(productID);
        } catch (Exception e) {
            logger.severe("Error getting product by ID: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Validate product data
     */
    public String validateProduct(Product product) {
        try {
            return productService.validateProduct(product);
        } catch (Exception e) {
            logger.severe("Error validating product: " + e.getMessage());
            return "Validation error: " + e.getMessage();
        }
    }
}