<html>
	<head>
		<title>Main Menu</title>
		
		<style type="text/css">
			#buttonAttr {
				width: 200px; height=175px;
			}
		</style>
		
	</head>
	<body>
		<!-- Displays the name at the top. -->
		<% String user = (String) session.getAttribute("name"); //Gets name 
			if(user == null) {
			   	response.setHeader("refresh", "0;URL=login.jsp");
			}%>
		<b>Hello <%=user%></b>
		
		<br/>What to do?<p/>
		
		<form method="GET" action="mainMenu.jsp">
			<input name="action" id="buttonAttr" type="submit" value="Main Menu"/>
		</form>
		
		<form method="GET" action="categories.jsp">
			<input name="action" id="buttonAttr" type="submit" value="Categories Management"/>
		</form>
		
		<form method="GET" action="products.jsp">
			<input name="action" id="buttonAttr" type="submit" value="Products Management"/>
		</form>
	</body>
</html>