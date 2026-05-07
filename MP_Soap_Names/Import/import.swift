import Foundation
import TabularData
import SwiftData

func importBundledCSV(modelContext: ModelContext) {
    guard let url = Bundle.main.url(forResource: "names", withExtension: "csv") else {
        print("Bundled names.csv not found in app bundle")
        return
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    do {
        let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")
        let dataFrame = try DataFrame(contentsOfCSVFile: url, options: options)

        for row in dataFrame.rows {
            guard let dbid = (row["MP_ID"]).map({ String(describing: $0) }),
                  let firstname = row["First"] as? String,
                  let lastname = row["Last"] as? String,
                  let gender = row["gender"] as? String,
                  let db = row["DB"] as? String
            else { continue }

            let dob = (row["Birthday"] as? String).flatMap { dateFormatter.date(from: $0) }
            let start = (row["FirstRecord"] as? String).flatMap { dateFormatter.date(from: $0) }
            let end = (row["RecentRecord"] as? String).flatMap { dateFormatter.date(from: $0) }
            let count = (row["visitCount"] as? Int) ?? Int(row["visitCount"] as? String ?? "") ?? 0

            let newPerson = Name(dbid: dbid, lastname: lastname, firstname: firstname, gender: gender, dob: dob, startDate: start, endDate: end, count: count, dbSource: db)
            modelContext.insert(newPerson)
        }

        try modelContext.save()
    } catch {
        print("Failed to import bundled CSV: \(error)")
    }
}

func importCSV(url: URL, modelContext: ModelContext) {
    guard url.startAccessingSecurityScopedResource() else {
        print("Failed to access security-scoped resource: \(url)")
        return
    }
    defer { url.stopAccessingSecurityScopedResource() }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    do {
        let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")
        let dataFrame = try DataFrame(contentsOfCSVFile: url, options: options)

        for row in dataFrame.rows {
            guard let dbid = (row["MP_ID"]).map({ String(describing: $0) }),
                  let firstname = row["First"] as? String,
                  let lastname = row["Last"] as? String,
                  let gender = row["gender"] as? String,
                  let db = row["DB"] as? String
            else { continue }

            let dob = (row["Birthday"] as? String).flatMap { dateFormatter.date(from: $0) }
            let start = (row["FirstRecord"] as? String).flatMap { dateFormatter.date(from: $0) }
            let end = (row["RecentRecord"] as? String).flatMap { dateFormatter.date(from: $0) }
            let count = (row["visitCount"] as? Int) ?? Int(row["visitCount"] as? String ?? "")  ?? 0

            let newPerson = Name(dbid: dbid, lastname: lastname, firstname: firstname, gender: gender, dob: dob, startDate: start, endDate: end, count: count, dbSource: db)
            modelContext.insert(newPerson)
        }

        try modelContext.save()
    } catch {
        print("Failed to import CSV: \(error)")
    }
}
