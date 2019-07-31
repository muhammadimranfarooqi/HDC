<%@page import="database.SqlServerConnector"%>
<%@ page import="reception.*,login.*,java.sql.ResultSet,java.util.*, java.sql.Connection,java.text.SimpleDateFormat" %>

<!DOCTYPE html>

<html>
 <head>
<%


UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else 
	if (!user.getRole().equalsIgnoreCase("Receptionist") && !user.getRole().equalsIgnoreCase("Admin"))
		response.sendRedirect("../login/authorizationfailed.jsp");

%>
 	<%@include file="../templates/libraries.html" %>
<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script> 
<script src="//cdn.jsdelivr.net/webshim/1.14.5/polyfiller.js"></script>
<script>
	webshims.setOptions('forms-ext', {types: 'date'});
	webshims.polyfill('forms forms-ext');
</script>

<!-- 
<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script> 

<script src="//cdn.jsdelivr.net/webshim/1.14.5/polyfiller.js"></script>
 -->

 </head> 
 <body>
 
 
 	<OBJECT id=objVerify style="LEFT: 0px; TOP: 0px" height=0 width=0 
	classid="CLSID:8D613732-7D38-4664-A8B7-A24049B96117" 
	name=objVerify VIEWASTEXT>
</OBJECT>
	<!-- First, include the Webcam.js JavaScript Library -->
	<script type="text/javascript" src="../js/webcam.js"></script>
	
	<!-- Configure a few settings and attach camera -->
	
 
  <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
    <ul class="nav navbar-nav">
    <%if(user!=null && user.getRole().equalsIgnoreCase("Admin")){%>
         <%@include file="../templates/admin_nav.html" %>
    
    
    <%} else { %>
                 <%@include file="../templates/reception_nav.html" %>
   	<%} %>
     	</ul>   
</div>
        
  </div>
</nav>		
 <div class="container">
 
 <%@include file="../templates/header.html" %>
 <%@include file="../templates/receptionbutton.html" %>
<div class="panel panel-default">
	<hr class="colorgraph">
		<div class="panel-body">
  			
  		</div>
<!-- <table id="profile" class="table table-striped table-bordered table-striped table-bordered table-condensed table-hover" cellspacing="0" width="100%">
 -->
 <%
 	Connection con = (Connection) session.getAttribute("connection");
