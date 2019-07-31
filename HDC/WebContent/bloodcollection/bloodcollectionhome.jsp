<%@ page import="reception.*,javax.imageio.ImageIO,bloodcollection.*,java.io.ByteArrayOutputStream,login.*,java.sql.ResultSet,java.sql.Connection,java.util.*,net.sourceforge.barbecue.*,java.awt.image.BufferedImage" %>
<%@ page import="java.sql.Timestamp,java.text.SimpleDateFormat"%>

<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else{
if (!user.getRole().equalsIgnoreCase("BloodCollection") && !user.getRole().equalsIgnoreCase("Admin"))
	response.sendRedirect("../login/authorizationfailed.jsp");
%>

<!DOCTYPE html>
<html>
 <head>
  	<%@include file="../templates/libraries.html" %>
 
 <script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script> 
<script src="//cdn.jsdelivr.net/webshim/1.14.5/polyfiller.js"></script>
<script>
	webshims.setOptions('forms-ext', {types: 'date'});
	webshims.polyfill('forms forms-ext');
</script>
 

 </head> 
 <body>
 <OBJECT id=objVerify style="LEFT: 0px; TOP: 0px" height=0 width=0 
	classid="CLSID:8D613732-7D38-4664-A8B7-A24049B96117" 
	name=objVerify VIEWASTEXT>
</OBJECT>
  <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
    <ul class="nav navbar-nav">
    
     <%if(user!=null && user.getRole().equalsIgnoreCase("Admin")){%>
         <%@include file="../templates/admin_nav.html" %>
    
    
    <%} else { %>
           <%@include file="../templates/bloodcollection_nav.html" %>
  
<%} %>
	</ul>   
</div>
        
  </div>
</nav>		
 <div class="container">
 
 <%@include file="../templates/header.html" %>
 <div class="btn-group btn-group-justified">
  <a href="bloodcollectionhome.jsp" class="btn btn-primary " > <span class="glyphicon glyphicon-home"></span> Home </a>
  
</div>
<div class="panel panel-default">
	<hr class="colorgraph">
 <br>

 
 <form class="form-horizontal" method="post" action="bloodcollectionhome.jsp" name="search_form">

<div class="form-group">
        <div align="center">
        
        <h1>
        <%
        
    	String sample_date=null, new_sample_date=null;
        String message = request.getParameter("message");
        if(message!=null)
       		out.print(message);
        
        byte[] live_imageBytes=null;
        String live_image_bytes_string="";
       	ResultSet rs=null, rstest=null, rs_profile_test=null, rs_bloodcollection=null;
       	String lab_search="", name="",father_name="",nationality="",cnic="",gamca_no="",gender="",passport_no=null,marital_status="",issue_place="";
       	
       	 String finger_min="", medical="", lab_no = null;
         Connection con = (Connection) session.getAttribute("connection");

    	ProfileController pfc = new ProfileController(con);
    	TestController tc = new TestController(con);
    	HashMap<String, String> countries = pfc.getCountries();
    	HashMap<String, String> agencies = pfc.getAgencies();
    	HashMap<String, String> professions = pfc.getProfessions();
       	
       	Date dob=null,issue_date=null,expiry_date=null, test_date=null, collection_date=null;
       	lab_search = request.getParameter("search");
    	finger_min = request.getParameter("min");

       	
     	String passport = request.getParameter("passport");

       	ResultSet rs_passport =null;
       	if(passport!=null)
       		rs_passport= tc.getTest(passport);
       	if(rs_passport!=null)
       		if(rs_passport.next()){
       			lab_search = rs_passport.getString("lab_no");
       		}

  
       	//out.print("testing"+lab_search);
    	if (lab_search != null || lab_search != "" || !lab_search.isEmpty())
    		rs_profile_test = tc.getTestByLabNo(lab_search) ;      	
       	
    	if( rs_profile_test != null){
    		if(rs_profile_test.next()){
           		medical = rs_profile_test.getString("medical");
           		lab_no = rs_profile_test.getString("lab_no");
           		rs = pfc.getProfile(rs_profile_test.getString("passport_no"), con);

           		if(rs!=null){
        			if(rs.next()){
           				name = rs.getString("name");
            			father_name = rs.getString("father_name");
            			dob = rs.getDate("dob");
            			nationality = rs.getString("nationality");
            			cnic = rs.getString("cnic");
            			gamca_no = rs.getString("gamca_no");
            			gender = rs.getString("gender");
            			passport_no = rs.getString("passport");
            			marital_status = rs.getString("marital_status");
            			issue_date = rs.getDate("issue_date");
            			expiry_date = rs.getDate("expiry_date");
            			issue_place = rs.getString("issue_place");
            			live_imageBytes = rs.getBytes("live_picture");

            			if(live_imageBytes!=null)		
            				live_image_bytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((live_imageBytes));
            		
           			}
           		}
    		}
    	}
	
       	BloodCollectionController pc = new BloodCollectionController (con);
       	String  	barcode_image="",  barcode_data="";
       	rs_bloodcollection = pc.getBloodCollectionTestByLabNo(lab_no);
       	
       	BufferedImage img;
       	String b64 = "";
    	if( rs_bloodcollection != null){
    		if(rs_bloodcollection.next()){

    			barcode_data = rs_bloodcollection.getString("barcode_data");
				sample_date = rs_bloodcollection.getString("sample_date");		
						
				
				img = BarcodeImageHandler.getImage(BarcodeFactory.createCode39(barcode_data,true));			
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				ImageIO.write( img, "jpg", baos );
				baos.flush();
				byte[] imageInByteArray = baos.toByteArray();
				baos.close();
				b64 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
				

    		}
    	}
       		
    	//out.print("testing"+b64);
    	
        %>
        
        </h1>
       <table id="profile" class="" cellspacing="0" width="80%">
       
       
         <tr>
   <td>
         
   	<label > Finger Print Scan:</label>
         </td>   
   <td>  	<OBJECT id="objFP" style="WIDTH: 200px; HEIGHT: 250px" classid="CLSID:D547FDD7-82F6-44e8-AFBA-7553ADCEE7C8" name="objFP" VIEWASTEXT>
   	</OBJECT>
   
    </td>
<td>	
<button id="snap" type="button" class="btn btn-primary btn-md" onClick="fnCapture()" >Take Finger Prints</button>
         </td>      
 	<td>
  <input type="text" name="min" id="min" readonly   >
    <input type="text" name="passport" id="passport" placeholder="Passport"  value = "<%if(passport!=null) out.print(passport); else out.print(""); %>"  >
  
  </td>

 
  
</tr>    
       
      <tr>
         <td>      <label  > Search by Pin Number:</label>
         </td> 
      
          <td>  <input type="text" class="form-control" name="search" value = "<%if (lab_no==null) out.print(""); else out.print(lab_no);%>"/></td>
         <td>    <button type="submit" class="btn btn-primary btn-md"><span class="glyphicon glyphicon-search"></span></button></td>
            
            <td>
    <img alt="" onerror="this.style.display = 'none';" src= "<% out.print("data:image/png;base64,"+live_image_bytes_string); %> " id="live_image" name = "live_image" style="width: 200px; height: 200px; "  /></td>
 </td>             
   
              
               </tr>
           </table> 
           
           
        </div>
        
    </div>
   </form> 

       <form id="bc_form" class="form-horizontal" method="post"  action = "../EditBloodCollectionServlet" name="bc_form">
 

     <br>
       <table align="center" id="profile" class=".table" cellspacing="0" width="80%" >
       <tr>
         <td>      
         <label > Name:</label>
         </td> 
         <td>  
         <input type="text" class="form-control" name="name" readonly value="<% out.print(name); %>" /></td>
         <td><label style="margin-left:50px;" >   Agency:</label>
         <td>  
          	         <input type="text" class="form-control" name="agency" readonly value="<% 
     						
          	         if (passport_no!=null){

	          	   		for (Map.Entry<String, String> entry : agencies.entrySet()) {
		          	        if(pfc.getAgency(rs.getString("agency_id")).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}
          	    	     %>"/></td>

         
         </td>
         
         </tr>
             <tr>
         <td>      <label > Father Name:</label>
         </td> 
         <td>  <input type="text" class="form-control" name="fname" readonly value="<% out.print(father_name); %>"/></td>
         
                  <td>      <label style="margin-left:50px;" > Profession:</label>
         <td>  
         <input type="text" class="form-control" name="profession" readonly value="<% 
     						
          	         if (passport_no!=null ){

	          	   		for (Map.Entry<String, String> entry : professions.entrySet()) {
		          	        if(pfc.getProfession(rs.getString("profession_id")).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}
          	    	     %>" /></td>
		
         
         </td>
         
         </tr>
      <tr>
         <td>      <label > Date of Birth:</label>
         </td> 
         <td>  <input type="text" class="form-control" name="dob" readonly value="<% if (dob!=null) out.print(dob); else out.print(""); %>"/></td>
              <td>      <label style="margin-left:50px;" > GAMCA NO:</label>
         <td>  <input type="text" class="form-control" name="gamca" readonly value="<% out.print(gamca_no); %>"/></td>
              
         </tr>
      <tr>
         <td>      <label > CNIC:</label>
         </td> 
         <td>  <input type="text" class="form-control" name="cnic" readonly value="<% out.print(cnic); %>"/></td>
                <td>      <label style="margin-left:50px;" > Passport Number:</label>
         <td>  <input type="text" class="form-control" name="passport_no" readonly required value="<% out.print(passport_no); %>"/></td>
           
         </tr>
      <tr>
         <td>      <label > Gender:</label>
         </td> 
         <td>  
         <input type="text" class="form-control" name="gender" readonly value="<% out.print(gender); %>"/></td>
         </td>
               <td>      <label style="margin-left:50px;" > Issue Date:</label>
         <td>  <input type="text" class="form-control" name="issuedate" readonly value="<% if (issue_date !=null) out.print(issue_date); %>"/></td>
           
         </tr>
      <tr>
         <td>      <label > Marital Status:</label>
         </td> 
         <td>  
         <input type="text" class="form-control" name="maritalstatus" readonly value="<% out.print(marital_status); %>"/></td>
		
         </td>
                  <td>      <label style="margin-left:50px;" > Expirty Date:</label>
         <td>  <input type="text" class="form-control" name="expirydate" readonly value="<% if( expiry_date !=null) out.print(expiry_date); %>"/></td>
         
         </tr>
      <tr>
         <td>      <label > Country:</label>
         </td> 
         <td>  
         <input type="text" class="form-control" name="countries" readonly value="<% 
     						
          	         if (passport_no!=null ){

	          	   		for (Map.Entry<String, String> entry : countries.entrySet()) {
		          	        if(pfc.getCountry(rs.getString("dest_country")).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}
          	    	     %>"/></td>
         </td>
             <td>      <label style="margin-left:50px;" > Place of Issue:</label>
         <td>  <input type="text" class="form-control" name="issueplace" readonly value="<% out.print(issue_place); %>"/></td>
             
         </tr>
      <tr>
      
      <td>      <label > Nationality:</label>
         <td>  <input type="text" class="form-control" name="nationality" readonly value="<% out.print(nationality); %>"/></td>
         
                    <td>      <label style="margin-left:50px;"  > Phone Number:</label>
         <td>  <input type="text" class="form-control" name="phone_number" readonly value="<% out.print(issue_place); %>"/></td>
 
      </tr>
      <tr>
                  <td>      <label > Medical:</label>
         <td>  <input type="text" class="form-control" name="medical" readonly value="<% out.print(medical); %>"/></td>
         
         </tr>
  
  
  
      <tr>
         <td>  <input type="hidden" class="form-control" name="lab_no" readonly  value="<%  out.print(lab_no); %>"/></td>
         </tr>
          
		      </table>
         
       

<br>

        <div class="row" >
 	<div class="col-sm-2" >
 	</div>
 	<div class="col-sm-8" align="center" >
          
       <label style="font-size:26px; " > Blood Collection Information</label>
</div>          
 	<div class="col-sm-2" >
 	</div>
</div>

  <div class="row" >
 
            <div class="col-sm-1" >
			</div>

	       <div class="col-sm-2" >
	               	 <label > Sample Date:</label>
	       
			</div>
      <% 
      if(sample_date!=null){
    		 SimpleDateFormat  	 format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
    		 Date date = format.parse(sample_date);
    	 
    		 SimpleDateFormat format2 = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
    		 
    		 new_sample_date = format2.format(date);
    		
    	}
      %>

	       <div class="col-sm-3" >
	       <input type="datetime-local" class="form-control" autofocus="autofocus" name="sample_date"  value="<%=new_sample_date%>" required/>
			</div>
 
    	<div class="col-sm-2" >
        	 <label > Bar Code:</label>
          </div>
                       
         <div id ="barcode_div" >
        	
             <div class="col-sm-3" >

	         	<img src = "<% out.print("data:image/png;base64,"+b64); %>" onerror="this.style.display = 'none';"  style='width: 250px; height: 100px; border:1px solid #000000;' />
          
	         	<input type="hidden" class="form-control" name="barcode_data" readonly value = "<%=barcode_data %>" />
          			
    	   </div>
    	   
    	               <div class="col-sm-1" >
			</div>
			
				       <div class="col-sm-8" >
			</div>

				       <div class="col-sm-4" >
		   		<button class="btn btn-lg btn-info" type="submit" onclick="$('form').attr('target', '_blank');form.action='../PrintBarCodeServlet';" >Print Barcode</button>
			</div>
</div>			
    	 <!--  
            <div class="col-sm-1" >
			</div>
    	    <div class="col-sm-4" id ='barcode_print' >
	         	<img src = "<% out.print("data:image/png;base64,"+b64); %> " style='width: 250px; height: 100px; border:1px solid #000000;' />
    	   </div>
		    <div class="col-sm-3" >
		   		<button class="btn btn-lg btn-success" type="button" onClick="generateBarcode()">Generate Barcode</button>
			</div>
			
       </div>
       
	       <div class="col-sm-3" >
		   		<button class="btn btn-lg btn-info" type="submit" onclick="$('form').attr('target', '_blank');form.action='../PrintBarCodeServlet';" >Print Barcode</button>
			</div>
			
			<div class="col-sm-1" >
			</div>
             --> 
         <br>
           <div class="container" >
         
			      		<div class="btn-group btn-group-justified" >
			      			<div class="btn-group" >	      
								<button  class="btn btn-lg btn-primary" type="submit" onclick="$('form').attr('target', '');form.action='../EditBloodCollectionServlet';" >Save / Edit</button>
 				  		</div>
 				  
 				    	<div class="btn-group">
 				    		<button class="btn btn-lg btn-success"  type="reset" onClick="refreshPage()">  Reset</button>
 					 	</div>
 					
 					<div class="btn-group">
 				    		<button class="btn btn-lg btn-info" type="submit"  onclick="$('form').attr('target', '_blank');form.action='../PrintBloodCollectionServlet';"  >Print</button>
 					 	</div>
 					</div>
 		</div>			
			      
</form>
<br>

<!--  </table>-->
<br>


  	<hr class="colorgraph">
  	</div>
  	 <%@include file="../templates/footer.html" %>
  	
  	 </div> 
 	
 	
 		
  </body>
   <script >
   
   var resultantJSON = <%= ProfileController.getPassportByFingerJSON(con) %>
   
   //alert(resultantJSON);

   var map = JSON.parse(JSON.stringify(resultantJSON));
 //  alert (map);
  // for (x in map) {
 //	  alert (x);
 //	  alert (map[x]);
 	  
   
function fnCapture()

{
  //alert ("Test");
     
		document.search_form.objFP.DeviceID = -1;
		document.search_form.objFP.CodeName = 4;
		document.search_form.objFP.MinutiaeMode = 256;
		
		objVerify.MinutiaeMode = 256;

		
		//document.getElementById("objVerify").MinutiaeMode = 256;

		document.getElementById("objFP").Capture();

		var result = document.search_form.objFP.ErrorCode;

	if (result == 0)
	{	
		//var strimg1 = objFP.ImageTextData;
	
		var strmin = document.search_form.objFP.MinTextData;
	//	document.profile_form.min.value = strmin;
		//var strimg = document.search_form.objFP.ImageTextData;
		document.search_form.min.value = strmin;
		//document.search_form.minimg.src = "data:image/png;base64,"+ strimg;
		found = false
for (x in map) {
	
	if(map[x]=='' || map[x]==null ){}

	else{
		if ( objVerify.VerifyForText(strmin, map[x]) && objVerify.ErrorCode == 0 ){
			document.search_form.passport.value = x;
			found = true;
			break;
		
		}
		
	}
   }  
   		//alert (found);
		if(!found)
			document.search_form.passport.value = '';


	}
	else
		alert('Failed to get finger print. Error No = ' + result);

	return;
}


   
   
   
   function generateBarcode() {
		  var xhttp = new XMLHttpRequest();
		// alert("test");
		  xhttp.onreadystatechange = function() {
		    if (this.readyState == 4 && this.status == 200) {
		     document.getElementById("barcode_div").innerHTML = this.responseText;
		    }
		  };
		  xhttp.open("GET", "../GenerateBarcodeServlet", true);
		  xhttp.send();
		}
  function refreshPage(){
		window.parent.location = window.parent.location.href;
		}
  function barcodePrint(divName) {
	     var printContents = document.getElementById(divName).innerHTML;
	     var originalContents = document.body.innerHTML;

	     document.body.innerHTML = printContents;

	     window.print();

	     document.body.innerHTML = originalContents;
	}
  </script>
  <%} %>
  </html>