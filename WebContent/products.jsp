<html>
	<head>
		<title>Products</title>
	</head>
	<body>
		<!-- Displays the name at the top. -->
		<% String auser = (String) session.getAttribute("name"); //Gets name 
			if(auser == null) {
			   	response.setHeader("refresh", "0;URL=login.jsp");
			}%>
		<b>Products Management</b><p/>
		
		<table>
		<tr>
	    	<td valign="top">
	            <%-- -------- Include menu HTML code -------- --%>
	            <jsp:include page="mainMenu.jsp" />

		
		<%-- Import the java.sql package --%>
        <%@ page import="java.sql.*"%>
        
        <%-- -------- Open Connection Code -------- --%>
        <%
        String user = (String) session.getAttribute("name"); //Gets name
        String sortAttribute = (String) session.getAttribute("sortAttribute");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSet rs2 = null;
        ResultSet searchRS = null;
        String rsResults = null;
        
        ResultSet categoryResult = null;
        String categoryResults = null;
        
        ResultSet categoryIDResult = null;
        int categoryID = 0;
        ResultSet signupIDResult = null;
        int signupID = 0;
        
        ResultSet categoryIDUpdateR = null;
        int categoryIDUpdate = 0;
        ResultSet signupIDUpdateR = null;
        int signupIDUpdate = 0;
        
        try {
            // Registering Postgresql JDBC driver with the DriverManager
            Class.forName("org.postgresql.Driver");

            // Open a connection to the database using DriverManager
            conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost/cse135?" +
                "user=postgres&password=postgres");
            
            //Find category ID
            Statement catIDStatement = conn.createStatement();
            //Find owner ID
            Statement signupStatement = conn.createStatement();
            //Find category ID
            Statement catIDUpdateStatement = conn.createStatement();
            //Find owner ID
            Statement signupIDUpdateStatement = conn.createStatement();
        %>
		
		<%-- -------- SORT By Categories Code -------- --%>
		<p><u>Sort by Categories</u></p>
		<% 
        // Create the statement
        Statement categoryListStatement = conn.createStatement();

        // Use the created statement to SELECT
        // the category attributes FROM the Category table.
        rs = categoryListStatement.executeQuery("SELECT name FROM categories");
        %>
        
        <form action="products.jsp" method="GET">
            <input type="hidden" name="sortAction" value="sortAll"/>
        	<input name="sortedAction" type="submit" value="All Products"/>
        </form>
        <%
        while(rs.next()) {
        	%>
       	    <form action="products.jsp" method="GET">
               <input type="hidden" name="sortAction" value="sort"/>
               <input name="sortedCats" type="submit" value="<%=rs.getString("name")%>"/>

        	</form>
        	<% 
        }
        %>
       	</td>
       	
	    <td valign="top">
		<table border="4" >
            
	        <%-- -------- INSERT Code -------- --%>
	        <%
	        	String searchAction = request.getParameter("searchAction");
	        	String sortAction = request.getParameter("sortAction");
	            String action = request.getParameter("action");
	            // Check if an insertion is requested
	            if (action != null && action.equals("insert")) {
	
	                // Begin transaction
	                conn.setAutoCommit(false);
					
	                categoryIDResult = catIDStatement.executeQuery("SELECT id FROM categories WHERE name='"+request.getParameter("category")+"'");
	                while(categoryIDResult.next()) {
	                	
	                	categoryID = categoryIDResult.getInt("id");
	                }
	                
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
                    pstmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
	                pstmt.setInt(5, signupID);
	                int rowCount = pstmt.executeUpdate();
					
	                %>
	                <b><font size="10">INSERT CONFIRMATION:</font></b><br/>
	                <b>Name:</b> <%=request.getParameter("name")%> -
	                <b>SKU:</b> <%=request.getParameter("sku")%> -
	                <b>Category:</b> <%=request.getParameter("category")%> -
	                <b>Price:</b> <%=request.getParameter("price")%>          
	                <% 
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
                    
	                categoryIDUpdateR = catIDUpdateStatement.executeQuery("SELECT id FROM categories WHERE name='"+request.getParameter("category")+"'");
	                while(categoryIDUpdateR.next()) {
	                	
	                	categoryIDUpdate = categoryIDUpdateR.getInt("id");
	                }
	                
	                signupIDUpdateR = signupIDUpdateStatement.executeQuery("SELECT id FROM signup WHERE name='"+request.getParameter("owner")+"'");
	                while(signupIDUpdateR.next()) {
	                	signupIDUpdate = signupIDUpdateR.getInt("id");
	                }

                    // Create the prepared statement and use it to
                    // UPDATE product values in the products table.
                    pstmt = conn
                        .prepareStatement("UPDATE products SET name = ?, sku = ?, "
                            + "category = ?, price = ?, owner = ? WHERE id = ?");

                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("sku"));
                   	pstmt.setInt(3, categoryIDUpdate);
                    pstmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
	                pstmt.setInt(5, signupIDUpdate);
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
                Statement statement = conn.createStatement();
            
            	Statement categoryStatement = conn.createStatement();
             	
            	//SHOW ALL PRODUCTS
             	if(sortAction != null && !(sortAction.equals("sort"))) {
                	rs = statement.executeQuery("SELECT products.id, products.name, sku, categories.name AS category_name, "
                    		+ "price, signup.name AS user_name FROM products, categories, signup "
                    		+ "WHERE products.owner=signup.id AND products.category = categories.id");
            		//Saves the all products attribute so we can search from all products later
                	sortAttribute = request.getParameter("sortedAction");
            		session.setAttribute("sortAttribute",sortAttribute);
             	}
            	//SEARCH FROM ALL PRODUCTS
             	else if((searchAction != null) && searchAction.equals("search") && (sortAttribute.equals("All Products")) && (request.getParameter("searchInput") != "")) {
                    	
                	rs = statement.executeQuery("SELECT products.id, products.name, sku, categories.name AS category_name, "
                    		+ "price, signup.name AS user_name FROM products, categories, signup "
                    		+ "WHERE products.owner=signup.id AND products.category = categories.id AND products.name LIKE '%"+request.getParameter("searchInput")+"%'");
            	}
            	//SEARCH FROM SPECIFIC CATEGORIES
             	else if((searchAction != null) && searchAction.equals("search") && (request.getParameter("searchInput") != "")) {
            		rs = statement.executeQuery("SELECT products.id, products.name, sku, categories.name AS category_name, "
                        	+ "price, signup.name AS user_name FROM products, categories, signup "
                        	+ "WHERE products.owner=signup.id AND products.category = categories.id "
                        	+ "AND categories.name='"+sortAttribute+"' AND products.name LIKE '%"+request.getParameter("searchInput")+"%'");             		
             	}
				//SHOW FROM SPECIFIC CATEGORIES
            	else if(sortAction != null && sortAction.equals("sort")) {
            		rs = statement.executeQuery("SELECT products.id, products.name, sku, categories.name AS category_name, "
                    	+ "price, signup.name AS user_name FROM products, categories, signup "
                    	+ "WHERE products.owner=signup.id AND products.category = categories.id AND categories.name='"+request.getParameter("sortedCats")+"'");
            		//Saves the last category clicked so we can search from this specific category later
            		sortAttribute = request.getParameter("sortedCats");
            		session.setAttribute("sortAttribute",sortAttribute);
            	}
                categoryResult = categoryStatement.executeQuery("SELECT name FROM categories");
                
                if(rs != null) {
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
                    <td><input type="text" name="owner" value="<%=user%>" size="15" readonly/></td>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="products.jsp" method="POST">
                
                    <input type="hidden" name="action" value="update"/>
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
	                    <select name="category">
						<% rsResults = rs.getString("category_name"); //Displays category name%>
						<option name="category" value="<%=rsResults%>" size="15"><u><%=rsResults%></u></option>
						<% 
						//Second ResultSet to list the rest of the category names in the dropdown
						Statement categoryDropDown = conn.createStatement();
						rs2 = categoryDropDown.executeQuery("SELECT name FROM categories");
						while(rs2.next()) {
							if(!(rs2.getString("name").equals(rsResults))) { //if it's not the category already listed
								%> 
								<option name="category" value="<%=rs2.getString("name")%>" size="15"><u><%=rs2.getString("name")%></u></option>
								<%
							}
						}
						%>
						</select>
	                </td>
	
	                <%-- Get the price --%>
	                <td>
	                    <input value="<%=rs.getString("price")%>" name="price" size="15"/>
	                </td>
	                
	                <%-- Get the owner name --%>
	                <td>
	                    <input value="<%=rs.getString("user_name")%>" name="owner" size="15" readonly/>
	                </td>                
	
	                <%-- Button --%>
	                <td>
	                	<input type="submit" value="Update">
	                </td>
                	
                </form>
                
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                
               		 <%-- Button --%>
               		 <td>
                		<input type="submit" value="Delete"/>
                	</td>
                </form>
            </tr>

            <%
                } //end while
                } //end if rs != null
            %>
			</table>
			
			<%-- -------- SEARCH BOX Code -------- --%>
	       <form action="products.jsp" method="POST">
	           	<input type="hidden" name="searchAction" value="search"/>
	          	<p>Product Search <input size="20" name="searchInput" value=""/>
	       		<input name="searchAction" type="submit" value="Search"/></p>
	       </form>
	       
        </td>
    	</tr>
		</table>
        
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();
            
            	//rs2.close();
            
            	// Close category ResultSelt
            	categoryResult.close();
            	
            	// Category ID
            	//categoryIDResult.close();
            	
            	//Close signup ID
            	//signupIDResult.close();
            	
            	// Category ID
            	//categoryIDUpdateR.close();
            	
            	//Close signup ID
            	//signupIDUpdateR.close();

                // Close the Statement
                statement.close();
                
                // Close category statement
                categoryStatement.close();
                
                catIDUpdateStatement.close();
                
                signupStatement.close();
                signupIDUpdateStatement.close();
               
                // Close the Connection
                conn.close();
            } catch (Exception e) {
                //throw new RuntimeException(e);
            	
            	//This will catch all exceptions and show this error message.
                %><p><b>Failure to insert or update products. <br/> Please click on Products and try again.</b></p> <% 
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
                if (rs2 != null) {
                    try {
                        rs2.close();
                    } catch (SQLException e) { } // Ignore
                    rs2 = null;
                }
                if (categoryResult != null) {
                    try {
                        categoryResult.close();
                    } catch (SQLException e) { } // Ignore
                    categoryResult = null;
                }
                if (categoryIDResult != null) {
                    try {
                        categoryIDResult.close();
                    } catch (SQLException e) { } // Ignore
                    categoryIDResult = null;
                }
                if (categoryIDUpdateR != null) {
                    try {
                        categoryIDUpdateR.close();
                    } catch (SQLException e) { } // Ignore
                    categoryIDUpdateR = null;
                }
                if (signupIDResult != null) {
                    try {
                        signupIDResult.close();
                    } catch (SQLException e) { } // Ignore
                    signupIDResult = null;
                }
                if (signupIDUpdateR != null) {
                    try {
                        signupIDUpdateR.close();
                    } catch (SQLException e) { } // Ignore
                    signupIDUpdateR = null;
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