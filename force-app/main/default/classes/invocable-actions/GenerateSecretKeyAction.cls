/**
 * The class represents Flow action which is used to generate Secret Key.
 */
public without sharing class GenerateSecretKeyAction {
    @InvocableMethod(Label = 'Generate Secret Key')
    public static List<String> generateSecretKey() {
        Set<Id> userIds = Sets.of((Id) UserInfo.getUserId());
        Users usersDomain = (Users) Application.Domain.newInstance(userIds);
        return Lists.of(usersDomain.generateSecretKeyAsString());
    }
    // TODO - implement logging mechanism;
}