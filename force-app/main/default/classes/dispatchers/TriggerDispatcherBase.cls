
// This class implements the ITriggerDispatcher and acts as an adapter to avoid implementing all the ITriggerDispatcher methods.
public virtual class TriggerDispatcherBase {

    public static ITriggerHandler beforeInsertHandler;
    public static ITriggerHandler beforeUpdateHandler;
    public static ITriggerHandler beforeDeleteHandler;
    public static ITriggerHandler afterInsertHandler;
    public static ITriggerHandler afterUpdateHandler;
    public static ITriggerHandler afterDeleteHandler;
    public static ITriggerHandler afterUndeleteHandler;

    public virtual void bulkBefore(){
    }

    public virtual void bulkAfter(){
    }

    public virtual void beforeInsert(){
    }

    public virtual void beforeUpdate(){
    }

    public virtual void beforeDelete(){
    }

    public virtual void afterInsert(){
    }

    public virtual void afterUpdate(){
    }

    public virtual void afterDelete(){
    }

    public virtual void afterUndelete(){
    }

    public virtual void andFinally(){
    }

    protected void execute(
        ITriggerHandler handlerInstance,
        TriggerParameters tp,
        TriggerParameters.TriggerEvent tEvent
    ){
        if(handlerInstance != null){
            if(tEvent == TriggerParameters.TriggerEvent.beforeInsert){
                beforeInsertHandler = handlerInstance;
            } else if(tEvent == TriggerParameters.TriggerEvent.beforeUpdate){
                beforeUpdateHandler = handlerInstance;
            } else if(tEvent == TriggerParameters.TriggerEvent.beforeDelete){
                beforeDeleteHandler = handlerInstance;
            } else if(tEvent == TriggerParameters.TriggerEvent.afterInsert){
                afterInsertHandler = handlerInstance;
            } else if(tEvent == TriggerParameters.TriggerEvent.afterUpdate){
                afterUpdateHandler = handlerInstance;
            } else if(tEvent == TriggerParameters.TriggerEvent.afterDelete){
                afterDeleteHandler = handlerInstance;
            } else if(tEvent == TriggerParameters.TriggerEvent.afterUndelete){
                afterUndeleteHandler = handlerInstance;
            }

            BRFHandler.MutableTriggerParameters mutedTp = Test.isRunningTest()
                ? new BRFHandler(new BRFHandlerTest.DummyMetadataProvider()).handle(tp, tEvent)
                : new BRFHandler(BRFHandler.defaultMetadataProvider).handle(tp, tEvent);
            if (!mutedTp.proceed) {
                System.debug(
                'Trigger has been disabled for ' +
                tEvent +
                '. ' +
                mutedTp.message
                );
                return;
            } else {
                for (sObject obj : mutedTp.objectsToBeRejected) {
                System.debug(
                    'Trigger has been disabled for ' +
                    tEvent +
                    ', for object ' +
                    obj
                );
                }
                handlerInstance.mainEntry(mutedTp.actualParameters());
                handlerInstance.updateObjects();
                handlerInstance.insertObjects();
            }
        } else {
            if(tEvent == TriggerParameters.TriggerEvent.beforeInsert){
                beforeInsertHandler.inProgressEntry(tp);
            } else if(tEvent == TriggerParameters.TriggerEvent.beforeUpdate){
                beforeUpdateHandler.inProgressEntry(tp);
            } else if(tEvent == TriggerParameters.TriggerEvent.beforeDelete){
                beforeDeleteHandler.inProgressEntry(tp);
            } else if(tEvent == TriggerParameters.TriggerEvent.afterInsert){
                afterInsertHandler.inProgressEntry(tp);
            } else if(tEvent == TriggerParameters.TriggerEvent.afterUpdate){
                afterUpdateHandler.inProgressEntry(tp);
            } else if(tEvent == TriggerParameters.TriggerEvent.afterDelete){
                afterDeleteHandler.inProgressEntry(tp);
            } else if(tEvent == TriggerParameters.TriggerEvent.afterUndelete){
                afterUndeleteHandler.inProgressEntry(tp);
            }
        }
    }
}