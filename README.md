# Apex Mockery

Lightweight mocking library in Apex

This project provide a very simple, lightweight, easy to read mocking library for apex.
We want its usage to be very simple, its maintainability to be very easy and to provide the best developer experience possible

<a href="https://githubsfdeploy.herokuapp.com?owner=salesforce&repo=apex-mockery">
  <img alt="Deploy to Salesforce"
	   src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

## Principles

This library is based on our experience with Mockito, chai.js, sinon.js and jest.
The library aims to provide developers a very simple way to stub, mock and assert their implementations.
Dependency Injection and Inversion Of Control are key architectural concepts the system under test need to comply with

## Usage

Let's assume we have this interface we want to mock in order to test `MyService`:

```java
public interface INumberUtils {
    boolean isOdd(Integer number);
    boolean isEven(Integer number);
}

public class NumberUtils implements INumberUtils {
    public boolean isOdd(Integer number) {
        return number != null && math.mod(number, 2) != 0;
    }
    public boolean isEven(Integer number) {
        return number != null && math.mod(number, 2) == 0;
    }
}

public MyService {
    private INumberUtils numberUtils;

    public MyService(final INumberUtils numberUtils) {
        this.numberUtils = numberUtils;
    }

    public void doSomething(final Integer number) {
        if(this.numberUtils.isOdd(number)) {
            // do Something
        } else if(this.numberUtils.isEven(number)) {
            // do Something
        } else {
            // do Something
        }
    }
}
```

### Mock

To mock an instance, use the `Mock.forType` method
It returns a Mock instance containing the stub and all the mechanism to drive its behaviour

```java
final Mock numberUtilsMock = Mock.forType(INumberUtils.class);
```

### Stub

To access the stub, use the `stub` attribut
Use the stub with the system under test

```java
final INumberUtils numberUtilsStub = (INumberUtils) numberUtilsMock.stub
final MyService sut = new MyService(numberUtilsStub);
```

### Spy

To spy on a method, use the `spyOn` method.
It returns a MethodSpy instance containing all the tools to drive its behaviour and spy on it

```java
final MethodSpy isOddSpy = numberUtilsMock.spyOn('isOdd');
isOddSpy.returns(true);
```

### Assert

To assert a mock has been called with the right parameters, use the `Assertion` class
It allows to assert at the mock level or the spy level

```java
Assertions.assertThat(numberUtilsMock)
    .method('isOdd')
    .hasBeenCalledWith(
        11
    );
// Or
Assertions.assertThat(isOddSpy)
    .hasBeenCalledWith(
        11
    );
```

### Full example

```java
@IsTest
private MyServiceTest {
    @IsTest
    static void doSomething_givenOddInteger_itDoesSomething {
        // Arrange
        final Mock numberUtilsMock = Mock.forType(INumberUtils.class);
        final MethodSpy isOddSpy = numberUtilsMock.spyOn('isOdd');
        isOddSpy.returns(true);
        final INumberUtils numberUtilsStub = (INumberUtils) numberUtilsMock.stub
        final MyService sut = new MyService(numberUtilsStub);

        // Act
        sut.doSomething(11);

        // Assert
        Assertions.assertThat(numberUtilsMock)
            .method('isOdd')
            .hasBeenCalledWith(
                11
            );
        // Assert sut
    }
    // ... Test other scenario
}
```
