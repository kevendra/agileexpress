<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
   <link type="text/css" href="${ctx}/css/express.css" rel="stylesheet"/>
   <link type="text/css" href="${ctx}/css/colorpicker.css" rel="stylesheet"/>
   <script type="text/javascript" src="${ctx}/js/jquery-1.3.2.min.js"></script>
   <script type="text/javascript" src="${ctx}/js/jquery.form-2.18.js"></script>
   <script type="text/javascript" src="${ctx}/js/express.js"></script>
   <script type="text/javascript" src="${ctx}/js/colorpicker.js"></script>
   <title>Express | Sign Up</title>
</head>

<body id="register">
<div id="top">
   <ul class="mainNav">
      <li>
         <img src="${ctx}/images/separator.gif" height="29" alt="separator"/>
         <a href="${ctx}/index.html">Home</a>
      </li>
      <li>
         <img src="${ctx}/images/separator.gif" height="29" alt="separator"/>
         <a href="${ctx}/documentation.html">Pricing</a>
      </li>
      <li>
         <img src="${ctx}/images/separator.gif" height="29" alt="separator"/>
         <a href="${ctx}/faq.html">Support</a>
      </li>
      <li>
         <img src="${ctx}/images/separator.gif" height="29" alt="separator"/>
         <a href="${ctx}/data/register.html">Sign Up</a>
      </li>
      <li>
         <img src="${ctx}/images/separator.gif" height="29" alt="separator"/>
         <a href="${ctx}/express.html">Application</a>
      </li>
   </ul>
</div>

<div id="banner">
   <img id="logo" src="${ctx}/images/logo.png" alt="Express"/>
   <div class="message"><c:out value="${msg}"/></div>
</div>

<div id="main">
   <form:form method="post" action="${ctx}/data/register.html" commandName="user" onsubmit="return validate();">
      <fieldset>
         <legend> Login Details</legend>
         <table class="form">
            <tbody>
            <tr>
               <td class="label"><form:label path="email">Email (username)</form:label></td>
               <td><form:input path="email"/><form:errors path="email"/></td>
            </tr>
            <tr>
               <td class="label"><form:label path="password">Password</form:label></td>
               <td><form:password path="password"/><form:errors path="email"/></td>
            </tr>
            <tr>
               <td class="label"><label for="confirm">Confirm Password</label></td>
               <td><input id="confirm" type="password"/><form:errors path="email"/></td>
            </tr>
            <tr>
               <td class="label"><form:label path="passwordHint">Password Hint</form:label></td>
               <td><form:input path="passwordHint"/><form:errors path="email"/></td>
            </tr>
            </tbody>
         </table>
         <ul class="form">
            <li>These fields are required so that you can login and use Express.</li>
            <li>Your password is enrypted with a one way encryption algorithm and cannot be
               recoveredif you
               forget it. Because of this we require a password hint. If you forget your password
               you can request
               that we email you the hint.
            </li>
         </ul>
      </fieldset>

      <fieldset>
         <legend> User Details</legend>
         <table class="form">
            <tbody>
            <tr>
               <td class="label"><form:label path="firstName">First Name</form:label></td>
               <td><form:input path="firstName"/></td>
            </tr>
            <tr>
               <td class="label"><form:label path="lastName">Last Name</form:label></td>
               <td><form:input path="lastName"/></td>
            </tr>
            <tr>
               <td class="label"><form:label path="phone1">Phone (main)</form:label></td>
               <td><form:input path="phone1"/></td>
            </tr>
            <tr>
               <td class="label"><form:label path="phone2">Phone (other)</form:label></td>
               <td><form:input path="phone2"/></td>
            </tr>
            <tr>
               <td class="label"><form:label path="colour">Wall Colour</form:label></td>
               <td><div id="colorSelector"><div style="background-color:#0000ff"></div> </div> <form:hidden path="colour"/></td>
            </tr>
            </tbody>
         </table>
         <ul class="form">
            <li>
               These fields are optional. They are not required but filling them in will improve the
               experience
               for you and the other people on your project team(s).
            </li>
            <li>
               If you don't fill in your first and last name then your email (username) with the
               domain name
               removed will appear in place of your real name.
            </li>
            <li>
               The <i>wall colour</i> is the colour Express will tag your stories and tasks with. If
               you don't
               choose one, we will assign you one randomly so that others on the team can tell your
               cards apart.
            </li>
         </ul>
      </fieldset>
      <div class="buttonHolder">
         <button type="submit">Submit</button>&nbsp;&nbsp;
         <a href="#" onclick="return reset();">reset</a>
      </div>
   </form:form>
</div>
<div id="footer">&copy; Copyright 2009 redredred&nbsp;&nbsp;&nbsp;</div>
</body>
</html>
