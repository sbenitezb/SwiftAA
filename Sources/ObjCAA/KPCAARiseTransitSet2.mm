//
//  KPCAARiseTransitSet2.cpp
//  ObjCAA
//
//  Created by Vincent Neo on 8/10/20.
//  Copyright © 2020 onekiloparsec. All rights reserved.
//

#import "KPCAARiseTransitSet2.h"
#import "AARiseTransitSet2.h"

NSArray<KPCAARiseTransitSetDetails2 *> *KPCAARiseTransitSet2_Calculate(double StartJD,
                                        double EndJD,
                                        KPCAARiseTransitSetObject object,
                                        double Longitude,
                                        double Latitude,
                                        double h0,
                                        double height,
                                        double stepInterval,
                                        bool bHighPrecision) {
    CAARiseTransitSet2::Object obj = (CAARiseTransitSet2::Object) object;
    std::vector<CAARiseTransitSetDetails2> detailsPlus = CAARiseTransitSet2::Calculate(StartJD, EndJD, obj, Longitude, Latitude, h0, height, stepInterval, bHighPrecision);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for(auto&& caaDetails: detailsPlus) {
        KPCAARiseTransitSetDetails2* details = [[KPCAARiseTransitSetDetails2 alloc] init];
        details.type = (KPCAARiseTransitSetType) caaDetails.type;
        details.JD = caaDetails.JD;
        details.bearing = caaDetails.Bearing;
        details.geometricAltitude = caaDetails.GeometricAltitude;
        details.bAboveHorizon = caaDetails.bAboveHorizon;
        [array addObject:details];
    }
    
    return array;
}

NSArray<KPCAARiseTransitSetDetails2 *> *KPCAARiseTransitSet2_CalculateMoon(double StartJD,
                                            double EndJD,
                                            double Longitude,
                                            double Latitude,
                                            double height,
                                                                           double stepInterval) {
    std::vector<CAARiseTransitSetDetails2> detailsPlus = CAARiseTransitSet2::CalculateMoon(StartJD, EndJD, Longitude, Latitude, height, stepInterval);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for(auto&& caaDetails: detailsPlus) {
        KPCAARiseTransitSetDetails2* details = [[KPCAARiseTransitSetDetails2 alloc] init];
        int type = (int) caaDetails.type;
        details.type = (KPCAARiseTransitSetType) type;
        details.JD = caaDetails.JD;
        details.bearing = caaDetails.Bearing;
        details.geometricAltitude = caaDetails.GeometricAltitude;
        details.bAboveHorizon = caaDetails.bAboveHorizon;
        [array addObject:details];
    }
    
    return array;
}

NSArray<KPCAARiseTransitSetDetails2 *> *KPCAARiseTransitSet2_CalculateStationary(double StartJD,
                                                                                 double EndJD,
                                                                                 double Alpha,
                                                                                 double Delta,
                                                                                 double Longitude,
                                                                                 double Latitude,
                                                                                 double h0,
                                                                                 double stepInterval) {
    std::vector<CAARiseTransitSetDetails2> detailsPlus = CAARiseTransitSet2::CalculateStationary(StartJD, EndJD, Alpha, Delta, Longitude, Latitude, h0, stepInterval);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for(auto&& caaDetails: detailsPlus) {
        KPCAARiseTransitSetDetails2* details = [[KPCAARiseTransitSetDetails2 alloc] init];
        details.type = (KPCAARiseTransitSetType) caaDetails.type;
        details.JD = caaDetails.JD;
        details.bearing = caaDetails.Bearing;
        details.geometricAltitude = caaDetails.GeometricAltitude;
        details.bAboveHorizon = caaDetails.bAboveHorizon;
        [array addObject:details];
    }
    
    return array;
}
