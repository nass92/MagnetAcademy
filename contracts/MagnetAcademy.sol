//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./SchoolMagnet.sol";

contract MagnetAcademy {
    using Counters for Counters.Counter;

    address private _rector;
    Counters.Counter private _nbSchools;
    Counters.Counter private _schoolId;
    mapping(address => bool) private _admins;
    mapping(address => address) private _schoolDirectors; // director to school
    mapping(address => address) private _schools; // school to director

    event AdminAdded(address indexed account);
    event AdminRevoked(address indexed account);
    event SchoolCreated(address indexed schoolAddress, address indexed directorAddress, string name);
    event SchoolDeleted(address indexed schoolAddress, address indexed directorAddress);
    event DirectorSet(address indexed directorAddress, address indexed schoolAddress);

    modifier OnlyRector() {
        require(msg.sender == _rector, "MagnetAcademy: Only rector can perform this action");
        _;
    }

    modifier OnlyAdmin() {
        require(_admins[msg.sender] == true, "MagnetAcademy: Only administrators can perform this action");
        _;
    }

    modifier OnlySchoolDirector(address account) {
        require(_schoolDirectors[account] != address(0), "MagnetAcademy: Not a school director");
        _;
    }

    modifier OnlyNotSchoolDirector(address account) {
        require(_schoolDirectors[account] == address(0), "MagnetAcademy: Already a school director");
        _;
    }

    modifier OnlySchoolAddress(address addr) {
        require(_schools[addr] != address(0), "MagnetAcademy: Only for created schools");
        _;
    }

    constructor(address rector_) {
        _rector = rector_;
        _admins[rector_] = true;
    }

    function addAdmin(address account) public OnlyRector() {
        _admins[account] = true;
        emit AdminAdded(account);
    }

    function revokeAdmin(address account) public OnlyRector() {
        _admins[account] = false;
        emit AdminRevoked(account);
    }

    function changeSchoolDirector(address oldDirector, address newDirector)
        public
        OnlyAdmin()
        OnlySchoolDirector(oldDirector)
        OnlyNotSchoolDirector(newDirector)
        returns (bool)
    {
        address schoolAddress = _schoolDirectors[oldDirector];
        _schoolDirectors[oldDirector] = address(0);
        _schoolDirectors[newDirector] = schoolAddress;
        _schools[schoolAddress] = newDirector;
        emit DirectorSet(newDirector, schoolAddress);
        return true;
    }

    function createSchool(string memory name, address directorAddress)
        public
        OnlyAdmin()
        OnlyNotSchoolDirector(directorAddress)
        returns (bool)
    {
        SchoolMagnet school = new SchoolMagnet(name, directorAddress);
        _schoolDirectors[directorAddress] = address(school);
        _schools[address(school)] = directorAddress;
        emit DirectorSet(directorAddress, address(school));
        _nbSchools.increment();
        emit SchoolCreated(address(school), directorAddress, name);
        return true;
    }

    function deleteSchool(address schoolAddress) public OnlyAdmin() OnlySchoolAddress(schoolAddress) returns (bool) {
        address directorAddress = _schools[schoolAddress];
        _schools[schoolAddress] = address(0);
        _schoolDirectors[directorAddress] = address(0);
        _nbSchools.decrement();
        emit SchoolDeleted(schoolAddress, directorAddress);
        return true;
    }

    function nbSchools() public view returns (uint256) {
        return _nbSchools.current();
    }

    function schoolOf(address account) public view returns (address) {
        return _schoolDirectors[account];
    }

    function directorOf(address school) public view returns (address) {
        return _schools[school];
    }

    function rector() public view returns (address) {
        return _rector;
    }

    function isAdmin(address account) public view returns (bool) {
        return _admins[account];
    }

    function isDirector(address account) public view returns (bool) {
        return _schoolDirectors[account] != address(0);
    }

    function isSchool(address addr) public view returns (bool) {
        return _schools[addr] != address(0);
    }
}
