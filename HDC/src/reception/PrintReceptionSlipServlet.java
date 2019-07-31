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
@WebServlet("/PrintReceptionSlipServlet")
public class PrintReceptionSlipServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PrintReceptionSlipServlet() {
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

			String lab_no = request.getParameter("lab_no");
			
			String urdu = getServletContext().getRealPath("/WEB-INF/reports/urdu.png"); 
	
			
			TestController tc = new TestController(con);
			
			
			
			Map parameters = new HashMap();
			parameters.put("lab_no", lab_no);
			parameters.put("serial_number", Integer.toString(tc.getSerialNo(lab_no)));
			parameters.put("urdu", urdu);
//			parameters.put("serial_number", (tc.getSerialNo(lab_no)));
	//		parameters.put("reportLogo", reportLogo);
			
			JasperPrint jasperPrint;
        	
			String filepath = session.getServletContext().getRealPath("/WEB-INF/reports/reception_print.jasper");
        	InputStream input = new FileInputStream(new File (filepath));

        	String dirpath = session.getServletContext().getRealPath("/WEB-INF/reports/");
			
			parameters.put("SUBREPORT_DIR", dirpath);
		
			jasperPrint = JasperFillManager.fillReport(input, parameters, con);
	
			 response.setContentType("application/pdf");

		       JasperExportManager.exportReportToPdfStream(jasperPrint,response.getOutputStream());
		       response.getOutputStream().flush();
		       response.getOutputStream().close();

		//	JasperViewer visor = new JasperViewer(jasperPrint,false) ;
	
		//	visor.setVisible(true);
	
		//	response.sendRedirect("reception/receptiontest.jsp"); //logged-in page      		
	

		} catch (Exception e) {
		// TODO Auto-generated catch block
			PrintWriter out = response.getWriter();
			out.print(e.getMessage());
			e.printStackTrace(out);

			
			e.printStackTrace();
			}
	}

}
