<%@ page import="reception.*,login.*,java.sql.ResultSet,java.util.*" %>
<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");

%>
<!DOCTYPE html>
<html>
 <head>
 	<%@include file="/templates/libraries.html" %>

 </head> 
 <body>
 	<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <ul class="nav navbar-nav">
    <%if(user!=null && user.getRole().equalsIgnoreCase("Admin")){%>
         <%@include file="../templates/admin_nav.html" %>
    <%}
    else if (user!=null && user.getRole().equalsIgnoreCase("Receptionist")){%>
    
             <%@include file="../templates/reception_nav.html" %>
    
    <%} else if (user!=null && user.getRole().equalsIgnoreCase("Physician")){%>
    
    <%@include file="../templates/physician_nav.html" %>

<%} else if (user!=null && user.getRole().equalsIgnoreCase("Xray")){%>
    
    <%@include file="../templates/xray_nav.html" %>

<%} else if (user!=null && user.getRole().equalsIgnoreCase("BloodCollection")){%>
    
    <%@include file="../templates/bloodcollection_nav.html" %>

<%} else if (user!=null && user.getRole().equalsIgnoreCase("LabReport")){%>

<%@include file="../templates/labreport_nav.html" %>

<%}else if (user!=null && user.getRole().equalsIgnoreCase("FinalReport")){%>

<%@include file="../templates/finalreport_nav.html" %>

<%}
%>
    
    
     	</ul>   
        
  </div>
</nav>					
 <div class="container">
 <%@include file="/templates/header.html" %>
 		
<div class="panel panel-default">
 <!-- Default panel contents -->
	<hr class="colorgraph">
	
	<script language="javascript">
function fncSubmit()
{


if(document.ChangePasswordForm.newpassword.value != document.ChangePasswordForm.conpassword.value)
{
alert('Confirm Password Not Match');
document.ChangePasswordForm.conpassword.focus(); 
return false;
} 

document.ChangePasswordForm.submit();
}
</script>
	<div class="panel-body">
  			<div class="wrapper">
    
    <h1><% String message = request.getParameter("message");
    if(message!=null)
   		out.print(message);
    %></h1>
    
    
<form class="form-signin" name="ChangePasswordForm" method="post" action="../ChangePasswordServlet" OnSubmit="return fncSubmit();">

   <h3 class="form-signin-heading">Change password below:</h3>
			      <table class="table  table-bordered "  id="table3" >
				
<tr>
<td>OLD PASSWORD</td>
<TD><input name="OldPassword" required type="password" id="OLDpwd" ></td>
</tr>
<tr>
<td>NewPassword</td>
<td><input name="newpassword" required type="password" id="newpassword">
</td>
</tr>
<tr>
<td>Confirm Password</td>
<td><input name="conpassword" required type="password" id="conpassword">
</td>
</tr>
<tr>
			      	<td colspan="2">
			      	
			      	<div class="btn-group btn-group-justified" align="center">
			      		<div class="btn-group">	      
 							<button  class="btn btn-lg btn-primary" type="submit">Login</button>
 				    	</div>
 				    	<div class="btn-group">
 				   		 <button class="btn btn-lg btn-success" type="reset">Reset</button>
 					 	</div>
 					</div>
 					</td>
			      </tr>

</table>
</form>
	</div>
	</div>
	
  	<hr class="colorgraph">
  	</div>
  	 <%@include file="/templates/footer.html" %>
  	
  	 </div> 
 	
 	
 		
  </body>
  </html>