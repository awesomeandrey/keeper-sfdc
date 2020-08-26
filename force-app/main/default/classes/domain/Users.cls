public inherited sharing class Users extends fflib_SObjectDomain {

    public Users(List<User> sObjectList) {
        super(sObjectList, User.SObjectType);
    }

    /**
     * Automatically generates 256 bit size secret key for AES algorithm,
     * and casts it to string type.
     *
     * @return System generated, encoded secret key.
     */
    public String generateSecretKeyAsString() {
        return EncodingUtil.base64Encode(this.generateSecretKey());
    }

    /**
     * Automatically generates secret key & updates context user info.
     *
     * @param uow - instance of UnitOfWork object to handle transaction
     */
    public void setupSecretKey(fflib_ISObjectUnitOfWork uow) {
        String generatedSecretKey = this.generateSecretKeyAsString();
        this.setupSecretKey(generatedSecretKey, uow);
    }

    /**
     * Updates context user info with passed in secret key.
     *
     * @param rawSecretKey - context user secret key
     * @param uow - instance of UnitOfWork object to handle transaction
     */
    public void setupSecretKey(String rawSecretKey, fflib_ISObjectUnitOfWork uow) {
        this.validateSecretKey(rawSecretKey);
        User contextUser = new User(
                Id = UserInfo.getUserId(),
                KeeperSecretKey__c = rawSecretKey
        );
        uow.registerDirty(contextUser);
    }

    /**
      * Automatically generates 256 bit size secret key for AES algorithm.
      *
      * @return System generated secret key as a BLOB.
      */
    private Blob generateSecretKey() {
        return Crypto.generateAesKey(256);
    }

    /**
     * Checks whether provided secret key validity.
     *
     * @param secretKey - secret key to validate against AES algorithm
     */
    @TestVisible
    private void validateSecretKey(String secretKey) {
        try {
            // Sample input data;
            Blob keyAsBlob = EncodingUtil.base64Decode(secretKey);
            String dataAsString = 'Ad-hoc test data to encrypt/decrypt!';
            Blob dataAsBlob = Blob.valueOf(dataAsString);
            // Ad-hoc test;
            Blob encryptedData = Crypto.encryptWithManagedIV('AES256', keyAsBlob, dataAsBlob);
            System.assertNotEquals(dataAsString, EncodingUtil.base64Encode(encryptedData));
            Blob decryptedData = Crypto.decryptWithManagedIV('AES256', keyAsBlob, encryptedData);
            System.assertEquals(dataAsString, decryptedData.toString());
        } catch (Exception ex) {
            throw new IllegalArgumentException('Secret Key didn\'t pass verification!', ex);
        }
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Users(sObjectList);
        }
    }
}