//
//  ViewController.m
//  NerdyUIExample
//
//  Created by nerdycat on 2017/1/3.
//  Copyright © 2017 nerdycat. All rights reserved.
//

#import "ViewController.h"
#import "AppStoreViewController.h"
#import "NerdyUI.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface ViewController ()

@end

@implementation ViewController


- (void)demo1 {
    UIView *view1 = View.xywh(20, 30, 50, 50).bgColor(@"red").opacity(0.7).border(3, @"#3d3d3d");
    UIView *view2 = View.xy(80, 30).wh(view1.wh).bgColor(@"blue,0.7").cornerRadius(25).shadow(0.8).onClick(^{
        Log(@"view2");
    });
    
    
    UIView *moose = ImageView.img(@"moose").x(20).y(100).shadow(0.6, 2, -3, -1);
    UILabel *quiz = Label.str(@"%d+%d=?", 1, 1).fnt(@17).color(@"66,66,66").fitSize.x(moose.maxX + 10).cy(moose.cy);
    
    
    id title = AttStr(@"TAP ME").fnt(15).underline.range(0, 3).fnt(@18).color(@"random");
    UIButton *button1 = Button.str(title).insets(5, 10).fitSize.border(1).xy(20, 150).onClick(^(UIButton *btn) {
        quiz.text = Str(@"%d+%d=%d", 1, 1, Exp(btn.tag += 1));
        [quiz sizeToFit];
    });
    
    UIButton *button2 = Button.str(@"HAT").highColor(@"brown").img(@"hat").gap(8);
    button2.xywh(button1.frame).x(button1.maxX + 10).cornerRadius(5).bgImg(@"blue,0.5").highBgImg(@"orange");
    //highBgImg with color string is a very useful trick to set highlighted background color for UIButton.
    
    
    id pinField = TextField.x(button1.x).y(button1.maxY + 15).wh(170, 30).onChange(^(NSString *text) {
        //self has been weakified, no need to warry about retain cycle.
        [(id)[self.view viewWithTag:101] setText:text];
    }).numberKeyboard.maxLength(4).hint(@"pin code").fnt(15).roundStyle;
    
    id textView = TextView.xywh(20, 240, 170, 100).border(1).insets(8).hint(@"placeholder").fnt([pinField font]).tg(101);
    
    //Add multiply subviews at once.
    self.view.addChild(view1, view2, quiz, moose, button1, button2, pinField, textView);
}


- (void)demo2 {
    id str = @"Lorem ipsum 20 dolor sit er elit lamet, consectetaur cillium #adipisicing pecu, sed do #eiusmod tempor incididunt ut labore et 3.14 dolore magna aliqua.";
    
    id attStr = AttStr(str).range(0, 5).match(@"lamet").match(@"[0-9.]+").matchHashTag.linkForLabel;
    
    Label.str(attStr).multiline.lineGap(10).xywh(self.view.bounds).onLink(^(NSString *text) {
        Log(text);
    }).addTo(self.view).centerAlignment;
}


- (void)demo3 {
    ImageView.img(@"macbook").embedIn(self.view).centerMode;
    
    id hello = Label.str(@"HELLO").fnt(@20).wh(80, 80).centerAlignment;
    id mac = Label.str(@"MAC").fnt(@20).wh(80, 80).centerAlignment;
    
    //In order to use makeCons, the view must be in the view hierarchy.
    EffectView.darkBlur.fixWH(80, 80).addTo(self.view).makeCons(^{
        make.right.equal.superview.centerX.constants(0);
        make.bottom.equal.superview.centerY.constants(0);
    }).addVibrancyChild(hello).tg(101);
    
    EffectView.extraLightBlur.fixWidth(80).fixHeight(80).addTo(self.view).makeCons(^{
        make.left.bottom.equal.view(self.view).center.constants(0, 0);
    });
    
    EffectView.lightBlur.addTo(self.view).makeCons(^{
        make.size.equal.constants(80, 80).And.center.equal.constants(40, 40);
    }).addVibrancyChild(mac);
    
    id subImg = Img(@"macbook").subImg(95, 110, 80, 80).blur(10);
    ImageView.img(subImg).addTo(self.view).makeCons(^{
        make.centerX.top.equal.view([self.view viewWithTag:101]).centerX.bottom.constants(0);
    });
}


- (void)demo4 {
    AppStoreViewController *as = [AppStoreViewController new];
    [self.view addSubview:as.view.xywh(self.view.bounds)];
    [self addChildViewController:as];
}


