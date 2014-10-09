public with sharing class listviewAPI {

public List<String> fields {get;set;}
public List<String> columnName {get;set;}
public List<sObject> recordList {get;set;}
public List<List<sObject>> allRecords {get;set;}
public List<listviewAPI.Columns> parserCol{get;set;}
public List<Columns> columns;

  public void fetchListviewRecords() {  
  	 
    columnName = new List<String>();
    fields = new List<String>();
    parserCol =  new List<listviewAPI.Columns>();
    recordList = new List<sObject>();
    allRecords = new List<List<sObject>>();
    String listid = apexpages.currentpage().getparameters().get('listid');
    String ObjectName = apexpages.currentpage().getparameters().get('Object');
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
    for(Sobject sobj : Database.query((string)root.get('query') + ' Limit 100' )){
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