@isTest
public class AccountService {
  DMLDelegate dmlDelegate;

  public AccountService(DMLDelegate dmlDelegate) {
    this.dmlDelegate = dmlDelegate;
  }

  public void insertAccount(Account account) {
    this.dmlDelegate.insertSObject(account);
  }
}
