public without sharing class ContactTriggerHandler {

    public static void setWelcomeMessage(List<Contact> contacts){
        for(Contact c:contacts){
            c.Description = 'Welcome to devorg ' + c.FirstName + ' ' + c.LastName + '!';
        }
    }
}