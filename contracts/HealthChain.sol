pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract HealthChain {

    address[] public admins;
    mapping (address => bool) public isAdmin;

    mapping (uint => bool) public docIdExists;

    struct doctor {
        address doctor;
        uint doctorId;
    }
    
    doctor[] public doctors;
    // mapping (uint => doctor) public doctors; 
    
    struct patientRegister {
      address patient;
      uint mrn;
      uint doctorId;
    }
    
    // uint public doctorCount;
    uint public clncRegCount;
    mapping (uint => patientRegister) public clinicRegistry;

    modifier mustBeAnAdmin() { require (isAdmin[msg.sender]); _;}
    
    modifier notAlreadyDoctor() { require (!isDoctor(msg.sender)); _;}

    modifier doctorExists(uint _doctorId) { require (docIdExists[_doctorId]); _;}

    // modifier requiring that patient address cannot equal to 
    // a doctor's with which he/she is registering


    constructor(address[] memory _starterDoctors, 
            address[] memory _admins) 
            public 
    {
        clncRegCount = 0;

        // To have a couple of doctors created to start
        // 
        doctor memory inputDoctor;
        uint inputDocId;
        for (uint i=0; i<_starterDoctors.length; i++) 
        {
            inputDocId = i+100;
            inputDoctor = doctor(_starterDoctors[i], inputDocId);
            doctors.push(inputDoctor);
            docIdExists[inputDocId] = true;
        }

        for (uint i=0; i<_admins.length; i++) {
            isAdmin[_admins[i]] = true;
        }

    }

    function() external payable {
        revert();
    }    

    function deleteDoctor(uint _doctorId, address _doctor) 
        public 
        mustBeAnAdmin()
    {

        for (uint i=0; i<doctors.length; i++) {
            if ((doctors[i].doctor == _doctor) 
               && (doctors[i].doctorId == _doctorId)) {
                delete docIdExists[_doctorId];                
                doctors[i].doctor = doctors[doctors.length-1].doctor;
                doctors[i].doctorId = doctors[doctors.length-1].doctorId;
                delete doctors[doctors.length-1];
                doctors.length--;

            } 
        }
    }
    
    function createDoctor(uint _doctorId) 
        public
        notAlreadyDoctor()
        returns (uint)
    {
        doctor memory newDoctor = doctor(msg.sender, _doctorId);
        doctors.push(newDoctor);

        return doctors.length;
    }
    
    function getTotalDoctors() 
        public view
        returns (uint) 
    {
        return doctors.length;
        // return doctorCount;
    }

    function getDoctors()
        public view
        // returns (doctor memory)         
        returns (doctor[] memory) 
    {
        //uint i = doctorCount-1;
        //return doctors[i];
        return doctors;
    }

    function isDoctor(address _doctor) 
        public view
        returns (bool)    
    {
        bool isDocFound = false;
        for (uint i=0; i<doctors.length; i++) {
            if (doctors[i].doctor == _doctor) {
                isDocFound = true;
            }
        }
        return isDocFound;
    }
    
    // function enrolPatient is where patient selects a 
    //   doctor 
    function enrolPatient(uint _doctorId) 
        public 
        doctorExists(_doctorId)
        returns (uint)
    {
        bool foundRegRec = false;
        uint totalRegRec = clncRegCount;
        for (uint i=0; i<totalRegRec; i++) {
            if ((clinicRegistry[i].patient == msg.sender) 
               && (clinicRegistry[i].doctorId == _doctorId))
                foundRegRec = true;
        }        

        if (!foundRegRec) {
            clinicRegistry[totalRegRec] = patientRegister({
                patient: msg.sender,
                mrn: totalRegRec+1,
                doctorId: _doctorId
            });
            clncRegCount += 1;
        }
        
        return _doctorId;
    }
    
    function isPatientOf(uint _doctorId) 
        public view
        doctorExists(_doctorId)
        returns (bool)
    {
        bool foundRegRec = false;
        uint totalRegRec = clncRegCount;
        for (uint i=0; i<totalRegRec; i++) {
            if ((clinicRegistry[i].patient == msg.sender) 
               && (clinicRegistry[i].doctorId == _doctorId))
                foundRegRec = true;
        }        

        return (foundRegRec);        
    }
    
    function submitMedRec(address patient, bytes memory data) 
        public 
        returns (uint medRecId) 
    {
           
    }
    
}