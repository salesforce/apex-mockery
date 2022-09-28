@isTest
public class BusinessService {
  DMLDelegate dmlDelegate;

  public BusinessService(DMLDelegate dmlDelegate) {
    this.dmlDelegate = dmlDelegate;
  }

  public void businessScenario(final Integer numberOfEmployees) {
    Account anAccount = new Account(NumberOfEmployees = numberOfEmployees);
    this.dmlDelegate.insertSObject(anAccount);
  }
}
