

#import "YNumberKeyboard.h"



// 圆角效果 view 10
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//边框效果
#define ViewBoderWithHex(View,BorderWidth,hexValue)\
[View.layer setBorderWidth:BorderWidth];\
CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();\
CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){((float)((hexValue & 0xFF0000) >> 16))/255.0,((float)((hexValue & 0xFF00) >> 8))/255.0, ((float)(hexValue & 0xFF))/255.0,1});\
[View.layer setBorderColor:colorref];\
CGColorSpaceRelease(colorSpace);\
CGColorRelease(colorref);

#define kLineWidth 0.5
#define kNumFont [UIFont systemFontOfSize:27]

#define YWith [UIScreen mainScreen].bounds.size.width
#define YHeight 216
@interface YNumberKeyboard ()
@property (nonatomic,assign) id<YNumberKeyboardDelegate> delegate;
@end

@implementation YNumberKeyboard

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        
        self.bounds = CGRectMake(0, 0, YWith, YHeight);
        self.startY = 0;
        self.delegate = delegate;
        
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];//BCC0C7
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(YWith/3, 0, kLineWidth, YHeight)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(YWith/3*2, 0, kLineWidth, YHeight)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*(i+1), YWith, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
    }
    return self;
}

- (id)initWithDelegate:(id)delegate andTextfield:(UITextField *)textField
{
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, YWith, YHeight);
        self.startY = 0;
        
        self.delegate = delegate;
        self.textField = textField;
        //
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        //
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(YWith/3, 0, kLineWidth, YHeight)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(YWith/3*2, 0, kLineWidth, YHeight)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*(i+1), YWith, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
    }
    return self;
}
- (id)initWithDelegate:(id)delegate withAddHeight:(int)addHeight
{
    self = [super init];
    if (self) {
        
        self.bounds = CGRectMake(0, 0, YWith, YHeight + addHeight);
        
        
        self.startY = addHeight;
        self.delegate = delegate;
        
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];//BCC0C7
        
        
        //5 10 20 倍
        self.viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0,0, YWith, addHeight)];
        self.viewHeader.backgroundColor =  [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
        self.viewHeader.hidden = YES;
        [self addSubview:self.viewHeader];
        UILabel *labelHeaderLine = [[UILabel alloc]initWithFrame:CGRectMake(0, addHeight -1, YWith, 1)];
        labelHeaderLine.backgroundColor = color;
        [self.viewHeader addSubview:labelHeaderLine];
        for (int i = 0; i < 3 ; i ++) {
            UIButton *buttonMutiple = [[UIButton alloc]initWithFrame:CGRectMake(10 + (10 + (YWith - addHeight)/3)*i , 5, (YWith -addHeight)/3, 30)];
            buttonMutiple.tag = 301+i;

            if (i == 0) {
                [buttonMutiple setTitle:@"按钮1" forState:UIControlStateNormal];
            }else if (i == 1){
                [buttonMutiple setTitle:@"按钮2" forState:UIControlStateNormal];
            }else if (i == 2){
                [buttonMutiple setTitle:@"按钮3" forState:UIControlStateNormal];
            }
            [buttonMutiple setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            buttonMutiple.titleLabel.font = [UIFont systemFontOfSize:15.0];
            ViewBoderWithHex(buttonMutiple, 1,0xbcc0c7);
            ViewRadius(buttonMutiple, 3);
            [self.viewHeader addSubview:buttonMutiple];
        }
        //
        
        //
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(YWith/3, 0 + addHeight, kLineWidth, YHeight + addHeight)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(YWith/3*2, 0+ addHeight, kLineWidth, YHeight + addHeight)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, addHeight+54*(i+1), YWith, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
    }
    return self;
}


