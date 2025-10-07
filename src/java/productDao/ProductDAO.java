package productDao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import dao.DBConnection;

public class ProductDAO implements IProductDAO {
    private static final String INSERT_PRODUCT = "INSERT INTO Product (name, price, description, stock, import_date) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_PRODUCT_BY_ID = "SELECT * FROM Product WHERE id = ?";
    private static final String SELECT_ALL_PRODUCTS = "SELECT * FROM Product";
    private static final String DELETE_PRODUCT = "DELETE FROM Product WHERE id = ?";
    private static final String UPDATE_PRODUCT = "UPDATE Product SET name=?, price=?, description=?, stock=?, import_date=? WHERE id=?";
    private static final String SELECT_PRODUCTS_PAGINATION = "SELECT * FROM Product ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
    private static final String COUNT_PRODUCTS = "SELECT COUNT(*) FROM Product";
    private static final String UPDATE_STOCK = "UPDATE Product SET stock = ? WHERE id = ?";
    private static final String DECREASE_STOCK = "UPDATE Product SET stock = stock - ? WHERE id = ? AND stock >= ?";

    @Override
    public void insertProduct(Product product) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(INSERT_PRODUCT)) {
            pstm.setString(1, product.getName());
            pstm.setDouble(2, product.getPrice());
            pstm.setString(3, product.getDescription());
            pstm.setInt(4, product.getStock());
            pstm.setString(5, product.getImportDate());
            pstm.executeUpdate();
        }
    }

    @Override
    public Product selectProduct(int id) {
        Product product = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(SELECT_PRODUCT_BY_ID)) {
            pstm.setInt(1, id);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                String description = rs.getString("description");
                int stock = rs.getInt("stock");
                String importDate = rs.getString("import_date");
                String status = rs.getString("status");

                product = new Product(id, name, price, description, stock, importDate, status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return product;
    }

    @Override
    public List<Product> selectAllProducts() {
        List<Product> products = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(SELECT_ALL_PRODUCTS)) {
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                String description = rs.getString("description");
                int stock = rs.getInt("stock");
                String importDate = rs.getString("import_date");
                String status = rs.getString("status");

                Product product = new Product(id, name, price, description, stock, importDate, status);
                products.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public boolean deleteProduct(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(DELETE_PRODUCT)) {
            pstm.setInt(1, id);
            rowDeleted = pstm.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    @Override
    public boolean updateProduct(Product product) throws SQLException {
        boolean rowUpdated;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(UPDATE_PRODUCT)) {
            pstm.setString(1, product.getName());
            pstm.setDouble(2, product.getPrice());
            pstm.setString(3, product.getDescription());
            pstm.setInt(4, product.getStock());
            pstm.setString(5, product.getImportDate());
            pstm.setInt(6, product.getId());

            rowUpdated = pstm.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    @Override
    public List<Product> selectProductsWithPagination(int offset, int limit) {
        List<Product> products = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(SELECT_PRODUCTS_PAGINATION)) {
            pstm.setInt(1, offset);
            pstm.setInt(2, limit);
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                String description = rs.getString("description");
                int stock = rs.getInt("stock");
                String importDate = rs.getString("import_date");
                String status = rs.getString("status");

                Product product = new Product(id, name, price, description, stock, importDate, status);
                products.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public int getTotalProducts() {
        int count = 0;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(COUNT_PRODUCTS)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    @Override
    public boolean updateStock(int productId, int newStock) throws SQLException {
        boolean rowUpdated;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(UPDATE_STOCK)) {
            pstm.setInt(1, newStock);
            pstm.setInt(2, productId);
            rowUpdated = pstm.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    @Override
    public boolean decreaseStock(int productId, int quantity) throws SQLException {
        boolean rowUpdated;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(DECREASE_STOCK)) {
            pstm.setInt(1, quantity);
            pstm.setInt(2, productId);
            pstm.setInt(3, quantity); // Ensure stock >= quantity before decreasing
            rowUpdated = pstm.executeUpdate() > 0;
        }
        return rowUpdated;
    }
}
