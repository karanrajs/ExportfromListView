ExportfromListView
==================

<a href="https://githubsfdeploy.herokuapp.com?owner=Karanraj&repo=ExportfromListView">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

This allows you to Export records directly from List view of any objects.<br/> 
Find more details about in my blog click <a href="http://clicksandcode.blogspot.in/2014/10/export-records-from-list-viewlistview.html">here</a> 

<h3>Screenshot</h3>
![img](/images/ExportToExcel.png)



<h3>Export to Excel button</h3>
To add the Export to excel button follow the below setps, below example for 'Account' object
  <ol>
  <li>Go to Setup –> Accounts –> Buttons, Links and Actions </li>
  <li>Click ‘New Button or Link'</li>
  <li>Enter Label, Name and select display type as ‘List Button’</li>
  <li>Content source as “Onclick Javascript” and paste the below code</li>
  </ol>

```
//Getting List Name 
var listview = document.getElementsByName('fcf')[0]; 
var listName = listview.options[listview.selectedIndex].text; 
//Getting List Id 
var listId = document.getElementsByName("fcf")[0].value; 
var ObjectName = 'Account'; 
//Passing ListId,ObjectName and ListName to Visualforce page 
window.open("apex/exportStandardListView?Object="+ObjectName+"&listid="+listId+"&listName="+listName,"myWindow");
```

<h3>Remote Site settings</h3>
 <ol>
 <li>Go to Setup->Remote Site –> New </li>
 <li>Add the Name and in the URL enter the <a href = "https://help.salesforce.com/HTViewHelpDoc?id=domain_name_app_url_changes.htm&language=en_US">domain name</a> of your org</li>
 <li>Then click save</li>
 </ol>
