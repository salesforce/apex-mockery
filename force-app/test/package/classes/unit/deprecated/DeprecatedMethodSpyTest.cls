/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class DeprecatedMethodSpyTest {
  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingArguments_whenCallingDeprecatedCall_whenCallingTheSpyWithOtherArguments_itThrowsMethodSpyConfigurationException() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Another Param', true).thenReturn('Expected Result');
    sut.whenCalledWith('Expected First Param', false).thenReturn('Another expected Result');
    sut.whenCalledWith('Expected First Param', true).thenReturn('Yet another expected Result');
    try {
      // Act
      sut.call(new List<Object>{ 'Another Param', false });
      Assert.fail('it shoud not reach this line');
    } catch (MethodSpy.ConfigurationException cex) {
      // Assert
      Assert.areEqual(
        'No stub value found for a call of methodName(String <unknown_param_name>[Another Param], Boolean <unknown_param_name>[false])\nHere are the configured stubs:\n\twhenCalledWith(Another Param, true).thenReturn(Expected Result)\n\twhenCalledWith(Expected First Param, false).thenReturn(Another expected Result)\n\twhenCalledWith(Expected First Param, true).thenReturn(Yet another expected Result)',
        cex.getMessage()
      );
    }
  }
}
