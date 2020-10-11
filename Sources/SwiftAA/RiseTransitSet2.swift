//
//  RiseTransitSet.swift
//  SwiftAA
//
//  Created by Cédric Foellmi on 17/12/2016.
//  MIT Licence. See LICENCE file.
//

import Foundation
import ObjCAA

/// The RiseTransitSetTimesDetails struct encompasses all elements of the times of rise, transit and set.
public struct RiseTransitSetTimesDetails2 {
    var julianDay: JulianDay
    var bearing: Double
    var geometricAltitude: Double
    var bAboveHorizon: Bool
}


/// Calculate the rise, transit and set times of a celestial body for a given
/// location on Earth.
///
/// One must correct the instants of the geometric rise and set of the center
/// of the celestial body by the athomspheric refraction. Because of it, the
/// body is actually below the horizon at the instant of its apparent rise or set.
/// The value of 0º34' is generally adopted for the effect of refraction
/// at the horizon. For the Sun, the calculated times generally refer to the
/// apparent rise or set of the upper limb of the disk, hence, 0º16'
/// should be added to the semidiameter
///
/// Actually, the amount of refraction changes with air temperature, pressure and
/// the elevation of the observer. A change of temperature from winter to summer
/// can shift the times of sunrise and sunset by about 20 secondes in mid-northern
/// and mid-southern latitudes. Similarly, observing sunrise or sunset over
/// a range of barometric pressures leads to a variation of a dozen seconds in the
/// times. However, in this chapter we shall use a mean value of the atmospheric
/// refraction at the horizon, namely the value of 0º34' mentionned above.
///
/// Notes:
/// The geographic longitude must be expressed postively west from Greenwhich,
/// in degrees.
/// The standard altitude, i.e. the geometric altitude of the center of the body
/// at the time of apparent rising, setting, namely:
/// h0 = -0º34' = 0º.5667 for stars and planets
/// h0 = -0º50' = 0º.8333 for the sun
/// h0 = +0º.125 for the moon
/// Actually, for the moon h0 is not constant. See p.102 of AA.
///
/// - Parameters:
///   - julianDay: the date at which one want to compute the times. MUST BE SET AT 0h UT for the given DAY.
///   - equCoords1: the equatorial coordinates of the body at Date - 1 Day.
///   - equCoords2: the equatorial coordinates of the body at Date.
///   - equCoords3: the equatorial coordinates of the body at Date + 1 Day.
///   - geoCoords: the location on Earth, with its altitude set to the standard one (see above)
/// - Returns: the times of rise, transit and set, with an indication if it is actually valid or not.
public struct RiseTransitSetTimes2 {
    public func riseTransitSet2Moon(fromJulianDay startJD: JulianDay,
                               toJulianDay endJD: JulianDay,
                               geoCoords: GeographicCoordinates, height: Double = 0, stepInterval: Double = 0.007) -> [Type : RiseTransitSetTimesDetails2]
    {
        // Do NOT pass Right Ascension values in degrees, as requested by AA+. It will be transformed later.
        // See CAARiseTransitSet::CalculateTransit, line 72.
        let details = KPCAARiseTransitSet2_CalculateMoon(startJD.UTCtoTT().value,
                                                         endJD.UTCtoTT().value,
                                                         geoCoords.longitude.value,
                                                         geoCoords.latitude.value,
                                                         height,
                                                         stepInterval)
        var dict = [Type : RiseTransitSetTimesDetails2]()
        for detail in details! {
            dict[detail.type] = RiseTransitSetTimesDetails2(julianDay: JulianDay(detail.jd), bearing: detail.bearing, geometricAltitude: detail.geometricAltitude, bAboveHorizon: detail.bAboveHorizon)
        }
        return dict
    }
}

/*
/// Convenient class for storing the Rise, Transit and Set times of a celestial body.
public struct RiseTransitSetTimes2 {
    private var details: RiseTransitSetTimesDetails2? = nil
    public fileprivate(set) var transitError: CelestialBodyTransitError? = nil
    public fileprivate(set) var geographicCoordinates: GeographicCoordinates
    public fileprivate(set) var riseSetAltitude: Degree
    
    
    /// Returns a new RiseTransitSetTimes object giving access to Rise, Transit and Set times of the provided body.
    ///
    /// - Parameters:
    ///   - celestialBody: The celestial body under study.
    ///   - geographicCoordinates: The geographic coordinates of the observer.
    ///   - riseSetAltitude: The altitude considered for rise and set times.
    public init(celestialBody: CelestialBody, geographicCoordinates: GeographicCoordinates, riseSetAltitude: Degree? = nil)
    {
        self.geographicCoordinates = geographicCoordinates
        self.riseSetAltitude = riseSetAltitude ?? type(of: celestialBody).apparentRiseSetAltitude
        
        // AA+ p.102 indicates one need to get day D at 0h Dynamical Time, thus, midnight UT.
        let jd = celestialBody.julianDay.midnight
        let hp = celestialBody.highPrecision
        
        let celestialBodyType = type(of: celestialBody)
        if (celestialBodyType is AstronomicalObject.Type) {
            self.details = riseTransitSet(forJulianDay: jd,
                                          equCoords1: celestialBody.equatorialCoordinates,
                                          equCoords2: celestialBody.equatorialCoordinates,
                                          equCoords3: celestialBody.equatorialCoordinates,
                                          geoCoords: geographicCoordinates,
                                          apparentRiseSetAltitude: AstronomicalObject.apparentRiseSetAltitude)
            
        } else {
            let body1: CelestialBody = celestialBodyType.init(julianDay: jd-1, highPrecision: hp)
            let body2: CelestialBody = celestialBodyType.init(julianDay: jd, highPrecision: hp)
            let body3: CelestialBody = celestialBodyType.init(julianDay: jd+1, highPrecision: hp)
            
            self.details = riseTransitSet(forJulianDay: jd,
                                          equCoords1: body1.equatorialCoordinates,
                                          equCoords2: body2.equatorialCoordinates,
                                          equCoords3: body3.equatorialCoordinates,
                                          geoCoords: self.geographicCoordinates,
                                          apparentRiseSetAltitude: self.riseSetAltitude)
            
        }
        
        if (!self.details!.isRiseValid && !self.details!.isSetValid) {
            self.transitError = (self.details!.isTransitAboveHorizon) ? .alwaysAboveAltitude : .alwaysBelowAltitude
        }
    }
        

    /// Returns a new RiseTransitSetTimes object with an error.
    ///
    /// - Parameters:
    ///   - geographicCoordinates: The geographic coordinates of the observer.
    ///   - riseSetAltitude: The altitude considered for rise and set times.
    public init(geographicCoordinates: GeographicCoordinates, transitError: CelestialBodyTransitError? = nil)
    {
        self.transitError = transitError
        self.geographicCoordinates = geographicCoordinates
        self.riseSetAltitude = Degree(0)
    }
    
    /// The rise time of the celestial body, in Julian Day.
    public var riseTime: JulianDay? {
        get { return (self.details != nil && self.details!.isRiseValid) ? self.details!.riseTime : nil }
    }
    
    /// The transit time of the celestial body, in Julian Day.
    public var transitTime: JulianDay? {
        get { return (self.details != nil && self.details!.isTransitAboveHorizon) ? self.details!.transitTime : nil }
    }
    
    /// The set time of the celestial body, in Julian Day.
    public var setTime: JulianDay? {
        get { return (self.details != nil && self.details!.isSetValid) ? self.details!.setTime : nil }
    }
}


*/
