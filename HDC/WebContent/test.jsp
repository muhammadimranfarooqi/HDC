<%@ page import="reception.*,java.sql.ResultSet,java.util.*,SecuGen.FDxSDKPro.jni.*,java.awt.image.*,java.io.*,javax.imageio.ImageIO" %>

<!DOCTYPE html>
<html>
 <head>

 </head> 
 <body>
 				
 <div class="container">
 		
<div class="panel panel-default">
 <!-- Default panel contents -->
	<hr class="colorgraph">
		<div class="panel-body">
  			<div class="wrapper">
    	<%		
    			  long deviceName;
     long devicePort;
     JSGFPLib fplib = null;  
     long ret;
     boolean bLEDOn;
     byte[] regMin1 = new byte[400];
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

	     				out.print(new String(deviceInfo.deviceSN()));
	     
	     				out.print(new String(Integer.toString(deviceInfo.brightness))+"<br>");
	     				out.print(new String(Integer.toString((int)deviceInfo.contrast))+"<br>");
	     				out.print(new String(Integer.toString(deviceInfo.deviceID))+"<br>");
	     				out.print(new String(Integer.toHexString(deviceInfo.FWVersion))+"<br>");
	     				out.print(new String(Integer.toString(deviceInfo.gain))+"<br>");
	     				out.print(new String(Integer.toString(deviceInfo.imageDPI))+"<br>");
	     				out.print(new String(Integer.toString(deviceInfo.imageHeight))+"<br>");
	     				out.print(new String(Integer.toString(deviceInfo.imageWidth))+"<br>");
	     
     					imgRegistration1 = new BufferedImage(deviceInfo.imageWidth, deviceInfo.imageHeight, BufferedImage.TYPE_BYTE_GRAY);
     	
     //					imgRegistration2 = new BufferedImage(deviceInfo.imageWidth, deviceInfo.imageHeight, BufferedImage.TYPE_BYTE_GRAY);
	
           
     					int[] quality = new int[1];
 
     					byte[] imageBuffer1 = ((java.awt.image.DataBufferByte) imgRegistration1.getRaster().getDataBuffer()).getData();
 
     					long iError = SGFDxErrorCode.SGFDX_ERROR_NONE;
      
     out.print("test"+fplib.GetImageEx(imageBuffer1,5 * 1000, 0, 50)+"<br>");
     fplib.GetImageQuality(deviceInfo.imageWidth, deviceInfo.imageHeight, imageBuffer1, quality);
     out.print(quality[0]+"<br>");
     SGFingerInfo fingerInfo = new SGFingerInfo();
     fingerInfo.FingerNumber = SGFingerPosition.SG_FINGPOS_LI;
     fingerInfo.ImageQuality = quality[0];
     fingerInfo.ImpressionType = SGImpressionType.SG_IMPTYPE_LP;
     fingerInfo.ViewNumber = 1;

     out.print("testing"+fplib.CreateTemplate(fingerInfo, imageBuffer1, regMin1));

     out.print("<br>"+imageBuffer1.length);
     out.print("<br>"+regMin1.length);
     

     ByteArrayOutputStream baos = new ByteArrayOutputStream();
     ImageIO.write( imgRegistration1, "jpg", baos );
     baos.flush();
     byte[] imageInByteArray = baos.toByteArray();
     baos.close();
     b64 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
     
//out.print(regMin1);
 //    byte[] imageBuffer2 = ((java.awt.image.DataBufferByte) imgRegistration1.getRaster().getDataBuffer()).getData();
      
 //    out.print("test"+fplib.GetImageEx(imageBuffer1,5 * 1000, 0, 50)+"<br>");
 //    fplib.GetImageQuality(deviceInfo.imageWidth, deviceInfo.imageHeight, imageBuffer1, quality);
 //    out.print(quality[0]+"<br>");

//     out.print("testing"+fplib.CreateTemplate(fingerInfo, imageBuffer2, regMin2));



  ///   ByteArrayOutputStream baos1 = new ByteArrayOutputStream();
  //   ImageIO.write( imgRegistration2, "jpg", baos );
   //  baos.flush();
  //   byte[] imageInByteArray1 = baos.toByteArray();
 //    baos.close();
  //   b64_1 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);

     System.out.println(new String(regMin1));
     
     int[] matchScore = new int[1];
     boolean[] matched = new boolean[1];
     long secuLevel = 8;
     matched[0] = false;
     iError = fplib.MatchTemplate(regMin1,regMin1, secuLevel, matched); 
     if (iError == SGFDxErrorCode.SGFDX_ERROR_NONE)
     {
        // matchScore[0] = 0;
         iError = fplib.GetMatchingScore(regMin1, regMin1, matchScore);
		 
     
         if (iError == SGFDxErrorCode.SGFDX_ERROR_NONE)
         {
             if (matched[0])
                 out.print( "Registration Success, Matching Score: " + matchScore[0]);
             else
                 out.print( "Registration Fail, Matching Score: " + matchScore[0]);
         }    
     }
     
                }
                }   }
         
//         out.print(b64);
    %>
        <img src="data:image/jpg;base64, <%=b64%>" alt="Visruth.jpg not found" /><br>
    	<img src="data:image/jpg;base64, <%=b64_1%>" alt="Visruth.jpg not found" />
    </body>  
  			</div>
  		</div>
  	<hr class="colorgraph">
  	</div>
  	 <%@include file="/templates/footer.html" %>
  	
  	 </div> 
 	
 	
 		
  </body>
  </html>