package bloodcollection;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import login.UserBean;
import net.sourceforge.barbecue.*; 

/**
 * Servlet implementation class BarcodePrintServlet
 */
@WebServlet("/GenerateBarcodeServlet")
public class GenerateBarcodeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GenerateBarcodeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
		PrintWriter out=response.getWriter();
		Random random = new Random(System.nanoTime());

		int randomInt = random.nextInt(1000000000);
		 HttpSession session = request.getSession(true);	    
		 Connection con = (Connection) session.getAttribute("connection");
			BloodCollectionController bcc = new BloodCollectionController(con);
			
			boolean exists =true;
			
			while(exists){
			
				if(	bcc.checkBarCode(Integer.toString(randomInt)))
					{
					randomInt = random.nextInt(1000000000);
					}
				else
					exists = false;
			}
			Barcode b = BarcodeFactory.createCode39(Integer.toString(randomInt),true);
			BufferedImage img = BarcodeImageHandler.getImage(b);			
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ImageIO.write( img, "jpg", baos );
			baos.flush();
			byte[] imageInByteArray = baos.toByteArray();
			baos.close();
			String b64 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
			
			out.print("<div class='col-sm-3' >");
	     	out.print("<input type='text' class='form-control' name='barcode_data' readonly value = "+randomInt+" />");
	     	out.print("</div>");
	     	out.print("<div class='col-sm-1' >");
	     	out.print("</div>");
	     	
	     	out.print("<div class='col-sm-12' >");
	     	out.print("</div>");
	     	out.print("<div class='col-sm-1' >");
	     	out.print("</div>");
	     	
			out.print("<div class='col-sm-4' id ='barcode_print'>");
			out.print("<img src='data:image/png;base64,"+b64+"' style='width: 250px; height: 100px; border:1px solid #000000;' />");
	     	out.print("</div>");
			out.print("<div class='col-sm-3'  >");
	     	out.print("<button class='btn btn-lg btn-success' type='button' onClick='generateBarcode()'>Generate Barcode</button>");
	     	out.print("</div>");
	     	
	     	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			PrintWriter out = response.getWriter();
			out.print(e.getMessage());
			e.printStackTrace(out);

		}


	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
