/**
 * The class represents Flow action which is used to read end-user provided Secret Key,
 * and commit it to DB layer.
 */
public without sharing class SetupSecretKeyAction {
    @InvocableMethod(Label = 'Setup Secret Key')
    public static void setupSecretKey(List<String> keys) {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(Lists.of(User.SObjectType));
        Set<Id> userIds = Sets.of((Id) UserInfo.getUserId());
        Users usersDomain = (Users) Application.Domain.newInstance(userIds);
        String secretKey = Lists.getFirstIfAny(keys);
        if (String.isBlank(secretKey)) {
            usersDomain.setupSecretKey(uow);
        } else {
            usersDomain.setupSecretKey(secretKey, uow);
        }
        uow.commitWork();
    }
    // TODO - implement logging mechanism;
}
