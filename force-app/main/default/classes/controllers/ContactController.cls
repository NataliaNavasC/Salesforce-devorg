public without sharing class ContactController {
    @InvocableMethod(label='Create Animals' description='Creates animals for the specified contact')
    public static void createAnimals(List<Id> contactIds) {
        //Enqueue the async job
        System.debug('Contact Id: ' + contactIds);
        if(!contactIds.isEmpty()){
            enqueueAnimalCreation(contactIds);
        }
    }

    // Internal method that calls future method
    private static void enqueueAnimalCreation(List<Id> contactIds) {
        createAnimalsAsync(contactIds);
    }

    @future(callout=true)
    public static void createAnimalsAsync(List<Id> contactIds) {
        System.debug('Aync call from future method');
        List<Animal__c> animalsToCreate = new List<Animal__c>();
        List<String> animals = AnimalsService.makeGetCallout();
        for(Contact c: [SELECT id, LastName FROM Contact where id in :contactIds]){
            for (String animal : animals) {
                Animal__c an = new Animal__c(Name = animal + ' - ' + c.LastName, Contact__c = c.Id);
                animalsToCreate.add(an);
            }
        }
        if (!animalsToCreate.isEmpty()) {
            insert animalsToCreate;
        } else {
            throw new CustomException('Error!');
        }
    }
}
