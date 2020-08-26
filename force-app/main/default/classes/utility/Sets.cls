public class Sets {

    private Sets() {
    }

    public static Set<Id> of(Id recordId) {
        return new Set<Id>{
                recordId
        };
    }

    public static Set<String> of(String str) {
        return new Set<String>{
                str
        };
    }
}