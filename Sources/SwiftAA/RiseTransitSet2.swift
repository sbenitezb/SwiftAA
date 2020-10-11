//
//  RiseTransitSet2.swift
//  SwiftAA
//
//  Created by Vincent Neo on 11/10/2020.
//  MIT Licence. See LICENCE file.
//

import Foundation
import ObjCAA

public enum RiseTransitSetType: Int {
    case notDefined,
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
}

public struct RiseTransitSetTimesDetails2 {
    public var type: RiseTransitSetType
    public var julianDay: JulianDay
    public var bearing: Double?
    public var geometricAltitude: Double?
    public var bAboveHorizon: Bool?
    
    public init(type: RiseTransitSetType, julianDay: JulianDay, bearing: Double, geometricAltitude: Double, bAboveHorizon: Bool) {
        self.type = type
        self.julianDay = julianDay
        if self.type == .rise || self.type == .set {
            self.bearing = bearing
        }
        if self.type == .southernTransit || self.type == .northernTransit {
            self.geometricAltitude = geometricAltitude
            self.bAboveHorizon = bAboveHorizon
        }
    }
}

public struct RiseTransitSetTimes2 {
    
    public static func calculate(fromJulianDay startJD: JulianDay,
                               toJulianDay endJD: JulianDay,
                               planet: KPCAARiseTransitSetObject,
                               geoCoords: GeographicCoordinates, apparentRiseSetAltitude: Degree, height: Double = 0, stepInterval: Double = 0.007, highPrecision: Bool = false) -> [RiseTransitSetTimesDetails2]
    {
        let details = KPCAARiseTransitSet2_Calculate(startJD.UTCtoTT().value,
                                                     endJD.UTCtoTT().value,
                                                     planet,
                                                     geoCoords.longitude.value,
                                                     geoCoords.latitude.value,
                                                     apparentRiseSetAltitude.value,
                                                     height,
                                                     stepInterval,
                                                     highPrecision)
        
        var detailsArr = [RiseTransitSetTimesDetails2]()
        for detail in details! {
            let converted = RiseTransitSetTimesDetails2(type: RiseTransitSetType(rawValue: detail.type.rawValue)!, julianDay: JulianDay(detail.jd).TTtoUTC(), bearing: detail.bearing, geometricAltitude: detail.geometricAltitude, bAboveHorizon: detail.bAboveHorizon)
            detailsArr.append(converted)
            
        }
        return detailsArr
    }

    public static func calculateStationary(fromJulianDay startJD: JulianDay,
                               toJulianDay endJD: JulianDay,
                               equatorialCoordinates: EquatorialCoordinates,
                               geoCoords: GeographicCoordinates, apparentRiseSetAltitude: Degree, stepInterval: Double = 0.007) -> [RiseTransitSetTimesDetails2]
    {
        let details = KPCAARiseTransitSet2_CalculateStationary(startJD.UTCtoTT().value,
                                                               endJD.UTCtoTT().value,
                                                               equatorialCoordinates.alpha.value,
                                                               equatorialCoordinates.delta.value,
                                                               geoCoords.longitude.value,
                                                               geoCoords.latitude.value,
                                                               apparentRiseSetAltitude.value,
                                                               stepInterval)
        
        var detailsArr = [RiseTransitSetTimesDetails2]()
        for detail in details! {
            let converted = RiseTransitSetTimesDetails2(type: RiseTransitSetType(rawValue: detail.type.rawValue)!, julianDay: JulianDay(detail.jd).TTtoUTC(), bearing: detail.bearing, geometricAltitude: detail.geometricAltitude, bAboveHorizon: detail.bAboveHorizon)
            detailsArr.append(converted)
            
        }
        return detailsArr
    }

}
