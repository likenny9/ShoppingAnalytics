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
		<% String user = (String) session.getAttribute("name"); //Gets name %>
		<b>Hello <%=user%></b>
		
		<br/>What to do?<p/>
		
		<form method="GET" action="mainMenuC.jsp">
			<input name="action" id="buttonAttr" type="submit" value="Main Menu"/>
		</form>
		
		<form method="GET" action="productBrowsing.jsp">
			<input name="action" id="buttonAttr" type="submit" value="Browse Products"/>
		</form>
		
		<form method="GET" action="shoppingCart.jsp">
			<input name="action" id="buttonAttr" type="submit" value="Shopping Cart"/>
		</form>

	</body>
</html>