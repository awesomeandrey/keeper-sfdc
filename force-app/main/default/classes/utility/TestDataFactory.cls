@IsTest
public class TestDataFactory {
    private static final String ADMIN_USER_PROFILE_NAME = 'System Administrator';
    private static final String STANDARD_USER_PROFILE_NAME = 'Standard User';
    private static final String KEEPER_ADMIN_PS_NAME = 'KeeperAdministrator';
    private static final String KEEPER_USER_PS_NAME = 'KeeperUser';

    public static User generateKeeperAdminUser() {
        Profile standardUserProfile = getProfileByName(ADMIN_USER_PROFILE_NAME);
        User keeperAdminUser = generateUser(standardUserProfile.Id);
        insert keeperAdminUser;
        PermissionSet keeperAdminPS = getPermissionSetByName(KEEPER_ADMIN_PS_NAME);
        assignPermissionSet(keeperAdminUser, keeperAdminPS);
        return keeperAdminUser;
    }

    public static User generateKeeperUser() {
        Profile standardUserProfile = getProfileByName(STANDARD_USER_PROFILE_NAME);
        User keeperUser = generateUser(standardUserProfile.Id);
        insert keeperUser;
        PermissionSet keeperUserPS = getPermissionSetByName(KEEPER_USER_PS_NAME);
        assignPermissionSet(keeperUser, keeperUserPS);
        return keeperUser;
    }

    public static User generateUser(Id profileId) {
        String uniqueUserName = 'temp-user-' + Datetime.now().getTime() + '@testorg.com';
        return new User(
                ProfileId = profileId,
                Username = uniqueUserName,
                Alias = 'standt',
                Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Testing',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles'
        );
    }

    public static Profile getProfileByName(String profileName) {
        List<Profile> profiles = [
                SELECT Id, Name
                FROM Profile
                WHERE Name = :profileName
                LIMIT 1
        ];
        if (profiles.isEmpty()) {
            throw new InvalidParameterValueException('Invalid Profile name', profileName);
        }
        return (Profile) Lists.getFirstIfAnyObject(profiles);
    }

    public static PermissionSet getPermissionSetByName(String permissionSetName) {
        List<PermissionSet> permissionSets = [
                SELECT Id, Name
                FROM PermissionSet
                WHERE Name = :permissionSetName
                LIMIT 1
        ];
        if (permissionSets.isEmpty()) {
            throw new InvalidParameterValueException('Invalid Permission Set name', permissionSetName);
        }
        return (PermissionSet) Lists.getFirstIfAnyObject(permissionSets);
    }

    public static void assignPermissionSet(User targetUser, PermissionSet targetPermissionSet) {
        PermissionSetAssignment assignmentItem = new PermissionSetAssignment(
                AssigneeId = targetUser.Id, PermissionSetId = targetPermissionSet.Id
        );
        insert assignmentItem;
    }
}