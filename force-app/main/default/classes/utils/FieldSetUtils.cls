// Common mwthods to access fieldset for different SObjects
public with sharing class FieldSetUtils {

    public FieldSetUtils() {
    }

    public class DisplayColumns {
        private List<ColumnsWrapper> columnsWrapper;
        private String fieldsToSearch;

        public DisplayColumns(
            List<ColumnsWrapper> columnsWrapper,
            String fieldsToSearch
        ) {
            this.columnsWrapper = columnsWrapper;
            this.fieldsToSearch = fieldsToSearch;
        }

        public List<ColumnsWrapper> columnsWrapper() {
            return columnsWrapper;
        }

        public String fieldsToSearch() {
            return fieldsToSearch;
        }
    }

    public class ColumnsWrapper {
        public String label;
        public String fieldName;
        public String type;
        public Boolean editable;
        public String typeAttributes;
        public Integer initialWidth;
        public Boolean wrapText;
        public Boolean sortable;

        public ColumnsWrapper(String label, String fieldName, String type) {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
            this.wrapText = true;
            this.sortable = true;
        }

        public ColumnsWrapper(
            String label,
            String fieldName,
            String type,
            String typeAttributes,
            Integer initialWidth,
            Boolean editable
        ) {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
            this.typeAttributes = typeAttributes;
            this.initialWidth = initialWidth;
            this.editable = editable;
            this.wrapText = true;
            this.sortable = true;
        }
    }

    public ColumnsWrapper columnsWrapper(
        String label,
        String fieldName,
        String type
    ) {
        return new ColumnsWrapper(label, fieldName, type);
    }


    public static List<Schema.FieldSetMember> getFieldsFromFieldSet(
        String someSObject,
        String name
    ) {
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType mySObject = globalDescribeMap.get(someSObject);
        Schema.FieldSet f1 = mySObject.getDescribe()
            .FieldSets.getMap()
            .get(name);
        return (f1 == null)
            ? new List<Schema.FieldSetMember>()
            : f1.getFields();
    }

    public Map<String, Schema.SObjectField> getSObjectFields(
        String someSObject
    ) {
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType mySObject = globalDescribeMap.get(someSObject);
        return mySObject.getDescribe().fields.getMap();
    }

    public static Schema.SObjectField getFields(
        String someSObject,
        String name
    ) {
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType mySObject = globalDescribeMap.get(someSObject);
        Map<String, Schema.SObjectField> targetFields = mySObject.getDescribe()
            .fields.getMap();
        return targetFields.get(name);
    }




}
