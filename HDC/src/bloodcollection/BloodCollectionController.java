package bloodcollection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;


public class BloodCollectionController {
	private PreparedStatement stmt;
	
	Connection con = null;


	public BloodCollectionController(Connection con) {
		this.con = con;
	}

	public ResultSet getBloodCollectionTestByLabNo(String lab_no){
		ResultSet rs = null;
		
		String query = "select * from blood_collection where lab_no = ? ";
		
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

	public boolean checkBarCode(String barcode_data){
		ResultSet rs = null;
		boolean test = false;
		String query = "select 1 from blood_collection where barcode_data = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, barcode_data);
		
			rs = stmt.executeQuery();
			
			if(rs.next())
				test = true;
			stmt.close();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return test;
	}

	
	public boolean checkLabNo(String lab_no){
		ResultSet rs = null;
		boolean test = false;
		String query = "select 1 from blood_collection where lab_no = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, lab_no);
		
			rs = stmt.executeQuery();
			
			if(rs.next())
				test = true;
			stmt.close();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return test;
	}
	
	
}
