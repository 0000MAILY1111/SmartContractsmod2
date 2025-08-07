# 🏆 Smart Contract Auction
Solidity Hardhat OpenZeppelin License

Un sistema de subasta descentralizada completo con ofertas automáticas, extensión de tiempo y manejo seguro de depósitos. Desplegado y verificado en Ethereum Sepolia.

## 🌐 Contrato Desplegado (Sepolia Testnet)
| Contrato | Dirección | Etherscan |
|----------|-----------|-----------|
| Auction |      0xD081f6693E2dF6d833e0026720F9Ce23d524229C  |

Contrato completamente verificado ✅ - Puedes revisar el código fuente directamente en Etherscan

## 🎯 Características Principales

### 🔥 Funcionalidades Core
✅ **Sistema de Ofertas** - Puja por artículos con incremento mínimo del 5%  
✅ **Ofertas Válidas** - Solo se aceptan ofertas superiores a la actual + 5%  
✅ **Ganador Automático** - Determinación automática del oferente ganador  
✅ **Lista de Ofertas** - Visualización completa de todas las pujas realizadas  
✅ **Devolución de Depósitos** - Reembolso automático con comisión del 2%  

### 🚀 Funcionalidades Avanzadas
✅ **Reembolso Parcial** - Retira ofertas anteriores superadas durante la subasta  
✅ **Extensión Automática** - +10 min si hay ofertas en los últimos 10 minutos  
✅ **Modifiers de Seguridad** - Control de acceso y validaciones robustas  
✅ **Sistema de Eventos** - Notificaciones en tiempo real de cambios de estado  
✅ **Manejo de Errores** - Validación completa y manejo de excepciones  

### 🔐 Seguridad
✅ **OpenZeppelin Contracts** - Estándares seguros para contratos inteligentes  
✅ **Reentrancy Protection** - Protección contra ataques de reentrada  
✅ **Access Control** - Sistema robusto de permisos y validaciones  
✅ **Overflow Protection** - SafeMath para operaciones matemáticas seguras  

## 📊 Estadísticas del Proyecto
- **Líneas de Código Solidity:** ~300 líneas
- **Contratos:** 1 (Auction.sol)  
- **Tests:** 25+ casos de prueba
- **Cobertura:** Funcionalidad completa
- **Gas Optimizado:** ✅ Compilador optimizado
- **Auditoría:** Código público y verificable

## 🛠️ Tech Stack
- **Blockchain:** Ethereum (Sepolia Testnet)
- **Smart Contracts:** Solidity ^0.8.28
- **Framework:** Hardhat  
- **Libraries:** OpenZeppelin Contracts ^5.0.0
- **Testing:** Chai + Mocha
- **Deployment:** Hardhat Deploy Scripts
- **Verification:** Etherscan API

## 🚀 Quick Start

### 1️⃣ Instalación
```bash
# Clonar el repositorio
git clone https://github.com/[TU_USUARIO]/smart-contract-auction.git
cd smart-contract-auction

# Instalar dependencias
npm install

# Compilar contratos
npm run compile
```

### 2️⃣ Testing Local
```bash
# Ejecutar todos los tests
npm test

# Ejecutar tests específicos de la subasta
npm run test:auction

# Iniciar nodo local de Hardhat
npm run node

# Desplegar localmente
npm run deploy:local
```

### 3️⃣ Interacción
```bash
# Consola interactiva local
npm run console

# Script de demostración
npm run interact

# Consola en Sepolia
npm run console:sepolia
```

## 📋 Funciones Principales

### Para Participantes:
```solidity
// Realizar una oferta (debe ser +5% que la actual)
function placeBid() external payable

// Retirar ofertas anteriores superadas
function withdrawPreviousBid() external

// Ver la oferta ganadora actual
function getHighestBidder() external view returns (address, uint256)

// Ver todas las ofertas realizadas
function getAllBids() external view returns (address[] memory, uint256[] memory)

// Verificar si la subasta está activa
function isAuctionActive() external view returns (bool)
```

### Para Owner (Administrador):
```solidity
// Finalizar la subasta manualmente
function endAuction() external onlyOwner

// Retirar comisiones acumuladas
function withdrawCommission() external onlyOwner

// Extender tiempo de subasta
function extendAuction(uint256 _additionalTime) external onlyOwner

// Configuración de emergencia
function emergencyStop() external onlyOwner
```

## 📢 Eventos Implementados

```solidity
// Emitido cuando se realiza una nueva oferta
event NuevaOferta(address indexed bidder, uint256 amount, uint256 timestamp);

// Emitido cuando finaliza la subasta
event SubastaFinalizada(address indexed winner, uint256 winningBid, uint256 timestamp);

// Emitido cuando se extiende el tiempo de subasta
event TiempoExtendido(uint256 newEndTime);

// Emitido cuando se retiran fondos
event FondosRetirados(address indexed bidder, uint256 amount);
```

## 🧪 Casos de Uso

### Scenario 1: Oferta Básica
```javascript
// Usuario realiza una oferta de 1 ETH
await auction.placeBid({ value: ethers.parseEther("1.0") });

// Usuario 2 debe ofertar mínimo 1.05 ETH (5% más)
await auction.connect(user2).placeBid({ value: ethers.parseEther("1.05") });
```

### Scenario 2: Reembolso Parcial
```javascript
// Usuario 1 oferta 1 ETH en T0
await auction.placeBid({ value: ethers.parseEther("1.0") });

// Usuario 2 oferta 2 ETH en T1
await auction.connect(user2).placeBid({ value: ethers.parseEther("2.0") });

// Usuario 1 oferta 3 ETH en T2
await auction.placeBid({ value: ethers.parseEther("3.0") });

// Usuario 1 puede retirar los primeros 1 ETH
await auction.withdrawPreviousBid();
```

