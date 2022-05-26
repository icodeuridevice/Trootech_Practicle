
import Foundation

// MARK: - MenuModel
struct MenuModel: Codable {
    let data: [MenuData]?
}

// MARK: - Datum
struct MenuData: Codable {
  
    let modificadores: [Modificadore]?
    let idmenu, precioSugerido, nombre: String?
    let imagen: String?
    let codigo: String?
    let impuesto: Int?
    let codigoBarra: String?
    let precioAbierto: Bool?
    let comision, tipoComision: String?
    let descTipoComision: DescTipoComision?
    let impuestoAplicado: Bool?
    let tipo: String?
    let tipoDesc: TipoDesc?
    let descripcion: Descripcion?
    let permiteDescuentos: Bool?
    let categoria: Categoria?
    let categoriaEcommerce: CategoriaEcommerce?

    enum CodingKeys: String, CodingKey {
        case modificadores, idmenu, precioSugerido, nombre, imagen, codigo, impuesto, codigoBarra
        case precioAbierto = "precio_abierto"
        case comision
        case tipoComision = "tipo_comision"
        case descTipoComision, impuestoAplicado, tipo
        case tipoDesc = "tipo_desc"
        case descripcion
        case permiteDescuentos = "permite_descuentos"
        case categoria
        case categoriaEcommerce = "categoria_ecommerce"
    }
}

// MARK: - Categoria
struct Categoria: Codable {
    let idcategoriamenu, nombremenu, porcentaje, impuesto: String?
    let codigo: String?
    let orden: Int?
    let printers: [Printer]?
}

// MARK: - Printer
struct Printer: Codable {
    let idPrinter: String?
    let descPrinter: DescPrinter?
    let ip: IP?
    let idtipo: String?
    let descTipo: DescTipo?
    let isDouble, cutPaper: Bool?

    enum CodingKeys: String, CodingKey {
        case idPrinter = "id_printer"
        case descPrinter = "desc_printer"
        case ip, idtipo
        case descTipo = "desc_tipo"
        case isDouble, cutPaper
    }
}

enum DescPrinter: String, Codable {
    case suvlasMarbellaPrecuenta = "Suvlas Marbella Precuenta"
}

enum DescTipo: String, Codable {
    case comanda = "Comanda"
}

enum IP: String, Codable {
    case the1001215 = "10.0.1.215"
}

// MARK: - CategoriaEcommerce
struct CategoriaEcommerce: Codable {
    let idcategoriamenu: Int?
    let nombremenu: Nombremenu?
    let porcentaje, impuesto: Int?
    let codigo: Codigo?
}

enum Codigo: String, Codable {
    case sC = "S/C"
}

enum Nombremenu: String, Codable {
    case sinCategoriaEcommerce = "-Sin Categoria Ecommerce-"
}

enum DescTipoComision: String, Codable {
    case valor = "Valor"
}

enum Descripcion: String, Codable {
    case delicisiosoYogurt100GriegoConToppingDeFresa = "Delicisioso Yogurt 100% Griego con topping de fresa"
    case delicisiosoYogurt100GriegoConToppingDePiña = "Delicisioso Yogurt 100% Griego con topping de piña"
    case empty = ""
}

// MARK: - Modificadore
struct Modificadore: Codable {
    let idmodificador: String?
}

enum TipoDesc: String, Codable {
    case normal = "Normal"
}

