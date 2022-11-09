@isTest
public class SObjectTypeMatcher implements ParametersMatcher {
  private SObjectType matchingType;

  public SObjectTypeMatcher(SObjectType matchingType) {
    this.matchingType = matchingType;
  }

  public boolean matches(List<Object> params) {
    if (params == null) {
      return false;
    }

    for (Integer i = 0; i < params.size(); ++i) {
      try {
        SObject param = (SObject) params[i];
        if (param?.getsObjectType() == this.matchingType) {
          return true;
        }
      } catch (Exception castingException) {
        // Silent
      }
    }
    return false;
  }
}
