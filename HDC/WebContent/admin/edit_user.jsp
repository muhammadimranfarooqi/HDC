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
  	String user_id="",username="",firstname="",lastname="",emp_id="",password="", role="", status="";
   ResultSet rs = null;
   int count = 0;
   user_id = request.getParameter("user_id");
   rs = controller.getUser(user_id);
   String roles = "";
   if(rs!=null){
		if(rs.next()){
			username = rs.getString("username");
			firstname = rs.getString("firstname");
			lastname = rs.getString("lastname");
			emp_id = rs.getString("emp_id");
			password = rs.getString("password");
			status = rs.getString("status");
			
		//	role = rs.getString("role");

		}
	}
   
   rs = controller.getRoleList(user_id);

   while(rs.next())
	   roles= rs.getString("role_name")+","+roles;
   
   rs.close();
   %> 
<br>

 <form class="form-horizontal" method="post" action="../EditUserServlet" name="search_form">

<div class="form-group">
        <div align="center">

       <table id="profile" class="" cellspacing="0" width="80%">
					<tr>
					<td>
					<label>Username:</label>
					</td>
			      	<td><input type="text" class="form-control" name="username" placeholder="Enter User Name" required autofocus="" value="<%=username %>" />
			      	</td>
			      	</tr>
			      						<tr>
					<td>
					<label>First Name:</label>
					</td>
			      	<td><input type="text" class="form-control" name="firstname" placeholder="Enter First Name"  value="<%=firstname%>" />
			      	</td>
			      	</tr>

			      						<tr>
					<td>
					<label>Last Name:</label>
					</td>
			      	<td><input type="text" class="form-control" name="lastname" placeholder="Enter Last Name"  value="<%=lastname%>" />
			      	</td>
			      	</tr>
			      						<tr>
					<td>
					<label>Emp ID:</label>
					</td>
			      	<td><input type="text" class="form-control" name="emp_id" placeholder="Enter Emp ID"  value="<%=emp_id%>" />
			      	</td>
			      	</tr>
	
					<tr>
					<td>
					<label>Password:</label>
					</td>
			      	<td><input type="password" class="form-control" name="password" placeholder="Enter Password" required value="<%=password%>" />
			      	</td>
			      	</tr>
			  
			  
			  	<tr>
					<td>
					<label>Status:</label>
					</td>
			      	<td>
			      	<select  class="form-control" name="status" >
			      			     	 	<option value="active"  <% if (status.equalsIgnoreCase("active")) out.print("selected='selected'");%>  >Active</option>
			      			     	 		     	 	<option value="locked"  <% if (status.equalsIgnoreCase("locked")) out.print("selected='selected'");%>  >Locked</option>
					</select>			      	
			      		</td>
			      	</tr>
			  
			      						<tr>
					<td>
					<label>Role:</label>
					</td>
			      	<td>
			      	
			      	<fieldset>
                        <input type="checkbox" name="role" value="Admin" <% if(roles!=null && roles.contains("Admin")) out.print("checked='checked'"); %>    />Administrator<br />
                        <input type="checkbox" name="role" value="Receptionist" <% if(roles!=null && roles.contains("Receptionist")) out.print("checked='checked'"); %>  />Receptionist<br />
                        <input type="checkbox" name="role" value="Physician" <% if(roles!=null && roles.contains("Physician")) out.print("checked='checked'"); %>  />Physician<br />
                        <input type="checkbox" name="role" value="Xray" <% if(roles!=null && roles.contains("Xray")) out.print("checked='checked'"); %>  />X-Ray<br />
                        <input type="checkbox" name="role" value="BloodCollection" <% if(roles!=null && roles.contains("BloodCollection")) out.print("checked='checked'"); %>  />Blood Collection<br />
                        <input type="checkbox" name="role" value="LabReport" <% if(roles!=null && roles.contains("LabReport")) out.print("checked='checked'"); %>  />Lab Report<br />
                        <input type="checkbox" name="role" value="FinalReport" <% if(roles!=null && roles.contains("FinalReport")) out.print("checked='checked'"); %>  />Final Report<br />
                        
        </fieldset>
<!-- 			      	
			      	<select class="form-control" name="role" required>
			      	<option value="Reception" <% if (role.equalsIgnoreCase("reception")) out.print("selected='selected'"); %> >Receptionist</option>
			      	<option value="BloodCollection"  <% if (role.equalsIgnoreCase("bloodcollection")) out.print("selected='selected'"); %> >Blood Collection</option>
			      	<option value="LabReport"  <% if (role.equalsIgnoreCase("labreport")) out.print("selected='selected'"); %>>Lab Report</option>
			      	<option value="Physician"  <% if (role.equalsIgnoreCase("physician")) out.print("selected='selected'"); %> >Physician</option>
			      	<option value="XRay"  <% if (role.equalsIgnoreCase("xray")) out.print("selected='selected'"); %> >X-Ray</option>
			      	<option value="Admin"   <% if (role.equalsIgnoreCase("admin")) out.print("selected='selected'"); %>>Administrator</option>
			      	</select>	
	 -->		      	
			      	</td>
			      	</tr>
			      	
			      	<tr>
			      	<td>
			      	
			      	<input type="hidden" class="form-control" name="user_id" value="<%=user_id %>" />      
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