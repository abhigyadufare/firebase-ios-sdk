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

class GetProjectConfigTests: RPCBaseTests {
  /** @var kGetProjectConfigEndPoint
      @brief The "getProjectConfig" endpoint.
   */
  let kGetProjectConfigEndPoint = "getProjectConfig"

  /** @var kExpectedAPIURL
      @brief The expected URL for the test calls.
   */
  let kExpectedAPIURL =
    "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getProjectConfig?key=APIKey"

  func testGetProjectConfig() throws {
    let kMissingAPIKeyErrorMessage = "MISSING_API_KEY"
    try checkRequest(
      request: makeGetProjectConfigRequest(),
      expected: kExpectedAPIURL,
      key: kTestAPIKey,
      value: kGetProjectConfigEndPoint,
      checkPostBody: true
    )
    // This test simulates a missing API key error. Since the API key is provided to the backend
    // from the auth library this error should map to an internal error.
    try checkBackendError(
      request: makeGetProjectConfigRequest(),
      message: kMissingAPIKeyErrorMessage,
      errorCode: AuthErrorCode.internalError
    )
  }

  /** @fn testSuccessFulGetProjectConfigRequest
      @brief This test checks for a successful response
   */
  func testSuccessfulGetProjectConfigRequest() throws {
    let kTestProjectID = "21141651616"
    let kTestDomain1 = "localhost"
    let kTestDomain2 = "example.firebaseapp.com"
    var callbackInvoked = false
    var rpcResponse: GetProjectConfigResponse?
    var rpcError: NSError?

    AuthBackend.post(with: makeGetProjectConfigRequest()) { response, error in
      callbackInvoked = true
      rpcResponse = response
      rpcError = error as? NSError
    }

    _ = try rpcIssuer?.respond(withJSON: ["projectId": kTestProjectID,
                                          "authorizedDomains": [kTestDomain1, kTestDomain2]])

    XCTAssert(callbackInvoked)
    XCTAssertNil(rpcError)
    XCTAssertEqual(rpcResponse?.projectID, kTestProjectID)
    XCTAssertEqual(rpcResponse?.authorizedDomains?.first, kTestDomain1)
    XCTAssertEqual(rpcResponse?.authorizedDomains?[1], kTestDomain2)
  }

  private func makeGetProjectConfigRequest() -> GetProjectConfigRequest {
    return GetProjectConfigRequest(requestConfiguration: makeRequestConfiguration())
  }
}
