package reception;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

import login.UserBean;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.view.JasperViewer;

/**
 * Servlet implementation class DailyReportServlet
 */
@WebServlet("/DailyReportServlet")
public class DailyReportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DailyReportServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			
			
			  HttpSession session = request.getSession(true);	    
				 Connection con = (Connection) session.getAttribute("connection");

				 
			  UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
				 
			  String start_date = request.getParameter("start_date");
				 
			  String end_date = request.getParameter("end_date");
				 
			  String user_id = request.getParameter("userslist");
		
			  String test_type = request.getParameter("test_type");
				
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

		        //String reportLogo = getServletContext().getRealPath("/WEB-INF/reports/humna_logo.jpg"); 

        Map parameters = new HashMap();
        parameters.put("fromDate", fromDate);
        parameters.put("toDate", toDate);
      
        
    	parameters.put("user_name", user.getUsername());

       // parameters.put("reportLogo", reportLogo);
        JasperPrint jasperPrint;

        if (user_id==null || user_id=="" || user_id.isEmpty())
        {
        	String filepath=null;

            if(test_type.equalsIgnoreCase("all_tests"))

            	filepath = session.getServletContext().getRealPath("/WEB-INF/reports/dailyreport.jasper");
            else if(test_type.equalsIgnoreCase("new_tests"))
            	filepath = session.getServletContext().getRealPath("/WEB-INF/reports/dailyreport_new.jasper");

                else
                	filepath = session.getServletContext().getRealPath("/WEB-INF/reports/dailyreport_repeat.jasper");

      //  InputStream input =  getClass().getResourceAsStream("/report/dailyreport.jasper");
        	InputStream input = new FileInputStream(new File (filepath));
        jasperPrint = JasperFillManager.fillReport(input, parameters, con);
	
     //   JasperExportManager.exportReportToPdfFile(jasperPrint,"f:/output/samplereport.pdf");
        }
        else{
        	String filepath = session.getServletContext().getRealPath("/WEB-INF/reports/dailyreport_user_new.jasper");
        	InputStream input = new FileInputStream(new File (filepath));

        	parameters.put("user_id", user_id);
        	
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

		}
	}

}
