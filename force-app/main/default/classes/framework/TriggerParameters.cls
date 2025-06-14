public without sharing class TriggerParameters {
    
    public enum TriggerEvent{
        beforeInsert,
        beforeUpdate,
        beforeDelete,
        afterInsert,
        afterUpdate,
        afterDelete,
        afterUndelete
    }
    public TriggerEvent tEvent;

    public List<SObject> oldList { get; private set;}
    public List<SObject> newList { get; private set;}
    public Map<Id, SObject> oldMap { get; private set; }
    public Map<Id, SObject> newMap { get; private set; }
    public String triggerObject { get; private set; }
    public Boolean isExecuting { get; private set; }
        
    public TriggerParameters(
        List<SObject> olist,
        List<SObject> nlist,
        Map<Id,SObject> oMap,
        Map<Id,SObject> nMap,
        Boolean isBef,
        Boolean isAft,
        Boolean isIns,
        Boolean isUpd,
        Boolean isDel,
        Boolean isUnd,
        Boolean isExc
    ) {
        this.oldList = oList;
        this.newList = nlist;
        this.oldMap = oMap;
        this.newMap = nMap;
        this.triggerObject = ApexUtils.getSObjectTypeName(
            (this.oldList != null && this.oldList.size()>0) ? this.oldList[0] : this.newList[0]
        );
        if(isBef && isIns){
            tEvent = TriggerEvent.beforeInsert;
        } else if (isBef && isUpd){
            tEvent = TriggerEvent.beforeUpdate;
        } else if(isBef && isDel){
            tEvent = TriggerEvent.beforeDelete;
        } else if(isAft && isIns){
            tEvent = TriggerEvent.afterInsert;
        } else if(isAft && isUpd){
            tEvent = TriggerEvent.afterUpdate;
        } else if(isAft && isDel){
            tEvent = TriggerEvent.afterDelete;
        } else if(isAft && isUnd){
            tEvent = TriggerEvent.afterUndelete;
        }
        isExecuting = isExc;

    }

    public TriggerParameters replaceNewList(List<SObject> l){
        this.newList = l;
        return this;
    }
}