@IsTest
public class ParameterizedMethodSpyCall {
  private List<Object> params;
  public Object value;

  public ParameterizedMethodSpyCall(List<Object> params) {
    this.params = params;
  }

  public void thenReturn(Object value) {
    this.value = value;
  }

  public boolean matches(List<Object> params) {
    if (this.params.equals(params)) {
      return true;
    }
    if (this.params.size() != params.size()) {
      return false;
    }
    for (Integer i = 0; i < params.size(); i++) {
      Object expectedParam = this.params.get(i);
      Object actualParam = params.get(i);
      if (actualParam == expectedParam) {
        return true;
      }
      // To support Custom Apex classes that have not implemented equals and hashcode methods
      try {
        if (JSON.serialize(actualParam) == JSON.serialize(expectedParam)) {
          return true;
        }
      } catch (JSONException e) {
        // JSON serialization is not supported by all objects.
        // like common.apex.runtime.bytecode.BytecodeApexObjectType
        // In that case, we ignore the JSON comparison
      }
    }
    return false;
  }
}
