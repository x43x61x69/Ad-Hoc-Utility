//
//  ViewController.m
//  Ad-Hoc Utility
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

#import "ViewController.h"
#import "NSAdHocUpdate.h"

@implementation ViewController

- (void)viewDidAppear
{
    [super viewDidAppear];
    [self check:_textField_manifestURL];
}

- (IBAction)check:(id)sender
{
    _imageView_icon.image = nil;
    _button_copyURL.enabled =
    _button_download.enabled = NO;
    _textField_bundleId.stringValue =
    _textField_version.stringValue =
    _textField_payloadURL.stringValue = @"";
    
    [NSAdHocUpdate checkForUpdate:[NSURL URLWithString:_textField_manifestURL.stringValue]
                completionHandler:^(NSDictionary *manifest,
                                    NSString *bundleId,
                                    NSString *version,
                                    NSImage *image,
                                    NSURL *payloadURL)
     {
         _textField_bundleId.stringValue = bundleId;
         _textField_version.stringValue = version;
         if (payloadURL) {
             _textField_payloadURL.stringValue = [payloadURL absoluteString];
             _button_download.enabled = _textField_payloadURL.stringValue.length;
         }
         _imageView_icon.image = image;
     }];
    
    _button_copyURL.enabled =
    _button_download.enabled = YES;
}

- (IBAction)download:(id)sender
{
    if (_textField_payloadURL.stringValue.length) {
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_textField_payloadURL.stringValue]];
//        if (data) {
//            
//            NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
//            NSString *desktopPath = [paths firstObject];
//            desktopPath = [desktopPath stringByAppendingPathComponent:[_textField_payloadURL.stringValue lastPathComponent]];
//            
//            NSLog(@"%@", desktopPath);
//            
//            [data writeToURL:[NSURL fileURLWithPath:desktopPath]
//                  atomically:YES];
//        }
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:_textField_payloadURL.stringValue]];
    }
}

- (IBAction)copyURLforiOS:(id)sender
{
    if (_textField_manifestURL.stringValue.length) {
        NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
        [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
        [pasteBoard setString:[NSString stringWithFormat:@"%@%@",
                               kITMSServicesAction,
                               _textField_manifestURL.stringValue] forType:NSStringPboardType];
    }
}

@end
