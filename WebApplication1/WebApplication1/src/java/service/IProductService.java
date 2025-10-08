package service;

import model.Product;
import model.User;
import java.util.List;


public interface IProductService {
   
    List<Product> getAllProducts();
    
    List<Product> getProductsForAdmin(User currentUser);
    
    List<Product> getProductsForUser(User currentUser);
    
    // Lấy sản phẩm sắp xếp theo Category cho Admin
    List<Product> getProductsSortedByCategory(User currentUser);
    
    // Tìm sản phẩm có giá lớn hơn (>) minPrice
    List<Product> searchProductsByMinPrice(Long minPrice, User currentUser);
    
    Product getProductByID(String productID);
    
   
    boolean addProduct(Product product, User currentUser);
    
  
    boolean updateProduct(Product product, User currentUser);
    
   boolean deleteProduct(String productID, User currentUser);
    
   
    List<String> getAllCategories();
    
   
    String validateProduct(Product product);
}