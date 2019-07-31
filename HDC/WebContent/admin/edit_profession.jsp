<%@ page import="login.*,admin.*,java.sql.*,java.util.*" %>

<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else if (!user.getRole().equalsIgnoreCase("Admin"))
	response.sendRedirect("../login/authorizationfailed.jsp");
%>


<!DOCTYPE html>
<html>
 	<%@include file="../templates/libraries.html" %>
	<meta charset="utf-8">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.13/css/dataTables.bootstrap.min.css">
    <script src="https://cdn.datatables.net/1.10.13/js/dataTables.bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.13/js/jquery.dataTables.min.js"></script>
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
   <%
   Connection con = (Connection) session.getAttribute("connection");
  	if(con!=null){

   AdminController controller = new AdminController(con);
   String name = "";
   ResultSet rs = null;
   int count = 0;
   String id = request.getParameter("id");
   rs = controller.getProfession(id);
   if(rs!=null){
		if(rs.next()){
			name = rs.getString("name");
		}
		}
   %> 
<br>

 <form class="form-horizontal" method="post" action="../EditProfessionServlet" name="search_form">

<div class="form-group">
        <div align="center">

       <table id="profile" class="" cellspacing="0" width="80%">
					<tr>
					<td>
					<label>Profession Name:</label>
					</td>
			      	<td><input type="text" class="form-control" name="name" placeholder="Enter Profession Name" required="" autofocus="" value="<%=name %>" />
			      	</td>
			      	</tr>
			      	<tr>
			      	<td>
			      	
			      	<input type="hidden" class="form-control" name="id" value="<%=id %>" />      
			    	</td>
			      	</tr>
			      	</table>
			      	</div>
			      </div>
			      	
			      	
			      	<div class="btn-group btn-group-justified" align="center">
			      	<div class="btn-group">	      
 					<button  class="btn btn-lg btn-primary" type="submit">Edit/Save</button>
 				    </div>
 				    <div class="btn-group">
 				    <button class="btn btn-lg btn-success" type="reset">Reset</button>
 					 				    </div>
 					
 					
			      	
 					</div>
			         
					    </form>
			      

<br>



<%} %>

  	<hr class="colorgraph">
  	</div>
  	 <%@include file="../templates/footer.html" %>
  	
  	 </div> 
</div> 
 	
 	
 		
  </body>
 
  </html>