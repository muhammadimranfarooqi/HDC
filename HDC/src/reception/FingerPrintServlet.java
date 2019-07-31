package reception;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import SecuGen.FDxSDKPro.jni.*;
import java.awt.image.*; 
import java.io.*;
import javax.imageio.ImageIO;
/**
 * Servlet implementation class FingerPrintServlet
 */
@WebServlet("/FingerPrintServlet")
public class FingerPrintServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FingerPrintServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out=response.getWriter();
		
		  long deviceName;
long devicePort;
JSGFPLib fplib = null;  
long ret;
boolean bLEDOn;
byte[] regMin1 = new byte[4000000];
//  byte[] regMin2 = new byte[400];
SGDeviceInfoParam deviceInfo = new SGDeviceInfoParam();
BufferedImage imgRegistration1;
// BufferedImage imgRegistration2;
boolean r1Captured = false;
//  boolean r2Captured = false;
String b64_1="", b64="";
fplib = new JSGFPLib();

ret = fplib.Init(SGFDxDeviceName.SG_DEV_AUTO);
if ((fplib != null) && (ret  == SGFDxErrorCode.SGFDX_ERROR_NONE))

	{
   	devicePort = SGPPPortAddr.USB_AUTO_DETECT;

      ret = fplib.OpenDevice(devicePort);
      if (ret == SGFDxErrorCode.SGFDX_ERROR_NONE){

			ret = fplib.GetDeviceInfo(deviceInfo);
          if (ret == SGFDxErrorCode.SGFDX_ERROR_NONE){

//				out.print(new String(deviceInfo.deviceSN()));

	//			out.print(new String(Integer.toString(deviceInfo.brightness))+"<br>");
		//		out.print(new String(Integer.toString((int)deviceInfo.contrast))+"<br>");
			//	out.print(new String(Integer.toString(deviceInfo.deviceID))+"<br>");
			//	out.print(new String(Integer.toHexString(deviceInfo.FWVersion))+"<br>");
			//	out.print(new String(Integer.toString(deviceInfo.gain))+"<br>");
			//	out.print(new String(Integer.toString(deviceInfo.imageDPI))+"<br>");
			//	out.print(new String(Integer.toString(deviceInfo.imageHeight))+"<br>");
			//	out.print(new String(Integer.toString(deviceInfo.imageWidth))+"<br>");

				imgRegistration1 = new BufferedImage(deviceInfo.imageWidth, deviceInfo.imageHeight, BufferedImage.TYPE_BYTE_GRAY);

//					imgRegistration2 = new BufferedImage(deviceInfo.imageWidth, deviceInfo.imageHeight, BufferedImage.TYPE_BYTE_GRAY);

 
				int[] quality = new int[1];

				byte[] imageBuffer1 = ((java.awt.image.DataBufferByte) imgRegistration1.getRaster().getDataBuffer()).getData();

				long iError = SGFDxErrorCode.SGFDX_ERROR_NONE;

fplib.GetImageEx(imageBuffer1,5 * 1000, 0, 50);
fplib.GetImageQuality(deviceInfo.imageWidth, deviceInfo.imageHeight, imageBuffer1, quality);
//out.print(quality[0]+"<br>");
SGFingerInfo fingerInfo = new SGFingerInfo();
fingerInfo.FingerNumber = SGFingerPosition.SG_FINGPOS_LI;
fingerInfo.ImageQuality = quality[0];
fingerInfo.ImpressionType = SGImpressionType.SG_IMPTYPE_LP;
fingerInfo.ViewNumber = 1;

fplib.CreateTemplate(fingerInfo, imageBuffer1, regMin1);



ByteArrayOutputStream baos = new ByteArrayOutputStream();
ImageIO.write( imgRegistration1, "jpg", baos );
baos.flush();
byte[] imageInByteArray = baos.toByteArray();
baos.close();
b64 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);

      }
      }   }

		  
//		out.print(b64);
		
	  out.print("<input type = 'text' id = 'fingertext' name = 'fingertext'  class='form-control' value = 'data:image/jpg;base64,"+b64+"' />");
		 out.print("<img src='data:image/png;base64,"+b64+"' style='width: 200px; height: 200px; border:1px solid #000000;' />");
  
fplib.CloseDevice();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
