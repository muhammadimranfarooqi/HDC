package reception;


import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
 

import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import login.UserBean;
/**
 * Servlet implementation class EditProfile
 */
@WebServlet("/EditProfileServlet")
@MultipartConfig(maxFileSize = 16177215)

public class EditProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditProfileServlet() {
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

		 String data = request.getParameter("image");
		 
		 String base64Image = data.split(",")[1];
		 byte[] imageBytes = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64Image);
		// BufferedImage img = ImageIO.read(new ByteArrayInputStream(imageBytes));

		 String finger_data = request.getParameter("min");

		 byte[] finger_imageBytes = javax.xml.bind.DatatypeConverter.parseBase64Binary(finger_data);
		// BufferedImage finger_img = ImageIO.read(new ByteArrayInputStream(finger_imageBytes));

		 
		 String passport_no = request.getParameter("passport_no");
		 String name = request.getParameter("name");
		 String agency = request.getParameter("agency");
		 
		 
		 String father_name = request.getParameter("father_name");
		 
		 String father_husband = request.getParameter("father_husband");
		 
		 String profession = request.getParameter("profession");
		 String dob = request.getParameter("dob");
		 String nationality = request.getParameter("nationality");
		 String cnic = request.getParameter("cnic");
		 String gamca_no = request.getParameter("gamca_no");
		 String gender = request.getParameter("gender");
		 String maritalstatus = request.getParameter("maritalstatus");
		 String issue_date = request.getParameter("issue_date");
		 String country = request.getParameter("country");
		 String expiry_date = request.getParameter("expiry_date");
		 String issue_place = request.getParameter("issue_place");
	
		 String phone_number = request.getParameter("phone_number");
			
		 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	     Date parsed_dob=null,parsed_issue=null,parsed_expiry=null;
		try {
			parsed_dob = format.parse(dob);
			parsed_issue = format.parse(issue_date);
			parsed_expiry = format.parse(expiry_date);

		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	        
	     java.sql.Date dobsql = new java.sql.Date(parsed_dob.getTime());
	     java.sql.Date issue_datesql = new java.sql.Date(parsed_issue.getTime());
	     java.sql.Date expiry_datesql = new java.sql.Date(parsed_expiry.getTime());

         System.out.println(data);
         System.out.println(finger_data);
         System.out.println(imageBytes);
         System.out.println(finger_imageBytes);


         System.out.println(passport_no);
         System.out.println(name);
         System.out.println(agency);
         System.out.println(father_name);
         System.out.println(profession);
         System.out.println(dobsql);
         System.out.println(nationality);
         System.out.println(cnic);
         System.out.println(gamca_no);
         System.out.println(gender);
         System.out.println(maritalstatus);
         System.out.println(issue_date);
         System.out.println(country);

         System.out.println(expiry_date);
         System.out.println(issue_place);

		 
		 InputStream passport_file = null, live_pict=null, scan_pict=null; // input stream of the upload file
		 
		 
	        // obtains the upload file part in this multipart request
	        Part filePart = request.getPart("passport_file");
	        if (filePart != null) {
	            // prints out some information for debugging
	            System.out.println(filePart.getName());
	            System.out.println(filePart.getSize());
	             
	            // obtains input stream of the upload file
	            passport_file = filePart.getInputStream();
	        }
	        
	        Part filePart1 = request.getPart("canvas");
	        if (filePart1 != null) {
	            // prints out some information for debugging
	            System.out.println(filePart1.getName());
	            System.out.println(filePart1.getSize());
	             
	            // obtains input stream of the upload file
	            live_pict = filePart1.getInputStream();
	        }
	        
	        Part filePart2 = request.getPart("scan_pict");
	        if (filePart2 != null) {
	            // prints out some information for debugging
	            System.out.println(filePart2.getName());
	            System.out.println(filePart2.getSize());
	             
	            // obtains input stream of the upload file
	            scan_pict = filePart2.getInputStream();
	        }
	        
	        
            ProfileController pfc = new ProfileController(con);

	        
	    	String query = "select * from profile where passport='"+ passport_no + "'";
	 try 
	   {
		   
		  ResultSet rs = null;  
	      Statement stmt = null;    
	      
	      stmt = con.createStatement();
	      rs = stmt.executeQuery(query);	        
	      boolean more = rs.next();
	      
	      if(more){
	    	  query = "UPDATE profile set name=?, father_name = ?, dob=?, cnic=?, gamca_no = ?, gender = ? , marital_status = ? , issue_date = ?, expiry_date = ?, issue_place = ? , agency_id = ?,  profession_id = ? , nationality = ? , dest_country = ? , live_picture = ?,  passport_scan = ?, finger_print = ? , user_id = ? , modification_date = ? , scan_picture = ?, father_husband=?, phone_number=? where passport = ?";
		        PreparedStatement statement=null;
		        statement = con.prepareStatement(query);
			        statement.setString(1, name);
			        statement.setString(2, father_name);
			        statement.setDate(3, dobsql);
			        statement.setString(4, cnic);
			        statement.setString(5, gamca_no);
			        statement.setString(6, gender);
			        statement.setString(7, maritalstatus);
			        statement.setDate(8, issue_datesql);
			        statement.setDate(9, expiry_datesql);
			        statement.setString(10, issue_place);
			        statement.setString(11, pfc.getAgencyID(agency));
			        statement.setString(12, pfc.getProfessionID(profession));
			        statement.setString(13, nationality);
			        statement.setString(14, pfc.getCountryID(country));

			        
			      //  if (scan_pict != null) {
		                // fetches input stream of the upload file for the blob column
		          //      statement.setBinaryStream(14, scan_pict,scan_pict.available());
		          //  }
			       // else
//		                statement.setBinaryStream(15, null,0);

			   
			        statement.setBytes(15, imageBytes);
			        if (passport_file != null) {
	                // fetches input stream of the upload file for the blob column
			        	statement.setBinaryStream(16, passport_file,passport_file.available());
			        }
			        else
			        	statement.setBinaryStream(16, null,0);

			     //   if (passport_file != null) {
		                // fetches input stream of the upload file for the blob column
				  //      	statement.setBinaryStream(16, passport_file,passport_file.available());
				 ////     else
			      //  statement.setBytes(17, finger_imageBytes);
			        statement.setString(17, finger_data);
	//			        statement.setBinaryStream(17, null,0);
			        
			        statement.setString(18, user.getUser_id());
			        
			        statement.setTimestamp(19, new Timestamp(System.currentTimeMillis()));

			        if (scan_pict != null) {
		                // fetches input stream of the upload file for the blob column
				        	statement.setBinaryStream(20, scan_pict,scan_pict.available());
				        }
				        else
				        statement.setBinaryStream(20, null,0);
			        
			     
			        statement.setString(21, father_husband);
			        statement.setString(22, phone_number);
		             
			        statement.setString(23, passport_no);
	             
	           
	 
	            // sends the statement to the database server
	            int row = statement.executeUpdate();
	            if (row > 0) {
	            	pfc.populateMaps();

	                String test = "Profile updated";
	            	response.sendRedirect("reception/receptiontest.jsp?message="+test+"&passport="+passport_no); //logged-in page      		

	                System.out.println("File uploaded and saved into database");
	            }

	      }
	      else{
	    	  query = "INSERT INTO profile (passport, name, father_name, dob, cnic, gamca_no, gender , marital_status , issue_date, expiry_date, issue_place , agency_id,  profession_id , nationality , dest_country , live_picture,  passport_scan, finger_print , user_id , modification_date , scan_picture, father_husband, phone_number) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		        PreparedStatement statement=null;
		        statement = con.prepareStatement(query);

		        
		        	statement.setString(1, passport_no);
				
			        statement.setString(2, name);
			        statement.setString(3, father_name);
			        statement.setDate(4, dobsql);
			        statement.setString(5, cnic);
			        statement.setString(6, gamca_no);
			        statement.setString(7, gender);
			        statement.setString(8, maritalstatus);
			        statement.setDate(9, issue_datesql);
			        statement.setDate(10, expiry_datesql);
			        statement.setString(11, issue_place);
			        statement.setString(12, pfc.getAgencyID(agency));
			        statement.setString(13, pfc.getProfessionID(profession));
			        statement.setString(14, nationality);
			        statement.setString(15, pfc.getCountryID(country));

			        
			      //  if (scan_pict != null) {
		                // fetches input stream of the upload file for the blob column
		          //      statement.setBinaryStream(14, scan_pict,scan_pict.available());
		          //  }
			       // else
		       //         statement.setBinaryStream(16, null,0);
				        statement.setBytes(16, imageBytes);

			        
			        if (passport_file != null) {
	                // fetches input stream of the upload file for the blob column
			        	statement.setBinaryStream(17, passport_file,passport_file.available());
			        }
			        else
			        	statement.setBinaryStream(17, null,0);

			     //   if (passport_file != null) {
		                // fetches input stream of the upload file for the blob column
				  //      	statement.setBinaryStream(16, passport_file,passport_file.available());
				 ////     else
//				        statement.setBinaryStream(18, null,0);
//			        statement.setBytes(18, finger_imageBytes);
			        statement.setString(18, finger_data);
			        statement.setString(19, user.getUser_id());
			        
			        statement.setTimestamp(20, new Timestamp(System.currentTimeMillis()));

			        if (scan_pict != null) {
		                // fetches input stream of the upload file for the blob column
				        	statement.setBinaryStream(21, scan_pict,scan_pict.available());
				        }
				        else
				        statement.setBinaryStream(21, null,0);
			        statement.setString(22, father_husband);
		                     
			        statement.setString(23, phone_number);
	           
	 
	            // sends the statement to the database server
	            int row = statement.executeUpdate();
	            if (row > 0) {
	            	pfc.populateMaps();
	            	String test = "Profile saved";
	            	response.sendRedirect("reception/receptiontest.jsp?message="+test+"&passport="+passport_no); //logged-in page      		
	                System.out.println("Record saved into database");
	            }

	      }
	        
	        		
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				PrintWriter out = response.getWriter();
				out.print(e.getMessage());
				e.printStackTrace(out);

			}
		// TODO Auto-generated method stub
	}

}
