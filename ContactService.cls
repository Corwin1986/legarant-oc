@RestResource(urlMapping='/Contact/*')
global with sharing class ContactService {
    @HttpPost
    global static Id createNewContact(String FirstName, String LastName, String Phone, String Email) {
        // a. Création d’un contact : quand un contact est créé dans CRM AXG, il faut vérifier si
		// l’email existe déjà.
		// S’il existe, mettre l’id de Salesforce dans le CRM AXG
		// S’il n’existe pas, créer un nouveau contact dans Salesforce et prendre l’id.
        List<Contact> contactList = [SELECT Id FROM Contact WHERE Email =: Email] ;
        Contact ctc = (contactList != null && contactList.size()>0)?contactList[0]:null;
        if (ctc != null) {
            return ctc.Id;
        }
        else{
            Contact thisContact = new Contact(
                FirstName       = FirstName,
                LastName        = LastName,
                Phone           = Phone,
                Email           = Email);
            insert thisContact;
            return thisContact.Id;
        }
    }
    @HttpPut
    global static Id updateContact(String FirstName, String LastName, String Phone, String Email){
        //b. Modification d’un contact : quand un champ est modifié sur le Contact dans le CRM AXG,
		//   le changement doit être envoyé
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact result = [SELECT Id FROM Contact WHERE Id = :id];
        Contact thisContact = new Contact(); 
        thisContact.Id = id;  
        thisContact.FirstName = FirstName;
        thisContact.LastName = LastName ;
        thisContact.Phone = Phone ;
        thisContact.Email = Email;
        update thisContact;
        return thisContact.Id;
    }
    @HttpDelete
    global static Id desactivatedContact(){
        //c. Suppression d’un contact : un contact ne doit pas être supprimé dans Salesforce, 
 		//   il faut le mettre en désactivé.
 		//   Créer un champs case à cocher nommé "Desactivated" dans l'objet contact.
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        Contact result = [SELECT Id, Desactivated__c FROM Contact WHERE Id = :id];
        Contact thisContact = new Contact(); 
        thisContact.Id = id;
        thisContact.Desactivated__c = true;  
        update thisContact;
        return thisContact.Id;
    }
}