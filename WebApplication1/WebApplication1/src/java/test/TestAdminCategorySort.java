package test;

import productDao.ProductDAO;
import model.Product;
import java.util.List;

/**
 * Test class để kiểm tra chức năng sắp xếp theo Category cho Admin
 */
public class TestAdminCategorySort {
    
    public static void main(String[] args) {
        try {
            ProductDAO productDAO = new ProductDAO();
            System.out.println("=== TEST ADMIN CATEGORY SORTING ===");
            
            // Test 1: Lấy tất cả sản phẩm sắp xếp theo Category
            System.out.println("\n1. Test sắp xếp theo Category (cho Admin):");
            List<Product> categoryProducts = productDAO.getAllProductsSortedByCategory();
            if (categoryProducts != null && !categoryProducts.isEmpty()) {
                System.out.println("   Tìm thấy " + categoryProducts.size() + " sản phẩm sắp xếp theo Category:");
                String currentCategory = "";
                for (Product p : categoryProducts) {
                    if (!currentCategory.equals(p.getCategory())) {
                        currentCategory = p.getCategory();
                        System.out.println("\n   📂 CATEGORY: " + currentCategory);
                    }
                    System.out.println("     - " + p.getProductName() + " (" + p.getProductID() + "): " 
                                     + String.format("%,d", p.getPrice()) + " VND");
                }
            } else {
                System.out.println("   Không tìm thấy sản phẩm nào.");
            }
            
            // Test 2: So sánh với getAllProducts thông thường
            System.out.println("\n2. Test getAllProducts() thông thường:");
            List<Product> normalProducts = productDAO.getAllProducts();
            if (normalProducts != null && !normalProducts.isEmpty()) {
                System.out.println("   Tìm thấy " + normalProducts.size() + " sản phẩm (sắp xếp theo ProductID):");
                for (Product p : normalProducts) {
                    System.out.println("   - " + p.getProductID() + ": " + p.getProductName() 
                                     + " [" + p.getCategory() + "] - " 
                                     + String.format("%,d", p.getPrice()) + " VND");
                }
            } else {
                System.out.println("   Không tìm thấy sản phẩm nào.");
            }
            
            // Test 3: Lấy danh sách categories
            System.out.println("\n3. Test getAllCategories():");
            List<String> categories = productDAO.getAllCategories();
            if (categories != null && !categories.isEmpty()) {
                System.out.println("   Tìm thấy " + categories.size() + " categories:");
                for (String category : categories) {
                    System.out.println("   - " + category);
                }
            } else {
                System.out.println("   Không tìm thấy category nào.");
            }
            
        } catch (Exception e) {
            System.err.println("Lỗi khi test: " + e.getMessage());
            e.printStackTrace();
        }
    }
}