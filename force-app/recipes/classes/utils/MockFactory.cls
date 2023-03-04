@isTest
public class MockFactory {
  public static Mock forType(final Type aType) {
    final Mock mockInstance = new Mock();
    mockInstance.stub = Test.createStub(aType, mockInstance);
    return mockInstance;
  }
}
