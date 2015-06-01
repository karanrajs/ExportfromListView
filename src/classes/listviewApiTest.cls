@isTest
private class listviewApiTest {
    
    @isTest static void testAllAccountList() {
    
        List<Account> testAccounts = new List<Account>();
        for(integer i=0; i<100 ; i++){
            Account acc = new Account();
            acc.Name = 'Test Account'+ i;
            testAccounts.add(acc);
        }
        insert testAccounts;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PageReference pageRef = Page.exportStandardListView;
        Test.setCurrentPage(pageRef);
        listviewAPI listviewAPIctrl = new listviewAPI();
        pageRef.getParameters().put('listid', 'ert322144');
        pageRef.getParameters().put('Object', 'Account');
        pageRef.getParameters().put('listName', 'All Account');
        listviewAPIctrl.fetchListviewRecords();
        Test.StopTest();
        system.assertEquals(listviewAPIctrl.fileName,'Account_All_Account_'+Datetime.now().format());
        system.assertEquals(listviewAPIctrl.columnName[0],'Account Name');

    }

    @isTest static void testAllAccountList_error() {
    
        List<Account> testAccounts = new List<Account>();
        for(integer i=0; i<100 ; i++){
            Account acc = new Account();
            acc.Name = 'Test Account'+ i;
            testAccounts.add(acc);
        }
        insert testAccounts;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PageReference pageRef = Page.exportStandardListView;
        Test.setCurrentPage(pageRef);
        listviewAPI listviewAPIctrl = new listviewAPI();
        pageRef.getParameters().put('listid', '');
        pageRef.getParameters().put('Object', '');
        listviewAPIctrl.fetchListviewRecords();
        Test.StopTest();
        system.assertNotEquals(listviewAPIctrl.fileName,'Account_All_Account_'+Datetime.now().format());

    }
}