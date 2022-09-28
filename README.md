# Apex Mockery

Lightweight mocking library in Apex

This project provide a simple, lightweight, easy to read mocking library for apex.
We want its usage to be simple, its maintainability to be easy and to provide the best developer experience possible

<a href="https://githubsfdeploy.herokuapp.com?owner=salesforce&repo=apex-mockery">
  <img alt="Deploy to Salesforce"
	   src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

## Principles

APIs design come from our experience with Mockito, chai.js, sinon.js and jest.
The library aims to provide developers a simple way to stub, mock and assert their implementations.
Dependency Injection and Inversion Of Control are key architectural concepts the system under test should implements

## Usage

Let's assume we have this interface we want to mock to test `MyService`:

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

To assert the test called the mock with the right parameters, use the `Assertion` class
It allows to assert at the mock level or the spy level

```java
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
        Assertions.assertThat(isOddSpy)
            .hasBeenCalledWith(
                11
            );
        // Assert sut
    }
    // ... Test other scenario
}
```
