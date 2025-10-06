package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    public static String driverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=Sp25_DemoPRJ_1;encrypt=true;trustServerCertificate=true;";
    public static String userDB = "sa";
    public static String passDB = "1234";

    // Hàm lấy Connection
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(driverName);
            con = DriverManager.getConnection(dbURL, userDB, passDB);
            return con;
        } catch (Exception ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // ✅ Hàm kiểm tra kết nối DB
    public static boolean testConnection() {
        try (Connection con = getConnection()) {
            if (con != null && !con.isClosed()) {
                return true;  // kết nối thành công
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false; // kết nối thất bại
    }

    // Test nhanh khi chạy file
    public static void main(String[] args) {
        if (testConnection()) {
            System.out.println("✅ Database connected successfully!");
        } else {
            System.out.println("❌ Failed to connect to database!");
        }
    }
}
