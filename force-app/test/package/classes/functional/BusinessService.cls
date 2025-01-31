@IsTest
public class BusinessService {
  DMLDelegate dmlDelegate;

  public BusinessService(DMLDelegate dmlDelegate) {
    this.dmlDelegate = dmlDelegate;
  }

  public void createNewCompany(Integer numberOfEmployees) {
    Account anAccount = new Account(NumberOfEmployees = numberOfEmployees);
    this.dmlDelegate.insertSObject(anAccount);
  }

  public void createNewCompanies(List<Integer> numberOfEmployeesList) {
    System.Savepoint sp = Database.setSavepoint();
    List<Account> accountToInsert = new List<Account>();
    for (Integer numberOfEmployees : numberOfEmployeesList) {
      accountToInsert.add(new Account(NumberOfEmployees = numberOfEmployees));
    }
    Database.DMLOptions dmlOptions = new Database.DMLOptions();
    dmlOptions.optAllOrNone = false;
    Database.SaveResult[] saveResults = this.dmlDelegate.insertSObjects(accountToInsert, dmlOptions);
    Boolean allSucceed = true;
    for (Database.SaveResult saveResult : saveResults) {
      allSucceed &= saveResult.isSuccess();
    }
    if (!allSucceed) {
      this.dmlDelegate.rollBack(sp);
    }
  }

  public void createNewCompanyWithOpportunity(Integer numberOfEmployees) {
    Account anAccount = new Account(NumberOfEmployees = numberOfEmployees);
    Database.SaveResult accountSaveResult = this.dmlDelegate.insertSObject(anAccount);
    Opportunity anOppy = new Opportunity(AccountId = accountSaveResult.getId());
    this.dmlDelegate.insertSObject(anOppy);
  }
}
