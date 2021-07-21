//
//  TimesheetViewModel.swift
//  BTSPocket
//
//  Created by bts on 23/06/21.
//

import Foundation
import JTAppleCalendar

typealias postTimesheet = [String: Any]

struct TimesheetViewModel {
    func postUserTimesheet(_ date: String?, _ dayTimesheet: Timesheet? = nil, _ newTimesheet: TimesheetDescriptionsObject, _ completition: @escaping( ( Result<String, Error>) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id,
           let date = date {
            let url = Constants.Endpoints.userTimesheet.replacingOccurrences(of: "{userId}", with: String(userId))
            let urlRequest = "\(Constants.serverAddress)\(url)"
            var postDescriptions: [TimesheetDescriptionsObject] = []
            if let descriptions = dayTimesheet?.descriptions {
                for description in descriptions {
                    let aDescription = TimesheetDescriptionsObject(
                        projectId: description.projectId,
                        dedicatedHours: description.dedicatedHours,
                        task: description.task,
                        isHappy: description.isHappy,
                        note: description.note
                    )
                    postDescriptions.append(aDescription)
                }
            }
            postDescriptions.append(newTimesheet)
            let postParams = TimesheetObject(date: date, descriptions: postDescriptions)
            
            let params: [String: Any] = [
                "date": date,
                "descriptions": postDescriptions.map( { $0.getDiccionary() } )
            ]
            print(params)
            BTSApi.shared.platformEP.postMethod(urlRequest, nil, params) { (timesheetResponse: UserTimesheetsResponse) in
                completition(.success(""))
            } onError: { (error) in
                print(error.localizedDescription)
                completition(.failure(error))
            }

        }
    }
    
    func getUserTimesheets(_ startDate: String, _ endDate: String, _ completition: @escaping( ( Result<[Timesheet], Error>) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id {
            let urlTimesheet = Constants.Endpoints.userTimesheet.replacingOccurrences(of: "{userId}", with: String(userId))
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
    
    func updateUserTimesheet(_ dayTimesheet: Timesheet?, _ completition: @escaping( (Result<String,Error>) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id,
           let date = dayTimesheet?.date,
           let descriptions = dayTimesheet?.descriptions {
            let urlTimesheet = Constants.Endpoints.userTimesheet.replacingOccurrences(of: "{userId}", with: String(userId))
            let urlTimesheetRequest = "\(Constants.serverAddress)\(urlTimesheet)"
            let dateString = String(date.prefix(10))
            var updateDescriptions: [TimesheetDescriptionsObject] = []
            
            for description in descriptions {
                let aDescription = TimesheetDescriptionsObject(
                    projectId: description.projectId,
                    dedicatedHours: description.dedicatedHours,
                    task: description.task,
                    isHappy: description.isHappy,
                    note: description.note
                )
                updateDescriptions.append(aDescription)
            }
            
            let params: [String: Any] = [
                "date": dateString,
                "descriptions": updateDescriptions.map( { $0.getDiccionary() } )
            ]
            BTSApi.shared.platformEP.postMethod(urlTimesheetRequest, nil, params) { (resultUpdate: UserTimesheetsResponse) in
                print(resultUpdate.message)
                completition(.success(""))
            } onError: { error in
                print(error)
                completition(.failure(error))
            }
        }
    }
    
    func deleteUserTimesheet(_ date: String, _ completition: @escaping( (Result<Bool, Error>) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id {
            let urlTimesheet = Constants.Endpoints.userTimesheet.replacingOccurrences(of: "{userId}", with: String(userId))
            let urlTimesheetRequest = "\(Constants.serverAddress)\(urlTimesheet)?date=\(date)"
            BTSApi.shared.platformEP.deleteMethod(urlTimesheetRequest) { (timesheetResponse: UserTimesheetsResponse) in
                if let response = timesheetResponse.message,
                   response == "success" {
                    completition(.success(true))
                }
            } onError: { error in
                completition(.failure(error))
            }

        }
    }
    
}
