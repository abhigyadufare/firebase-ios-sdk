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

private let kStartMFASignInEndPoint = "accounts/mfaSignIn:start"

/** @var kTenantIDKey
    @brief The key for the tenant id value in the request.
 */
private let kTenantIDKey = "tenantId"

public class StartMFASignInRequest: IdentityToolkitRequest, AuthRPCRequest {
  var MFAPendingCredential: String?
  var MFAEnrollmentID: String?
  var signInInfo: AuthProtoStartMFAPhoneRequestInfo?

  /** @var response
      @brief The corresponding response for this request
   */
  public var response: StartMFASignInResponse = StartMFASignInResponse()

  init(MFAPendingCredential: String?, MFAEnrollmentID: String?,
       signInInfo: AuthProtoStartMFAPhoneRequestInfo?,
       requestConfiguration: AuthRequestConfiguration) {
    self.MFAPendingCredential = MFAPendingCredential
    self.MFAEnrollmentID = MFAEnrollmentID
    self.signInInfo = signInInfo
    super.init(
      endpoint: kStartMFASignInEndPoint,
      requestConfiguration: requestConfiguration,
      useIdentityPlatform: true,
      useStaging: false
    )
  }

  public func unencodedHTTPRequestBody() throws -> [String: AnyHashable] {
    var body: [String: AnyHashable] = [:]
    if let MFAPendingCredential = MFAPendingCredential {
      body["mfaPendingCredential"] = MFAPendingCredential
    }
    if let MFAEnrollmentID = MFAEnrollmentID {
      body["mfaEnrollmentId"] = MFAEnrollmentID
    }
    if let signInInfo = signInInfo {
      body["phoneSignInInfo"] = signInInfo.dictionary
    }
    if let tenantID = tenantID {
      body[kTenantIDKey] = tenantID
    }
    return body
  }
}
