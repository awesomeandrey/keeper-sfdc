public with sharing class SKSController {

    @AuraEnabled(Cacheable=true)
    public static Boolean validateSecretKey(String rawSecretKey) {
        try {
            Set<Id> userIds = Sets.of((Id) UserInfo.getUserId());
            Users usersDomain = (Users) Application.Domain.newInstance(userIds);
            usersDomain.validateSecretKey(Blob.valueOf(rawSecretKey));
            return true;
        } catch (Exception ex) {
            throw Exceptions.getAuraHandledException(ex);
        }
    }
}