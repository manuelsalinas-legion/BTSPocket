//
//  TimesheetViewModel.swift
//  BTSPocket
//
//  Created by bts on 23/06/21.
//

import Foundation
import JTAppleCalendar

struct TimesheetViewModel {
    func getUserTimesheets(_ startDate: String, _ endDate: String, _ completition: @escaping( ( Result<[GetTimesheets], Error>) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id {
            let urlTimesheet = Constants.Endpoints.getUserTimesheet.replacingOccurrences(of: "{userId}", with: String(userId))
            let urlTimesheetRequest = "\(Constants.serverAddress)\(urlTimesheet)?fromDate=\(String(describing: startDate))&toDate=\(String(describing: endDate))"
            BTSApi.shared.platformEP.getMethod(urlTimesheetRequest) { (timesheetResponse: UserTimesheetsResponse) in
                if let userTimesheets = timesheetResponse.data?.timesheets {
                    completition(.success(userTimesheets))
                }
            } onError: { (error) in
                completition(.failure(error))
            }
        }
    }
}
