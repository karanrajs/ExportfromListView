ExportfromListView
==================

<a href="https://githubsfdeploy.herokuapp.com?owner=Karanraj&repo=ExportfromListView">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

This allows you to Export records directly from List view of any objects. Find more details about this in my blog. Click <a href="http://clicksandcode.blogspot.in/2014/10/export-records-from-list-viewlistview.html">here</a> 

<h3>Screenshot</h3>
![img](https://lh6.googleusercontent.com/weMR30d680nPb6WNWPZzNjX8PcfiRBvuSxu54iGqKMeG78lRwLypy5BNg4HJTxBn5yoHplRJhqY=w1342-h547)



<h3>Export to Excel button</h3>
To add the Export to excel button follow the below setps, below example for 'Account' object
  <ol>
  <li>Go to Setup –> Accounts –> Buttons, Links and Actions </li>
  <li>Click ‘New Button or Link'</li>
  <li>Enter Label, Name and select display type as ‘List Button’</li>
  <li>Content source as “Onclick Javascript” and paste the below code</li>
  </ol>

```
var listId = document.getElementsByName("fcf")[0].value;
var ObjectName = 'Account'; //API name of the object on which you are creating this button
window.open("apex/exportStandardListView?Object="+ObjectName+"&listid="+listId,"myWindow");
```

<h3>Remote Site settings</h3>
 <ol>
 <li>Go to Setup->Remote Site –> New </li>
 <li>Add the Name and in the URL enter the <a href = "https://help.salesforce.com/HTViewHelpDoc?id=domain_name_app_url_changes.htm&language=en_US">domain name</a> of your org</li>
 <li>Then click save</li>
 </ol>
