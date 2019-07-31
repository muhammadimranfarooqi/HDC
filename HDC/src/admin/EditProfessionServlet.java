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

import reception.TestController;
import xray.XRayController;

/**
 * Servlet implementation class EditProfessionServlet
 */
@WebServlet("/EditProfessionServlet")
public class EditProfessionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditProfessionServlet() {
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

       	String id="",name="";

       	id = request.getParameter("id");
       	name = request.getParameter("name");


     
     String query = "";
     ResultSet rs = null;  
      
     PreparedStatement stmt = null;    
	 HttpSession session = request.getSession(true);	    
	 Connection con = (Connection) session.getAttribute("connection");
     AdminController controller = new AdminController(con);

	 try {
		// System.out.println("id="+id);
     if(!controller.checkProfession(id)){
    	 
    	 query = "INSERT INTO profession (id, name) VALUES (?,?)";
	        PreparedStatement statement=null;
	        
				statement = con.prepareStatement(query);
			
	        	statement.setLong(1, controller.getLatestProfessionID());
	           	statement.setString(2, name);
		     
		        int row = statement.executeUpdate();
	            if (row > 0) {
	            	response.sendRedirect("admin/admin_professions.jsp"); //logged-in page      		
	                System.out.println("Record added into database");
	            }

	        

     }
     else{
    	  query = "UPDATE profession set name = ? where id = ?";
    	  PreparedStatement statement=null;
	        
		  statement = con.prepareStatement(query);
	
			
	       	statement.setString(1, name);
           	statement.setString(2, id);
    	  
	    	  int row = statement.executeUpdate();
	            
	    	  if (row > 0) {
	          
	              response.sendRedirect("admin/admin_professions.jsp"); //logged-in page      		
	              System.out.println("Record updated into database");
	            }    
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
