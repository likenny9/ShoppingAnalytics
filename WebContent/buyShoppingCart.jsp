<html>
	<head>
		<title>Buy Shopping Cart</title>
	</head>
	
	<body>
	    <%
		String user  = (String) session.getAttribute("name"); //Gets name
		%>
		<b>Buy Shopping Cart</b><p/>
		<div style="text-align:center">
		
		<table>
		<tr>
		 <%-- -------- Include menu HTML code -------- --%>
	     <td valign="top"><jsp:include page="mainMenuC.jsp" /></td>
	     <td width="75%">
	    
		<h3><b>Current Shopping Cart:</b></h3>
		</div>
       <%-- Import the java.sql package --%>
     <%@ page import="java.sql.*"%>
     <%-- -------- Open Connection Code -------- --%>
     <%
     Connection conn = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     double totalShoppingCart = 0;
     
     try {
         // Registering Postgresql JDBC driver with the DriverManager
         Class.forName("org.postgresql.Driver");

         // Open a connection to the database using DriverManager
         conn = DriverManager.getConnection(
             "jdbc:postgresql://localhost/cse135?" +
             "user=postgres&password=postgres");
     %>
     
     
     
     <%-- -------- Shopping Cart -------- --%>
	 <%
	   // Create the statement
	   Statement statement = conn.createStatement();
	
	   // Use the created statement to SELECT
	   // the attributes FROM the purchases table.
	   rs = statement.executeQuery("SELECT products.name, products.price, "
			   + "quantity FROM purchases, products, signup WHERE "
			   + "signup.id=purchases.name AND purchases.product=products.id "
			   + "AND signup.name='"+user+"'");
   	if(!(rs.next())) {
	 %>
	 	<div style="text-align:center">
		<p>Nothing in Shopping Cart!</p>
		</div>
     <%
   	}
     else {
         double priceAmount = rs.getDouble("price")*(double)(rs.getInt("quantity"));
         totalShoppingCart += priceAmount;
     %>
         <!-- Add an HTML table header row to format the results -->
         <table border="1" align="center">
         <tr>
             <th>Product</th>
             <th>Price</th>
             <th>Quantity</th>
             <th>Amount Price</th>
         </tr>
         <%-- Get the name of the product --%>
         <tr>
	         <td>
	             <%=rs.getString("name")%>
	         </td>
	
	         <%-- Get the price --%>
	         <td>
	             <%=rs.getDouble("price")%>
	         </td>
	
	         <%-- Get the quantity --%>
	         <td>
	             <%=rs.getInt("quantity")%>
	         </td>
	         
	         <%-- Get the amount price --%>
	         <td>
	             <%=priceAmount%>
	         </td>
         </tr>
     <%
     	while(rs.next()){
     		priceAmount = rs.getDouble("price")*(double)(rs.getInt("quantity"));
            totalShoppingCart += priceAmount;
     %>
	        <%-- Get the name of the product --%>
	         <tr>
		         <td>
		             <%=rs.getString("name")%>
		         </td>
		
		         <%-- Get the price --%>
		         <td>
		             <%=rs.getDouble("price")%>
		         </td>
		
		         <%-- Get the quantity --%>
		         <td>
		             <%=rs.getInt("quantity")%>
		         </td>
		         <%-- Get the amount price --%>
		         <td>
		             <%=priceAmount%>
		         </td>
	         </tr>
     <%
     	}
     %>
     </table>
     <div style="text-align:center">
     <h2>Total Price of Shopping Cart: <%=totalShoppingCart%></h2>
     <p>Please enter your Credit Card Information to complete the transaction.</p>
     <form method="GET" action="confirmation.jsp">
     	<p>Credit Card: <input size="10" name="creditCard" value=""/></p>
		<input type="submit" name="action" value="Purchase Shopping Cart"/>
	</form>
	 </div>
     <%
   	 }
     %>
	 
	 
     <%-- -------- Close Connection Code -------- --%>
     <%
         // Close the ResultSet
         rs.close();
         // Close the Statement
         statement.close();
         
      
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
	   </td>
	   </tr>
	   </table>
	</body>
</html>