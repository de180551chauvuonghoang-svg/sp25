package controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;
import userDao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth", "/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            switch (path) {
                case "/login":
                    if ("POST".equals(request.getMethod())) {
                        processLogin(request, response);
                    } else {
                        showLoginForm(request, response);
                    }
                    break;
                case "/register":
                    if ("POST".equals(request.getMethod())) {
                        processRegister(request, response);
                    } else {
                        showRegisterForm(request, response);
                    }
                case "/logout":
                    processLogout(request, response);
                    break;
                default:
                    showLoginForm(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email và mật khẩu không được để trống!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

     
//        String hashedPassword = hashPassword(password);
        
  
        User user = userDAO.loginUser(email,password /*hashedPassword*/);
        
        if (user != null) {
            // Kiểm tra status của user
            if (!user.isStatus()) {
                request.setAttribute("error", "Tài khoản đã bị khóa!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Đăng nhập thành công
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userRole", user.getRole());
            
            // Xử lý Remember Me
            String rememberMe = request.getParameter("rememberMe");
            if ("true".equals(rememberMe)) {
                
                Cookie emailCookie = new Cookie("rememberedEmail", email);
                Cookie passwordCookie = new Cookie("rememberedPassword", password);
                
              // Tạo cookie lưu email và password trong 10 giây
                emailCookie.setMaxAge(20);
                passwordCookie.setMaxAge(20);
                
              
                emailCookie.setPath("/");
                passwordCookie.setPath("/");
                
              
                response.addCookie(emailCookie);
                response.addCookie(passwordCookie);
            } else {
              
                clearRememberMeCookies(response);
            }
            
            // Check for redirect parameter
            String redirectUrl = request.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                if ("checkout".equals(redirectUrl)) {
                    response.sendRedirect("checkout");
                    return;
                } else {
                    response.sendRedirect(redirectUrl);
                    return;
                }
            }
            
            // Redirect dựa trên role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("products"); 
            } else {
                response.sendRedirect("dashboard");
            }
        } else {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String country = request.getParameter("country");
        String dateOfBirth = request.getParameter("dateOfBirth");

        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra password confirmation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra độ dài password
        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra email đã tồn tại chưa
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email đã được sử dụng!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Hash password
        String hashedPassword = hashPassword(password);

        // Tạo user mới
        User newUser = new User();
        newUser.setName(name.trim());
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPassword(hashedPassword);
        newUser.setCountry(country != null ? country.trim() : "");
        newUser.setDateOfBirth(dateOfBirth != null ? dateOfBirth : "");
        newUser.setRole("user"); 
        newUser.setStatus(true); 

        // Lưu vào database
        boolean success = userDAO.registerUser(newUser);
        
        if (success) {
            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Không xóa cookie khi logout để giữ remember me trong 30s
        // Cookie tự động hết hạn sau 30s
        
        response.sendRedirect("login");
    }

   
    private void clearRememberMeCookies(HttpServletResponse response) {
        Cookie emailCookie = new Cookie("rememberedEmail", "");
        Cookie passwordCookie = new Cookie("rememberedPassword", "");
        
        emailCookie.setMaxAge(20);
        passwordCookie.setMaxAge(20);
        emailCookie.setPath("/");
        passwordCookie.setPath("/");
        
        response.addCookie(emailCookie);
        response.addCookie(passwordCookie);
    }

   
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}