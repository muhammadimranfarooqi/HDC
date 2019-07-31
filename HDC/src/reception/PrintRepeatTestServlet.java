package reception;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
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
import net.sf.jasperreports.view.JasperViewer;

/**
 * Servlet implementation class PrintReceptionSlipServlet
 */
@WebServlet("/PrintRepeatTestServlet")
public class PrintRepeatTestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PrintRepeatTestServlet() {
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
		try{
			  HttpSession session = request.getSession(true);	    
				 Connection con = (Connection) session.getAttribute("connection");

			String lab_no = request.getParameter("repeattest_lab_no");
			
		//	String reportLogo = getServletContext().getRealPath("/WEB-INF/reports/humna_logo.jpg"); 
	
			Map parameters = new HashMap();
			parameters.put("lab_no", lab_no);
	//		parameters.put("reportLogo", reportLogo);
			
			JasperPrint jasperPrint;
String dirpath = session.getServletContext().getRealPath("/WEB-INF/reports/");
			
			parameters.put("SUBREPORT_DIR", dirpath);
		
			String filepath = session.getServletContext().getRealPath("/WEB-INF/reports/repeattest_print.jasper");
        	InputStream input = new FileInputStream(new File (filepath));

	
			jasperPrint = JasperFillManager.fillReport(input, parameters, con);
	
			 response.setContentType("application/pdf");

		       JasperExportManager.exportReportToPdfStream(jasperPrint,response.getOutputStream());
		       response.getOutputStream().flush();
		       response.getOutputStream().close();

		//	JasperViewer visor = new JasperViewer(jasperPrint,false) ;
	
		//	visor.setVisible(true);
	
		//	response.sendRedirect("reception/receptiontest.jsp"); //logged-in page      		
	

		} catch (Exception e) {
			PrintWriter out = response.getWriter();
			out.print(e.getMessage());
			e.printStackTrace(out);
			e.printStackTrace();
			}
	}

}
