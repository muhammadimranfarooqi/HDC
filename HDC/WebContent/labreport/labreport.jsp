<%@page import="groovy.swing.factory.HBoxFactory"%>
<%@page import="com.lowagie.text.pdf.codec.GifImage"%>
<%@ page import="labreport.*,login.*,java.sql.ResultSet,java.sql.Connection,java.util.*" %>

<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else
if (!user.getRole().equalsIgnoreCase("LabReport") && !user.getRole().equalsIgnoreCase("Admin"))
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
     <%if(user!=null && user.getRole().equalsIgnoreCase("Admin")){%>
         <%@include file="../templates/admin_nav.html" %>
    
    
    <%} else { %>
             <%@include file="../templates/labreport_nav.html" %>
    
  	<%} %>
 	
 	</ul>   
</div>
        
  </div>
</nav>		
 <div class="container">
 
 <%@include file="../templates/header.html" %>
 	<div class="btn-group btn-group-justified">
  <a href="labreport.jsp" class="btn btn-primary " > <span class="glyphicon glyphicon-home"></span> Home </a>
  
</div>	
<div class="panel panel-default">
	<hr class="colorgraph">
		<div class="panel-body">
  			
  		</div>
<!-- <table id="profile" class="table table-striped table-bordered table-striped table-bordered table-condensed table-hover" cellspacing="0" width="100%">
 -->
 
 
 <%
 Connection con = (Connection) session.getAttribute("connection");
	if(con!=null){

 String comments="",sugar="", albumin="", bilharziasis="", blood_group="", hemoglobin="", thick_film_for="", malaria="", micro_falria="",
 
 helminthes="NAD", glardia="NAD", bilharziasis_culture="NAD", salmonella="NAD", cholera="NAD", hiv_ii="", h_bs_ag="", anti_hcv="",
 rbs="", lfts="", bilrubin="", alt="", alp="", alb="", rft="", creatinine="", tpha="";

 
 
 String barcode = request.getParameter("barcode_data");
 String lab_no = request.getParameter("lab_no_search");
 ResultSet rs_labreport=null;
 //out.print(barcode);
 //out.print(lab_no);
LabReportController controller = new LabReportController(con);
 if(barcode==null || barcode=="" ){
	 barcode = controller.getBarCode(lab_no);
 }
 else
	 lab_no = controller.getLabNo(barcode);

	if (lab_no != null || lab_no != "" || !lab_no.isEmpty())
		rs_labreport = controller.getLabReportTestByLabNo(lab_no);
	
	if( rs_labreport != null){
		if(rs_labreport.next()){
			sugar = rs_labreport.getString("sugar");
			albumin = rs_labreport.getString("albumin");
			bilharziasis = rs_labreport.getString("bilharziasis");
			blood_group = rs_labreport.getString("blood_group");
			hemoglobin = rs_labreport.getString("hemoglobin");
			thick_film_for = rs_labreport.getString("thick_film_for");
			malaria = rs_labreport.getString("malaria");
			micro_falria = rs_labreport.getString("micro_falria");
			helminthes = rs_labreport.getString("helminthes");
			glardia = rs_labreport.getString("glardia");
			bilharziasis_culture = rs_labreport.getString("bilharziasis_culture");
			salmonella = rs_labreport.getString("salmonella");
			cholera = rs_labreport.getString("cholera");
			hiv_ii = rs_labreport.getString("hiv_ii");
			h_bs_ag = rs_labreport.getString("h_bs_ag");
			anti_hcv = rs_labreport.getString("anti_hcv");
			rbs = rs_labreport.getString("rbs");
			lfts = rs_labreport.getString("lfts");
			bilrubin = rs_labreport.getString("bilrubin");
			alt = rs_labreport.getString("alt");
			alp = rs_labreport.getString("alp");
			alb = rs_labreport.getString("alb");
			rft = rs_labreport.getString("rft");
			creatinine = rs_labreport.getString("creatinine");
			tpha = rs_labreport.getString("tpha");
			comments = rs_labreport.getString("comments");

		}
	}
	
 
 
 %>
 
 <br>
<form class="form-horizontal" method="post" action="labreport.jsp" name="searchform">

<div class="form-group">
        <div align="center">
       <table id="profile" class="" cellspacing="0" width="80%">
      <tr>
       <td>      <label  >Search by Barcode:</label>
         </td> 
      
          <td>  <input type="text" autofocus="autofocus" class="form-control" name="barcode_data" value = "<%if (barcode==null) out.print(""); else out.print(barcode);%>"/></td>
        
         <td>      <label  > Search by Pin Number:</label>
         </td> 
      
          <td>  <input type="text" class="form-control" name="lab_no_search" value = "<%if (lab_no==null) out.print(""); else out.print(lab_no);%>"/></td>
          
         <td>    <button type="submit" class="btn btn-primary btn-md"><span class="glyphicon glyphicon-search"></span></button></td>
              
              
               </tr>
           </table> 
           
           
        </div>
        
    </div>
    
    </form>
    
     <br>
    <form class="form-horizontal" action="../EditLabReportServlet"  method="post" id="labreportform" name="labreportform">
        <div  align="center">
        <input type="hidden" name="lab_no" value = "<%=lab_no%>"/> 
       <table align="center" id="profile" class="" cellspacing="0" width="80%">
       
       <tr>
      
               <td colspan="2" align="center"> <label > URINE:</label> </td> 
      			<td colspan="2" align="center"> <label > BLOOD:</label> </td>
      </tr>
      <tr>
         <td>      
         <label > SUGAR:</label>
         </td> 
         <td>  
					<select class="form-control" name="sugar">
			      		<option value="Absent" selected="selected" <% if (sugar.equalsIgnoreCase("Absent"))
			      		out.print("selected='selected'");%> >Absent</option>
			      		<option value="Present"  <% if (sugar.equalsIgnoreCase("Present"))
			      		out.print("selected='selected'");%> >Present</option>
			      		
			      	</select>	
		         <td><label >   BLOOD GROUP:</label>
         <td>  
					<select class="form-control" name="blood_group" >
			      		<option value="A+ve" selected="selected"  <% if (blood_group.equalsIgnoreCase("A+ve"))
			      		out.print("selected='selected'");%>  >A +ve</option>
			      		<option value="A-ve"   <% if (blood_group.equalsIgnoreCase("A-ve"))
			      		out.print("selected='selected'");%>  >A -ve</option>
			      		<option value="B+ve"  <% if (blood_group.equalsIgnoreCase("B+ve"))
			      		out.print("selected='selected'");%>   >B +ve</option>
			      		<option value="B-ve"  <% if (blood_group.equalsIgnoreCase("B-ve"))
			      		out.print("selected='selected'");%>  >B -ve</option>
			      		<option value="O+ve"  <% if (blood_group.equalsIgnoreCase("O+ve"))
			      		out.print("selected='selected'");%>  >O +ve</option>
			      		<option value="O-ve"  <% if (blood_group.equalsIgnoreCase("O-ve"))
			      		out.print("selected='selected'");%>   >O -ve</option>
			      		<option value="AB+ve"  <% if (blood_group.equalsIgnoreCase("AB+ve"))
			      		out.print("selected='selected'");%>  >AB +ve</option>
			      		<option value="AB-ve"  <% if (blood_group.equalsIgnoreCase("AB-ve"))
			      		out.print("selected='selected'");%>  >AB -ve</option>
			      		
			      		
			      	</select>	         </td>
         </tr>
         
               <tr>
         <td>      
         <label > ALBUMIN:</label>
         </td> 
         <td>  
					<select class="form-control" name="albumin" >
			      		<option value="Not Detected" selected="selected" <% if (albumin.equalsIgnoreCase("Not Detected"))
			      		out.print("selected='selected'");%> >Not Detected</option>
			      		<option value="Detected"  <% if (albumin.equalsIgnoreCase("Detected"))
			      		out.print("selected='selected'");%> >Detected</option>
			      		
			      	</select>	
		         <td><label >   HEMOGLOBIN (g/dl):</label>
         <td>  
					
				<input type="text" class="form-control" name="hemoglobin" value="<%=hemoglobin %>" /> 			      	</td>
         </tr>
         
          <tr>
         <td>      
         <label > BILHARZIASIS:</label>
         </td> 
         <td>  
					<input type="text" class="form-control" name="bilharziasis" value="<%=bilharziasis%>"/>
		         <td><label >   THICK FILM FOR:</label>
         <td>  
					
				<select class="form-control" name="thick_film_for">
			      		<option value="Absent" selected="selected"  <% if (thick_film_for.equalsIgnoreCase("Absent"))
			      		out.print("selected='selected'");%> >Absent</option>
			      		<option value="Present"  <% if (thick_film_for.equalsIgnoreCase("Present"))
			      		out.print("selected='selected'");%> >Present</option>
			      		
			      	</select>	 			      	</td>
         </tr>
        
         <tr>
         <td>      
         </td> 
         <td></td>  
		         <td><label >   1.	MALARIA:</label>
         <td>  
					
				<select class="form-control" name="malaria" >
			      		<option value="Not Detected" selected="selected" <% if (malaria.equalsIgnoreCase("Not Detected"))
			      		out.print("selected='selected'");%> >Not Detected</option>
			      		<option value="Detected"  <% if (malaria.equalsIgnoreCase("Detected"))
			      		out.print("selected='selected'");%> >Detected</option>
			      		
			      		
			      	</select>	 			      	</td>
         </tr>
         <tr>
         <td>      
         </td> 
         <td></td>  
		         <td><label >   2.	MICRO FALRIA:</label>
         <td>  
					
				<select class="form-control" name="micro_falria" >
			      		<option value="Not Detected" selected="selected" <% if (micro_falria.equalsIgnoreCase("Not Detected"))
			      		out.print("selected='selected'");%> >Not Detected</option>
			      		<option value="Detected"  <% if (micro_falria.equalsIgnoreCase("Detected"))
			      		out.print("selected='selected'");%> >Detected</option>
			      		
			      	</select>	 			      	</td>
         </tr>
         
         
         
          <tr>
      
               <td colspan="2" align="center"> <label > STOOL:</label> </td> 
      </tr>
         
         
         <tr>
      
               <td colspan="2" align="center"> <label > ROUTINE:</label> </td> 
      			<td colspan="2" align="center"> <label > SEROLOGY:</label> </td>
      </tr> 
         
    <tr>
         <td>      
         <label > 1. HELMINTHES:</label>
         </td> 
         <td>  
					<input type="text" class="form-control" name="helminthes" value="<%=helminthes%>"/></td>
					
		         <td><label >   1. R.B.S. (mg/dl):</label>
         <td>  
					
				<input type="text" class="form-control" name="rbs" value="<%=rbs %>"/></td>
         </tr>     
         
         
         <tr>
         <td>      
         <label > 2. GIARDIA:</label>
         </td> 
         <td>  
					<input type="text" class="form-control" name="glardia" value="<%=glardia %>"/></td>
					
		         <td><label >   2. L.F.Ts (mg/dl):</label>
         <td>  
					
						<select class="form-control" name="lfts" >
			      		<option value="Normal" selected="selected" <% if (lfts.equalsIgnoreCase("Normal"))
			      		out.print("selected='selected'");%> >Noraml</option>
			      		<option value="Detected"  <% if (lfts.equalsIgnoreCase("Detected"))
			      		out.print("selected='selected'");%> >Detected</option>
			      		
			      	</select>	</td>
         </tr>     
         
      <tr>
         <td>      
         <label > 3. BILHARZIASIS CULTURE:</label>
         </td> 
         <td>  
					<input type="text" class="form-control" name="bilharziasis_culture" value="<%=bilharziasis_culture%> "/></td>
					
		         <td><label >   a) BILRUBIN:</label>
         <td>  
					
				<input type="text" class="form-control" name="bilrubin" value="<%=bilrubin%> "/></td>
         </tr>
         
          <tr>
         <td>      
         <label > 4. SALMONELLA:</label>
         </td> 
         <td>  
					<input type="text" class="form-control" name="salmonella" value="<%=salmonella%> "/></td>
					
		         <td><label >   b) ALT (U/L):</label>
         <td>  
					
				<input type="text" class="form-control" name="alt" value="<%=alt %>"/></td>
         </tr>
         
          <tr>
         <td>      
         <label > 5. CHOLERA:</label>
         </td> 
         <td>  
					<input type="text" class="form-control" name="cholera" value = "<%=cholera%>"/></td>
					
		         <td><label >   c) ALP (U/L):</label>
         <td>  
					
				<input type="text" class="form-control" name="alp" value="<%=alp%>"/></td>
         </tr>     
        
         <tr>
         <td>    ELISA</label>
         </td> 
         <td>  
