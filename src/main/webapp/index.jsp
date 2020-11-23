<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page pageEncoding="utf-8" contentType="text/html;utf-8" %>

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
<head>
    <meta charset='utf-8'>
    <title>ToDoList</title>
    <style>
        table {
            border: 1px solid black;
            border-collapse: collapse;
            text-align: center;
            width: 1000px;
        }

        td {
            border: 1px solid black;
            text-align: center;
        }
    </style>
</head>
<body>
<form id='form' method='post' accept-charset='utf-8'>
    <label>Название задачи<br>
        <input type='text' name='TaskName' size='50' required>
    </label><br>
    <label>Описание задачи<br>
        <input type='text' name='TaskDescription' size='50'>
    </label><br>
    <label>Категория задачи<br>
        <input type='text' name='TaskCategory' size='50'>
    </label><br>
    <label>Срок выполнения(Год-Месяц-День)<br>
        <input type='text' name='PeriodExecution' size='50'>
    </label><br>
    <label>Важность (от 1 до 10)<br>
        <input type='text' name='Importance' size='50'>
    </label><br>
    <p></p>
    <input id='submitButton' type='submit'/>
</form>
<p></p>
<table>
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
        if (buttonValue != null && count > 0) {
            ResultSet buttVal = stmt.executeQuery("select * from uncompletedtasks;");
            while (buttVal.next()) {
                String value = buttVal.getString("id");
                if (buttonValue.equals(value)) {
                    String name = buttVal.getString("TaskName");
                    String description = buttVal.getString("TaskDescription");
                    String category = buttVal.getString("TaskCategory");
                    String execution = buttVal.getString("PeriodOfExecution");
                    String importan = buttVal.getString("Importance");
                    int imp = Integer.parseInt(importan);
                    Statement stmt2 = connect.createStatement();
                    connect.setAutoCommit(false);
                    try {
                        stmt2.executeUpdate("insert into completedtasks(TaskName, TaskDescription, TaskCategory, PeriodOfExecution, Importance) value('" + name + "', '" + description + "','" + category + "', '" + execution + "', '" + imp + "');");
                        connect.commit();
                    } catch (Exception e) {
                        connect.rollback();
                    }
                    connect.setAutoCommit(true);
                    Statement stmt1 = connect.createStatement();
                    connect.setAutoCommit(false);
                    try {
                        stmt1.executeUpdate("delete from uncompletedtasks where id = '" + value + "';");
                        connect.commit();
                    } catch (Exception e) {
                        connect.rollback();
                    }
                    connect.setAutoCommit(true);
                    stmt = connect.createStatement();
                    ResultSet resultSet = stmt.executeQuery("select * from uncompletedtasks;");
                    while (resultSet.next()) {
                        out.println("<tr>");
                        out.println("<td>" + resultSet.getString("TaskName") + "</td>");
                        out.println("<td>" + resultSet.getString("TaskDescription") + "</td>");
                        out.println("<td>" + resultSet.getString("TaskCategory") + "</td>");
                        out.println("<td>" + resultSet.getString("PeriodOfExecution") + "</td>");
                        out.println("<td>" + resultSet.getString("Importance") + "</td>");
                        out.println("<td id='done'>" + "<form id='button'><button id='butt' type='submit' name='button' value = '" + resultSet.getString("id") + "'>Выполнить</button></form>" + "</td>");
                        out.println("</tr>");
                    }
                }
            }
            this.count++;
        }
    %>


    <%
        if (buttonValue == null && taskName == null) {
            stmt = connect.createStatement();
            ResultSet resultSet = stmt.executeQuery("select * from uncompletedtasks;");
            while (resultSet.next()) {
                out.println("<tr>");
                out.println("<td>" + resultSet.getString("TaskName") + "</td>");
                out.println("<td>" + resultSet.getString("TaskDescription") + "</td>");
                out.println("<td>" + resultSet.getString("TaskCategory") + "</td>");
                out.println("<td>" + resultSet.getString("PeriodOfExecution") + "</td>");
                out.println("<td>" + resultSet.getString("Importance") + "</td>");
                out.println("<td>" + "<form id='button'><button id='butt' type='submit' name='button' value = '" + resultSet.getString("id") + "'>Выполнить</button></form>" + "</td>");
                out.println("</tr>");
            }
            this.count++;
        }
    %>


    <%
        if (taskName != null && count > 0) {
            taskDescription = request.getParameter("TaskDescription");
            taskCategory = request.getParameter("TaskCategory");
            periodExecution = request.getParameter("PeriodExecution");
            importance = request.getParameter("Importance");
            System.out.println(taskDescription);
            if (importance != null) {
                try {
                    importanceInt = Integer.parseInt(importance);
                } catch (Exception e) {

                }
            }
            connect.setAutoCommit(false);
            try {
                stmt.executeUpdate("insert into uncompletedtasks(TaskName, TaskDescription, TaskCategory, PeriodOfExecution, Importance) value('" + taskName + "', '" + taskDescription + "','" + taskCategory + "', '" + periodExecution + "', '" + importanceInt + "');");
                connect.commit();
            } catch (Exception e) {
                connect.rollback();
            }
            connect.setAutoCommit(true);
            ResultSet resultSet = stmt.executeQuery("select * from uncompletedtasks;");
            while (resultSet.next()) {
                out.println("<tr>");
                out.println("<td>" + resultSet.getString("TaskName") + "</td>");
                out.println("<td>" + resultSet.getString("TaskDescription") + "</td>");
                out.println("<td>" + resultSet.getString("TaskCategory") + "</td>");
                out.println("<td>" + resultSet.getString("PeriodOfExecution") + "</td>");
                out.println("<td>" + resultSet.getString("Importance") + "</td>");
                out.println("<td>" + "<form id='button'><button id='butt' type='submit' name='button' value = '" + resultSet.getString("id") + "'>Выполнить</button></form>" + "</td>");
                out.println("</tr>");
            }
            this.count++;
        }

    %>
    </tbody>
</table>
<script>
    let submitForm = function (e) {
        if (e.target.id === 'submitButton') {
            document.forms['form'].submit();
        }
    }
    let clearForm = function (e) {
        if (e.target.id === 'submitButton') {
            document.forms['form'].reset();
        }
    }
    let clearButton = function (e) {
        if (e.target.id === 'butt') {
            document.forms['button'].reset();
        }
    }
    let clearAll = function (e) {
        document.forms['form'].reset();
        document.forms['button'].reset();
    }
    document.body.addEventListener('click', submitForm);
    window.addEventListener('load', clearForm);
    window.addEventListener('load', clearButton);
    window.addEventListener('beforeunload', clearAll);
</script>
<a href='/done.jsp'>Выполненные задания</a>
</body>
</html>

