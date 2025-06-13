public with sharing class UtilityClass {

    public static String getSObjectTypeName(SObject so){
        return so.getSObjectType().getDescribe().getName();
    }
}