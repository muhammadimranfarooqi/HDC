package reception;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bloodcollection.BloodCollectionController;
import login.UserBean;

/**
 * Servlet implementation class EditTestServlet
 */
@WebServlet("/EditTestServlet")
public class EditTestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditTestServlet() {
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
		 String lab_no = request.getParameter("lab_no");
		 String passport_no = request.getParameter("passport_no");
		 String medical = request.getParameter("medical");
		 String test_date = request.getParameter("test_date");
		 String medical_fee = request.getParameter("medical_fee");
		 String collection_date = request.getParameter("collection_date");
		
		 System.out.println("testdate:"+test_date);
		 System.out.println("collection_date:"+collection_date);

		
		 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		 SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	     Date parsed_test_date=null,parsed_collection_date=null;
		try {
			parsed_test_date = format1.parse(test_date);
			parsed_collection_date = format.parse(collection_date);

		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	        
	     java.sql.Timestamp test_date_sql = new java.sql.Timestamp(parsed_test_date.getTime());
	     java.sql.Date collection_date_sql = new java.sql.Date(parsed_collection_date.getTime());

	     System.out.println(lab_no);
	     System.out.println(passport_no);
         System.out.println(medical);
         System.out.println(medical_fee);
         System.out.println(test_date);
         System.out.println(collection_date);
         System.out.println(test_date_sql);
         System.out.println(collection_date_sql);
         String query = "";
         ResultSet rs = null;  
	      
         PreparedStatement stmt = null;    
    	 Connection con = (Connection) session.getAttribute("connection");
	 try {
			 
         if(lab_no=="" || lab_no.isEmpty() || lab_no==null){
        	 TestController tc = new TestController(con);
        	 
        	 lab_no = Long.toString(tc.getLatestLabNo());
        	 query = "INSERT INTO labtest (lab_no, date, medical, fee, collection_date, status, user_id , modification_date,passport_no) VALUES (?,?,?,?,?,?,?,?,?)";
		        PreparedStatement statement=null;
		        
					statement = con.prepareStatement(query);
				
		        
		        	statement.setString(1, lab_no);
				
			        statement.setTimestamp(2, test_date_sql);
			        statement.setString(3, medical);
			        statement.setString(4, medical_fee);

			        statement.setDate(5, collection_date_sql);
			        statement.setString(6, "In Progress");
			        statement.setString(7, user.getUser_id());
			        statement.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
			        statement.setString(9, passport_no);
			       
			     
			        int row = statement.executeUpdate();
		            if (row > 0) {
		            	
		        		Random random = new Random(System.nanoTime());

		        		int randomInt = random.nextInt(1000000000);

		        		BloodCollectionController bcc = new BloodCollectionController(con);
		        			
		        		boolean exists =true;
		        			
		        		while(exists){
		        			
		        		
		        			if(	bcc.checkBarCode(Integer.toString(randomInt)))
		        					{
		        					randomInt = random.nextInt(1000000000);
		        					}
		        				else
		        					exists = false;
		        			}

		           	 		query = "INSERT INTO blood_collection (lab_no, barcode_data, user_id , modification_date) VALUES (?,?,?,?)";
				        
							statement = con.prepareStatement(query);
						
				        	statement.setString(1, lab_no);
				           	statement.setString(2, Integer.toString(randomInt));
		    		        statement.setString(3, user.getUser_id());
		    		        statement.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
				    				
					     
					        row = statement.executeUpdate();
	
					        if (row > 0) {
						        String test = "Test saved";
				            	response.sendRedirect("reception/receptiontest.jsp?message="+test+"&passport="+passport_no); //logged-in page      		
				                System.out.println("Record saved into database");
					        }
		            }

		        

         }
         else{
	    	  query = "UPDATE labtest set date=?, medical = ?, fee=?, collection_date=?, status = ?, user_id = ? , modification_date = ? , passport_no = ? where lab_no = ?";
	    	  PreparedStatement statement=null;
		        
			  statement = con.prepareStatement(query);
		
				
		        statement.setTimestamp(1, test_date_sql);
		        statement.setString(2, medical);
		        statement.setString(3, medical_fee);

		        statement.setDate(4, collection_date_sql);
		        statement.setString(5, "In Progress");
		        statement.setString(6, user.getUser_id());
		        statement.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
		        statement.setString(8, passport_no);
		    	  statement.setString(9, lab_no);
		    	  
		    	  int row = statement.executeUpdate();
		            
		    	  if (row > 0) {
		          
		    		  String test = "Test saved";
		              response.sendRedirect("reception/receptiontest.jsp?message="+test+"&passport="+passport_no); //logged-in page      		
		              System.out.println("Record saved into database");
		            }    
         }
         
         
		 } catch (Exception e) {
				// TODO Auto-generated catch block
				PrintWriter out = response.getWriter();
				out.print(e.getMessage());
				e.printStackTrace(out);

				e.printStackTrace();
			}
	}

}
