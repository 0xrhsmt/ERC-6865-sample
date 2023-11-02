// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IEIP6865 {
    struct Liveness {
        uint256 from;
        uint256 to;
    }

    struct UserAssetMovement {
        address assetTokenAddress;
        uint256 id;
        uint256[] amounts;
    }

    struct Result {
        UserAssetMovement[] assetsIn;
        UserAssetMovement[] assetsOut;
        Liveness liveness;
    }

    /**
     * @notice This function processes an EIP-712 payload message and returns a structured data format emphasizing the potential impact on users' assets.
     * @dev The function returns assetsOut (assets the user is offering), assetsIn (assets the user would receive), and liveness (validity duration of the EIP-712 message).
     * @param encodedMessage The ABI-encoded EIP-712 message (abi.encode(types, params)).
     * @param domainHash The hash of the EIP-712 domain separator as defined in the EIP-712 proposal; see https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator.
     * @return Result struct containing the user's assets impact and message liveness.
     */
    function visualizeEIP712Message(
        bytes memory encodedMessage,
        bytes32 domainHash
    ) external view returns (Result memory);
}
