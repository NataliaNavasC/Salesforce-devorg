// This class contains generic helper methods
public with sharing class ApexUtils {
    public enum SortOrder {
        ASCENDING,
        DESCENDING
    }
    public enum Type {
        TYPE_STRING,
        TYPE_INTEGER,
        TYPE_DECIMAL,
        TYPE_DATE
    }

    sObject record;
    SortOrder sortOrderValue;
    String fieldName;
    Type valueType;

    public ApexUtils(
        sObject record,
        SortOrder sortOrderValue,
        String fieldName,
        Type valueType
    ) {
        this.record = record;
        this.sortOrderValue = sortOrderValue;
        this.fieldName = fieldName;
        this.valueType = valueType;
    }

    public static void sortRecords(
        List<sObject> records,
        SortOrder sortOrderValue,
        String fieldName,
        Type valueType
    ) {
        List<ApexUtils> sortUtils = new List<ApexUtils>();
        for (sObject record : records) {
            sortUtils.add(
                new ApexUtils(record, sortOrderValue, fieldName, valueType)
            );
        }
        sortUtils.sort();
        records.clear();
        for (ApexUtils sortUtil : sortUtils) {
            records.add(sortUtil.record);
        }
    }

    public Integer compareTo(Object anotherObject) {
        sObject anotherRecord = ((ApexUtils) anotherObject).record;
        if (valueType.equals(Type.TYPE_STRING)) {
            return compareStrings(
                (String) record.get(fieldName),
                (String) anotherRecord.get(fieldName)
            );
        } else if (valueType.equals(Type.TYPE_INTEGER)) {
            return compareIntegers(
                (Integer) record.get(fieldName),
                (Integer) anotherRecord.get(fieldName)
            );
        } else if (valueType.equals(Type.TYPE_DECIMAL)) {
            return compareDecimals(
                (Decimal) record.get(fieldName),
                (Decimal) anotherRecord.get(fieldName)
            );
        } else if (valueType.equals(Type.TYPE_DATE)) {
            return compareDates(
                (Date) record.get(fieldName),
                (Date) anotherRecord.get(fieldName)
            );
        }
        return -1;
    }

    public Integer compareStrings(String sourceValue, String destinationValue) {
        if (sortOrderValue.equals(SortOrder.ASCENDING)) {
            if (sourceValue < destinationValue) {
                return -1;
            } else if (sourceValue.equals(destinationValue)) {
                return 0;
            } else {
                return 1;
            }
        } else {
            if (sourceValue < destinationValue) {
                return 1;
            } else if (sourceValue.equals(destinationValue)) {
                return 0;
            } else {
                return -1;
            }
        }
    }

    public Integer compareIntegers(
        Integer sourceValue,
        Integer destinationValue
    ) {
        if (sortOrderValue.equals(SortOrder.ASCENDING)) {
            if (sourceValue < destinationValue) {
                return -1;
            } else if (sourceValue == destinationValue) {
                return 0;
            } else {
                return 1;
            }
        } else {
            if (sourceValue < destinationValue) {
                return 1;
            } else if (sourceValue == destinationValue) {
                return 0;
            } else {
                return -1;
            }
        }
    }

    public Integer compareDecimals(
        Decimal sourceValue,
        Decimal destinationValue
    ) {
        if (sortOrderValue.equals(SortOrder.ASCENDING)) {
            if (sourceValue < destinationValue) {
                return -1;
            } else if (sourceValue == destinationValue) {
                return 0;
            } else {
                return 1;
            }
        } else {
            if (sourceValue < destinationValue) {
                return 1;
            } else if (sourceValue == destinationValue) {
                return 0;
            } else {
                return -1;
            }
        }
    }

    public Integer compareDates(Date sourceValue, Date destinationValue) {
        if (sortOrderValue.equals(SortOrder.ASCENDING)) {
            if (sourceValue < destinationValue) {
                return -1;
            } else if (sourceValue == destinationValue) {
                return 0;
            } else {
                return 1;
            }
        } else {
            if (sourceValue < destinationValue) {
                return 1;
            } else if (sourceValue == destinationValue) {
                return 0;
            } else {
                return -1;
            }
        }
    }

    public static String getSObjectTypeName(SObject so) {
        return so.getSObjectType().getDescribe().getName();
    }

    public static User getSystemUser() {
        String username = Label.SystemUser + '%';
        User sysUser = [
            SELECT Id, Name, LastName, FirstName, Email
            FROM user
            WHERE username LIKE :username
            LIMIT 1
        ];
        return sysUser;
    }

    public static boolean matchesRegex(String regex, String textToBeMatched) {
        if (textToBeMatched == null || regex == null) {
            return false;
        }
        return Pattern.compile(regex).matcher(textToBeMatched).matches();
    }

    public static boolean dateBetween(
        Date currentDate,
        Date startDate,
        Date endDate
    ) {
        if (currentDate >= startDate && currentDate <= endDate) {
            return true;
        }
        return false;
    }

    private Id getRecordTypeID(
        String objectName,
        String recordTypeDeveloperName
    ) {
        return Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .getRecordTypeInfosByDeveloperName()
            .get(recordTypeDeveloperName)
            .getRecordTypeId();
    }

    public Id getRecordTypeByLabel(String objectName, String recordTypeLabel) {
        return Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .getRecordTypeInfosByName()
            .get(recordTypeLabel)
            .getRecordTypeId();
    }

    public static Map<Id, Schema.RecordTypeInfo> getAllRecordTypes(
        Schema.sObjectType objectType
    ) {
        return objectType.getDescribe().getRecordTypeInfosById();
    }

    public static Map<String, Schema.RecordTypeInfo> getAllRecordTypesByDevelperName(
        Schema.sObjectType objectType
    ) {
        return objectType.getDescribe().getRecordTypeInfosByDeveloperName();
    }

    public static String aRecordUrl(String id) {
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        return baseUrl + '/' + id;
    }

}