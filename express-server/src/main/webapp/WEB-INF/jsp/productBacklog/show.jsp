<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<table summary="Product Backlog" class="backlog">
   <caption>Product Backlog</caption>
   <thead>
   <tr>
      <th>Theme</th>
      <th>Title</th>
      <th>Effort</th>
      <th>Status</th>
   </tr>
   </thead>
   <tbody>
   <c:forEach items="${productBacklog}" var="item">
      <tr>
         <td class="theme">
            <c:choose>
            <c:when test="${fn:length(item.themes) > 0}">
               <c:forEach items="${item.themes}" var="theme">
                  <c:out value="${theme.title}"/>
               </c:forEach>
            </c:when>
            <c:otherwise>
               Default
            </c:otherwise>
            </c:choose>
         </td>
         <td><c:out value="${item.title}"/></td>
         <td><c:out value="${item.effort}"/></td>
         <td><c:out value="${item.status}"/></td>
      </tr>
   </c:forEach>
   </tbody>
</table>