// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @author mail
 */
contract Auction {
    
    
    /// @dev Propietario del contrato
    address public owner;
    
    /// @dev Tiempo de finalización de la subasta
    uint256 public auctionEndTime;
    
    /// @dev Mayor oferta actual
    uint256 public highestBid;
    
    /// @dev Dirección del mayor oferente
    address public highestBidder;
    
    /// @dev Incremento mínimo requerido (5%)
    uint256 public constant MINIMUM_BID_INCREASE = 5;
    
    /// @dev Tasa de comisión (2%)
    uint256 public constant COMMISSION_RATE = 2;
    
    /// @dev Tiempo de extensión automática (10 minutos)
    uint256 public constant TIME_EXTENSION = 10 minutes;
    
    /// @dev Estado de la subasta
    bool public auctionEnded;
    bool public auctionActive;
    
    /// @dev Mapeo de ofertas totales por usuario
    mapping(address => uint256) public totalBids;
    
    /// @dev Lista de oferentes para iteración
    address[] public bidders;
    
    /// @dev Mapeo para verificar si una dirección ya es oferente
    mapping(address => bool) public isBidder;
    
    /// @dev Comisiones acumuladas
    uint256 public accumulatedCommissions;
    

    event NuevaOferta(address indexed bidder, uint256 amount, uint256 timestamp);
    
 
    event SubastaFinalizada(address indexed winner, uint256 winningBid, uint256 timestamp);
    
    event TiempoExtendido(uint256 newEndTime);
    
    event FondosRetirados(address indexed bidder, uint256 amount);
   
    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion");
        _;
    }
    
    
    modifier onlyActive() {
        require(auctionActive && block.timestamp < auctionEndTime, "La subasta no esta activa");
        _;
    }
    
   
    modifier onlyAfterEnd() {
        require(block.timestamp >= auctionEndTime || auctionEnded, "La subasta aun no ha terminado");
        _;
    }
    
   
    modifier validBidAmount() {
        require(msg.value > 0, "La oferta debe ser mayor a 0");
        if (highestBid > 0) {
            uint256 minimumBid = highestBid + (highestBid * MINIMUM_BID_INCREASE) / 100;
            require(msg.value >= minimumBid, "La oferta debe ser al menos 5% mayor que la actual");
        }
        _;
    }
    
   
    modifier onlyBidder() {
        require(isBidder[msg.sender], "No eres un oferente registrado");
        _;
    }
    
   
    constructor(uint256 _durationInMinutes) {
        require(_durationInMinutes > 0, "La duracion debe ser mayor a 0");
        
        owner = msg.sender;
        auctionEndTime = block.timestamp + (_durationInMinutes * 1 minutes);
        auctionActive = true;
        auctionEnded = false;
        highestBid = 0;
        highestBidder = address(0);
    }
   
    function placeBid() external payable onlyActive validBidAmount {
        // Verificar extensión automática de tiempo
        if (block.timestamp + TIME_EXTENSION > auctionEndTime) {
            auctionEndTime = block.timestamp + TIME_EXTENSION;
            emit TiempoExtendido(auctionEndTime);
        }
        
        // Si es la primera oferta del usuario, agregarlo a la lista
        if (!isBidder[msg.sender]) {
            bidders.push(msg.sender);
            isBidder[msg.sender] = true;
        }
        
        // Sumar la nueva oferta al total del usuario
        totalBids[msg.sender] += msg.value;
        
        // Actualizar la mejor oferta si es necesario
        if (totalBids[msg.sender] > highestBid) {
            highestBid = totalBids[msg.sender];
            highestBidder = msg.sender;
        }
        
        emit NuevaOferta(msg.sender, msg.value, block.timestamp);
    }
    
  
    function withdrawPreviousBid() external onlyBidder {
        require(totalBids[msg.sender] > 0, "No tienes ofertas para retirar");
        require(msg.sender != highestBidder, "No puedes retirar fondos siendo el mayor oferente");
        
        uint256 amount = totalBids[msg.sender];
        totalBids[msg.sender] = 0;
        
        // Calcular comisión del 2%
        uint256 commission = (amount * COMMISSION_RATE) / 100;
        uint256 refundAmount = amount - commission;
        
        // Acumular comisiones
        accumulatedCommissions += commission;
        
        // Transferir fondos
        payable(msg.sender).transfer(refundAmount);
        
        emit FondosRetirados(msg.sender, refundAmount);
    }
    

    function endAuction() external onlyAfterEnd {
        require(!auctionEnded, "La subasta ya ha finalizado");
        
        auctionEnded = true;
        auctionActive = false;
        
        emit SubastaFinalizada(highestBidder, highestBid, block.timestamp);
        
        // Devolver depósitos a oferentes no ganadores
        for (uint256 i = 0; i < bidders.length; i++) {
            address bidder = bidders[i];
            
            // Solo devolver a no ganadores con ofertas pendientes
            if (bidder != highestBidder && totalBids[bidder] > 0) {
                uint256 amount = totalBids[bidder];
                totalBids[bidder] = 0;
                
                // Calcular comisión del 2%
                uint256 commission = (amount * COMMISSION_RATE) / 100;
                uint256 refundAmount = amount - commission;
                
                // Acumular comisiones
                accumulatedCommissions += commission;
                
                // Transferir reembolso
                payable(bidder).transfer(refundAmount);
                
                emit FondosRetirados(bidder, refundAmount);
            }
        }
    }
    
    
    function getHighestBidder() external view returns (address winner, uint256 winningBid) {
        return (highestBidder, highestBid);
    }
    
 
    function getAllBids() external view returns (address[] memory biddersList, uint256[] memory bidAmounts) {
        uint256[] memory amounts = new uint256[](bidders.length);
        
        for (uint256 i = 0; i < bidders.length; i++) {
            amounts[i] = totalBids[bidders[i]];
        }
        
        return (bidders, amounts);
    }
    
    
    function isAuctionActive() external view returns (bool active) {
        return auctionActive && block.timestamp < auctionEndTime;
    }
    
    
    function getTimeLeft() external view returns (uint256 timeLeft) {
        if (block.timestamp >= auctionEndTime) {
            return 0;
        }
        return auctionEndTime - block.timestamp;
    }
    
   
    function getAuctionInfo() external view returns (
        uint256 endTime,
        bool active,
        bool ended,
        address winner,
        uint256 winningBid,
        uint256 totalBidders
    ) {
        return (
            auctionEndTime,
            auctionActive && block.timestamp < auctionEndTime,
            auctionEnded,
            highestBidder,
            highestBid,
            bidders.length
        );
    }
    
   
    function withdrawCommission() external onlyOwner {
        require(accumulatedCommissions > 0, "No hay comisiones para retirar");
        
        uint256 amount = accumulatedCommissions;
        accumulatedCommissions = 0;
        
        payable(owner).transfer(amount);
    }
    
    
    function withdrawWinnerFunds() external onlyOwner onlyAfterEnd {
        require(highestBidder != address(0), "No hay ganador");
        require(totalBids[highestBidder] > 0, "Los fondos del ganador ya fueron retirados");
        
        uint256 winnerAmount = totalBids[highestBidder];
        totalBids[highestBidder] = 0;
        
        payable(owner).transfer(winnerAmount);
    }
    

    function emergencyStop() external onlyOwner {
        require(!auctionEnded, "La subasta ya ha terminado");
        
        auctionEnded = true;
        auctionActive = false;
        
        emit SubastaFinalizada(address(0), 0, block.timestamp);
    }
    
    
    function extendAuction(uint256 _additionalMinutes) external onlyOwner {
        require(!auctionEnded, "La subasta ya ha terminado");
        require(_additionalMinutes > 0, "Los minutos adicionales deben ser mayor a 0");
        
        auctionEndTime += _additionalMinutes * 1 minutes;
        emit TiempoExtendido(auctionEndTime);
    }
    
 
    receive() external payable {
        revert("Usa placeBid() para hacer ofertas");
    }
    
    
    fallback() external payable {
        revert("Funcion no encontrada. Usa placeBid() para ofertar");
    }
}