//	Connection con = new SqlServerConnector().getConnection(); 

   	ResultSet rs=null;
   	String phone_number="",father_husband="",passport_scan_bytes_string="",scan_picture_bytes_string="",finger_print_bytes_string="",live_image_bytes_string="", passport="", agency_id="",profession_id="",name="",country_id="",father_name="",nationality="",cnic="",gamca_no="",gender="",passport_no="",marital_status="",issue_place="";
   	Date dob=null,issue_date=null,expiry_date=null;
   	passport = request.getParameter("search");
   	
   	if(con!=null){
   		
   		
	ProfileController pfc = new ProfileController(con);
	byte[] live_imageBytes=null, finger_print_bytes=null, scan_picture_bytes=null, passport_scan_bytes=null;
	HashMap<String, String> countries = pfc.getCountries();
	HashMap<String, String> agencies = pfc.getAgencies();

	HashMap<String, String> professions = pfc.getProfessions();
 
   	if (passport!=null){
   	
   		rs = pfc.getProfile(passport,con);
   		if(rs!=null){
			if(rs.next()){
   				name = rs.getString("name");
   				profession_id = rs.getString("profession_id");
   				agency_id = rs.getString("agency_id");
   				country_id = rs.getString("dest_country");

    			father_name = rs.getString("father_name");
    			father_husband = rs.getString("father_husband");

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
    			finger_print_bytes_string =  rs.getString("finger_print");
//    			finger_print_bytes = rs.getBytes("finger_print");
    			scan_picture_bytes = rs.getBytes("scan_picture");
    			passport_scan_bytes = rs.getBytes("passport_scan");	
    			phone_number = rs.getString("phone_number");
    			 
    			
    			if(live_imageBytes!=null)		
	    			live_image_bytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((live_imageBytes));
    		//	if(finger_print_bytes!=null)		

  //  			finger_print_bytes_string  = javax.xml.bind.DatatypeConverter.printBase64Binary((finger_print_bytes));
    			if(scan_picture_bytes!=null)		

					scan_picture_bytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((scan_picture_bytes));
    			if(passport_scan_bytes!=null)		

    			passport_scan_bytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((passport_scan_bytes));


   			}
			else
				passport=null;
		}
	   
	}
   	
   %>
 
 <br>
<form class="form-horizontal" method="post" action="profile.jsp">

<div class="form-group">
        <div align="center">
       <table id="profile" class="" cellspacing="0">
      <tr>
         <td>      <label  > Search by Passport Number:</label>
         </td> 
      
          <td>  <input type="text" class="form-control" name="search" required/></td>
         <td>    <button type="submit" class="btn btn-primary btn-md"><span class="glyphicon glyphicon-search"></span></button></td>
              
 
         
               </tr>
           </table> 
           
           
        </div>
        
    </div>
    
    </form>
    
    
     <div class="row" >
 	<div class="col-sm-1" >
 	</div>
     
 	<div class="col-sm-2" >
 	<label > Live Picture:</label>
 	</div>
     
    	<div class="col-sm-3" id="my_camera" >
 
  	</div>
  
  <div class="col-sm-2" align="center" >
 	<button id="snap" type="button" class="btn btn-primary btn-md" onClick="take_snapshot()">Take Snap</button>
  	</div>
  	
  	<div class="col-sm-3"  id="results" >
     <img alt="" onerror="this.style.display = 'none';" src= "<% out.print("data:image/png;base64,"+live_image_bytes_string); %> " id="live_image" name = "live_image" style="width: 200px; height: 200px; "  /></td>
 
  	</div>
  	 	<div class="col-sm-1" >
 	</div>
  	
  	</div>	
        
  
	
	  
      
  <script language="JavaScript">
		Webcam.set({
			width: 240,
			height: 200,
			image_format: 'jpeg',
		});
		Webcam.attach( '#my_camera' );
	</script>
	
	
	<!-- Code to handle taking the snapshot and displaying it locally -->
	<script language="JavaScript">
		function take_snapshot() {
			// take snapshot and get image data
			Webcam.snap( function(data_uri) {
				// display results in page
//				document.getElementById('results').innerHTML = 
	//				'<img src="'+data_uri+'"/>';
				document.getElementById('live_image').src = data_uri;
				document.getElementById('image').value = document.getElementById('live_image').src ;
		        document.getElementById("live_image").style.display="inline";


			} );
		}
	</script>
 
     <br>
     
     
      <form id='profile_form' class="form-horizontal" method="post" action="../EditProfileServlet" enctype="multipart/form-data" name="recordform">
    
    
     <div class="row" >
 	<div class="col-sm-1" >
 	</div>
    
    <div class="col-sm-2" >
         <label > Name:</label>
    
 	</div>
    
    
    <div class="col-sm-3" >
         <input type="text" class="form-control" required name="name" value="<% out.print(name); %>"/>
    
 	</div>
 	
 	 	<div class="col-sm-2" >
 	 	<label style="margin-left:30px;">   Agency:</label>
 	</div>
    
    <div class="col-sm-3" >
             <input type="text"  class="form-control" name="agency" list="agency" value="<% if (agency_id!="" ) out.print(pfc.getAgency(agency_id)); %>" required/>
		<datalist id="agency">
         
			<% 		 for (Map.Entry<String, String> entry : agencies.entrySet()) {
					
							out.print("<option value =\""+ entry.getValue()+"\">");
	 				}
	%>	     	
		</datalist>
    
 	</div>
    
    
    <div class="col-sm-1" >
 	</div>
</div>
 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
 	     <select  class="form-control" name="father_husband" required  style="font-size:14px;font: bold; ">
			      	<option value="father" <% if (father_husband.equalsIgnoreCase("father")) out.print("selected='selected'");%>   >Father's Name</option>
			     	 	<option value="husband"  <% if (father_husband.equalsIgnoreCase("husband")) out.print("selected='selected'");%>  >Husband's Name</option>
			     
			      	</select>	
    
 	</div>
 	<div class="col-sm-3" >
 	     <input type="text" class="form-control" name="father_name"  value="<% out.print(father_name); %>"/>
 	</div>
 	<div class="col-sm-2" >
 	<label style="margin-left:30px;" > Profession:</label>
 	</div>
 	<div class="col-sm-3" >
 	         <input type="text"  class="form-control" name="profession" list="profession" value="<% if (profession_id!="" ) out.print(pfc.getProfession(profession_id)); %>" required/>
<datalist id="profession">

          	
			<% 	
			
			for (Map.Entry<String, String> entry : professions.entrySet()) {
			
							out.print("<option value =\""+ entry.getValue()+"\">");
	 				}
	%>	       
      
      </datalist>
      
 	
 	</div>
 	<div class="col-sm-1" >
 	</div>
</div>    
 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
      <label > Date of Birth:</label>    
 	</div>
 	<div class="col-sm-3" >
 	
 	
	 <input type="date"  class="form-control" name="dob" value="<% if(dob!=null) out.print(dob); %>" required/>
  	</div>
 	<div class="col-sm-2" >
     <label style="margin-left:30px;" > GAMCA NO:</label>
      	</div>
 	<div class="col-sm-3" >
 <input type="text" class="form-control" name="gamca_no" value="<% out.print(gamca_no); %>"/>
  	</div>
 	<div class="col-sm-1" >
 	</div>
</div>    

 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
                   <label > CNIC:</label>
 	</div>
 	<div class="col-sm-3" >
           <input type="text" class="form-control" name="cnic" value="<% out.print(cnic); %>"/>
  	</div>
 	<div class="col-sm-2" >
                 <label style="margin-left:30px;" > Passport Number:</label>
      	</div>
 	<div class="col-sm-3" >
           <input type="text" class="form-control" name="passport_no" required value="<% out.print(passport_no); %>"/>
           </div>
 	<div class="col-sm-1" >
 	</div>
</div>    
    
         
    
 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
 <label > Gender:</label> 	</div>
 	<div class="col-sm-3" >
          	<select class="form-control" name="gender" required>
			      	<option value="" selected="selected" disabled="disabled">Select Gender</option>
			      	<option value="male" <% if (gender.equalsIgnoreCase("male"))
			      		out.print("selected='selected'");%> 
			      		>Male</option>
			      	<option value="female" <% if (gender.equalsIgnoreCase("female"))
			      		out.print("selected='selected'");%> 
			      		>Female</option>
			      	</select>	
  	</div>
 	<div class="col-sm-2" >
      <label style="margin-left:30px;" > Issue Date:</label>
      	</div>
 	<div class="col-sm-3" >
  <input type="date" class="form-control" required  name="issue_date" value="<% if (issue_date!=null) out.print(issue_date); %>"/>  	</div>
 	<div class="col-sm-1" >
 	</div>
</div>    

 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
<label > Marital Status:</label> 	</div>
 	<div class="col-sm-3" >
          	<select class="form-control" name="maritalstatus" required>
			      	<option value="" selected="selected" disabled="disabled">Select Marital Status</option>
			      
			      
			      	<option value="married" 
			      	<% if (marital_status.equalsIgnoreCase("married"))
			      		out.print("selected='selected'");%> 
			      	
			      	>Married</option>
			      	<option value="single" 
			      	<% if (marital_status.equalsIgnoreCase("single"))
			      		out.print("selected='selected'");%> 
			      
			      	
			      	>Single</option>
			      	</select>	
		
  	</div>
 	<div class="col-sm-2" >
  <label style="margin-left:30px;"> Expiry Date:</label>      	</div>
 	<div class="col-sm-3" >
 <input type="date"  name="expiry_date" required class="form-control" value="<% if(expiry_date!=null) out.print(expiry_date); %>"/> 	</div>
 	<div class="col-sm-1" >
 	</div>
</div>    

 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
<label > Country:</label>	</div>
 	<div class="col-sm-3" >
                  <input type="text"  class="form-control" name="country" list="country" value="<% if (country_id!="" ) out.print(pfc.getCountry(country_id)); %>" required/>
<datalist id="country">

          	
			<% 	
			
			for (Map.Entry<String, String> entry : countries.entrySet()) {
			
							out.print("<option value =\""+ entry.getValue()+"\">");
	 				}
	%>	       
      
      </datalist>
  	</div>
 	<div class="col-sm-2" >
     <label style="margin-left:30px;" > Place of Issue:</label>  	</div>
 	<div class="col-sm-3" >
 <input type="text" class="form-control" name="issue_place" value="<%  out.print(issue_place); %>"/> 	</div>
 	<div class="col-sm-1" >
 	</div>
</div>    


 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
  <label > Nationality:</label>	</div>
 	<div class="col-sm-3" >
               <input type="text" class="form-control" name="nationality" value="<% out.print(nationality); %>"/>  	</div>
 	<div class="col-sm-2" >
       <label style="margin-left:30px;" > Phone Number:</label> 	</div>
 	<div class="col-sm-3" >
  <input type="text" class="form-control" name="phone_number" value="<% out.print(phone_number); %>"/> 
   		<input type = "hidden" id = "image" name = "image"  class="form-control" value="<% out.print("data:image/png;base64,"+live_image_bytes_string); %>" />
  	</div>
 	<div class="col-sm-1" >
 	</div>
</div>    
    



    

 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
   	<label > Select Passport Scan File:</label>
  	</div>
 	<div class="col-sm-5" >
  <input id="uploadPassportImage" type="file" class="form-control" accept="image/*" name="passport_file"  onchange="PreviewPassportImage();"/>  
</div>
 	<div class="col-sm-3" >
<img alt="" onerror="this.style.display = 'none';" src= "<% out.print("data:image/png;base64,"+passport_scan_bytes_string); %> " id="uploadPassportPreview" style="width: 200px; height: 200px; border:1px solid #000000;""  />
</div>
 	<div class="col-sm-1" >
 	</div>
</div>    


 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
   	<label > Select Picture Scan File:</label>
  	</div>
 	<div class="col-sm-5" >
 <input id="uploadImage" type="file" accept="image/*" class="form-control" name="scan_pict"  onchange="PreviewImage();"/>
 </div> 
 	<div class="col-sm-3" >
<img alt="" onerror="this.style.display = 'none';" src= "<% out.print("data:image/png;base64,"+scan_picture_bytes_string); %>" id="uploadPreview" style="width: 200px; height: 200px; border:1px solid #000000;"  />
</div>
 	<div class="col-sm-1" >
 	</div>
</div>    



 <div class="row" >
 	
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
  <label > Finger Print Scan:</label>
  	</div>
 	<div class="col-sm-3" >
      	<OBJECT id="objFP" style="WIDTH: 200px; HEIGHT: 250px" classid="CLSID:D547FDD7-82F6-44e8-AFBA-7553ADCEE7C8" name="objFP" >
   	</OBJECT>
  </div>
 	<div class="col-sm-2" >
<button id="snap" type="button" class="btn btn-primary btn-md" onClick="fnCapture()" >Take Finger Prints</button>
</div>
 	<div class="col-sm-3" >
  <input type="text" class = "form-control" name="min" id="min" readonly value="<% out.print(finger_print_bytes_string); %>"  >
  	</div>
 	<div class="col-sm-1" >
 	</div>
</div>    


	<br>
	   		      	<div class="btn-group btn-group-justified" >
	
			      	
			      		<div class="btn-group" >	      
 							<button  class="btn btn-lg btn-primary" type="submit" onClick="return validate();" >Save / Edit</button>
 				  		</div>
 				  
 				    	<div class="btn-group">
 				    		<button class="btn btn-lg btn-success"  type="reset" onClick="refreshPage()">  Reset</button>
 					 	</div>
 					
 					
 					
 				
			      	
 					</div>
 		<%} %>	
