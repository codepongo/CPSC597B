<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Python SQLite Admin Tool</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />

    <!-- Le styles -->
    <link href="../../../static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="../../../static/bootstrap/js/jquery-1.10.2.min.js"></script>

    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }

      @media (max-width: 980px) {
        /* Enable use of floated navbar text */
        .navbar-text.pull-right {
          float: none;
          padding-left: 5px;
          padding-right: 5px;
        }
      }
    </style>
    <link href="../../../static/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">

    <script>
        //the following javascrip function is used to redirect to the database page after a database is chosen
        $(function(){
          $('#dynamic_select').bind('change', function () {
              var url = $(this).val();
              if (url) {
                  window.location = url;
              }
              return false;
          });
        });
        
       /* $(document).ready(function(){
          $("#displayDIV").click(function(){
            $("#addColDIV").show();
          });
        });*/

        
        //this function will validate the form
        /*function validateForm(){
            var cn=document.forms["addColForm"]["ColName"].value;
            if (cn==null || cn==""){
              alert("Column name must be filled out");
                return false;
            }
        }*/
        
        
        
    </script>
    
  </head>

  <body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="#">Python SQLite Admin Tool</a>
        </div>
      </div>
    </div>

    <!--left menu-->
    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span3">
            
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Choose Database</li>
              <li><select id="dynamic_select">
                  <option></option>
                  %for name in dbNames:
                    %if name == choosenDB:
                        <option value="/database/{{name}}" selected>{{name}}</option>
                    %else:
                        <option value="/database/{{name}}">{{name}}</option>
                    %end
                  %end
                </select>
              </li>
              <li><a href="/createdb">Create New Database</a></li>
              <li><a href="/dropdb">Drop Database</a></li>
              <li><a href="/uploadDB">Upload Database</a></li>
              <li><a href="/SQLiteDatabases/{{choosenDB}}">Download Database</a></li>
            </ul>
          </div><!--/.well -->
          
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Tables</li>
              <li ><a href="/database/{{choosenDB}}/createTable">Create Table</a></li>
              <li><a href="/database/{{choosenDB}}/dropTable">Drop Table</a></li>
              <li><a href="/database/{{choosenDB}}/manageTable/frontPage">Manage Table</a></li>
              
              <li class="nav-header">Index</li>
              <li><a href="/database/{{choosenDB}}/createIndex">Create Index</a></li>
              <li><a href="/database/{{choosenDB}}/dropIndex">Drop Index</a></li>

              <li class="nav-header">Views</li>
              <li><a href="/database/{{choosenDB}}/createView">Create View</a></li>
              <li><a href="/database/{{choosenDB}}/manageView">Manage View</a></li>
              
              <li class="nav-header">Data</li>
              <li class="active"><a href="frontPage">Manage Data</a>
                 <ul class="nav nav-list">
                    %if tablesList:
                        %for tableN in tablesList:
                            %if tableName == tableN :
                                <li><a href="{{tableN}}" style="color:black;">- {{tableN}}</a></li>
                            %else:
                                <li><a href="{{tableN}}" style="color:brown;">- {{tableN}}</a></li>
                            %end
                        %end
                    %else:
                        <li>- No tables</a></li>
                    %end
                </ul>
              </li>
              <li><a href="/database/{{choosenDB}}/SQLQuery">SQL query</a></li>
              <li><a href="/database/{{choosenDB}}/exportData">Export Data</a></li>
              <li><a href="/database/{{choosenDB}}/importData">Import Data</a></li>
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        
        
        <div class="span9">
          <div class="hero-unit" style="background:#eeeeee;padding: 10px;">
            <center><h2>Manage Table</h2></center>
            </div>
          <div class="row-fluid">
            <div class="span12">
              
                  <table class="table">
                  <thead>
                    <tr>
                        %for colName in tableColNames:
                          <th>{{colName}}</th>
                        %end
                        
                        <th>Update</th>
                        <th>Delete</th>
                    </tr>
                  </thead>
                 <tbody>
                     %for row in tableData:
                        <tr>
                            %datalist = list(row)
                            %rowID = datalist.pop()
                            %for data in datalist:
                                <td>{{data}}</td>
                            %end
                            <td><a class="btn" href="/database/{{choosenDB}}/manageData/{{tableName}}/editRow/{{rowID}}"> <i class="icon-edit"></i></a></td>
                            <td><a class="btn" href="?deleteCol={{rowID}}&pageNo={{pageNo}}"> <i class="icon-trash"></i></a></td>
                        </tr>
                     %end
                  </tbody>
                </table>
                
               %if message != "Succesfull":
                 <p style="color:red">{{message}}</p>      
               %end
            </div><!--/span-->
          </div><!--/row-->
          
          <center><p>
              
          %if pageNo <= 20:
              %for pNo in range(1,21):
                    %if pNo <= noOfPages:
                        %if pageNo == pNo:
                            {{pNo}}
                        %else:
                            <a href="?pageNo={{pNo}}">{{pNo}}</a>
                        %end
                        
                        %if pNo == 20:
                            <a href="?pageNo={{pageNo+20}}"> <i class="icon-forward"></i> &nbsp;</a>
                        %end
                        
                   %end
              %end
          
          %elif pageNo > 20:
              %for pNo in range(((((pageNo/20))*20) + 1),(((pageNo/20))*20)+20):
                    %if pNo <= noOfPages:
                        %if pNo == (((pageNo/20))*20):
                            <a href="?pageNo={{pageNo-20}}"> <i class="icon-backward"></i> &nbsp;</a>
                        %end

                        %if pNo == pageNo:
                            {{pNo}}
                        
                        %else:
                            <a href="?pageNo={{pNo}}">{{pNo}}</a>
                        %end
                        
                        %if pNo == (((pageNo/20))*20)+20 - 1:
                            %if pageNo+20 < noOfPages:
                                <a href="?pageNo={{pageNo+20}}"> <i class="icon-forward"></i> &nbsp;</a>
                            %else:
                                <a href="?pageNo={{noOfPages}}"> <i class="icon-forward"></i> &nbsp;</a>
                            %end
                        %end
                        
                        
                    %end
                
              %end
        %end

          
          
          
          </p> </center>
          
          <br>
          <a href="{{tableName}}/insertRow"><button class="btn" >insert New row</button></a>
          
          
        </div><!--/span-->
      </div><!--/row-->

      <hr>

      

    </div><!--/.fluid-container-->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="../../../static/bootstrap/js/jquery.js"></script>
    <script src="../../../static/bootstrap/js/bootstrap.js"></script>
    <script src="../../../static/bootstrap/js/bootstrap.min.js"></script>
  </body>
</html>
