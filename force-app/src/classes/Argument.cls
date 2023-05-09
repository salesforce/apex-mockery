/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**
 * Matchable offers publis static methods to build out-of-the-box matchers to be used with Expect
 *    - Argument.any()
 *    - Argument.equals(Object object)
 *    - Argument.jsonEquals(Object object)
 *    - Argument.ofType(String typeName)
 *    - Argument.ofType(Type type)
 *    - Argument.ofType(Schema.SObjectType sobjectType)
 */
@IsTest
@SuppressWarnings('PMD.EmptyStatementBlock')
global class Argument {
  global interface Matchable {
    Boolean matches(Object callArgument);
  }

  global class ConfigurationException extends Exception {
  }

  private Argument() {
  }

  global static Argument.Matchable any() {
    return new AnyMatchable();
  }

  global static Argument.Matchable equals(final Object callArgument) {
    return new EqualsMatchable(callArgument);
  }

  global static Argument.Matchable jsonEquals(final Object callArgument) {
    return new JSONMatchable(callArgument);
  }

  global static Argument.Matchable ofType(final String matchingType) {
    return new TypeMatchable(matchingType);
  }

  global static Argument.Matchable ofType(final Schema.SObjectType callArgument) {
    return new TypeMatchable(callArgument);
  }

  global static Argument.Matchable ofType(final Type callArgument) {
    return new TypeMatchable(callArgument);
  }

  private class AnyMatchable implements Argument.Matchable {
    public Boolean matches(final Object callArgument) {
      return true;
    }

    override public String toString() {
      return 'any';
    }
  }

  private class EqualsMatchable implements Argument.Matchable {
    private Object callArgumentToMatch;

    public EqualsMatchable(final Object callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch;
    }

    public Boolean matches(final Object callArgument) {
      return callArgument == this.callArgumentToMatch;
    }

    override public String toString() {
      return callArgumentToMatch + '';
    }
  }

  private class JSONMatchable implements Argument.Matchable {
    private Object callArgumentToMatch;
    private String jsonValue;

    public JSONMatchable(final Object callArgumentToMatch) {
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

  private class TypeMatchable implements Argument.Matchable {
    private String callArgumentToMatch;

    public TypeMatchable(final Schema.SObjectType callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch.getDescribe().getName();
    }

    public TypeMatchable(final String callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch;
    }

    public TypeMatchable(final Type callArgumentToMatch) {
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
