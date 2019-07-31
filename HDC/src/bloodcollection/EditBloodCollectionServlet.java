package bloodcollection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

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
 * Servlet implementation class EditBloodCollectionServlet
 */
@WebServlet("/EditBloodCollectionServlet")
public class EditBloodCollectionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditBloodCollectionServlet() {
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
		 Connection con = (Connection) session.getAttribute("connection");

	       	String barcode_data="",sample_date_string="";
	       	java.util.Date sample_date=null;
	       	
	       	String lab_no = request.getParameter("lab_no");
	       	barcode_data = request.getParameter("barcode_data");
	       	sample_date_string = request.getParameter("sample_date");

//			 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			 SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

		     Timestamp sample_date_sql=null;
			try {
				if(sample_date_string != null)
					sample_date = format1.parse(sample_date_string);

			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		     
			if(sample_date!=null)
			     sample_date_sql = new java.sql.Timestamp(sample_date.getTime());
			
//				sample_date_sql = new java.sql.Date(sample_date.getTime());

	       	
	       	
	        BloodCollectionController controller = new BloodCollectionController(con);

	     
         String query = "";
         ResultSet rs = null;  
	      
         PreparedStatement stmt = null;    
		 Connection currentCon = null;
		 
		 
		 try {
			 
         if(!controller.checkLabNo(lab_no)){
        	 
        	 query = "INSERT INTO blood_collection (lab_no, barcode_data, sample_date, user_id , modification_date) VALUES (?,?,?,?,?)";
		        PreparedStatement statement=null;
		        
					statement = con.prepareStatement(query);
				
		        	statement.setString(1, lab_no);
		           	statement.setString(2, barcode_data);
		           	statement.setTimestamp(3, sample_date_sql);
    		        statement.setString(4, user.getUser_id());
    		        statement.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
		    				
			     
			        int row = statement.executeUpdate();
		            if (row > 0) {
		                String test = "Test saved";
		            	response.sendRedirect("bloodcollection/bloodcollectionhome.jsp?message="+test+"&search="+lab_no); //logged-in page      		
		                System.out.println("Record saved into database");
		            }

		        

         }
         else{
	    	  query = "UPDATE blood_collection set barcode_data = ? , sample_date = ?, user_id = ? , modification_date = ?  where lab_no = ?";
	    	  PreparedStatement statement=null;

			  statement = con.prepareStatement(query);
		
				
		       	statement.setString(1, barcode_data);
	           	statement.setTimestamp(2, sample_date_sql);
		        statement.setString(3, user.getUser_id());
		        statement.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
	           	statement.setString(5, lab_no);
	    	  
		    	  int row = statement.executeUpdate();
		            
		    	  if (row > 0) {
		          
		    		  String test = "Test saved";
		              response.sendRedirect("bloodcollection/bloodcollectionhome.jsp?message="+test+"&search="+lab_no); //logged-in page      		
		              System.out.println("Record saved into database");
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
