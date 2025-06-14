@isTest
public class BRFHandlerTest {
    private static final Map<String, Schema.RecordTypeInfo> recordTypes = getRecordTypes();

    public class DummyMetadataProvider implements BRFHandler.MetadataProvider {
        public List<Bypassed_Automation__mdt> getParentMetadata(
            Schema.sObjectType name,
            TriggerParameters.TriggerEvent tEvent
        ) {
            System.debug('Looking for paremt metadata for ' + name);
            List<Bypassed_Automation__mdt> mdtParentList = new List<Bypassed_Automation__mdt>();
            Bypassed_Automation__mdt mdt4 = new Bypassed_Automation__mdt();
            mdt4.MasterLabel = 'Test_Obj2__c';
            mdt4.DeveloperName = 'Test_Obj2__c';
            mdt4.Bypass_Trigger__c = false;

            Bypassed_Automation__mdt mdt5 = new Bypassed_Automation__mdt();
            mdt5.MasterLabel = 'Test_Obj_c';
            mdt5.DeveloperName = 'Test_Obj_c';
            mdt5.Bypass_Trigger__c = true;
            mdtParentList.add(mdt4);
            mdtParentList.add(mdt5);

            String objName = String.valueOf(name);
            List<Bypassed_Automation__mdt> filtered = new List<Bypassed_Automation__mdt>();
            for (Bypassed_Automation__mdt mdt : mdtParentList) {
                if (mdt.MasterLabel == objName) {
                    filtered.add(mdt);
                }
            }
            return filtered;
        }

        public List<Bypassed_Trigger__mdt> getMetadata(
            Schema.sObjectType name,
            TriggerParameters.TriggerEvent tEvent
        ) {
            System.debug(
                'Looking for child metadata for ' +
                    name +
                    ' and event is ' +
                    tEvent
            );
            List<Bypassed_Trigger__mdt> mdtChildList = new List<Bypassed_Trigger__mdt>();
            Bypassed_Trigger__mdt mt1 = new Bypassed_Trigger__mdt();
            mt1.MasterLabel = 'Test_Obj__c';
            mt1.DeveloperName = 'Test_Obj';
            mt1.Bypass_Trigger__c = true;
            mt1.Profile__c = PermissionUtils.getLoggedInUserProfileName();
            mt1.DML_Event__c = 'beforeInsert';
            mt1.RecordType__c = 'RecordType1';

            Bypassed_Trigger__mdt mt2 = new Bypassed_Trigger__mdt();
            mt2.MasterLabel = 'Test_Obj__c';
            mt2.DeveloperName = 'Test_Obj';
            mt2.Bypass_Trigger__c = true;
            mt2.Profile__c = PermissionUtils.getLoggedInUserProfileName();
            mt2.DML_Event__c = 'afterInsert';
            mt2.RecordType__c = 'RecordType1,RecordType2';

            Bypassed_Trigger__mdt mt3 = new Bypassed_Trigger__mdt();
            mt3.MasterLabel = 'Test_Obj__c';
            mt3.DeveloperName = 'Test_Obj';
            mt3.Bypass_Trigger__c = true;
            mt3.Profile__c = PermissionUtils.getLoggedInUserProfileName();
            mt3.DML_Event__c = 'afterUpdate';
            //mt3.RecordType__c = 'E_File_Building_Permit,Manual_Entry_Building_Permit';
            //
            Bypassed_Trigger__mdt mt4 = new Bypassed_Trigger__mdt();
            mt4.MasterLabel = 'Test_Obj__c';
            mt4.DeveloperName = 'Test_Obj';
            mt4.Bypass_Trigger__c = true;
            // mt4.Profile__c = PermissionUtils.getLoggedInUserProfileName();
            mt4.DML_Event__c = 'beforeUpdate';
            mt4.RecordType__c = 'RecordType1';
            //

            mdtChildList.add(mt1);
            mdtChildList.add(mt2);
            mdtChildList.add(mt3);
            mdtChildList.add(mt4);

            String objName = String.valueOf(name);
            List<Bypassed_Trigger__mdt> filtered = new List<Bypassed_Trigger__mdt>();
            for (Bypassed_Trigger__mdt mdt : mdtChildList) {
                if (
                    mdt.MasterLabel == objName &&
                    mdt.DML_Event__c == String.valueOf(tEvent)
                ) {
                    filtered.add(mdt);
                }
            }
            System.debug('Filtered Child Metadata ' + filtered);
            return filtered;
        }
    }

    private static Map<String, Schema.RecordTypeInfo> getRecordTypes() {
        return Schema.SObjectType.Test_Obj__c.getRecordTypeInfosByName();
    }

    static testMethod void testMutableTriggerParameters() {
        FieldSetUtils.getFields('Account', 'Industry');
        Id recordType1 = recordTypes.get('RecordType1').getRecordTypeId();
        Id recordType2 = recordTypes.get('RecordType2').getRecordTypeId();
        Test_Obj2__c testObj2 = new Test_Obj2__c(Name = 'Test Rec2');
        insert testObj2;
        Test_Obj__c testObj = new Test_Obj__c(
            Name = 'Test Rec3',
            RecordTypeId = RecordType2
        );
        insert testObj;
        update testObj2;
        update testObj;
        System.assertEquals([SELECT COUNT() FROM Test_Obj__c], 1);
    }
}
