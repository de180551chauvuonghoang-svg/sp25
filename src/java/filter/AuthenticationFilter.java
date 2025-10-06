package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/products", "/users", "/dashboard.jsp"})
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Kiểm tra xem user đã đăng nhập chưa
        boolean loggedIn = (session != null && session.getAttribute("loggedInUser") != null);
        
        // Các trang không cần đăng nhập
        boolean loginRequest = requestURI.equals(contextPath + "/login");
        boolean registerRequest = requestURI.equals(contextPath + "/register");
        boolean logoutRequest = requestURI.equals(contextPath + "/logout");
        boolean publicResource = loginRequest || registerRequest || logoutRequest;
        
        if (loggedIn || publicResource) {
            // User đã đăng nhập hoặc đang truy cập trang public
            chain.doFilter(request, response);
        } else {
            // User chưa đăng nhập, redirect về login
            httpResponse.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup filter
    }
}