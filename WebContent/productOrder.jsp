<html>
	<head>
		<title>Product Order</title>
	</head>
	
	<body>
	    <%
		String user  = request.getParameter("name"); //Gets name
		session.setAttribute("name",user); //Saves name for the session
		%>
		<div style="text-align:center">
		<h1> Product Order</h1>
		<h3><b>Current Shopping Cart:</b></h3>
		</div>
       <%-- Import the java.sql package --%>
     <%@ page import="java.sql.*"%>
     <%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     ResultSet rs2 = null;
     ResultSet signupIDResult = null;
     ResultSet productResult = null;
     int signupID = 0;
     String productName = "";
     int product = Integer.parseInt(request.getParameter("product_id"));
     
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
     String action = request.getParameter("action");
     // Check if an insertion is requested
     if (action != null && action.equals("insert")) {
         // Begin transaction
         conn.setAutoCommit(false);
         
         //Find owner ID
         Statement signupStatement = conn.createStatement();

         signupIDResult = signupStatement.executeQuery("SELECT id FROM signup WHERE name='"+user+"'");
         while(signupIDResult.next()) {
         	signupID = signupIDResult.getInt("id");
         }
         
         Statement productStatement = conn.createStatement();
         productResult = productStatement.executeQuery("SELECT name FROM products WHERE id = '"+product+"'");
         while(productResult.next()) {
          	productName = productResult.getString("name");
          }
         pstmt = conn
         .prepareStatement("INSERT INTO purchases (name, product, quantity) VALUES (?, ?, ?) ");

         pstmt.setInt(1, signupID);
         pstmt.setString(2, productName);
         pstmt.setInt(3, Integer.parseInt(request.getParameter("quantityInput")));
         int rowCount = pstmt.executeUpdate();
         
         
         
         // Commit transaction
         conn.commit();
         conn.setAutoCommit(true);
     }
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
     %>
         <!-- Add an HTML table header row to format the results -->
         <table border="1" align="center">
         <tr>
             <th>Product</th>
             <th>Price</th>
             <th>Quantity</th>
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
         </tr>
     <%
     	while(rs.next()){
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
	         </tr>
     <%
     	}
   	 }
     %>
     </table>
	 
	 <%-- -------- Product Quantity ------------- --%>
	 <%
	 
	    Statement statement2 = conn.createStatement();
	 	// Use the created statement to SELECT
	    // the attributes FROM the purchases table.
	    
	    //TODO change the p.id to something else.
	    rs2 = statement2.executeQuery("SELECT p.name, p.sku, c.name AS category"
	    		+ ", p.price, s.name AS owner FROM categories AS c, products AS"
	    		+ " p, signup AS s WHERE p.id = 3 AND p.category = c.id AND "
	    		+ "p.owner = s.id");
	 %>
	 
	 	<div style="text-align:center">
		<h3><b>Current Product:</b></h3>
		<p></p>
		</div>
		
     <!-- Add an HTML table header row to format the results -->
     <table border="1" align="center">
     <tr>
         <th>Name</th>
         <th>SKU</th>
         <th>Category</th>
         <th>Price</th>
         <th>Owner</th>
     </tr>
     
     <%
          	while(rs2.next()){
     %>
	        <%-- Get the name of the product --%>
	         <tr>
		         <td>
		             <%=rs2.getString("name")%>
		         </td>
		
		         <%-- Get the SKU --%>
		         <td>
		             <%=rs2.getString("sku")%>
		         </td>
		
		         <%-- Get the category --%>
		         <td>
		             <%=rs2.getString("category")%>
		         </td>
		         
		         <%-- Get the price --%>
		         <td>
		             <%=rs2.getDouble("price")%>
		         </td>
		         
		         <%-- Get the owner --%>
		         <td>
		             <%=rs2.getString("owner")%>
		         </td>
	         </tr>
     <%
     	}
	 %>
	 </table>
	 
    <div style="text-align:center">
    <p>How many would you like to buy?</p>
		<form method="POST" action="mainMenu.jsp">
			<input type="hidden" name="action" value="insert"/>
			<p>Quantity: <input size="10" name="quantityInput" value=""/></p>
			<input name="action" type="submit" value="Purchase"/>
		</form>
	</div>
	 
     <%-- -------- Close Connection Code -------- --%>
     <%
         // Close the ResultSet
         rs.close();

         rs2.close();
         // Close the Statement
         statement.close();
         
         statement2.close();
      
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
	         if (rs2 != null) {
	             try {
	                 rs2.close();
	             } catch (SQLException e) { } // Ignore
	             rs2 = null;
	         }
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