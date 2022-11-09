@isTest
public class EqualsMatcher implements ParametersMatcher {
  private List<Object> paramsToMatch;

  public EqualsMatcher(final List<Object> paramsToMatch) {
    this.paramsToMatch = paramsToMatch;
  }

  public Boolean matches(List<Object> params) {
    return params == this.paramsToMatch;
  }
}
