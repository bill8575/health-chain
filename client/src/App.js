import React, { Component } from "react";
// import SimpleStorageContract from "./contracts/SimpleStorage.json";
import HealthChainContract from "./contracts/HealthChain.json"
import getWeb3 from "./utils/getWeb3";

import "./App.css";

class App extends Component {

  constructor(props) {
    super(props)

    this.state = { 
      doctorCount: 0, 
      web3: null, 
      instance: null,
      accounts: null,
      contract: null,
      jsonData: null,
      setValue: 0,
      inputValue: ''            
    };

    this.inputNumberRef = React.createRef()    

  }


  componentDidUpdate() {
    // console.log("componentDidUpdate")
    this.inputNumberRef.current.focus()    
  }

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3()

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts()

      // Get the contract instance.
      const networkId = await web3.eth.net.getId()
      // const deployedNetwork = SimpleStorageContract.networks[networkId];
      const deployedNetwork = HealthChainContract.networks[networkId]
      const instance = new web3.eth.Contract(
        // SimpleStorageContract.abi,
        HealthChainContract.abi,        
        deployedNetwork && deployedNetwork.address,
      )

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { contract } = this.state

    const response = await contract.methods.getDoctors().call()

    const jsonData = JSON.parse(JSON.stringify(response))
    this.setState({ jsonData: jsonData })
    const result = await contract.methods.getTotalDoctors().call()
    this.setState({doctorCount: result})

  };

  handleClick(event) {
    const contract = this.state.contract
    const accounts = this.state.accounts    
    const web3 = this.state.web3
    const setValue = this.state.setValue

    contract.methods.createDoctor(setValue).send({from: accounts[0]}).then(result => {
      return contract.methods.getTotalDoctors().call()
    }).then(result => {
      this.setState({doctorCount: result})
      return this.setState({ web3, accounts, contract}, this.runExample)      
    })

  }  

  handleSetValue = (event) => {
    event.preventDefault()
    const data = this.state.inputValue
    this.setState({
      setValue: data
    })
  }

  handleInputChange = (event) => {
    event.preventDefault()
    this.setState({
      [event.target.name]: event.target.value,
    })
  }

  render() {

    const {inputValue, setValue} = this.state

    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    const jsonData = this.state.jsonData;

    return (      
      <div className="App">
        <h1>Clinic Blockchain!</h1>
        <p>Joining clinic Blockchain, set a <br/>doctor ID
        (click "Set Your Id") follow by <br/>clicking 
        "Create doctor".
        </p>
        <div>
            <p>[[Doctors] [DoctorID]]:</p> 
            <p>{JSON.stringify(jsonData)} </p>
        </div>
        <div>
        {inputValue !== '' 
          ? <p>doctorId to use: {setValue}</p> 
          : ''
        }
        </div>        
        <form onSubmit={this.handleSetValue}>
        <p><input type='text' name='inputValue' id='numberInput' ref={this.inputNumberRef} onChange={this.handleInputChange} /></p>
        <p><button>Set Your Id</button></p>
        </form>        
        <button onClick={this.handleClick.bind(this)}>Create Doctor</button>
        <div>Number of doctors: {this.state.doctorCount} </div>
      </div>
    );
  }
}

export default App;
