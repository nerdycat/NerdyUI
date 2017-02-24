//
//  NSAttributedString+NERChainable.m
//  NerdyUI
//
//  Created by CAI on 10/3/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NSAttributedString+NERChainable.h"
#import "UIFont+NERChainable.h"
#import "UIColor+NERChainable.h"


@implementation NSAttributedString (NERChainable)

@end

@implementation NSMutableAttributedString (NERChainable)

- (NERChainableNSMutableAttributedStringObjectBlock)fnt {
    NER_OBJECT_BLOCK([self ner_applyAttribute:NSFontAttributeName withValue:Fnt(value)]);
}

- (NERChainableNSMutableAttributedStringObjectBlock)color {
    NER_OBJECT_BLOCK([self ner_applyAttribute:NSForegroundColorAttributeName withValue:Color(value)]);
}

- (NERChainableNSMutableAttributedStringObjectBlock)bgColor {
    NER_OBJECT_BLOCK([self ner_applyAttribute:NSBackgroundColorAttributeName withValue:Color(value)]);
}

- (NERChainableNSMutableAttributedStringObjectBlock)systemLink {
    NER_OBJECT_BLOCK([self ner_applyAttribute:NSLinkAttributeName withValue:value]);
}

- (NERChainableNSMutableAttributedStringFloatBlock)kern {
    NER_FLOAT_BLOCK([self ner_applyAttribute:NSKernAttributeName withValue:@(value)]);
}

- (NERChainableNSMutableAttributedStringFloatBlock)stroke {
    NER_FLOAT_BLOCK([self ner_applyAttribute:NSStrokeWidthAttributeName withValue:@(value)]);
}

- (NERChainableNSMutableAttributedStringFloatBlock)oblique {
    NER_FLOAT_BLOCK([self ner_applyAttribute:NSObliquenessAttributeName withValue:@(value)]);
}

- (NERChainableNSMutableAttributedStringFloatBlock)expansion {
    NER_FLOAT_BLOCK([self ner_applyAttribute:NSExpansionAttributeName withValue:@(value)]);
}

- (NERChainableNSMutableAttributedStringFloatBlock)baselineOffset {
    NER_FLOAT_BLOCK([self ner_applyAttribute:NSBaselineOffsetAttributeName withValue:@(value)]);
}

- (NERChainableNSMutableAttributedStringFloatBlock)indent {
    NER_FLOAT_BLOCK([self ner_setParagraphStyleValue:@(value) forKey:@"firstLineHeadIndent"]);
}

- (NERChainableNSMutableAttributedStringFloatBlock)lineGap {
    NER_FLOAT_BLOCK([self ner_setParagraphStyleValue:@(value) forKey:@"lineSpacing"]);
}

- (NERChainableNSMutableAttributedStringObjectBlock)match {
    NER_OBJECT_BLOCK(
                     if (!self.nerIsJustSettingEffectedRanges) {
                         [self.nerEffectedRanges removeAllIndexes];
                     }
                     
                     NSRegularExpression *exp = nil;
                     if ([value isKindOfClass:NSRegularExpression.class]) {
                         exp = value;
                     } else {
                         exp = [[NSRegularExpression alloc] initWithPattern:value options:0 error:nil];
                     }
                     
                     NSArray *matches = [exp matchesInString:self.string options:0 range:[self.string ner_fullRange]];
                     for (NSTextCheckingResult *result in matches) {
                         [self.nerEffectedRanges addIndexesInRange:result.range];
                     }
                     
                     self.nerIsJustSettingEffectedRanges = YES;
                     );
}

- (NERChainableNSMutableAttributedStringTwoIntBlock)range {
    NER_TWO_INT_BLOCK(
                      if (!self.nerIsJustSettingEffectedRanges) {
                          [self.nerEffectedRanges removeAllIndexes];
                      }
                      
                      if (value1 < 0) {
                          value1 = self.string.length + value1;
                      }
                      [self.nerEffectedRanges addIndexesInRange:NSMakeRange(value1, value2)];
                      self.nerIsJustSettingEffectedRanges = YES;
                      );
}

- (NERChainableNSMutableAttributedStringObjectBlock)styles {
    NER_OBJECT_BLOCK([NERUtils applyStyleObject:value toItem:self];);
}

- (instancetype)underline {
    [self ner_applyAttribute:NSUnderlineStyleAttributeName withValue:@(NSUnderlineStyleSingle)];
    return self;
}

- (instancetype)strikeThrough {
    [self ner_applyAttribute:NSStrikethroughStyleAttributeName withValue:@(NSUnderlineStyleSingle)];
    return self;
}

- (instancetype)letterpress {
    [self ner_applyAttribute:NSTextEffectAttributeName withValue:NSTextEffectLetterpressStyle];
    return self;
}

- (instancetype)matchNumber {
    return self.match(@"\\d+(\\.\\d+)?");
}

- (instancetype)matchURL {
    NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    return self.match(urlDetector);
}

- (instancetype)matchHashTag {
    return self.match(@"(?<!\\w)#([\\w\\_]+)?");
}

- (instancetype)matchNameTag {
    return self.match(@"(?<!\\w)@([\\w\\_]+)?");
}

- (instancetype)linkForLabel {
    [self ner_applyAttribute:NERLinkAttributeName withValue:NERLinkAttributeValue];
    return self;
}

- (instancetype)ifNotExists {
    self.nerAddAttributeIfNotExists = YES;
    return self;
}

- (instancetype)leftAlignment {
    [self ner_setParagraphStyleValue:@(NSTextAlignmentLeft) forKey:@"alignment"];
    return self;
}

- (instancetype)centerAlignment {
    [self ner_setParagraphStyleValue:@(NSTextAlignmentCenter) forKey:@"alignment"];
    return self;
}

- (instancetype)rightAlignment {
    [self ner_setParagraphStyleValue:@(NSTextAlignmentRight) forKey:@"alignment"];
    return self;
}

- (instancetype)justifiedAlignment {
    [self ner_setParagraphStyleValue:@(NSTextAlignmentJustified) forKey:@"alignment"];
    return self;
}

- (void (^)())End {
    return ^{};
}

@end

