public without sharing class StringUtils {
    public static String buildSql(String text) {
        if (String.isBlank(text)) {
            throw new CustomException('Unable to build sql for sources');
        }
        List<String> texts = text.split('/');
        List<String> whereClauses = new List<String>();

        for (String s : texts) {
            if (s.startsWith('[') && s.endsWith(']')) {
                whereClauses.add(s.substring(1, s.length() - 1));
            }
        }
        String fromClause = texts.get(0);
        String str = '';
        if (whereClauses.size() > 0) {
            String whereSql = new StringUtils.Joiner().join(whereClauses, ' and ');
            //System.debug('whereSql==>' + whereSql);
            str =
                'Select Id, Name, AllowedFileFormat__c, Delete_Records_On_Approval__c,Talend_Job_Id__c,Import_post_processor__c, Import_Status__c,Pre_Processor_Name__c from ' +
                fromClause +
                ' where ' +
                whereSql;
            return str;
        } else {
            str =
                'Select Id, Name, AllowedFileFormat__c, Delete_Records_On_Approval__c,Talend_Job_Id__c,Import_post_processor__c, Import_Status__c,Pre_Processor_Name__c from ' +
                fromClause;
            return str;
        }
    }

    public static String normalizeObjectName(
        String name,
        boolean removeAllUnderscores
    ) {
        if (name.toLowerCase().endsWith('__c')) {
            Integer index = name.toLowerCase().indexOf('__c');
            String typeName = name.substring(0, index);
            return removeAllUnderscores
                ? typeName.replaceAll('_', '')
                : typeName;
        }
        return name;
    }

    public static String replace(String text, List<String> toBeReplaced) {
        if (
            String.isBlank(text) ||
            toBeReplaced == null ||
            toBeReplaced.size() == 0
        ) {
            return text;
        }
        for (String c : toBeReplaced) {
            text = text.replace(c, '');
        }
        return text;
    }

    public static String toPlainString(
        Decimal value,
        Integer noOfDigitsAfterDecimal
    ) {
        if (value == null) {
            return '';
        }
        String s = value.toPlainString();
        Integer decimalIndex = s.indexOf('.');
        // System.debug('decimalIndex:::' + decimalIndex);
        if (
            decimalIndex == -1 ||
            (s.length() <= decimalIndex + noOfDigitsAfterDecimal)
        ) {
            return s;
        }
        return s.substring(0, decimalIndex + noOfDigitsAfterDecimal + 1);
    }

    public static Boolean isNumeric(String s) {
        Boolean isnum;
        try {
            Decimal.valueOf(s);
            isnum = true;
        } catch (Exception e) {
            isnum = false;
        }
        return isnum;
    }

    public static List<String> stringArrToList(String[] strArry) {
        List<String> lstStr = new List<String>();
        if (strArry == null && strArry.size() == 0) {
            return lstStr;
        }

        for (integer i = 0; i < strArry.size(); i++) {
            lstStr.add(strArry[i]);
        }
        return lstStr;
    }

    public static String trimDecimalFromString(
        String value,
        Integer noOfDigitsAfterDecimal
    ) {
        if (value == null) {
            return '';
        }
        String s = value;
        Integer decimalIndex = s.indexOf('.');
        // System.debug('decimalIndex:::' + decimalIndex);
        if (
            decimalIndex == -1 ||
            (s.length() <= decimalIndex + noOfDigitsAfterDecimal)
        ) {
            return s;
        }
        return s.substring(0, decimalIndex + noOfDigitsAfterDecimal + 1);
    }

    public class Joiner {
        public String join(List<String> args, String joiner) {
            String finalStr = '';
            for (String arg : args) {
                finalStr = finalStr + arg;
                finalStr = finalStr + joiner;
            }
            return finalStr.removeEnd(joiner);
        }

        public String join(Set<String> args, String joiner) {
            String finalStr = '';
            for (String arg : args) {
                finalStr = finalStr + arg;
                finalStr = finalStr + joiner;
            }
            return finalStr.removeEnd(joiner);
        }
    }
    public class Splitter {
        private boolean trim = false;
        private boolean removeNull = false;

        public Splitter trim() {
            this.trim = true;
            return this;
        }

        public Splitter removeNull() {
            this.removeNull = true;
            return this;
        }

        public List<String> split(String arg, String splitOn) {
            List<String> values = new List<String>();
            for (String s : arg.split(splitOn)) {
                if (removeNull && (s == null || s == '')) {
                    continue;
                }
                values.add(trim ? s.trim() : s);
            }
            return values;
        }
    }
    public static String normalizeLongDecimal(
        Decimal Value,
        Boolean ScientificNotation
    ) {
        /* string representation if a Decimal value with or without Scientific Notation */
        if (ScientificNotation)
            return Value.format();
        else
            return Value.toPlainString();
    }

    public static boolean isNumericOrDecimal(String val) {
        boolean isValidDecimal = true;
        if (val != null) {
            try {
                Decimal.valueOf(val);
            } catch (TypeException e) {
                isValidDecimal = false;
            }
        }
        return isValidDecimal;
    }
}
