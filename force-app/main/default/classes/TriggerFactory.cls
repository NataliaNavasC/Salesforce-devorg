public without sharing class TriggerFactory {
    
    public static void createTriggerDispatcher(Schema.sObjectType soType){
        ITriggerDispatcher dispatcher = getTriggerDispatcher(soType);
        if(dispatcher == null){
            throw new TriggerException(
                'No trigger dispatcher registered for Object Type: ' + soType
            );
        }
        execute(dispatcher);
    }

    private static ITriggerDispatcher getTriggerDispatcher(Schema.sObjectType soType){
        String originalTypeName = soType.getDescribe().getName();
        String dispatcherTypeName = String.normalizeObjectName(originalTypeName,true) + 'Dispatcher';
        Type obType = Type.forName(dispatcherTypeName);
        ITriggerDispatcher dispatcher = (obType == null) ? null : (ITriggerDispatcher) obType.newInstance(); 
        return dispatcher;
    }

    private static void execute(ITriggerDispatcher dispatcher){
        TriggerParameters tp = new TriggerParameters(
            Trigger.old,
            Trigger.new,
            Trigger.oldMap,
            Trigger.newMap,
            Trigger.isBefore,
            Trigger.isAfter,
            Trigger.isInsert,
            Trigger.isUpdate,
            Trigger.isDelete,
            Trigger.isUndelete,
            Trigger.isExecuting
        );
        if(Trigger.isBefore){
            dispatcher.bulkBefore();
            if(Trigger.isInsert){
                dispatcher.beforeInsert(tp);
            } else if(Trigger.isUpdate){
                dispatcher.beforeUpdate(tp);
            } else if(Trigger.isDelete){
                dispatcher.beforeDelete(tp);
            }
        } else {
            dispatcher.bulkAfter();
            if(Trigger.isInsert){
                dispatcher.afterInsert(tp);
            } else if(Trigger.isUpdate){
                dispatcher.afterUpdate(tp);
            } else if(Trigger.isDelete){
                dispatcher.afterDelete(tp);
            } else if(Trigger.isUndelete){
                dispatcher.afterUndelete(tp);
            }
        }
        dispatcher.andFinally();
    }
}