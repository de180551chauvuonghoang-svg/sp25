package model;

/**
 * User Model class mapping với bảng User_YourID
 */
public class User {
    private int userID;
    private String userName;
    private String password;
    private String role;

    // Constructor mặc định
    public User() {
    }

    // Constructor đầy đủ
    public User(int userID, String userName, String password, String role) {
        this.userID = userID;
        this.userName = userName;
        this.password = password;
        this.role = role;
    }

    // Getter và Setter
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // Method kiểm tra user có phải admin không
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }

    // toString method
    @Override
    public String toString() {
        return "User{" +
                "userID=" + userID +
                ", userName='" + userName + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}