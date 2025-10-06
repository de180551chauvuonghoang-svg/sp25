package controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import productDao.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = "/products")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;
    private static final int PRODUCTS_PER_PAGE = 10;

    public void init() {
        productDAO = new ProductDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null) action = "list";

            switch (action) {
                case "new":
                    if (!checkAdminPermission(request, response)) return;
                    showNewForm(request, response);
                    break;
                case "insert":
                    if (!checkAdminPermission(request, response)) return;
                    insertProduct(request, response);
                    break;
                case "delete":
                    if (!checkAdminPermission(request, response)) return;
                    deleteProduct(request, response);
                    break;
                case "edit":
                    if (!checkAdminPermission(request, response)) return;
                    showEditForm(request, response);
                    break;
                case "update":
                    if (!checkAdminPermission(request, response)) return;
                    updateProduct(request, response);
                    break;
                case "confirmDelete":
                    if (!checkAdminPermission(request, response)) return;
                    showDeleteForm(request, response);
                    break;
                default:
                    listProduct(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int page = 1;
        int recordsPerPage = PRODUCTS_PER_PAGE;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        int offset = (page - 1) * recordsPerPage;
        List<Product> listProduct = productDAO.selectProductsWithPagination(offset, recordsPerPage);
        int totalProducts = productDAO.getTotalProducts();
        int totalPages = (int) Math.ceil(totalProducts * 1.0 / recordsPerPage);

        request.setAttribute("listProduct", listProduct);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("productList.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("createProduct.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product existingProduct = productDAO.selectProduct(id);
        request.setAttribute("product", existingProduct);
        request.getRequestDispatcher("editProduct.jsp").forward(request, response);
    }

    private void showDeleteForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.selectProduct(id);
        request.setAttribute("product", product);
        request.getRequestDispatcher("deleteProduct.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        int stock = Integer.parseInt(request.getParameter("stock"));
        String importDate = request.getParameter("importDate");

        Product newProduct = new Product(0, name, price, description, stock, importDate);
        productDAO.insertProduct(newProduct);
        response.sendRedirect("products");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        int stock = Integer.parseInt(request.getParameter("stock"));
        String importDate = request.getParameter("importDate");

        Product product = new Product(id, name, price, description, stock, importDate);
        productDAO.updateProduct(product);
        response.sendRedirect("products");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        productDAO.deleteProduct(id);
        response.sendRedirect("products");
    }
    
    private boolean checkAdminPermission(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String userRole = (String) request.getSession().getAttribute("userRole");
        if (!"admin".equals(userRole)) {
            response.sendError(403, "Bạn không có quyền thực hiện hành động này!");
            return false;
        }
        return true;
    }
}
