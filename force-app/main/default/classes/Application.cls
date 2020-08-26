public class Application extends fflib_Application {
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork = new fflib_Application.UnitOfWorkFactory(new List<SObjectType>{
            User.SObjectType,
            Credential__c.SObjectType
    });
    public static final fflib_Application.ServiceFactory Service = new fflib_Application.ServiceFactory(new Map<Type, Type>{
            UserService.class => UserService.class,
            CredentialService.class => CredentialService.class
    });
    public static final fflib_Application.SelectorFactory Selector = new fflib_Application.SelectorFactory(new Map<SObjectType, Type>{
            User.SObjectType => UserSelector.class,
            Credential__c.SObjectType => CredentialSelector.class
    });
    public static final fflib_Application.DomainFactory Domain = new fflib_Application.DomainFactory(Application.Selector, new Map<SObjectType, Type>{
            User.SObjectType => Users.Constructor.class,
            Credential__c.SObjectType => Credentials.Constructor.class
    });
}