<%@ page import="xray.*,reception.*,login.*,java.sql.ResultSet,java.sql.Connection,java.util.*" %>
<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else
if (!user.getRole().equalsIgnoreCase("Xray") && !user.getRole().equalsIgnoreCase("Admin"))
	response.sendRedirect("../login/authorizationfailed.jsp");
%>
<!DOCTYPE html>
<html>
 <head>
 	<%@include file="../templates/libraries.html" %>

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
     <%
     if(user!=null && user.getRole().equalsIgnoreCase("Admin")){%>
         <%@include file="../templates/admin_nav.html" %>
    
    
    <%}     else { %>
   
               <%@include file="../templates/xray_nav.html" %>
      
<%} %>
	</ul>   
</div>
        
  </div>
</nav>		
 <div class="container">
 
 <%@include file="../templates/header.html" %>
 	<div class="btn-group btn-group-justified">
  <a href="xrayhome.jsp" class="btn btn-primary " > <span class="glyphicon glyphicon-home"></span> Home </a>
  
</div>	
<div class="panel panel-default">
	<hr class="colorgraph">
		<div class="panel-body">
  			
  		</div>
<form class="form-horizontal" method="post" action="xrayhome.jsp" name="search_form">

<div class="form-group">
        <div align="center">
        
        <h1>
        <%
        Connection con = (Connection) session.getAttribute("connection");
       	if(con!=null){

        String message = request.getParameter("message");
        if(message!=null)
       		out.print(message);
        
        byte[] live_imageBytes=null;
        String live_image_bytes_string="", comments="";
       	ResultSet rs=null, rstest=null, rs_profile_test=null, rs_xray=null;
       	String lab_search="", name="",father_name="",nationality="",cnic="",gamca_no="",gender="",passport_no=null,marital_status="",issue_place="";
       	
       	String  finger_min="",medical="", lab_no = null;
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
           		rs = pfc.getProfile(rs_profile_test.getString("passport_no"),con);

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
	
       	XRayController xc = new XRayController (con);
       	String chest_xray="",reason="";
       	rs_xray = xc.getXRayTestByLabNo(lab_no);
    	if( rs_xray != null){
    		if(rs_xray.next()){

    			chest_xray = rs_xray.getString("chest_xray");
    			reason = rs_xray.getString("reason");
    			comments = rs_xray.getString("comments");

    		}
    	}
       		
    	
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

       <form id="xray_form" class="form-horizontal" method="post"  action = "../EditXRayServlet" name="xray_form">
 

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
 

<br>

       <tr>
       <td colspan="4" align="center">
	     
       <label style="font-size:26px; " > Xray Test Information</label>

</td>       
       </tr>
      <tr>
         <td>      
        	 <label > Chest X-Ray:</label>
         </td> 
         <td>  
         	<input type="text" class="form-control" name="chest_xray" value="<% out.print(chest_xray); %> " required /></td>
         <td>
         	<label style="margin-left:50px;">Reason:</label>
         </td>  
 		<td>  
         	<input type="text" class="form-control" name="reason" value="<% out.print(reason); %>" required /></td>
		 </td>
         </tr>
<tr>
         <td>      
        	 <label > Comments:</label>
         </td> 
         <td colspan="3">  
         	<input type="text" class="form-control" name="comments" value="<% out.print(comments); %>" /></td>
         </tr>
 	
			      </table>
<br>
			      		<div class="btn-group btn-group-justified" >
	
			      	
			      		<div class="btn-group" >	      
 							<button  class="btn btn-lg btn-primary" type="submit" onclick="$('form').attr('target', '');form.action='../EditXRayServlet';">Save / Edit</button>
 				  		</div>
 				  
 				    	<div class="btn-group">
 				    		<button class="btn btn-lg btn-success"  type="reset" onClick="refreshPage()">  Reset</button>
 					 	</div>
 					
 					<div class="btn-group">
 				    		<button class="btn btn-lg btn-info" type="submit" onclick="$('form').attr('target', '_blank');form.action='../PrintXrayServlet';" >Print</button>
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
          

          var map = JSON.parse(JSON.stringify(resultantJSON));
        
        function fnCapture()
  
  {
	     
			document.search_form.objFP.DeviceID = -1;
			document.search_form.objFP.CodeName = 4;
			document.search_form.objFP.MinutiaeMode = 256;
			
			objVerify.MinutiaeMode = 256;

			

			document.getElementById("objFP").Capture();
	
			var result = document.search_form.objFP.ErrorCode;

		if (result == 0)
		{	
		
			var strmin = document.search_form.objFP.MinTextData;
			//var strimg = document.search_form.objFP.ImageTextData;
			document.search_form.min.value = strmin;
			//document.search_form.minimg.src = "data:image/png;base64,"+ strimg;
			var found = false;
	for (x in map) {
		
		if(map[x]=='' || map[x]==null ){}

		else{
			
			if ( objVerify.VerifyForText(strmin, map[x]) && objVerify.ErrorCode == 0 ){
				document.search_form.passport.value = x;
				found = true;
			//	alert(map[x]);
				break;
			}
		}
	   }  
//		alert (found);
	   if (found==false)
			document.search_form.passport.value = '';


		}
		else
			alert('Failed to get finger print. Error No = ' + result);

		return;
	}


        
  function refreshPage(){
		window.parent.location = window.parent.location.href;
		}
  
  </script>
  <%} %>
  </html>