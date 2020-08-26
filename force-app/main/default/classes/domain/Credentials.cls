public class Credentials extends fflib_SObjectDomain{
	public Credentials(List<Credential__c> sObjectList){
		super(sObjectList);
	}

	public virtual override void onBeforeInsert(){
		// TODO - encrypt data
	}

	public virtual override void onBeforeUpdate(Map<Id, SObject> existingRecords){
		// TODO - encrypt data
	}

	public List<Object> encrypt(){
		return null;
	}

	public List<Object> decrypt(){
		return null;
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Credentials(sObjectList);
		}
	}
}