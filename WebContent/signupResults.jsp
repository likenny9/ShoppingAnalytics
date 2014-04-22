<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Signup Results</title>
	</head>
	
	<body>
		
		<%-- Import the java.sql package --%>
        <%@ page import="java.sql.*"%>
        
		<%
		String user  = request.getParameter("name");
		String role  = request.getParameter("role"); 
		Integer age = null;
		try {
			age = Integer.parseInt(request.getParameter("age")); }
		catch(NumberFormatException e) { 
			
		}
		String state = request.getParameter("state");
		String stringResults;
		boolean addToDatabase;
		%>	
			
		<%	
		if(!(user.equals(null)) && 
		   (age != null) && 
		   !(role.equals("noRole")) && 
		   !(state.equals("noState")))
		{
		   stringResults = "Welcome " + user;
		   addToDatabase = true;
		}
		else
		{
		   stringResults = "Your signup failed";
		   addToDatabase = false;
		}
		%>
		
		<%= stringResults %> <p>
		
		<%-- -------- Open Connection Code -------- --%>
        
        <%
        
        if(addToDatabase) {
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
         %>
		
		 <%-- -------- INSERT Code -------- --%>
         <%
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
          %>
          
          <%-- -------- Close Connection Code -------- --%>
          <%
          
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
                
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { %> Sign Up <font size="24" color="red"><b>FAILED</b></font> <% } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
        }
          %>

	</body>
</html>