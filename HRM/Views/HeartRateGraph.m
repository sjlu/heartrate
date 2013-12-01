//
//  HeartRateGraph.m
//  heartrate
//
//  Created by Jonathan Grana on 11/30/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HeartRateGraph.h"

#import "BluetoothManager.h"
#import "HeartRateBeat.h"
#import "UIColor+HeartRate.h"

#import <CorePlot-CocoaTouch.h>

static const NSUInteger kMaxDataPoints  = 30;
static NSString *const kPlotIdentifier  = @"HeartRatePlot";

@interface HeartRateGraph()
<
CPTPlotDataSource
>

@property (nonatomic) NSMutableArray        *plotData;
@property (nonatomic) NSUInteger            currentIndex;
@property (nonatomic) CPTGraph              *graph;

@end

@implementation HeartRateGraph

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBluetoothNotificationHeartBeat object:nil];
    //Kill graph
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.plotData = [[NSMutableArray alloc] initWithCapacity:kMaxDataPoints];
        
        self.collapsesLayers = NO;
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        self.autoresizesSubviews = YES;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        CGRect bounds = self.bounds;
        
        self.graph = [[CPTXYGraph alloc] initWithFrame:bounds];
//        [self.graph applyTheme:[CPTTheme themeNamed:kTheme]];
        
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.color                = [CPTColor clearColor];
        textStyle.fontName             = @"Helvetica-Bold";
        textStyle.fontSize             = round( bounds.size.height / CPTFloat(20.0) );
        self.graph.titleTextStyle           = textStyle;
        self.graph.titleDisplacement        = CPTPointMake( 0.0, textStyle.fontSize * CPTFloat(1.5) );
        self.graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
        
        
        self.graph.paddingLeft = 0;
        
        if ( self.graph.titleDisplacement.y > 0.0 ) {
            self.graph.paddingTop = 0;
        }
        else {
            self.graph.paddingTop = 0;
        }
        
        self.graph.paddingRight  = 10;
        self.graph.paddingBottom = 0;
        
//        self.graph.plotAreaFrame.paddingTop    = 15.0;
//        self.graph.plotAreaFrame.paddingRight  = 15.0;
//        self.graph.plotAreaFrame.paddingBottom = 55.0;
//        self.graph.plotAreaFrame.paddingLeft   = 55.0;
        self.graph.plotAreaFrame.masksToBorder = NO;
        
        // Grid line styles
        CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
        majorGridLineStyle.lineWidth = 0.75;
        majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
        
        CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
        minorGridLineStyle.lineWidth = 0.25;
        minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
        
        // Axes
        // X axis
        self.graph.axisSet.hidden = YES;
//        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
//        CPTXYAxis *x          = axisSet.xAxis;
//        x.hidden = YES;
//        x.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
//        x.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
//        x.majorGridLineStyle          = majorGridLineStyle;
//        x.minorGridLineStyle          = minorGridLineStyle;
//        x.minorTicksPerInterval       = 9;
//        x.title                       = @"X Axis";
//        x.titleOffset                 = 35.0;
//        NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
//        labelFormatter.numberStyle = NSNumberFormatterNoStyle;
//        x.labelFormatter           = labelFormatter;
//        
        // Y axis
//        CPTXYAxis *y = axisSet.yAxis;
//        y.hidden = YES;
//        y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
//        y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
//        y.majorGridLineStyle          = majorGridLineStyle;
//        y.minorGridLineStyle          = minorGridLineStyle;
//        y.minorTicksPerInterval       = 3;
//        y.labelOffset                 = 5.0;
//        y.title                       = @"Y Axis";
//        y.titleOffset                 = 30.0;
//        y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
        
        // Rotatesthe labels by 45 degrees, just to show it can be done.
//        x.labelRotation = M_PI * 0.25;
        
        // Create the plot
        CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
        dataSourceLinePlot.identifier     = kPlotIdentifier;
        dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
        
        CPTMutableLineStyle *lineStyle = dataSourceLinePlot.dataLineStyle.mutableCopy;
        lineStyle.lineWidth              = 3.0;
        lineStyle.lineColor              = [CPTColor colorWithCGColor:UIColor.heartRateRed.CGColor];
        dataSourceLinePlot.dataLineStyle = lineStyle;
        
        dataSourceLinePlot.dataSource = self;
        [self.graph addPlot:dataSourceLinePlot];
        
        // Plot space
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(kMaxDataPoints - 2)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(220)];
        
        self.hostedGraph = self.graph;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(newHeartBeat:)
                                                     name:kBluetoothNotificationHeartBeat
                                                   object:nil];
    }
    return self;
}

//- (void)layoutSubviews {
//    self.graph.frame = self.bounds;
//    [self.graph reloadData];
//}

#pragma mark -
#pragma mark Timer callback

-(void)newHeartBeat:(NSNotification *)beat
{
    CPTPlot *thePlot = [self.graph plotWithIdentifier:kPlotIdentifier];
    
    if ( thePlot ) {
        if (self.plotData.count >= kMaxDataPoints ) {
            [self.plotData removeObjectAtIndex:0];
            [thePlot deleteDataInIndexRange:NSMakeRange(0, 1)];
        }
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
        NSUInteger location       = (self.currentIndex >= kMaxDataPoints ? self.currentIndex - kMaxDataPoints + 2 : 0);
        
        CPTPlotRange *newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(location)
                                                              length:CPTDecimalFromUnsignedInteger(kMaxDataPoints - 2)];
        
        [CPTAnimation animate:plotSpace
                     property:@"xRange"
                fromPlotRange:plotSpace.xRange
                  toPlotRange:newRange
                     duration:CPTFloat(1.0f)];
        
        self.currentIndex++;
        [self.plotData addObject:beat.object];
        [thePlot insertDataAtIndex:self.plotData.count - 1 numberOfRecords:1];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    for (CPTScatterPlot *plot in self.graph.allPlots) {
        CPTMutableLineStyle *lineStyle = plot.dataLineStyle.mutableCopy;
        lineStyle.lineWidth              = 3.0;
        lineStyle.lineColor              = [CPTColor colorWithCGColor:tintColor.CGColor];
        plot.dataLineStyle = lineStyle;
    }
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.plotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    
    switch ( fieldEnum ) {
        case CPTScatterPlotFieldX:
            num = [NSNumber numberWithUnsignedInteger:index + self.currentIndex - self.plotData.count];
            break;
            
        case CPTScatterPlotFieldY:
            num = [self.plotData objectAtIndex:index];
            break;
            
        default:
            break;
    }
    
    return num;
}

@end
