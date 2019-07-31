package physician;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;


public class PhysicianController {
	private PreparedStatement stmt;

	Connection con = null;


	public PhysicianController(Connection con) {
		this.con = con;
	}

	public ResultSet getPhysicianTestByLabNo(String lab_no){
		ResultSet rs = null;
		
		String query = "select * from physician where lab_no = ? ";
		
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

	public boolean checkLabNo(String lab_no){
		ResultSet rs = null;
		boolean test = false;
		String query = "select * from physician where lab_no = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, lab_no);
		
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
	
	
}
