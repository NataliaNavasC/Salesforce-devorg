public with sharing class ContactDispatcher extends TriggerDispatcherBase {
    private ContactTriggerHandler triggerHandler = new ContactTriggerHandler();
    private static Boolean isAfterUpdateProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isBeforeInsertProcessing = false;

    public virtual override void beforeInsert(TriggerParameters tp) {
        if (!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(
                triggerHandler,
                tp,
                TriggerParameters.TriggerEvent.beforeInsert
            );
            isBeforeInsertProcessing = false;
        } else{
            execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
        }
    }

    public virtual override void beforeUpdate(TriggerParameters tp) {
        if (!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(
                triggerHandler,
                tp,
                TriggerParameters.TriggerEvent.beforeUpdate
            );
            isBeforeUpdateProcessing = false;
        } else{
            execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
        }
    }

    public virtual override void afterInsert(TriggerParameters tp) {
    if (!isAfterInsertProcessing) {
            isAfterInsertProcessing = true;
            execute(
                triggerHandler,
                tp,
                TriggerParameters.TriggerEvent.afterInsert
            );
            isAfterInsertProcessing = false;
        } else {
            execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
        }
    }

    public virtual override void afterUpdate(TriggerParameters tp) {
        if (!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(
                triggerHandler,
                tp,
                TriggerParameters.TriggerEvent.afterUpdate
            );
            isAfterUpdateProcessing = false;
        } else {
            execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
        }
    }
}
