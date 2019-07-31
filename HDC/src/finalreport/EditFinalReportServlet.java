package finalreport;

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
import reception.TestController;
import xray.XRayController;

/**
 * Servlet implementation class EditFinalReportServlet
 */
@WebServlet("/EditFinalReportServlet")
public class EditFinalReportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditFinalReportServlet() {
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
	       	String status="",reason="", comments="";

	       	String lab_no = request.getParameter("search");
	       	status = request.getParameter("final_comments");

	       	System.out.println(lab_no);
	       	System.out.println(status);

	        

	     
         String query = "";
         ResultSet rs = null;  
    	 Connection con = (Connection) session.getAttribute("connection");
    	 TestController xc = new TestController(con);

         PreparedStatement stmt = null;    
		 try {
			 
	    	  query = "UPDATE labtest set status = ? , user_id = ? , modification_date = ? where lab_no = ?";
	    	  PreparedStatement statement=null;
		        
			  statement = con.prepareStatement(query);
		
				
		       	statement.setString(1, status);
		        statement.setString(2, user.getUser_id());
		        statement.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

		        statement.setString(4, lab_no);
	    	  
		    	  int row = statement.executeUpdate();
		            
		    	  if (row > 0) {
		          
		    		  String test = "Status updated.";
		              response.sendRedirect("finalreport/finalreport.jsp?message="+test+"&search="+lab_no); //logged-in page      		
		              System.out.println("Record saved into database");
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
