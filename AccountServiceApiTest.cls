@isTest
private class AccountServiceApiTest {
    @TestSetup
    static void createNewAccount(){
        ID thisAccountId = AccountServiceApi.createNewAccount('TestAccountREST'); 
    }
    
    @isTest 
    static void testCreateNewAccount() {
        test.startTest();
        Account thisAccount = [SELECT Name FROM Account LIMIT 1];
        test.stopTest();
        
        System.assertEquals(thisAccount.Name, 'TestAccountREST');
    }
    
    @isTest static void testUpdateAccount() {
        Account thisAccount = [SELECT Name FROM Account LIMIT 1];
        Id thisAccountId = thisAccount.Id;
     
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/services/apexrest/AccountServiceApi/' + thisAccountId;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name":"TestAccountRESTupdt"}');
        RestContext.request = request;

        test.startTest();
        Id accountUpdatedId = AccountServiceApi.updateAccount('TestAccountRESTupdt');
        test.stopTest();
        
        Account thisAccountUpdated = [SELECT Id,Name FROM Account WHERE Id=:accountUpdatedId];
        System.assertEquals(thisAccountUpdated.Name, 'TestAccountRESTupdt');
    }    
}