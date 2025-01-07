@IsTest
public class ArgumentTest {
  @IsTest
  static void givenAnyMatchable_matchesAnyKindOfArgument() {
    // Arrange
    Argument.Matchable sut = Argument.any();

    // Act & Assert
    Assert.isTrue(sut.matches(null));
    Assert.isTrue(sut.matches(Date.today()));
    Assert.isTrue(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenEqualsMatchable_matchesPrimitive() {
    // Arrange
    Argument.Matchable sut = Argument.equals(10);

    // Act & Assert
    Assert.isTrue(sut.matches(10));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenEqualsMatchable_matchesSObject() {
    // Arrange
    Argument.Matchable sut = Argument.equals(new Account(Name = 'test'));

    // Act & Assert
    Assert.isTrue(sut.matches(new Account(Name = 'test')));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenEqualsMatchable_matchesCustomTypeWithEquals() {
    // Arrange
    Argument.Matchable sut = Argument.equals(new CustomTypeWithEquals('test', 10, new Account(Name = 'test')));

    // Act & Assert
    Assert.isTrue(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
    Assert.isTrue(sut.matches(new CustomTypeWithEquals('test', 10, new Account(Name = 'test'))));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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
    Assert.isFalse(sut.matches(new CustomType('TEST', 10, new Account(Name = 'TEST'))));
    Assert.isFalse(sut.matches(new CustomTypeWithEquals('TEST', 10, new Account(Name = 'TEST'))));
  }

  @IsTest
  static void givenEqualsMatchable_matchesCollection() {
    // Arrange
    Argument.Matchable sut = Argument.equals(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' });

    // Act & Assert
    Assert.isTrue(sut.matches(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' }));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenTypeMatchable_matchesPrimitive() {
    // Arrange
    Argument.Matchable sut = Argument.ofType('Integer');

    // Act & Assert
    Assert.isTrue(sut.matches(10));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenTypeMatchable_matchesSObject() {
    // Arrange
    Argument.Matchable sut = Argument.ofType(Account.getSObjectType());

    // Act & Assert
    Assert.isTrue(sut.matches(new Account()));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenTypeMatchable_matchesCustomType() {
    // Arrange
    Argument.Matchable sut = Argument.ofType(CustomType.class);

    // Act & Assert
    Assert.isTrue(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenTypeMatchable_matchesDeriveType() {
    // Arrange
    Argument.Matchable sut = Argument.ofType(Argument.Matchable.class);

    // Act & Assert
    Assert.isTrue(sut.matches(new MatchableStub()));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenTypeMatchable_matchesCollection() {
    // Arrange
    Argument.Matchable sut = Argument.ofType('List');

    // Act & Assert
    Assert.isTrue(sut.matches(new List<Object>{ 10, 'String', new Account() }));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenJSONMatchable_matchesPrimitive() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(10);

    // Act & Assert
    Assert.isTrue(sut.matches(10));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenJSONMatchable_matchesSObject() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(new Account(Name = 'test'));

    // Act & Assert
    Assert.isTrue(sut.matches(new Account(Name = 'test')));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenJSONMatchable_matchesCustomType() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(new CustomType('test', 10, new Account(Name = 'test')));

    // Act & Assert
    Assert.isTrue(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenJSONMatchable_matchesCollection() {
    // Arrange
    Argument.Matchable sut = Argument.jsonEquals(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' });

    // Act & Assert
    Assert.isTrue(sut.matches(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' }));

    Assert.isFalse(sut.matches(null));
    Assert.isFalse(sut.matches(Date.today()));
    Assert.isFalse(sut.matches(Datetime.now()));
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

  @IsTest
  static void givenNull_whenOfIsCalled_doesNotmatche() {
    // Arrange
    List<Argument.Matchable> sut = null;

    // Act
    Boolean result = Argument.matches(sut, new List<Object>());

    // Assert
    Assert.isFalse(result);
  }

  @IsTest
  static void givenNothing_whenNullIsCalled_doesNotmatche() {
    // Arrange
    List<Argument.Matchable> sut = Argument.empty();

    // Act
    Boolean result = Argument.matches(sut, null);

    // Assert
    Assert.isFalse(result);
  }

  @IsTest
  static void givenNull_whenNullIsCalled_matches() {
    // Arrange
    List<Argument.Matchable> sut = null;

    // Act
    Boolean result = Argument.matches(sut, null);

    // Assert
    Assert.isTrue(result);
  }

  @IsTest
  static void givenNothing_whenOfIsCalled_matchesEmptyList() {
    // Arrange
    List<Argument.Matchable> sut = Argument.empty();

    // Act
    Boolean result = Argument.matches(sut, new List<Object>());

    // Assert
    Assert.isTrue(result);
  }

  @IsTest
  static void given1Object_whenOfIsCalled_matchesTheElement() {
    // Arrange
    List<Argument.Matchable> sut = Argument.of('test');

    // Act
    Boolean result = Argument.matches(sut, new List<Object>{ 'test' });

    // Assert
    Assert.isTrue(result);
  }

  @IsTest
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

  @IsTest
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

  @IsTest
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

  @IsTest
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

  @IsTest
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

  @IsTest
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

  @IsTest
  static void getType_whenCalledWithSObject_returnsSObjectType() {
    // Assert
    Assert.areEqual(Account.class, Argument.getType(new Account()));
    Assert.areEqual(Opportunity.class, Argument.getType(new Opportunity()));
  }

  @IsTest
  static void getType_whenCalledWithPrimitive_returnsPrimitiveType() {
    // Assert
    Assert.areEqual(Blob.class, Argument.getType(Blob.valueOf('test')));
    Assert.areEqual(Boolean.class, Argument.getType(true));
    Assert.areEqual(Date.class, Argument.getType(Date.today()));
    Assert.areEqual(Datetime.class, Argument.getType(Datetime.now()));
    Decimal dec = 42.0;
    Assert.areEqual(Decimal.class, Argument.getType(dec));
    Assert.areEqual(Double.class, Argument.getType(42.0d));
    Id contactId = '00300000003T2PGAA0';
    Assert.areEqual(ID.class, Argument.getType(contactId));
    Assert.areEqual(Integer.class, Argument.getType(42));
    Assert.areEqual(Long.class, Argument.getType(42L));
    Assert.areEqual(String.class, Argument.getType('test'));
    Assert.areEqual(Time.class, Argument.getType(Time.newInstance(10, 10, 10, 10)));
  }

  @IsTest
  static void getType_whenCalledWithObject_returnObjectType() {
    // Assert
    Assert.areEqual(List<Account>.class, Argument.getType(new List<Account>()));
    Assert.areEqual(ArgumentTest.class, Argument.getType(new ArgumentTest()));
  }

  @IsTest
  static void areListsEqual_whenCalledWithNull_returnsTrue() {
    // Arrange
    final List<Argument.Matchable> list1 = null;
    final List<Argument.Matchable> list2 = null;

    // Act
    final Boolean result = Argument.areListsEqual(list1, list2);

    // Assert
    Assert.isTrue(result);
  }

  @IsTest
  static void areListsEqual_whenCalledWithOneNull_returnsFalse() {
    // Arrange
    final List<Argument.Matchable> list1 = new List<Argument.Matchable>();
    final List<Argument.Matchable> list2 = null;

    // Act
    Boolean result = Argument.areListsEqual(list1, list2);

    // Assert
    Assert.isFalse(result);

    // Act
    result = Argument.areListsEqual(list2, list1);

    // Assert
    Assert.isFalse(result);
  }

  @IsTest
  static void areListsEqual_whenCalledWithDifferentListInSize_returnsFalse() {
    // Arrange
    final List<Argument.Matchable> list1 = new List<Argument.Matchable>{ Argument.any(), Argument.any() };
    final List<Argument.Matchable> list2 = new List<Argument.Matchable>{ Argument.any() };

    // Act
    final Boolean result = Argument.areListsEqual(list1, list2);

    // Assert
    Assert.isFalse(result);
  }

  @IsTest
  static void areListsEqual_whenCalledWithDifferentList_returnsFalse() {
    // Arrange
    final List<Argument.Matchable> list1 = new List<Argument.Matchable>{ Argument.any(), Argument.any() };
    final List<Argument.Matchable> list2 = new List<Argument.Matchable>{ Argument.any(), Argument.equals('str') };

    // Act
    final Boolean result = Argument.areListsEqual(list1, list2);

    // Assert
    Assert.isFalse(result);
  }

  @IsTest
  static void areListsEqual_whenCalledWithSameList_returnsFalse() {
    // Arrange
    final List<Argument.Matchable> list1 = new List<Argument.Matchable>{
      Argument.any(),
      Argument.equals('str'),
      Argument.jsonEquals(new Account(Name = 'Test')),
      Argument.ofType(Opportunity.getSObjectType())
    };
    final List<Argument.Matchable> list2 = new List<Argument.Matchable>{
      Argument.any(),
      Argument.equals('str'),
      Argument.jsonEquals(new Account(Name = 'Test')),
      Argument.ofType(Opportunity.getSObjectType())
    };

    // Act
    final Boolean result = Argument.areListsEqual(list1, list2);

    // Assert
    Assert.isTrue(result);
  }

  @IsTest
  static void ArgumentAnyMatchable_equals_spec() {
    // Act && Assert
    Assert.isTrue(Argument.any() == Argument.any());
    Assert.isFalse(Argument.any() == null);
    Assert.isFalse(Argument.any() == Argument.equals('str'));
    Assert.isFalse(Argument.any() == Argument.jsonEquals('str'));
    Assert.isFalse(Argument.any() == Argument.ofType(Account.getSObjectType()));
  }

  @IsTest
  static void ArgumentEqualsMatchable_equals_spec() {
    // Act && Assert
    Assert.isTrue(Argument.equals(new Account()) == Argument.equals(new Account()));
    Assert.isTrue(Argument.equals('str') == Argument.equals('str'));
    Assert.isTrue(Argument.equals('STR') == Argument.equals('str'));
    Assert.isFalse(Argument.equals('STR') == Argument.equals('not str'));
    Assert.isFalse(Argument.equals('any') == Argument.any());
    Assert.isFalse(Argument.equals(new Account()) == Argument.jsonEquals(new Account()));
    Assert.isFalse(Argument.equals(new Account()) == Argument.ofType(Account.getSObjectType()));
  }

  @IsTest
  static void ArgumentJSONMatchable_equals_spec() {
    // Act && Assert
    Assert.isTrue(Argument.jsonEquals(new Account()) == Argument.jsonEquals(new Account()));
    Assert.isTrue(Argument.jsonEquals('str') == Argument.jsonEquals('str'));
    Assert.isFalse(Argument.jsonEquals('STR') == Argument.jsonEquals('str'));
    Assert.isFalse(Argument.jsonEquals('STR') == Argument.jsonEquals('not str'));
    Assert.isFalse(Argument.jsonEquals('any') == Argument.any());
    Assert.isFalse(Argument.jsonEquals(new Account()) == Argument.equals(new Account()));
    Assert.isFalse(Argument.jsonEquals(new Account()) == Argument.ofType(Account.getSObjectType()));
  }

  @IsTest
  static void ArgumentTypeMatchable_equals_spec() {
    // Act && Assert
    Assert.isTrue(Argument.ofType(Account.getSObjectType()) == Argument.ofType(Account.getSObjectType()));
    Assert.isTrue(Argument.ofType('string') == Argument.ofType('string'));
    Assert.isTrue(Argument.ofType(Argument.class) == Argument.ofType(Argument.class));
    Assert.isFalse(Argument.ofType(Argument.class) == Argument.ofType(ArgumentTest.class));
    Assert.isFalse(Argument.ofType(Account.getSObjectType()) == Argument.ofType(Opportunity.getSObjectType()));
    Assert.isFalse(Argument.ofType('test') == Argument.ofType('other'));
    Assert.isFalse(Argument.ofType('any') == Argument.any());
    Assert.isFalse(Argument.ofType(Account.getSObjectType()) == Argument.equals(new Account()));
    Assert.isFalse(Argument.ofType(Argument.class) == Argument.jsonEquals(new Account()));
  }
}
