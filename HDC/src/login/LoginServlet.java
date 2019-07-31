package login;



import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import database.SqlServerConnector;

/**
 * Servlet implementation class LoginServlet
 */

@WebServlet("/LoginServlet")

public class LoginServlet extends HttpServlet {

	 public LoginServlet() {
	        super();
	        // TODO Auto-generated constructor stub
	    }

public void doPost(HttpServletRequest request, HttpServletResponse response) 
			           throws ServletException, java.io.IOException {

try
{	    

     UserBean user = new UserBean();
     user.setUserName(request.getParameter("username"));
     user.setPassword(request.getParameter("password"));
     
     String role = request.getParameter("role");
     Connection con = new SqlServerConnector().getConnection();
     HttpSession session = request.getSession(true);	    
     session.setAttribute("connection",con); 

     user = UserDAO.login(user, con);
//	 if(user.getRole().equalsIgnoreCase("admin")){
		 
//	 }  		    
     if (user.isValid())
     {
    	 if(UserDAO.checkRole(role, user.getUser_id(),con))  
    		 user.setRole(role);
    	 else
       	  	response.sendRedirect("login/authorizationfailed.jsp"); //logged-in page   

          session.setAttribute("currentSessionUser",user); 
          session.setAttribute("message","Welcome! "); 

          PrintWriter out = response.getWriter();
          out.print(user.getRole());
          
          if(user.getRole().equalsIgnoreCase("Receptionist"))
        	  response.sendRedirect("reception/receptionhome.jsp"); //logged-in page   
          if(user.getRole().equalsIgnoreCase("Physician"))
        	  response.sendRedirect("physician/physicianhome.jsp"); //logged-in page   

          if(user.getRole().equalsIgnoreCase("Xray"))
        	  response.sendRedirect("xray/xrayhome.jsp"); //logged-in page   
	 
          if(user.getRole().equalsIgnoreCase("BloodCollection"))
        	  response.sendRedirect("bloodcollection/bloodcollectionhome.jsp"); //logged-in page   

          if(user.getRole().equalsIgnoreCase("LabReport"))
        	  response.sendRedirect("labreport/labreport.jsp"); //logged-in page   

          if(user.getRole().equalsIgnoreCase("Admin"))
        	  response.sendRedirect("admin/adminhome.jsp"); //logged-in page   

          if(user.getRole().equalsIgnoreCase("FinalReport"))
        	  response.sendRedirect("finalreport/finalreport.jsp"); //logged-in page   

     }
     
	        
     else {
    	 	if (con!=null)
    	 		con.close();
    	 		response.sendRedirect("login/invalidlogin.jsp");
          } //error page 
} 
		
		
catch (Throwable e) 	    
{
     System.out.println(e); 
		PrintWriter out = response.getWriter();
		out.print(e.getMessage());
		e.printStackTrace(out);

}
       }
	}
