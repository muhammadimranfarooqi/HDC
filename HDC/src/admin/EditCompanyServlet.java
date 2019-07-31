package admin;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;


/**
 * Servlet implementation class EditCompanyServlet
 */
@WebServlet("/EditCompanyServlet")
@MultipartConfig(maxFileSize = 16177215)

public class EditCompanyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditCompanyServlet() {
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

		
		 String name = request.getParameter("name");

       	String address = request.getParameter("address");
        Part logo_file = request.getPart("logo_file");
        InputStream logo_file_is = null;

        if(logo_file!=null)
        	logo_file_is = logo_file.getInputStream();
        
     String query = "";
     ResultSet rs = null;  
      System.out.println(name);
      System.out.println(address);
      System.out.println(logo_file.getName());
      
     PreparedStatement stmt = null;    
	 HttpSession session = request.getSession(true);	    
	 Connection con = (Connection) session.getAttribute("connection");
     AdminController controller = new AdminController(con);

	 try {
		// System.out.println("id="+id);
     if(!controller.checkCompany()){
    	 
    	 query = "INSERT INTO company ( name, address, logo) VALUES (?,?,?)";
	        PreparedStatement statement=null;
	        
				statement = con.prepareStatement(query);
			
	        	statement.setString(1, name);
	           	statement.setString(2, address);
	           	
	           	if(logo_file_is!=null)
	 		       	statement.setBinaryStream(3, logo_file_is,logo_file_is.available());
	           	else
		        	statement.setBinaryStream(3, null,0);

		     
		        int row = statement.executeUpdate();
	            if (row > 0) {
	            	response.sendRedirect("admin/admin_company.jsp"); //logged-in page      		
	                System.out.println("Record added into database");
	            }

	        

     }
     else{
    	  query = "UPDATE company set name = ?, address = ?, logo = ?";
    	  PreparedStatement statement=null;
	        
		  statement = con.prepareStatement(query);
	
			
	       	statement.setString(1, name);
           	statement.setString(2, address);
         	if(logo_file_is!=null)
 		       	statement.setBinaryStream(3, logo_file_is,logo_file_is.available());
           	else
	        	statement.setBinaryStream(3, null,0);

	    
	    	  int row = statement.executeUpdate();
	            
	    	  if (row > 0) {
	          
	              response.sendRedirect("admin/admin_company.jsp"); //logged-in page      		
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
