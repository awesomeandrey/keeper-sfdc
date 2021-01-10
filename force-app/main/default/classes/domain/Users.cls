public inherited sharing class Users extends fflib_SObjectDomain {

    public Users(List<User> sObjectList) {
        super(sObjectList, User.SObjectType);
    }

    public void setupSecretKey(fflib_ISObjectUnitOfWork uow) {
        Blob systemGeneratedSecretKey = this.generateSecretKey();
        this.setupSecretKey(systemGeneratedSecretKey, uow);
    }

    public void setupSecretKey(String rawSecretKey, fflib_ISObjectUnitOfWork uow) {
        Blob userProvidedRawSecretKey = Blob.valueOf(rawSecretKey);
        this.setupSecretKey(userProvidedRawSecretKey, uow);
    }

    public void validateSecretKey(Blob keyAsBlob) {
        try {
            // Sample input data;
            String dataAsString = 'Ad-hoc test data to encrypt/decrypt!';
            Blob dataAsBlob = Blob.valueOf(dataAsString);
            // Ad-hoc test;
            Blob encryptedData = Crypto.encryptWithManagedIV('AES256', keyAsBlob, dataAsBlob);
            Blob decryptedData = Crypto.decryptWithManagedIV('AES256', keyAsBlob, encryptedData);
            System.assertEquals(dataAsString, decryptedData.toString());
        } catch (Exception ex) {
            throw new IllegalArgumentException('Secret Key didn\'t pass verification!', ex);
        }
    }

    //******************************************************************************************************************

    @TestVisible
    private Blob generateSecretKey() {
        return Crypto.generateAesKey(256);
    }

    public void setupSecretKey(Blob secretKey, fflib_ISObjectUnitOfWork uow) {
        // Validate Secret Key;
        this.validateSecretKey(secretKey);
        // Update UoW instance for User record change;
        User contextUser = new User(
                Id = UserInfo.getUserId()
                , SecretKey__c = EncodingUtil.base64Encode(secretKey)
        );
        uow.registerDirty(contextUser);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Users(sObjectList);
        }
    }
}