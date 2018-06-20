pragma solidity ^0.4.19;

contract StockCompany{
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
      string currency;
      uint256 profit;
      uint256 dividend;
      address accountant;
      bool approved;
    }

    string public name;
    string public symbol;
    address public president;
    uint256 public capitalStock;
    uint256 public accountingMonth;
    uint256 public creationDate;

    Accountant[] public accountants;
    Problem[] public problems;
    AnnualReport[] public annualReports;

    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function StockCompany(uint256 _capitalStock, string _name, string _symbol, address _president, uint256 _accountingMonth) public{
        capitalStock = _capitalStock;
        balanceOf[msg.sender] = capitalStock;
        name = _name;
        symbol = _symbol;
        president = _president;
        accountingMonth = _accountingMonth;
        creationDate = now;
    }

    function changeAccountant(address _accountant){
      if(msg.sender == president){
        accountants.push(Accountant(_accountant, now));
      }
    }
    function publishProblem(string _problem, uint256 _accountantNumber){
      if(msg.sender == accountants[_accountantNumber].accountant){
        problems.push(Problem(msg.sender, _problem, now));
      }
    }
    function publishAnnualReport(uint256 _year, string _report, uint256 _profit, string _currency, uint256 _dividend, address _accountantAddress){
      if(msg.sender == president){
        annualReports.push(AnnualReport(_year, _report, _currency, _profit, _dividend, _accountantAddress, false));
      }
    }
    function approveAnnualReport(uint256 _numberAnnualReports, bool _yesOrNo){
      if(msg.sender == annualReports[_numberAnnualReports].accountant){
        annualReports[_numberAnnualReports].approved = _yesOrNo;
      }
    }

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);

        uint previousBalances = balanceOf[_from] + balanceOf[_to];

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);

        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
}
