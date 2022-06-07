@isTest
private class ContractServiceClassTest {
    @isTest 
    static void CreateNewContractTest() {
        Account account = new Account();
        account.Name ='AccountTest';
        insert account;
        Id thisContractId = ContractServiceClass.createNewContract('ContractTest','Draft',account.Id,Date.valueOf('2022-01-01'),12);
        Contract thisContract = [SELECT Id, ContractTerm FROM Contract WHERE Id =:thisContractId];
        System.assertEquals(thisContract.ContractTerm, 12);
    }
    @isTest 
    static void UpdateContractTest(){
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/apexrest/ContractServiceClass/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Status":"Activated"}');
        RestContext.request = request;
        Contract ctc = [SELECT Name ,AccountId FROM Contract WHERE Id =: recordId];
        Id thisContractId = ContractServiceClass.updateContract(ctc.Name, 'Activated', ctc.AccountId);
        Contract thisContract = [SELECT Id, Status FROM Contract WHERE Id=:thisContractId];
        System.assertEquals(thisContract.Status, 'Activated'); 
    }
    static Id CreateTestRecord(){
        Account accountTest = new Account();
        accountTest.Name ='TestAccount';
        insert accountTest;
        Contract contractTest = new Contract(
            Name = 'TestContract',
            Status = 'Draft',
            AccountId = accountTest.Id);
        insert contractTest;
        return contractTest.Id;
    }
}