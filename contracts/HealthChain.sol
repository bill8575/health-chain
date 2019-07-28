pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract HealthChain {

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
    
    // modifier requiring that patient address cannot equal to 
    // a doctor's with which he/she is registering


    constructor(address[] memory _owners) public {
        clncRegCount = 0;
        // doctorCount = 0;

        // To have a couple of doctors created to start
        // 
        doctor memory inputDoctor;
        uint inputDocId;
        for (uint i=0; i<_owners.length; i++) 
        {
            inputDocId = i+100;
            inputDoctor = doctor(_owners[i], inputDocId);
            doctors.push(inputDoctor);
        }

    }

    function deleteDoctor(uint _doctorId, address _doctor) 
        public 
    {

        for (uint i=0; i<doctors.length; i++) {
            if ((doctors[i].doctor == _doctor) 
               && (doctors[i].doctorId == _doctorId)) {
                doctors[i].doctor = doctors[doctors.length-1].doctor;
                doctors[i].doctorId = doctors[doctors.length-1].doctorId;
                delete doctors[doctors.length-1];
                doctors.length--;
            } 
        }
    }
    
    function createDoctor(uint _doctorId) 
        public
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
    
    
    function enrolPatient(uint _doctorId) public returns (uint)
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