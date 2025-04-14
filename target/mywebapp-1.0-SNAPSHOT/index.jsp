<%@ page import="java.util.Calendar" %>
<%
    Calendar cal = Calendar.getInstance();
    int hour = cal.get(Calendar.HOUR_OF_DAY);
    String greeting;

    if (hour < 12) {
        greeting = "Good morning, Nityaom, Welcome to COMP367";
    } else {
        greeting = "Good afternoon, Nityaom, Welcome to COMP367";
    }
%>

<html>
  <body>
    <h1><%= greeting %></h1>
  </body>
</html>
