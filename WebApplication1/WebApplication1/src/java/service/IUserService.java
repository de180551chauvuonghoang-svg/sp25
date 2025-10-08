package service;

import model.User;
import java.util.List;

/**
 * Interface cho User Service - Business Logic Layer
 */
public interface IUserService {
    /**
     * Đăng nhập user
     * @param userName tên đăng nhập
     * @param password mật khẩu
     * @return User object nếu đăng nhập thành công, null nếu thất bại
     */
    User login(String userName, String password);
    
    /**
     * Đăng xuất user
     * @param user User object
     */
    void logout(User user);
    
    /**
     * Lấy tất cả users (chỉ admin mới được phép)
     * @param currentUser user hiện tại
     * @return List users hoặc null nếu không có quyền
     */
    List<User> getAllUsers(User currentUser);
    
    /**
     * Thêm user mới (chỉ admin mới được phép)
     * @param newUser user mới
     * @param currentUser user hiện tại
     * @return true nếu thành công, false nếu thất bại
     */
    boolean addUser(User newUser, User currentUser);
    
    /**
     * Cập nhật user (admin có thể cập nhật tất cả, user chỉ cập nhật chính mình)
     * @param userToUpdate user cần cập nhật
     * @param currentUser user hiện tại
     * @return true nếu thành công, false nếu thất bại
     */
    boolean updateUser(User userToUpdate, User currentUser);
    
    /**
     * Xóa user (chỉ admin mới được phép)
     * @param userID ID của user cần xóa
     * @param currentUser user hiện tại
     * @return true nếu thành công, false nếu thất bại
     */
    boolean deleteUser(int userID, User currentUser);
    
    /**
     * Kiểm tra quyền admin
     * @param user User object
     * @return true nếu là admin, false nếu không
     */
    boolean isAdmin(User user);
    
    /**
     * Validate thông tin user
     * @param user User object cần validate
     * @return message lỗi hoặc null nếu hợp lệ
     */
    String validateUser(User user);
}