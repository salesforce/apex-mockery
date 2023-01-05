@isTest
public class MatcherTest {
  @isTest
  static void givenAnyMatcher_matchesAnyKindOfArgument() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.any();

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
  static void givenEqualsMatcher_matchesPrimitive() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.equals(10);

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
  static void givenEqualsMatcher_matchesSObject() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.equals(new Account(Name = 'test'));

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
  static void givenEqualsMatcher_matchesCustomType() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.equals(new CustomTypeWithEquals('test', 10, new Account(Name = 'test')));

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
    Assert.isFalse(sut.matches(new CustomType('test', 10, new Account(Name = 'test'))));
  }

  @isTest
  static void givenEqualsMatcher_matchesCollection() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.equals(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' });

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
  static void givenTypeMatcher_matchesPrimitive() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.ofType('Integer');

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
  static void givenTypeMatcher_matchesSObject() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.ofType(Account.getSObjectType());

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
  static void givenTypeMatcher_matchesCustomType() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.ofType(CustomType.class);

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
  static void givenTypeMatcher_matchesDeriveType() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.ofType(Matcher.ArgumentMatcher.class);

    // Act & Assert
    Assert.isTrue(sut.matches(new ArgumentMatcherStub()));

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
  static void givenTypeMatcher_matchesCollection() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.ofType('List');

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
  static void givenJSONMatcher_matchesPrimitive() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.jsonEquals(10);

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
  static void givenJSONMatcher_matchesSObject() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.jsonEquals(new Account(Name = 'test'));

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
  static void givenJSONMatcher_matchesCustomType() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.jsonEquals(new CustomType('test', 10, new Account(Name = 'test')));

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
  static void givenJSONMatcher_matchesCollection() {
    // Arrange
    Matcher.ArgumentMatcher sut = Matcher.jsonEquals(new Map<String, Object>{ 'A' => new Account(), 'B' => 'test' });

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

  public class ArgumentMatcherStub implements Matcher.ArgumentMatcher {
    public Boolean matches(Object callArgument) {
      return true;
    }
  }
}
