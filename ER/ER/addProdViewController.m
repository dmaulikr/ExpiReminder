//
//  addProdViewController.m
//  ER
//
//  Created by Leonardo Rodrigues de Morais Brunassi on 26/03/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

#import "addProdViewController.h"

@interface addProdViewController ()

@end

@implementation addProdViewController
@synthesize cadastroTableView, produto, produtoCell, notificacao;

#pragma mark metodos delegate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Vai por favor");
    return 6;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Entro");
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if(indexPath.row == 0){
        _dataValidade = [tableView dequeueReusableCellWithIdentifier:@"validade"];
                return _dataValidade;
    }
    
    if(indexPath.row == 1){
        _datePicker = [tableView dequeueReusableCellWithIdentifier:@"datePicker"];
        NSDate *currentDate = [NSDate date];
        [_datePicker.datePicker setMinimumDate:currentDate];
        return _datePicker;
    }
    
    if (indexPath.row == 2) {
        UITableViewCell *celula = [[UITableViewCell alloc] init];
        celula.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:0.5];
        return celula;
    }
    
    if (indexPath.row == 3) {
        produtoCell = [tableView dequeueReusableCellWithIdentifier:@"nome"];
        
        return produtoCell;
    }
    
    if (indexPath.row == 4) {
        UITableViewCell *celula = [[UITableViewCell alloc] init];
        celula.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:0.5];
        return celula;
    }
    
    if (indexPath.row == 5) {
        _imagem = [tableView dequeueReusableCellWithIdentifier:@"imagem"];
        _imagem.imgProd.image = [UIImage imageNamed:@"default.png"];
        return _imagem;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellStyleDefault];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 50;
    else if (indexPath.row == 1)
        return 200;
    else if (indexPath.row == 2)
        return 35;
    else if (indexPath.row == 3)
        return 50;
    else if (indexPath.row == 4)
        return 35;
    else if (indexPath.row == 5)
        return 190;
    else
        return 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden: YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark implementações do grupo



-(void)initialize
{
    self.navigationItem.title = @"Adicionar Produto";
    
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = done;
    _usuarioSingleton = [UsuarioSingleton sharedInstance];
     _user = [[_usuarioSingleton loadUsuario]objectAtIndex:0];
    

}


//----------------------------------------- METODO QUE SALVA O PRODUTO NO BANCO E CRIA A NOTIFICATION PARA ESSE PRODUTO
-(void)done:(id)sender{
    ProdutoSingleton *singleton = [ProdutoSingleton instance];
    FotoSingleton *fotoSingleton = [FotoSingleton instance];
    
    produto = [[Produto alloc]init];
// CONDIÇAO DO CODIGO DE BARRAS
    if(_aux == nil)
    {
        _aux = @" ";
        [produto setNumCodigoDeBarras:_aux];
    }
    else{
        [produto setNumCodigoDeBarras:_aux];
    }
    

    
// CONDIÇAO DA CAIXA DE TEXTO
    if ([produtoCell.registroProdTF.text  isEqual: @""]) {
        [self alertViewShowMessageView];
    }
    else
    {
        [produto setNome: produtoCell.registroProdTF.text];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MM/yyyy"];
        
        NSString *dateString = [format stringFromDate:_datePicker.datePicker.date];
        NSLog(@"%@", dateString);
        
        NSDate *dateNow = [NSDate date];
        
        NSString *dateNowString = [format stringFromDate:dateNow];
        
        dateNow = [format dateFromString:dateNowString];
        NSLog(@"%@", dateNowString);
        
        NSDate *dateValidade = [format dateFromString:dateString];
        NSLog(@"%@", dateString);
        
        int diasFaltandoInt = (int) -[dateNow timeIntervalSinceDate:dateValidade]/86400;;
        
        NSLog(@"%i dia(s)", diasFaltandoInt);
        
        [produto setDiasFaltando:[NSString stringWithFormat:@"%i", diasFaltandoInt]];
        NSLog(@"%@", produto.diasFaltando);
        [produto setDataValidade:dateString];
        
        if ([_imagem.imgProd.image isEqual:[UIImage imageNamed:@"default.png"]]) {
            [_imagem.imgProd.image setAccessibilityIdentifier:@"default"];
            [fotoSingleton salvarFoto:_imagem.imgProd.image comNome:[produto nome]];
        }
        else{
            [_imagem.imgProd.image setAccessibilityIdentifier:[produto nome]];
            [fotoSingleton salvarFoto:_imagem.imgProd.image comNome:[produto nome]];
        }
        

        [singleton adicionarProd:produto];
        
        //verifica se a notificação vai ser disparada aqui
        if([_user fireNotification])
            [self createLocalNotification];
        
        [self createEvent];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


//-------------------------------------- METODO QUE ENCAPSULA A CRIAÇAO DO ALERTCONTROLLER
-(void)alertViewShowMessageView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Nome do produto obrigatório." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}


//------------------------------------------- METODO QUE ENCAPSULA A CRIAÇAO DA LOCALNOTIFICATION
-(void)createLocalNotification{
    notificacao = [[UILocalNotification alloc]init];
    NSLog(@"%@", _datePicker.datePicker.date);
    //notificacao.fireDate = [self setCustomFireDate:_datePicker.datePicker.date];
    
   
    notificacao.fireDate = [_datePicker.datePicker.date dateByAddingTimeInterval:[_user daysInSeconds]];
    
    NSLog(@"%@", notificacao.fireDate);
    notificacao.timeZone = [NSTimeZone systemTimeZone];
    NSLog(@"%@", notificacao.timeZone);
    //        notificacao.repeatInterval = NSCalendarUnitDay;
    notificacao.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ irá vencer em breve.", nil),
                             produto.nome];
    notificacao.alertTitle = NSLocalizedString(@"Produto Vencendo!", nil);
   
    notificacao.soundName = UILocalNotificationDefaultSoundName;
    notificacao.applicationIconBadgeNumber= [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notificacao];
    
}

-(void)createEvent
{
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = [NSString stringWithFormat:@"%@ vencendo", produtoCell.registroProdTF.text];
        event.notes = [NSString stringWithFormat:@"%@ esta vencendo hj", produtoCell.registroProdTF.text];
        event.startDate = notificacao.fireDate;
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
        event.calendar = [store defaultCalendarForNewEvents];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    }];

}

//--------------------------------------------------------------------

//-------------------------------------------- METODOS PARA TIRAR FOTO
- (IBAction)tirarFoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    _imagem.imgProd.contentMode = UIViewContentModeScaleAspectFit;
    [_imagem.imgProd setImage: image];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.2 green:0.3 blue:1 alpha:1.0]];
}

//---------------------------------------------------------------------



@end
