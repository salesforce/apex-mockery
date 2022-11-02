public interface DMLDelegate {
  // insert can throw DMLException when not allowing partial result (dmlOptions.optAllOrNone = true)
  Database.SaveResult insertSObject(SObject recordToInsert);
  Database.SaveResult insertSObject(
    SObject recordToInsert,
    Database.DMLOptions dmlOptions
  );
  Database.SaveResult[] insertSObjects(List<SObject> recordsToInsert);
  Database.SaveResult[] insertSObjects(
    List<SObject> recordsToInsert,
    Database.DMLOptions dmlOptions
  );
  void rollBack(System.Savepoint sp);
}
