package labreport;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import login.UserBean;
import bloodcollection.BloodCollectionController;

/**
 * Servlet implementation class EditLabReportServlet
 */
@WebServlet("/EditLabReportServlet")
public class EditLabReportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditLabReportServlet() {
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
	       	
		 String sugar="", albumin="", bilharziasis="", blood_group="", hemoglobin="", thick_film_for="", malaria="", micro_falria="",
				 helminthes="", glardia="", bilharziasis_culture="", salmonella="", cholera="", hiv_ii="", h_bs_ag="", anti_hcv="",
				 rbs="", lfts="", bilrubin="", alt="", alp="", alb="", rft="", creatinine="", tpha="", comments="";
	 
		 String barcode_data="",lab_no="";
	       	lab_no = request.getParameter("lab_no");
	       	sugar = request.getParameter("sugar");
	       	albumin = request.getParameter("albumin");
	       	bilharziasis = request.getParameter("bilharziasis");
	       	blood_group = request.getParameter("blood_group");
	       	hemoglobin = request.getParameter("hemoglobin");
	       	thick_film_for = request.getParameter("thick_film_for");
	       	malaria = request.getParameter("malaria");
	       	micro_falria = request.getParameter("micro_falria");
	       	helminthes = request.getParameter("helminthes");
	       	glardia = request.getParameter("glardia");
	       	bilharziasis_culture = request.getParameter("bilharziasis_culture");
	       	salmonella = request.getParameter("salmonella");
	       	cholera = request.getParameter("cholera");
	       	hiv_ii = request.getParameter("hiv_ii");
	       	h_bs_ag = request.getParameter("h_bs_ag");
	       	anti_hcv = request.getParameter("anti_hcv");
	       	rbs = request.getParameter("rbs");
	       	lfts = request.getParameter("lfts");
	       	bilrubin = request.getParameter("bilrubin");
	       	alt = request.getParameter("alt");
	       	alp = request.getParameter("alp");
	       	alb = request.getParameter("alb");
	       	rft = request.getParameter("rft");
	       	creatinine = request.getParameter("creatinine");
	       	tpha = request.getParameter("tpha");
	  	       	
	       	comments = request.getParameter("comments");
	       	
	       

	     
         String query = "";
         ResultSet rs = null;  
	      
         PreparedStatement stmt = null;    
    	 Connection con = (Connection) session.getAttribute("connection");
		 
    	 LabReportController controller = new LabReportController(con);
		 try {
			 
         if(!controller.checkLabNo(lab_no)){
        	 
        	 query = "INSERT INTO lab_report (lab_no, sugar, albumin, bilharziasis, blood_group, hemoglobin,"
        	 		+ " thick_film_for, malaria, micro_falria, helminthes, glardia, bilharziasis_culture,"
        	 		+ " salmonella, cholera, hiv_ii, h_bs_ag, anti_hcv, rbs, lfts, bilrubin,  alt, alp, alb,"
        	 		+ " rft, creatinine, tpha, user_id, modification_date, comments)  VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		        PreparedStatement statement=null;
		        
					statement = con.prepareStatement(query);
				
		        	statement.setString(1, lab_no);
		        	statement.setString(2, sugar);
		        	statement.setString(3, albumin);
		        	statement.setString(4, bilharziasis);
		        	statement.setString(5, blood_group);
		        	statement.setString(6, hemoglobin);
		        	statement.setString(7, thick_film_for);
		        	statement.setString(8, malaria);
		        	statement.setString(9, micro_falria);
		        	statement.setString(10, helminthes);
		        	statement.setString(11, glardia);
		        	statement.setString(12, bilharziasis_culture);
		        	statement.setString(13, salmonella);
		        	statement.setString(14, cholera);
		        	statement.setString(15, hiv_ii);
		        	statement.setString(16, h_bs_ag);
		        	statement.setString(17, anti_hcv);
		        	statement.setString(18, rbs);
		        	statement.setString(19, lfts);
		        	statement.setString(20, bilrubin);
		        	statement.setString(21, alt);
		        	statement.setString(22, alp);
		        	statement.setString(23, alb);
		        	statement.setString(24, rft);
		        	statement.setString(25, creatinine);
		        	statement.setString(26, tpha);
		        	statement.setString(27, user.getUser_id());
		        	statement.setTimestamp(28, new Timestamp(System.currentTimeMillis()));
		    		    				
		        	statement.setString(29, comments);
			     
			        int row = statement.executeUpdate();
		            if (row > 0) {
		                String test = "Test saved";
		            	response.sendRedirect("labreport/labreport.jsp?message="+test+"&search="+lab_no); //logged-in page      		
		                System.out.println("Record saved into database");
		            }

		        

         }
         else{
	    	  query = "UPDATE lab_report set  sugar=?, albumin=?, bilharziasis=?, blood_group=?, hemoglobin=?, thick_film_for=?, malaria=?, micro_falria=?, helminthes=?, glardia=?, bilharziasis_culture=?, salmonella=?, cholera=?, hiv_ii=?, h_bs_ag=?, anti_hcv=?, rbs=?, lfts=?, bilrubin=?,  alt=?, alp=?, alb=?, rft=?, creatinine=?, tpha=?, user_id=?, modification_date=? , comments = ? where lab_no = ?";
	    	  PreparedStatement statement=null;

			  statement = con.prepareStatement(query);
		
				
	        	statement.setString(1, sugar);
	        	statement.setString(2, albumin);
	        	statement.setString(3, bilharziasis);
	        	statement.setString(4, blood_group);
	        	statement.setString(5, hemoglobin);
	        	statement.setString(6, thick_film_for);
	        	statement.setString(7, malaria);
	        	statement.setString(8, micro_falria);
	        	statement.setString(9, helminthes);
	        	statement.setString(10, glardia);
	        	statement.setString(11, bilharziasis_culture);
	        	statement.setString(12, salmonella);
	        	statement.setString(13, cholera);
	        	statement.setString(14, hiv_ii);
	        	statement.setString(15, h_bs_ag);
	        	statement.setString(16, anti_hcv);
	        	statement.setString(17, rbs);
	        	statement.setString(18, lfts);
	        	statement.setString(19, bilrubin);
	        	statement.setString(20, alt);
	        	statement.setString(21, alp);
	        	statement.setString(22, alb);
	        	statement.setString(23, rft);
	        	statement.setString(24, creatinine);
	        	statement.setString(25, tpha);
	        	statement.setString(26, user.getUser_id());
	        	statement.setTimestamp(27, new Timestamp(System.currentTimeMillis()));
	        	statement.setString(28, comments);

	        	statement.setString(29, lab_no);

	           	
		    	  int row = statement.executeUpdate();
		            
		    	  if (row > 0) {
		          
		    		  String test = "Test saved";
		              response.sendRedirect("labreport/labreport.jsp?message="+test+"&search="+lab_no); //logged-in page      		
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