</td>
					
		         <td><label >   d) ALB (g/dl):</label>
         <td>  
					
				<input type="text" class="form-control" name="alb" value="<%=alb %>"/></td>
         </tr>      
          <tr>
         <td>      
         <label > H.I.VI II:</label>
         </td> 
         <td>  
					<select class="form-control" name="hiv_ii" >
			      		<option value="Negative" selected="selected" <% if (hiv_ii.equalsIgnoreCase("Negative"))
			      		out.print("selected='selected'");%> >Negative</option>
			      		<option value="Positive"  <% if (hiv_ii.equalsIgnoreCase("Positive"))
			      		out.print("selected='selected'");%> >Positive</option>
			      		
			      	</select></td>
					
		         <td><label >   3. R.F.T. (g/dl):</label>
         <td>  
					
				<input type="text" class="form-control" name="rft" value="<%=rft%>"/></td>
         </tr>     
         
          <tr>
         <td>      
         <label > H bs Ag:</label>
         </td> 
         <td>  
					<select class="form-control" name="h_bs_ag" >
			      		<option value="Negative" selected="selected" <% if (h_bs_ag.equalsIgnoreCase("Negative"))
			      		out.print("selected='selected'");%> >Negative</option>
			      		<option value="Positive"  <% if (h_bs_ag.equalsIgnoreCase("Positive"))
			      		out.print("selected='selected'");%> >Positive</option>
			      		
			      	</select></td>
					
		         <td><label >   a) CREATININE (mg/dl):</label>
         <td>  
					
				<input type="text" class="form-control" name="creatinine" value = "<%=creatinine%>"/></td>
         </tr>     
     <tr>
         <td>      
         <label > ANTI HCV:</label>
         </td> 
         <td>  
					<select class="form-control" name="anti_hcv" >
			    		<option value="Negative" selected="selected" <% if (anti_hcv.equalsIgnoreCase("Negative"))
			      		out.print("selected='selected'");%> >Negative</option>
			      		<option value="Positive"  <% if (anti_hcv.equalsIgnoreCase("Positive"))
			      		out.print("selected='selected'");%> >Positive</option>
			      		
			      		
			      	</select></td>
					
		         <td colspan="2" align="center"><label >   VDRL:</label>
         <td>  
					
