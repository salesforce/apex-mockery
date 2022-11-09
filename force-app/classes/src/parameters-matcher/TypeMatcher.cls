@isTest
public class TypeMatcher implements ParametersMatcher {
  private System.Type matchingType;

  public TypeMatcher(System.Type matchingType) {
    this.matchingType = matchingType;
  }

  public boolean matches(List<Object> params) {
    if (params == null) {
      return false;
    }

    for (Integer i = 0; i < params.size(); ++i) {
      String typeName = String.valueOf(params[i]).split(':')[0];
      System.Type actualType = Type.forName(typeName);
      if (this.matchingType.isAssignableFrom(actualType)) {
        return true;
      }
    }
    return false;
  }
}
