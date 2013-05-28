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
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<script type="text/javascript" src="../js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../js/jquery-ui-1.8.18.custom.min.js"></script>

<script type="text/javascript" src="../js/grid.locale-en.js"></script>
<script type="text/javascript" src="../js/jqGrid-4.3.1.min.js"></script>
<script type="text/javascript" src="../js/emrUtility.js"></script>

<script type="text/javascript" src="../js/pubsub.js"></script>
<script type="text/javascript" src="../js/suiteUtility.js"></script>


<SCRIPT type="text/javascript">
    
    //Presentation Service parameters
    var token = "${token}"; 
    var providerId = "${providerId}"; 
    var userId = "${userId}"; 

    //Portal parameters
    var patientId = "${patientId}"; 
    var contextStatus = "${contextStatus}"; 
    
    
    //TODO: delete this function
    function TMPGetPatientData(){
return jQuery.parseJSON('{ "patients": [  { "patientId":"99990070", "contactId":"bcma.eight", "lastName": "Doe", "firstName": "Jane", "middleName": "", "address": "123 Garry Lane", "city": "San Diego", "dateOfBirth": "1945-11-04", "gender": "F", "ssn": "123-45-6789" , "medicalRecordNo":"med01" , "primaryDoctor":"Dr. Smith", "patientStatus":"Inpatient" } ], "successStatus": true, "statusMessage": "" }');    }
    
    
    function getAppFrame() {
        return top.document.getElementById('app');
    }
    
    function getAppWindow() {
        return getAppFrame().contentWindow;
    }

    function changeAppSrc(src) {
        getAppFrame().src = src;
    }    
    
    function getEnablerApplet() {
        return top.document.getElementById("enabler");
    }

    function getCCOWStatusImage() {
        return getAppWindow().document.getElementById('ccowStatus');
    }

    function isCCOWActive(){
        return contextStatus === "1";
    }

    function syncCCOWStatusImage() {
        var ccowImg = getCCOWStatusImage();
        if (ccowImg){

            if (isCCOWActive()) {
                ccowImg.src = "images/ccow/link.gif";
                ccowImg.title = "Joined. Click to leave the context.";
                ccowImg.onclick = function (e) { 
                    parent.getCCOWFrame().src = "servlet/ccow?action=leave";
                };
            } else {
                ccowImg.src = "images/ccow/unlink.gif";
                ccowImg.title = "Not Joined. Click to join the context.";
                ccowImg.onclick = function (e) { 
                    var t = getAppWindow().urlParams['token'];
                    var u = getAppWindow().urlParams['userId'];
                    var p = getAppWindow().urlParams['providerId'];
                    parent.getCCOWFrame().src = "servlet/ccow?action=join&token="+t+"&userId="+u+"&providerId="+p;
                };
            }
        }
    }
    
    function syncContextPatient(){
        var sirona = getAppWindow().sirona;
        if (sirona){
            changeCurrentPatient(patientId);
        }
    }

    function changeCurrentPatient(patientId) {
        var sirona = getAppWindow().sirona;
        if (patientId !== "" && ( !sirona.patient || patientId != sirona.patient.patientId)) {
            
            sirona.localOnce = true;
            sirona.reqPS('getAccount', {view: 'searchPatient', data: {patientId: patientId},
                success: function(data) {
                    //TODO: use PS' data instead
                    var patients = TMPGetPatientData();
                    patients = patients.patients;
                    $.each(patients, function(i, p){
                        if (p.patientId == patientId){
                            data = p;
                        }
                    });
                    /////
                    
                    getAppWindow().$.publish('/emr/patientSelected', [data]); // Publish the row data selected and data returned
                }
            }, 'accountFact');
        } else if (patientId === ""){
            getAppWindow().$.publish('/emr/patientSelected', [undefined]);
        }
    }

    syncCCOWStatusImage();

</SCRIPT>