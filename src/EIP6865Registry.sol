// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "solmate/auth/Owned.sol";

contract EIP6865Registry is Owned {
    mapping(bytes32 => address) public implementations;

    event EIP6865ImplementationRegistered(
        bytes32 indexed domainHash,
        address indexed implementation
    );

    constructor(address _initialOwner) Owned(_initialOwner) {}

    /**
     * @dev Registers an EIP-6865 implementation for a given domain hash.
     * @param domainHash The hash of the EIP-712 domain separator as defined in the EIP-712 proposal; see https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator.
     * @param implementation The address of the EIP-6865 implementation contract.
     */
    function registerImplementation(
        bytes32 domainHash,
        address implementation
    ) external onlyOwner {
        require(implementation != address(0), "Invalid implementation address");

        implementations[domainHash] = implementation;

        emit EIP6865ImplementationRegistered(domainHash, implementation);
    }
}
