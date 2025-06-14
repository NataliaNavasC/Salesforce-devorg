public interface ITriggerHandler {
    
    //Called for the first time in the execution context
    void mainEntry(TriggerParameters tp);

    //Call for the subsequent times in the same execution context
    void inProgressEntry(TriggerParameters tp);

    void updateObjects();
    void insertObjects();

}