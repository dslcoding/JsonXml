//
//  ViewController.m
//  Json&Xml
//
//  Created by 董诗磊 on 2017/4/5.
//  Copyright © 2017年 董诗磊. All rights reserved.
//

#import "ViewController.h"

#import "DSLModel.h"
@interface ViewController ()<NSXMLParserDelegate>

@property (nonatomic ,strong) NSMutableArray * dataArray;

@property (nonatomic ,strong) NSString * startTagFlag;

@property (nonatomic ,strong) DSLModel * model;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self xml];
    
   // [self json];
}

- (void)json{

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://api.douban.com/v2/movie/subject/25881786"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
         NSLog(@"=====%@",dic);
        
    }];
    
    [task resume];
    
    NSDictionary * dic = @{
                           @"large":@"https://img3.doubanio.com/view/movie_poster_cover/lpst/public/p2276855500.jpg",
                           @"medium":@"https://img3.doubanio.com/view/movie_poster_cover/spst/public/p2276855500.jpg"
                           };
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"===%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);




}

- (void)xml{
    
    //声明一个数组，用来存放解析的数据
    self.dataArray = [[NSMutableArray alloc]init];
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"DSL.xml" ofType:nil];
    

    NSXMLParser * xmlParser = [[NSXMLParser alloc]initWithData:[NSData dataWithContentsOfFile:path]];
    
    xmlParser.delegate = self;
    
    [xmlParser parse];


}

#pragma mark NSXMLParserDelegate
//文档读区开始
- (void)parserDidStartDocument:(NSXMLParser *)parser
{

    NSLog(@"parse start");
    

}

//文档读取结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"parser end ===%@",self.dataArray);
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        DSLModel *model = (DSLModel*)obj;
        
        NSLog(@"====%@===%@==%@",model.proID,model.pinyin,model.proName);
        
        
    }];

}

//解析标签开始
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    self.startTagFlag = elementName;
    
    if ([elementName isEqualToString:@"result"]) {
        
        self.model = [[DSLModel alloc]init];
        
        [self.dataArray addObject:self.model];
        
    }



}

//获取标签的内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.startTagFlag isEqualToString:@"proID"]) {
        
        [self.model setProID:string];
    }
    
    if ([self.startTagFlag isEqualToString:@"proName"]) {
        
        [self.model setProName:string];
        
    }

    
    if ([self.startTagFlag isEqualToString:@"pinyin"]) {
        
        [self.model setPinyin:string];
    }

}

//解析标签结束
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    self.startTagFlag = nil;


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



























@end
