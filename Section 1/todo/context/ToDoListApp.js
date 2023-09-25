import React, {useEffect, useState} from "react";
import Web3Modal from "web3modal";
import { ethers } from "ethers";

import{toDoListAddress, toDoListABI} from "./constant";

const fetchContract = (signerOrProvider) => new ethers.Contract(toDoListAddress, toDoListABI, signerOrProvider);

export const ToDoListContext = React.createContext();
export const ToDoListProvider = ({children}) => {

    const [currentAccount, setCurrentAccount] = useState("");
    const [error, setError] = useState("");
    const [allToDoList, setallToDoList] = useState([]);
    const [myList, setMyList] = useState([]);
    const [allAddress, setallAddress] = useState([]);

    //Connecting Metamask
    const checkIfWalletConnected = async()=> {
        if(!window.ethereum) return setError("Please install metamask");

        const account = await window.ethereum.request({method: "eth_accounts"});
        if(account.length){
            setCurrentAccount(account[0]);
            console.log(account[0]);
        }
        else{
            setError("Please install the metamask and reload");
        }
    };

    //Connecting Wallet
    const connectWallet = async() => {
        if(!window.ethereum) return setError("Please install metamask");

        const account = await window.ethereum.request({method: "eth_requestAccounts"});

        setCurrentAccount(account[0]);
    };

    //conversing with SC
    const toDoList = async (message) => {
        try{
            const web3Modal = new Web3Modal();
            const connection = await web3Modal.connect();
            const provider = new ethers.providers.Web3Provider(connection);
            const signer = provider.getSigner();
            const contract = await fetchContract(signer);

            const data = JSON.stringify({ message });
            const added = await client.add(data);

            

            const createList = await contract.createList(message);
            createList.wait();
            consolelog(createList);
        }
        catch(error){
            setError("Something is wrong");
        }
    };

    const getToDoList = async () => {
        try {
          //CONNECTING SMART CONTRACT
          const web3Modal = new Web3Modal();
          const connection = await web3Modal.connect();
          const provider = new ethers.providers.Web3Provider(connection);
          const signer = provider.getSigner();
          const contract = await fetchContract(signer);
    
          //GET DATA
          const getAllAddress = await contract.getAddress();
          setAllAddress(getAllAddress);
          console.log(getAllAddress);
    
          getAllAddress.map(async (el) => {
            const getSingleData = await contract.getCreatorData(el);
            allToDoList.push(getSingleData);
            console.log(getSingleData);
          });
    
          const allMessage = await contract.getMessage();
          setmyList(allMessage);
        } catch (error) {
          setError("Something wrong while getting the data");
        }
      };

    const change = async (address) => {
       try {
        //CONNECTING SMART CONTRACT
        const web3Modal = new Web3Modal();
        const connection = await web3Modal.connect();
        const provider = new ethers.providers.Web3Provider(connection);
        const signer = provider.getSigner();
        const contract = await fetchContract(signer);
    
        const state = await contract.toggle(address);
        state.wait();
        console.log(state);
        } 
        catch (error) {
          console.log("Wrong");
        }
    };

    return(
        <ToDoListContext.Provider> value = {
        {
            checkIfWalletConnected,
            connectWallet,
            toDoList,
            allToDoList,
            currentAccount,
            getToDoList,
            error,
            allAddress,
            myList,
            change
        }}
        {children}
        </ToDoListContext.Provider>
    );
};
// const ToDoListApp = () => {
//     return (
//         <div>ToDoListApp</div>
//     );
// };

//export default ToDoListApp;