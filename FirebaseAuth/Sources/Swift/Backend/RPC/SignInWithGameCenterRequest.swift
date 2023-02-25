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

private let kSignInWithGameCenterEndPoint = "signInWithGameCenter"

/** @class FIRSignInWithGameCenterRequest
    @brief The request to sign in with Game Center account
 */
@objc(FIRSignInWithGameCenterRequest)
public class SignInWithGameCenterRequest: IdentityToolkitRequest,
  AuthRPCRequest {
  /** @property playerID
      @brief The playerID to verify.
   */
  @objc public var playerID: String

  /** @property teamPlayerID
      @brief The team player ID of the Game Center local player.
   */
  @objc public var teamPlayerID: String?

  /** @property gamePlayerID
      @brief The game player ID of the Game Center local player.
   */
  @objc public var gamePlayerID: String?

  /** @property publicKeyURL
      @brief The URL for the public encryption key.
   */
  @objc public var publicKeyURL: URL

  /** @property signature
      @brief The verification signature data generated by Game Center.
   */
  @objc public var signature: Data

  /** @property salt
      @brief A random strong used to compute the hash and keep it randomized.
   */
  @objc public var salt: Data

  /** @property timestamp
      @brief The date and time that the signature was created.
   */
  @objc public var timestamp: UInt64

  /** @property accessToken
      @brief The STS Access Token for the authenticated user, only needed for linking the user.
   */
  @objc public var accessToken: String?

  /** @property displayName
      @brief The display name of the local Game Center player.
   */
  @objc public var displayName: String?

  /** @var response
      @brief The corresponding response for this request
   */
  @objc public var response: AuthRPCResponse = SignInWithGameCenterResponse()

  /** @fn initWithPlayerID:publicKeyURL:signature:salt:timestamp:displayName:requestConfiguration:
      @brief Designated initializer.
      @param playerID The ID of the Game Center player.
      @param teamPlayerID The teamPlayerID of the Game Center local player.
      @param gamePlayerID The gamePlayerID of the Game Center local player.
      @param publicKeyURL The URL for the public encryption key.
      @param signature The verification signature generated.
      @param salt A random string used to compute the hash and keep it randomized.
      @param timestamp The date and time that the signature was created.
      @param displayName The display name of the Game Center player.
   */
  @objc public init(playerID: String, teamPlayerID: String?, gamePlayerID: String?,
                    publicKeyURL: URL,
                    signature: Data, salt: Data,
                    timestamp: UInt64, displayName: String?,
                    requestConfiguration: AuthRequestConfiguration) {
    self.playerID = playerID
    self.teamPlayerID = teamPlayerID
    self.gamePlayerID = gamePlayerID
    self.publicKeyURL = publicKeyURL
    self.signature = signature
    self.salt = salt
    self.timestamp = timestamp
    self.displayName = displayName
    super.init(
      endpoint: kSignInWithGameCenterEndPoint,
      requestConfiguration: requestConfiguration
    )
  }

  public func unencodedHTTPRequestBody() throws -> Any {
    var postBody: [String: Any] = [
      "playerId": playerID,
      "publicKeyUrl": publicKeyURL.absoluteString,
      "signature": signature.base64URLEncodedString(),
      "salt": salt.base64URLEncodedString(),
    ]
    if timestamp != 0 {
      postBody["timestamp"] = timestamp
    }
    if let teamPlayerID {
      postBody["teamPlayerId"] = teamPlayerID
    }
    if let gamePlayerID {
      postBody["gamePlayerId"] = gamePlayerID
    }
    if let accessToken {
      postBody["idToken"] = accessToken
    }
    if let displayName {
      postBody["displayName"] = displayName
    }
    return postBody
  }
}