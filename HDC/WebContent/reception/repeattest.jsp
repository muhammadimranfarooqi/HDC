<%@ page import="reception.*,bloodcollection.*,physician.*,login.*,java.sql.ResultSet,java.sql.Connection,java.util.*" %>
<%@ page import="javax.imageio.ImageIO,java.io.ByteArrayOutputStream,net.sourceforge.barbecue.*,java.awt.image.BufferedImage" %>
<%@ page import="java.sql.Timestamp,java.text.SimpleDateFormat"%>

<%
UserBean user = (UserBean) session.getAttribute("currentSessionUser"); 
if (user==null)
	response.sendRedirect("../login/sessionexpired.jsp");
else
if (!user.getRole().equalsIgnoreCase("Receptionist") && !user.getRole().equalsIgnoreCase("Admin"))
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
 <OBJECT id=objVerify style="LEFT: 0px; TOP: 0px" height=0 width=0 
	classid="CLSID:8D613732-7D38-4664-A8B7-A24049B96117" 
	name=objVerify VIEWASTEXT>
</OBJECT>

  <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
    <ul class="nav navbar-nav">
    <%if(user!=null && user.getRole().equalsIgnoreCase("Admin")){%>
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
 <br>
<form class="form-horizontal" method="post" action="repeattest.jsp" name="search_form" id ="search_form">

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
       	ResultSet rs=null, rstest=null, rs_profile_test=null, rs_physician=null, rs_repeattest=null, rs_bloodcollection=null;
       	String finger_min="",lab_search="", name="",father_name="",nationality="",cnic="",gamca_no="",gender="",passport_no=null,marital_status="",issue_place="";
       	
       	String  medical_repeat="",medical="", medical_fee="", status="", lab_no = null, repeattest_lab_no=null;
    	ProfileController pfc = new ProfileController(con);
    	TestController tc = new TestController(con);
    	HashMap<String, String> countries = pfc.getCountries();
    	HashMap<String, String> agencies = pfc.getAgencies();
    	HashMap<String, String> professions = pfc.getProfessions();
       	String new_test_date=null,test_date=null;
       	Date dob=null,issue_date=null,expiry_date=null,   collection_date=null;
       	lab_search = request.getParameter("search");
       	finger_min = request.getParameter("min");
       	String passport = request.getParameter("passport");
       	BufferedImage img;
       	String b64 = "";
    
       	String previous_lab_no=null;
       	String test_type=null;
       	ResultSet rs_passport =null;
       	if(passport!=null)
       		rs_passport= tc.getTestExcludingRepeatTest(passport);
       	if(rs_passport!=null)
       		if(rs_passport.next()){
       			lab_search = rs_passport.getString("lab_no");
       		}
       	//System.out.println(finger_min);
       	
       	
       //	if(finger_min!=null)
      // 		System.out.println("Test"+pfc.getPassportNoByFingerPrint(finger_min));
       	
       	//out.print("testing"+lab_search);
    	if (lab_search != null || lab_search != "" || !lab_search.isEmpty()){
    		rs_profile_test = tc.getTestByLabNo(lab_search) ;      	
    		rs_repeattest = tc.getRepeatTestByLabNo(lab_search);
    	}
       	
    	if( rs_profile_test != null){
    		if(rs_profile_test.next()){
           		medical = rs_profile_test.getString("medical");
           		lab_no = rs_profile_test.getString("lab_no");
           	//	previous_lab_no = rs_profile_test.getString("previous_lab_no");
           	//	test_type = rs_profile_test.getString("test_type");
           		rs = pfc.getProfile(rs_profile_test.getString("passport_no"),con);
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
            			if(live_imageBytes!=null)		
            				live_image_bytes_string = javax.xml.bind.DatatypeConverter.printBase64Binary((live_imageBytes));
           			}
           		}
           		
           		
    		}
    	}
	
		//System.out.println("repeat");

    	if( rs_repeattest != null){
    		if(rs_repeattest.next()){
    			System.out.println("repeat");
    			
    			previous_lab_no = rs_repeattest.getString("previous_lab_no");
               	test_type = rs_repeattest.getString("test_type");
   				test_date = rs_repeattest.getString("date");
   				medical_repeat = rs_repeattest.getString("medical");
    			medical_fee = rs_repeattest.getString("fee");
    			collection_date = rs_repeattest.getDate("collection_date");
    			status = rs_repeattest.getString("status");
    			repeattest_lab_no = rs_repeattest.getString("lab_no");

    			
               	BloodCollectionController pc = new BloodCollectionController (con);
               	String  	barcode_image="",  barcode_data="";
               	rs_bloodcollection = pc.getBloodCollectionTestByLabNo(repeattest_lab_no);
           
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
   		}   		
    	
        %>
        
        </h1>
       <table id="profile" class="" cellspacing="0" width="80%">
       
        <tr>
   <td>
         
   	<label > Finger Print Scan:</label>
         </td>   
   <td>  	<OBJECT id="objFP" style="WIDTH: 200px; HEIGHT: 250px" classid="CLSID:D547FDD7-82F6-44e8-AFBA-7553ADCEE7C8" name="objFP" VIEWASTEXT>
   	</OBJECT>
   
    </td>
<td>	
<button id="snap" type="button" class="btn btn-primary btn-md" onClick="fnCapture()" >Take Finger Prints</button>
         </td>      
 	<td>
  <input type="text" name="min" id="min" readonly   >
    <input type="text" name="passport" id="passport" placeholder="Passport"  value ="<%if(passport!=null) out.print(passport); else out.print(""); %>"  >
  
  </td>

 
  
</tr>    
       
       
      <tr>
         <td>      <label  > Search by Previous Pin Number:</label>
         </td> 
      
          <td>  <input type="text" class="form-control" name="search" value ="<%if(lab_no!=null) out.print(lab_no); else out.print(""); %>" /></td>
         <td>    <button type="submit" class="btn btn-primary btn-md"><span class="glyphicon glyphicon-search"></span></button></td>
            
            <td>
    <img alt="" onerror="this.style.display = 'none';"  src="<% out.print("data:image/png;base64,"+live_image_bytes_string); %>" id="live_image" name ="live_image" style="width: 200px; height: 200px; "  /></td>
 </td>             
   
              
               </tr>
               
              
           </table> 
           
           
        </div>
        
    </div>
</form>
<form class="form-horizontal" method="post" name="repeattestform">

<br>

       <table align="center" id="profile"  cellspacing="0" style="width:83%" >
      <tr>
         <td>      
         <label > Name:</label>
         </td> 
         <td>  
         <input type="text" class="form-control" name="name" readonly value="<% out.print(name); %>" /></td>
         <td><label style="margin-left:50px;" >   Agency:</label>
         <td>  
          	         <input type="text" class="form-control" name="agency" readonly value="<% 
     						
          	         if (passport_no!=null){

	          	   		for (Map.Entry<String, String> entry : agencies.entrySet()) {
		          	        if(pfc.getAgency(rs.getString("agency_id")).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}
          	    	     %>"/></td>

         
         </td>
         
         </tr>
             <tr>
         <td>      <label > Father Name:</label>
         </td> 
         <td>  <input type="text" class="form-control" name="fname" readonly value="<% out.print(father_name); %>"/></td>
         
                  <td>      <label style="margin-left:50px;" > Profession:</label>
         <td>  
         <input type="text" class="form-control" name="profession" readonly value="<% 
     						
          	         if (passport_no!=null ){

	          	   		for (Map.Entry<String, String> entry : professions.entrySet()) {
		          	        if(pfc.getProfession(rs.getString("profession_id")).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}
          	    	     %>" /></td>
		
         
         </td>
         
         </tr>
      <tr>
         <td>      <label > Date of Birth:</label>
         </td> 
         <td>  <input type="text" class="form-control" name="dob" readonly value="<% if (dob!=null) out.print(dob); else out.print(""); %>"/></td>
              <td>      <label style="margin-left:50px;" > GAMCA NO:</label>
         <td>  <input type="text" class="form-control" name="gamca" readonly value="<% out.print(gamca_no); %>"/></td>
              
         </tr>
      <tr>
         <td>      <label > CNIC:</label>
         </td> 
         <td>  <input type="text" class="form-control" name="cnic" readonly value="<% out.print(cnic); %>"/></td>
                <td>      <label style="margin-left:50px;" > Passport Number:</label>
         <td>  <input type="text" class="form-control" name="passport_no" readonly required value="<% out.print(passport_no); %>"/></td>
           
         </tr>
      <tr>
         <td>      <label > Gender:</label>
         </td> 
         <td>  
         <input type="text" class="form-control" name="gender" readonly value="<% out.print(gender); %>"/></td>
         </td>
               <td>      <label style="margin-left:50px;" > Issue Date:</label>
         <td>  <input type="text" class="form-control" name="issuedate" readonly value="<% if (issue_date !=null) out.print(issue_date); %>"/></td>
           
         </tr>
      <tr>
         <td>      <label > Marital Status:</label>
         </td> 
         <td>  
         <input type="text" class="form-control" name="maritalstatus" readonly value="<% out.print(marital_status); %>"/></td>
		
         </td>
                  <td>      <label style="margin-left:50px;" > Expiry Date:</label>
         <td>  <input type="text" class="form-control" name="expirydate" readonly value="<% if( expiry_date !=null) out.print(expiry_date); %>"/></td>
         
         </tr>
      <tr>
         <td>      <label > Country:</label>
         </td> 
         <td>  
         <input type="text" class="form-control" name="countries" readonly value="<% 
     						
          	         if (passport_no!=null ){

	          	   		for (Map.Entry<String, String> entry : countries.entrySet()) {
		          	        if(pfc.getCountry(rs.getString("dest_country")).equalsIgnoreCase(entry.getValue()))
								out.print(entry.getValue());
          		   		}
     				}
          	    	     %>"/></td>
         </td>
             <td>      <label style="margin-left:50px;" > Place of Issue:</label>
         <td>  <input type="text" class="form-control" name="issueplace" readonly value="<% out.print(issue_place); %>"/></td>
             
         </tr>
      <tr>
      
      <td>      <label > Nationality:</label>
         <td>  <input type="text" class="form-control" name="nationality" readonly value="<% out.print(nationality); %>"/></td>
         
                    <td>      <label style="margin-left:50px;"  > Phone Number:</label>
         <td>  <input type="text" class="form-control" name="phone_number" readonly value="<% out.print(issue_place); %>"/></td>
 
      </tr>
      <tr>
                  <td>      <label > Medical:</label>
         <td>  <input type="text" class="form-control" name="medical" readonly value="<% out.print(medical); %>"/></td>
         
         </tr>
  
  
  
      <tr>
         <td>  <input type="hidden" class="form-control" name="lab_no" readonly  value="<%  out.print(lab_no); %>"/></td>
         </tr>
         <tr>
       <td colspan="4" align="center">
       <label style="font-size:20px; " > Repeat Test Information</label>
          </td>
          
</tr>
</table>
<br>       
  <div class="row" >
      
           	<div class="col-sm-1" >
      </div>
           	<div class="col-sm-2" >
       
        	 <label style="margin-left:100px;" > Physical:</label>
       </div>
       
           	<div class="col-sm-1" >
       
         	<input type="checkbox" class="form-control" name="test_type" value ="physician" <% if(test_type!=null && test_type.contains("physician")) out.print("checked='checked'"); %> />
		</div>
    	<div class="col-sm-2" >

         	<label style="margin-left:100px;" >X-Ray:</label>
         	</div>
         	<div class="col-sm-1" >
         		<input type="checkbox" class="form-control" name="test_type" value = "xray" <% if(test_type!=null && test_type.contains("xray")) out.print("checked='checked'"); %> />
         	</div>
         	
      <div class="col-sm-2" >
         		<label style="margin-left:80px;" >Lab Tests:</label>
			</div>
		<div class="col-sm-1" >
         	<input type="checkbox" class="form-control" name="test_type" value="labtest" <% if(test_type!=null && test_type.contains("labtest")) out.print("checked='checked'"); %> />        
         	</div>
         	<div class="col-sm-2" >
      </div>
      
      <div class="col-sm-12"></div>
      <br>
            <div class="col-sm-12"></div>
      
         	
         	           	<div class="col-sm-1" >
      </div>
      <% 
      if(test_date!=null){
    		 SimpleDateFormat  	 format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
    		 Date date = format.parse(test_date);
    	 
    		 SimpleDateFormat format2 = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
    		 
    		 new_test_date = format2.format(date);
    		
    	}
      %>
<div class="col-sm-2" >
        	 <label > Repeat Test Date:</label>
</div>    
<div class="col-sm-3" >
       <input type= "datetime-local" class="form-control" autofocus="autofocus" name ="test_date" value = "<%=new_test_date%>" required/>
       </div>
         	<div class="col-sm-2" >
         		 <label > Repeat Test Pin No:</label>
			</div>
			<div class="col-sm-3" >
           <input type= "text" class="form-control" name="repeattest_lab_no" readonly value = "<% if(repeattest_lab_no!=null) out.print(repeattest_lab_no); %>" />
           </div>
           
           	<div class="col-sm-1" >
      </div>
                 	
              <div class="col-sm-12"></div>   	
                 	
              
            
      <div class="col-sm-1" >
      </div>
       
       <div class="col-sm-2" >
         	 <label > Report Collection Date:</label>
</div>
<div class="col-sm-3" >
           <input type= "date" class="form-control" required name="collection_date" value = "<%if (collection_date!=null) out.print(collection_date); else out.print(""); %>"/>
</div>
<div class="col-sm-2" >
         	<label >Medical Fee:</label>
</div>

	<div class="col-sm-3" >    
     	<input type="text" class="form-control" required name="medical_fee" value = "<%=medical_fee %>" />
	</div>

           	<div class="col-sm-1" >
      </div>	
                 	
                 	      <div class="col-sm-12"></div>
                 	<div class="col-sm-1" >
      </div>
             <div class="col-sm-2" >
      
      <label >Medical Repeat Test:</label>
      </div>
           	<div class="col-sm-3" >

          	<select class="form-control" name="medical_repeat" required>
			      
			      	<option value="ordinary" <% if (medical_repeat.equalsIgnoreCase("ordinary"))
			      		out.print("selected='selected'");%>  >Ordinary</option>
			      	<option value="urgent" <% if (medical_repeat.equalsIgnoreCase("urgent"))
			      		out.print("selected='selected'");%> >Urgent</option>
		  	</select>
		  	</div>	    	
          	<div class="col-sm-2" >
 	        	 <label > Barcode:</label>
 	
      	</div>
    <div class="col-sm-3" id ='barcode_print' >
	         	<img src = "<% out.print("data:image/png;base64,"+b64); %>" onerror="this.style.display = 'none';" style='width: 250px; height: 100px; border:1px solid #000000;' />
   	</div>
 	
              
</div>


<br>

			      	
	   		<div class="btn-group btn-group-justified" >
	
			      	
			      		<div class="btn-group" >	      
 							<button  class="btn btn-lg btn-primary" type="submit" onclick="$('form').attr('target', '');form.action='../EditRepeatTestServlet';" >Save / Edit</button>
 				  		</div>
 				  
 				    	<div class="btn-group">
 				    		<button class="btn btn-lg btn-success"  type="reset" onClick="refreshPage()">  Reset</button>
 					 	</div>
 					
 					<div class="btn-group">
 					 					<button type="submit" onclick="$('form').attr('target', '_blank');form.action='../PrintRepeatTestServlet';" class="btn btn-lg btn-info">Print</button>
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
 	
 	
 		
  </body>
  
  
    <script >
var resultantJSON = <%=ProfileController.getPassportByFingerJSON(con) %>
       
       //alert(resultantJSON);

       var map = JSON.parse(JSON.stringify(resultantJSON));
     //  alert (map);
      // for (x in map) {
     //	  alert (x);
     //	  alert (map[x]);
     	  
       
  function fnCapture()
  
  {
	  //alert ("Test");
	     
			document.search_form.objFP.DeviceID = -1;
			document.search_form.objFP.CodeName = 4;
			document.search_form.objFP.MinutiaeMode = 256;
			
			objVerify.MinutiaeMode = 256;

			
			//document.getElementById("objVerify").MinutiaeMode = 256;

			document.getElementById("objFP").Capture();
	
			var result = document.search_form.objFP.ErrorCode;

		if (result == 0)
		{	
			//var strimg1 = objFP.ImageTextData;
		
			var strmin = document.search_form.objFP.MinTextData;
		//	document.profile_form.min.value = strmin;
			//var strimg = document.search_form.objFP.ImageTextData;
			document.search_form.min.value = strmin;
			//document.search_form.minimg.src = "data:image/png;base64,"+ strimg;
			found = false
	for (x in map) {
		
		if(map[x]=='' || map[x]==null ){}

		else{
			if ( objVerify.VerifyForText(strmin, map[x]) && objVerify.ErrorCode == 0 ){
				document.search_form.passport.value = x;
				found = true;
				break;
			
			}
			
		}
	   }  
	   		//alert (found);
			if(!found)
				document.search_form.passport.value = '';


		}
		else
			alert('Failed to get finger print. Error No = ' + result);

		return;
	}


  function refreshPage(){
		window.parent.location = window.parent.location.href;
		}
  
  </script>
  <%} %>
  </html>