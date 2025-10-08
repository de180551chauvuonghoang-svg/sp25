package controller;

import model.User;
import service.IUserService;
import service.UserService;

import java.io.IOException;
import java.util.logging.Logger;

// Tạm thời comment servlet imports để tránh lỗi compile
// import javax.servlet.ServletException;
// import javax.servlet.http.HttpServlet;
// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpServletResponse;
// import javax.servlet.http.HttpSession;

/**
 * Controller xử lý đăng nhập theo mô hình MVC
 * NOTE: Servlet API chưa được config, tạm thời sử dụng JSP hybrid approach
 */
public class LoginController {
    
    private static final Logger logger = Logger.getLogger(LoginController.class.getName());
    private IUserService userService;
    
    public LoginController() {
        userService = new UserService();
    }
    
    // Tạm thời comment servlet methods
    /*
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        
        try {
            User user = userService.login(userName, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                session.setAttribute("userName", user.getUserName());
                session.setAttribute("role", user.getRole());
                
                logger.info("User logged in successfully: " + user.getUserName());
                response.sendRedirect(request.getContextPath() + "/products");
                
            } else {
                request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
                request.getRequestDispatcher("/WEB-INF/views/invalid.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            logger.severe("Error during login: " + e.getMessage());
            request.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình đăng nhập!");
            request.getRequestDispatcher("/WEB-INF/views/invalid.jsp").forward(request, response);
        }
    }
    */
    
    /**
     * Business logic cho login - có thể gọi từ JSP
     */
    public User authenticate(String userName, String password) {
        return userService.login(userName, password);
    }
}