//
//  CustomURLProtocol.m
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import "CustomURLProtocol.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"

typedef NS_ENUM(NSInteger, FTHTTPCodesNo) {
    // Informational
    FTHTTPCodesNo1XXInformationalUnknown = 1,
    FTHTTPCodesNo100Continue = 100,
    FTHTTPCodesNo101SwitchingProtocols = 101,
    FTHTTPCodesNo102Processing = 102,
    
    // Success
    FTHTTPCodesNo2XXSuccessUnknown = 2,
    FTHTTPCodesNo200OK = 200,
    FTHTTPCodesNo201Created = 201,
    FTHTTPCodesNo202Accepted = 202,
    FTHTTPCodesNo203NonAuthoritativeInformation = 203,
    FTHTTPCodesNo204NoContent = 204,
    FTHTTPCodesNo205ResetContent = 205,
    FTHTTPCodesNo206PartialContent = 206,
    FTHTTPCodesNo207MultiStatus = 207,
    FTHTTPCodesNo208AlreadyReported = 208,
    FTHTTPCodesNo209IMUsed = 209,
    
    // Redirection
    FTHTTPCodesNo3XXSuccessUnknown = 3,
    FTHTTPCodesNo300MultipleChoices = 300,
    FTHTTPCodesNo301MovedPermanently = 301,
    FTHTTPCodesNo302Found = 302,
    FTHTTPCodesNo303SeeOther = 303,
    FTHTTPCodesNo304NotModified = 304,
    FTHTTPCodesNo305UseProxy = 305,
    FTHTTPCodesNo306SwitchProxy = 306,
    FTHTTPCodesNo307TemporaryRedirect = 307,
    FTHTTPCodesNo308PermanentRedirect = 308,
    
    // Client error
    FTHTTPCodesNo4XXSuccessUnknown = 4,
    FTHTTPCodesNo400BadRequest = 400,
    FTHTTPCodesNo401Unauthorised = 401,
    FTHTTPCodesNo402PaymentRequired = 402,
    FTHTTPCodesNo403Forbidden = 403,
    FTHTTPCodesNo404NotFound = 404,
    FTHTTPCodesNo405MethodNotAllowed = 405,
    FTHTTPCodesNo406NotAcceptable = 406,
    FTHTTPCodesNo407ProxyAuthenticationRequired = 407,
    FTHTTPCodesNo408RequestTimeout = 408,
    FTHTTPCodesNo409Conflict = 409,
    FTHTTPCodesNo410Gone = 410,
    FTHTTPCodesNo411LengthRequired = 411,
    FTHTTPCodesNo412PreconditionFailed = 412,
    FTHTTPCodesNo413RequestEntityTooLarge = 413,
    FTHTTPCodesNo414RequestURITooLong = 414,
    FTHTTPCodesNo415UnsupportedMediaType = 415,
    FTHTTPCodesNo416RequestedRangeNotSatisfiable = 416,
    FTHTTPCodesNo417ExpectationFailed = 417,
    FTHTTPCodesNo418IamATeapot = 418,
    FTHTTPCodesNo419AuthenticationTimeout = 419,
    FTHTTPCodesNo420MethodFailureSpringFramework = 420,
    FTHTTPCodesNo420EnhanceYourCalmTwitter = 4200,
    FTHTTPCodesNo422UnprocessableEntity = 422,
    FTHTTPCodesNo423Locked = 423,
    FTHTTPCodesNo424FailedDependency = 424,
    FTHTTPCodesNo424MethodFailureWebDaw = 4240,
    FTHTTPCodesNo425UnorderedCollection = 425,
    FTHTTPCodesNo426UpgradeRequired = 426,
    FTHTTPCodesNo428PreconditionRequired = 428,
    FTHTTPCodesNo429TooManyRequests = 429,
    FTHTTPCodesNo431RequestHeaderFieldsTooLarge = 431,
    FTHTTPCodesNo444NoResponseNginx = 444,
    FTHTTPCodesNo449RetryWithMicrosoft = 449,
    FTHTTPCodesNo450BlockedByWindowsParentalControls = 450,
    FTHTTPCodesNo451RedirectMicrosoft = 451,
    FTHTTPCodesNo451UnavailableForLegalReasons = 4510,
    FTHTTPCodesNo494RequestHeaderTooLargeNginx = 494,
    FTHTTPCodesNo495CertErrorNginx = 495,
    FTHTTPCodesNo496NoCertNginx = 496,
    FTHTTPCodesNo497HTTPToHTTPSNginx = 497,
    FTHTTPCodesNo499ClientClosedRequestNginx = 499,
    
    
    // Server error
    FTHTTPCodesNo5XXSuccessUnknown = 5,
    FTHTTPCodesNo500InternalServerError = 500,
    FTHTTPCodesNo501NotImplemented = 501,
    FTHTTPCodesNo502BadGateway = 502,
    FTHTTPCodesNo503ServiceUnavailable = 503,
    FTHTTPCodesNo504GatewayTimeout = 504,
    FTHTTPCodesNo505HTTPVersionNotSupported = 505,
    FTHTTPCodesNo506VariantAlsoNegotiates = 506,
    FTHTTPCodesNo507InsufficientStorage = 507,
    FTHTTPCodesNo508LoopDetected = 508,
    FTHTTPCodesNo509BandwidthLimitExceeded = 509,
    FTHTTPCodesNo510NotExtended = 510,
    FTHTTPCodesNo511NetworkAuthenticationRequired = 511,
    FTHTTPCodesNo522ConnectionTimedOut = 522,
    FTHTTPCodesNo598NetworkReadTimeoutErrorUnknown = 598,
    FTHTTPCodesNo599NetworkConnectTimeoutErrorUnknown = 599
};

