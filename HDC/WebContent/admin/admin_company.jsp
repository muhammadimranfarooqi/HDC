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
  			
  		</div>
     <%
     Connection con = (Connection) session.getAttribute("connection");
    	if(con!=null){

   AdminController controller = new AdminController(con);
   String name = "", address="", logo="",logo_imageBytes_string="";
   ResultSet rs = null;
   int count = 0;
   byte[] logo_imageBytes=null;
   rs = controller.getCompany();
   if(rs!=null){
		if(rs.next()){
			name = rs.getString("name");
			address = rs.getString("address");
			logo_imageBytes = rs.getBytes("logo");
			if(logo_imageBytes!=null)		
				logo_imageBytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((logo_imageBytes));
		
		}
		}
   %> 
<br>

  <form id='profile_form' class="form-horizontal" method="post" action="../EditCompanyServlet" enctype="multipart/form-data" name="recordform">
    

<div class="form-group">
        <div align="center">

       <table id="profile" class="" cellspacing="0" width="80%">
					<tr>
					<td>
					<label>Company Name:</label>
					</td>
			      	<td><input type="text" class="form-control" name="name"  required="" autofocus="" value = "<%=name %>"  />
			      	</td>
			      	</tr>
					<tr>
					<td>
					<label>Company Address:</label>
					</td>
			      	<td><input type="text" class="form-control" name="address" value = "<%=address %>" />
			      	</td>
			      	</tr>
					<tr>
					<td>
					<label>Company Logo:</label>
					</td>
			      	<td><input type="file" class="form-control" id="logo_file" name="logo_file" placeholder="Select Logo" required="" onchange="PreviewLogoImage();"  />
			      	</td>
					<td>
					     <img src= "<% out.print("data:image/png;base64,"+logo_imageBytes_string); %> " id="logo_image" name = "logo_image" style="width: 200px; height: 200px; "  /></td>
					
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
 				    		<button class="btn btn-lg btn-success"  type="reset" onClick="refreshPage()">  Reset</button>
 					 				    </div>
 					
 					
			      	
 					</div>
			         
					    </form>
			      

<br>





  	<hr class="colorgraph">
  	</div>
  	 <%@include file="../templates/footer.html" %>
  	
  	 </div> 
</div> 
  	<%} %>
 		
  </body>
 
<script type="text/javascript">
function refreshPage(){
	window.parent.location = window.parent.location.href;
	}

function PreviewLogoImage() {
    var oFReader = new FileReader();
    oFReader.readAsDataURL(document.getElementById("logo_file").files[0]);

    oFReader.onload = function (oFREvent) {
        document.getElementById("logo_image").src = oFREvent.target.result;

    };
}
</script>


  </html>