-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    UIButton *button;
    //
    CGFloat frameX = 0.0;
    CGFloat frameW = 0.0;
    switch (y)
    {
        case 0:
            frameX = 0.0;
            frameW = YWith/3;
            break;
        case 1:
            frameX = YWith/3;
            frameW = YWith/3;
            break;
        case 2:
            frameX = YWith/3*2;
            frameW = YWith/3;
            break;
            
        default:
            break;
    }
    CGFloat frameY = self.startY + 54*x;
    
    //
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, YWith/3, 54)];
//    button.isIgnore = YES;
    //
    NSInteger num = y+3*x+1;
    button.tag = num;
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    
    if (num == 10 || num == 12)
    {
        UIColor *colorTemp = colorNormal;
        colorNormal = colorHightlighted;
        colorHightlighted = colorTemp;
    }
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    
    
    
    if (num<10)
    {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:button.bounds];
        labelNum.text = [NSString stringWithFormat:@"%ld",num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        [button addSubview:labelNum];
    }
    else if (num == 11)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:button.bounds];
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    }
    else if (num == 10)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:button.bounds];
        label.text = @"确 定";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:215.0f / 256.0f green:33.0f / 256.0f blue:59.0f / 256.0f alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    else
    {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width/2-11, button.frame.size.height/2-9, 22, 18)];
        arrow.image = [UIImage imageNamed:@"keyboarddelete"];
        [button addSubview:arrow];
        
    }
    
    return button;
}


-(void)clickButton:(UIButton *)sender
{
//    NSLog(@"%@",self.textField);
    
    if (sender.tag == 10)
    {
        if ([self.delegate respondsToSelector:@selector(doneKeyboardType)]) {
            [self.delegate doneKeyboardType];
        }
        
        [self.textField resignFirstResponder];
        [self removeFromSuperview];
        return;
    }
    else if(sender.tag == 12)
    {
        
        UITextField * textfieldTrans = [[UITextField alloc]init];
        if (self.textField.text.length != 0) {
            NSRange offsetRange = [self reEdtingTextFieldOfSelect:self.textField];
            if (offsetRange.length > 0) {
                textfieldTrans.text = [self.textField.text substringToIndex:self.textField.text.length - offsetRange.length];
            }else{
                textfieldTrans.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
            }
            self.textField.text = textfieldTrans.text;
        }
        if ([self.delegate respondsToSelector:@selector(numberKeyboardBackspaceWithTextField:)]) {
            [self.delegate numberKeyboardBackspaceWithTextField:self.textField];
        }
    }
    else
    {
        NSInteger num = sender.tag;
        if (sender.tag == 11)
        {
            num = 0;
        }
       
        int valueOfMultipleTF = [self.textField.text intValue];
        if(valueOfMultipleTF == 0 && num == 0){
            self.textField.text = @"0";
            return;
        }else if(valueOfMultipleTF == 0 && num != 0){
            self.textField.text = @"";
        }
        NSRange offsetRangeTF = [self reEdtingTextFieldOfSelect:self.textField];
        NSString *stringInTF = [NSString stringWithFormat:@"%ld",(long)num];
        NSString *stringRepleTF;
        if (self.textField.text.length > 0)
        {
            if ((valueOfMultipleTF == num) && (offsetRangeTF.length == self.textField.text.length)) {
                self.textField.text = @"";
                stringRepleTF = [NSString stringWithFormat:@"%ld",(long)num];
            }else{
                stringRepleTF = [self.textField.text stringByReplacingCharactersInRange:offsetRangeTF withString:stringInTF];
            }
            self.textField.text = stringRepleTF;
        }
        else
        {
            stringRepleTF = stringInTF;
            self.textField.text = stringInTF;
        }
        
        if (self.textField.text.length > 9) {
            self.textField.text = [self.textField.text substringToIndex:9];
            stringRepleTF = [stringRepleTF substringToIndex:9];
        }
        
        if ([self.delegate respondsToSelector:@selector(numberKeyboardInput:textField:)]) {
            [self.delegate numberKeyboardInput:num textField:self.textField];
        }
        
    }
}
-(NSRange)reEdtingTextFieldOfSelect:(UITextField *)tf{
    NSInteger startOffset = [tf offsetFromPosition:tf.beginningOfDocument toPosition:tf.selectedTextRange.start];
    NSInteger endOffset = [tf offsetFromPosition:tf.beginningOfDocument toPosition:tf.selectedTextRange.end];
    NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
    return offsetRange;
}


@end
