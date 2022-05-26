
import Foundation

struct FranquiciasModel : Codable {
    
	let franquicias : [Franquicias]?

	enum CodingKeys: String, CodingKey {

		case franquicias = "franquicias"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		franquicias = try values.decodeIfPresent([Franquicias].self, forKey: .franquicias)
	}

}

struct Franquicias : Codable {
    
    let aPIKEY : String?
    let tokenInvu : String?
    let negocio : String?
    let principal : Bool?
    let id_franquicia : String?
    let franquicia : String?
    let horaCierreLocal : String?

    enum CodingKeys: String, CodingKey {

        case aPIKEY = "APIKEY"
        case tokenInvu = "tokenInvu"
        case negocio = "negocio"
        case principal = "principal"
        case id_franquicia = "id_franquicia"
        case franquicia = "franquicia"
        case horaCierreLocal = "horaCierreLocal"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aPIKEY = try values.decodeIfPresent(String.self, forKey: .aPIKEY)
        tokenInvu = try values.decodeIfPresent(String.self, forKey: .tokenInvu)
        negocio = try values.decodeIfPresent(String.self, forKey: .negocio)
        principal = try values.decodeIfPresent(Bool.self, forKey: .principal)
        id_franquicia = try values.decodeIfPresent(String.self, forKey: .id_franquicia)
        franquicia = try values.decodeIfPresent(String.self, forKey: .franquicia)
        horaCierreLocal = try values.decodeIfPresent(String.self, forKey: .horaCierreLocal)
    }

}
