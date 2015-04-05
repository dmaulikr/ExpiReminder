//
//  CalendarioViewController.m
//  ER
//
//  Created by Leonardo Rodrigues de Morais Brunassi on 25/03/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

#import "CalendarioViewController.h"

@interface CalendarioViewController ()

@end

@implementation CalendarioViewController

//diaAlerta
//alerta on/off
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Calendário";
    self.navigationItem.title = @"Calendário";
    _singleton = [ProdutoSingleton instance];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 7;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Produto allObjects]count];
}

-(NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *now = [NSDate date];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day=1;
    NSDate *newDate;
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSLog(@"The day of the week is: %@", [weekday stringFromDate:now]);
    switch (section) {
        case 0:
            return [[weekday stringFromDate:now] uppercaseString];
            break;
        case 1:
            newDate = [calendar dateByAddingComponents:components toDate:now options:0];
            components.day=2;
            return [[weekday stringFromDate:newDate ] uppercaseString];
            break;
        case 2:
            components.day=2;
            newDate = [calendar dateByAddingComponents:components toDate:now options:0];
            return [[weekday stringFromDate:newDate ] uppercaseString];
            break;
        case 3:
            components.day=3;
            newDate = [calendar dateByAddingComponents:components toDate:now options:0];
            return [[weekday stringFromDate:newDate ] uppercaseString];
            break;
        case 4:
            components.day=4;
            newDate = [calendar dateByAddingComponents:components toDate:now options:0];
            return [[weekday stringFromDate:newDate ] uppercaseString];
            break;
        case 5:
            components.day=5;
            newDate = [calendar dateByAddingComponents:components toDate:now options:0];
            return [[weekday stringFromDate:newDate ] uppercaseString];
            break;
        case 6:
            components.day=6;
            newDate = [calendar dateByAddingComponents:components toDate:now options:0];
            return [[weekday stringFromDate:newDate ] uppercaseString];
            break;
        default:
            return nil;
            break;
            
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CalendarioTableViewCell *cal = [self.tableView dequeueReusableCellWithIdentifier:@"produtoCalendario" forIndexPath:indexPath];
    cal.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cal.produtoCalend.text = [[[_singleton retornoProd] objectAtIndex:indexPath.row]nome];
    return cal;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
