package admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.http.HttpSession;


public class AdminController {
	private PreparedStatement stmt;
	private Connection con = null;

	public AdminController(Connection con) {
		this.con = con;
		// TODO Auto-generated constructor stub
	}
	
	public ResultSet getCompany(){
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
	
	public ResultSet getRoleList(String user_id){
		ResultSet rs = null;
		
		String query = "select * from role where user_id = ? order by role_name ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, user_id);

			rs = stmt.executeQuery();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
		
			e.printStackTrace();
		}
		return rs;
	}
	
	
	
	public ResultSet getUsersList(){
		ResultSet rs = null;
		
		String query = "select * from users order by username ";
		
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
	public ResultSet getProfessionsList(){
		ResultSet rs = null;
		
		String query = "select * from profession order by name ";
		
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
	public ResultSet getProfession(String id){
		ResultSet rs = null;
		
		String query = "select * from profession where id = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, id);
			
		
			rs = stmt.executeQuery();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	public ResultSet getAgency(String id){
		ResultSet rs = null;
		
		String query = "select * from agency where id = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, id);
			
		
			rs = stmt.executeQuery();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}

	public ResultSet getUser(String id){
		ResultSet rs = null;
		
		String query = "select * from users where user_id = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, id);
			
		
			rs = stmt.executeQuery();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	
	public ResultSet getAgenciesList(){
		ResultSet rs = null;
		
		String query = "select * from agency order by name ";
		
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

	
	public boolean checkCompany(){
		ResultSet rs = null;
		boolean test = false;
		String query = "select * from company ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		
			rs = stmt.executeQuery();
			
			if(rs.next())
				test = true;
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return test;
	}
	
	public boolean checkProfession(String id ){
		ResultSet rs = null;
		boolean test = false;
		String query = "select * from profession where id = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, id);
		
			rs = stmt.executeQuery();
			
			if(rs.next())
				test = true;
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return test;
	}
	
	public boolean checkAgency(String id ){
		ResultSet rs = null;
		boolean test = false;
		String query = "select * from agency where id = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, id);
	
			rs = stmt.executeQuery();
			
			if(rs.next())
				test = true;
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return test;
	}

	public boolean checkUser(String user_id ){
		ResultSet rs = null;
		boolean test = false;
		String query = "select * from users where user_id = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, user_id);
	
			rs = stmt.executeQuery();
			
			if(rs.next())
				test = true;
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return test;
	}

	public long getLatestProfessionID(){
		ResultSet rs = null;
	    Statement stmt = null;    


	    long id =0;
		String query = "select max(id) as 'id' from profession";
		
		try {
		
			stmt=con.createStatement();
		
			rs = stmt.executeQuery(query);	        
		
			if(rs.next())
				if(rs.getString("id") != null){
					id = rs.getLong("id");
				}
		 
	      
		 } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		id=id+1;
		return id;
	}

	public long getLatestCountryID(){
		ResultSet rs = null;
	    Statement stmt = null;    


	    long id =0;
		String query = "select max(id) as 'id' from country";
		
		try {
		
			stmt=con.createStatement();
		
			rs = stmt.executeQuery(query);	        
		
			if(rs.next())
				if(rs.getString("id") != null){
					id = rs.getLong("id");
				}
		 
	      
		 } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		id=id+1;
		return id;
	}

	public long getLatestAgencyID(){
		ResultSet rs = null;
	    Statement stmt = null;    


	    long id =0;
		String query = "select max(id) as 'id' from agency";
		
		try {
		
			stmt=con.createStatement();
		
			rs = stmt.executeQuery(query);	        
		
			if(rs.next())
				if(rs.getString("id") != null){
					id = rs.getLong("id");
				}
		 
	      
		 } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		id=id+1;
		return id;
	}
	public long getLatestUserID(){
		ResultSet rs = null;
	    Statement stmt = null;    


	    long id =0;
		String query = "select max(user_id) as 'id' from users";
		
		try {
		
			stmt=con.createStatement();
		
			rs = stmt.executeQuery(query);	        
		
			if(rs.next())
				if(rs.getString("id") != null){
					id = rs.getLong("id");
				}
		 
	      
		 } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		id=id+1;
		return id;
	}


	
}
