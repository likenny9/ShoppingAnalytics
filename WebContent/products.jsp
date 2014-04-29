<html>
	<head>
		<title>Products</title>
	</head>
	<body>
		
		<b>Products Management</b><p/>
		
		<table>
		<tr>
	    	<td valign="top">
	            <%-- -------- Include menu HTML code -------- --%>
	            <jsp:include page="mainMenu.jsp" />
	        </td>
	        <td>
		
		<%-- Import the java.sql package --%>
        <%@ page import="java.sql.*"%>
        
        <%-- -------- Open Connection Code -------- --%>
        <%
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        ResultSet categoryResult = null;
        String categoryResults = null;
        
        ResultSet categoryIDResult = null;
        int categoryID = 0;
        ResultSet signupIDResult = null;
        int signupID = 0;
        
        
        
        try {
            // Registering Postgresql JDBC driver with the DriverManager
            Class.forName("org.postgresql.Driver");

            // Open a connection to the database using DriverManager
            conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost/cse135?" +
                "user=postgres&password=postgres");
        %>
		
		<table border="4" >
            
	        <%-- -------- INSERT Code -------- --%>
	        <%
	            String action = request.getParameter("action");
	            // Check if an insertion is requested
	            if (action != null && action.equals("insert")) {
	
	                // Begin transaction
	                conn.setAutoCommit(false);
					
	                Statement catIDStatement = conn.createStatement();
	                categoryIDResult = catIDStatement.executeQuery("SELECT id FROM categories WHERE name='"+request.getParameter("category")+"'");
	                while(categoryIDResult.next()) {
	                	
	                	categoryID = categoryIDResult.getInt("id");
	                }
	                
	                Statement signupStatement = conn.createStatement();
	                signupIDResult = signupStatement.executeQuery("SELECT id FROM signup WHERE name='"+request.getParameter("owner")+"'");
	                while(signupIDResult.next()) {
	                	signupID = signupIDResult.getInt("id");
	                }
	                
	                // Create the prepared statement and use it to
	                // INSERT product values INTO the products table.
	                pstmt = conn
	                .prepareStatement("INSERT INTO products (name, sku, category, price, owner) VALUES (?, ?, ?, ?, ?) ");
	
	                pstmt.setString(1, request.getParameter("name"));
	                pstmt.setString(2, request.getParameter("sku"));
                   	pstmt.setInt(3, categoryID);
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("price")));
	                pstmt.setInt(5, signupID);
	                int rowCount = pstmt.executeUpdate();
	
	                // Commit transaction
	                conn.commit();
	                conn.setAutoCommit(true);
	            }
	        %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE product values in the products table.
                    pstmt = conn
                        .prepareStatement("UPDATE products SET name = ?, sku = ?, "
                            + "category, price = ?, owner = ? WHERE id = ?");

                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("sku"));
                    pstmt.setString(3, request.getParameter("category"));
                    pstmt.setString(4, request.getParameter("price"));
                    pstmt.setString(5, request.getParameter("owner"));
                    pstmt.setInt(6, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE products FROM the products table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM products WHERE id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();
            
            	//
            	Statement categoryStatement = conn.createStatement();

                // Use the created statement to SELECT
                // the product attributes FROM the products table.
                rs = statement.executeQuery("SELECT products.id, products.name, sku, categories.name AS category_name, "
                		+ "price, signup.name AS user_name FROM products, categories , signup "
                		+ "WHERE products.owner=signup.id AND products.category = categories.id");
                
                categoryResult = categoryStatement.executeQuery("SELECT name FROM categories");
            %>
            	
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Product Name</th>
                <th>SKU</th>
                <th>Category</th>
                <th>Price</th>
                <th>Owner</th>
            </tr>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="name" size="10"/></th>
                    <th><input value="" name="sku" size="15"/></th>
                    <th><select name="category">
						<option value="noCategory">--Choose One--</option>
						<% while(categoryResult.next()) {
							categoryResults = categoryResult.getString("name");%>
						<option name="category" value="<%=categoryResults%>"><%=categoryResults%></option>
						<% } %>
						</select></th>
                    <th><input value="" name="price" size="15"/></th>
                    <th><input value="" name="owner" size="15"/></th>
                    <th><input type="submit" value="Insert Product"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="products.jsp" method="POST">
                
                    <input type="hidden" name="action" value="Update Product"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>
                    
	                <%-- Get the id --%>
	                <td>
	                    <%=rs.getInt("id")%>
	                </td>
	
	                <%-- Get the name --%>
	                <td>
	                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
	                </td>
	
	                <%-- Get the sku --%>
	                <td>
	                    <input value="<%=rs.getString("sku")%>" name="sku" size="15"/>
	                </td>
	
	                <%-- Get the category --%>
	                <td>
	                    <input value="<%=rs.getString("category_name")%>" name="category" size="15"/>
	                </td>
	
	                <%-- Get the price --%>
	                <td>
	                    <input value="<%=rs.getString("price")%>" name="price" size="15"/>
	                </td>
	                
	                <%-- Get the owner name --%>
	                <td>
	                    <input value="<%=rs.getString("user_name")%>" name="owner" size="15"/>
	                </td>                
	
	                <%-- Button --%>
	                <td>
	                	<input type="submit" value="Update Product">
	                </td>
                	
                </form>
                
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                
               		 <%-- Button --%>
               		 <td>
                		<input type="submit" value="Delete Product"/>
                	</td>
                </form>
            </tr>

            <%
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();
            
            	// Close category ResultSelt
            	categoryResult.close();

                // Close the Statement
                statement.close();
                
                // Close category statement
                categoryStatement.close();

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
                if (categoryResult != null) {
                    try {
                        categoryResult.close();
                    } catch (SQLException e) { } // Ignore
                    categoryResult = null;
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
        	</table>
        
        </td>
    	</tr>
		</table>
	</body>
</html>