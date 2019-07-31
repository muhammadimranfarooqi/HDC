package labreport;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class LabReportController {
	private PreparedStatement stmt;
	
	Connection con = null;

	public LabReportController(Connection con) {
		this.con = con;
	}
	
	public String getLabNo(String barcode_data){
		String lab_no = null;
		
		String query = "select * from blood_collection where barcode_data = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, barcode_data);
		
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
				lab_no = rs.getString("lab_no");
			rs.close();
			stmt.close();

		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return lab_no;
	}
	
	public String getBarCode(String lab_no){
		String barcode = null;
		
		String query = "select * from blood_collection where lab_no = ? ";
		
		try {
			stmt=con.prepareStatement(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			stmt.setString(1, lab_no);
		
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
				barcode = rs.getString("barcode_data");
			rs.close();
			stmt.close();
			
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	
		return barcode;
	}
	
	
	public ResultSet getLabReportTestByLabNo(String lab_no){
		ResultSet rs = null;
		
		String query = "select * from lab_report where lab_no = ? ";
		
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
		String query = "select * from lab_report where lab_no = ? ";
		
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
