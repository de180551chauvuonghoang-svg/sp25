package userDao;

import model.User;
import java.util.List;


public interface IUserDAO {
    
    User authenticate(String userName, String password);
    
  
    List<User> getAllUsers();
  
    User getUserByID(int userID);
    
   
    User getUserByUserName(String userName);
    
  
    boolean addUser(User user);
    
   
    boolean updateUser(User user);
    
   
    boolean deleteUser(int userID);
}