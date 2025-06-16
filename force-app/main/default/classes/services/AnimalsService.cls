public without sharing class AnimalsService {
    
    private static final String endPoint = 'https://th-apex-http-callout.herokuapp.com/animals';

    public static List<String> makeGetCallout(){
        List<String> animals = new List<String>();
        Http hppt = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = hppt.send(request);
        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> animalsObj = (List<Object>) results.get('animals');
            for(Object obj : animalsObj){
                animals.add((String)obj);
            }
            //animals = (List<String>) results.get('animals');
        } else{
            throw new CalloutException('API call failed: '+ response.getBody()) ;
        }
        return animals;
    }


}