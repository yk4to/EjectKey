//
//  printDAReturn.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/08/23.
//

import Foundation

func printDAReturn(r: DAReturn) -> String {
    switch Int(r) {
    case kDAReturnError:
      return "Error"
    case kDAReturnBusy:
      return "Busy"
    case kDAReturnBadArgument:
      return "Bad Argument"
    case kDAReturnExclusiveAccess:
      return "Exclusive Access"
    case kDAReturnNoResources:
      return "No Resources"
    case kDAReturnNotFound:
      return "Not Found"
    case kDAReturnNotMounted:
      return "Not Mounted"
    case kDAReturnNotPermitted:
      return "Not Permitted"
    case kDAReturnNotPrivileged:
      return "Not Privileged"
    case kDAReturnNotReady:
      return "Not Ready"
    case kDAReturnNotWritable:
      return "Not Writable"
    case kDAReturnUnsupported:
      return "Unsupported"
    default:
      return "Unknown"
    }
  }
