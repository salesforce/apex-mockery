<div align="center">
	<img src="resources/logo.png" width="256">
	<h1>Lightweight mocking library in Apex</h1>
</div>

This project provide a simple, lightweight, easy to read, fully tested mocking library for apex.
We want its usage to be simple, its maintainability to be easy and to provide the best developer experience possible

## Principles

APIs design come from our experience with Mockito, chai.js, sinon.js and jest.
The library aims to provide developers a simple way to stub, mock and assert their implementations.
Dependency Injection and Inversion Of Control are key architectural concepts the system under test should implements

The library repository has 3 parts:

- Test classes in the `force-app/src` folder are what you need to use the lib, no more. Installation button deploy this folder.
- Test classes in the `force-app/test` folder are what we need to maintain the library and is not required in production.
- Test classes in the `force-app/recipes` folder are what you can use to have a deeper understanding of the library usages.

## Installation

Deploy via the deploy button

<a href="https://githubsfdeploy.herokuapp.com?owner=salesforce&repo=apex-mockery&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

Or copy `force-app/src/classes` test classes in your sfdx project to deploy it with your favourite deployment methods

Or you can deploy the library from the managed package [here](TODO: url to the managed package)

## Usage

### Mock

To mock an instance, use the `Mock.forType` method
It returns a Mock instance containing the stub and all the mechanism to spy/configure how it behaves

```java
final Mock myMock = Mock.forType(MyType.class);
```

### Stub

To access the stub, use the `stub` attribut
Use the stub with the system under test

```java
final MyType myTypeStub = (MyType) myMock.stub
final MyService myService = new MyServiceImpl(myTypeStub);
```

### Spy

To spy on a method, use the `spyOn` method from the mock.
It returns a `MethodSpy` instance containing all the tools to drive its behaviour and spy on it

```java
final MethodSpy myMethodSpy = myMock.spyOn('myMethod');
```

#### How to Configure a spy

##### Default behaviour

By default, a spy return `null` when called, whatever the parameters received.

```java
// Act
Object result = myTypeStub.myMethod();
// Assert
Assert.areEqual(null, result);
```

Have a look at the [NoConfiguration recipe](force-app/recipes/classes/mocking/NoConfiguration.cls)

##### Global returns

It can be configured to return a specific value, whatever the parameter received

```java
// Arrange
myMethodSpy.returns(new Account(Name='Test'));
// Act
Object result = myTypeStub.myMethod();
// Assert
Assert.areEqual(new Account(Name='Test'), result);
```

Have a look at the [Returns recipe](force-app/recipes/classes/mocking/Returns.cls)

##### Global throws

It can be configured to throw a specific exception, whatever the parameter received

```java
// Arrange
myMethodSpy.throwsException(new MyException());
try {
    // Act
    Object result = myTypeStub.myMethod();

    // Assert
    Assert.fail('Expected exception was not thrown');
} catch (Exception ex) {
    Assert.isInstanceOfType(ex, MyException.class);
}
```

Have a look at the [Throws recipe](force-app/recipes/classes/mocking/Throws.cls)

##### Parameterized configuration

It can be configured to return a specific value, when call with specific parameters
It can be configured to throw a specific value, when call with specific parameters
Use `Params` class to build the params matcher list and configure the spy to behave as you need

```java
// Arrange
myMethodSpy
    .whenCalledWith(Params.of(Matcher.any(), 10))
    .thenReturn(new Account(Name='Test'));

// Arrange
myMethodSpy
    .whenCalledWith(Params.of(Matcher.any(), -1))
    .thenThrow(new MyException);

// Act
Object result = myTypeStub.myMethod('nothing', 10);

// Assert
Assert.areEqual(new Account(Name='Test'), result);

// Act
try {
    Object result = myTypeStub.myMethod('value', -1);

    // Assert
    Assert.fail('Expected exception was not thrown');
} catch (Exception ex) {
    Assert.isInstanceOfType(ex, MyException.class);
}
```

