<%@page import="java.sql.Timestamp,java.text.SimpleDateFormat"%>
<%@ page import="reception.*,login.*,bloodcollection.*,java.sql.ResultSet,java.sql.Connection,java.util.*" %>
<%@ page import="javax.imageio.ImageIO,java.io.ByteArrayOutputStream,net.sourceforge.barbecue.*,java.awt.image.BufferedImage" %>

<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else if (!user.getRole().equalsIgnoreCase("Receptionist") && !user.getRole().equalsIgnoreCase("Admin"))
	response.sendRedirect("../login/authorizationfailed.jsp");
%>
<!DOCTYPE html>
<html>
 <head>
  	<%@include file="../templates/libraries.html" %>
 
 <script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script> 
<script src="//cdn.jsdelivr.net/webshim/1.14.5/polyfiller.js"></script>
<script>
	webshims.setOptions('forms-ext', {types: 'date'});
	webshims.polyfill('forms forms-ext');
</script>

 </head> 
 <body>
  <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
    <ul class="nav navbar-nav">
    <% if(user!=null && user.getRole().equalsIgnoreCase("Admin")){%>
         <%@include file="../templates/admin_nav.html" %>
    
    
    <%} else { %>
                    <%@include file="../templates/reception_nav.html" %>
    	<%} %>
     	
     	</ul>   
</div>
        
  </div>
</nav>		
 <div class="container">
 
 <%@include file="../templates/header.html" %>
 <%@include file="../templates/receptionbutton.html" %>
<div class="panel panel-default">
	<hr class="colorgraph">
		<div class="panel-body">
  			
  		</div>
<!-- <table id="profile" class="table table-striped table-bordered table-striped table-bordered table-condensed table-hover" cellspacing="0" width="100%">
 -->
 <br>

<form class="form-horizontal" method="post" action="receptiontest.jsp" name="recordform">

