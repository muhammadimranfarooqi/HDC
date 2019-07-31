package physician;

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

/**
 * Servlet implementation class EditPhysicianServlet
 */
@WebServlet("/EditPhysicianServlet")
public class EditPhysicianServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditPhysicianServlet() {
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

	       	String eye_left="",eye_right="",ear_left="",ear_right="",bp="",heart="",height="",weight="",hernia="",varicos_veins="",extrenities="",deformities="", skin="", comments = "";

	       	String lab_no = request.getParameter("lab_no");
			eye_left = request.getParameter("eye_left");
			eye_right = request.getParameter("eye_right");
			ear_left = request.getParameter("ear_left");
			ear_right = request.getParameter("ear_right");
			bp = request.getParameter("bp");
			heart = request.getParameter("heart");
			height = request.getParameter("height");
			weight = request.getParameter("weight");
			hernia = request.getParameter("hernia");
			varicos_veins = request.getParameter("varicos_veins");
			extrenities = request.getParameter("extrenities");
			deformities = request.getParameter("deformities");
			skin = request.getParameter("skin");
 
			comments = request.getParameter("comments");

	        PhysicianController pc = new PhysicianController(con);

	     System.out.println(lab_no);
	     System.out.println(eye_left);
	     System.out.println(eye_right);
	     System.out.println(ear_right);
	     System.out.println(bp);
	     System.out.println(heart);
	     System.out.println(height);
	     System.out.println(weight);
	     System.out.println(hernia);
	     System.out.println(varicos_veins);
	     System.out.println(extrenities);
	     System.out.println(deformities);
	     System.out.println(skin);
	     
         String query = "";
         ResultSet rs = null;  
	      
         PreparedStatement stmt = null;    
		 try {
			 
         if(!pc.checkLabNo(lab_no)){
        	 TestController tc = new TestController(con);
        	 
        	 query = "INSERT INTO physician (lab_no, eye_left, eye_right, ear_left, ear_right, heart, height, weight,hernia, varicos_veins, extrenities, deformities, skin, user_id , modification_date, bp, comments) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		        PreparedStatement statement=null;
		        
					statement = con.prepareStatement(query);
				
		        	statement.setString(1, lab_no);
		           	statement.setString(2, eye_left);
		           	statement.setString(3, eye_right);
		           	statement.setString(4, ear_right);
		           	statement.setString(5, ear_right);
		           	statement.setString(6, heart);
		           	statement.setString(7, height);
		           	statement.setString(8, weight);
		           	statement.setString(9, hernia);
		           	statement.setString(10, varicos_veins);
		           	statement.setString(11, extrenities);
		           	statement.setString(12, deformities);
		           	statement.setString(13, skin);
    		        statement.setString(14, user.getUser_id());
    		        statement.setTimestamp(15, new Timestamp(System.currentTimeMillis()));
		           	statement.setString(16, bp);
		           	statement.setString(17, comments);

			     
			        int row = statement.executeUpdate();
		            if (row > 0) {
		                String test = "Test saved";
		            	response.sendRedirect("physician/physicianhome.jsp?message="+test+"&search="+lab_no); //logged-in page      		
		                System.out.println("Record saved into database");
		            }

		        

         }
         else{
	    	  query = "UPDATE physician set eye_left = ? , eye_right = ? , ear_left = ? , ear_right = ? , heart = ? , height = ? , weight = ? , hernia = ? , varicos_veins = ? , extrenities = ? , deformities = ? , skin = ? , user_id = ? , modification_date = ? , bp = ?, comments = ?  where lab_no = ?";
	    	  PreparedStatement statement=null;
		        
			  statement = con.prepareStatement(query);
		
				
		       	statement.setString(1, eye_left);
	           	statement.setString(2, eye_right);
	           	statement.setString(3, ear_right);
	           	statement.setString(4, ear_right);
	           	statement.setString(5, heart);
	           	statement.setString(6, height);
	           	statement.setString(7, weight);
	           	statement.setString(8, hernia);
	           	statement.setString(9, varicos_veins);
	           	statement.setString(10, extrenities);
	           	statement.setString(11, deformities);
	           	statement.setString(12, skin);
		        statement.setString(13, user.getUser_id());
		        statement.setTimestamp(14, new Timestamp(System.currentTimeMillis()));
	           	statement.setString(15, bp);
	           	statement.setString(16, comments);

	           	statement.setString(17, lab_no);
	    	  
		    	  int row = statement.executeUpdate();
		            
		    	  if (row > 0) {
		          
		    		  String test = "Test saved";
		              response.sendRedirect("physician/physicianhome.jsp?message="+test+"&search="+lab_no); //logged-in page      		
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


