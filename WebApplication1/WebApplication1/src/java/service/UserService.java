package service;

import model.User;
import userDao.IUserDAO;
import userDao.UserDAO;
import java.util.List;
import java.util.logging.Logger;

/**
 * Implementation của IUserService - Business Logic cho User
 */
public class UserService implements IUserService {
    
    private static final Logger logger = Logger.getLogger(UserService.class.getName());
    private final IUserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    // Constructor cho testing (dependency injection)
    public UserService(IUserDAO userDAO) {
        this.userDAO = userDAO;
    }

    @Override
    public User login(String userName, String password) {
        // Validate input
        if (userName == null || userName.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            logger.warning("Login attempt with empty username or password");
            return null;
        }
        
        // Authenticate user
        User user = userDAO.authenticate(userName.trim(), password);
        
        if (user != null) {
            logger.info("User logged in successfully: " + userName);
        } else {
            logger.warning("Failed login attempt for username: " + userName);
        }
        
        return user;
    }

    @Override
    public void logout(User user) {
        if (user != null) {
            logger.info("User logged out: " + user.getUserName());
        }
    }

    @Override
    public List<User> getAllUsers(User currentUser) {
        if (!isAdmin(currentUser)) {
            logger.warning("Non-admin user attempted to access all users: " + 
                         (currentUser != null ? currentUser.getUserName() : "null"));
            return null;
        }
        
        return userDAO.getAllUsers();
    }

    @Override
    public boolean addUser(User newUser, User currentUser) {
        // Kiểm tra quyền admin
        if (!isAdmin(currentUser)) {
            logger.warning("Non-admin user attempted to add user: " + 
                         (currentUser != null ? currentUser.getUserName() : "null"));
            return false;
        }
        
        // Validate user data
        String validationError = validateUser(newUser);
        if (validationError != null) {
            logger.warning("User validation failed: " + validationError);
            return false;
        }
        
        // Kiểm tra username đã tồn tại chưa
        if (userDAO.getUserByUserName(newUser.getUserName()) != null) {
            logger.warning("Attempted to add user with existing username: " + newUser.getUserName());
            return false;
        }
        
        return userDAO.addUser(newUser);
    }

    @Override
    public boolean updateUser(User userToUpdate, User currentUser) {
        // Kiểm tra quyền: admin có thể update tất cả, user chỉ update chính mình
        if (!isAdmin(currentUser) && 
            currentUser.getUserID() != userToUpdate.getUserID()) {
            logger.warning("User attempted to update another user's data: " + 
                         currentUser.getUserName());
            return false;
        }
        
        // Validate user data
        String validationError = validateUser(userToUpdate);
        if (validationError != null) {
            logger.warning("User validation failed: " + validationError);
            return false;
        }
        
        return userDAO.updateUser(userToUpdate);
    }

    @Override
    public boolean deleteUser(int userID, User currentUser) {
        // Chỉ admin mới được xóa user
        if (!isAdmin(currentUser)) {
            logger.warning("Non-admin user attempted to delete user: " + 
                         (currentUser != null ? currentUser.getUserName() : "null"));
            return false;
        }
        
        // Không cho phép xóa chính mình
        if (currentUser.getUserID() == userID) {
            logger.warning("Admin attempted to delete their own account: " + 
                         currentUser.getUserName());
            return false;
        }
        
        return userDAO.deleteUser(userID);
    }

    @Override
    public boolean isAdmin(User user) {
        return user != null && user.isAdmin();
    }

    @Override
    public String validateUser(User user) {
        if (user == null) {
            return "User object cannot be null";
        }
        
        if (user.getUserName() == null || user.getUserName().trim().isEmpty()) {
            return "Username cannot be empty";
        }
        
        if (user.getUserName().length() > 50) {
            return "Username cannot exceed 50 characters";
        }
        
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            return "Password cannot be empty";
        }
        
        if (user.getPassword().length() > 50) {
            return "Password cannot exceed 50 characters";
        }
        
        if (user.getRole() == null || user.getRole().trim().isEmpty()) {
            return "Role cannot be empty";
        }
        
        if (!user.getRole().equalsIgnoreCase("admin") && 
            !user.getRole().equalsIgnoreCase("user")) {
            return "Role must be either 'admin' or 'user'";
        }
        
        return null; // No validation errors
    }
}