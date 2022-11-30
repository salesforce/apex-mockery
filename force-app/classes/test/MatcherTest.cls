@isTest
public class MatcherTest {
  @isTest
  static void givenAnyMatcher_matchesAnyKindOfArgument() {
    // Arrange
    ArgumentMatcher sut = Matcher.any();

    // Act & Assert
    System.assert(sut.matches(null));
    System.assert(sut.matches(Date.today()));
    System.assert(sut.matches(DateTime.now()));
    System.assert(sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(sut.matches(Blob.valueOf('test')));
    System.assert(sut.matches(false));
    System.assert(sut.matches(true));
    System.assert(sut.matches(new Account(Name = 'test')));
    System.assert(sut.matches(10));
    System.assert(sut.matches(10.2));
    System.assert(sut.matches('test'));
    System.assert(sut.matches('001000000000011AAA'));
    System.assert(sut.matches(new List<Object>()));
    System.assert(sut.matches(new Set<Object>()));
    System.assert(sut.matches(new Map<Id, Object>()));
    System.assert(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenEqualsMatcher_matchesPrimitive() {
    // Arrange
    ArgumentMatcher sut = Matcher.equals(10);

    // Act & Assert
    System.assert(sut.matches(10));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
    System.assert(!sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenEqualsMatcher_matchesSObject() {
    // Arrange
    ArgumentMatcher sut = Matcher.equals(new Account(Name = 'test'));

    // Act & Assert
    System.assert(sut.matches(new Account(Name = 'test')));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
    System.assert(!sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenEqualsMatcher_matchesCustomType() {
    // Arrange
    ArgumentMatcher sut = Matcher.equals(new CustomTypeWithEquals('test', 10, new Account(Name = 'test')));

    // Act & Assert
    System.assert(sut.matches(new CustomTypeWithEquals('test', 10, new Account(Name = 'test'))));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
    System.assert(!sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenEqualsMatcher_matchesCollection() {
    // Arrange
    ArgumentMatcher sut = Matcher.equals(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' });

    // Act & Assert
    System.assert(sut.matches(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' }));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
    System.assert(!sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenTypeMatcher_matchesPrimitive() {
    // Arrange
    ArgumentMatcher sut = Matcher.ofType('Integer');

    // Act & Assert
    System.assert(sut.matches(10));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenTypeMatcher_matchesSObject() {
    // Arrange
    ArgumentMatcher sut = Matcher.ofType(Account.getSObjectType());

    // Act & Assert
    System.assert(sut.matches(new Account()));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
    System.assert(!sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenTypeMatcher_matchesCustomType() {
    // Arrange
    ArgumentMatcher sut = Matcher.ofType(CustomType.class);

    // Act & Assert
    System.assert(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenTypeMatcher_matchesDeriveType() {
    // Arrange
    ArgumentMatcher sut = Matcher.ofType(ArgumentMatcher.class);

    // Act & Assert
    System.assert(sut.matches(new ArgumentMatcherStub()));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenTypeMatcher_matchesCollection() {
    // Arrange
    ArgumentMatcher sut = Matcher.ofType('List');

    // Act & Assert
    System.assert(sut.matches(new List<Object>{ 10, 'String', new Account() }));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenJSONMatcher_matchesPrimitive() {
    // Arrange
    ArgumentMatcher sut = Matcher.jsonEquals(10);

    // Act & Assert
    System.assert(sut.matches(10));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenJSONMatcher_matchesSObject() {
    // Arrange
    ArgumentMatcher sut = Matcher.jsonEquals(new Account(Name = 'test'));

    // Act & Assert
    System.assert(sut.matches(new Account(Name = 'test')));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenJSONMatcher_matchesCustomType() {
    // Arrange
    ArgumentMatcher sut = Matcher.jsonEquals(new CustomType('test', 10, new Account(Name = 'test')));

    // Act & Assert
    System.assert(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
  }

  @isTest
  static void givenJSONMatcher_matchesCollection() {
    // Arrange
    ArgumentMatcher sut = Matcher.jsonEquals(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' });

    // Act & Assert
    System.assert(sut.matches(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' }));

    System.assert(!sut.matches(null));
    System.assert(!sut.matches(Date.today()));
    System.assert(!sut.matches(DateTime.now()));
    System.assert(!sut.matches(Time.newInstance(12, 12, 12, 12)));
    System.assert(!sut.matches(Blob.valueOf('test')));
    System.assert(!sut.matches(false));
    System.assert(!sut.matches(true));
    System.assert(!sut.matches(10));
    System.assert(!sut.matches(10.2));
    System.assert(!sut.matches('test'));
    System.assert(!sut.matches('001000000000011AAA'));
    System.assert(!sut.matches(new Account(Name = 'test')));
    System.assert(!sut.matches(new List<Object>()));
    System.assert(!sut.matches(new Set<Object>()));
    System.assert(!sut.matches(new Map<Id, Object>()));
  }

  virtual class CustomType {
    public String name;
    public Integer size;
    public SObject sob;
    public List<Object> lo = new List<Object>();

    public CustomType(final String name, final Integer size, final SObject sob) {
      this.name = name;
      this.size = size;
      this.sob = sob;
    }
  }

  class CustomTypeWithEquals extends CustomType {
    public CustomTypeWithEquals(final String name, final Integer size, final SObject sob) {
      super(name, size, sob);
    }
    public Boolean equals(Object o) {
      if (this === o) {
        return true;
      }

      if ((o == null) || !(o instanceof CustomType)) {
        return false;
      }

      final CustomType other = (CustomType) o;
      return this.name == other.name && this.size == other.size && this.sob == other.sob;
    }

    public Integer hashCode() {
      return this.name?.hashCode();
    }
  }

  public class ArgumentMatcherStub implements ArgumentMatcher {
    public Boolean matches(final Object callArgument) {
      return true;
    }
  }
}
