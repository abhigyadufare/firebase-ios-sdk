// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import XCTest

@testable import FirebaseAuth

class VerifyCustomTokenTests: RPCBaseTests {
  private let kTestTokenKey = "token"
  private let kTestToken = "test token"
  private let kReturnSecureTokenKey = "returnSecureToken"
  private let kExpectedAPIURL =
    "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=APIKey"

  /** @fn testVerifyCustomTokenRequest
      @brief Tests the verify custom token request.
   */
  func testVerifyCustomTokenRequest() throws {
    let request = makeVerifyCustomTokenRequest()
    request.returnSecureToken = false
    let issuer = try checkRequest(
      request: request,
      expected: kExpectedAPIURL,
      key: kTestTokenKey,
      value: kTestToken
    )
    let requestDictionary = try XCTUnwrap(issuer.decodedRequest as? [String: AnyHashable])
    XCTAssertNil(requestDictionary[kReturnSecureTokenKey])
  }

  /** @fn testVerifyCustomTokenRequestOptionalFields
      @brief Tests the verify custom token request with optional fields.
   */
  func testVerifyCustomTokenRequestOptionalFields() throws {
    let request = makeVerifyCustomTokenRequest()
    let issuer = try checkRequest(
      request: request,
      expected: kExpectedAPIURL,
      key: kTestTokenKey,
      value: kTestToken
    )
    let requestDictionary = try XCTUnwrap(issuer.decodedRequest as? [String: AnyHashable])
    XCTAssertTrue(try XCTUnwrap(requestDictionary[kReturnSecureTokenKey] as? Bool))
  }

  func testVerifyCustomTokenRequestErrors() throws {
    let kInvalidCustomTokenErrorMessage = "INVALID_CUSTOM_TOKEN"
    let kInvalidCustomTokenServerErrorMessage = "INVALID_CUSTOM_TOKEN : Detailed Error"
    let kInvalidCustomTokenEmptyServerErrorMessage = "INVALID_CUSTOM_TOKEN :"
    let kInvalidCustomTokenErrorDetails = "Detailed Error"
    let kCredentialMismatchErrorMessage = "CREDENTIAL_MISMATCH:"

    try checkBackendError(
      request: makeVerifyCustomTokenRequest(),
      message: kInvalidCustomTokenErrorMessage,
      errorCode: AuthErrorCode.invalidCustomToken
    )
    try checkBackendError(
      request: makeVerifyCustomTokenRequest(),
      message: kInvalidCustomTokenServerErrorMessage,
      errorCode: AuthErrorCode.invalidCustomToken,
      checkLocalizedDescription: kInvalidCustomTokenErrorDetails
    )
    try checkBackendError(
      request: makeVerifyCustomTokenRequest(),
      message: kInvalidCustomTokenEmptyServerErrorMessage,
      errorCode: AuthErrorCode.invalidCustomToken,
      checkLocalizedDescription: ""
    )
    try checkBackendError(
      request: makeVerifyCustomTokenRequest(),
      message: kCredentialMismatchErrorMessage,
      errorCode: AuthErrorCode.customTokenMismatch
    )
  }

  /** @fn testSuccessfulVerifyCustomTokenResponse
      @brief This test simulates a successful verify CustomToken flow.
   */
  func testSuccessfulVerifyCustomTokenResponse() throws {
    let kIDTokenKey = "idToken"
    let kTestIDToken = "ID_TOKEN"
    let kTestExpiresIn = "12345"
    let kTestRefreshToken = "REFRESH_TOKEN"
    let kExpiresInKey = "expiresIn"
    let kRefreshTokenKey = "refreshToken"
    let kIsNewUserKey = "isNewUser"
    var callbackInvoked = false
    var rpcResponse: VerifyCustomTokenResponse?
    var rpcError: NSError?

    AuthBackend.post(with: makeVerifyCustomTokenRequest()) { response, error in
      callbackInvoked = true
      rpcResponse = response
      rpcError = error as? NSError
    }

    _ = try rpcIssuer?.respond(withJSON: [
      kIDTokenKey: kTestIDToken,
      kExpiresInKey: kTestExpiresIn,
      kRefreshTokenKey: kTestRefreshToken,
      kIsNewUserKey: true,
    ])

    XCTAssert(callbackInvoked)
    XCTAssertNil(rpcError)
    XCTAssertEqual(rpcResponse?.idToken, kTestIDToken)
    XCTAssertEqual(rpcResponse?.refreshToken, kTestRefreshToken)
    let expiresIn = try XCTUnwrap(rpcResponse?.approximateExpirationDate?.timeIntervalSinceNow)
    XCTAssertEqual(expiresIn, 12345, accuracy: 0.1)
    XCTAssertTrue(try XCTUnwrap(rpcResponse?.isNewUser))
  }

  private func makeVerifyCustomTokenRequest() -> VerifyCustomTokenRequest {
    return VerifyCustomTokenRequest(token: kTestToken,
                                    requestConfiguration: makeRequestConfiguration())
  }
}
