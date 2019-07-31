package reception;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;


public class TestController {
	private PreparedStatement stmt;
	
	Connection con = null;

	public TestController(Connection con) {
		this.con = con;
	}


	public long getLatestLabNo(){
		ResultSet rs = null;
	    Statement stmt = null;    


	    long lab_no =0;
		String query = "select max(lab_no) as 'lab_no' from labtest";
		
		try {
		
			stmt=con.createStatement();
		
			rs = stmt.executeQuery(query);	        
		
			if(rs.next())
				if(rs.getString("lab_no") != null){
					lab_no = rs.getLong("lab_no");
				}
		 
	      
		 } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		lab_no=lab_no+1;
		return lab_no;
	}

	public int getSerialNo(String lab_no){
		ResultSet rs = null;
	    PreparedStatement stmt = null;    

		int count  = 1;
		int serial_number =0;
		String query = "select lab_no, date from labtest where CONVERT(date, getdate()) =  (select CONVERT(date, getdate()) as date from labtest where lab_no = ?) order by date asc ";
		
		try {
		
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, lab_no);
		
			rs = stmt.executeQuery();
			while(rs.next())
				if(rs.getString("lab_no").equalsIgnoreCase(lab_no))
					serial_number = count;
					else
					count++;
				
		 
	      
		 } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		return serial_number;
	}


	
	public ResultSet getTestByLabNo(String lab_no){
		ResultSet rs = null;
		
		String query = "select * from labtest where lab_no = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, lab_no);
		
			rs = stmt.executeQuery();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}

	public ResultSet getRepeatTestByLabNo(String previous_lab_no){
		ResultSet rs = null;
		
		String query = "select * from labtest where previous_lab_no  = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, previous_lab_no);
		
			rs = stmt.executeQuery();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}

	public ResultSet getTestExcludingRepeatTest(String passport){
		ResultSet rs = null;
		
		String query = "select * from labtest where passport_no = ? and previous_lab_no is null order by date desc";
		
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

	
	public ResultSet getTest(String passport){
		ResultSet rs = null;
		
		String query = "select * from labtest where passport_no = ? and previous_lab_no is null order by date desc";
		
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
	
	public ResultSet getTestHistoryFinalReport(String start_date, String end_date, String status){
		ResultSet rs = null;
		 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		 
		 try {
		 
	     Date from=null,to=null;
		
			from = format.parse(start_date);
			to = format.parse(end_date);

		     java.sql.Date fromDate = new java.sql.Date(from.getTime());
		     java.sql.Date toDate = new java.sql.Date(to.getTime());

		     if (status.equalsIgnoreCase("All"))
		        {
		    	 String query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, convert (VARCHAR(10),l.date,110) as date, l.user_id, l.status from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? order by date";
		
		    	 
		    	 stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		    	 stmt.setDate(1, fromDate);
		    	 stmt.setDate(2, toDate);

		    	 rs = stmt.executeQuery();}
		     else{
		 		String query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, convert (VARCHAR(10),l.date,110) as date, l.user_id, l.status from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.status = ? order by date";
				stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			 	 stmt.setDate(1, fromDate);
		    	 stmt.setDate(2, toDate);
		    	 stmt.setString(3, status);
				rs = stmt.executeQuery();
				}
		    	 
		     
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}

	
	public ResultSet getTestHistory(String start_date, String end_date, String user_id, String type){
		ResultSet rs = null;
		 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		 
		 try {
		 
	     Date from=null,to=null;
		
			from = format.parse(start_date);
			to = format.parse(end_date);

		     java.sql.Date fromDate = new java.sql.Date(from.getTime());
		     java.sql.Date toDate = new java.sql.Date(to.getTime());

		     if (user_id==null || user_id=="" || user_id.isEmpty())
		        {
		    	 String query="";
		    	 if(type.equalsIgnoreCase("all_tests"))
		    		 
		//    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, convert (VARCHAR(10),l.date,110) as date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? order by date";
		    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? order by date";
		    		 else if (type.equalsIgnoreCase("new_tests"))
//		    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, convert (VARCHAR(10),l.date,110) as date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.previous_lab_no is NULL order by date";
			    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.previous_lab_no is NULL order by date";
		    	 else
//		    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, convert (VARCHAR(10),l.date,110) as date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.previous_lab_no is NOT NULL order by date";
		    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.previous_lab_no is NOT NULL order by date";
		    	 
		    	 stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		    	 stmt.setDate(1, fromDate);
		    	 stmt.setDate(2, toDate);

		    	 rs = stmt.executeQuery();}
		     else{
		    	 String query="";
		    	 if(type.equalsIgnoreCase("all_tests"))
//		    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, convert (VARCHAR(10),l.date,110) as date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.user_id = ? order by date";
		    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee,  date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.user_id = ? order by date";
		    	 else if (type.equalsIgnoreCase("new_tests"))
//		    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, convert (VARCHAR(10),l.date,110) as date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.user_id = ? and l.previous_lab_no is NULL order by date";
		    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.user_id = ? and l.previous_lab_no is NULL order by date";
			    	 else
//			    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee, convert (VARCHAR(10),l.date,110) as date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.user_id = ? and l.previous_lab_no is NOT NULL order by date";
			    		 query = "select l.lab_no, p.name, p.passport, l.medical, l.fee,  date, l.user_id, l.previous_lab_no from labtest l, profile p where l.passport_no = p.passport and l.date between ? and ? and l.user_id = ? and l.previous_lab_no is NOT NULL order by date";		    	 
		    	 stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			 	 stmt.setDate(1, fromDate);
		    	 stmt.setDate(2, toDate);
		    	 stmt.setString(3, user_id);
				rs = stmt.executeQuery();
				}
		    	 
		     
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
}
