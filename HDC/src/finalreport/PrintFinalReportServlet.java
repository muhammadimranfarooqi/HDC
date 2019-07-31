package finalreport;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
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

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

/**
 * Servlet implementation class PrintFinalReportServlet
 */
@WebServlet("/PrintFinalReportServlet")
public class PrintFinalReportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PrintFinalReportServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try{
			  HttpSession session = request.getSession(true);	    

			String lab_no = request.getParameter("search");
			

			 Connection con = (Connection) session.getAttribute("connection");

			Map parameters = new HashMap();
			parameters.put("lab_no", lab_no);
			
			JasperPrint jasperPrint;
    	
			String filepath = session.getServletContext().getRealPath("/WEB-INF/reports/finalreport.jasper");
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
		// TODO Auto-generated catch block
			e.printStackTrace();
			}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try{
			  HttpSession session = request.getSession(true);	    

			String lab_no = request.getParameter("search");

			 Connection con = (Connection) session.getAttribute("connection");

			Map parameters = new HashMap();
			parameters.put("lab_no", lab_no);
			
			JasperPrint jasperPrint;
      	
			String filepath = session.getServletContext().getRealPath("/WEB-INF/reports/finalreport.jasper");
			
			String dirpath = session.getServletContext().getRealPath("/WEB-INF/reports/");
			parameters.put("SUBREPORT_DIR", dirpath);
			InputStream input = new FileInputStream(new File (filepath));
   //   	JasperDesign jasperDesign = JRXmlLoader.load(input);
    //  	JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);
		//jasperPrint = JasperFillManager.fillReport(input, parameters, con);

	
	
		jasperPrint = JasperFillManager.fillReport(input, parameters, con);
		
		 response.setContentType("application/pdf");

	       JasperExportManager.exportReportToPdfStream(jasperPrint,response.getOutputStream());
	       response.getOutputStream().flush();
	       response.getOutputStream().close();
       // byte[] byteStream;

      //	byteStream = JasperRunManager.runReportToPdf(jasperReport,      parameters, con);

            /**
             * Set output Stream in response.
             */    
      //	OutputStream outStream;
       //  String DOWNLOAD_FILE_NAME = "REPORT.pdf";

       //     outStream = response.getOutputStream();
       //     response.setHeader("Content-Disposition", "inline; filename=" + DOWNLOAD_FILE_NAME);
    	//	response.setContentType("application/pdf");
      //      response.setContentLength(byteStream.length);
     //       outStream.write(byteStream, 0, byteStream.length);

		//	JasperViewer visor = new JasperViewer(jasperPrint,false) ;
	
		//	visor.setVisible(true);
	
		//	response.sendRedirect("reception/receptiontest.jsp"); //logged-in page      		
	

		} catch (Exception e) {
		// TODO Auto-generated catch block
			e.printStackTrace();
			PrintWriter out = response.getWriter();
			out.print(e.getMessage());
			e.printStackTrace(out);

			}
	}

}
