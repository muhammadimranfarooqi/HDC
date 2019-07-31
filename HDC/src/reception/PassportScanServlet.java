package reception;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;






import javax.servlet.http.HttpSession;


/**
 * Servlet implementation class imageServlet
 */
@WebServlet("/PassportScanServlet")
public class PassportScanServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	   static ResultSet rs = null;  
		
		
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PassportScanServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	      Statement stmt = null;    
	 	 HttpSession session = request.getSession(true);	    
		 Connection con = (Connection) session.getAttribute("connection");

	      String sql=null;
	    	
	      BufferedInputStream bin=null;
	    	
	      BufferedOutputStream bout=null;
	    	
	      InputStream in =null;

	    	
	      response.setContentType("image/jpeg");  
	    	
	      ServletOutputStream out;  
	    	    
	      out = response.getOutputStream();  
	    	            
		String passport = request.getParameter("passport");
		String query = "select * from profile where passport='"
	                     + passport
	                     + "'";
		 try 
		   {
		      //connect to DB 
		      stmt=con.createStatement();
		      rs = stmt.executeQuery(query);	        
		      boolean more = rs.next();
		      if(more){
		    	  in = rs.getBinaryStream("passport_scan");
		    	  //OutputStream output = response.getOutputStream();
		    	  
		    	  bin = new BufferedInputStream(in);  
  	            	bout = new BufferedOutputStream(out);  
  	            	int ch=0;   
  	            	while((ch=bin.read())!=-1)  
  	            		bout.write(ch);  
  	            	  
        	      }
		      
		   }
		 catch(Exception e){
				PrintWriter out1 = response.getWriter();
				out1.print(e.getMessage());
				e.printStackTrace(out1);

		   }	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
