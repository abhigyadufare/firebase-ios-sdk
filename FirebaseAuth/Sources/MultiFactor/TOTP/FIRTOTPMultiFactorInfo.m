/*
 * Copyright 2023 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <TargetConditionals.h>
#if TARGET_OS_IOS

#import "FirebaseAuth/Sources/Public/FirebaseAuth/FIRMultiFactorInfo.h"
#import "FirebaseAuth/Sources/Public/FirebaseAuth/FIRTOTPMultiFactorInfo.h"

#import "FirebaseAuth/Sources/Backend/RPC/Proto/FIRAuthProtoMFAEnrollment.h"
#import "FirebaseAuth/Sources/MultiFactor/FIRMultiFactorInfo+Internal.h"

extern NSString *const FIRTOTPMultiFactorID;

@implementation FIRTOTPMultiFactorInfo

- (instancetype)initWithProto:(FIRAuthProtoMFAEnrollment *)proto {
  self = [super initWithProto:proto];
  if (self) {
    _factorID = FIRTOTPMultiFactorID;
    _totpInfo = proto.totpInfo;
  }
  return self;
}

@end

#endif