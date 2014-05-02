<html>
<head>
<title>Product Ordering Results</title>
</head>
<body>
	    <%
		String user  = (String) session.getAttribute("name"); //Gets name
	    int product = (Integer) session.getAttribute("parsedProductID");
		
		%>
		<b>Hello <%=user%></b>
		<div style="text-align:center">
		<h1> Product Order</h1>
		</div>
       <%-- Import the java.sql package --%>
     <%@ page import="java.sql.*"%>
     <%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement pstmt = null;
     ResultSet signupIDResult = null;
     int signupID = 0;
     int quantity;
	try {
		quantity = Integer.parseInt(request.getParameter("quantityInput"));//Age
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
	         
	         pstmt = conn.prepareStatement("INSERT INTO purchases "
	        		 + "(name, product, quantity) VALUES (?, ?, ?)");

	         pstmt.setInt(1, signupID);
	         pstmt.setInt(2, product);
	         pstmt.setInt(3, Integer.parseInt(request.getParameter("quantityInput")));
	         int rowCount = pstmt.executeUpdate();
	         
	         
	         
	         // Commit transaction
	         conn.commit();
	         conn.setAutoCommit(true);
	     
	     %>

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
		   %>
		<div style="text-align:center">Success! Redirecting to Product Browsing..<br/>
			Or click to get there faster.</div>
		<% response.setHeader("refresh", "1;URL=productBrowsing.jsp");%>
	<%
	}
	catch(NumberFormatException e) { 
		%> <div style="text-align:center">Your quantity is either blank or not a valid!</div><br/> <% 
	}
%>
	     <div style="text-align:center">
	     		<form method="GET" action="productBrowsing.jsp">
				<input type="submit" name="action" value="Click here to return to product browsing"/>
			</form>
		 </div>

</body>
</html>