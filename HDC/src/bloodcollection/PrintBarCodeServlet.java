package bloodcollection;

import java.io.ByteArrayInputStream;
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

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;

/**
 * Servlet implementation class PrintBarCodeServlet
 */
@WebServlet("/PrintBarCodeServlet")
public class PrintBarCodeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PrintBarCodeServlet() {
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
		//PrintWriter out=response.getWriter();
		  HttpSession session = request.getSession(true);	    

		String barcode_data =  request.getParameter("barcode_data");
		// String base64Image = barcode_image.split(",")[1];
		// byte[] imageBytes = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64Image);
		 
		// InputStream in = new ByteArrayInputStream(imageBytes);
	
		 Map parameters = new HashMap();
			parameters.put("barcode", barcode_data);
			String filepath = session.getServletContext().getRealPath("/WEB-INF/reports/printbarcode.jasper");
        	InputStream input = new FileInputStream(new File (filepath));
			JasperPrint jasperPrint;

			 Connection con = (Connection) session.getAttribute("connection");

	
			try {
				jasperPrint = JasperFillManager.fillReport(input, parameters, con);
			
			 response.setContentType("application/pdf");

		       JasperExportManager.exportReportToPdfStream(jasperPrint,response.getOutputStream());
		       response.getOutputStream().flush();
		       response.getOutputStream().close();
			} catch (JRException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				PrintWriter out = response.getWriter();
				out.print(e.getMessage());
				e.printStackTrace(out);

			}
	
		
//		out.print("<img src="+barcode_image+" style='width: 100px; height: 50px; border:1px solid #000000;' />");

	
	}

}
