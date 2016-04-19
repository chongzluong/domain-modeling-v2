//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Modified by Timothy Luong on 04/12/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

// Protocols
protocol CustomStringConvertible {
    // Human-readable representation
    var description : String{get}
}

protocol Mathematics {
    func + (left: Money, right: Money) -> Money
    func - (left: Money, right: Money) -> Money
}

// Double Extension
extension Double {
    var USD: Money { return Money(amount: self, currency: "USD") }
    var EUR: Money { return Money(amount: self, currency: "EUR") }
    var GBP: Money { return Money(amount: self, currency: "GBP") }
    var YEN: Money { return Money(amount: self, currency: "YEN") } // Not sure if YEN was a typo
    var CAN: Money { return Money(amount: self, currency: "CAN") }
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
  public var amount : Double
  public var currency : String
  
    public var description : String {
        get{return currency + String(amount)}
    }
    
  init(amount: Double, currency: String) {
    self.amount = amount
    if (currency == "USD" || currency == "GBP" || currency == "EUR" || currency == "CAN") {
        self.currency = currency
    } else {
        print(currency + " is not a valid currency type")
        exit(1)
    }
  }
  
  public func convert(to: String) -> Money {
    // Convert to US first
    if currency == "USD" {
        if to == "GBP" {
            return Money(amount: amount * 0.5, currency: "GBP")
        } else if to == "EUR" {
            return Money(amount: amount * 1.5, currency: "EUR")
        } else if to == "CAN" {
            return Money(amount: amount * 1.25, currency: "CAN")
        }
    } else if currency == "GBP" {
        if to == "USD" {
            return Money(amount: amount * 2, currency: "USD")
        } else if to == "EUR" {
            return Money(amount: amount * 3, currency: "EUR")
        } else if to == "CAN" {
            return Money(amount: amount * 2.5, currency: "CAN")
        }
    } else if currency == "EUR" {
        if to == "GBP" {
            return Money(amount: amount * (1.0 / 3.0), currency: "GBP")
        } else if to == "USD" {
            return Money(amount: amount * (2.0 / 3.0), currency: "USD")
        } else if to == "CAN" {
            return Money(amount: amount * (5.0 / 6.0), currency: "CAN")
        }
    } else if currency == "CAN" {
        if to == "GBP" {
            return Money(amount: amount * 0.4, currency: "GBP")
        } else if to == "EUR" {
            return Money(amount: amount * 1.2, currency: "EUR")
        } else if to == "USD" {
            return Money(amount: amount * 0.8, currency: "USD")
        }
    }
    print("Invalid currency type")
    return Money(amount: amount, currency: currency)
  }
  
  public func add(to: Money) -> Money {
    let converted = self.convert(to.currency)
    return Money(amount: converted.amount + to.amount, currency: to.currency)
  }
    
  public func subtract(from: Money) -> Money {
    let converted = self.convert(from.currency)
    return Money(amount: from.amount - converted.amount, currency: from.currency)
  }
}

func +(left: Money, right: Money) -> Money {
    return Money(amount: left.amount + right.convert(left.currency).amount, currency: left.currency)
}

func -(left: Money, right: Money) -> Money {
    return Money(amount: left.amount - right.convert(left.currency).amount, currency: left.currency)
}

////////////////////////////////////
// Job
//
public class Job {
  public var title: String
  public var type: JobType
  
  public enum JobType {
    case Hourly(Double)
    case Salary(Double)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  public func calculateIncome(hours: Double) -> Double {
    switch type {
    case .Hourly(let pay):
        return pay * hours
    case .Salary(let pay):
        return pay
    }
  }
  
  public func raise(amt : Double) {
    switch type {
    case .Hourly(let pay):
        type = .Hourly(pay + amt)
    case .Salary(let pay):
        type = .Salary(pay + amt)
    }
  }
}

////////////////////////////////////
// Person
//
public class Person {
  public var firstName : String = ""
  public var lastName : String = ""
  public var age : Int = 0

  private var _job: Job? = nil
  public var job : Job? {
    get {
        if age < 16 {
            return nil
        } else {
            return self._job
        }
    }
    set(newJob) {
        self._job = newJob
    }
  }
  
  private var _spouse: Person? = nil
  public var spouse : Person? {
    get {
        if age < 18 {
            return nil
        }
        return self._spouse
    }
    set(newSpouse) {
        self._spouse = newSpouse
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  public func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
  }
}

////////////////////////////////////
// Family
//
public class Family {
  private var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse != nil || spouse2.spouse != nil || (spouse1.age < 21 && spouse2.age < 21)) {
        print("Either one of the spouses is already married or neither is at least 21")
        exit(1)
    }
    members.append(spouse1)
    members.append(spouse2)
  }
  
  public func haveChild(child: Person) -> Bool {
    members.append(child)
    return true
  }
  
  public func householdIncome() -> Double {
    var result = 0.0
    for people in members {
        if people.job != nil {
            result += people.job!.calculateIncome(2000)
        }
    }
    return result
  }
}





