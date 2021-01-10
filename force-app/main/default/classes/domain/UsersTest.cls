@IsTest
private class UsersTest {
    @IsTest
    static void setupSecretKey() {
        // Defined mock implementation of UoW;
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Application.UnitOfWork.setMock(mockUow);
        // Run test on behalf of Keeper app user;
        User keeperUser = TestDataFactory.generateKeeperUser();
        System.runAs(keeperUser) {
            // Call domain logic;
            Users usersDomain = new Users(Lists.of(keeperUser));
            usersDomain.setupSecretKey(mockUow);
        }
        // Verify that context User record has been affected by mocked UoW;
        ((fflib_SObjectUnitOfWork) mocks.verify(mockUow, mocks.times(1)
                .description('User record has been successfully updated')))
                .registerDirty(fflib_Match.sObjectWithId(keeperUser.Id));
        System.assert(true);
    }

    @IsTest
    static void setupSecretKey_InvalidKey() {
        Boolean exceptionCaught = false;
        User keeperUser = TestDataFactory.generateKeeperUser();
        System.runAs(keeperUser) {
            try {
                Users usersDomain = new Users(Lists.of(keeperUser));
                usersDomain.setupSecretKey('invalid AES key', null);
            } catch (Exception ex) {
                exceptionCaught = true;
            }
        }
        System.assert(exceptionCaught);
    }

    @IsTest
    static void validateSecretKey() {
        Boolean exceptionCaught = false;
        User keeperUser = TestDataFactory.generateKeeperUser();
        System.runAs(keeperUser) {
            // Call domain logic;
            Users usersDomain = new Users(Lists.of(keeperUser));
            Blob validSecretKeyAsBlob = usersDomain.generateSecretKey();
            usersDomain.validateSecretKey(validSecretKeyAsBlob);
        }
        System.assert(!exceptionCaught);
    }
}