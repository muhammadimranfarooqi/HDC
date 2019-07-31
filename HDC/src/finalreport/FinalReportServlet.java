package finalreport;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;

/**
 * Servlet implementation class FinalReportServlet
 */
@WebServlet("/FinalReportServlet")
public class FinalReportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FinalReportServlet() {
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
		try {

			
			
			  HttpSession session = request.getSession(true);	    
				 Connection con = (Connection) session.getAttribute("connection");

				 
			//  UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
				 
			  String start_date = request.getParameter("start_date");
				 
			  String end_date = request.getParameter("end_date");
				 
			  String status = request.getParameter("status");
				 
			 // PrintWriter out = response.getWriter();
			 // out.print(start_date);
			//  out.print(end_date);
			//  out.print(user_id);

			  
		 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		 
		 
		 
	     Date from=null,to=null;
		
			from = format.parse(start_date);
			to = format.parse(end_date);

		     java.sql.Date fromDate = new java.sql.Date(from.getTime());
		     java.sql.Date toDate = new java.sql.Date(to.getTime());

		//        String reportLogo = getServletContext().getRealPath("/WEB-INF/reports/humna_logo.jpg"); 

      Map parameters = new HashMap();
      parameters.put("fromDate", fromDate);
      parameters.put("toDate", toDate);
    //  parameters.put("reportLogo", reportLogo);
      JasperPrint jasperPrint;

      if (status.equalsIgnoreCase("All"))
      {

      	
      	String filepath = session.getServletContext().getRealPath("/WEB-INF/reports/finalreportsearch.jasper");

    //  InputStream input =  getClass().getResourceAsStream("/report/dailyreport.jasper");
      	InputStream input = new FileInputStream(new File (filepath));
      jasperPrint = JasperFillManager.fillReport(input, parameters, con);
	
   //   JasperExportManager.exportReportToPdfFile(jasperPrint,"f:/output/samplereport.pdf");
      }
      else{
      	String filepath = session.getServletContext().getRealPath("/WEB-INF/reports/finalreportsearch_user.jasper");
      	InputStream input = new FileInputStream(new File (filepath));

      	parameters.put("status", status);
      	
           jasperPrint = JasperFillManager.fillReport(input, parameters, con);
   		
      }
      response.setContentType("application/pdf");

     JasperExportManager.exportReportToPdfStream(jasperPrint,response.getOutputStream());
     response.getOutputStream().flush();
     response.getOutputStream().close();

    //  JasperViewer visor = new JasperViewer(jasperPrint,false) ;
      
     // visor.setVisible(true);
     
  	//response.sendRedirect("reception/dailyreport.jsp"); //logged-in page      		

      
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			PrintWriter out = response.getWriter();
			out.print(e.getMessage());
			e.printStackTrace(out);

		}	}

}
