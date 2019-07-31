<%@page import="reception.TestController,login.*,java.sql.ResultSet,java.sql.Connection,java.util.*,java.text.SimpleDateFormat"%>
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
 
   	
 	<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script> 
	<script src="//cdn.jsdelivr.net/webshim/1.14.5/polyfiller.js"></script>
	<script>
	  //	webshims.setOptions('waitReady', false);

		webshims.setOptions('forms-ext', {types: 'date'});
		webshims.polyfill('forms forms-ext');
	</script>
 </head> 
 <body>
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
 <%
 Connection con = (Connection) session.getAttribute("connection");
	if(con!=null){

 HashMap<String, String> userslist = UserDAO.getUserslist(con);
 
 String startdate = request.getParameter("start_date");
 String enddate = request.getParameter("end_date");
 String status = request.getParameter("status");

 
 String s="",e="";
 
 if (startdate != null )
	 s = startdate;
 if (enddate != null)
	 e = enddate;
 
 %>
<form  class="form-horizontal" method="post" action="dailyreport.jsp" name="dailyreport">

        
         <div class="row" >
    	<div class="col-sm-2" >
 
            <label  > Start Date:</label>
         </div>
             	<div class="col-sm-2" >
         
       <input type="date" required class="form-control" name="start_date" value = "<% out.print(s); %>" />
       </div>
              	<div class="col-sm-2" >
          
             <label  > End Date:</label>
             </div>
                 	<div class="col-sm-2" >
             
            	<input type="date" required class="form-control" name="end_date"  value = "<% out.print(e); %>" />
            </div>
                	<div class="col-sm-1" >
            
          
                 <label  >User:</label>
          
		</div>      
            	<div class="col-sm-2" >
          
          <select class="form-control" name="status">
			      	<option value="All" selected="selected" >All</option>
			      	<option value="Fit" <% if (status !=null && status.equalsIgnoreCase("Fit")) out.print("selected='selected'"); %> >Fit</option>
			      	<option value="UnFit" <% if (status !=null &&  status.equalsIgnoreCase("UnFit")) out.print("selected='selected'"); %> >UnFit</option>
			      	<option value="In Progress" <%  if (status !=null &&  status.equalsIgnoreCase("In Progress")) out.print("selected='selected'"); %> >In Progress</option>
				      
		      	</select>	
		
          </div>
          
    	<div class="col-sm-1" >
      
             <button type="submit" onclick="$('form').attr('target', '');form.action='finalreportsearch.jsp';" class="btn btn-primary btn-md"><span class="glyphicon glyphicon-search"></span></button>
              
		</div>              
           
           </div>
        
    
  <% TestController tc = new TestController(con);
  
  ResultSet rs = null;
  int count = 0;
  long sum = 0;
	  String start_date = request.getParameter("start_date");
		 
	  String end_date = request.getParameter("end_date");
		 
	  String user_id = request.getParameter("userslist");

	 %>
<br>
  <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
    <thead>
      <tr>
        <th>Sr. No.</th>
        <th>Lab No.</th>
        <th>Name</th>
        <th>Passport</th>
     <th>Medical</th>
     <th>Fee</th>
      <th>Date</th>
     <th>Status</th>
     
      </tr>
    </thead>
    <tbody>
    <%
    System.out.println(status);
    
     if (start_date != null &&  end_date !=null && status!=null)
	  {
    	rs = tc.getTestHistoryFinalReport(start_date,end_date,status);
    	while(rs.next()){
    	count++;
    %>
    
      <tr>
        <td><% out.print(count); %></td>
        <td><a target="_blank" href="../PrintFinalReportServlet?search=<%out.print(rs.getString("lab_no"));%>"><% out.print(rs.getString("lab_no")); %></a></td>
        
       <td><% out.print(rs.getString("name")); %></td>
                <td><% out.print(rs.getString("passport")); %></td>
        
                <td><% out.print(rs.getString("medical")); %></td>
                <td><% out.print(rs.getString("fee")); %></td>

                <td><% out.print(rs.getString("date")); %></td>
        		
        		<td><% out.print((rs.getString("status"))); %></td>
      </tr>
      
      
      <% 
      sum += rs.getLong("fee");
    }
	  }
    	
    
      %>
   
 
 
 
 
 
 
 
 
            
   <!--     <tr>
       <td></td>
       <td></td>
       <td></td>
       <td></td>
        <td > <h3> Total Fee: </h3></td>
        <td><h3> <% out.print(sum); %> <h3></td>
        </tr>
        
         -->
     </tbody>
  </table>



		   		      	
	<div class="btn-group btn-group-justified" >
	
			      	
			      		    	<div class="btn-group">
 				    		<button class="btn btn-lg btn-success"  type="reset" onClick="refreshPage()">  Reset</button>
 					 	</div>
 					
 					<div class="btn-group">
 					
 					<button type="submit" onclick="$('form').attr('target', '_blank');form.action='../FinalReportServlet';" class="btn btn-lg btn-info">Print</button>
 					 	</div>
 					
 				
			      	
 					</div>

</form>
<br>




  	<hr class="colorgraph">
  	</div>
  	 <%@include file="../templates/footer.html" %>
  	
  	 </div> 
 	 </div> 
 	
 	
 		
  </body>
  <link rel="stylesheet" href="https://cdn.datatables.net/1.10.13/css/dataTables.bootstrap.min.css">
    <script src="https://cdn.datatables.net/1.10.13/js/dataTables.bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.13/js/jquery.dataTables.min.js"></script>
 
<script type="text/javascript">
$(document).ready(function() {
    $('#example').DataTable();
} );
function refreshPage(){
	window.parent.location = window.parent.location.href;
	}
</script>

<%} %>
  </html>