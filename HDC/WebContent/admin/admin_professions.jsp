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
		<div class="panel-body">
<a target="_blank" href="edit_profession.jsp">Create New Profession</a>
  			
  		</div>
   <%
   Connection con = (Connection) session.getAttribute("connection");
  	if(con!=null){

   AdminController controller = new AdminController(con);
   
   ResultSet rs = null;
   int count = 0;
   
   rs = controller.getProfessionsList();
   %> 
<br>




<br>
  <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
    <thead>
      <tr>
        <th>Sr. No.</th>
        <th>Profession Name</th>
     
      </tr>
    </thead>
    <tbody>
    <%
    
	  
	  
		 
	  if(rs!=null){
	    while(rs.next()){
    	count++;
    	
    %>
    
      <tr>
        <td><% out.print(count); %></td>
        <td><a target="_blank" href="edit_profession.jsp?id=<%out.print(rs.getString("id"));%>"><% out.print(rs.getString("name")); %></a></td>
                
        	<%} rs.close();} %>
        		
      </tr>
</tbody>
</table>

		   	



  	<hr class="colorgraph">
  	</div>
  	 <%@include file="../templates/footer.html" %>
  	
  	 </div> 
 	 </div> 
 	<%} %>
 	
 		
  </body>
 
<script type="text/javascript">
$(document).ready(function() {
    $('#example').DataTable();
} );
function refreshPage(){
	window.parent.location = window.parent.location.href;
	}
</script>


  </html>