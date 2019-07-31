package database;

import java.io.InputStream;
import java.io.OutputStream;
import java.sql.*;
import java.util.Properties;

import javax.swing.JOptionPane;



public class SqlServerConnector {
	
	//static Logger log4j = Logger.getLogger(SqlServerConnector.class);
	private  Properties prop = new Properties();
    private  OutputStream output = null;
    private  InputStream input = null;

	public static String dbname = "HDC";
	public static String username = "";
	public static String passwd = "";
	
	
	public Connection con = null;
	
    /** Creates a new instance of ConnectionString */
   public  SqlServerConnector() {
    
        try { 
    		input  = getClass().getResourceAsStream("config.properties");
    		prop.load( input );
           
            
            passwd = prop.getProperty("password");
            username = prop.getProperty("username");

        	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        	String connectionUrl = "jdbc:sqlserver://localhost;databaseName="+dbname+";user="+username+";password="+passwd+";";
        	con = DriverManager.getConnection(connectionUrl);
        }
       catch(ClassNotFoundException ce){
    	   JOptionPane.showMessageDialog(null, ce.getMessage());
    	   
    	   } 
       catch(Exception se){
    	   JOptionPane.showMessageDialog(null, se.getMessage());
    	   }
   }
    
   public  Connection getConnection()
   {
     
     /* try
      {

     	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    	String connectionUrl = "jdbc:sqlserver://localhost;databaseName="+dbname+";user="+username+";password="+passwd+";";

         try
         {            	
            con = DriverManager.getConnection(connectionUrl); 
             								
         // assuming your SQL Server's	username is "username"               
         // and password is "password"
              
         }
         
         catch (SQLException ex)
         {
            ex.printStackTrace();
         }
      }

      catch(ClassNotFoundException e)
      {
         System.out.println(e);
      }
*/
   return con;
}
   
/*   public static void main(String args[]){
	   SqlServerConnector s= new SqlServerConnector();
	   System.out.println("Test"+s.con);
   }
   */
}
