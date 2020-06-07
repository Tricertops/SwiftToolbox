//
//  Measurement.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Type Aliases

public typealias Acceleration = Measurement<UnitAcceleration>
public typealias Angle = Measurement<UnitAngle>
public typealias Area = Measurement<UnitArea>
public typealias ConcentrationMass = Measurement<UnitConcentrationMass>
public typealias Dispersion = Measurement<UnitDispersion>
public typealias Duration = Measurement<UnitDuration>
public typealias ElectricCharge = Measurement<UnitElectricCharge>
public typealias ElectricCurrent = Measurement<UnitElectricCurrent>
public typealias ElectricPotentialDifference = Measurement<UnitElectricPotentialDifference>
public typealias ElectricResistance = Measurement<UnitElectricResistance>
public typealias Energy = Measurement<UnitEnergy>
public typealias Frequency = Measurement<UnitFrequency>
public typealias FuelEfficiency = Measurement<UnitFuelEfficiency>
public typealias Illuminance = Measurement<UnitIlluminance>
public typealias Length = Measurement<UnitLength>
public typealias Mass = Measurement<UnitMass>
public typealias Power = Measurement<UnitPower>
public typealias Pressure = Measurement<UnitPressure>
public typealias Speed = Measurement<UnitSpeed>
public typealias Temperature = Measurement<UnitTemperature>
public typealias Volume = Measurement<UnitVolume>


//MARK: - Constructing

extension Measurement where UnitType: Dimension {
    
    /// Measurement of NaN in base unit.
    public static var nan: Self {
        Self(value: .nan, unit: UnitType.baseUnit())
    }
}


//MARK: - Arithmetics

extension Measurement {
    
    /// Negates the value.
    public static prefix func - (measurement: Self) -> Self {
        Self(value: -measurement.value, unit: measurement.unit)
    }
}

