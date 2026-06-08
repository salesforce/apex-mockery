/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**
 * Matchable offers public static methods to build out-of-the-box matchers to be used with Expect
 *    - Argument.any()
 *    - Argument.equals(Object object)
 *    - Argument.jsonEquals(Object object)
 *    - Argument.ofType(String typeName)
 *    - Argument.ofType(Type type)
 *    - Argument.ofType(Schema.SObjectType sobjectType)
 */
@IsTest
@SuppressWarnings('PMD.EmptyStatementBlock, PMD.AvoidGlobalModifier')
global class Argument {
  global interface Matchable {
    Boolean matches(Object callArgument);
  }

  private Argument() {
  }

  public static boolean matches(final List<Argument.Matchable> matchableArguments, final List<Object> callArguments) {
    if (matchableArguments == null || callArguments == null) {
      // If both equals null then return true
      return matchableArguments == callArguments;
    }

    if (matchableArguments.size() != callArguments.size()) {
      return false;
    }

    for (Integer i = 0; i < matchableArguments.size(); ++i) {
      if (!matchableArguments[i].matches(callArguments[i])) {
        return false;
      }
    }

    return true;
  }

  global static List<Argument.Matchable> empty() {
    return new List<Argument.Matchable>();
  }

  // SYNC POINT: The 1-5 argument overloads below are duplicated in:
  //   - MethodSpy.whenCalledWith()  (MethodSpy.cls)
  //   - Expect.hasBeenCalledWith()  (Expect.cls)
  // If you add a 6th overload here, add it in the other two locations too.
  global static List<Argument.Matchable> of(final Object arg) {
    return Argument.ofList(new List<Object>{ arg });
  }

  global static List<Argument.Matchable> of(final Object arg1, final Object arg2) {
    return Argument.ofList(new List<Object>{ arg1, arg2 });
  }

  global static List<Argument.Matchable> of(final Object arg1, final Object arg2, final Object arg3) {
    return Argument.ofList(new List<Object>{ arg1, arg2, arg3 });
  }

  global static List<Argument.Matchable> of(final Object arg1, final Object arg2, final Object arg3, final Object arg4) {
    return Argument.ofList(new List<Object>{ arg1, arg2, arg3, arg4 });
  }

  global static List<Argument.Matchable> of(final Object arg1, final Object arg2, final Object arg3, final Object arg4, final Object arg5) {
    return Argument.ofList(new List<Object>{ arg1, arg2, arg3, arg4, arg5 });
  }

  global static List<Argument.Matchable> ofList(final List<Object> listOfArgs) {
    final List<Argument.Matchable> listOfMatchableArgs = Argument.empty();
    if (listOfArgs == null) {
      return listOfMatchableArgs;
    }
    for (Object callArgument : listOfArgs) {
      if (callArgument instanceof Argument.Matchable) {
        listOfMatchableArgs.add((Argument.Matchable) callArgument);
      } else {
        listOfMatchableArgs.add(Argument.equals(callArgument));
      }
    }
    return listOfMatchableArgs;
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

    public override String toString() {
      return 'any';
    }

    public Boolean equals(Object obj) {
      return obj != null && obj instanceof AnyMatchable;
    }
  }

  private class EqualsMatchable implements Argument.Matchable {
    private Object callArgumentToMatch;

    public EqualsMatchable(final Object callArgumentToMatch) {
      this.callArgumentToMatch = callArgumentToMatch;
    }

    public Boolean matches(final Object callArgument) {
      if (this.callArgumentToMatch == null) {
        return callArgument == null;
      }

      // case-sensitive check for string
      if (this.callArgumentToMatch instanceof String) {
        return this.callArgumentToMatch.equals(callArgument);
      }

      // native platform equality check for anything else
      return this.callArgumentToMatch == callArgument;
    }

    public override String toString() {
      return String.valueOf(this.callArgumentToMatch);
    }

    public Boolean equals(Object obj) {
      if (obj == null || !(obj instanceof EqualsMatchable)) {
        return false;
      }
      EqualsMatchable other = (EqualsMatchable) obj;
      return this.matches(other.callArgumentToMatch);
    }
  }

  private class JSONMatchable implements Argument.Matchable {
    private String jsonValue;

    public JSONMatchable(final Object callArgumentToMatch) {
      // Serialized once at configuration time — the expected value never changes.
      this.jsonValue = JSON.serialize(callArgumentToMatch);
    }

    public Boolean matches(final Object callArgument) {
      // The call argument must be serialized fresh each time — it varies per invocation.
      return String.valueOf(this.jsonValue).equals(String.valueOf(JSON.serialize(callArgument)));
    }

    override public String toString() {
      return 'json(' + this.jsonValue + ')';
    }

    public Boolean equals(Object obj) {
      if (obj == null || !(obj instanceof JSONMatchable)) {
        return false;
      }
      JSONMatchable other = (JSONMatchable) obj;
      return this.jsonValue.equals(other.jsonValue);
    }
  }

  private class TypeMatchable implements Argument.Matchable {
    private String typeNameToMatch;

    public TypeMatchable(final Schema.SObjectType callArgumentToMatch) {
      this.typeNameToMatch = callArgumentToMatch.getDescribe().getName();
    }

    public TypeMatchable(final String callArgumentToMatch) {
      this.typeNameToMatch = callArgumentToMatch;
    }

    public TypeMatchable(final Type callArgumentToMatch) {
      this.typeNameToMatch = callArgumentToMatch.getName();
    }

    public Boolean matches(final Object callArgument) {
      String typeName = Argument.getTypeName(callArgument);
      if (typeName == null) {
        return false;
      }
      if (this.typeNameToMatch == typeName) {
        return true;
      }

      Type actualType = Type.forName(typeName);
      Type expectedType = Type.forName(this.typeNameToMatch);
      if (expectedType != null && actualType != null) {
        return expectedType.isAssignableFrom(actualType);
      }
      return false;
    }

    override public String toString() {
      return this.typeNameToMatch + '.Type';
    }

    public Boolean equals(Object obj) {
      if (obj == null || !(obj instanceof TypeMatchable)) {
        return false;
      }
      TypeMatchable other = (TypeMatchable) obj;
      return this.typeNameToMatch == other.typeNameToMatch;
    }
  }

  private static String getTypeName(final Object callArgument) {
    if (callArgument == null) {
      return null;
    }
    // Apex does not expose Object.getClass() or any reflection API to get
    // the runtime type of an arbitrary Object. The only available technique
    // is to attempt a cast to a known type and parse the resulting
    // TypeException message, which Salesforce embeds the actual type name in:
    //   "Invalid conversion from runtime type <ActualType> to Date"
    // This relies on an undocumented message format. If Salesforce changes it,
    // this method will silently return 'Date' for all non-Date, non-null types.
    String result = 'Date';
    try {
      Date typeCheck = (Date) callArgument;
    } catch (System.TypeException te) {
      String message = te.getMessage().substringAfter('Invalid conversion from runtime type ');
      result = message.substringBefore(' to Date');
    }
    return result;
  }

  public static Type getType(final Object callArgument) {
    final String typeName = getTypeName(callArgument);
    if (typeName == null) {
      return null;
    }
    return Type.forName(typeName);
  }

  global static Boolean areListsEqual(final List<Argument.Matchable> list1, final List<Argument.Matchable> list2) {
    if (list1 == null || list2 == null) {
      return list1 == list2;
    }

    final Integer size = list1.size();
    if (size != list2.size()) {
      return false;
    }

    for (Integer i = 0; i < size; ++i) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }
}