</td>
 <tr>
         <td>      
                  <label > Comments:</label>
         
         </td> 
         <td>  
         				<input type="text" class="form-control" name="comments" value="<%=comments%>"/>
					</td>
					
		         <td><label >   TPHA:</label>
         <td>  
					
				<select class="form-control" name="tpha">
			      		<option value="Negative" selected="selected" <% if (tpha.equalsIgnoreCase("Negative"))
			      		out.print("selected='selected'");%> >Negative</option>
			      		<option value="Positive"  <% if (tpha.equalsIgnoreCase("Positive"))
			      		out.print("selected='selected'");%> >Positive</option>
			      		
			      	</select></td>
         </tr>     
                       

         </tr>     
                                                        
           </table> 
          
         
        </div>

<br>
			      		<div class="btn-group btn-group-justified" >
	
			      	
			      		<div class="btn-group" >	      
 							<button  class="btn btn-lg btn-primary" type="submit" onclick="$('form').attr('target', '');form.action='../EditLabReportServlet';">Save / Edit</button>
 				  		</div>
 				  
 				    	<div class="btn-group">
 				    		<button class="btn btn-lg btn-success" type="reset">Reset</button>
 					 	</div>
 					
 					<div class="btn-group">
 				    		<button class="btn btn-lg btn-info" type="submit" onclick="$('form').attr('target', '_blank');form.action='../PrintLabReportServlet';">Print</button>
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
 	
 	<%} %>
 		
  </body>
  </html>