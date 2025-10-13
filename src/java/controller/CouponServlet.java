package controller;

import couponDao.CouponDAO;
import couponDao.ICouponDAO.CouponResult;
import couponDao.ICouponDAO.CouponValidationResult;
import model.Coupon;
import model.CouponUsage;
import model.User;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CouponServlet", urlPatterns = {"/coupon"})
public class CouponServlet extends HttpServlet {
    private CouponDAO couponDAO = new CouponDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("list".equals(action)) {
            handleListCoupons(request, response, loggedInUser);
        } else if ("validate".equals(action)) {
            handleValidateCoupon(request, response, loggedInUser);
        } else if ("usage-history".equals(action)) {
            handleUsageHistory(request, response, loggedInUser);
        } else if ("active".equals(action)) {
            handleActiveCoupons(request, response);
        } else if ("getAvailable".equals(action)) {
            handleGetAvailableCoupons(request, response, loggedInUser);
        } else {
            // Default: hiển thị danh sách coupon
            handleListCoupons(request, response, loggedInUser);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            handleCreateCoupon(request, response, loggedInUser);
        } else if ("update".equals(action)) {
            handleUpdateCoupon(request, response, loggedInUser);
        } else if ("deactivate".equals(action)) {
            handleDeactivateCoupon(request, response, loggedInUser);
        } else if ("validate".equals(action)) {
            handleValidateCouponAjax(request, response, loggedInUser);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không hợp lệ");
        }
    }
    
    /**
     * Hiển thị danh sách coupon (cho admin)
     */
    private void handleListCoupons(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        
        // Chỉ admin mới được xem tất cả coupon
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            // User thường chỉ xem coupon có hiệu lực
            List<Coupon> activeCoupons = couponDAO.getActiveCoupons();
            request.setAttribute("coupons", activeCoupons);
            request.setAttribute("isUserView", true);
        } else {
            List<Coupon> allCoupons = couponDAO.getAllCoupons();
            request.setAttribute("coupons", allCoupons);
            request.setAttribute("isUserView", false);
        }
        
        request.getRequestDispatcher("coupon-list.jsp").forward(request, response);
    }
    
    /**
     * Validate coupon code
     */
    private void handleValidateCoupon(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        
        String couponCode = request.getParameter("code");
        String orderAmountStr = request.getParameter("orderAmount");
        
        if (couponCode == null || orderAmountStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin cần thiết");
            return;
        }
        
        try {
            double orderAmount = Double.parseDouble(orderAmountStr);
            CouponValidationResult result = couponDAO.validateCoupon(couponCode, loggedInUser.getId(), orderAmount);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("valid", result.isValid());
            jsonResponse.put("message", result.getMessage());
            jsonResponse.put("discountAmount", result.getDiscountAmount());
            
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số tiền đơn hàng không hợp lệ");
        }
    }
    
    /**
     * Lấy lịch sử sử dụng coupon
     */
    private void handleUsageHistory(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        
        List<CouponUsage> usageHistory = couponDAO.getUserCouponUsageHistory(loggedInUser.getId());
        
        request.setAttribute("usageHistory", usageHistory);
        request.getRequestDispatcher("coupon-usage-history.jsp").forward(request, response);
    }
    
    /**
     * Lấy danh sách coupon có hiệu lực (API)
     */
    private void handleActiveCoupons(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Coupon> activeCoupons = couponDAO.getActiveCoupons();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(activeCoupons));
    }
    
    /**
     * Lấy danh sách coupon khả dụng cho user (API)
     */
    private void handleGetAvailableCoupons(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        
        try {
            List<Coupon> availableCoupons = couponDAO.getAvailableCouponsForUser(loggedInUser.getId());
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("coupons", availableCoupons);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("message", "Lỗi khi lấy danh sách coupon: " + e.getMessage());
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(errorResult));
        }
    }
    
    /**
     * Tạo coupon mới (chỉ admin)
     */
    private void handleCreateCoupon(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }
        
        try {
            Coupon coupon = createCouponFromRequest(request, loggedInUser);
            CouponResult result = couponDAO.createCoupon(coupon);
            
            if (result.isSuccess()) {
                request.setAttribute("success", result.getMessage());
            } else {
                request.setAttribute("error", result.getMessage());
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tạo coupon: " + e.getMessage());
        }
        
        // Redirect về trang danh sách
        response.sendRedirect("coupon?action=list");
    }
    
    /**
     * Cập nhật coupon (chỉ admin)
     */
    private void handleUpdateCoupon(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID coupon");
                return;
            }
            
            int couponId = Integer.parseInt(idStr);
            Coupon coupon = createCouponFromRequest(request, loggedInUser);
            coupon.setId(couponId);
            
            CouponResult result = couponDAO.updateCoupon(coupon);
            
            if (result.isSuccess()) {
                request.setAttribute("success", result.getMessage());
            } else {
                request.setAttribute("error", result.getMessage());
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi cập nhật coupon: " + e.getMessage());
        }
        
        // Redirect về trang danh sách
        response.sendRedirect("coupon?action=list");
    }
    
    /**
     * Vô hiệu hóa coupon (chỉ admin)
     */
    private void handleDeactivateCoupon(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID coupon");
                return;
            }
            
            int couponId = Integer.parseInt(idStr);
            boolean success = couponDAO.deactivateCoupon(couponId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", success);
            jsonResponse.put("message", success ? "Vô hiệu hóa thành công" : "Không thể vô hiệu hóa coupon");
            
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID coupon không hợp lệ");
        }
    }
    
    /**
     * Validate coupon qua AJAX
     */
    private void handleValidateCouponAjax(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String couponCode = request.getParameter("couponCode");
        String orderAmountStr = request.getParameter("orderAmount");
        
        Map<String, Object> jsonResponse = new HashMap<>();
        
        try {
            // Validate input parameters
            if (couponCode == null || couponCode.trim().isEmpty()) {
                jsonResponse.put("valid", false);
                jsonResponse.put("message", "Vui lòng nhập mã giảm giá");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            if (orderAmountStr == null || orderAmountStr.trim().isEmpty()) {
                jsonResponse.put("valid", false);
                jsonResponse.put("message", "Số tiền đơn hàng không hợp lệ");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            double orderAmount = Double.parseDouble(orderAmountStr);
            if (orderAmount <= 0) {
                jsonResponse.put("valid", false);
                jsonResponse.put("message", "Số tiền đơn hàng phải lớn hơn 0");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            // Validate coupon
            CouponValidationResult result = couponDAO.validateCoupon(couponCode, loggedInUser.getId(), orderAmount);
            
            jsonResponse.put("valid", result.isValid());
            jsonResponse.put("message", result.getMessage());
            jsonResponse.put("discountAmount", result.getDiscountAmount());
            jsonResponse.put("couponId", result.getCouponId());
            
            if (result.isValid()) {
                // Lấy thông tin coupon để trả về
                Coupon coupon = couponDAO.getCouponByCode(couponCode);
                if (coupon != null) {
                    Map<String, Object> couponInfo = new HashMap<>();
                    couponInfo.put("id", coupon.getId());
                    couponInfo.put("code", coupon.getCode());
                    couponInfo.put("name", coupon.getName());
                    couponInfo.put("discountType", coupon.getDiscountType());
                    couponInfo.put("discountValue", coupon.getDiscountValue());
                    jsonResponse.put("coupon", couponInfo);
                }
            }
            
        } catch (NumberFormatException e) {
            jsonResponse.put("valid", false);
            jsonResponse.put("message", "Số tiền đơn hàng không hợp lệ");
        } catch (Exception e) {
            jsonResponse.put("valid", false);
            jsonResponse.put("message", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace(); // For debugging
        }
        
        response.getWriter().write(gson.toJson(jsonResponse));
    }
    
    /**
     * Tạo Coupon object từ request parameters
     */
    private Coupon createCouponFromRequest(HttpServletRequest request, User loggedInUser) throws ParseException {
        Coupon coupon = new Coupon();
        
        coupon.setCode(request.getParameter("code"));
        coupon.setName(request.getParameter("name"));
        coupon.setDescription(request.getParameter("description"));
        coupon.setDiscountType(request.getParameter("discountType"));
        coupon.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
        
        // Optional fields
        String minOrderAmountStr = request.getParameter("minOrderAmount");
        if (minOrderAmountStr != null && !minOrderAmountStr.trim().isEmpty()) {
            coupon.setMinOrderAmount(Double.parseDouble(minOrderAmountStr));
        }
        
        String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
        if (maxDiscountAmountStr != null && !maxDiscountAmountStr.trim().isEmpty()) {
            coupon.setMaxDiscountAmount(Double.parseDouble(maxDiscountAmountStr));
        }
        
        // Parse dates
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        if (startDateStr != null && !startDateStr.trim().isEmpty()) {
            coupon.setStartDate(new Timestamp(dateFormat.parse(startDateStr).getTime()));
        }
        
        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
            coupon.setEndDate(new Timestamp(dateFormat.parse(endDateStr).getTime()));
        }
        
        String usageLimitStr = request.getParameter("usageLimit");
        if (usageLimitStr != null && !usageLimitStr.trim().isEmpty()) {
            coupon.setUsageLimit(Integer.parseInt(usageLimitStr));
        }
        
        coupon.setCreatedBy(loggedInUser.getId());
        coupon.setActive(true);
        
        return coupon;
    }
}