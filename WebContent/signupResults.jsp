<html>
	<head>
		<title>Signup Results</title>
	</head>
	
	<body>
		
		<%-- Import the java.sql package --%>
        <%@ page import="java.sql.*"%>
        
		<%
		String user  = request.getParameter("name"); //Name			
		String role  = request.getParameter("role"); //Role 
		Integer age = null;
		try {
			age = Integer.parseInt(request.getParameter("age")); //Age
		}
		catch(NumberFormatException e) { 
			%> <div style="text-align:center">Your age is either blank or not a valid!</div><br/> <% 
		}
		String state = request.getParameter("state"); //State
		
		String stringResults = null; //Result of user input
		String databaseName = null; //Result of database query
		boolean addToDatabase;
		%>					
		
		<%-- -------- Open Connection Code -------- --%>
        
        <%
            
        Connection conn = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        
        try {
            // Registering Postgresql JDBC driver with the DriverManager
            Class.forName("org.postgresql.Driver");

            // Open a connection to the database using DriverManager
            conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost/cse135?" +
                "user=postgres&password=postgres");
        %>

         <%-- -------- SELECT Code -------- --%>
         <%
         // Create the statement
         Statement statement = conn.createStatement();

     	 rs = statement.executeQuery("SELECT name FROM signup WHERE name='"+user+"' ");
     	
     	 while(rs.next()) {
     		 databaseName = rs.getString("name");
     	 }
     	
		 if(user.equals(databaseName)) 
		 {
		 	 stringResults = "SIGNUP FAILED";
	         %> <div style="text-align:center">Username is already taken!<br/> Redirecting to previous page...</div><br/> <%
			 addToDatabase = false;
		 }
		 else if(!(user.equals(null)) && 
		    (age != null) && 
		    !(role.equals("noRole")) && 
		    !(state.equals("noState"))) 
		 {
		    stringResults = "Hello " + user;
		    addToDatabase = true;
		 }
		 else
		 {
		    stringResults = "SIGNUP FAILED";
		    addToDatabase = false;
		 }
	     %>
	     
	     <div style="text-align:center"><font size=24><b><%= stringResults %></b></font></div><p/>
      
      <%-- -------- INSERT Code -------- --%>
      <%
	  	 if(addToDatabase) {
		     String action = request.getParameter("action");
		     // Check if an insertion is requested
		     //System.out.println(action.equals("Create Account"));
		     if (action != null && action.equals("Create Account")) {
		
		         // Begin transaction
		         conn.setAutoCommit(false);
		
		         // Create the prepared statement and use it to
		         // INSERT student values INTO the students table.
		         pstmt = conn
		         .prepareStatement("INSERT INTO signup (name, role, age, state) VALUES (?, ?, ?, ?)");
		          
		         pstmt.setString(1, request.getParameter("name"));	                	
		         pstmt.setString(2, request.getParameter("role"));
		         pstmt.setInt(3, Integer.parseInt(request.getParameter("age")));
		         pstmt.setString(4, request.getParameter("state"));
		         int rowCount = pstmt.executeUpdate();
		
		         // Commit transaction
		         conn.commit();
		         conn.setAutoCommit(true);
		
		     }
	  	 }
      %>
      
      <%-- -------- Close Connection Code -------- --%>
      <%
      // Close the ResultSet
      rs.close(); 
      
            // Close the Connection
            conn.close();
            
        } catch (SQLException e) {

            // Wrap the SQL exception in a runtime exception to propagate
            // it upwards

            throw new RuntimeException(e);
        }
        finally {
            // Release resources in a finally block in reverse-order of
            // their creation
            if (rs != null) {
             try {
                 rs.close();
             } catch (SQLException e) { } // Ignore
             rs = null;
         }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) { } // Ignore
                pstmt = null;
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) { } // Ignore
                conn = null;
            }
        }
          %>

	</body>
</html>