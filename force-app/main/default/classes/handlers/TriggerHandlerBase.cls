public without sharing abstract class TriggerHandlerBase implements ITriggerHandler{

    protected Map<Id, SObject> sObjectsToUdate = new Map<Id,SObject>();
    protected List<SObject> sObjectsToInsert = new List<SObject>();

    // Called for the first time in the execution context
    public abstract void mainEntry(TriggerParameters tp);

    // Called for the subsequent times in the same execution context
    public virtual void inProgressEntry(TriggerParameters tp){ }

    public virtual void updateObjects() {
        if(!sObjectsToUdate.isEmpty()) {
            update sObjectsToUdate.values();
        }
    }

    public virtual void insertObjects() {
        if(!sObjectsToInsert.isEmpty()) {
            insert sObjectsToInsert;
        }
    }

}