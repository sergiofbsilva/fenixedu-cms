<%--

    Copyright © 2014 Instituto Superior Técnico

    This file is part of FenixEdu CMS.

    FenixEdu CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FenixEdu CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FenixEdu CMS.  If not, see <http://www.gnu.org/licenses/>.

--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@taglib uri="http://fenixedu.com/cms/permissions" prefix="permissions" %>
${portal.toolkit()}

<div class="page-header">
    <h1>Content Managment
          <c:if test="${cmsSettings.canManageSettings()}">
          <button type="button" class="btn btn-link" data-target="#sites-settings" data-toggle="modal"><i class="glyphicon glyphicon-wrench"></i></button>
          </c:if>
          <small>

              <ol class="breadcrumb">
                  <c:if test="${not empty query}">
                      <li><c:out value="${query}"/></li>
                  </c:if>
              </ol>
          </small>
    </h1>
</div>


<style>
  .site{
    padding-left: 24px !important;
  }
</style>

<style>
  .folder{
    padding-top: 20px !important;
  }
  .folder i{
    float:left;
    color: #888;
    padding-right: 5px;
  }

  .folder h5{
    text-transform: uppercase;
    font-weight: bold;
    margin-bottom: 0px;
    margin-top: 0px;
  }
  .modal .modal-header h3{ text-transform: uppercase; }
</style>
<p>

<div class="row">
  <div class="col-sm-8">
    <c:if test="${cmsSettings.canManageSettings()}">
      <div class="btn-group">
      <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#create-site"><i class="glyphicon glyphicon-plus"></i> New</button>
      <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <span class="caret"></span>
        <span class="sr-only">Toggle Dropdown</span>
      </button>
      <ul class="dropdown-menu">
        <li><a href="#" onclick="$('#import-button').click();">Import</a></li>
        <form id="import-form" method="post" action="${pageContext.request.contextPath}/cms/sites/import" enctype='multipart/form-data'>
            ${csrf.field()}
            <input id="import-button" class="hidden" type="file" name="attachment" onchange="$('#import-form').submit();" />
        </form>
      </ul>
      </div>
    </c:if>

    <c:if test="${cmsSettings.canManageThemes()}">
      <a href="${pageContext.request.contextPath}/cms/themes" class="btn btn-default"><i class="glyphicon glyphicon-wrench"></i> Themes</a>
    </c:if>

  </div>
  <div class="col-sm-4">
  <div class="input-group">
      <div class="input-group-btn">
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <c:if test="${folder != null and folder != 'no-folder'}">${folder.functionality.title.content}</c:if>
          <c:if test="${folder != null and folder == 'no-folder'}">Untagged</c:if>
          <c:if test="${folder == null}">Tag</c:if>
         <span class="caret"></span></button>
        <ul class="dropdown-menu">
          <c:if test="${not empty tag}">
            <li><a class="search-tag" href="" data-val="">Any</a></li>
          </c:if>
          <c:forEach var="f" items="${foldersSorted}">
            <c:if test="${f == null}">
              <li><a class="search-tag" href="#" data-val="untagged">Untagged</a></li>
            </c:if>
            <c:if test="${f != null}">
                <li><a class="search-tag" href="#" data-val="${f.functionality.path}">${f.functionality.title.content}</a></li>
            </c:if>
          </c:forEach>
        </ul>
      </div><!-- /btn-group -->
      <input id="search-query" type="text" class="form-control" placeholder="Search for..." value="${query}" autofocus>
    </div><!-- /input-group -->
  </div>
  </div>


<c:if test="${not empty query or not empty tag}">
<c:choose>
    <c:when test="${sites.size() == 0}">
        <div class="panel panel-default">
          <div class="panel-body">
            <spring:message code="site.manage.label.emptySites"/>
          </div>
        </div>
    </c:when>

  <c:otherwise>

    <table class="table">
  <thead>
    <tr>
      <th>Name</th>
      <th>Created</th>
      <th>Published</th>
    </tr>
  </thead>
  <tbody>
       <c:forEach var="i" items="${sites}" >
      <tr>
        <td class="col-md-8 site">

        <a href="${pageContext.request.contextPath}/cms/sites/${i.slug}">${i.getName().getContent()}</a>

        <c:if test="${i.getEmbedded()}">
          <span class="label label-info">Embedded</span></c:if><c:if test="${i.isDefault()}"><span class="label label-success"><spring:message code="site.manage.label.default"/></span>
        </c:if>

        </td>
        <td class="col-md-2">${cms.prettyDate(i.creationDate)}</td>
        <td class="col-md-2"><p>
         <span class="glyphicon glyphicon-option-vertical"></span>
              <input type="checkbox" ng-model="post.active" id="success" class="ng-pristine ng-valid">
              <label for="success">Published</label>
              </p>
            <div class="dropdown pull-right">
              <a class="dropdown-toggle" href="#" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                <span class="caret"></span>
              </a>
              <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenu1">
                <li><a href="${pageContext.request.contextPath}/cms/sites/${i.slug}/edit">View details</a></li>
                <c:if test="${i.published}">
                  <li><a href="${i.fullUrl}">Visit public URL</a></li>
                </c:if>
                <c:if test="${permissions:canDoThis(i, 'MANAGE_ROLES')}">
                  <li><a href="${pageContext.request.contextPath}/cms/sites/${i.slug}/roles">View roles</a></li>
                </c:if>
                  <c:if test="${cmsSettings.canManageSettings()}">
                      <li><a href="#makeDefault" data-slug="${i.slug}">Make default site</a></li>
                  </c:if>
              </ul>
            </div>
        </td>
      </tr>
      </c:forEach>
  </tbody>
</table>
      <form id="defaultSiteForm" class="hidden" action="${pageContext.request.contextPath}/cms/sites/defaultSite" method="post">
          <input type="hidden" name="slug"/>
      </form>
      <script>
          $("a[data-slug]").click(function(e) {
              e.preventDefault()
              $("#defaultSiteForm input").val($(this).data('slug'))
              $("#defaultSiteForm").submit()
          })
      </script>
    <c:if test="${partition.getNumPartitions() > 1}">
      <nav class="text-center">
        <ul class="pagination">
          <li ${partition.isFirst() ? 'class="disabled"' : ''}>
            <a href="#" onclick="goToPage(${partition.getNumber() - 1})">&laquo;</a>
          </li>
          <li class="disabled"><a>${partition.getNumber()} / ${partition.getNumPartitions()}</a></li>
          <li ${partition.isLast() ? 'class="disabled"' : ''}>
            <a href="#" onclick="goToPage(${partition.getNumber() + 1})">&raquo;</a>
          </li>
        </ul>
      </nav>
    </c:if>
  </c:otherwise>
</c:choose>
</c:if>


<jsp:include page="manageModals.jsp" />