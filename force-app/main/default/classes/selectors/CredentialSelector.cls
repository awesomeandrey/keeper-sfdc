public class CredentialSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Credential__c.SObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Credential__c.Id,
                Credential__c.Name
        };
    }
}