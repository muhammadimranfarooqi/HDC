package admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import login.UserBean;
import login.UserDAO;

/**
 * Servlet implementation class EditAgencyServlet
 */
@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditUserServlet() {
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
		UserBean user = (UserBean) session.getAttribute("currentSessionUser");
	  
		String user_id="",username="",firstname="",lastname="",emp_id="",password="", status="";

       	user_id = request.getParameter("user_id");
       	username = request.getParameter("username");
       	firstname = request.getParameter("firstname");
       	lastname = request.getParameter("lastname");
       	emp_id = request.getParameter("emp_id");
       	password = request.getParameter("password");
       	status = request.getParameter("status");

       	String[] role = request.getParameterValues("role");

       	String hashpassword = UserDAO.generateHash(password);
       	
       	
       	
       	
       	System.out.println(role);
       	
       	for (int i = 0; i < role.length; i++) 
        {
           System.out.println (role[i]);
        }

     
     String query = "";
     ResultSet rs = null;  
      
     PreparedStatement stmt = null;    
	 session = request.getSession(true);	    
	 Connection con = (Connection) session.getAttribute("connection");
     AdminController controller = new AdminController(con);

	 String user_id_new=null;
	 try {
		// System.out.println("id="+id);
     if(!controller.checkUser(user_id)){
    	 
    	 query = "INSERT INTO users (user_id, username,firstname,lastname,emp_id,password, modification_date,modify_by,status) VALUES (?,?,?,?,?,?,?,?,?)";
	        PreparedStatement statement=null;
	        
				statement = con.prepareStatement(query);
				user_id_new = Long.toString(controller.getLatestUserID());
	        	statement.setString(1, user_id_new);
	           	statement.setString(2, username);
	           	statement.setString(3, firstname);
	           	statement.setString(4, lastname);
	           	statement.setString(5, emp_id);
	           	statement.setString(6, hashpassword);
		        statement.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
	            statement.setString(8, user.getUser_id());
	           	statement.setString(9, status);

		        int row = statement.executeUpdate();
	            if (row > 0) {
	         //   	response.sendRedirect("admin/admin_user.jsp"); //logged-in page      		
	                System.out.println("Record added into database");
	            }
	            
	            query = "delete from role where user_id = ?";
	         
	   	  	 	statement = con.prepareStatement(query);

	   	  	 	statement.setString(1, user_id_new);
	   	  	 	row = statement.executeUpdate();
	      	
	   	  	 	query = "insert into role (user_id, role_name) values (?,?)";
	            statement = con.prepareStatement(query);
	          
	   	  	 	for (int i = 0; i < role.length; i++) {
	           		statement.setString(1, user_id_new);
	           		statement.setString(2, role[i]);
	           		row = statement.executeUpdate();
	   	  	 	}
	        

     }
     else{
    	  query = "UPDATE users set username = ?, firstname=?, lastname=?, emp_id = ?, password = ?, modification_date=?,modify_by=?, status=? where user_id = ?";
    	  PreparedStatement statement=null;
	        
		  statement = con.prepareStatement(query);
	
			
			statement.setString(1, username);
           	statement.setString(2, firstname);
           	statement.setString(3, lastname);
           	statement.setString(4, emp_id);
           	statement.setString(5, hashpassword);

	        statement.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            statement.setString(7, user.getUser_id());

           	statement.setString(8, status);

           	statement.setString(9, user_id);
	         	  
	    	  int row = statement.executeUpdate();
	            
	    	  if (row > 0) {
	          
	           //   response.sendRedirect("admin/admin_user.jsp"); //logged-in page      		
	              System.out.println("Record updated into database");
	          }    
	    	    query = "delete from role where user_id = ?";
		         
	   	  	 	statement = con.prepareStatement(query);

	   	  	 	statement.setString(1, user_id);
	   	  	 	row = statement.executeUpdate();
	      	
	   	  	 	query = "insert into role (user_id, role_name) values (?,?)";
	            statement = con.prepareStatement(query);
	          
	   	  	 	for (int i = 0; i < role.length; i++) {
	           		statement.setString(1, user_id);
	           		statement.setString(2, role[i]);
	           		row = statement.executeUpdate();
	   	  	 	}
	      	  
	    	  
     }
      

	  response.sendRedirect("admin/admin_user.jsp"); 

	 } catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			PrintWriter out = response.getWriter();
			out.print(e.getMessage());
			e.printStackTrace(out);

		}

		
	}

}
