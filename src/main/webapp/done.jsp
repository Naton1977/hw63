<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: User
  Date: 23.11.2020
  Time: 09:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    String URL = "jdbc:mysql://localhost/ToDoList";
    String USER = "root";
    String PASSWORD = "";
    String taskDescription;
    String taskCategory;
    String periodExecution;
    String importance;
    int importanceInt = 0;
    int count = 0;
%>

<%
    Connection connect = DriverManager.getConnection(URL, USER, PASSWORD);
    Statement stmt = connect.createStatement();
    connect.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");
    String buttonValue = request.getParameter("button");
    String taskName = request.getParameter("TaskName");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Title</title>
    <style>
        table {
            border: 1px solid black;
            border-collapse: collapse;
            text-align: center
        }

        td {
            border: 1px solid black;
        }
    </style>
</head>
<body>
<p>Выполненные задания</p>
<table width='1000px'>
    <thead>
    <tr>
        <td>Название задачи</td>
        <td>Описание задачи</td>
        <td>Категория задачи</td>
        <td>Срок выполнения</td>
        <td>Важность</td>
    </thead>
    <tbody>
    <%
        ResultSet resultSet = stmt.executeQuery("select * from completedtasks order by id desc;");
        while (resultSet.next()) {
            out.println("<tr>");
            out.println("<td>" + resultSet.getString("TaskName") + "</td>");
            out.println("<td>" + resultSet.getString("TaskDescription") + "</td>");
            out.println("<td>" + resultSet.getString("TaskCategory") + "</td>");
            out.println("<td>" + resultSet.getString("PeriodOfExecution") + "</td>");
            out.println("<td>" + resultSet.getString("Importance") + "</td>");
            out.println("</tr>");
        }
    %>

    </tbody>
</table>
</body>
</html>
