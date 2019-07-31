package login;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * Servlet implementation class ChangePasswordServlet
 */
@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangePasswordServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 HttpSession session = request.getSession(true);	    

		 
		 System.out.println("testing");
		 UserBean user = (UserBean) session.getAttribute("currentSessionUser");
		 Connection con = (Connection) session.getAttribute("connection");

		 String OldPassword = request.getParameter("OldPassword");
		    
		    String newpassword = request.getParameter("newpassword");
		  
 			 String searchQuery =
 		            "select * from users where username='"
 		                     + user.getUsername()
 		                     + "' AND password='"
 		                     + UserDAO.generateHash(OldPassword)
 		                     + "'";
 			 Statement stmt = null;    
		    	 ResultSet rs = null;
 			    
 		   try 
 		   {
 		      //connect to DB 
 		      stmt=con.createStatement();
 		      rs = stmt.executeQuery(searchQuery);	        
 		      boolean more = rs.next();
 			       
 		      if (more) 
 		      {
  		    	 String query = "UPDATE users set password = ? where user_id = ?";
  		    	 PreparedStatement statement=null;
  		    	 statement = con.prepareStatement(query);
			
 			
				
  		    	 statement.setString(1, UserDAO.generateHash(newpassword));
	               statement.setString(2, user.getUser_id());
	 	         	  
		    	  int row = statement.executeUpdate();
		    	  if(row>0){

		    		  	  if (con!=null)
		    		  		  con.close();
			    		  session.invalidate();
			    		  String test = "Password changed:";
			    		  response.sendRedirect("login/login.jsp?message="+test); 
			    	  }
			    	  else{
			    		 String test = "Fail to change password:";
		    		  response.sendRedirect("login/changepassword.jsp?message="+test); 
		    	  
			    	  }

 		      } 
 		      else{
 		    	  
 		    	 String test = "Fail to change password:";
	    		  response.sendRedirect("login/changepassword.jsp?message="+test); 
 		      }
 			
 		    	
 			        
 				 
				  
 			    	  
 				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					PrintWriter out = response.getWriter();
					out.print(e.getMessage());
					e.printStackTrace(out);

				}
 		    
 		   
	}

}
