/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
public class Matcher {
  private Matcher() {
  }

  public static ArgumentMatcher any() {
    return new AnyMatcher();
  }

  public static ArgumentMatcher equals(final Object callArgument) {
    return new EqualsMatcher(callArgument);
  }

  public static ArgumentMatcher jsonEquals(final Object callArgument) {
    return new JSONMatcher(callArgument);
  }

  public static ArgumentMatcher ofType(final String matchingType) {
    return new TypeMatcher(matchingType);
  }

  public static ArgumentMatcher ofType(final Schema.SObjectType callArgument) {
    return new TypeMatcher(callArgument);
  }

  public static ArgumentMatcher ofType(final Type callArgument) {
    return new TypeMatcher(callArgument);
  }

  private class AnyMatcher implements ArgumentMatcher {
    public Boolean matches(final Object callArgument) {
      return true;
    }

    override public String toString() {
      return 'any';
    }
  }

  private class EqualsMatcher implements ArgumentMatcher {
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

  private class JSONMatcher implements ArgumentMatcher {
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

  private class TypeMatcher implements ArgumentMatcher {
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
        String message = te.getMessage()
          .substringAfter('Invalid conversion from runtime type ');
        result = message.substringBefore(' to Date');
      }
      return result;
    }

    override public String toString() {
      return callArgumentToMatch + '.Type';
    }
  }
}
