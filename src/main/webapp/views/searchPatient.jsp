    
<!DOCTYPE HTML>
<!--
 ~
 ~ Copyright (C) 2012 by Cognitive Medical Systems, Inc (http://www.cognitivemedciine.com)
 ~
 ~ Licensed under the Apache License, Version 2.0 (the "License"); you may not 
 ~ use this file except in compliance with the License. You may obtain a copy of 
 ~ the License at
 ~
 ~     http://www.apache.org/licenses/LICENSE-2.0
 ~
 ~ Unless required by applicable law or agreed to in writing, software distributed 
 ~ under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
 ~ CONDITIONS OF ANY KIND, either express or implied. See the License for the
 ~ specific language governing permissions and limitations under the License.
 ~
-->
 
<!--
 ~ Socratic Grid contains components to which third party terms apply. To comply 
 ~ with these terms, the following notice is provided:
 ~
 ~ TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
 ~ Copyright (c) 2008, Nationwide Health Information Network (NHIN) Connect. All 
 ~ rights reserved.
 ~ Redistribution and use in source and binary forms, with or without 
 ~ modification, are permitted provided that the following conditions are met:
 ~ 
 ~ - Redistributions of source code must retain the above copyright notice, this 
 ~   list of conditions and the following disclaimer.
 ~ - Redistributions in binary form must reproduce the above copyright notice, 
 ~   this list of conditions and the following disclaimer in the documentation 
 ~   and/or other materials provided with the distribution.
 ~ - Neither the name of the NHIN Connect Project nor the names of its 
 ~   contributors may be used to endorse or promote products derived from this 
 ~   software without specific prior written permission.
 ~ 
 ~ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 ~ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 ~ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ~ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 ~ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 ~ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 ~ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 ~ INTERRUPTION HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 ~ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ~ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 ~ POSSIBILITY OF SUCH DAMAGE.
 ~ 
 ~ END OF TERMS AND CONDITIONS
 ~
-->

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>
<body>
<div id="suiteBodyHeader">
    <div class="suiteBodyHeaderTop">
        <div id="suiteBodyTitle">Search for Patient</div>
    </div>
</div>
    <div id="searchForm">
        Enter one or more search parameters
        <form id="searchInput">
            <table>
                <tr>
                    <td><input id="searchLastName" name="lastName" type="text" style="width:100px"></td><td><input id="searchFirstName" name="firstName" type="text" style="width:100px"></td>
                    <td><input id="searchMiddleName" name="middleName" type="text" style="width:100px"></td><td><input id="searchCity" name="city" type="text" style="width:100px"></td>
                    <td><input id="searchDOB" name="dateOfBirth" type="text" style="width:100px"></td><td><input id="searchGender" name="gender" type="text" style="width:100px"></td>
                    <td><input id="searchSSN" name="ssn" type="text" style="width:100px"></td><td><input id="searchMedicalRecNo" name="medicalRecordNo" type="text" style="width:100px"></td>
                </tr>
                <tr>
                    <td><label for="searchLastName">LAST NAME</label></td><td><label for="searchFirstName">FIRST NAME</label></td>
                    <td><label for="searchMiddleName">MI</label></td><td><label for="searchCity">CITY</label></td>
                    <td><label for="searchDOB">DOB</label></td><td><label for="searchGender">GENDER</label></td>
                    <td><label for="searchSSN">SOCIAL SEC. #</label></td><td><label for="searchMedicalRecNo">MEDICAL RECORD #</label></td>
                </tr>
            </table>
        </form>
        <div>
            <span>
                 <input id="searchTypeNHIN" name="searchType" type="checkbox" value="NHIN"/><label for="searchTypeNHIN">NHIN</label>
                 <input id="searchTypeOrg" name="searchType" type="checkbox" value="Organization"/><label for="searchTypeOrg">Organization</label>
                 <input id="searchTypeMedCenter" name="searchType" type="checkbox" value="Medical Center"/><label for="searchTypeMedCenter">Medical Center</label>
                 <input id="searchTypeClinic" name="searchType" type="checkbox" value="Clinic"/><label for="searchTypeClinic">Clinic</label>
             </span>
        </div>
        <button style="float:right" id="searchButton">Search</button>
    </div>

    <h3 style="line-height:30px;padding-top:10px">Search Results:</h3>
    <div id="suiteBody"><table id="searchGrid" class="suiteGrid"></table></div>
    <div style="float:right;padding:10px 0"><button id="patientCancel" style="display:none">Cancel</button><button id="patientSelect" style="display:none">Select Patient</button></div>
    <!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'searchPatient';
        if (sirona.patient.patientId) $('#patientCancel').show(); // Show the cancel button if there is an active patient
        var _patientsGrid = $('#searchGrid');

        $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
            _patientsGrid.jqGrid('setGridWidth', $('#suiteBody').width());
        });

        $('#patientSelect').click(function() {
            var _iRowId = _patientsGrid.jqGrid('getGridParam','selrow');
            if (_iRowId) {
                var _rowData = _patientsGrid.getRowData(_iRowId);
                
                sirona.requestPatientChange(_rowData.patientId);
                /*
                sirona.localOnce = true;
                sirona.reqPS('getAccount', { view:_thisView, data:{patientId:_rowData.patientId},
                    success:function(data) {
                        $.publish( '/emr/patientSelected',[ $.extend(_rowData, data) ] ); // Publish the row data selected and data returned
                    }
                },'accountFact');
                */
            }
        });
        $('#patientCancel').click(function() {
            $.publish( '/emr/patientSelected',[ sirona.patient ] ); // Publish the row data selected, to be used by other widgets
        });

        $('#searchButton').click( function() {
            sirona.localOnce = true;
            sirona.reqPS('searchPatient', { view:_thisView, data: $('#searchInput').serialize() + '&searchType=' + $('#searchForm input:checked').map(function(){ return this.value; }).get().join(','),
                success: function(data) {
                    // Load and populate the Inbox grid
                    _patientsGrid.jqGrid({
                        datatype: "jsonstring",
                        //datastr:data,
                        //TODO: Use line above
                        datastr: parent.getCCOWFrame().contentWindow.TMPGetPatientData(),
                        loadonce: true,  // loads the data from the server only once.  Sets the datatype to local afterwards for sorting
                        jsonReader: {
                            root: "patients",
                            repeatitems:false
                        },
                        colNames:[ '','', 'Last Name', 'First Name', 'Middle', "Address", 'City', 'DOB', 'Gender', 'SS#', 'MR#', 'PCM', 'Status' ],
                        colModel:[
                            {name:'patientId', hidden:true },
                            {name:'contactId', hidden:true },
                            {name:'lastName'},
                            {name:'firstName' },
                            {name:'middleName' },
                            {name:'address' },
                            {name:'city' },
                            {name:'dateOfBirth' },
                            {name:'gender' },
                            {name:'ssn' },
                            {name:'medicalRecordNo', hidden:true  },
                            {name:'primaryDoctor' },
                            {name:'patientStatus' }
                        ],
                        forceFit:true, hoverrows:false,
                        loadComplete: function() {
                            $.publish( '/suite/bottomHalfLoaded',[] );
                            if ($(this).jqGrid('getGridParam', "reccount") > 0) {
                                $('#patientSelect').show();
                                $(this).jqGrid('setSelection',"1"); // Select the first row after the grid is loaded
                            }
                        }
                    });
                }
            },'searchPatientFact');
        });
    });
</script>
</body>
</html>