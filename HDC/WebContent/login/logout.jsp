<%@ page import="reception.*,login.*,java.sql.*,java.util.*" %>

<!DOCTYPE html>
<html>
 <head>
 	<%@include file="/templates/libraries.html" %>

 </head> 
 <body>
 				
 <div class="container">
 <%@include file="/templates/header.html" %>
 		<% 
		Connection con = (Connection) session.getAttribute("connection");
 		if(con!=null)
 			con.close();
 		 session.invalidate();
 		
 		%>
<div class="panel panel-default">
 <!-- Default panel contents -->
	<hr class="colorgraph">
		<div class="panel-body">
  			<div class="wrapper">
    			<form class="form-signin" action="../LoginServlet" method="post">       
			      <h2 class="form-signin-heading">You have log out. Please login again.</h2>
			      <table class="table  table-striped table-bordered table-condensed table-hover"  id="table3" >
					<tr>
			      	<td><input type="text" class="form-control" name="username" placeholder="Enter User Name" required="" autofocus="" />
			      	</td>
			      	</tr>
			      	<tr>
			      	<td>
			      	
			      	<input type="password" class="form-control" name="password" placeholder="Password" required=""/>      
			     <!--  	<label class="checkbox">
			        <input type="checkbox" value="remember-me" id="rememberMe" name="rememberMe"> Remember me
			      </label>-->	
			      	</td>
			      	</tr>
			      	<tr>
			      	<td>
			      
			      	<select class="form-control" name="role" required>
			      	<option value="" selected="selected" disabled="disabled">Select Type</option>
			      	<option value="Receptionist" >Receptionist</option>
			      	<option value="BloodCollection" >Blood Collection</option>
			      	<option value="LabReport" >Lab Report</option>
			      	<option value="Physician" >Physician</option>
			      	<option value="Xray" >X-Ray</option>
			      	<option value="FinalReport" >Final Report</option>
			      	<option value="Admin" >Administrator</option>
			      	</select>		
			      				      	</td>
			      	</tr>
			      	<tr>
			      	<td>
			      	
			      	<div class="btn-group btn-group-justified" align="center">
			      	<div class="btn-group">	      
 					<button  class="btn btn-lg btn-primary" type="submit">Login</button>
 				    </div>
 				    <div class="btn-group">
 				    <button class="btn btn-lg btn-success" type="reset">Reset</button>
 					 				    </div>
 					
 					</td>
			      	
 					</div>
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