@interface CustomURLProtocol () <NSURLConnectionDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation CustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:@"CustomURLProtocolKey" inRequest:request]) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    GitHubResponse *cachedResponse = [CoreDataHelper cachedResponseForUrl:self.request.URL.absoluteString];
    if (cachedResponse && cachedResponse.etag == nil) {
        NSData *data = cachedResponse.data;
        NSString *mimeType = cachedResponse.mimeType;
        NSString *encoding = cachedResponse.encoding;
        
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                            MIMEType:mimeType
                                               expectedContentLength:data.length
                                                    textEncodingName:encoding];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    } else {
        NSMutableURLRequest *newRequest = [self.request mutableCopy];
        [NSURLProtocol setProperty:@YES forKey:@"CustomURLProtocolKey" inRequest:newRequest];
        if (cachedResponse.etag != nil) {
            [newRequest addValue:cachedResponse.etag forHTTPHeaderField:@"If-None-Match"];
            [NSURLProtocol setProperty:cachedResponse forKey:@"CachedData" inRequest:self.request];
        }
        self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
    }
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

- (void)passCachedData {
    GitHubResponse *cachedResponse = [NSURLProtocol propertyForKey:@"CachedData" inRequest:self.request];
    if (cachedResponse != nil) {
        NSData *data = cachedResponse.data;
        NSString *mimeType = cachedResponse.mimeType;
        NSString *encoding = cachedResponse.encoding;
        
        NSURLResponse *response2 = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                             MIMEType:mimeType
                                                expectedContentLength:data.length
                                                     textEncodingName:encoding];
        [self.client URLProtocol:self didReceiveResponse:response2 cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = response;
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)self.response;
    NSInteger code = [httpResponse statusCode];
    
    if (code == FTHTTPCodesNo304NotModified) {
        [self passCachedData];
    } else {
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    }
    self.mutableData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
    if (self.mutableData.length > 0) {
        [CoreDataHelper addResponseEnityBasedOn:self.response data:self.mutableData andUrlPath:self.request.URL.absoluteString];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self passCachedData];
}

@end
