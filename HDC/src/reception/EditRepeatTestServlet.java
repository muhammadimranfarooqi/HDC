package reception;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
 * Servlet implementation class EditRepeatTestServlet
 */
@WebServlet("/EditRepeatTestServlet")
public class EditRepeatTestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditRepeatTestServlet() {
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

		 String previous_lab_no = request.getParameter("lab_no");
		 String passport_no = request.getParameter("passport_no");
		 String medical_repeat = request.getParameter("medical_repeat");
		 String test_date = request.getParameter("test_date");
		 String medical_fee = request.getParameter("medical_fee");
		 String collection_date = request.getParameter("collection_date");
		 String repeattest_lab_no = request.getParameter("repeattest_lab_no");

		 String[] test_type_array = request.getParameterValues("test_type");

		 String test_type="";
		 
		 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		 SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	     Date parsed_test_date=null,parsed_collection_date=null;

		try {
			parsed_test_date = format1.parse(test_date);
			parsed_collection_date = format.parse(collection_date);

		
	        
//	     java.sql.Date test_date_sql = new java.sql.Date(parsed_test_date.getTime());
		     java.sql.Timestamp test_date_sql = new java.sql.Timestamp(parsed_test_date.getTime());

			java.sql.Date collection_date_sql = new java.sql.Date(parsed_collection_date.getTime());

	     
	     PreparedStatement stmt = null;    
		    String query = "";
	         ResultSet rs = null;  
	         System.out.println(previous_lab_no);
		     System.out.println(passport_no);
	         System.out.println(medical_repeat);
	         System.out.println(medical_fee);
	         System.out.println(test_date);
	         System.out.println(collection_date);
	         System.out.println(test_date_sql);
	         System.out.println(collection_date_sql);
	         System.out.println(repeattest_lab_no);
	         
	         System.out.println("Length"+repeattest_lab_no.length());
	         if(test_type_array!=null)
	        	 for (int i = 0; i < test_type_array.length; i++) 
	        	 {
	        		 System.out.println (test_type_array[i]);
	        		 test_type = test_type + test_type_array[i]+ " ";
	        	 }
	      	
	         if(previous_lab_no=="" || previous_lab_no.isEmpty() || previous_lab_no==null){
	        	  String test = "Failed to save record. Previous lab number cannot be null.";
	              response.sendRedirect("reception/repeattest.jsp?message="+test+"&passport="+passport_no); //logged-in page      		
	         
	         }

	         else if(repeattest_lab_no == null || repeattest_lab_no =="" || repeattest_lab_no.isEmpty()){

	        	 TestController tc = new TestController(con);
	        	 
	        	 System.out.println("Testing New Record");
	        	 	String lab_no = Long.toString(tc.getLatestLabNo());
	        	 	query = "INSERT INTO labtest (lab_no, date, medical, fee, collection_date, status, user_id , modification_date,passport_no, previous_lab_no, test_type) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
			        PreparedStatement statement=null;
			        
						statement = con.prepareStatement(query);
					
			        
			        	statement.setString(1, lab_no);
					
				        statement.setTimestamp(2, test_date_sql);
				        statement.setString(3, medical_repeat);
				        statement.setString(4, medical_fee);

				        statement.setDate(5, collection_date_sql);
				        statement.setString(6, "In Progress");
				        statement.setString(7, user.getUser_id());
				        statement.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
				        statement.setString(9, passport_no);
				        statement.setString(10, previous_lab_no);
					       
				        statement.setString(11, test_type);
					       
						   
				     
				        int row = statement.executeUpdate();
			            if (row > 0) {
			            	
			            	query = "INSERT INTO physician (lab_no, eye_left, eye_right, ear_left, ear_right, heart, height, weight,hernia, varicos_veins, extrenities, deformities, skin, user_id , modification_date, bp, comments) "
			            			+ "SELECT "+lab_no+", eye_left, eye_right, ear_left, ear_right, heart, height, weight,hernia, varicos_veins, extrenities, deformities, skin, user_id , modification_date, bp, comments "
			            				+ "FROM physician WHERE lab_no = ?";
			            	  
			            	    
			            	statement = con.prepareStatement(query);
			            	statement.setString(1, previous_lab_no);
			            	row = statement.executeUpdate();

			            	query = "INSERT INTO xray (lab_no, chest_xray, reason, user_id , modification_date, comments) "
		            			+ "SELECT "+lab_no+", chest_xray, reason, user_id , modification_date, comments "
		            			+ "FROM xray WHERE lab_no = ?";
		            	  
		            	    
					        statement = con.prepareStatement(query);
					        statement.setString(1, previous_lab_no);
					        row = statement.executeUpdate();
	
//					        query = "INSERT INTO blood_collection (lab_no, barcode_data, sample_date, user_id , modification_date) "
	//	            			+ "SELECT "+lab_no+", barcode_data, sample_date, user_id , modification_date "
		///            			+ "FROM blood_collection WHERE lab_no = ?";
		            	  
		            	    
			//		        statement = con.prepareStatement(query);
				//	        statement.setString(1, previous_lab_no);
					//        row = statement.executeUpdate();
	
					        query = "INSERT INTO lab_report (lab_no, sugar, albumin, bilharziasis, blood_group, hemoglobin, thick_film_for, malaria, micro_falria, helminthes, glardia, bilharziasis_culture, salmonella, cholera, hiv_ii, h_bs_ag, anti_hcv, rbs, lfts, bilrubin,  alt, alp, alb, rft, creatinine, tpha, user_id, modification_date, comments) "
		            			+ "SELECT "+lab_no+", sugar, albumin, bilharziasis, blood_group, hemoglobin, thick_film_for, malaria, micro_falria, helminthes, glardia, bilharziasis_culture, salmonella, cholera, hiv_ii, h_bs_ag, anti_hcv, rbs, lfts, bilrubin,  alt, alp, alb, rft, creatinine, tpha, user_id, modification_date, comments "
		            			+ "FROM lab_report WHERE lab_no = ?";
		            	  
		            	    
					        statement = con.prepareStatement(query);
					        statement.setString(1, previous_lab_no);
					        row = statement.executeUpdate();
	
				        
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
			                String test = "Test saved";
			            	response.sendRedirect("reception/repeattest.jsp?message="+test+"&passport="+passport_no); //logged-in page      		
			                System.out.println("Record saved into database");
			            }

			        

	         }
	         else{
	        	 	query = "UPDATE labtest set date=?, medical = ?, fee=?, collection_date=?, status = ?, user_id = ? , modification_date = ? , passport_no = ?, previous_lab_no =?, test_type=?  where lab_no = ?";
	        	 	PreparedStatement statement=null;
	        	 	System.out.println("Testing Update Record");

	        	 	statement = con.prepareStatement(query);
			
					
			        statement.setTimestamp(1, test_date_sql);
			        statement.setString(2, medical_repeat);
			        statement.setString(3, medical_fee);

			        statement.setDate(4, collection_date_sql);
			        statement.setString(5, "In Progress");
			        statement.setString(6, user.getUser_id());
			        statement.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
			        statement.setString(8, passport_no);

			        statement.setString(9, previous_lab_no);
				       
			        statement.setString(10, test_type);
				
			        statement.setString(11, repeattest_lab_no);
			    	  
			    	  int row = statement.executeUpdate();
			            
			    	  if (row > 0) {
			          
			    		  String test = "Test saved";
			              response.sendRedirect("reception/repeattest.jsp?message="+test+"&passport="+passport_no); //logged-in page      		
			              System.out.println("Record saved into database");
			            }    
	         }
	         

	         
		} catch (Exception e) {
			// TODO Auto-generated catch block1
			
			PrintWriter out = response.getWriter();
			out.print(e.getMessage());
			e.printStackTrace(out);

			e.printStackTrace();
		}
	}

}
