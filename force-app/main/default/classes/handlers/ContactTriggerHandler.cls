public without sharing class ContactTriggerHandler extends TriggerHandlerBase{

    public override void mainEntry(TriggerParameters tp){
        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
            handleBeforeInsert(tp.newList);
        } else if (tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
            handleBeforeUpdate(tp.newList);
        } else if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
            handleAfterInsert(tp.newList);
        } else if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
            handleAfterUpdate(tp.newList);
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