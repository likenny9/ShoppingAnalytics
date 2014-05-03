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
		<b>Browse Products</b><p/>
		
		<table>
		<tr>
	    	<td valign="top">
	            <%-- -------- Include menu HTML code -------- --%>
	            <jsp:include page="mainMenuC.jsp" />

		
		<%-- Import the java.sql package --%>
        <%@ page import="java.sql.*"%>
        
        <%-- -------- Open Connection Code -------- --%>
        <%
        String user = (String) session.getAttribute("name"); //Gets name
        String sortAttribute = (String) session.getAttribute("sortAttribute");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        ResultSet categoryResult = null;
        
        try {
            // Registering Postgresql JDBC driver with the DriverManager
            Class.forName("org.postgresql.Driver");

            // Open a connection to the database using DriverManager
            conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost/cse135?" +
                "user=postgres&password=postgres");
            
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
        
        <form action="productBrowsing.jsp" method="GET">
            <input type="hidden" name="sortAction" value="sortAll"/>
        	<input name="sortedAction" type="submit" value="All Products"/>
        </form>
        <%
        while(rs.next()) {
        	%>
       	    <form action="productBrowsing.jsp" method="GET">
               <input type="hidden" name="sortAction" value="sort"/>
               <input name="sortedCats" type="submit" value="<%=rs.getString("name")%>"/>

        	</form>
        	<% 
        }
        %>
       	</td>
       	
	    <td valign="top">
		<table border="4" >
            
	        <%-- -------- Set the strings for Actions -------- --%>
	        <%
	        	String searchAction = request.getParameter("searchAction");
	        	String sortAction = request.getParameter("sortAction");
	            String action = request.getParameter("action");
	        %>
	        
	       	<%-- -------- BUY Statement Code -------- --%>
	        <%
            	if (action != null && action.equals("buy")) {
            		
            	}
	        %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                Statement statement = conn.createStatement();
            
            	Statement categoryStatement = conn.createStatement();
             	
            	//SHOW ALL PRODUCTS
              	if((sortAction != null && !(sortAction.equals("sort"))) || (action != null && action.equals("Browse Products"))) {
                	rs = statement.executeQuery("SELECT products.id, products.name, sku, categories.name AS category_name, "
                    		+ "price, signup.name AS user_name FROM products, categories, signup "
                    		+ "WHERE products.owner=signup.id AND products.category = categories.id");
            		//Saves the all products attribute so we can search from all products later
            		if(action == null) { //Only if we didn't click Products Management
                		sortAttribute = request.getParameter("sortedAction");
            			session.setAttribute("sortAttribute",sortAttribute);
            		}
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
                <th>Product Name</th>
                <th>SKU</th>
                <th>Category</th>
                <th>Price</th>
                <th>Product Owner</th>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="productOrder.jsp" method="POST">
                    <input type="hidden" name="action" value="buy"/>
                    <input type="hidden" name="product_id" value="<%=rs.getInt("id")%>"/>
	
	                <%-- Get the name --%>
	                <td>
	                    <%=rs.getString("name")%>
	                </td>
	
	                <%-- Get the sku --%>
	                <td>
	                    <%=rs.getString("sku")%>
	                </td>
	
	                <%-- Get the category --%>
	                <td>
	                    <%=rs.getString("category_name")%>
	                </td>
	
	                <%-- Get the price --%>
	                <td>
	                    <%=rs.getString("price")%>
	                </td>
	                         
		            <%-- Get the owner name --%>
	                <td>
	                    <%=rs.getString("user_name")%>
	                </td>  
	                
	                <%-- Buy Button --%>
               		<form action="productOrder.jsp" method="POST">
                    	<input type="hidden" name="action" value="buy"/>
                    	<input type="hidden" value="<%=rs.getInt("id")%>" name="product_id"/>
                    	<% session.setAttribute("product_id", rs.getInt("id"));%>
               		 <%-- Button --%>
               		 <td>
                		<input type="submit" value="Buy"/>
                	</td>
                	
                	</form>
                	
                </form>
                
            </tr>

            <%
                } //end while
                } //end if rs != null
            %>
			</table>
			
			<%-- -------- SEARCH BOX Code -------- --%>
	       <form action="productBrowsing.jsp" method="POST">
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
            
            	// Close category ResultSelt
            	categoryResult.close();

                // Close the Statement
                statement.close();
                    
                // Close the Connection
                conn.close();
                
            } catch (Exception e) {
                //throw new RuntimeException(e);
            	
            	//This will catch all exceptions and show this error message.
                %><p><b>HEY!!! You did something you weren't suppose to.</b></p> <% 
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
	</body>
</html>