<div class="form-group">
        <div align="center">
        
        <h1>
        <%
        Connection con = (Connection) session.getAttribute("connection");
       	if(con!=null){

        String message = request.getParameter("message");
        if(message!=null)
       		out.print(message);
        
        byte[] live_imageBytes=null;
        String live_image_bytes_string="";
       	ResultSet rs=null, rstest=null,rs_bloodcollection=null;;
       	String father_husband="",passport_search="", name="",father_name="",nationality="",cnic="",gamca_no="",gender="",passport_no="",marital_status="",issue_place="", phone_number="";
       	
       	String lab_no="", medical="", medical_fee = "", status = ""; 
       	String agency_id=null, profession_id = null, country_id = null;
       	Date dob=null,issue_date=null,expiry_date=null, collection_date=null;
       	String test_date=null;
       	passport_search = request.getParameter("search");
       	String passport = request.getParameter("passport");

    	System.out.println("searchbefore"+passport_search);
       	System.out.println("passportbefore"+passport);
       	
       	if (passport_search==null || passport_search=="" || passport_search.isEmpty())
       		passport_search = passport;
       	
    	ProfileController pfc = new ProfileController(con);
    	TestController tc = new TestController(con);

    	HashMap<String, String> countries = pfc.getCountries();
    	HashMap<String, String> agencies = pfc.getAgencies();

    	HashMap<String, String> professions = pfc.getProfessions();
    	BufferedImage img;
       	String b64 = "";
    
     
       	if (passport_search!=null ){
       	
       		rs = pfc.getProfile(passport_search,con);
       		rstest = tc.getTest(passport_search);

       		if(rs!=null){
    			if(rs.next()){
       				name = rs.getString("name");
        			father_name = rs.getString("father_name");
        			father_husband = rs.getString("father_husband");
        			
        			dob = rs.getDate("dob");
        			nationality = rs.getString("nationality");
        			cnic = rs.getString("cnic");
        			gamca_no = rs.getString("gamca_no");
        			gender = rs.getString("gender");
        			passport_no = rs.getString("passport");
        			marital_status = rs.getString("marital_status");
        			issue_date = rs.getDate("issue_date");
        			expiry_date = rs.getDate("expiry_date");
        			issue_place = rs.getString("issue_place");
        			agency_id = rs.getString("agency_id");
        			profession_id = rs.getString("profession_id");
        			country_id = rs.getString("dest_country");
        			phone_number = rs.getString("phone_number");

        			live_imageBytes = rs.getBytes("live_picture");

        			if(live_imageBytes!=null)		
        				live_image_bytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((live_imageBytes));
        		
       			}
    			else
    				passport=null;
    		}
       		
       		
       		if(rstest!=null){
    			if(rstest.next()){
//       				test_date = rstest.getTimestamp("date");
  
       				test_date = rstest.getString("date");
  
					medical = rstest.getString("medical");
        			medical_fee = rstest.getString("fee");
        			collection_date = rstest.getDate("collection_date");
        			status = rstest.getString("status");
    				lab_no = rstest.getString("lab_no");
    			}
    			else
    				lab_no = "";
    		}
           	BloodCollectionController pc = new BloodCollectionController (con);
           	String  	barcode_image="",  barcode_data="";
           	rs_bloodcollection = pc.getBloodCollectionTestByLabNo(lab_no);
       
       	if( rs_bloodcollection != null){
        		if(rs_bloodcollection.next()){

        			barcode_data = rs_bloodcollection.getString("barcode_data");
        			
    				img = BarcodeImageHandler.getImage(BarcodeFactory.createCode39(barcode_data,true));			
    				ByteArrayOutputStream baos = new ByteArrayOutputStream();
    				ImageIO.write( img, "jpg", baos );
    				baos.flush();
    				byte[] imageInByteArray = baos.toByteArray();
    				baos.close();
    				b64 = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
    				

        		}
        	}

       		
    	}
       	/*
       	else if (passport_search !=null){
       		rs = pfc.getProfile(passport_search);
       		rstest = tc.getTest(passport_search);

       		if(rs!=null){
    			if(rs.next()){
       				name = rs.getString("name");
        			father_name = rs.getString("father_name");
        			dob = rs.getDate("dob");
        			nationality = rs.getString("nationality");
        			cnic = rs.getString("cnic");
        			gamca_no = rs.getString("gamca_no");
        			gender = rs.getString("gender");
        			passport_no = rs.getString("passport");
        			marital_status = rs.getString("marital_status");
        			issue_date = rs.getDate("issue_date");
        			expiry_date = rs.getDate("expiry_date");
        			issue_place = rs.getString("issue_place");
        			live_imageBytes = rs.getBytes("live_picture");
        			agency_id = rs.getString("agency_id");
        			profession_id = rs.getString("profession_id");
        			country_id = rs.getString("dest_country");
        		
        			if(live_imageBytes!=null)		
        				live_image_bytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((live_imageBytes));

       			}
    			else
    				passport=null;
    		}
    	
       		if(rstest!=null){
    			if(rstest.next()){
       				test_date = rstest.getDate("date");
        			medical = rstest.getString("medical");
        			medical_fee = rstest.getString("fee");
        			collection_date = rstest.getDate("collection_date");
        			status = rstest.getString("status");
    				lab_no = rstest.getString("lab_no");
    			}
    			else
    				lab_no = "";
    		}
       	
       		
       	}
    	*/
    	
     //	System.out.println("searchafter"+passport_search);
     //  	System.out.println("passportafter"+passport);
    //	System.out.println("agecy"+agency_id);
    //   	System.out.println("profession"+profession_id);
    //   	System.out.println("country"+country_id);

        %>
        
        </h1>
       <table id="profile" class="" cellspacing="0" width="80%">
      <tr>
         <td>      <label  > Search by Passport Number:</label>
         </td> 
      
          <td>  <input type="text" class="form-control" name="search"/></td>
         <td>    <button type="submit" class="btn btn-primary btn-md"><span class="glyphicon glyphicon-search"></span></button></td>
            
            <td>
    <img alt="" onerror="this.style.display = 'none';"  src= "<% out.print("data:image/png;base64,"+live_image_bytes_string); %> " id="live_image" name = "live_image" style="width: 200px; height: 200px; "  /></td>
 </td>             
   
              
               </tr>
           </table> 
           
           
        </div>
        
    </div>
   </form> 
    
       <%
   	
   %>
    
    
     <br>

       <form id="test_form" class="form-horizontal" method="post"  name="test_form">
    
    <div class="row" >
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
 	     <label style="margin-left:50px;" > Name:</label>
   </div>
 	<div class="col-sm-3" >
         <input type="text" class="form-control" name="name" readonly value="<% out.print(name); %>" />
         </div>
         
          	<div class="col-sm-2" >
         
                <label style="margin-left:30px;" >   Agency:</label>
        </div>
        
         	<div class="col-sm-3" >
          
          	         <input type="text" class="form-control" name="agency" readonly value="<% 
     						
          	         if (agency_id !=null){

	          	   		for (Map.Entry<String, String> entry : agencies.entrySet()) {
		          	        if(pfc.getAgency(agency_id).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}

          	         %>"/></div>
 	<div class="col-sm-1" >
</div>
</div>

    <div class="row" >

 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >

   <label style="margin-left:50px;" > <% if(father_husband.equalsIgnoreCase("husband"))
        	 out.print("Husband's Name:");
         else
        	 out.print("Father's Name:");
        	 %></label>
</div>

 	<div class="col-sm-3" >

           <input type="text" class="form-control" name="fname" readonly value="<% out.print(father_name); %>"/></div>

 	<div class="col-sm-2" >
         
                        <label style="margin-left:30px;"  > Profession:</label>
         </div> 
          	<div class="col-sm-3" >
          
         <input type="text" class="form-control" name="profession" readonly value="<% 
     						
          	         if (profession_id !=null){

	          	   		for (Map.Entry<String, String> entry : professions.entrySet()) {
		          	       if(pfc.getProfession(profession_id ).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}
          	    	     %>" /></div>
		
 	<div class="col-sm-1" >
</div>         
</div>
    <div class="row" >
<div class="col-sm-1" >
</div>
<div class="col-sm-2" >
      <label style="margin-left:50px;" > Date of Birth:</label>
</div>
         <div class="col-sm-3" >
  <input type="text" class="form-control" name="dob" readonly value="<% if (dob!=null) out.print(dob); else out.print(""); %>"/>
      </div>
         <div class="col-sm-2" >
      <label style="margin-left:30px;" > GAMCA NO:</label>
            </div>
                <div class="col-sm-3" >
  <input type="text" class="form-control" name="gamca" readonly value="<% out.print(gamca_no); %>"/>
</div>

         <div class="col-sm-1" >
</div>
</div>         
    <div class="row" >
<div class="col-sm-1" >
</div>
<div class="col-sm-2" >

               <label style="margin-left:50px;" > CNIC:</label>
</div>

<div class="col-sm-3" >
           <input type="text" class="form-control" name="cnic" readonly value="<% out.print(cnic); %>"/>
 </div>
<div class="col-sm-2" >

              <label style="margin-left:30px;" > Passport Number:</label>
        </div>
        <div class="col-sm-3" >
        
           <input type="text" class="form-control" name="passport_no" required readonly value="<% out.print(passport_no); %>"/>
         </div>
<div class="col-sm-1" >
</div>
</div>
      

    <div class="row" >
 	<div class="col-sm-1" >
 	</div>

 	<div class="col-sm-2" >

               <label style="margin-left:50px;" > Gender:</label>
        </div>
         	<div class="col-sm-3" >
        
         <input type="text" class="form-control" name="gender" readonly value="<% out.print(gender); %>"/>
</div>
 	<div class="col-sm-2" >

       <label style="margin-left:30px;" > Issue Date:</label>

</div>
 	<div class="col-sm-3" >

           <input type="text" class="form-control" name="issuedate" readonly value="<% if (issue_date !=null) out.print(issue_date); %>"/>
            </div>
 	<div class="col-sm-1" >
</div>
</div>


    <div class="row" >
 	<div class="col-sm-1" >
 	</div>

 	<div class="col-sm-2" >

      <label style="margin-left:50px;" > Marital Status:</label>
</div>
 	<div class="col-sm-3" >

         <input type="text" class="form-control" name="maritalstatus" readonly value="<% out.print(marital_status); %>"/>
</div>

 	<div class="col-sm-2" >
		
      <label style="margin-left:30px;" > Expirty Date:</label>
</div>
 	<div class="col-sm-3" >

           <input type="text" class="form-control" name="expirydate" readonly value="<% if( expiry_date !=null) out.print(expiry_date); %>"/>
 	</div>
 	<div class="col-sm-1" >
 	</div>
</div>

    <div class="row" >
 	<div class="col-sm-1" >
 	</div>

<div class="col-sm-2" >
 	
                  <label style="margin-left:50px;" > Country:</label>
</div>         
      <div class="col-sm-3" >
 	     <input type="text" class="form-control" name="countries" readonly value="<% 
     						
          	         if (country_id != null){

	          	   		for (Map.Entry<String, String> entry : countries.entrySet()) {
		          	        if(pfc.getCountry(country_id).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}
          	    	     %>"/>
</div>
<div class="col-sm-2" >
 	
          	    	          <label style="margin-left:30px;"> Place of Issue:</label>
       </div>
       <div class="col-sm-3" >
 	
           <input type="text" class="form-control" name="issueplace" readonly value="<% out.print(issue_place); %>"/>
    </div>
    <div class="col-sm-1" >
 	</div>
    </div>
    
        <div class="row" >
 	<div class="col-sm-1" >
 	</div>
    
           
          <div class="col-sm-2" >
 	   <label style="margin-left:50px;" > Nationality:</label>
 </div>
 
 <div class="col-sm-3" >
 	
           <input type="text" class="form-control" name="nationality" readonly value="<% out.print(nationality); %>"/>
              </div>
              
              <div class="col-sm-2" >
 	
                 <label style="margin-left:30px;" > Phone Number:</label>
</div>

<div class="col-sm-3" >
 	
          <input type="text" class="form-control" name="phone_number" readonly value="<% out.print(phone_number); %>"/>
 </div>
          <div class="col-sm-1" >
 	</div>       
    </div>      
       
        <div class="row" >
 	<div class="col-sm-2" >
 	</div>
 	<div class="col-sm-8" align="center" >
          
       <label style="font-size:26px; " > Test Information</label>
</div>          
 	<div class="col-sm-2" >
 	</div>
</div>
 	
			     
    <div class="row" >
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
        	 <label style="margin-left:50px;" > Pin No:</label>
 	</div>
 	<div class="col-sm-3" >
      	<input type="text" class="form-control" readonly name="lab_no" value="<% out.print(lab_no); %>" />
 	</div>
 	<div class="col-sm-2" >
 	         	<label style="margin-left:30px;" >Medical:</label>
 	</div>
 	<div class="col-sm-3" >
 	      	<select class="form-control" name="medical" required>
			      
			      	<option value="ordinary" <% if (medical.equalsIgnoreCase("ordinary"))
			      		out.print("selected='selected'");%>  >Ordinary</option>
			      	<option value="urgent" <% if (medical.equalsIgnoreCase("urgent"))
			      		out.print("selected='selected'");%> >Urgent</option>
		  	</select>	
 	</div>
 	<div class="col-sm-1" >
 	</div>
    </div>

    <div class="row" >
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >
        	 <label  style="margin-left:50px;"> Test Date:</label>
        	 
        	 
 	</div>
 	<%
 	
 	String new_test_date = null;
if(test_date!=null){
	 SimpleDateFormat  	 format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
	 Date date = format.parse(test_date);
 
	 SimpleDateFormat format2 = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
	 
	 new_test_date = format2.format(date);
	
}	//format1.format(test_date.getTime());
		
	//	Date date = format1.parse(test_date.toString());

 	
 	%>
 	<div class="col-sm-3" >
            <input type= "datetime-local" autofocus="autofocus" class="form-control"  name="test_date" value="<%=new_test_date%>" required />
 	</div>
 	<div class="col-sm-2" >
 	    	<label style="margin-left:30px;" >Medical Fee:</label>
      	</div>
 	<div class="col-sm-3" >
 	     	<input type="text" class="form-control" name="medical_fee" value="<% out.print(medical_fee); %>" required /></div>
 	<div class="col-sm-1" >
 	</div>
    </div>


    <div class="row" >
 	<div class="col-sm-1" >
 	</div>
 	<div class="col-sm-2" >

       
       

        	 <label style="margin-left:50px;" > Report Collection Date:</label>
 	</div>
 	<div class="col-sm-3" >
           <input type= "date" class="form-control" name="collection_date" value="<% if (collection_date!=null) out.print(collection_date); %>" required/>
 	</div>
 	<div class="col-sm-2" >
 	        	 <label style="margin-left:30px;" > Barcode:</label>
 	
      	</div>
    <div class="col-sm-3" id ='barcode_print' >
	         	<img src = "<% out.print("data:image/png;base64,"+b64); %>" onerror="this.style.display = 'none';" style='width: 250px; height: 100px; border:1px solid #000000;' />
   	</div>
 	
 		<div class="col-sm-1" >
 	</div>
    </div>

    
<br>
			      	
	   		      	<div class="btn-group btn-group-justified" >
	
			      	
			      		<div class="btn-group" >	      
 							<button  class="btn btn-lg btn-primary" type="submit" onclick="$('form').attr('target', '');form.action='../EditTestServlet';" >Save / Edit</button>
 				  		</div>
 				  
 				    	<div class="btn-group">
 				    		<button class="btn btn-lg btn-success" type="reset" onClick="refreshPage()" >Reset</button>
 					 	</div>
 					
 					<div class="btn-group">
 					
 					 					<button type="submit" onclick="$('form').attr('target', '_blank');form.action='../PrintReceptionSlipServlet';" class="btn btn-lg btn-info">Print</button>
 					
 				     	</div>
 					
 				
			      	
 					</div>
 			
			      
</form>
<%} %>
<br>

<!--  </table>-->
<br>


  	<hr class="colorgraph">
  	</div>
  	 <%@include file="../templates/footer.html" %>
  	
  	 </div> 
 	
 	
 		
  </body>
  <script>
function refreshPage(){
	window.parent.location = window.parent.location.href;
	}
</script>
  </html>