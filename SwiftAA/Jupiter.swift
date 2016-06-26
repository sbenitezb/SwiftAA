//
//  Jupiter.swift
//  SwiftAA
//
//  Created by Cédric Foellmi on 19/06/16.
//  Copyright © 2016 onekiloparsec. All rights reserved.
//

import Foundation

public struct Jupiter: Planet {
    public var julianDay: JulianDay
    public var eclipticObject: KPCEclipticObject { return .Jupiter }
    public var planet: KPCPlanetaryObject { return .JUPITER }
    
    public init(julianDay: JulianDay) {
        self.julianDay = julianDay
    }
    
    public static var color: Color {
        get { return Color(red: 0.647, green:0.608, blue:0.576, alpha: 1.0) }
    }
}
