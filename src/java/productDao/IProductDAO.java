package productDao;

import java.util.List;
import model.Product;
import java.sql.SQLException;

public interface IProductDAO {
    public void insertProduct(Product product) throws SQLException;
    public Product selectProduct(int id);
    public List<Product> selectAllProducts();
    public boolean deleteProduct(int id) throws SQLException;
    public boolean updateProduct(Product product) throws SQLException;
    // Additional method for pagination
    public List<Product> selectProductsWithPagination(int offset, int limit);
    public int getTotalProducts();
    // Cart related methods
    public boolean updateStock(int productId, int newStock) throws SQLException;
    public boolean decreaseStock(int productId, int quantity) throws SQLException;
}
