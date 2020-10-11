//
//  KPCAARiseTransitSet2.hpp
//  ObjCAA
//
//  Created by Vincent Neo on 8/10/20.
//  Copyright © 2020 onekiloparsec. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
typedef NS_ENUM(NSInteger, KPCAARiseTransitSetType) {
    notDefined = 0,
    rise,
    set,
    southernTransit,
    northernTransit,
    endCivilTwilight,
    endNauticalTwilight,
    endAstronomicalTwilight,
    startAstronomicalTwilight,
    startNauticalTwilight,
    startCivilTwilight
};

@interface KPCAARiseTransitSetDetails2: NSObject
@property KPCAARiseTransitSetType type;
@property double JD;
@property double bearing;
@property double geometricAltitude;
@property BOOL bAboveHorizon;

@end

@implementation KPCAARiseTransitSetDetails2

@synthesize type;
@synthesize JD;
@synthesize bearing;
@synthesize geometricAltitude;
@synthesize bAboveHorizon;


-(id)init {
   self = [super init];

   return self;
}

@end
typedef NS_ENUM(NSInteger, KPCAARiseTransitSetObject) {
    rtsSun,
    rtsMoon,
    rtsMercury,
    rtsVenus,
    rtsMars,
    rtsJupiter,
    rtsSaturn,
    rtsUranus,
    rtsNeptune,
    rtsPluto,
    rtsStar
};

NSArray<KPCAARiseTransitSetDetails2 *> *KPCAARiseTransitSet2_Calculate(double StartJD,
                                                                       double EndJD,
                                                                       KPCAARiseTransitSetObject object,
                                                                       double Longitude,
                                                                       double Latitude,
                                                                       double h0,
                                                                       double height,
                                                                       double stepInterval,
                                                                       bool bHighPrecision);

NSArray<KPCAARiseTransitSetDetails2 *> *KPCAARiseTransitSet2_CalculateMoon(double StartJD,
                                                                           double EndJD,
                                                                           double Longitude,
                                                                           double Latitude,
                                                                           double height,
                                                                           double stepInterval);

NSArray<KPCAARiseTransitSetDetails2 *> *KPCAARiseTransitSet2_CalculateStationary(double StartJD,
                                                                                 double EndJD,
                                                                                 double Alpha,
                                                                                 double Delta,
                                                                                 double Longitude,
                                                                                 double Latitude,
                                                                                 double h0,
                                                                                 double stepInterval);

#if __cplusplus
}
#endif
