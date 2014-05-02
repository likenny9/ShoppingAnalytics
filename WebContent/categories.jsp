<html>
	<head>
		<title>Categories</title>
		
		<style type="text/css">
			#descriptionBox {
				display: block;
				width: 210px; height: 50px;
			}
		</style>
	</head>

<body>

	<!-- Displays the name at the top. -->
	<% String user = (String) session.getAttribute("name"); //Gets name 
		if(user == null) {
		   	response.setHeader("refresh", "0;URL=login.jsp");
		}%>
<b>Categories Management</b><p/>

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
            ResultSet rs2 = null;
            
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
                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    pstmt = conn
                    .prepareStatement("INSERT INTO categories (name, description) VALUES (?, ?)");

                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("description"));
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
                    // UPDATE category values in the Categories table.
                    pstmt = conn
                        .prepareStatement("UPDATE categories SET name = ?, description = ? "
                            + "WHERE id = ?");

                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("description"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
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
                    // DELETE categories FROM the Categories table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM categories WHERE id = ?");

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
                Statement statement2 = conn.createStatement();

                // Use the created statement to SELECT
                // the category attributes FROM the Category table.
                rs = statement.executeQuery("SELECT * FROM categories");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
            </tr>

            <tr>
                <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="name" size="10"/></th>
                    <th><textarea name="description" style="resize:none" rows="4" cols="50"></textarea></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="categories.jsp" method="POST">
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

                <%-- Get the description --%>
                <td>
                    <textarea value="" style="resize:none" rows="4" cols="50" name="description"><%=rs.getString("description")%></textarea>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                
                
	            <%
	                
	
	                // Use the created statement to SELECT
	                // the category attributes FROM the Category table.
	                int y = rs.getInt("id");
	                rs2 = statement2.executeQuery("SELECT p.id FROM products AS p WHERE p.category ='"+y+"' ");
	                	if(!(rs2.next())) {
			    %>
		                <form action="categories.jsp" method="POST">
		                    <input type="hidden" name="action" value="delete"/>
		                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
		                    <%-- Button --%>
		                <td><input type="submit" value="Delete"/></td>
		                </form>
		                
		        <%
	                	}
                %>
            </tr>

            <%
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();
            	
	            // Close the ResultSet
	            rs2.close();
	
	            // Close the Statement
	            statement2.close();
	            
                // Close the Connection
                conn.close();
            } catch (SQLException e) {

            	//This will catch all exceptions and show this error message.
                %><p><b>Failure to insert or update category. <br/> Please click on Categories and try again.</b></p> <% 
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
        </table>
        </td>
    </tr>
</table>
</body>

</html>

