@isTest
global class mockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"query":"Select Id from Account","columns":[ {"ascendingLabel" : "Z-A","label" : "Account Name","fieldNameOrPath" : "Account Name","hidden":false}]}');
        res.setStatusCode(200);
        return res;
    }
}