- (void)demo5 {
    GroupTV(
            Section(
                    Row.str(@"Row1").fnt(20).color(@"red"),
                    Row.str(@"Row2").detailStr(@"detail"),
                    Row.str(@"Row3").detailStr(@"detail").img(@"moose").subtitleStyle.separatorLeftInset(15),
                    Row.str(@"Row4").detailStr(@"detail").value2Style.disclosure.onClick(@"row4Click"),
                    
                    Row.str(@"Row5").accessory(Switch.onChange(^{
                        Log(@"switch change");
                    })).onClick(^{
                        Log(@"Row5");
                    })
                    ),
            
            Section(
                    Row.str(@"Option1").check(YES),
                    Row.str(@"Option2"),
                    Row.str(@"Option3"),
                    ).singleCheck,
            
            Section(
                    Row.custom(^(id contentView) {
                        Label.str(@"Done").color(@"orange").centerAlignment.embedIn(contentView);
                    }).onClick(^{
                        id checkedIndex = [[self.view viewWithTag:101] checkedIndexPaths];
                        Log(checkedIndex);
                    })
                    )
            ).embedIn(self.view).tg(101);
}


- (void)demo6 {
    id s1 = Style().fnt(@15).fixWH(100, 44).cornerRadius(4);
    
    id b1 = Button.str(@"Alert").styles(s1).bgImg(@"#178BFB").highBgImg(@"#1F71DC").color(@"white").onClick(@"showAlert");
    id b2 = Button.str(@"ActionSheet").styles(s1).highBgImg(@"#DDD").border(1, @"lightGray").onClick(^{
        [self showActionSheet];
    });
    
    id s2 = Style().cornerRadius(8).bgImg(@"#1EC659").insets(10, 6);
    id s3 = Style().str(@"moose").img(@"moose").gap(10);
    
    id b3 = Button.styles(@[s2, s3]);
    id b4 = Button.styles(@[s2, s3]).reversed.adjustDisabled;
    
    id att5 = AttStr(Img(@"moose"), @"\nmoose").centerAlignment;
    id b5 = Button.str(att5).multiline.styles(s2);
    
    id att6 = AttStr(@"moose\n", Img(@"moose")).centerAlignment.lineGap(20);
    id b6 = Button.str(att6).multiline.styles(s2).bgImg(@"#40AFFC");
    id b7 = Button.str(att6).multiline.styles(s2).bgImg(@"#40AFFC").img(Img(@"hat").templates).tint(@"#EC4F51").gap(20);
    
    id att8 = AttStr(@"A hat ", Img(@"hat"), @" and a moose", Img(@"moose").templates);
    id b8 = Button.str(att8).bgImg(@"#40AFFC");
    
    id s4 = Style().fnt(13).color(@"darkGray").matchNumber.fnt(@17).color(@"black").centerAlignment;
    
    id att9 = AttStr(@"1024\n#followers").styles(s4);
    id b9 = Button.str(att9).fixWH(90, 44).multiline.border(1);
    
    id att10 = AttStr(@"2048\n#following").styles(s4);
    id b10 = Button.str(att10).fixWH(90, 44).multiline.highBgImg(@"#EEE");
    
    id att11 = AttStr(
                      AttStr(@"Super Mario Run\n").fnt(15),
                      AttStr(@"Games\n").fnt(13).color(@"darkGray"),
                      AttStr(@"★★★☆☆").fnt(11).color(@"orange"),
                      AttStr(@"（6053）").fnt(11).color(@"darkGray")
                      ).lineGap(3);
    id b11 = Button.str(att11).multiline.border(1).highBgImg(@"#EEE").img(Img(@"mario").resize(64, 64)).gap(10);
    
    id b12 = Button.str(@"⚽︎♠︎♣︎☁︎☃☆★⚾︎\n◼︎▶︎✔︎✖︎♚✎✿✪").fnt(25).multiline;
    id b13 = Button.str(@"♣︎").fnt(100).color(@"red");
    
    id title = Label.str(@"Button + Style + AttStr:");
    id scrollView = [UIScrollView new].embedIn(self.view);
    VerStack(title, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13).gap(10).embedIn(scrollView, 20, 20, 80);
}

- (void)showAlert {
    id message = @"You have to call .show() in the end in order to make Alert visible.";
    Alert.title(@"Alert").message(message).action(@"OK", ^{
        Log(@"OK");
    }).cancelAction(@"Cancel").show();
}

- (void)showActionSheet {
    ActionSheet.title(@"ActionSheet").message(@"ActionSheet use the same syntax as Alert.").action(@"Action1", ^{
        Log(@"Action1");
    }).action(@"Action2", ^{
        Log(@"Action2");
    }).destructiveAction(@"Delete", ^{
        Log(@"Delete");
    }).cancelAction(@"Cancel").tint(@"cyan").show();
}

- (void)row4Click {
    Log(@"Row4");
}


- (void)clear {
    self.view.subviews.filter(^(id v) {return [v tag] != 999;}).forEach(@"removeFromSuperview");
    self.childViewControllers.forEach(@"removeFromParentViewController");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    Segmented(@"demo1", @"demo2", @"demo3", @"demo4", @"demo5", @"demo6").onChange(^(int index, id sc) {
        id methodName = @("demo").a(index + 1);
        
        //self has been weakified, no need to warry about retain cycle.
        [self clear];
        [self performSelector:NSSelectorFromString(methodName)];
        [self.view bringSubviewToFront:sc];
    }).embedIn(self.view, NERNull, 10, 20, 10).tg(999);
}

- (void)dealloc {
    Log(@"dealloc");
}

@end



