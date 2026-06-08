# apex-mockery Design

## Purpose

apex-mockery is a test-double library for Apex. It lets test authors create stubs for any Apex interface or class, configure per-method return values and exception throws (including argument-specific and call-count-limited variants), and assert on how those methods were invoked. The library works entirely within the Apex Stub API (`System.StubProvider`) and ships as an unlocked package so it can be installed across Salesforce orgs without namespace conflicts.

## Architecture Overview

The library is composed of four classes that form a clean layered design.

`Mock` is the entry point. It owns a stub object and a map of `MethodSpy` instances keyed by lower-cased method name. When the Apex runtime intercepts a call on the stub, it routes it through `Mock.handleMethodCall`, which looks up the matching spy and delegates execution. Test code interacts with `Mock` through `spyOn` to create or retrieve spies and through the `stub` property to pass the fake object into the system under test.

`MethodSpy` is the behavioral core. It records every invocation in a `CallLog` and dispatches calls through a two-pass algorithm to find the right configured behavior. Behavior is separated into two categories: parameterized configs (`MatchingParamsMethodSpyConfig`) that match only when arguments satisfy a list of `Argument.Matchable` instances, and a default config (`BehaviorManagement`) that applies regardless of arguments. Each category further distinguishes once-behaviors (consumed one at a time, in order) from general behaviors (permanent fallback).

`Argument` is a matcher factory and normalization layer. It provides built-in `Matchable` implementations (`any`, `equals`, `jsonEquals`, `ofType`) and the `ofList` normalizer that promotes plain values to `EqualsMatchable` automatically. It also exposes `matches` and `areListsEqual` utilities consumed internally by `MethodSpy` and `Expect`.

`Expect` is the assertion DSL. `Expect.that(spy)` returns a `MethodSpyExpectable` that wraps the spy's `CallLog` and exposes readable assertions such as `hasBeenCalled`, `hasBeenCalledTimes`, `hasBeenCalledWith`, and `hasBeenLastCalledWith`. Error messages are built lazily via the `ErrorMessage` interface and only materialized as strings when an assertion actually fails.

## Class Responsibilities

### `Mock`

Entry point and `StubProvider` implementation. Wraps `Test.createStub()` behind the `StubBuilder` interface, owns the `Map<String, MethodSpy>` that backs all spy lookups, and implements `handleMethodCall` to route runtime interceptions to the right spy. Keys are normalized to lower-case so spy lookup is case-insensitive. Provides `spyOn` (create-or-retrieve) and `getSpy` (retrieve-only) for test setup.

### `MethodSpy`

Records calls via `CallLog` and dispatches them through `dispatchBehavior`. Holds two behavior containers: a `List<MatchingParamsMethodSpyConfig>` for argument-specific rules and a `BehaviorManagement` for the default rule. Both containers manage `SpyBehavior` implementations that either return a value (`ConfiguredValueBehavior`) or throw (`ConfiguredExceptionBehavior`). The `DispatchResult` wrapper distinguishes a matched result whose value is `null` from the absence of any match, which triggers a `ConfigurationException`.

### `Argument`

Static factory for `Matchable` instances. `ofList` is the normalization gateway: any element that already implements `Matchable` is kept as-is; anything else is wrapped in `EqualsMatchable`. The 1–5 positional `of` overloads delegate to `ofList`. `areListsEqual` compares two `Matchable` lists by object identity (used to deduplicate parameterized spy configs). `getTypeName` uses exception-message parsing to retrieve the runtime type of an arbitrary `Object`.

### `Expect`

Assertion DSL. `Expect.that(spy)` returns a `DefaultMethodSpyExpectable` that reads the spy's `CallLog` directly. Each assertion builds an `ErrorMessageImpl` at call time but defers its `toString()` until a failing condition is detected, keeping the happy path allocation-free. The `Asserter` interface allows tests of `Expect` itself to inject a custom assertion strategy.

## Key Design Decisions

**`global` visibility.** Every public type is declared `global` so the library works correctly when installed as an unlocked package. Apex unlocked packages expose only `global` symbols to consuming code outside the package namespace.

**`StubBuilder` interface.** `Test.createStub()` cannot be called across namespace boundaries. By parameterizing stub construction behind `Mock.StubBuilder`, consumers in a different namespace can supply their own builder that calls `Test.createStub` from within their namespace while still delegating behavior dispatch to `Mock`.

**Two-pass dispatch in `MethodSpy.call()`.** The dispatch algorithm runs in four ordered steps: (1) once-behaviors on parameterized configs, (2) the default once-behavior, (3) general behaviors on parameterized configs, (4) the default general behavior. This ordering ensures that finite-use behaviors fire before permanent fallbacks and that parameterized rules take priority over default rules within each tier.

**Lazy error message construction via `ErrorMessage`.** `Expect` passes `ErrorMessageImpl` objects—not strings—to `Asserter.isTrue/isFalse`. String assembly (including iterating the full call log in reverse and formatting each call) is deferred inside `ErrorMessageImpl.toString()`, which is only invoked when the assertion condition is false. This avoids unnecessary string work on every passing assertion.

**Exception-based type detection in `Argument.getTypeName()`.** Apex exposes no `Object.getClass()` or general reflection API. The only available technique is to attempt a cast to a known type (`Date`) and parse the `TypeException` message, which embeds the actual runtime type name. This is explicitly documented as relying on an undocumented Salesforce message format.

## Extension Points

**`Argument.Matchable`** — implement this interface to create custom argument matchers. Any instance of `Matchable` passed to `whenCalledWith` or `hasBeenCalledWith` is used as-is; non-`Matchable` values are wrapped in `EqualsMatchable` by `ofList`.

**`MethodSpy.SpyBehavior`** — implement this interface to define custom method behavior beyond returning a fixed value or throwing a fixed exception. Instances are passed to `spy.behaves(impl)` or `spy.whenCalledWith(...).thenBehave(impl)`. The `execute(List<Object> params)` method receives the actual call arguments at invocation time.

**`Mock.StubBuilder`** — implement this interface to control how the underlying stub object is created. The primary use case is cross-namespace stub construction, but it can also be used to inject pre-built stubs or apply post-creation initialization.

## Known Constraints

**5-argument limit on positional overloads.** Apex has no varargs. The `of`, `whenCalledWith`, and `hasBeenCalledWith` methods each provide overloads for 1–5 arguments. For methods with 6 or more parameters, use `Argument.ofList(new List<Object>{...})` and pass the result directly. The three SYNC POINT comments in the source mark where a future 6th overload must be added in all three locations simultaneously.

**Method spying is name-only.** The Apex Stub API does not distinguish between overloaded methods at the interception level — all overloads of the same method name share a single spy. Argument matchers can be used to differentiate behavior by call signature, but the call log aggregates all overloads together.

**`getTypeName()` relies on undocumented behavior.** The type-detection technique in `Argument.getTypeName()` parses the message of a `System.TypeException`. If Salesforce changes the message format, the method will silently return `'Date'` for all non-`Date`, non-`null` values, breaking `Argument.ofType()` matching.
