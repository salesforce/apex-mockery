@isTest
public class ArgumentTest {
  @isTest
  static void givenAnyMatchable_matchesAnyKindOfArgument() {
    // Arrange
    Argument.Matchable sut = Argument.any();

    // Act & Assert
    Assert.isTrue(sut.matches(null));
    Assert.isTrue(sut.matches(Date.today()));
    Assert.isTrue(sut.matches(DateTime.now()));
    Assert.isTrue(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isTrue(sut.matches(Blob.valueOf('test')));
    Assert.isTrue(sut.matches(false));
    Assert.isTrue(sut.matches(true));
    Assert.isTrue(sut.matches(new Account(Name = 'test')));
    Assert.isTrue(sut.matches(10));
    Assert.isTrue(sut.matches(10.2));
    Assert.isTrue(sut.matches('test'));
    Assert.isTrue(sut.matches('001000000000011AAA'));
    Assert.isTrue(sut.matches(new List<Object>()));
    Assert.isTrue(sut.matches(new Set<Object>()));
    Assert.isTrue(sut.matches(new Map<Id, Object>()));
    Assert.isTrue(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenEqualsMatchable_matchesPrimitive() {
    // Arrange
    Argument.Matchable sut = Argument.equals(10);

    // Act & Assert
    Assert.isTrue(sut.matches(10));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
    Assert.isFalse(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenEqualsMatchable_matchesSObject() {
    // Arrange
    Argument.Matchable sut = Argument.equals(new Account(Name = 'test'));

    // Act & Assert
    Assert.isTrue(sut.matches(new Account(Name = 'test')));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
    Assert.isFalse(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenEqualsMatchable_matchesCustomTypeWithEqualsAndProperties() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(new CustomTypeWithEquals('test', 10, new Account(Name = 'test')));

    // Act & Assert
    Assert.isTrue(sut.matches(new CustomTypeWithEquals('test', 10, new Account(Name = 'test'))));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenEqualsMatchable_matchesCustomTypeWithoutProperties() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(new CustomType());

    // Act & Assert
    Assert.isTrue(sut.matches(new CustomType()));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenEqualsMatchable_matchesCollection() {
    // Arrange
    Argument.Matchable sut = Argument.equals(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' });

    // Act & Assert
    Assert.isTrue(sut.matches(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' }));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
    Assert.isFalse(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenTypeMatchable_matchesPrimitive() {
    // Arrange
    Argument.Matchable sut = Argument.ofType('Integer');

    // Act & Assert
    Assert.isTrue(sut.matches(10));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenTypeMatchable_matchesSObject() {
    // Arrange
    Argument.Matchable sut = Argument.ofType(Account.getSObjectType());

    // Act & Assert
    Assert.isTrue(sut.matches(new Account()));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
    Assert.isFalse(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenTypeMatchable_matchesCustomType() {
    // Arrange
    Argument.Matchable sut = Argument.ofType(CustomType.class);

    // Act & Assert
    Assert.isTrue(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenTypeMatchable_matchesDeriveType() {
    // Arrange
    Argument.Matchable sut = Argument.ofType(Argument.Matchable.class);

    // Act & Assert
    Assert.isTrue(sut.matches(new MatchableStub()));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenTypeMatchable_matchesCollection() {
    // Arrange
    Argument.Matchable sut = Argument.ofType('List');

    // Act & Assert
    Assert.isTrue(sut.matches(new List<Object>{ 10, 'String', new Account() }));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenJSONMatchable_matchesPrimitive() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(10);

    // Act & Assert
    Assert.isTrue(sut.matches(10));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenJSONMatchable_matchesSObject() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(new Account(Name = 'test'));

    // Act & Assert
    Assert.isTrue(sut.matches(new Account(Name = 'test')));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenJSONMatchable_matchesCustomType() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(new CustomType('test', 10, new Account(Name = 'test')));

    // Act & Assert
    Assert.isTrue(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenJSONMatchable_matchesCollection() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' });

    // Act & Assert
    Assert.isTrue(sut.matches(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' }));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(DateTime.now()));
    Assert.isFalse(sut.matches(Time.newInstance(12, 12, 12, 12)));
    Assert.isFalse(sut.matches(Blob.valueOf('test')));
    Assert.isFalse(sut.matches(false));
    Assert.isFalse(sut.matches(true));
    Assert.isFalse(sut.matches(10));
    Assert.isFalse(sut.matches(10.2));
    Assert.isFalse(sut.matches('test'));
    Assert.isFalse(sut.matches('001000000000011AAA'));
    Assert.isFalse(sut.matches(new Account(Name = 'test')));
    Assert.isFalse(sut.matches(new List<Object>()));
    Assert.isFalse(sut.matches(new Set<Object>()));
    Assert.isFalse(sut.matches(new Map<Id, Object>()));
  }

  virtual class CustomType {
    public String name;
    public Integer size;
    public SObject sob;
    public List<Object> lo = new List<Object>();

    public CustomType(String name, Integer size, SObject sob) {
      this.name = name;
      this.size = size;
      this.sob = sob;
    }

    public CustomType() {
    }
  }

  class CustomTypeWithEquals extends CustomType {
    public CustomTypeWithEquals(String name, Integer size, SObject sob) {
      super(name, size, sob);
    }
    public Boolean equals(Object o) {
      if (this === o) {
        return true;
      }

      if ((o == null) || !(o instanceof CustomType)) {
        return false;
      }

      CustomType other = (CustomType) o;
      return this.name == other.name && this.size == other.size && this.sob == other.sob;
    }

    public Integer hashCode() {
      return this.name?.hashCode();
    }
  }

  public class MatchableStub implements Argument.Matchable {
    public Boolean matches(Object callArgument) {
      return true;
    }
  }

  @isTest
  static void givenNull_whenOfIsCalled_doesNotmatche() {
    // Arrange
    List<Argument.Matchable> sut = null;

    // Act
    Boolean result = Argument.matches(sut, new List<Object>());

    // Assert
    Assert.isFalse(result);
  }

  @isTest
  static void givenNothing_whenNullIsCalled_doesNotmatche() {
    // Arrange
    List<Argument.Matchable> sut = Argument.empty();

    // Act
    Boolean result = Argument.matches(sut, null);

    // Assert
    Assert.isFalse(result);
  }

  @isTest
  static void givenNull_whenNullIsCalled_matches() {
    // Arrange
    List<Argument.Matchable> sut = null;

    // Act
    Boolean result = Argument.matches(sut, null);

    // Assert
    Assert.isTrue(result);
  }

  @isTest
  static void givenNothing_whenOfIsCalled_matchesEmptyList() {
    // Arrange
    List<Argument.Matchable> sut = Argument.empty();

    // Act
    Boolean result = Argument.matches(sut, new List<Object>());

    // Assert
    Assert.isTrue(result);
  }

  @isTest
  static void given1Object_whenOfIsCalled_matchesTheElement() {
    // Arrange
    List<Argument.Matchable> sut = Argument.of('test');

    // Act
    Boolean result = Argument.matches(sut, new List<Object>{ 'test' });

    // Assert
    Assert.isTrue(result);
  }

  @isTest
  static void given2Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    List<Argument.Matchable> sut = Argument.of('test', 10);

    // Act
    Boolean positive = Argument.matches(sut, new List<Object>{ 'test', 10 });
    Boolean negative = Argument.matches(sut, new List<Object>{ 10, 'test' });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given3Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    List<Argument.Matchable> sut = Argument.of('test', 10, new Account());

    // Act
    Boolean positive = Argument.matches(sut, new List<Object>{ 'test', 10, new Account() });
    Boolean negative = Argument.matches(sut, new List<Object>{ 10, 'test', new Account() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given4Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    List<Argument.Matchable> sut = Argument.of('test', 10, new Account(), new List<Date>());

    // Act
    Boolean positive = Argument.matches(sut, new List<Object>{ 'test', 10, new Account(), new List<Date>() });
    Boolean negative = Argument.matches(sut, new List<Object>{ 10, 'test', new Account(), new List<Date>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given5Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    List<Argument.Matchable> sut = Argument.of('test', 10, new Account(), new List<Date>(), new Map<Id, Set<String>>());

    // Act
    Boolean positive = Argument.matches(sut, new List<Object>{ 'test', 10, new Account(), new List<Date>(), new Map<Id, Set<String>>() });
    Boolean negative = Argument.matches(sut, new List<Object>{ 10, 'test', new Account(), new List<Date>(), new Map<Id, Set<String>>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void givenListOf10MixType_whenOfListIsCalledWithList_matchesElementsInOrder() {
    // Arrange
    List<Argument.Matchable> sut = Argument.ofList(
      new List<Object>{
        Argument.equals('test'),
        Argument.equals(10),
        Argument.jsonEquals(new Account()),
        Argument.ofType('List'),
        new Map<Id, Set<String>>(),
        new Set<Date>(),
        new List<Account>(),
        Blob.valueOf('test'),
        new CustomMatchable(),
        Argument.ofType(CustomType.class)
      }
    );

    // Act
    Boolean positive = Argument.matches(
      sut,
      new List<Object>{
        'test',
        10,
        new Account(),
        new List<Date>(),
        new Map<Id, Set<String>>(),
        new Set<Date>(),
        new List<Account>(),
        Blob.valueOf('test'),
        'test',
        new CustomType()
      }
    );
    Boolean negative = Argument.matches(sut, new List<Object>{ 10, 'test', new Account(), new List<Date>(), new Map<Id, Set<String>>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void whenOfListIsCalledWithNull_matchesEmptyList() {
    // Act
    List<Argument.Matchable> sut = Argument.ofList(null);

    // Act
    Boolean result = Argument.matches(sut, new List<Object>());

    // Assert
    Assert.isTrue(result);
  }

  class CustomMatchable implements Argument.Matchable {
    public Boolean matches(Object callArgument) {
      return true;
    }
  }
}
