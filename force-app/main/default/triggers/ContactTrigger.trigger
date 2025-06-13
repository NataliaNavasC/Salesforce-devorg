trigger ContactTrigger on Contact (
    before insert, 
    before update, 
    before delete, 
    after insert,
    after update,
    after delete) {
    //TriggerFactory.createTriggerDispatcher(Contact.sObjectType);
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            System.debug('before insert');
            ContactTriggerHandler.setWelcomeMessage(Trigger.new);
        }
    } else {
        if(Trigger.isInsert){
            System.debug('after insert');
        }
    }
}