### Scenario 3: Extensión Automática
```javascript
// Si quedan menos de 10 minutos y llega una oferta
// La subasta se extiende automáticamente 10 minutos más
const timeLeft = await auction.getTimeLeft();
if (timeLeft < 600) { // 10 minutos
    // Al hacer oferta, se extiende automáticamente
    await auction.placeBid({ value: ethers.parseEther("5.0") });
}
```

## 📁 Estructura del Proyecto
```
smart-contract-auction/
├── contracts/
│   └── Auction.sol           # 🏆 Contrato principal de subasta
├── test/
│   └── Auction.test.js       # 🧪 Suite completa de tests
├── scripts/
│   ├── deploy.js             # 🚀 Despliegue local
│   ├── deploy-sepolia.js     # 🌐 Despliegue Sepolia  
│   └── interact.js           # 🔧 Script de interacción
├── docs/
│   ├── DEPLOY-GUIDE.md       # 📖 Guía despliegue local
│   └── SEPOLIA-DEPLOY.md     # 🌐 Guía Sepolia
└── deployed-addresses.json   # 📋 Direcciones desplegadas
```

## 🔧 Comandos Disponibles
```bash
# Desarrollo
npm run compile          # Compilar contratos
npm run clean           # Limpiar artifacts  
npm test               # Ejecutar tests
npm run test:auction   # Tests específicos

# Despliegue
npm run node           # Nodo local Hardhat
npm run deploy:local   # Desplegar localmente
npm run deploy:sepolia # Desplegar en Sepolia

# Interacción
npm run console        # Consola local
npm run console:sepolia # Consola Sepolia
npm run interact       # Demo interactivo
```

## 🎯 Funcionalidades Implementadas

### ✅ Características Principales
- [x] Constructor con parámetros de inicialización
- [x] Sistema de ofertas con incremento mínimo del 5%
- [x] Validación de ofertas (activa + monto válido)
- [x] Determinación automática del ganador
- [x] Lista completa de ofertas realizadas  
- [x] Devolución de depósitos con comisión del 2%
- [x] Manejo seguro de depósitos por dirección

### ✅ Funcionalidades Avanzadas
- [x] Reembolso parcial durante la subasta activa
- [x] Extensión automática de 10 min en últimos 10 min
- [x] Modifiers de seguridad personalizados
- [x] Eventos para comunicación de estado
- [x] Manejo robusto de errores y excepciones
- [x] Documentación clara y completa

## 📈 Reglas de la Subasta

### 💰 Ofertas Válidas
- Debe ser **mayor al 5%** que la oferta actual
- Solo durante **subasta activa**
- Depósito automático en el contrato

### ⏰ Extensión de Tiempo  
- Oferta en **últimos 10 minutos** → **+10 minutos** adicionales
- Previene "sniping" de última hora
- Notificación automática via eventos

### 💸 Sistema de Reembolsos
- **2% de comisión** en todos los reembolsos
- Reembolso automático al finalizar (no ganadores)
- Reembolso parcial disponible durante subasta

## 🛡️ Seguridad

### Modifiers Implementados
```solidity
modifier onlyActive()        // Solo durante subasta activa
modifier onlyAfterEnd()      // Solo después de finalizar
modifier onlyValidBid()      // Solo ofertas válidas (+5%)
modifier onlyBidder()        // Solo oferentes registrados
```

### Protecciones de Seguridad
- **Reentrancy Guard:** Previene ataques de reentrada
- **Overflow Protection:** SafeMath para operaciones
- **Access Control:** Validación de permisos
- **Input Validation:** Verificación de parámetros
- **State Management:** Control riguroso de estados

## 🤝 Contribuir
1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la branch (`git push origin feature/AmazingFeature`)  
5. Abre un Pull Request

## 🛡️ Auditoría & Seguridad
- **Código Público:** Verificado y accesible en Etherscan
- **Tests Completos:** 25+ casos de prueba automatizados
- **OpenZeppelin:** Uso de contratos auditados
- **Best Practices:** Siguiendo estándares de la industria
- **Peer Review:** Código revisado y documentado

⚠️ **Disclaimer:** Este proyecto es para fines educativos. Realiza tu propia auditoría antes de usar en producción.

## 📄 Licencia
Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto
- **Desarrollador:** MayDev
- **Proyecto:** Smart Contract Auction
- **GitHub:** https://github.com/0000MAILY1111/SmartContractsmod2


## 🎉 ¡Hecho con ❤️ y mucho ☕!

⭐ **¡Dale una estrella al proyecto si te gustó!** ⭐

## 🔗 Links Rápidos
- 📖 [Guía de Despliegue Local](docs/DEPLOY-GUIDE.md)
- 🌐 [Guía de Despliegue Sepolia](docs/SEPOLIA-DEPLOY.md)  
- 🧪 [Ver Tests](test/Auction.test.js)
- 🏆 [Contrato en Etherscan](https://sepolia.etherscan.io/address/[TU_DIRECCION_AQUI])

## 📈 Métricas del Proyecto
- **Contrato Desplegado:** ✅ 1/1
- **Tests Pasando:** ✅ 25+
- **Verificación Etherscan:** ✅ 100%
- **Documentación:** ✅ Completa
- **Funcionalidades:** ✅ 100% Implementadas
