public without sharing class BRFHandler {
	private static boolean disableTrigger = false;
	private static boolean disableAllTrigger = false;
	private static boolean returnValue = false;

	public interface MetadataProvider {
		List<Bypassed_Automation__mdt> getParentMetadata(
			Schema.sObjectType name,
			TriggerParameters.TriggerEvent tEvent
		);
		List<Bypassed_Trigger__mdt> getMetadata(
			Schema.sObjectType name,
			TriggerParameters.TriggerEvent tEvent
		);
	}

	public without sharing class CustomMetadataProvider implements MetadataProvider {
		public List<Bypassed_Trigger__mdt> getMetadata(
			Schema.sObjectType name,
			TriggerParameters.TriggerEvent tEvent
		) {
			System.debug('tEvent::: ' + String.valueOf(tEvent));
			String objectName = String.valueOf(name);
			List<String> objNames = new List<String>{
				objectName,
				StringUtils.normalizeObjectName(objectName, true),
				StringUtils.normalizeObjectName(objectName, false)
			};
			List<Bypassed_Trigger__mdt> tt = [
				SELECT
					Id,
					MasterLabel,
					DML_Event__c,
					Bypass_Trigger__c,
					Muted_Automation__c,
					Muted_Automation__r.MasterLabel,
					Muted_Automation__r.Bypass_Trigger__c,
					Profile__c,
					RecordType__c
				FROM Bypassed_Trigger__mdt
				WHERE
					Muted_Automation__r.MasterLabel IN :objNames
					AND DML_Event__c = :String.valueOf(tEvent)
			];
			return tt;
		}

		public List<Bypassed_Automation__mdt> getParentMetadata(
			Schema.sObjectType name,
			TriggerParameters.TriggerEvent tEvent
		) {
			String objectName = String.valueOf(name);
			List<String> objNames = new List<String>{
				objectName,
				StringUtils.normalizeObjectName(objectName, true),
				StringUtils.normalizeObjectName(objectName, false)
			};
			List<Bypassed_Automation__mdt> aa = [
				SELECT Id, MasterLabel, Bypass_Trigger__c, DeveloperName
				FROM Bypassed_Automation__mdt
				WHERE MasterLabel IN :objNames
			];
			return aa;
		}
	}
	public static MetadataProvider defaultMetadataProvider = new BRFHandler.CustomMetadataProvider();

	private final MetadataProvider metadataProvider;

	public BRFHandler(MetadataProvider metadataProvider) {
		this.metadataProvider = metadataProvider;
	}

	public MutableTriggerParameters handle(
		TriggerParameters triggerParameters,
		TriggerParameters.TriggerEvent tEvent
	) {
		List<sobject> sObjectList = (tEvent.Name() == 'beforeDelete' ||
			tEvent.Name() == 'afterDelete')
			? triggerParameters.oldList
			: triggerParameters.newList;
		Schema.sObjectType objtype = sObjectList.get(0).getSObjectType();
		// System.debug('objName===>'+objName);
		String profile = PermissionUtils.getLoggedInUserProfileName();
		Map<Id, Schema.RecordTypeInfo> actualRecordTypesOnObject = ApexUtils.getAllRecordTypes(
			objtype
		);
		System.debug(
			'Actual record type on object ' + actualRecordTypesOnObject
		);
		System.debug('Current profile of the user ' + profile);

		List<Bypassed_Trigger__mdt> metadata = metadataProvider.getMetadata(
			objtype,
			tEvent
		);
		List<Bypassed_Automation__mdt> parentMetadata = metadataProvider.getParentMetadata(
			objtype,
			tEvent
		);
		System.debug('parentMetadata===>' + parentMetadata);
		for (Bypassed_Automation__mdt mdt : parentMetadata) {
			if (mdt.Bypass_Trigger__c) {
				System.debug(
					'Looks like trigger has been disabled at parent level for all record types'
				);
				return new MutableTriggerParameters(
					triggerParameters,
					false,
					'Trigger disabled at parent level'
				);
			}
		}
		for (Bypassed_Trigger__mdt mdt : metadata) {
			List<String> profileNames = split(mdt.Profile__c);
			List<String> recordTypes = split(mdt.RecordType__c);

			System.debug('profileNames===>' + profileNames);
			System.debug('recordTypes===>' + recordTypes);

			if (mdt.Bypass_Trigger__c) {
				if (
					profileNames.size() > 0 &&
					profileNames.contains(profile) &&
					recordTypes.size() == 0
				) {
					return new MutableTriggerParameters(
						triggerParameters,
						false,
						'Trigger disabled at profile level'
					);
				}
				if (
					actualRecordTypesOnObject.size() > 0 &&
					recordTypes.size() > 0
				) {
					MutableTriggerParameters mutableTriggerParameters = performRecordTypeValidations(
						profileNames.size() > 0
							? profileNames.contains(profile)
							: true,
						recordTypes,
						actualRecordTypesOnObject,
						triggerParameters
					);
					return mutableTriggerParameters;
				}
			}
		}
		System.debug('No matching rule found');
		return new MutableTriggerParameters(
			triggerParameters,
			true,
			'',
			new List<sObject>{},
			triggerParameters.newList
		);
	}

	private MutableTriggerParameters performRecordTypeValidations(
		boolean profileMatches,
		List<String> recordTypesOnMetadata,
		Map<Id, Schema.RecordTypeInfo> actualRecordTypesOnObject,
		TriggerParameters triggerParameters
	) {
		List<sObject> objectsToProceedWith = new List<sObject>();
		List<sObject> objectsToBeRejected = new List<sObject>();

		for (sObject obj : triggerParameters.newList) {
			String recordTypeId = (Id) obj.get('RecordTypeId');
			if (
				String.isBlank(recordTypeId) ||
				actualRecordTypesOnObject.get(recordTypeId) == null
			) {
				objectsToProceedWith.add(obj);
				continue;
			}
			Schema.RecordTypeInfo recordType = actualRecordTypesOnObject.get(
				recordTypeId
			);

			String nameOfRecordType = recordType.getDeveloperName();
			System.debug('nameOfRecordType==>' + nameOfRecordType);
			if (
				recordTypesOnMetadata.contains(nameOfRecordType) &&
				profileMatches
			) {
				objectsToBeRejected.add(obj);
			} else {
				objectsToProceedWith.add(obj);
			}
		}
		return new MutableTriggerParameters(
			triggerParameters,
			true,
			'Trigger disabled at recordType level',
			objectsToBeRejected,
			objectsToProceedWith
		);
	}

	private List<String> split(String text) {
		if (String.isBlank(text)) {
			return new List<String>{};
		}
		return new StringUtils.Splitter().trim().removeNull().split(text, ',');
	}

	public class MutableTriggerParameters {
		public final TriggerParameters triggerParameters;
		public final boolean proceed;
		public final String message;
		public final List<sObject> objectsToProceedWith;
		public final List<sObject> objectsToBeRejected;

		public MutableTriggerParameters(
			TriggerParameters triggerParameters,
			boolean proceed,
			String message,
			List<sObject> objectsToBeRejected,
			List<sObject> objectsToProceedWith
		) {
			this.triggerParameters = triggerParameters;
			this.proceed = proceed;
			this.message = message;
			this.objectsToProceedWith = objectsToProceedWith;
			this.objectsToBeRejected = objectsToBeRejected;
		}

		public MutableTriggerParameters(
			TriggerParameters triggerParameters,
			boolean proceed,
			String message
		) {
			this.triggerParameters = triggerParameters;
			this.proceed = proceed;
			this.message = message;
			this.objectsToProceedWith = new List<sObject>();
			this.objectsToBeRejected = new List<sObject>();
		}

		public TriggerParameters actualParameters() {
			return triggerParameters.replaceNewList(objectsToProceedWith);
		}
	}
}
