import Foundation
import OSLog

struct ParallelumService: VehicleServiceProtocol {
    let baseUrl = "https://fipe.parallelum.com.br/api/v2/"
    
    private func createRequestWithAuthentication(for urlString: String, method: String = "GET") throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "CHAVE_PARALLELUM") as? String {
            request.setValue(apiKey, forHTTPHeaderField: "X-Subscription-Token")
        }
        
        return request
    }
    
    func fetchBrands(vehicleType: String) async throws -> [BrandResponse] {
        let urlString = baseUrl + vehicleType + "/brands"
        let request = try createRequestWithAuthentication(for: urlString)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let message = String(data: data, encoding: .utf8) ?? "Error"
            Logger.network.error("HTTP ERROR: \(httpResponse.statusCode) - \(message)")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let container = try decoder.decode([BrandResponse].self, from: data)
        return container
    }
    
    func fetchModels(request: ModelFipeRequest) async throws -> [ModelFipeResponse] {
        let urlString = baseUrl + request.vehicleType + "/brands/\(request.brandId)/models"
        let urlRequest = try createRequestWithAuthentication(for: urlString)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let message = String(data: data, encoding: .utf8) ?? "Error"
            Logger.network.error("HTTP ERROR: \(httpResponse.statusCode) - \(message)")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode([ModelFipeResponse].self, from: data)
    }
    
    func fetchYears(request: YearRequest) async throws -> [YearResponse] {
        Logger.network.error("Fetching years for model: \(request.modelId)")
        let urlString = baseUrl + request.vehicleType + "/brands/\(request.brandId)/models/\(request.modelId)/years"
        
        let urlRequest = try createRequestWithAuthentication(for: urlString)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let message = String(data: data, encoding: .utf8) ?? "Error"
            Logger.network.error("HTTP ERROR: \(httpResponse.statusCode) - \(message)")          
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode([YearResponse].self, from: data)
    }
    
    func fetchFipeInformation(request: FipeInformationRequest) async throws -> FipeInformationResponse {
        let urlString = baseUrl + request.vehicleType + "/brands/\(request.brandId)/models/\(request.modelId)/years/\(request.yearId)"
        let urlRequest = try createRequestWithAuthentication(for: urlString)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let message = String(data: data, encoding: .utf8) ?? "Error"
            Logger.network.error("HTTP ERROR: \(httpResponse.statusCode) - \(message)")
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(FipeInformationResponse.self, from: data)
    }
}
