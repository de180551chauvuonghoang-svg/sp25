package userDao;

import dao.DBConnection;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Implementation của IUserDAO
 */
public class UserDAO implements IUserDAO {
    
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

    @Override
    public User authenticate(String userName, String password) {
        String sql = "SELECT * FROM User_YourID WHERE UserName = ? AND Password = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, userName);
            pst.setString(2, password);
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("UserID"),
                        rs.getString("UserName"),
                        rs.getString("Password"),
                        rs.getString("Role")
                    );
                }
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error authenticating user: " + userName, ex);
        }
        return null;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM User_YourID ORDER BY UserID";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                User user = new User(
                    rs.getInt("UserID"),
                    rs.getString("UserName"),
                    rs.getString("Password"),
                    rs.getString("Role")
                );
                users.add(user);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting all users", ex);
        }
        return users;
    }

    @Override
    public User getUserByID(int userID) {
        String sql = "SELECT * FROM User_YourID WHERE UserID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setInt(1, userID);
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("UserID"),
                        rs.getString("UserName"),
                        rs.getString("Password"),
                        rs.getString("Role")
                    );
                }
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting user by ID: " + userID, ex);
        }
        return null;
    }

    @Override
    public User getUserByUserName(String userName) {
        String sql = "SELECT * FROM User_YourID WHERE UserName = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, userName);
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("UserID"),
                        rs.getString("UserName"),
                        rs.getString("Password"),
                        rs.getString("Role")
                    );
                }
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting user by username: " + userName, ex);
        }
        return null;
    }

    @Override
    public boolean addUser(User user) {
        String sql = "INSERT INTO User_YourID (UserID, UserName, Password, Role) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setInt(1, user.getUserID());
            pst.setString(2, user.getUserName());
            pst.setString(3, user.getPassword());
            pst.setString(4, user.getRole());
            
            return pst.executeUpdate() > 0;
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error adding user: " + user.getUserName(), ex);
            return false;
        }
    }

    @Override
    public boolean updateUser(User user) {
        String sql = "UPDATE User_YourID SET UserName = ?, Password = ?, Role = ? WHERE UserID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, user.getUserName());
            pst.setString(2, user.getPassword());
            pst.setString(3, user.getRole());
            pst.setInt(4, user.getUserID());
            
            return pst.executeUpdate() > 0;
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error updating user: " + user.getUserID(), ex);
            return false;
        }
    }

    @Override
    public boolean deleteUser(int userID) {
        String sql = "DELETE FROM User_YourID WHERE UserID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setInt(1, userID);
            
            return pst.executeUpdate() > 0;
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error deleting user: " + userID, ex);
            return false;
        }
    }
}