package login;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import java.text.*;
import java.util.*;
import java.sql.*;

import database.*;
public class UserDAO 	
{
//   static Connection con = null;
   static ResultSet rs = null;  
	
   private static HashMap<String, String> userslist = new HashMap<String, String>();

   public static String generateHash(String input) {
		StringBuilder hash = new StringBuilder();

		try {
			MessageDigest sha = MessageDigest.getInstance("SHA-1");
			byte[] hashedBytes = sha.digest(input.getBytes());
			char[] digits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
					'a', 'b', 'c', 'd', 'e', 'f' };
			for (int idx = 0; idx < hashedBytes.length;   idx++) {
				byte b = hashedBytes[idx];
				hash.append(digits[(b & 0xf0) >> 4]);
				hash.append(digits[b & 0x0f]);
			}
		} catch (NoSuchAlgorithmException e) {
			// handle error here.
		}

		return hash.toString();
	}
	
   public static HashMap<String, String> getUserslist(Connection con) {
	      Statement stmt = null;    

	   String searchQuery =      "select * from users order by user_id";
	   try 
	   {
		   
	      stmt=con.createStatement();
	      rs = stmt.executeQuery(searchQuery);	 
	      userslist.clear();
	      while(rs.next()){
	    	  userslist.put(rs.getString("user_id"), rs.getString("username"));
	    	  
	      }
	   }catch(Exception e){
		   
	   }
	   
	return userslist;
}

public static boolean checkRole(String role, String user_id, Connection con){
	boolean flag = false;
    Statement stmt = null;    
    String searchQuery =  "select * from role where user_id='"
                     + user_id
                     + "' AND role_name='"
                     + role
                     + "'";
	
    try 
    {
       //connect to DB 
       stmt=con.createStatement();
       rs = stmt.executeQuery(searchQuery);	        
       if( rs.next())
 	   	   flag = true;
     
       rs.close();
       stmt.close();
       
       } 

       catch (Exception ex) 
       {
          System.out.println("Role query failed: An Exception has occurred! " + ex);
       } 
    finally 
    {
       if (rs != null)	{
          try {
             rs.close();
          } catch (Exception e) {}
             rs = null;
          }
 	
       if (stmt != null) {
          try {
             stmt.close();
          } catch (Exception e) {}
             stmt = null;
          }
 	
    }
	return flag;
}

public static UserBean login(UserBean bean, Connection con) {
	
      //preparing some objects for connection
      Statement stmt = null;    
	
      String username = bean.getUsername();    
      String password = bean.getPassword();   
	  String hashpassword = generateHash(password);  
      String searchQuery =
            "select * from users where username='"
                     + username
                     + "' AND password='"
                     + hashpassword
                     + "'";
	    
   // "System.out.println" prints in the console; Normally used to trace the process
  // System.out.println("Your user name is " + username);          
 //  System.out.println("Your password is " + password);
 //  System.out.println("Query: "+searchQuery);
	    
   try 
   {
      //connect to DB 
      stmt=con.createStatement();
      rs = stmt.executeQuery(searchQuery);	        
      boolean more = rs.next();
	       
      // if user does not exist set the isValid variable to false
      if (!more) 
      {
        // System.out.println("Sorry, you are not a registered user! Please sign up first");
         bean.setValid(false);
      } 
	        
      //if user exists set the isValid variable to true
      else if (more) 
      {
         if(rs.getString("status").equalsIgnoreCase("locked"))	 
        	 bean.setValid(false);
         else{

	         bean.setFirstName(rs.getString("firstname"));
	         bean.setLastName(rs.getString("lastname"));
	         bean.setEmp_id(rs.getString("emp_id"));
	         bean.setUser_id(rs.getString("user_id"));
	        // bean.setRole(rs.getString("role"));
	         bean.setValid(true);
	         
         }
      }
      
      
   } 

   catch (Exception ex) 
   {
      System.out.println("Log In failed: An Exception has occurred! " + ex);
   } 
	    
   //some exception handling
   finally 
   {
      if (rs != null)	{
         try {
            rs.close();
         } catch (Exception e) {}
            rs = null;
         }
	
      if (stmt != null) {
         try {
            stmt.close();
         } catch (Exception e) {}
            stmt = null;
         }
	
   }

return bean;
	
   }	
}