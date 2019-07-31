<%@ page import="reception.*,physician.*,xray.*,labreport.*,login.*,java.sql.ResultSet,java.sql.Connection,java.util.*" %>
<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else
if (!user.getRole().equalsIgnoreCase("FinalReport") && !user.getRole().equalsIgnoreCase("Admin"))
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
     <%if(user!=null && user.getRole().equalsIgnoreCase("Admin")){%>
         <%@include file="../templates/admin_nav.html" %>
    
    
    <%} else { %>
             <%@include file="../templates/finalreport_nav.html" %>
    
      <%} %>
	</ul>   
</div>
        
  </div>
</nav>		
 <div class="container">
 
 <%@include file="../templates/header.html" %>
 	<div class="btn-group btn-group-justified">
  <a href="finalreport.jsp" class="btn btn-primary " > <span class="glyphicon glyphicon-home"></span> Home </a>
   <a href="finalreportsearch.jsp" class="btn btn-success " > <span class="glyphicon glyphicon-home"></span> Final Report Statistics </a>
  
</div>
<div class="panel panel-default">
	<hr class="colorgraph">
	
 <br>
 
 
 
 <form class="form-horizontal" method="post" action="finalreport.jsp" name="search_form">

<div class="form-group">
        <div align="center">
        
        <h1>
        <%
        String message = request.getParameter("message");
        if(message!=null)
       		out.print(message);
        Connection con = (Connection) session.getAttribute("connection");
       	if(con!=null){

        byte[] live_imageBytes=null;
        String live_image_bytes_string="", ph_comments="", xray_comments="",lab_comments="";
       	ResultSet rs=null, rstest=null, rs_profile_test=null, rs_physician=null, rs_xray=null, rs_lab=null;
       	String lab_search="", name="",father_name="",nationality="",cnic="",gamca_no="",gender="",passport_no=null,marital_status="",issue_place="";
       	
       	String  finger_min="",medical="", lab_no = null, status="";
    	ProfileController pfc = new ProfileController(con);
    	TestController tc = new TestController(con);
    	HashMap<String, String> countries = pfc.getCountries();
    	HashMap<String, String> agencies = pfc.getAgencies();
    	HashMap<String, String> professions = pfc.getProfessions();
       	
       	Date dob=null,issue_date=null,expiry_date=null, test_date=null, collection_date=null;
       	lab_search = request.getParameter("search");
       	//out.print("testing"+lab_search);
       	    	
       	finger_min = request.getParameter("min");

       	
     	String passport = request.getParameter("passport");

       	ResultSet rs_passport =null;
       	if(passport!=null)
       		rs_passport= tc.getTest(passport);
       	if(rs_passport!=null)
       		if(rs_passport.next()){
       			lab_search = rs_passport.getString("lab_no");
       		}

  
    	if (lab_search != null || lab_search != "" || !lab_search.isEmpty())
    		rs_profile_test = tc.getTestByLabNo(lab_search) ;      	
       	
    	if( rs_profile_test != null){
    		if(rs_profile_test.next()){
           		medical = rs_profile_test.getString("medical");
           		lab_no = rs_profile_test.getString("lab_no");
           		status = rs_profile_test.getString("status");
           		rs = pfc.getProfile(rs_profile_test.getString("passport_no"),con);

           		if(rs!=null){
        			if(rs.next()){
           				live_imageBytes = rs.getBytes("live_picture");

            			if(live_imageBytes!=null)		
            				live_image_bytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((live_imageBytes));
            		
           			}
           		}
    		}
    	}
	
       	PhysicianController pc = new PhysicianController (con);
       	rs_physician = pc.getPhysicianTestByLabNo(lab_no);
    	if( rs_physician != null){
    		if(rs_physician.next()){
    			ph_comments = rs_physician.getString("comments");
    		}
    	}
       	
     	XRayController xc = new XRayController (con);
       	rs_xray = xc.getXRayTestByLabNo(lab_no);
    	if( rs_xray != null){
    		if(rs_xray.next()){
    			xray_comments = rs_xray.getString("comments");
    		}
    	}
       	
    	LabReportController lc = new LabReportController (con);
       	rs_lab = lc.getLabReportTestByLabNo(lab_no);
    	if( rs_lab != null){
    		if(rs_lab.next()){
    			lab_comments = rs_lab.getString("comments");
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
  <input type="text" class="form-control" name="min" id="min" readonly   ></td>
  <td>
    <input type="text" class="form-control" name="passport" id="passport" placeholder="Passport"  value = "<%if(passport!=null) out.print(passport); else out.print(""); %>"  >
  
  </td>

 
  
</tr>    
       
       
       
      <tr>
         <td>      <label  > Search by Pin Number:</label>
         </td> 
      
          <td>  <input type="text" class="form-control" name="search"  value = "<%if(lab_no!=null)out.print(lab_no);else out.print("");%>"/></td>
         <td>    <button type="submit" class="btn btn-primary btn-md" onclick="$('form').attr('target', '');form.action='finalreport.jsp';"><span class="glyphicon glyphicon-search"></span></button></td>
            
            <td>
    <img alt="" onerror="this.style.display = 'none';" src= "<% out.print("data:image/png;base64,"+live_image_bytes_string); %> " id="live_image" name = "live_image" style="width: 200px; height: 200px; "  /></td>
 </td>             
   
              
               </tr>
               
      <tr>
         <td>      <label  > Physician's Comments:</label>
         </td> 
      
          <td colspan="3">  <input type="text" class="form-control" readonly name="ph_comments" value = "<%=ph_comments%>"/></td>
               </tr>
        <tr>
         <td>      <label  > XRay Comments:</label>
         </td> 
      
          <td colspan="3">  <input type="text" class="form-control" readonly name="xray_comments" value = "<%=xray_comments%>"/></td>
               </tr>
                 <tr>
         <td>      <label  > Lab Dr. Comments:</label>
         </td> 
      
          <td colspan="3">  <input type="text" class="form-control" readonly name="lab_comments" value = "<%=lab_comments%>"/></td>
               </tr>
             
               <tr>
         <td>      <label  > Final Comments:</label>
         </td> 
      
          <td colspan="3"> 
           	<select class="form-control" name="final_comments" required>
			      	<option value="Fit" selected="selected" >Fit</option>
			      	 	<option value="UnFit" <% if(status.equalsIgnoreCase("UnFit")) out.print("selected='selected'");	%> >UnFit</option>
			      	 	 	<option value="In Progress" <% if(status.equalsIgnoreCase("In Progress")) out.print("selected='selected'");	%> >In Progress</option>
		</select>
            </td>
               </tr>
               
                        
           </table> 
           <br>
         	
           
        </div>
        
    </div>
    <div class="btn-group btn-group-justified" >
	
			      	
			      		<div class="btn-group" >	      
 							<button  class="btn btn-lg btn-primary" type="submit" onclick="$('form').attr('target', '');form.action='../EditFinalReportServlet';" >Save / Edit</button>
 				  		</div>
 				  
 				    	<div class="btn-group">
 				    		<button class="btn btn-lg btn-success" type="reset" onClick="refreshPage()" >Reset</button>
 					 	</div>
 					
 					<div class="btn-group">
 					
 					 					<button type="submit" onclick="$('form').attr('target', '_blank');form.action='../PrintFinalReportServlet';" class="btn btn-lg btn-info">Print</button>
 					
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


  function refreshPage(){
		window.parent.location = window.parent.location.href;
		}
  
  </script>
  <%} %>
  </html>