</form>
<br>
	<br>


  	<hr class="colorgraph">
  	</div>
  	 <%@include file="../templates/footer.html" %>
  	
  	 </div> 
 	
 	
<script lang=javascript>

  function fnCapture()
  {
			document.profile_form.objFP.DeviceID = -1;
			document.profile_form.objFP.CodeName = 4;
			document.profile_form.objFP.MinutiaeMode = 256;
			
			//document.getElementById("objVerify").MinutiaeMode = 256;

			document.getElementById("objFP").Capture();
	
			var result = document.profile_form.objFP.ErrorCode;

		if (result == 0)
		{	
			//var strimg1 = objFP.ImageTextData;
		
			var strmin = document.profile_form.objFP.MinTextData;
		//	document.profile_form.min.value = strmin;
			var strimg = document.profile_form.objFP.ImageTextData;
			document.profile_form.min.value = strmin;
		//	document.profile_form.finger_image.src = "data:image/png;base64,"+strimg;
			}
		else
			alert('Failed to get finger print. Error No = ' + result);

		return;
	}


  function validate(){
	if(  document.getElementById('image').value == 'data:image/png;base64,'){
		//alert(document.getElementById('image').value);
		alert("Please take live picture.");
		return false
	}
		else
			return true;
			
	  
  }

