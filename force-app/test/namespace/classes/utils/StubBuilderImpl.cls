public class StubBuilderImpl implements mockery.Mock.StubBuilder {
  public Object build(final Type aType, System.StubProvider stubProvider) {
    return Test.createStub(aType, stubProvider);
  }
}
