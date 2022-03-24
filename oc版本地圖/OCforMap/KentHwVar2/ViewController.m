//
//  ViewController.m
//  KentHwVar2
//
//  Created by student on 2022/1/6.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//#import "KCAnnotation.h"

@interface ViewController()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVC];
    [self locationManager];
    
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray*) locations{
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D coordinate = location.coordinate;
    CLLocationCoordinate2D storeCoordinate = coordinate;
    storeCoordinate.longitude += 0.001;
    storeCoordinate.latitude += 0.001;
    ViewController *annotation=[[ViewController alloc] init];
    annotation.coordinate = storeCoordinate;
    annotation.title = @"肯德基";
    annotation.subtitle = @"真好吃";
    [_mainMapView addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mainMapView setRegion:region animated:YES];
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"123");
    [self infoBtnPressed];
}
-(void)info{
    MKMapItem *nowLocation = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *secLocMark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(25.045164,121.515154) addressDictionary:nil];
    MKMapItem *secLoc = [[MKMapItem alloc] initWithPlacemark:secLocMark];

    NSArray *array = [[NSArray alloc] initWithObjects:nowLocation, secLoc, nil];
        // 設定導航模式是行車還是走路
        NSDictionary *param = [NSDictionary dictionaryWithObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];

        // 開啓內建的地圖
        [MKMapItem openMapsWithItems:array launchOptions:param];
    
}
- (void)infoBtnPressed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"肯德基"
                                                                   message:@"導航前往"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"前往"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
        [self info];
                                                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {}];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)initVC{
    self.locationManager = [[CLLocationManager alloc]init];
    //如果沒有授權則跳出授權提示
    if ([CLLocationManager locationServicesEnabled] == false){}
    [_locationManager requestAlwaysAuthorization];
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeFitness;
    _locationManager.delegate=self;
    [_locationManager startUpdatingLocation];
    self.mainMapView.delegate = self;
    self.mainMapView.showsUserLocation = YES;

}

- (void)locateToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    CLLocationCoordinate2D center = {latitude , longitude};
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    MKCoordinateRegion region = {center,span};
    [self.mainMapView setRegion:region animated:YES];
    
    
}
- (IBAction)mapTypeChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _mainMapView.mapType = MKMapTypeStandard;
    }else if (sender.selectedSegmentIndex == 1){
        _mainMapView.mapType = MKMapTypeSatellite;
    }else if (sender.selectedSegmentIndex == 2){
        _mainMapView.mapType = MKMapTypeHybrid;
    }else if (sender.selectedSegmentIndex == 3){
        _mainMapView.mapType = MKMapTypeHybridFlyover;
        [self locateToLatitude:35.710093 longitude:139.8107];
        MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate: CLLocationCoordinate2DMake(35.710093, 139.8107) fromDistance:800 pitch:60 heading:0];
        _mainMapView.camera=camera;
            
    }
}


@end
