public class Lists {

    private Lists() {
    }

    public static Boolean isEmpty(List<Object> collection) {
        if (collection == null) return true;
        return collection.size() == 0;
    }

    public static List<Id> of(Id item) {
        return new List<Id>{
                item
        };
    }

    public static List<String> of(String item) {
        return new List<String>{
                item
        };
    }

    public static List<SObject> of(SObject item) {
        return new List<SObject>{
                item
        };
    }

    public static List<Schema.SObjectType> of(Schema.SObjectType item) {
        return new List<Schema.SObjectType>{
                item
        };
    }

    public static String getFirstIfAny(List<String> items) {
        return (String) getFirstIfAnyObject(items);
    }

    public static Object getFirstIfAnyObject(List<Object> items) {
        return isEmpty(items) ? null : items[0];
    }
}