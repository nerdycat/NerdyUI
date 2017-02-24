//
//  NSAttributedString+NERChainable.h
//  NerdyUI
//
//  Created by CAI on 10/3/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NERDefs.h"
#import "NERPrivates.h"

/**
 * Create a NSAttributedString.
 * AttStr can take multiply arguments, and each of them can be:
   1) NSString
   2) NSAttributedString
   3) UIImage, will create an NSTextAttachment.
   4) NSData, specifically HTML data.
 
 * Usages:
    1) id att1 = AttStr(@"Hello").color(@"red");
       id att2 = AttStr(@"Merry Christmas!").color(@"blue").range(2, 2).match(@"Christmas").underline;
       id att = AttStr(att1, @", ", att2, Img(@"hat")).fnt(@30);
 
    2) 
 */
#define AttStr(...) [NSMutableAttributedString ner_attributedStringWithSubstrings:@[__VA_ARGS__]]


@interface NSAttributedString (NERChainable)

@end


@interface NSMutableAttributedString (NERChainable)

/**
 * NSFontAttributeName
 * fnt use Fnt() internally, so it can take any kind of arguments that Fnt() supported.
 * Usages: .fnt(15), .fnt(@15), .fnt(@"headline"), .fnt(@"Helvetica,15"), .fnt(fontObject), etc.
 * See UIFont+NERChainable.h for more information.
 */
NER_ATT_PROP(Object)    fnt;

/**
 * NSForegroundColorAttributeName
 * color use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .color(@"red"), .color(@"#F00"), .color(@"255,0,0"), .color(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_ATT_PROP(Object)    color;

/**
 * NSBackgroundColorAttributeName
 * bgColor use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .bgColor(@"red"), .bgColor(@"#F00"), .bgColor(@"255,0,0"), .bgColor(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_ATT_PROP(Object)    bgColor;

/**
 * NSLinkAttributeName
 * Usages: .systemLink(urlString), .systemLink(url)
 */
NER_ATT_PROP(Object)    systemLink;

/**
 * NSKernAttributeName
 * The number of points by which to adjust kern-pair characters.
 * Usages: .kern(3)
 */
NER_ATT_PROP(Float)     kern;

/**
 * NSStrokeWidthAttributeName
 * The amount to change the stroke width (specified as a percentage of the font point size).
 * Usages: .stroke(3), .stroke(-3)
 */
NER_ATT_PROP(Float)     stroke;

/**
 * NSObliquenessAttributeName
 * The amount of skew to be applied to glyphs.
 * Usages: .oblique(1.3)
 */
NER_ATT_PROP(Float)     oblique;

/**
 * NSExpansionAttributeName
 * The amount of expansion factor to be applied to glyphs.
 * Usages: .expansion(1.1)
 */
NER_ATT_PROP(Float)     expansion;          //NSExpansionAttributeName

/**
 * NSBaselineOffsetAttributeName
 * How the character offset from the baseline.
 * Usages: .baselineOffset(5)
 */
NER_ATT_PROP(Float)     baselineOffset;

/**
 * ParagraphStyle.firstLineHeadIndent
 * The indentation of the first line of the receiver.
 * Usages: .indent(20)
 */
NER_ATT_PROP(Float)     indent;

/**
 * ParagraphStyle.lineSpacing
 * The distance in points between the bottom of one line fragment and the top of the next.
 * Usages: .lineGap(10)
 */
NER_ATT_PROP(Float)     lineGap;

/**
 * Select substrings that match the regular expression.
 * By default, attributes are apply to the whole string. You can limit the range by selecting substrings.
 * It support two kind of argument:
   1) NSRegularExpression
   2) NSString that represent regular expression pattern.
 * Usages: .match(@"[0-9]+"), match(regularExpression)
 */
NER_ATT_PROP(Object)    match;

/**
 * Select substring with range.
 * By default, attributes are apply to the whole string. You can limit the range by selecting substrings.
 * Negative location means location from end to start.
 * Usages: .range(0, 10).range(-10, 10)
 */
NER_ATT_PROP(TwoInt)    range;

/**
 * Apply styles to attributedString.
 * It support two kind of arguments:
   1) NERStyle instance or Array of NERStyle instances.
   2) NSString contain a list of style names(separated by white space).
 
 * Usages: .styles(style), .styles(@[style1, style2, style3]),
           .styles(@"style1"), .styles(@"style1 style2 style3")
 * See NERStyle+NERChainable.h for more information.
 */
NER_ATT_PROP(Object)    styles;


/**
 * Select substrings.
 * By default, attributes are apply to the whole string. You can limit the range by selecting substrings.
 * Usages: AttStr(@"@Tim at #Apple").matchHashTag.matchNameTag.color(@"red")
 */

//Select all numbers (e.g. 1024, 3.14)
- (instancetype)matchNumber;
//Select all URLs
- (instancetype)matchURL;
//Select all # Tags
- (instancetype)matchHashTag;
//Select all @ tags
- (instancetype)matchNameTag;


/**
 * Add underline, strikethrough or letterpress to selected strings.
 * Usages: .underline.strikeThrough
 */

//NSUnderlineStyleAttributeName
- (instancetype)underline;
//NSStrikethroughStyleAttributeName
- (instancetype)strikeThrough;
//NSTextEffectLetterpressStyle
- (instancetype)letterpress;


//paragraphStyle.alignment
- (instancetype)leftAlignment;
- (instancetype)centerAlignment;
- (instancetype)rightAlignment;
- (instancetype)justifiedAlignment;


/**
 * Marks as link for UILabel.
 * Example:
    id att1 = AttStr(@"@Tim at #Apple").matchHashTag.matchNameTag.linkForLabel;
    id att2 = AttStr(@"hello world").range(0, 5).linkForLabel.color(@"red");
 
    Label.str(att1).embedIn(self.view).onLink(^(NSString *text) {
        Log(text);
    });
 */
- (instancetype)linkForLabel;


/**
 * Only apply attribute if not exists.
 * By default, the attribute value applied later will override the previous one if they are the same attributes.
 * Usages:
    AttStr(@"hello").color(@"red").color(@"green")              //green color
    AttStr(@"hello").color(@"red").ifNotExists.color(@"green")  //red color
 */
- (instancetype)ifNotExists;


/*
 * Use to suppress getter side effects warning. Optional.
 * Usages: someAttStr.matchURL.underline.End();
 */
- (void(^)())End;

@end


