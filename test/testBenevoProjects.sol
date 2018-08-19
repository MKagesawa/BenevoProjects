pragma solidity ^0.4.19;

// import "truffle/Assert.sol";
// import "truffle/DeployedAddresses.sol";
// import "../contracts/BenevoProjects.sol";


contract testBenevoProjects {

//     BenevoToken bnt = BenevoToken(DeployedAddresses.BenevoToken());
//     BenevoProjects project = BenevoProjects(DeployedAddresses.BenevoProjects());
//     BenevoProjects userProject;
//     BenevoToken userToken;

//     address userAddress;
    
//     struct Project {
//         uint id;
//         string name;
//         uint256 goalAmount;
//         uint256 currentAmount;
//         uint256 currentBalance;
//         address ownerAddress;
//         address projectAddress;
//         bool canWithdraw;
//     }

//     // // 'Before hook' setups tests
//     // function beforeAll(){
//     //     BenevoProjects userProject = BenevoProjects(0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
//     //     BenevoToken userToken = BenevoToken(0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB);
//     //     project._createProject("Feed Children", 20000);
//     //     userAddress = address(0x0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
//     // }
    
//     /** @notice when a project is created, it is important all properties are correct. 
//         The hashing function also must output correctly.
//     */

//     function test_CreateProject1(){
//         uint expectedId = 1;
//         var expectedName = "Save Animals";
//         uint expectedGoalAmount = 30000;
//         uint expectedCurrentAmount = 0;
//         var (resultId, resultName, resultGoalAmount, resultCurrentAmount, resultCurrentBalance, resultOwnerAddress, 
//         resultProjectAddress) = project._createProject("Save Animals", 30000);
        
//         Assert.equal(resultId,   expectedId,   "should have Id 1");
//         Assert.equal(resultName, expectedName, "should have name 'Save Animals'");
//         Assert.equal(resultGoalAmount, expectedGoalAmount, "should have goal amount 30000 imals'");
//         Assert.equal(resultCurrentAmount, expectedCurrentAmount, "should have current amount 0");
//     }

//     function test_CreateProject2(){
//         uint expectedCurrentBalance = 0;
//         address expectedOwnerAddress = this;
//         address expectedProjectAddress = address(ripemd160(abi.encodePacked(this)));
//         var (resultId, resultName, resultGoalAmount, resultCurrentAmount, resultCurrentBalance, resultOwnerAddress, 
//         resultProjectAddress) = project._createProject("Save Animals", 30000);

//         Assert.equal(resultCurrentBalance, expectedCurrentBalance, "should have current balance 0");
//         Assert.equal(resultOwnerAddress, expectedOwnerAddress, "should have owner address of the sender");
//         Assert.equal(resultProjectAddress, expectedProjectAddress, "should have project address the hash of the address of the sender");
//     }

//     /** @notice Token transfer deals with value so must be done correctly and securely.
//     */

//     // function testDonate(){
//     //     BenevoProjects project = new BenevoProjects();
//     //     uint expected = 600;
//     //     var result = project.donate(1, 600);
//     //     Assert.equal(result, expected, "should have newBalance 600 after donation");
//     // }

//     // /** @notice When tokens are released, all currentBalance should be able to be withdrawn
//     // */

//     // function testReleaseDonation(){
//     //     bool expected = true;
//     //     bool result = project.releaseDonation(1, 200);
//     //     Assert.equal(result, expected, "project property canWithdraw should be true now");
//     // }

//     // /** @notice When withdrawToken function is called all currentBalance should be sent to the project owner 
//     // */

//     // function testWithdrawToken(){
//     //     /*  After two donations made to project 1 it should have 1000 tokens.
//     //         After 200 tokens are released and withdrawn, the project should have balance 800
//     //         and the project owner should have 1200 toknes (1000 token unpon initialization + 200 withdrawn).
//     //     */
//     //     uint expectedRemainingBalance = 800;
//     //     uint expectedOwnerBalance = 1200;
//     //     project.withdrawToken;
//     //     var (resultName, resultGoalAmount, resultCurrentAmount, resultCurrentBalance, resultOwnerAddress, 
//     //     resultProjectAddress, canWithdraw) = project.getProject(1);
//     //     Assert.equal(resultCurrentBalance, expectedRemainingBalance, "project current balance should be 800");
//     // }
}