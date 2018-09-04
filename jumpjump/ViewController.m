//
//  ViewController.m
//  jumpjump
//
//  Created by David Wagner on 04/09/2018.
//  Copyright © 2018 David Wagner. All rights reserved.
//

#import "ViewController.h"

typedef void (*DoSomething)(int);

static jmp_buf thingEnv;

void do_a_thing(DoSomething d) {
    int random = rand();
    NSLog(@"do_a_thing, generated: %d", random);
    d(random);
}

static void bounce(int r) {
    longjmp(thingEnv, r);
}

@interface ViewController ()
@property (nonatomic, copy) void (^thing)(int, int);
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    srand([NSDate date].timeIntervalSinceReferenceDate);
}

- (IBAction)handleButton:(UIButton *)sender {
    int localR = rand();
    NSLog(@"Button press, generated: %d", localR);
    
    self.thing = ^ (int ignored, int localRCopy) {
        NSLog(@"Closure called");
        int r = setjmp(thingEnv);
        if (r == 0) {
            NSLog(@"Closure exiting as r = 0");
            return;
        }
        //NSString *s = [sender debugDescription];
        NSLog(@"I'm in a function and was told %d, and had a local %d", r, localRCopy);
        NSLog(@"Closure exiting");
    };
    
    self.thing(0, localR);
    do_a_thing(bounce);
}

@end
