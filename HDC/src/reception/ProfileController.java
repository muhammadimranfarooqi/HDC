package reception;
import org.json.*;

import admin.AdminController;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.imageio.ImageIO;

import SecuGen.FDxSDKPro.jni.*;

public class ProfileController {
	private PreparedStatement stmt;
	
	HashMap<String, String> countries = new HashMap<String, String>();
	HashMap<String, String> agencies = new HashMap<String, String>();
	HashMap<String, String> professions = new HashMap<String, String>();

	Connection con = null;
	
	public HashMap<String, String> getCountries() {
		return countries;
	}


	public HashMap<String, String> getAgencies() {
		return agencies;
	}


	public HashMap<String, String> getProfessions() {
		return professions;
	}


	public ProfileController(Connection con) {
		this.con = con;
		populateMaps();
	}


	public void populateMaps(){
		ResultSet rs = null;
	      Statement stmt = null;    
		String query = "select * from country";
		 try {
			stmt=con.createStatement();
		
	      rs = stmt.executeQuery(query);	        
		
	      while(rs.next()){
	    	  countries.put(rs.getString("id"), rs.getString("nicename"));
	      }
	      
			query = "select * from agency";
			
				stmt=con.createStatement();
			
		      rs = stmt.executeQuery(query);	        
			
		      while(rs.next()){
		    	  agencies.put(rs.getString("id"), rs.getString("name"));
		      }
	      
		      query = "select * from profession";
				
				stmt=con.createStatement();
			
		      rs = stmt.executeQuery(query);	        
			
		      while(rs.next()){
		    	  professions.put(rs.getString("id"), rs.getString("name"));
		      }
	      
	      
		 } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
 
	public static String getPassportByFingerJSON(Connection con){
	     HashMap < String, String > map = new HashMap < String, String > ();

			String query = "select passport, finger_print from profile";
			ResultSet rs = null;
		    Statement stmt = null;   
			
		    try {
				stmt=con.createStatement();
			
				rs = stmt.executeQuery(query);	        
			
		      while(rs.next()){
		    	  String test = rs.getString("finger_print");
		    	  if (test==null)
		    		  test="";
		    	  map.put(rs.getString("passport"), test);
		    	//  System.out.println(rs.getString("passport"));
		    	//  System.out.println(rs.getString("finger_print"));

		      }
	     
		    }catch(Exception e){
		    	e.printStackTrace();
		    }

		
		    JSONObject resultMap = new JSONObject(map);
            
		    return resultMap.toString();
       
	}
	
	public String getPassportNoByFingerPrint(String min, Connection con){
		ResultSet rs = null;
		String passport_no = "";
		try {
		 byte[] finger_imageBytes = min.getBytes();
		 
		 InputStream in = new ByteArrayInputStream(finger_imageBytes);
			BufferedImage bImageFromConvert = ImageIO.read(in);
			
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ImageIO.write( bImageFromConvert, "jpg", baos );
			baos.flush();
			byte[] imageBuffer1 = baos.toByteArray();
			baos.close();

			
            JSONObject resultMap = new JSONObject();

		
		String query = "select * from profile";
		  
		JSGFPLib fplib = new JSGFPLib();

		      byte[] regMin1 = new byte[400];
		      byte[] regMin2 = new byte[400];

		      SGDeviceInfoParam deviceInfo = new SGDeviceInfoParam();

		      fplib.Init(SGFDxDeviceName.SG_DEV_AUTO);
	 
   
 					


 					long iError = SGFDxErrorCode.SGFDX_ERROR_NONE;
  
 					
 					int[] quality = new int[1];
 					SGFingerInfo fingerInfo = new SGFingerInfo();
 					fingerInfo.FingerNumber = SGFingerPosition.SG_FINGPOS_LI;
 					fingerInfo.ImageQuality = quality[0];
 					fingerInfo.ImpressionType = SGImpressionType.SG_IMPTYPE_LP;
 					fingerInfo.ViewNumber = 1;

// 					fplib.CreateTemplate(fingerInfo, min.getBytes(), regMin1);
 					fplib.GetImageEx(imageBuffer1,5 * 1000, 0, 50);
 					
 					fplib.CreateTemplate(fingerInfo, imageBuffer1 , regMin1);
 					 
// 					System.out.println(min.getBytes().length);
 					  int[] matchScore = new int[1];
	 					boolean[] matched = new boolean[1];
	 					long secuLevel = 2;
	 					matched[0] = false;
	 				
  
 					//	iError = fplib.MatchTemplate(regMin1,regMin1, secuLevel, matched);
 
// 					System.out.println("iErrorFirst"+iError);
 //					  iError = fplib.GetMatchingScore(regMin1, regMin1, matchScore);
//			          System.out.println("iErrorThird"+iError);
	//		    	  if (matched[0])
		//	    		  System.out.println( "Registration Success, Matching Score: " + matchScore[0]);
			//             else
			  //          	 System.out.println( "Registration Fail, Matching Score: " + matchScore[0]);
			        
			   
			
			   
			   
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			rs = stmt.executeQuery();
			while(rs.next()){
			   
			      
			      if(rs.getString("finger_print")==null ){
			    	  
			      }
			      else{
	
			    	  
			    		 InputStream in2 = new ByteArrayInputStream(rs.getString("finger_print").getBytes());
			 			BufferedImage bImageFromConvert1 = ImageIO.read(in2);
			 				

			 			ByteArrayOutputStream baos1 = new ByteArrayOutputStream();
						ImageIO.write( bImageFromConvert1, "jpg", baos1 );
						baos1.flush();
						byte[] imageBuffer2 = baos.toByteArray();
						baos1.close();



	 					//System.out.println(rs.getString("finger_print"));
			    	 // fplib.CreateTemplate(fingerInfo, rs.getString("finger_print").getBytes(), regMin2);

				    	  fplib.CreateTemplate(fingerInfo, imageBuffer2 , regMin2);

			    	  iError = fplib.MatchTemplate(regMin2,regMin1, secuLevel, matched);
			           
			          System.out.println("iErrorSecond"+iError);
			          System.out.println(rs.getString("finger_print").getBytes().length);

			          
				      if (iError == SGFDxErrorCode.SGFDX_ERROR_NONE)
				      {
				          iError = fplib.GetMatchingScore(regMin1, regMin2, matchScore);
				          System.out.println("iErrorThird"+iError);
				         
				    	  if (matched[0])
				    		  System.out.println( "Registration Success, Matching Score: " + matchScore[0]);
				             else
				            	 System.out.println( "Registration Fail, Matching Score: " + matchScore[0]);
				    //      matchScore[0] = 0;
				     //     iError = fplib.GetMatchingScore(regMin1,regMin2, matchScore);
				 		 
			         // if (iError == SGFDxErrorCode.SGFDX_ERROR_NONE)
				      //    {
				      //        if (matched[0]){
				       //     	  passport_no = rs.getString("passport");
				       //           System.out.println( "Registration Success, Matching Score: " + matchScore[0]);
				       //       }
				   //       }    
				      }
				
				}
			}
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return passport_no;
	}
	
	
	public ResultSet getProfile(String passport, Connection con){
		ResultSet rs = null;
		
		String query = "select * from profile where passport = ?";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, passport);
		
			rs = stmt.executeQuery();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	public ResultSet getCompany(Connection con){
		ResultSet rs = null;
		
		String query = "select * from company ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);

			rs = stmt.executeQuery();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	public String getAgency(String id){
		String agency="";
		agency = agencies.get(id);
		return agency;
	}
	public String getCountry(String id){
		String country="";
		country = countries.get(id);
		return country;
	}
	public String getProfession(String id){
		String profession="";
		profession = professions.get(id);
		return profession;
	}

	public String getAgencyID(String agency_name){
		String agency_id = null;
		
		for (Map.Entry<String, String> e : agencies.entrySet()) {
		    if(agency_name.equalsIgnoreCase(e.getValue()))
		    	{
		    	agency_id = e.getKey();
		    	break;
		    	}
		}
		
		if(agency_id==null){
		     AdminController controller = new AdminController(con);
		     String query = "INSERT INTO agency (id, name,address) VALUES (?,?,?)";
		        PreparedStatement statement=null;
		        
					try {
						statement = con.prepareStatement(query);
					
						long test = controller.getLatestAgencyID();
			        	statement.setLong(1, test);
			           	statement.setString(2, agency_name);
			           	statement.setString(3, agency_name);
			            int row = statement.executeUpdate();
			            if (row > 0) {
			            	agency_id = Long.toString(test);
			            }
						} catch (SQLException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}

		}
		
		return agency_id;
		
		
	}

	public String getProfessionID(String profession_name){
		String profession_id = null;
		
		for (Map.Entry<String, String> e : professions.entrySet()) {
		    if(profession_name.equalsIgnoreCase(e.getValue()))
		    	{
		    	profession_id = e.getKey();
		    	break;
		    	}
		}
		
		if(profession_id==null){
		     AdminController controller = new AdminController(con);
		     String query = "INSERT INTO profession (id, name) VALUES (?,?)";
		        PreparedStatement statement=null;
		        
					try {
						statement = con.prepareStatement(query);
					
						long test = controller.getLatestProfessionID();
			        	statement.setLong(1, test);
			           	statement.setString(2, profession_name);
			            int row = statement.executeUpdate();
			            if (row > 0) {
			            	profession_id = Long.toString(test);
			            }
						} catch (SQLException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}

		}
		
		return profession_id;
		
		
	}
	
	public String getCountryID(String country_name){
		String country_id = null;
		
		for (Map.Entry<String, String> e : countries.entrySet()) {
		    if(country_name.equalsIgnoreCase(e.getValue()))
		    	{
		    	country_id = e.getKey();
		    	break;
		    	}
		}
		
		if(country_id==null){
		     AdminController controller = new AdminController(con);
		     String query = "INSERT INTO country (id, name, nicename) VALUES (?,?,?)";
		        PreparedStatement statement=null;
		        
					try {
						statement = con.prepareStatement(query);
					
						long test = controller.getLatestCountryID();
			        	statement.setLong(1, test);
			           	statement.setString(2, country_name.toUpperCase());
			           	statement.setString(3, country_name);

			           	int row = statement.executeUpdate();
			            if (row > 0) {
			            	country_id = Long.toString(test);
			            }
						} catch (SQLException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}

		}
		
		return country_id;
		
		
	}
	

}
