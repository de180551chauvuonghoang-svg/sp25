<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="userDao.UserDAO" %>

<%
    if ("POST".equals(request.getMethod())) {
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        
        if (userName != null && password != null && !userName.trim().isEmpty() && !password.trim().isEmpty()) {
            try {
                UserDAO userDAO = new UserDAO();
                User user = userDAO.authenticate(userName.trim(), password);
                
                if (user != null) {
                    // Đăng nhập thành công
                    session.setAttribute("currentUser", user);
                    session.setAttribute("userName", user.getUserName());
                    session.setAttribute("role", user.getRole());
                    
                    // Redirect đến trang sản phẩm
                    response.sendRedirect(request.getContextPath() + "/viewAllProduct.jsp");
                    return;
                } else {
                    // Đăng nhập thất bại
                    request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
                    request.getRequestDispatcher("/invalid.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình đăng nhập: " + e.getMessage());
                request.getRequestDispatcher("/invalid.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            request.getRequestDispatcher("/invalid.jsp").forward(request, response);
            return;
        }
    }
    
    // GET request - hiển thị form login
    request.getRequestDispatcher("/login.jsp").forward(request, response);
%>