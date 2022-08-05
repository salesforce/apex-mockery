public with sharing class FunctionalTest {
  public FunctionalTest() {
  }
}

/*
@isTest
private class PocMethodSpyTest {
    @isTest
    static void testPoc() {
        final Mock pocMock = Mock.forType(PocInterface.class);
        pocMock.spyOn('methodWithList');

        PocSubject sut = new PocSubject((PocInterface) pocMock.stub);

        sut.testThese();

        List<Account> t = new List<Account>{ new Account() };
        System.Debug('SEB: (PocMethodSpyTest) test list ' + t);
        Assertions.assertThat(pocMock)
            .method('methodWithList')
            .hasBeenCalledWith(t);
    }

    @isTest
    static void testObject() {
        final Mock pocMock = Mock.forType(PocInterface.class);
        pocMock.spyOn('methodWithSObject');

        PocSubject sut = new PocSubject((PocInterface) pocMock.stub);

        sut.testThis();

        Assertions.assertThat(pocMock)
            .method('methodWithSObject')
            .hasBeenCalledWith(new Account());
    }

    @isTest
    static void testMultipleObject() {
        final Mock pocMock = Mock.forType(PocInterface.class);
        pocMock.spyOn('methodWithMultipleParams');

        PocSubject sut = new PocSubject((PocInterface) pocMock.stub);

        sut.testThat();

        List<Object> t = new List<Object>{ new Account(), new Account() };
        System.Debug('SEB: (PocMethodSpyTest) test list ' + t);
        Assertions.assertThat(pocMock)
            .method('methodWithMultipleParams')
            .hasBeenCalledWithParams(t);
    }

    @isTest
    static void testMultipleCompositeObject() {
        final Mock pocMock = Mock.forType(PocInterface.class);
        pocMock.spyOn('methodWithMultipleCompositeParams');

        PocSubject sut = new PocSubject((PocInterface) pocMock.stub);

        sut.testThose();

        List<Object> t = new List<Object>{
            new List<SObject>{ new Account() },
            new Account()
        };
        System.Debug('SEB: (PocMethodSpyTest) test list ' + t);
        Assertions.assertThat(pocMock)
            .method('methodWithMultipleCompositeParams')
            .hasBeenCalledWithParams(t);
    }

    class PocSubject {
        PocInterface service;

        public PocSubject(PocInterface service) {
            this.service = service;
        }

        public void testThose() {
            this.service.methodWithMultipleCompositeParams(
                new List<SObject>{ new Account() },
                new Account()
            );
        }

        public void testThese() {
            this.service.methodWithList(new List<SObject>{ new Account() });
        }

        public void testThis() {
            this.service.methodWithSObject(new Account());
        }

        public void testThat() {
            this.service.methodWithMultipleParams(new Account(), new Account());
        }
    }
}
*/

