//
//  NSAdHocUpdate.m
//  NSAdHocUpdate
//
//  The MIT License (MIT)
//
//  Copyright © 2017 Zhi-Wei Cai. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "NSAdHocUpdate.h"

@implementation NSAdHocUpdate

+ (void)checkForUpdate:(NSURL *)manifestURL completionHandler:(void (^)(NSDictionary *manifest,
                                                                        NSString *bundleId,
                                                                        NSString *version,
                                                                        NSImage *image,
                                                                        NSURL *payloadURL))completionHandler
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:manifestURL];
    if (dict) {
        NSString *bundle = dict[@"items"][0][@"metadata"][@"bundle-identifier"];
        NSString *version = dict[@"items"][0][@"metadata"][@"bundle-version"];
        NSURL *payloadURL;
        NSImage *image;
        for (NSDictionary *d in dict[@"items"][0][@"assets"]) {
            NSString *kind = d[@"kind"];
            if ([kind isEqualToString:@"software-package"]) {
                NSString *payload = d[@"url"];
                if (payload) {
                    payloadURL = [NSURL URLWithString:payload];
                }
            } else if ([kind isEqualToString:@"display-image"]) {
                NSString *imageURL = d[@"url"];
                if (imageURL) {
                    image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
                }
            }
        }
        
        NSLog(@"%@, %@, %@", bundle, version, payloadURL);
        
        completionHandler(dict,
                          bundle,
                          version,
                          image,
                          payloadURL);
    }
}

@end
