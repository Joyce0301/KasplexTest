// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CheckIn {
    // 1 day in seconds
    uint256 public constant DAY = 1 days;

    // user => last check-in timestamp
    mapping(address => uint256) public lastCheckInAt;

    // user => current streak (consecutive days)
    mapping(address => uint256) public streak;

    // user => total check-ins
    mapping(address => uint256) public totalCheckIns;

    event CheckedIn(
        address indexed user,
        uint256 timestamp,
        uint256 currentStreak,
        uint256 total
    );

    /// @notice Check in once per 24 hours.
    /// If you check in within the next day window, it reverts.
    function checkIn() external {
        uint256 last = lastCheckInAt[msg.sender];
        uint256 nowTs = block.timestamp;

        // Prevent multiple check-ins within 24 hours
        require(last == 0 || nowTs >= last + DAY, "Too early: one per day");

        // Update streak:
        // If last check-in was within 48 hours, we treat it as "consecutive"
        // (allows some delay but still counts as continuous)
        if (last != 0 && nowTs <= last + 2 * DAY) {
            streak[msg.sender] += 1;
        } else {
            streak[msg.sender] = 1;
        }

        lastCheckInAt[msg.sender] = nowTs;
        totalCheckIns[msg.sender] += 1;

        emit CheckedIn(msg.sender, nowTs, streak[msg.sender], totalCheckIns[msg.sender]);
    }

    /// @notice Convenience helper: how many seconds until you can check in again.
    function secondsUntilNextCheckIn(address user) external view returns (uint256) {
        uint256 last = lastCheckInAt[user];
        if (last == 0) return 0;
        uint256 next = last + DAY;
        if (block.timestamp >= next) return 0;
        return next - block.timestamp;
    }
}
