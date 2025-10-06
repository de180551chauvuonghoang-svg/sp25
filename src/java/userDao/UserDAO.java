/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package userDao;


import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import dao.DBConnection;





public class UserDAO implements IUserDAO {
    private static final String LOGIN = "SELECT id, name, role FROM Users WHERE name=? AND password=?";
    private static final String INSERT_USER = "INSERT INTO Users (name, email, country, role, status, password, dateOfBirth) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_USER_BY_ID = "SELECT * FROM Users WHERE id = ?";
    private static final String SELECT_ALL_USERS = "SELECT * FROM Users";
    private static final String DELETE_USER = "DELETE FROM Users WHERE id = ?";
    private static final String UPDATE_USER = "UPDATE Users SET name=?, email=?, country=?, role=?, status=?, password=?, dateOfBirth=? WHERE id=?";
    private static final String SEARCH_USERS_BY_NAME = "SELECT * FROM Users WHERE LOWER(name) LIKE LOWER(?)";

    // ✅ Check Login
    public User checkLogin(String name, String password) {
        User us = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(LOGIN)) {

            pstm.setString(1, name);
            pstm.setString(2, password);

            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("id");
                String user = rs.getString("name");
                String role = rs.getString("role");

                us = new User(id, user, "", "", role, true, "");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return us;
    }

   
    @Override
    public void insertUser(User user) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(INSERT_USER)) {
            pstm.setString(1, user.getName());
            pstm.setString(2, user.getEmail());
            pstm.setString(3, user.getCountry());
            pstm.setString(4, user.getRole());
            pstm.setBoolean(5, user.isStatus());
            pstm.setString(6, user.getPassword());
            pstm.setString(7, user.getDateOfBirth());
            pstm.executeUpdate();
        }
    }

   
    @Override
    public User selectUser(int id) {
        User user = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(SELECT_USER_BY_ID)) {
            pstm.setInt(1, id);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                String role = rs.getString("role");
                boolean status = rs.getBoolean("status");
                String password = rs.getString("password");
                String dateOfBirth = rs.getString("dateOfBirth");

                user = new User(id, name, email, country, role, status, password);
                user.setDateOfBirth(dateOfBirth);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

  
    @Override
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(SELECT_ALL_USERS)) {
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                String role = rs.getString("role");
                boolean status = rs.getBoolean("status");
                String password = rs.getString("password");
                String dateOfBirth = rs.getString("dateOfBirth");

                User user = new User(id, name, email, country, role, status, password);
                user.setDateOfBirth(dateOfBirth);
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

  
    @Override
    public boolean deleteUser(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(DELETE_USER)) {
            pstm.setInt(1, id);
            rowDeleted = pstm.executeUpdate() > 0;
        }
        return rowDeleted;
    }

 
    @Override
    public boolean updateUser(User user) throws SQLException {
        boolean rowUpdated;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(UPDATE_USER)) {
            pstm.setString(1, user.getName());
            pstm.setString(2, user.getEmail());
            pstm.setString(3, user.getCountry());
            pstm.setString(4, user.getRole());
            pstm.setBoolean(5, user.isStatus());
            pstm.setString(6, user.getPassword());
            pstm.setString(7, user.getDateOfBirth());
            pstm.setInt(8, user.getId());

            rowUpdated = pstm.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    // Get user by ID - method name for compatibility
    public User getUser(int id) {
        return selectUser(id);
    }

    // Search users by name (case-insensitive)
    public List<User> searchUsersByName(String searchName) {
        List<User> users = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(SEARCH_USERS_BY_NAME)) {
            pstm.setString(1, "%" + searchName + "%");
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                String role = rs.getString("role");
                boolean status = rs.getBoolean("status");
                String password = rs.getString("password");
                String dateOfBirth = rs.getString("dateOfBirth");

                User user = new User(id, name, email, country, role, status, password);
                user.setDateOfBirth(dateOfBirth);
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    // Method needed by AuthServlet - login by email and password
    public User loginUser(String email, String password) {
        String loginQuery = "SELECT * FROM Users WHERE email=? AND password=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(loginQuery)) {
            pstm.setString(1, email);
            pstm.setString(2, password);
            
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String userEmail = rs.getString("email");
                String country = rs.getString("country");
                String role = rs.getString("role");
                boolean status = rs.getBoolean("status");
                String userPassword = rs.getString("password");
                String dateOfBirth = rs.getString("dateOfBirth");

                User user = new User(id, name, userEmail, country, role, status, userPassword);
                user.setDateOfBirth(dateOfBirth);
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Method needed by AuthServlet - check if email exists
    public boolean isEmailExists(String email) {
        String checkEmailQuery = "SELECT COUNT(*) FROM Users WHERE email=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstm = con.prepareStatement(checkEmailQuery)) {
            pstm.setString(1, email);
            
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Method needed by AuthServlet - register new user
    public boolean registerUser(User user) {
        try {
            insertUser(user);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
