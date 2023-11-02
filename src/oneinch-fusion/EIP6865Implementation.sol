// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../interfaces/IEIP6865.sol";

contract EIP6865Implementation is IEIP6865 {
    uint256 constant START_TIME_MASK =
        0xFFFFFFFF00000000000000000000000000000000000000000000000000000000;
    uint256 constant DURATION_MASK =
        0x00000000FFFFFF00000000000000000000000000000000000000000000000000;
    uint256 constant START_TIME_SHIFT = 224;
    uint256 constant DURATION_SHIFT = 200;
    bytes32 public constant DOMAIN_HASH = 0x0; // TODO: calculate this

    struct Order {
        uint256 salt;
        address makerAsset;
        address takerAsset;
        address maker;
        address receiver;
        address allowedSender;
        uint256 makingAmount;
        uint256 takingAmount;
        uint256 offsets;
        bytes interactions;
    }

    function visualizeEIP712Message(
        bytes memory encodedMessage,
        bytes32 domainHash
    ) external view override returns (Result memory) {
        require(
            domainHash == DOMAIN_HASH,
            "EIP6865Implementation: invalid domain hash"
        );

        Order memory order = abi.decode(encodedMessage, (Order));

        (
            UserAssetMovement[] memory assetsIn,
            UserAssetMovement[] memory assetsOut
        ) = getAssets(order);
        (uint256 startTime, uint256 endTime) = getAuctionTime(order.salt);

        return Result(assetsIn, assetsOut, Liveness(startTime, endTime));
    }

    function getAssets(
        Order memory order
    )
        internal
        pure
        returns (
            UserAssetMovement[] memory assetsIn,
            UserAssetMovement[] memory assetsOut
        )
    {
        assetsIn = new UserAssetMovement[](1);
        uint256[] memory amountsInValues = new uint256[](1);
        amountsInValues[0] = order.makingAmount;
        assetsIn[0] = UserAssetMovement({
            assetTokenAddress: order.makerAsset,
            id: 0,
            amounts: amountsInValues
        });

        assetsOut = new UserAssetMovement[](1);
        uint256[] memory amountsOutValues = new uint256[](1);
        amountsOutValues[0] = order.makingAmount;
        assetsOut[0] = UserAssetMovement({
            assetTokenAddress: order.takerAsset,
            id: 0,
            amounts: amountsOutValues
        });
    }

    function getAuctionTime(
        uint256 salt
    ) internal pure returns (uint256 startTime, uint256 endTime) {
        uint256 duration = (salt & DURATION_MASK) >> DURATION_SHIFT;

        startTime = (salt & START_TIME_MASK) >> START_TIME_SHIFT;
        endTime = startTime + duration;
    }
}
