public without sharing class ContactTriggerHandler {

    public override void mainEntry(TriggerParameters tp){
        TriggerEvent tEvent = tp.tEvent;

        if (tEvent == TriggerParametters.TriggerEvent.beforeInsert) {
            handleBeforeInsert(tp.newList);
        } else if (tEvent == TriggerParametters.TriggerEvent.beforeUpdate) {
            setWelcomeMessage(tp.newList);
        } else if (tEvent == TriggerParametters.TriggerEvent.afterInsert) {
            setWelcomeMessage(tp.newList);
        } else if (tEvent == TriggerParametters.TriggerEvent.afterUpdate) {
            setWelcomeMessage(tp.newList);
        } 
    }


    private void handleBeforeInsert(List<Contact> contacts ){
        for(Contact c:contacts){
            c.Description = 'Welcome to devorg ' + c.FirstName + ' ' + c.LastName + '!';
        }
    }

    private void handleBeforeUpdate(List<Contact> contacts){
        System.debug('Handle before update ' + contacts);
    }

    private void handleAfterInsert(List<Contact> contacts){
        System.debug('Handle after insert ' + contacts);
    }

    private void handleAfterUpdate(List<Contact> contacts){
        System.debug('Handle after update ' + contacts);
    }

}