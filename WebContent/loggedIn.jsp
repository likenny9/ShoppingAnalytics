<html>
	<head>
		<title>Logging In</title>
		
		<style type="text/css">
			#buttonAttr {
				width: 200px; height=175px;
			}
		</style>
		
	</head>
	<body>
		<%
		String user  = request.getParameter("name"); //Gets name
		session.setAttribute("name",user); //Saves name for the session
		String stringResults = ""; //Result of user input
		String databaseName = null; //Result of database query
		String role = null; //Role of customer
				
		
		%>
						
        <%-- Import the java.sql package --%>
        <%@ page import="java.sql.*"%>
        <%-- -------- Open Connection Code -------- --%>
        <% 
        
        Connection conn = null;
        ResultSet rs = null;
        
        try {
            // Registering Postgresql JDBC driver with the DriverManager
            Class.forName("org.postgresql.Driver");

            // Open a connection to the database using DriverManager
            conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost/cse135?" +
                "user=postgres&password=postgres");
                     
            // Create the statement
            Statement statement = conn.createStatement();

        	rs = statement.executeQuery("SELECT name FROM signup WHERE name='"+user+"' ");
        	
        	while(rs.next()) {
            	databaseName = rs.getString("name");
        	}
        	
        	//Code for either customer or owner
        	Statement statement2 = conn.createStatement();
        	rs = statement2.executeQuery("SELECT role FROM signup WHERE name='"+user+"'");
        	while(rs.next()) {
        		role = rs.getString("role");
        	}
        	
            // Close the ResultSet
            rs.close();

            // Close the Statement
            statement.close();

            // Close the Connection
            conn.close();
        } 
        catch (SQLException e) {

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
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) { } // Ignore
                conn = null;
            }
        }
        
		if(user.length() == 0) {
			%>
			<div style="text-align:center">
				<h1>No username specified.</h1><br/>
				<b>Redirecting to login page...</b>
			</div>
			
			<%
		   	response.setHeader("refresh", "2;URL=login.jsp"); 
		   	
		}
		else if(databaseName == null) {
        	stringResults = user + " is not known.";
        	
    		%>
    		<div style="text-align:center">
    		<b>Log In</b>
    				<form method="GET" action="loggedIn.jsp">
    					<p>Username: <input size="20" name="name" value=""/><p />
    				
    					<input name="action" type="submit" value="Login"/>
    				</form>
    		</div>
    		<%
        }
        else {
        	stringResults = "Hello " + databaseName;
        }
		%>
	
		<div style="text-align:center">
			<font size=24><b><%= stringResults %></b></font>
			
			<% 
			if(databaseName != null) {
				if(role.equals("owner")) {
				%>
					<br/>Click here for Main Menu.<p/>
					
					<form method="GET" action="mainMenu.jsp">
						<input name="action" id="buttonAttr" type="submit" value="Main Menu"/>
					</form>
				<%
				}
				else {
				%>
					<br/>Click here for Main Menu.<p/>
					
					<form method="GET" action="mainMenuC.jsp">
						<input name="action" id="buttonAttr" type="submit" value="Main Menu"/>
					</form>
				<%
				}
			}
			%>
		</div>
		
	</body>
</html>