Have a look at the [recipes](force-app/recipes/classes/mocking/) to have a deeper overview of what can be done with the mocking API.

### Assert on a spy

Use the `Assertion` class to assert on a spy
It exposes the method `assertThat` and returns a `MethodSpyAssertions` type.
Use the convenient assertion methods the following way:

```java
// hasNotBeenCalled
Assertions.assertThat(myMethodSpy).hasNotBeenCalled();

// hasBeenCalled
Assertions.assertThat(myMethodSpy).hasBeenCalled();

// hasBeenCalledTimes
Assertions.assertThat(myMethodSpy).hasBeenCalledTimes(2);

// hasBeenCalledWith
Assertions.assertThat(myMethodSpy).hasBeenCalledWith(Params.of(Matcher.any()));

// hasBeenLastCalledWith
Assertions.assertThat(myMethodSpy).hasBeenLastCalledWith(Params.of(Matcher.any()));
```

Have a look at the [recipes](force-app/recipes/classes/asserting/) to have a deeper overview of what can be done with the assertion API

### Params

Configuring a stub (`spy.whenCalledWith(...)`) and asserting (`Assertions.assertThat(myMethodSpy).hasBeenCalledWith` and `Assertions.assertThat(myMethodSpy).hasBeenLastCalledWith`) a stub uses `Params matchers`.

`Params` offer the `of` API up to 5 parameters. Use `ofList` API to create parameters for a method exposing more than 5 parameters.
It wrapes value with a `Matcher.equals` when called with `Object`.

```java
Params emptyParameters = Params.empty();

Params myMethodParameters = Params.of(10, 'string'); // Up to five

Params myMethodWithLongParameters = Params.ofList(new List<Object>{10, 'string', true, 20, false, 'Sure'});
```

### Matchers

The library provide several OOTB (out of the box) Matchers ready for use and fully tested.
The library accept your own matchers for specific use cases and reusability.

#### Any

`Matcher.any()` matches anything

```java
Params param = Params.of(Matcher.any());
```

#### Equal

`Matcher.equal()` (the default) matches with native deep equals

```java
Params param = Params.of(Matcher.equals(10));
```

#### jsonEqual

`Matcher.jsonEquals(new WithoutEqualsType())` matches with json string equals. Convenient to match without `equals` type

```java
Params param = Params.of(Matcher.jsonEquals(new WithoutEqualsType(10, true, '...')));
```

#### ofType

`Matcher.ofType()` matches on the type of the param

```java
// To match any Integer
Params param = Params.of(Matcher.ofType('Integer'));
// To match any Account SObject
Params param = Params.of(Matcher.ofType(Account.getSObjectType()));
// To match any CustomType class instance
Params param = Params.of(Matcher.ofType(CustomType.class));
```

#### BYOM (Build your own matcher)

Implement the `Matcher.ArgumentMatcher` interface and then use it with `Params` APIs

```java
@isTest
public class MyMatcher implements Matcher.ArgumentMatcher {
  public Boolean matches(final Object callArgument) {
    MyType myType = (MyType) callArgument;
    boolean matches = false;

    // custom logic to determine if it matches here
    ...

    return matches;
  }
}

Params param = Params.of(new MyMatcher());
```

Have a look at the [overview recipes](force-app/recipes/classes/ApexMockeryOverview.cls) to have a deeper overview of what can be done with the library

### Class diagram

![apex mockery class diagram](resources/class_diagram.png)

## Authors

- **Sebastien Colladon** - Developer - [scolladon-sfdc](https://github.com/scolladon-sfdc)
- **Ludovic Meurillon** - Architect - [LudoMeurillon](https://github.com/LudoMeurillon) _Initial work_

## Contributing

Contributions are what make the trailblazer community such an amazing place. Any contributions you make are **appreciated**.

See [contributing.md](/CONTRIBUTING.md) for apex-mockery contribution principles.

## License

This project license is BSD 3 - see the [LICENSE.md](LICENSE.md) file for details
