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
  private final BehaviorManagement behaviorManager;

  global MethodSpy(String methodName) {
    this.methodName = methodName;
    this.callLog = new CallLog();
    this.methodCalls = new List<ParameterizedMethodSpyCall>();
    this.behaviorManager = new BehaviorManagement();
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
        return methodCall.getConfiguredBehavior();
      }
    }

    if (this.behaviorManager.hasConfiguredOnceBehavior()) {
      return this.behaviorManager.getConfiguredBehavior();
    }

    for (ParameterizedMethodSpyCall methodCall : this.methodCalls) {
      if (methodCall.matches(args)) {
        return methodCall.getConfiguredBehavior();
      }
    }

    if (this.behaviorManager.hasConfiguredGeneralBehavior()) {
      return this.behaviorManager.getConfiguredBehavior();
    }

    throw new ConfigurationExceptionBuilder().withMethodSpy(this).withCallTypes(paramTypes).withCallParamNames(paramNames).withCallArguments(args).build();
  }

  private Boolean isConfigured() {
    return this.methodCalls.size() > 0 || this.behaviorManager.hasConfiguredOnceBehavior() || this.behaviorManager.hasConfiguredGeneralBehavior();
  }

  global void returns(Object value) {
    this.behaviorManager.setGeneralBehavior(new ConfiguredValueBehavior(value));
  }

  global void throwsException(Exception exceptionToThrow) {
    this.behaviorManager.setGeneralBehavior(new ConfiguredExceptionBehavior(exceptionToThrow));
  }

  global void returnsOnce(Object value) {
    this.behaviorManager.queueOnceBehavior(new ConfiguredValueBehaviorOnce(value));
  }

  global void throwsExceptionOnce(Exception exceptionToThrowOnce) {
    this.behaviorManager.queueOnceBehavior(new ConfiguredExceptionBehaviorOnce(exceptionToThrowOnce));
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
    private final BehaviorManagement behaviorManager;

    public ParameterizedMethodSpyCall(final List<Argument.Matchable> argsMatchable) {
      this.argsMatchable = argsMatchable;
      this.behaviorManager = new BehaviorManagement();
    }

    public MethodSpyCall thenReturn(final Object value) {
      this.behaviorManager.setGeneralBehavior(new ConfiguredValueBehavior(value));
      return this;
    }

    public MethodSpyCall thenThrow(final Exception exceptionToThrow) {
      this.behaviorManager.setGeneralBehavior(new ConfiguredExceptionBehavior(exceptionToThrow));
      return this;
    }

    public MethodSpyCall thenReturnOnce(final Object value) {
      this.behaviorManager.queueOnceBehavior(new ConfiguredValueBehaviorOnce(value));
      return this;
    }

    public MethodSpyCall thenThrowOnce(final Exception exceptionToThrowOnce) {
      this.behaviorManager.queueOnceBehavior(new ConfiguredExceptionBehaviorOnce(exceptionToThrowOnce));
      return this;
    }

    public Object getConfiguredBehavior() {
      return this.behaviorManager.getConfiguredBehavior();
    }

    public Boolean matches(final List<Object> callArguments) {
      return this.behaviorManager.hasConfiguredGeneralBehavior() && Argument.matches(this.argsMatchable, callArguments);
    }

    public Boolean matchesOnce(final List<Object> callArguments) {
      return this.behaviorManager.hasConfiguredOnceBehavior() && Argument.matches(this.argsMatchable, callArguments);
    }

    public override String toString() {
      return 'whenCalledWith' + this.argsMatchable + this.behaviorManager;
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

  private class BehaviorManagement {
    private final List<ConfiguredBehavior> onceBehaviors = new List<ConfiguredBehavior>();
    private ConfiguredBehavior generalBehavior;

    public void queueOnceBehavior(final ConfiguredBehavior configuredBehavior) {
      this.onceBehaviors.add(configuredBehavior);
    }

    public void setGeneralBehavior(final ConfiguredBehavior configuredBehavior) {
      this.generalBehavior = configuredBehavior;
    }

    public Boolean hasConfiguredOnceBehavior() {
      return this.onceBehaviors.size() > 0;
    }

    public Boolean hasConfiguredGeneralBehavior() {
      return this.generalBehavior != null;
    }

    public Object getConfiguredBehavior() {
      final ConfiguredBehavior behaviorToApply = this.hasConfiguredOnceBehavior() ? this.onceBehaviors.remove(0) : this.generalBehavior;
      return behaviorToApply?.getBehavior();
    }

    public override String toString() {
      final List<String> oncesString = new List<String>();
      for (ConfiguredBehavior configuredBehaviorOnce : this.onceBehaviors) {
        oncesString.add(configuredBehaviorOnce.toString());
      }
      return String.join(oncesString, '') + (this.generalBehavior != null ? this.generalBehavior.toString() : '');
    }
  }

  private abstract class ConfiguredBehavior {
    public final Object value;
    abstract Object getBehavior();

    public ConfiguredBehavior(final Object value) {
      this.value = value;
    }
  }

  private virtual class ConfiguredValueBehavior extends ConfiguredBehavior {
    public ConfiguredValueBehavior(final Object value) {
      super(value);
    }

    public override Object getBehavior() {
      return this.value;
    }

    public override virtual String toString() {
      return '.thenReturn(' + this.value + ')';
    }
  }

  private class ConfiguredValueBehaviorOnce extends ConfiguredValueBehavior {
    public ConfiguredValueBehaviorOnce(final Object value) {
      super(value);
    }
    public override String toString() {
      return '.thenReturnOnce(' + this.value + ')';
    }
  }

  private virtual class ConfiguredExceptionBehavior extends ConfiguredBehavior {
    public ConfiguredExceptionBehavior(final Exception value) {
      super(value);
    }

    public override Object getBehavior() {
      throw (Exception) this.value;
    }

    public override virtual String toString() {
      return '.thenThrow(' + this.value + ')';
    }
  }

  private class ConfiguredExceptionBehaviorOnce extends ConfiguredExceptionBehavior {
    public ConfiguredExceptionBehaviorOnce(final Exception value) {
      super(value);
    }

    public override String toString() {
      return '.thenThrowOnce(' + this.value + ')';
    }
  }

  global class ConfigurationException extends Exception {
  }
}
