// UserState.swift
// Copyright (C) 2020 Presidenza del Consiglio dei Ministri.
// Please refer to the AUTHORS file for more information.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import Foundation
import Models

/// Slice of state related to the user
struct UserState: Codable {
  /// The user's province
  var province: Province?

  /// The date of the last service not active local notification
  var lastServiceNotActiveDate = Date.distantPast

  /// The current user's covid status
  var covidStatus: CovidStatus = .neutral
    
  /// The Digital Green Certificate
  var greenCertificates: [GreenCertificate]?
}
struct GreenCertificate: Codable {

  /// The Dgc's id
  var id: String
    
  /// The owner's name
  var name: String
    
  /// The owner's birth
  var birth: String
    
  /// The Digital Green Certificate
  var greenCertificate: String
    
  /// The Digital Green Certificate detail
  var detailGreenCertificate: DetailDigitalGreenCertificate


}
public struct DetailDigitalGreenCertificate: Codable {

   var disease: String
   var vaccineType: String
   var vaccineName: String
   var vaccineProducer: String
   var numberOfDoses: String
   var dateLastAdministration: String
   var vaccinationCuntry: String
   var certificateAuthority: String
   var paragraph: String
   var url: String
    
  // swiftlint:enable force_unwrapping
}


