<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.nexttech.spanishreview.worksheet.WorksheetGenerator" %>
<%@ page import="com.nexttech.spanishreview.worksheet.Worksheet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta charset="utf-8">
    <title>Spanish Review</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <!-- Stylesheets -->
    <link rel="stylesheet" href="/css/bootstrap.min.css" media="screen">
    <link rel="stylesheet" href="/css/custom.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dragula/3.7.1/dragula.min.css">


    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>

    <script src="/js/bootstrap.min.js"></script>

    <!-- Google sign in stuff -->
    <script src="https://apis.google.com/js/client:platform.js?onload=start" async defer></script>
    <meta name="google-signin-client_id" content="453755821502-1k95kijujmdh4g16opd1qpaqn6miboro.apps.googleusercontent.com">
</head>
<body>
<div class="navbar navbar-default navbar-fixed-top top">
    <div class="container">
        <div class="navbar-header">
            <a href="../" class="navbar-brand">Spanish Review</a>
            <button class="navbar-toggle" type="button" data-toggle="collapse" data-target="#navbar-main">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
        </div>
        <div class="navbar-collapse collapse" id="navbar-main">
            <ul class="nav navbar-nav">

            </ul>

            <ul class="nav navbar-nav navbar-right">
                <%
                    UserService userService = UserServiceFactory.getUserService();
                    User user = userService.getCurrentUser();
//                        user.
                    if(user == null) {
                %>
                <li><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></li>
                <%--<li><div class="g-signin2" data-onsuccess="onSignIn"></div></li>--%>
                <%
                } else {
                    pageContext.setAttribute("user", user);
//                            User user = userService.getCurrentUser();
                %>
                <%--<li><%userService.createLoginURL(request.getRequestURI());%></li>--%>
                <li><p class="nav navbar-text">Hi, ${fn:escapeXml(user.nickname)}!</p></li>
                <li><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a></li>
                <%
                    }
                %>
                <!--<li><a href="http://builtwithbootstrap.com/" target="_blank">Built With Bootstrap</a></li>-->
                <!--<li><a href="https://wrapbootstrap.com/?ref=bsw" target="_blank">WrapBootstrap</a></li>-->
            </ul>

        </div>
    </div>
</div>

<br />
<br />
<br />
<div class="row">
    <%
        WorksheetGenerator worksheetGenerator = new WorksheetGenerator();
        Worksheet ws;
        String typeOfWorksheet = request.getParameter("type");
        if(typeOfWorksheet == null || typeOfWorksheet.equals("regular")) {
            ws = worksheetGenerator.getRegularWorksheet();
        } else {
            ws = worksheetGenerator.getBlankWorksheet();
        }
        String[][] wsArray = ws.getWorksheet();
        List<String> wordBank = ws.getWordBank();
//        System.out.println(wordBank.size());
    %>
    <div class="col-sm-8" id="worksheet-container">
        <br />
        <br />
        <br />
        <table class="table table-striped table-hover table-responsive table-bordered" id="worksheet-table">
            <tr>
                <% for (String item : wsArray[0]) { %>
                    <th><%=item%></th>
                <%}%>
            </tr>
            <% for(int i = 1; i < wsArray.length; i++) {%>
                <tr class="worksheet-row">
                    <% for(int j = 0; j < wsArray[i].length; j++) {%>
                        <!-- Makes colspan appropriate for rows that are smaller -->
                        <% if(wsArray[i][j].equals("")) {%>
                            <td class="cell droppable"></td>
                        <% } else {%>
                        <td class="cell" colspan="<%=wsArray[i].length == 3 && j == 2 ? 3 : (wsArray[i].length == 2 && j == 1 ? 4 : 1) %>%>"><%=wsArray[i][j]%></td>
                        <%}
                    }%>
                </tr>
            <%}%>
        </table>
    </div>
    <div class="col-sm-4 right droppable" id="wordbank-container">
        <br />
        <br />
        <br />
        <% for(String word : wordBank) {%>
            <div class="well"><%=word%></div>
        <%}%>
    </div>
</div>
<div class="modal fade" id="signin-failure" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Could not sign in.</h4>
            </div>
            <div class="modal-body">
                <p>Sign in failed. Make sure you're signing in with your mcpsmd.net Google account. Your data will not be seen by your teacher unless you do this.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>

    </div>
</div>

<script src='https://cdnjs.cloudflare.com/ajax/libs/dragula/3.7.1/dragula.min.js'></script>
<script src="/js/custom.js"></script>

</body>
</html>
