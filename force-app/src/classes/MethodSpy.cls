/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**
 * MethodSpy represents an apex method spy on which you can register some value to be returned
 *  - spy.returns(value): always return the same value using spy.returns(value)
 *  - spy.whenCalledWith(Arguments args).thenReturn(value)
 *  - spy.whenCalledWith(Arguments args).thenThrow(error)
 *  note: the matching algorithm is based on Matchable specified in the Arguments instanciation (defaulting to equals)
 *  @see Arguments
 *  @see Matchable
 */
@IsTest
global class MethodSpy {
  global final String methodName { get; private set; }
  global final CallLog callLog { get; private set; }
  private final List<ParameterizedMethodSpyCall> methodCalls;
  private final List<OnceHolder> onceHolders;
  private Object returnValue;
  private Boolean configuredGlobalReturn = false;
  private Boolean configuredGlobalThrow = false;
  private Exception exceptionToThrow;

  global MethodSpy(String methodName) {
    this.methodName = methodName;
    this.callLog = new CallLog();
    this.methodCalls = new List<ParameterizedMethodSpyCall>();
    this.onceHolders = new List<OnceHolder>();
  }

  // @deprecated use call(List<Type> paramTypes, List<String> paramNames, List<Object> args) instead
  public Object call(List<Object> args) {
    // Forward compatibility implementation
    List<Type> paramTypes = new List<Type>();
    List<String> paramNames = new List<String>();

    for (Object arg : args) {
      paramTypes.add(Argument.getType(arg)); // Infer type dynamically
      paramNames.add('<unknown_param_name>'); // Impossible to get this information at runtime
    }

    // Warn consumer
    System.Debug(
      LoggingLevel.WARN,
      '[apex-mockery] call to the deprecated MethodSpy.call(List<Object> args) method.\nPlease use MethodSpy.call(List<Type> paramTypes, List<String> paramNames, List<Object> args) instead.'
    );

    // Interoperability
    return this.call(paramTypes, paramNames, args);
  }

  public Object call(List<Type> paramTypes, List<String> paramNames, List<Object> args) {
    this.callLog.add(new MethodCall(args));

    if (!this.isConfigured()) {
      return null;
    }

    for (ParameterizedMethodSpyCall methodCall : this.methodCalls) {
      if (methodCall.matchesOnce(args)) {
        return methodCall.getValueOnce();
      }
    }

    if (!this.onceHolders.isEmpty()) {
      return this.onceHolders.remove(0).getValue();
    }

    for (ParameterizedMethodSpyCall methodCall : this.methodCalls) {
      if (methodCall.matches(args)) {
        return methodCall.getValue();
      }
    }

    if (this.configuredGlobalThrow) {
      throw this.exceptionToThrow;
    }

    if (this.configuredGlobalReturn) {
      return this.returnValue;
    }

    throw new ConfigurationExceptionBuilder().withMethodSpy(this).withCallTypes(paramTypes).withCallParamNames(paramNames).withCallArguments(args).build();
  }

  private Boolean isConfigured() {
    return !this.methodCalls.isEmpty() || this.configuredGlobalReturn || this.configuredGlobalThrow || !this.onceHolders.isEmpty();
  }

  global void returns(Object value) {
    this.configuredGlobalReturn = true;
    this.configuredGlobalThrow = false;
    this.returnValue = value;
  }

  global void throwsException(Exception exceptionToThrow) {
    this.configuredGlobalThrow = true;
    this.configuredGlobalReturn = false;
    this.exceptionToThrow = exceptionToThrow;
  }

  global void returnsOnce(Object value) {
    this.onceHolders.add(new ValueOnceHolder(value));
  }

  global void throwsExceptionOnce(Exception exceptionToThrowOnce) {
    this.onceHolders.add(new ExceptionOnceHolder(exceptionToThrowOnce));
  }

  global MethodSpyCall whenCalledWith() {
    return this.whenCalledWithArguments(Argument.empty());
  }

  global MethodSpyCall whenCalledWith(final Object arg) {
    return this.whenCalledWithArguments((arg instanceof List<Argument.Matchable>) ? (List<Argument.Matchable>) arg : Argument.of(arg));
  }

  global MethodSpyCall whenCalledWith(final Object arg1, final Object arg2) {
    return this.whenCalledWithArguments(Argument.of(arg1, arg2));
  }

  global MethodSpyCall whenCalledWith(final Object arg1, final Object arg2, final Object arg3) {
    return this.whenCalledWithArguments(Argument.of(arg1, arg2, arg3));
  }

  global MethodSpyCall whenCalledWith(final Object arg1, final Object arg2, final Object arg3, final Object arg4) {
    return this.whenCalledWithArguments(Argument.of(arg1, arg2, arg3, arg4));
  }

  global MethodSpyCall whenCalledWith(final Object arg1, final Object arg2, final Object arg3, final Object arg4, final Object arg5) {
    return this.whenCalledWithArguments(Argument.of(arg1, arg2, arg3, arg4, arg5));
  }

  private MethodSpyCall whenCalledWithArguments(final List<Argument.Matchable> args) {
    final ParameterizedMethodSpyCall parameterizedMethodCall = new ParameterizedMethodSpyCall(args);
    this.methodCalls.add(parameterizedMethodCall);
    return parameterizedMethodCall;
  }

  public class CallLog {
    private List<MethodCall> callArguments = new List<MethodCall>();

    private void add(MethodCall callParam) {
      this.callArguments.add(callParam);
    }

    public Boolean isEmpty() {
      return this.callArguments.isEmpty();
    }

    public Integer size() {
      return this.callArguments.size();
    }

    public List<Object> get(final Integer index) {
      return this.callArguments[index].args;
    }

    public List<Object> getLast() {
      return this.size() > 0 ? this.get(this.size() - 1) : null;
    }
  }

  private class MethodCall {
    public List<Object> args { get; private set; }

    public MethodCall(final List<Object> args) {
      this.args = args;
    }
  }

  global interface MethodSpyCall {
    MethodSpyCall thenReturn(Object value);
    MethodSpyCall thenThrow(Exception error);
    MethodSpyCall thenReturnOnce(Object value);
    MethodSpyCall thenThrowOnce(Exception error);
  }

  private class ParameterizedMethodSpyCall implements MethodSpyCall {
    private final List<Argument.Matchable> argsMatchable;
    private final List<OnceHolder> onceHolders;
    private Object value = DEFAULT_MEMORY_ADDRESS; // It is possible to configure to return null or Exception
    private Exception error;

    public ParameterizedMethodSpyCall(final List<Argument.Matchable> argsMatchable) {
      this.argsMatchable = argsMatchable;
      this.onceHolders = new List<OnceHolder>();
    }

    public MethodSpyCall thenReturnOnce(final Object value) {
      this.onceHolders.add(new ValueOnceHolder(value));
      return this;
    }
    public MethodSpyCall thenReturn(final Object value) {
      this.value = value;
      return this;
    }

    public MethodSpyCall thenThrowOnce(final Exception error) {
      this.onceHolders.add(new ExceptionOnceHolder(error));
      return this;
    }

    public MethodSpyCall thenThrow(final Exception error) {
      this.error = error;
      return this;
    }

    public Object getValueOnce() {
      // Check for configuration is done in matchesOnce
      return this.onceHolders.remove(0).getValue();
    }

    public Object getValue() {
      if (this.error != null) {
        throw this.error;
      }
      return this.value !== DEFAULT_MEMORY_ADDRESS ? this.value : null;
    }

    public Boolean matches(final List<Object> callArguments) {
      return Argument.matches(this.argsMatchable, callArguments) && this.isConfigured();
    }

    public Boolean matchesOnce(final List<Object> callArguments) {
      return Argument.matches(this.argsMatchable, callArguments) && this.isConfiguredOnce();
    }

    private Boolean isConfigured() {
      return this.value !== DEFAULT_MEMORY_ADDRESS || this.error != null;
    }

    private Boolean isConfiguredOnce() {
      return !this.onceHolders.isEmpty();
    }

    public override String toString() {
      final List<String> oncesString = new List<String>();
      for (OnceHolder onceHolder : this.onceHolders) {
        oncesString.add(onceHolder.toString());
      }

      return 'whenCalledWith' +
        this.argsMatchable +
        '' +
        String.join(oncesString, '') +
        (this.error != null ? '.thenThrow(' + this.error + ')' : '') +
        (this.value !== DEFAULT_MEMORY_ADDRESS ? '.thenReturn(' + this.value + ')' : '');
    }
  }

  private class ConfigurationExceptionBuilder {
    private MethodSpy spy;
    private List<Type> callTypes;
    private List<String> callParamNames;
    private List<Object> callArguments;

    public ConfigurationExceptionBuilder withMethodSpy(final MethodSpy spy) {
      this.spy = spy;
      return this;
    }

    public ConfigurationExceptionBuilder withCallTypes(final List<Type> callTypes) {
      this.callTypes = callTypes;
      return this;
    }

    public ConfigurationExceptionBuilder withCallParamNames(final List<String> callParamNames) {
      this.callParamNames = callParamNames;
      return this;
    }

    public ConfigurationExceptionBuilder withCallArguments(final List<Object> callArguments) {
      this.callArguments = callArguments;
      return this;
    }

    public ConfigurationException build() {
      List<String> errorMessages = new List<String>();
      for (MethodSpyCall methodCall : this.spy.methodCalls) {
        errorMessages.add(methodCall.toString());
      }

      List<String> callArgumentsAsString = new List<String>();
      for (Integer i = 0; i < this.callArguments.size(); i++) {
        callArgumentsAsString.add(this.callTypes[i] + ' ' + this.callParamNames[i] + '[' + this.callArguments[i] + ']');
      }
      return new ConfigurationException(
        'No stub value found for a call of ' +
          this.spy.methodName +
          '(' +
          String.join(callArgumentsAsString, ', ') +
          ')' +
          '\nHere are the configured stubs:\n\t' +
          String.join(errorMessages, '\n\t')
      );
    }
  }

  private interface OnceHolder {
    Object getValue();
  }

  private class ValueOnceHolder implements OnceHolder {
    private final Object value;

    public ValueOnceHolder(final Object value) {
      this.value = value;
    }
    public Object getValue() {
      return this.value;
    }

    public override String toString() {
      return '.thenReturnOnce(' + this.value + ')';
    }
  }

  private class ExceptionOnceHolder implements OnceHolder {
    public final Exception value;

    public ExceptionOnceHolder(final Exception value) {
      this.value = value;
    }

    public Object getValue() {
      throw this.value;
    }

    public override String toString() {
      return '.thenThrowOnce(' + this.value + ')';
    }
  }

  private static String DEFAULT_MEMORY_ADDRESS = '';

  global class ConfigurationException extends Exception {
  }
}
