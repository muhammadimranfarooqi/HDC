package xray;

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
import xray.XRayController;
import reception.TestController;

/**
 * Servlet implementation class EditXRayServlet
 */
@WebServlet("/EditXRayServlet")
public class EditXRayServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditXRayServlet() {
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
	       	String chest_xray="",reason="", comments="";
	    	 Connection con = (Connection) session.getAttribute("connection");

	       	String lab_no = request.getParameter("lab_no");
	       	chest_xray = request.getParameter("chest_xray");
	       	reason = request.getParameter("reason");
	       	comments = request.getParameter("comments");

	        XRayController xc = new XRayController(con);

	     
         String query = "";
         ResultSet rs = null;  
	      
         PreparedStatement stmt = null;    
	 try {
			 
         if(!xc.checkLabNo(lab_no)){
        	 TestController tc = new TestController(con);
        	 
        	 query = "INSERT INTO xray (lab_no, chest_xray, reason, user_id , modification_date, comments) VALUES (?,?,?,?,?,?)";
		        PreparedStatement statement=null;
		        
					statement = con.prepareStatement(query);
				
		        	statement.setString(1, lab_no);
		           	statement.setString(2, chest_xray);
		           	statement.setString(3, reason);
    		        statement.setString(4, user.getUser_id());
    		        statement.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
		           	statement.setString(6, comments);

			     
			        int row = statement.executeUpdate();
		            if (row > 0) {
		                String test = "Test saved";
		            	response.sendRedirect("xray/xrayhome.jsp?message="+test+"&search="+lab_no); //logged-in page      		
		                System.out.println("Record saved into database");
		            }

		        

         }
         else{
	    	  query = "UPDATE xray set chest_xray = ? , reason = ?, user_id = ? , modification_date = ?, comments = ?  where lab_no = ?";
	    	  PreparedStatement statement=null;
		        
			  statement = con.prepareStatement(query);
		
				
		       	statement.setString(1, chest_xray);
	           	statement.setString(2, reason);
		        statement.setString(3, user.getUser_id());
		        statement.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
	           	statement.setString(5, comments);

		        statement.setString(6, lab_no);
	    	  
		    	  int row = statement.executeUpdate();
		            
		    	  if (row > 0) {
		          
		    		  String test = "Test saved";
		              response.sendRedirect("xray/xrayhome.jsp?message="+test+"&search="+lab_no); //logged-in page      		
		              System.out.println("Record saved into database");
		            }    
         }
         
         
		 } catch (Exception e) {
				PrintWriter out = response.getWriter();
				out.print(e.getMessage());
				e.printStackTrace(out);
				e.printStackTrace();
			}
	}

	}


