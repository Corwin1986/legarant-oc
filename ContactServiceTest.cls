@isTest
private class ContactServiceTest {
    @TestSetup
    static void createNewContact(){
        Id thisContactId = ContactService.createNewContact('John', 'Doe', '0148325124', 'johndoe@gmail.com');
    }
    @isTest 
    static void testCreateNewContact() {
        test.startTest();
        Contact thisContact = [SELECT Id, Email FROM Contact LIMIT 1];
        test.stopTest();

        System.assertEquals(thisContact.Email, 'johndoe@gmail.com');
    }
    @isTest static void testUpdateContact() {
        Id recordId = [SELECT Id FROM Contact LIMIT 1].Id;
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/apexrest/ContactService/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Phone":"0148325124"}');
        RestContext.request = request;
        Id thisContactId = ContactService.updateContact('John', 'Doe','0148325124' ,'johndoe@gmail.com');
        Contact thisContact = [SELECT Id, Phone FROM Contact WHERE Id=:thisContactId];
        System.assertEquals(thisContact.Phone, '0148325124');    
    }
    @isTest static void testDeactivateContact() {
        Id recordId = [SELECT Id FROM Contact LIMIT 1].Id;
        RestRequest request = new RestRequest();
        request.requestURI =  'https://my.salesforce.com/apexrest/ContactService/' + recordId;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Desactivated__c" : "true"}');
        RestContext.request = request;
        Id thisContactId = ContactService.desactivatedContact();
        Contact thisContact = [SELECT Id, Desactivated__c FROM Contact WHERE Id =:thisContactId];
        System.assertEquals(thisContact.Desactivated__c, true);
    }        
   }