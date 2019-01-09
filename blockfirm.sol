pragma solidity ^0.4.19;

contract StockCompany{
  struct OtherId{
    string name;
    string id;
    string system;
  }
  struct Accountant{
    address accountant;
    uint256 hireDate;
  }
  struct Problem{
    address accountant;
    string problem;
    uint256 date;
  }
  struct AnnualReport{
    uint256 annualYear;
    string report;
    string profit;
    string dividend;
    string etherExchangeRates;
    address accountant;
    string shareHolders;
    bool approved;
  }

  string public name;
  string public symbol;
  address public president;
  string public constitution;
  uint256 public capitalStock;
  uint256 public accountingMonth;
  uint256 public creationDate;

  bool public closing;
  bool public closed;
  uint256 public closeDate;

  Accountant[] public accountants;
  Problem[] public problems;
  AnnualReport[] public annualReports;
  OtherId[] public otherIds;

  mapping (address => uint256) public balanceOf;

  event Transfer(address indexed from, address indexed to, uint256 value);

  constructor(uint256 _capitalStock, string _name, string _symbol, address _president, string _constitution, uint256 _accountingMonth) public{
      capitalStock = _capitalStock;
      balanceOf[msg.sender] = capitalStock;
      name = _name;
      symbol = _symbol;
      president = _president;
      constitution = _constitution;
      accountingMonth = _accountingMonth;
      creationDate = now;
  }

  function addOtherId(string _name, string _id, string _system) public{
    require(msg.sender == president);
    otherIds.push(OtherId(_name, _id, _system));
  }
  function changeAccountant(address _accountant) public{
    require(msg.sender == president);
    accountants.push(Accountant(_accountant, now));
  }
  function publishProblem(string _problem, uint256 _accountantNumber) public{
    require(msg.sender == accountants[_accountantNumber].accountant);
    problems.push(Problem(msg.sender, _problem, now));
  }
  function publishAnnualReport(uint256 _year, string _report, string _profit, string _dividend, string _etherExchangeRates, address _accountantAddress, string _shareHolders) public{
    require(msg.sender == president);
    annualReports.push(AnnualReport(_year, _report, _profit, _dividend, _etherExchangeRates, _accountantAddress, _shareHolders, false));
  }
  function approveAnnualReport(uint256 _numberAnnualReports, bool _yesOrNo) public{
    require(msg.sender == annualReports[_numberAnnualReports].accountant);
    annualReports[_numberAnnualReports].approved = _yesOrNo;
  }
  function startClosing() public{
    require(msg.sender == president);
    closing = true;
  }
  function close() public{
    require(!!closing);
    require(msg.sender == accountants[0].accountant);
    closed = true;
    closeDate = now;
  }
  function terminate() public{
    require(now > (closeDate + 2592000));
    selfdestruct(president);
  }

  function _transfer(address _from, address _to, uint _value) internal {
    require(!closed);
    require(_to != 0x0);
    require(balanceOf[_from] >= _value);
    require(balanceOf[_to] + _value > balanceOf[_to]);

    uint previousBalances = balanceOf[_from] + balanceOf[_to];

    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(_from, _to, _value);

    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
  }
  function transfer(address _to, uint256 _value) public {
      _transfer(msg.sender, _to, _value);
  }
}
