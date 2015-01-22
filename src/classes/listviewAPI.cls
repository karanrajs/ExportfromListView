/*
Copyright (c) 2014 Karanraj
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
@Description: Visualforce controller for the page to export the records directly from list view
@Author: Karanraj(@karanrajs) 
**/

public with sharing class listviewAPI {

public List<String> fields {get;set;}
public List<String> columnName {get;set;}
public List<sObject> recordList {get;set;}
public List<List<sObject>> allRecords {get;set;}
public List<listviewAPI.Columns> parserCol{get;set;}
public String fileName {get;set;}
public List<Columns> columns;

  public void fetchListviewRecords() {  
     
    columnName = new List<String>();
    fields = new List<String>();
    parserCol =  new List<listviewAPI.Columns>();
    recordList = new List<sObject>();
    allRecords = new List<List<sObject>>();
    String listid = apexpages.currentpage().getparameters().get('listid');
    String ObjectName = apexpages.currentpage().getparameters().get('Object');
    String listName = apexpages.currentpage().getparameters().get('listName');
    fileName =  ObjectName +'_'+listName.replace(' ','_') +'_'+ Datetime.now().format();
    
    //Http callout 
    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
    req.setHeader('Content-Type', 'application/json');
    String domainUrl=URL.getSalesforceBaseUrl().toExternalForm();
    system.debug('********domainUrl:'+domainUrl);
    String endpointUrl=domainUrl+'/services/data/v32.0/sobjects/'+ObjectName+'/listviews/'+listid+'/describe';
    system.debug('domain URL' + endpointUrl);
    req.setEndpoint(endpointUrl);
    req.setMethod('GET');      
    Http h = new Http();
    HttpResponse res = h.send(req);
    Map<String,Object> root  = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());     
    //Nested list logic to overcome collection limit
    for(Sobject sobj : Database.query((string)root.get('query'))){
        recordList.add(sobj);
        if(recordList.size() == 10000){
            allRecords.add(recordList);
            recordList = new List<sObject>();
        }
     }
     
     if(recordList != null && !recordList.isEmpty())
       allRecords.add(recordList);  
       
    //Parsing JSON string to get the column details    
    JSONParser parser = JSON.createParser(res.getBody());
    while (parser.nextToken() != null){ 
        if(parser.getCurrentToken() == JSONToken.START_ARRAY) {       
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    listviewAPI.Columns le = (listviewAPI.Columns)parser.readValueAs(listviewAPI.Columns.class);
                    parserCol.add(le);
                    
                }
            }
        }
     }
         
    for(listviewAPI.Columns lc : parserCol){
        if(lc.hidden == false && lc.fieldNameOrPath != Null){
            fields.add(lc.fieldNameOrPath);
            columnName.add(lc.label);    
        }
     }
  }   
  
  public class Columns {
    
    public String ascendingLabel;
    public String descendingLabel;
    public String fieldNameOrPath;
    public Boolean hidden;
    public String label;
    public String selectListItem;
    public String sortDirection;
    public Integer sortIndex;
    public Boolean sortable;
    public String type;
  }
}