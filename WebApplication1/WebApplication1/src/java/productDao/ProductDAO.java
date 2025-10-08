package productDao;

import dao.DBConnection;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Implementation của IProductDAO
 */
public class ProductDAO implements IProductDAO {
    
    private static final Logger logger = Logger.getLogger(ProductDAO.class.getName());

    @Override
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Product_YourID ORDER BY ProductID";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getString("ProductID"),
                    rs.getString("ProductName"),
                    rs.getLong("Price"),
                    rs.getDate("ImportDate").toLocalDate(),
                    rs.getString("Category")
                );
                products.add(product);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting all products", ex);
        }
        return products;
    }

    @Override
    public List<Product> getAllProductsSortedByCategory() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Product_YourID ORDER BY Category, ProductName";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getString("ProductID"),
                    rs.getString("ProductName"),
                    rs.getLong("Price"),
                    rs.getDate("ImportDate").toLocalDate(),
                    rs.getString("Category")
                );
                products.add(product);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting products sorted by category", ex);
        }
        return products;
    }

    @Override
    public Product getProductByID(String productID) {
        String sql = "SELECT * FROM Product_YourID WHERE ProductID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, productID);
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new Product(
                        rs.getString("ProductID"),
                        rs.getString("ProductName"),
                        rs.getLong("Price"),
                        rs.getDate("ImportDate").toLocalDate(),
                        rs.getString("Category")
                    );
                }
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting product by ID: " + productID, ex);
        }
        return null;
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Product_YourID WHERE Category = ? ORDER BY ProductName";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, category);
            
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                        rs.getString("ProductID"),
                        rs.getString("ProductName"),
                        rs.getLong("Price"),
                        rs.getDate("ImportDate").toLocalDate(),
                        rs.getString("Category")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting products by category: " + category, ex);
        }
        return products;
    }

    @Override
    public List<Product> getProductsSortedByImportDate(boolean ascending) {
        List<Product> products = new ArrayList<>();
        String orderBy = ascending ? "ASC" : "DESC";
        String sql = "SELECT * FROM Product_YourID ORDER BY ImportDate " + orderBy;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getString("ProductID"),
                    rs.getString("ProductName"),
                    rs.getLong("Price"),
                    rs.getDate("ImportDate").toLocalDate(),
                    rs.getString("Category")
                );
                products.add(product);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting products sorted by import date", ex);
        }
        return products;
    }

    @Override
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO Product_YourID (ProductID, ProductName, Price, ImportDate, Category) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, product.getProductID());
            pst.setString(2, product.getProductName());
            pst.setLong(3, product.getPrice());
            pst.setDate(4, Date.valueOf(product.getImportDate()));
            pst.setString(5, product.getCategory());
            
            return pst.executeUpdate() > 0;
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error adding product: " + product.getProductID(), ex);
            return false;
        }
    }

    @Override
    public boolean updateProduct(Product product) {
        String sql = "UPDATE Product_YourID SET ProductName = ?, Price = ?, ImportDate = ?, Category = ? WHERE ProductID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, product.getProductName());
            pst.setLong(2, product.getPrice());
            pst.setDate(3, Date.valueOf(product.getImportDate()));
            pst.setString(4, product.getCategory());
            pst.setString(5, product.getProductID());
            
            return pst.executeUpdate() > 0;
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error updating product: " + product.getProductID(), ex);
            return false;
        }
    }

    @Override
    public boolean deleteProduct(String productID) {
        String sql = "DELETE FROM Product_YourID WHERE ProductID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, productID);
            
            return pst.executeUpdate() > 0;
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error deleting product: " + productID, ex);
            return false;
        }
    }

    @Override
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT Category FROM Product_YourID ORDER BY Category";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                categories.add(rs.getString("Category"));
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting all categories", ex);
        }
        return categories;
    }

    @Override
    public List<Product> searchProductsByMinPrice(long minPrice) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Product_YourID WHERE Price > ? ORDER BY Price ASC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setLong(1, minPrice);
            
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                        rs.getString("ProductID"),
                        rs.getString("ProductName"),
                        rs.getLong("Price"),
                        rs.getDate("ImportDate").toLocalDate(),
                        rs.getString("Category")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error searching products by min price: " + minPrice, ex);
        }
        return products;
    }
}