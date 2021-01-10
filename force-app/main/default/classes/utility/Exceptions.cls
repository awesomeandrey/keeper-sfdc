public inherited sharing class Exceptions {

    public static AuraHandledException getAuraHandledException(Exception ex) {
        Map<String, String> details = getDetails(ex);
        return new AuraHandledException(JSON.serialize(details));
    }

    public static Map<String, String> getDetails(Exception ex) {
        Request reqInfo = Request.getCurrent();
        Map<String, String> details = new Map<String, String>{
                'message' => ex.getMessage(),
                'type' => ex.getTypeName(),
                'stackTrace' => ex.getStackTraceString(),
                'context' => reqInfo.getQuiddity().name()
        };
        return details;
    }
}