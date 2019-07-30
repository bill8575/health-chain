pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract HealthChain {

    address[] public admins;
    mapping (address => bool) public isAdmin;

    mapping (uint => bool) public docIdExists;

    mapping (address => uint) docIdLookup;

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

    mapping (uint => patientRegister) public clinicRegistry;

    struct medRecord {
        bool verified;
        uint doctorId;
        uint mrn;
        bytes data;
    }

    mapping (uint => medRecord) public patientMedRecords;

    uint public medRecCount;
    uint public clncRegCount;

    modifier mustBeAnAdmin() { require (isAdmin[msg.sender]); _;}
    
    modifier notAlreadyDoctor() { require (!isDoctor(msg.sender)); _;}

    modifier isADoctor() { require (isDoctor(msg.sender)); _;}

    modifier doctorExists(uint _doctorId) { require (docIdExists[_doctorId]); _;}

    constructor(address[] memory _starterDoctors, 
            address[] memory _admins) 
            public 
    {
        clncRegCount = 0;
        medRecCount = 0;

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

        // Pre-defined which accounts are the admins 
        //   through the deployment script
        for (uint i=0; i<_admins.length; i++) {
            isAdmin[_admins[i]] = true;
        }

    }

    function() external payable {
        revert();
    }    

    // Only the admins are allowed to delete a doctor 
    //   parameters are matching doctorId and doctor's 
    //   address
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
    
    // Anyone can enrol as a doctor 
    function createDoctor(uint _doctorId) 
        public
        notAlreadyDoctor()
        returns (uint)
    {
        doctor memory newDoctor = doctor(msg.sender, _doctorId);
        doctors.push(newDoctor);

        docIdLookup[msg.sender] = _doctorId;

        return doctors.length;
    }
    
    // function to return the total 
    //   number of doctors enrolled
    //   at the moment 
    function getTotalDoctors() 
        public view
        returns (uint) 
    {
        return doctors.length;
    }

    // function to return the entire doctors
    //   array
    function getDoctors()
        public view
        // returns (doctor memory)         
        returns (doctor[] memory) 
    {
        //uint i = doctorCount-1;
        //return doctors[i];
        return doctors;
    }

    // function to test if a contract caller is 
    //   enrolled as a doctor
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
    
    // function to test if the contract caller is 
    //   a registered patient of the doctor
    //   with the provided _doctorId
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

    // User must be a doctor to look up its own
    //   patient's MRN. There can be only one registry
    //   record for a given patient for the doctor
    function getPatientMRN(address _patient) 
        public 
        view
        isADoctor()
        returns (uint _mrn)
    {
        uint doctorId = docIdLookup[msg.sender];

        uint totalRegRec = clncRegCount;
        for (uint i=0; i<totalRegRec; i++) {
            if ((clinicRegistry[i].patient == _patient) 
               && (clinicRegistry[i].doctorId == doctorId))
                _mrn = clinicRegistry[i].mrn;
        }        

        return _mrn;

    }
    
    // Only doctor can submit a medical record
    // Doctor can only submit medRec for its enrolled patient
    function submitMedRec(address _patient, bytes memory _data) 
        public 
        isADoctor()
        returns (uint medRecId) 
    {
        uint patientMRN = getPatientMRN(_patient);

        patientMedRecords[medRecCount] = medRecord({
            verified: false,
            doctorId: docIdLookup[msg.sender],
            mrn: patientMRN,
            data: _data
        });
        medRecId = medRecCount;
        medRecCount += 1;

    }

    // The confirmer has to be the patient for
    // which is treated by the doctor with the doctorId
    // stored in the medicalRecord
    //
    // Loop through the clinicRegistry and search for 
    //   matching criteria based on mrn looked up from 
    //   patientMedRecords with the parameter medRecId
    function verifyMedRec(uint medRecId) 
        public
        returns (bool IsVerified)
    {
        IsVerified = false;
        medRecord storage m = patientMedRecords[medRecId];
        uint totalRegRec = clncRegCount;
        for (uint i=0; i<totalRegRec; i++) {
            if ((clinicRegistry[i].patient == msg.sender) 
                && (clinicRegistry[i].mrn == m.mrn)
                && isPatientOf(clinicRegistry[i].doctorId)) {
                m.verified = true;
                IsVerified = true;

            }
                
        }        

    }
    
}