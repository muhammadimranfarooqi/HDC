<%@ page import="login.*" %>

<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else if (!user.getRole().equalsIgnoreCase("Admin"))
	response.sendRedirect("../login/authorizationfailed.jsp");
%>

<!DOCTYPE html>
<html>
 <head>
 	<%@include file="../templates/libraries.html" %>

 </head> 
 <body>
  <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
    <ul class="nav navbar-nav">
     <%@include file="../templates/admin_nav.html" %>
    
	</ul>   
</div>
        
  </div>
</nav>		
 <div class="container">
 
 <%@include file="../templates/header.html" %>
 <%@include file="../templates/adminbutton.html" %>
<div class="panel panel-default">
	<hr class="colorgraph">
		<div class="panel-body">
  			
  		</div>
<!-- <table id="profile" class="table table-striped table-bordered table-striped table-bordered table-condensed table-hover" cellspacing="0" width="100%">
 -->
 
 <h1>
 <% 
 
// out.print( session.getAttribute("message") + user.getFirstName()+" "+user.getLastName()); 

 %></h1>
 
<br>

<!--  </table>-->
<br>


  	<hr class="colorgraph">
  	</div>
  	 <%@include file="../templates/footer.html" %>
  	
  	 </div> 
 	
 	
 		
  </body>
  </html>