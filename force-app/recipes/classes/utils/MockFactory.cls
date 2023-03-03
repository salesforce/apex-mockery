@isTest
public class MockFactory {
  public static mockery.Mock forType(final Type aType) {
    final mockery.Mock mockInstance = new mockery.Mock();
    mockInstance.stub = Test.createStub(aType, mockInstance);
    return mockInstance;
  }
}
