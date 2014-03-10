<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>

<style>
  
  .fancytree-container {
    outline: none;
  }
</style>
<div class="container">
<h1>Change Menu</h1>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
<link href="${pageContext.request.contextPath}/static/css/skin-awesome/ui.fancytree.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/static/js/jquery.fancytree-all.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/jquery.js" type="text/javascript"></script>

  <div class="row" style="min-height:400px">
    <div  class="col-md-4 well well-sm" style="min-height:400px"><div style="outline:none;" id="tree"></div></div>
    <div id="options" class="col-md-6">
      <h3>ZZZZZ</h3>
      <form action="changeItem" id="modal" method="post">
        <input type="hidden" name="menuItemOid" value="null" />
        <input type="hidden" name="menuItemOidParent" value="null" />
        <input type="hidden" name="position" value="" />
      <div class="form-group">
        <button onclick="showModal();return false" class="btn btn-default">Create subitem</button>
      </div>
    
      <div class="form-group">
        <label class="control-label" for="inputSuccess1">Menu Label</label>
        <input type="text" name="name" class="form-control" placeholder="Name">
      </div>

      <div id="menuitem-options">

      <div class="radio">
        <label>
          <input type="radio" name="use" class="useurl" value="url" checked>
          Link to a URL
        </label>
        <div class="form-group">
          <input type="text" name="url" class="url-select form-control" placeholder="URL">
        </div>
      </div>



      <div class="radio">
        <label>
          <input type="radio" name="use" class="usepage" value="page">
          Link to a Page
        </label>
        <div class="form-group">
          <select name="slugPage" class="page-select form-control">
            <option value="null">-</option>
            <c:forEach var="p" items="${site.pages}">
              <option value="${ p.slug }">${ p.name.content }</option>
            </c:forEach>
          </select>
        </div>
      </div>
      
      </div>
      
      <div class="form-group">
        <button type="submit" class="btn btn-primary">Save</button>
        <a href="#" class="btn btn-danger delete">Delete</a>
      </div>
      </form>
    </div>
  </div>

<div class="modal fade">
  <form action="createItem" id="modal" method="post">
    <input type="hidden" name="menuItemOid" value="null" />
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">Create subitem</h4>
      </div>
      <div class="modal-body">
      <div class="form-group">
        <label class="control-label" for="inputSuccess1">Menu Label</label>
        <input type="text" name="name" class="form-control" placeholder="Name">
      </div>

      <div id="menuitem-options">

      <div class="radio">
        <label>
          <input type="radio" name="use" class="useurl" value="url" checked>
          Link to a URL
        </label>
        <div class="form-group">
          <input type="text" name="url" class="url-select form-control" placeholder="URL">
        </div>
      </div>



      <div class="radio">
        <label>
          <input type="radio" name="use" class="usepage" value="page">
          Link to a Page
        </label>
        <div class="form-group">
          <select name="slugPage" class="page-select form-control">
            <option value="null">-</option>
            <c:forEach var="p" items="${site.pages}">
              <option value="${ p.slug }">${ p.name.content }</option>
            </c:forEach>
          </select>
        </div>
      </div>
      
      </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Create item</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
      </form>
</div><!-- /.modal -->
</div>
  <script>

  function optionsForComponent(event, data){
    $("#options").show();
    $("#menuitem-options").show();
    if(data.node.data.root){
      $("#menuitem-options").hide();
    }else{
      if(data.node.data.url){
        $("#options input.useurl").prop("checked",true)
        $("#options input.usepage").prop("checked",false)
        $("#options input[name='url']").prop('readonly', false);
        $("#options input[name='url']").val(data.node.data.url)
        $("#options  select option").filter(function() {
            //may want to use $.trim in here
            return $(this).text() == "-"; 
        }).prop('selected', true);
        $("#options .page-select").prop('readonly', true);
      }else{
        $("#options input.useurl").prop("checked",false)
        $("#options input.usepage").prop("checked",true)
        $("#options input[name='url']").val("")
        $("#options input[name='url']").prop('readonly', true);
        $("#options  select option").filter(function() {
            //may want to use $.trim in here
            return $(this).val() == data.node.data.page; 
        }).prop('selected', true);
      }

      $("#options .delete").attr("href", "delete/"+data.node.key);
    }


    $(".modal [name='menuItemOid']").val(data.node.key);
    $("#options [name='menuItemOid']").val(data.node.key);
    $("#options [name='position']").val(data.node.data.position);
    $("#options [name='menuItemOidParent']").val(data.node.key == "null" ? "null" : data.node.parent.key);
    $("#options h3").html(data.node.title);
    $("#options input[name='name']").val(data.node.title).on("keyup",function(){
      var x = $("#options input[name='name']").val();
      if (x){
        $("#options h3").html(x);
      }else{
        $("#options h3").html("&nbsp;");
      }
    });

    $("#options input[name='name']").val(data.node.title);

  }

  function showModal(){
    $(".modal").modal({});
    $(".modal input[type='text']").val("");
    $(".modal input.useurl").prop("checked", true);

  }

  function setLinks(block){
    return function(){
      if($(block + " input.usepage").is(':checked')){
        $(block + " .url-select").prop('readonly', true);
        $(block + " .url-select").val("");
        $(block + " .page-select").prop('readonly', false);
      }else{
        $(block + " .url-select").prop('readonly', false);
        $(block + " select option").filter(function() {
            //may want to use $.trim in here
            return $(this).text() == "-"; 
        }).prop('selected', true);
        $(block + " .page-select").prop('readonly', true);
      }
    };
  }

  $("#options").hide();

  $(function(){
      $("#options input[name='name']").on("keypress",function(){
        var x = $("#options input[name='name']").val();
        if (x){
          $("#options h3").html(x);
        }else{
          $("#options h3").html("&nbsp;");
        }
      });

      $("#options input[name='use']").on('click',setLinks("#options"));
      setLinks("#options")();

      $(".modal input[name='use']").on('click',setLinks(".modal"));
      setLinks(".modal")();

      // Create the tree inside the <div id="tree"> element.
      $("#tree").fancytree({ 
          source: {
            url: "data"
          },
          click: optionsForComponent,
          init:function(){
             $("#tree").fancytree("getRootNode").visit(function(node){
                node.setExpanded(true);
             });
          },
          extensions: ["dnd"],
          dnd: {
            preventVoidMoves: true, // Prevent dropping nodes 'before self', etc.
            preventRecursiveMoves: true, // Prevent dropping nodes on own descendants
            autoExpandMS: 400,
            dragStart: function(node, data) {
              optionsForComponent({},{node:node});
              return true;
            },
            dragEnter: function(node, data) {
               return true;
            },
            dragDrop: function(node, data) {
              if (data.hitMode === "before" || data.hitMode === "after"){
                if(data.hitMode === "before"){
                  $("#options [name='position']").val(node.data.position);
                }else{
                  $("#options [name='position']").val(node.data.position + 1);
                }
                $("#options [name='menuItemOidParent']").val(node.parent.key);
              }else if(data.hitMode === "over"){
                if (node.children){
                  $("#options [name='position']").val(node.children.length);
                }else{
                  $("#options [name='position']").val(0);
                }
                $("#options [name='menuItemOidParent']").val(node.key);
              }
              $("#options form").submit();
            }
          },
      });
  });


  </script>
  
