package productDao;

import model.Product;
import java.util.List;

/**
 * Interface cho Product DAO
 */
public interface IProductDAO {
 
    List<Product> getAllProducts();
    
    Product getProductByID(String productID);
    
    List<Product> getProductsByCategory(String category);
   
    List<Product> getProductsSortedByImportDate(boolean ascending);
    
    // Lấy tất cả sản phẩm sắp xếp theo Category cho Admin
    List<Product> getAllProductsSortedByCategory();
    
    boolean addProduct(Product product);
    
    boolean updateProduct(Product product);
    
    boolean deleteProduct(String productID);
   
    List<String> getAllCategories();
    
    // Tìm sản phẩm có giá lớn hơn (>) minPrice
    List<Product> searchProductsByMinPrice(long minPrice);
}