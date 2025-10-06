package controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import productDao.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "SearchServlet", urlPatterns = "/search")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    public void init() {
        productDAO = new ProductDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đã đăng nhập chưa
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login");
            return;
        }

        String keyword = request.getParameter("keyword");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            try {
                List<Product> searchResults = searchProducts(keyword.trim());
                request.setAttribute("searchResults", searchResults);
            } catch (SQLException ex) {
                throw new ServletException(ex);
            }
        }
        
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    private List<Product> searchProducts(String keyword) throws SQLException {
        List<Product> results = new ArrayList<>();
        List<Product> allProducts = productDAO.selectAllProducts();
        
        // Tìm kiếm đơn giản theo tên sản phẩm (case-insensitive)
        String lowerKeyword = keyword.toLowerCase();
        for (Product product : allProducts) {
            if (product.getName().toLowerCase().contains(lowerKeyword) ||
                product.getDescription().toLowerCase().contains(lowerKeyword)) {
                results.add(product);
            }
        }
        
        return results;
    }
}