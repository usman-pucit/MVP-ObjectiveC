//
//  VehiclesMapviewTests.m
//  MVP_ExampleTests
//
//  Created by Malik Usman on 24/08/2019.
//  Copyright © 2019 usmanSystems. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VehiclesMapViewPresenter.h"
#import "VehicleListModel.h"
#import "PoiList.h"
#import <MapKit/MapKit.h>
#import "Coordinate.h"
#import "Networking.h"
#import "VehiclesMapController.h"
#import "HelperMethods.h"


@interface VehiclesMapviewTests : XCTestCase
{
    VehiclesMapController *controller;
}
@end

@implementation VehiclesMapviewTests


- (void)setUp {
    
    controller = [VehiclesMapController new];
}

- (void)tearDown {
    
    controller = nil;
}


/// Method to fetch vehicles list method in viewmodel
/// Test Crieteria is to return response object on success and error on failure

- (void) testFetchVehiclesListWithMapviewRect
{
    MKMapView *mapView = controller.mapView;
    __block BOOL waitingForBlock = YES;
    
    [VehiclesMapViewPresenter getVehiclesListResquest:mapView.visibleMapRect inSucess:^(NSArray * _Nonnull responseObject) {
        
        if (responseObject)
        {
            waitingForBlock = NO;
            XCTAssert(responseObject);
        }
        else
        {
            waitingForBlock = NO;
            XCTAssert(NO, "Fail");
        }
        
    } failureBlock:^(NSError * _Nonnull error) {
       
        waitingForBlock = NO;
        XCTAssert(NO, "Fail");
    }];
    
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

/// Method to get vehicles list called in view controller and gives a callback return
/// Test Crieteria is to return response object on success and error on failure


-(void) testGetVehiclesListResquest
{
    MKMapView *mapView = controller.mapView;
    __block BOOL waitingForBlock = YES;
    
    [VehiclesMapViewPresenter getVehiclesListResquest:mapView.visibleMapRect inSucess:^(NSArray * _Nonnull responseObject) {
        
        if (responseObject)
        {
            waitingForBlock = NO;
            XCTAssert(responseObject);
        }
        else
        {
            waitingForBlock = NO;
            XCTAssert(NO, "Fail");
        }
        
    } failureBlock:^(NSError * _Nonnull error) {
        
        waitingForBlock = NO;
        XCTAssert(NO, "Fail");
    }];
    
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}


/// Method to check SW coordianates method
/// Test Crieteria is with provided rect always return the same known result


- (void) testGetSWCoordinateMethod
{
    MKMapRect rect = MKMapRectMake(0, 0, 0, 0);
    CLLocationCoordinate2D bottomLeft = [VehiclesMapViewPresenter getSWCoordinate:rect];

    XCTAssertEqual(bottomLeft.latitude, 85.051128779806589);
    XCTAssertEqual(bottomLeft.longitude, -180);
    
}

/// Method to check NE coordianates method
/// Test Crieteria is with provided rect always return the same known result


- (void) testGetNECoordinateMethod
{
    MKMapRect rect = MKMapRectMake(0, 0, 0, 0);
    CLLocationCoordinate2D topRight = [VehiclesMapViewPresenter getNECoordinate:rect];

    XCTAssertEqual(topRight.latitude, 85.051128779806589);
    XCTAssertEqual(topRight.longitude, -180);
}


/// Method to check parsing method working perfectly
/// Test Crieteria is parse a pre-defined JSON file and compare the values after parsing is done


- (void) testJsonParsingWorking
{
    
    NSDictionary *dict =  [HelperMethods JSONFromFile];
    
    VehicleListModel * model = [VehicleListModel modelObjectWithDictionary:(NSDictionary*)dict];
    
    XCTAssertEqual(model.poiList.count, 2);
    XCTAssertEqual([[model.poiList objectAtIndex:0] poiListIdentifier], 1);
    XCTAssertEqual([[model.poiList objectAtIndex:1] poiListIdentifier], 2);
}


/// Method to check creating mapview annotations method working fine
/// Test Crieteria with pre defined data set return annotations and annotations have same data values


- (void) testPrepareMapviewAnnoations
{
    NSDictionary *dict =  [HelperMethods JSONFromFile];
    
    VehicleListModel * model = [VehicleListModel modelObjectWithDictionary:(NSDictionary*)dict];
    NSArray *array = [[VehiclesMapViewPresenter prepareMapviewAnnoations:model.poiList] copy];
    
    MKPointAnnotation* annotationOne = [array objectAtIndex:0];
    MKPointAnnotation* annotationTwo = [array objectAtIndex:1];
    
    XCTAssertEqual(array.count, 2);
    XCTAssertEqual(annotationOne.coordinate.latitude, 50.0);
    XCTAssertEqual(annotationTwo.coordinate.latitude, 100.0);
}


@end
