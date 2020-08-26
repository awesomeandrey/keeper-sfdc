public class UserSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return User.SObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                User.Id,
                User.Name,
                User.KeeperSecretKey__c
        };
    }
}