function refreshPage(){
	window.parent.location = window.parent.location.href;
	}
function PreviewImage() {
    var oFReader = new FileReader();
    oFReader.readAsDataURL(document.getElementById("uploadImage").files[0]);
    oFReader.onload = function (oFREvent) {
        document.getElementById("uploadPreview").src = oFREvent.target.result;
        document.getElementById("uploadPreview").style.display="inline";

    };
}
function PreviewPassportImage() {
    var oFReader = new FileReader();
    oFReader.readAsDataURL(document.getElementById("uploadPassportImage").files[0]);

    oFReader.onload = function (oFREvent) {
        document.getElementById("uploadPassportPreview").src = oFREvent.target.result;
        document.getElementById("uploadPassportPreview").style.display="inline";

    };
}
/*
var video = document.getElementById('video');

//Get access to the camera!
if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
 // Not adding `{ audio: true }` since we only want video now
 navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
     video.src = window.URL.createObjectURL(stream);
     video.play();
 });
}


/*var canvas = document.getElementById('canvas');
var context = canvas.getContext('2d');
var video = document.getElementById('video');
document.getElementById("snap").addEventListener("click", function() {
	context.drawImage(video, 0, 0, 200, 200);
	var myImage = canvas.toDataURL("image/png");      // Get the data as an image.
	alert (myImage);
	var image = document.getElementById("image");  // Get the image object.
	image.value = myImage; 
	live_image.src = myImage; 
	//canvas.style.display="none";
});

function fingerPrint() {
	  var xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	     document.getElementById("finger").innerHTML = this.responseText;
	    }
	  };
	  xhttp.open("GET", "../FingerPrintServlet", true);
	  xhttp.send();
	}
*/
</script>
	
  </html>