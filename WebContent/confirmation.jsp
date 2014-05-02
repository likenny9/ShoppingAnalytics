<html>
<head>
<title>Confirmation</title>
</head>
<body>
	    <%
		String user  = (String) session.getAttribute("name"); //Gets name		
		%>
		<b>Hello <%=user%></b>
		<div style="text-align:center">
		<h1>Confirmation</h1>
		</div>
       <%-- Import the java.sql package --%>
     <%@ page import="java.sql.*"%>
     <%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     ResultSet signupIDResult = null;
     int signupID = 0;
     String creditCard = "";
	 creditCard = request.getParameter("creditCard");//Age
	 if(creditCard != null && !creditCard.isEmpty() && !creditCard.trim().isEmpty()) {
	     try {
	         // Registering Postgresql JDBC driver with the DriverManager
	         Class.forName("org.postgresql.Driver");

	         // Open a connection to the database using DriverManager
	         conn = DriverManager.getConnection(
	             "jdbc:postgresql://localhost/cse135?" +
	             "user=postgres&password=postgres");
	     %>
	     <%-- -------- Insert Code ------------------ --%>
	     <%


	         // Begin transaction
	         conn.setAutoCommit(false);
	         
	         //Find owner ID
	         Statement signupStatement = conn.createStatement();

	         signupIDResult = signupStatement.executeQuery("SELECT id FROM signup WHERE name='"+user+"'");
	         while(signupIDResult.next()) {
	         	signupID = signupIDResult.getInt("id");
	         }
	         
             // Create the prepared statement and use it to
             // DELETE products FROM the purchases table.
             pstmt = conn
                 .prepareStatement("DELETE FROM purchases WHERE name = ?");

             pstmt.setInt(1, signupID);
             int rowCount = pstmt.executeUpdate();
	         
	         
	         
	         // Commit transaction
	         conn.commit();
	         conn.setAutoCommit(true);
	     
	     %>
	     <div style="text-align:center">
	     <h2>Success!  Thank you for shopping here!</h2>
	     <h2>Your shopping cart has now been cleared.</h2>
	     </div>

	          <%-- -------- Close Connection Code -------- --%>
	     <%
	         // Close the ResultSet
	         //signupIDResult.close();
	      
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
		         if (signupIDResult != null) {
		             try {
		                 signupIDResult.close();
		             } catch (SQLException e) { } // Ignore
		             signupIDResult = null;
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
		}
		else {
			%>
			<div style="text-align:center">Credit Card info found to be blank.  Purchase unsuccessful.</div><br/>
		<%
		}
		   %>
		 <div style="text-align:center">
	     	<form method="GET" action="productBrowsing.jsp">
				<input type="submit" name="action" value="Click here to return to product browsing"/>
			</form>
		 </div>

</body>
</html>