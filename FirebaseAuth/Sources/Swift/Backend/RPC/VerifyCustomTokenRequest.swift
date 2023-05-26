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

/** @var kVerifyCustomTokenEndpoint
    @brief The "verifyPassword" endpoint.
 */
private let kVerifyCustomTokenEndpoint = "verifyCustomToken"

/** @var kTokenKey
    @brief The key for the "token" value in the request.
 */
private let kTokenKey = "token"

/** @var kReturnSecureTokenKey
    @brief The key for the "returnSecureToken" value in the request.
 */
private let kReturnSecureTokenKey = "returnSecureToken"

/** @var kTenantIDKey
    @brief The key for the tenant id value in the request.
 */
private let kTenantIDKey = "tenantId"

public class VerifyCustomTokenRequest: IdentityToolkitRequest, AuthRPCRequest {
  public let token: String

  public var returnSecureToken: Bool

  /** @var response
      @brief The corresponding response for this request
   */
  public var response: VerifyCustomTokenResponse = VerifyCustomTokenResponse()

  public init(token: String, requestConfiguration: AuthRequestConfiguration) {
    self.token = token
    returnSecureToken = true
    super.init(endpoint: kVerifyCustomTokenEndpoint, requestConfiguration: requestConfiguration)
  }

  public func unencodedHTTPRequestBody() throws -> [String: AnyHashable] {
    var postBody: [String: AnyHashable] = [
      kTokenKey: token,
    ]
    if returnSecureToken {
      postBody[kReturnSecureTokenKey] = true
    }
    if let tenantID = tenantID {
      postBody[kTenantIDKey] = tenantID
    }
    return postBody
  }
}
