/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**
 * Matcher offers publis static methods to build out-of-the-box matchers to be used with Assertions
 *    - Argument.any()
 *    - Argument.equals(Object object)
 *    - Argument.jsonEquals(Object object)
 *    - Argument.ofType(String typeName)
 *    - Argument.ofType(Type type)
 *    - Argument.ofType(Schema.SObjectType sobjectType)
 */
@IsTest
global class Argument {
  global interface Matcher {
    Boolean matches(Object callArgument);
  }

  global class ConfigurationException extends Exception {
  }

  private Argument() {
  }

  global static Argument.Matcher any() {
    return new AnyMatcher();
  }

  global static Argument.Matcher equals(final Object callArgument) {
    return new EqualsMatcher(callArgument);
  }

  global static Argument.Matcher jsonEquals(final Object callArgument) {
    return new JSONMatcher(callArgument);
  }

  global static Argument.Matcher ofType(final String matchingType) {
    return new TypeMatcher(matchingType);
  }

  global static Argument.Matcher ofType(final Schema.SObjectType callArgument) {
    return new TypeMatcher(callArgument);
  }

  global static Argument.Matcher ofType(final Type callArgument) {
    return new TypeMatcher(callArgument);
  }

  private class AnyMatcher implements Argument.Matcher {
    public Boolean matches(final Object callArgument) {
      return true;
    }

    override public String toString() {
      return 'any';
    }
  }

  private class EqualsMatcher implements Argument.Matcher {
    private Object callArgumentToMatch;

    public EqualsMatcher(final Object callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch;
    }

    public Boolean matches(final Object callArgument) {
      return callArgument == this.callArgumentToMatch;
    }

    override public String toString() {
      return callArgumentToMatch + '';
    }
  }

  private class JSONMatcher implements Argument.Matcher {
    private Object callArgumentToMatch;
    private String jsonValue;

    public JSONMatcher(final Object callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch;
      this.jsonValue = JSON.serialize(callArgumentToMatch);
    }

    public boolean matches(final Object callArgument) {
      return this.jsonValue == JSON.serialize(callArgument);
    }

    override public String toString() {
      return 'json(' + callArgumentToMatch + ')';
    }
  }

  private class TypeMatcher implements Argument.Matcher {
    private String callArgumentToMatch;

    public TypeMatcher(final Schema.SObjectType callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch.getDescribe().getName();
    }

    public TypeMatcher(final String callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch;
    }

    public TypeMatcher(final Type callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch.getName();
    }

    public boolean matches(final Object callArgument) {
      String typeName = this.getType(callArgument);
      if (this.callArgumentToMatch == typeName) {
        return true;
      }

      Type actualType = Type.forName(typeName);
      Type expectedType = Type.forName(this.callArgumentToMatch);
      if (expectedType != null && actualType != null) {
        return expectedType.isAssignableFrom(actualType);
      }
      return false;
    }

    private String getType(final Object callArgument) {
      String result = 'Date';
      try {
        Date typeCheck = (Date) callArgument;
      } catch (System.TypeException te) {
        String message = te.getMessage().substringAfter('Invalid conversion from runtime type ');
        result = message.substringBefore(' to Date');
      }
      return result;
    }

    override public String toString() {
      return callArgumentToMatch + '.Type';
    }
  }
}
