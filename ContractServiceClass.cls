@RestResource(urlMapping='/Contract/*')
global with sharing class ContractServiceClass {
    @HttpPost
    global static Id createNewContract(String Name, String Status, Id AccountId, Date StartDate, Integer ContractTerm) {
        //a. Création d’un contrat : quand un contrat est créé dans le CRM AXG, 
		//   les informations sont envoyées vers Salesforce et l’Id de Salesforce est sauvegardé.
        Contract thisContract = new Contract(
            Name = Name,
            Status = Status,
            AccountId = AccountId,
       	    StartDate = StartDate,
            ContractTerm = ContractTerm);
        insert thisContract;
        return thisContract.Id;
    }
     @HttpPatch
    global static Id updateContract(String Name, String Status, Id AccountId) {
        RestRequest request = RestContext.request;
        String Id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contract result = [SELECT Id FROM Contract WHERE Id = :Id];
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        Contract thisContract = new Contract(); 
        thisContract.Id = Id;  
        thisContract.Name = Name;
        thisContract.Status = Status;
        thisContract.AccountId = AccountId;
        for(String fieldName : params.keySet()) {
        thisContract.put(fieldName, params.get(fieldName));
        }
        update thisContract;
        return thisContract.Id;
    }    
    /*@HttpPatch
    global static Id updateContract(String Name, String Status, Id AccountId){
        //b. Modification d’un contrat : à chaque modification du contrat,
        //   il faut mettre à jour le contrat dans Salesforce en se basant sur l’Id de Salesforce.
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contract result = [SELECT Id, Name, Status, AccountId FROM Contract WHERE Id = :id];
        Contract thisContract = new Contract(); 
        thisContract.Id = id;  
        thisContract.Name = Name;
        thisContract.Status = Status;
        thisContract.AccountId = AccountId;
        update thisContract;
        return thisContract.Id;
    }*/
  }