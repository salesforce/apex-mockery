@isTest
public class JSONMatcher implements ParametersMatcher {
  private String expectedJSONRepresentation;

  public JSONMatcher(List<Object> params) {
    this.expectedJSONRepresentation = JSON.serialize(params);
  }

  public boolean matches(List<Object> params) {
    String actualJSONRepresentation = JSON.serialize(params);
    return this.expectedJSONRepresentation == actualJSONRepresentation;
  }
}
