<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<body>
<div id="suiteTopTabNav">
    <table class="tblClean">
        <tr id="suiteTopTabs" style="cursor:pointer;">
            <c:if test="${config['portal.display.desktop'] == 'true'}">
                <td class="suiteTabL"></td><td class="suiteTabActive"><div class="suiteTabText">Desktop</div></td><td class="suiteTabR"></td>
            </c:if>
            <c:if test="${config['portal.display.patient'] == 'true'}">    
                <td class="suiteTabLD"></td><td class="suiteTabInactive"><div id="topNavPatient" class="suiteTabText">Patient Records</div><div class="allergyIcon"></div><div class="inactiveSearchIcon" id="topNavSearch"></div></td><td class="suiteTabRD"></td>
            </c:if>
            <c:if test="${config['portal.display.simulator'] == 'true'}">
                <td class="suiteTabLD"></td><td class="suiteTabInactive"><div class="suiteTabText">Simulator</div></td><td class="suiteTabRD"></td>
            </c:if>
        </tr>
    </table>
</div>
<!-- Script to load data should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'topNavTabs';
        var _parent = $('#suiteTopTabs');

        _parent.undelegate().delegate('td', 'click', function(e) {
            var _tabIndex = parseInt(this.cellIndex/3)*3; // Get the starting index of the tab clicked

            $('.suiteTabL').attr('class','suiteTabLD');
            $('.suiteTabActive').attr('class','suiteTabInactive');
            $('.suiteTabR').attr('class','suiteTabRD');

            _parent.children(":eq(" + _tabIndex + ")").attr('class','suiteTabL');
            _parent.children(":eq(" + (_tabIndex+1) + ")").attr('class','suiteTabActive');
            _parent.children(":eq(" + (_tabIndex+2) + ")").attr('class','suiteTabR');

            var _isPatientTab = _parent.children(":eq(" + (_tabIndex+1) + ")").find('#topNavPatient').length === 1;

            var _tabContent = '';
            if (_isPatientTab) {
                // User clicked the patient tab
                $('#topNavSearch').attr('class', 'activeSearchIcon');
                if ($(e.target).attr('id') == 'topNavSearch') {
                    _tabContent = 'Patient Records';
                    delete sirona.patient.id;   // Remove the patient context when intending to search for a new one
                    delete sirona.patient.patientId;
                }  // Set the tab content to default, then the topTabNavigate subscription will show the search widget
                else  {
                    _tabContent = $('#topNavPatient').text();
                    if (sirona.patient.patientId) sirona.patient.id = sirona.patient.patientId;      // Change the context back to the current patient
                }
            } else {
                delete sirona.patient.id;   // Not on a patient tab, so remove the context
                delete sirona.patient.patientId;
                $('#topNavSearch').attr('class', 'inactiveSearchIcon');
                _tabContent = $('.suiteTabActive .suiteTabText', _parent).html();
            }
            $.publish( '/suite/topTabNavigate',[ _tabContent ],e );
        });

        $.subscribe('/emr/patientSelected', _thisView, function(rowData) {
            if (rowData){
                sirona.patient = rowData;
                sirona.patient.id = sirona.patient.patientId;
                sirona.patient.displayName = rowData.firstName + ((rowData.middleName && rowData.middleName !='')?' '+rowData.middleName:'') + ' ' + rowData.lastName;
                $('#topNavPatient').html('Patient: ' + sirona.patient.displayName);
                //$.publish( '/suite/topTabNavigate',[ $('#topNavPatient').html() ] );  // Publish that the new patient was selected
                $('#topNavPatient').trigger('click');
            }else{
                $('#topNavPatient').html('Patient Records');
                //$.publish( '/suite/topTabNavigate',[ $('#topNavPatient').html() ]);
                $('#topNavSearch').trigger('click');
            }
            
        
        });
// INITIALIZATION
//        $.publish( '/suite/topTabNavigate',[ 'Simulator' ] );
        if (sirona.debugIt){
//            $.publish( '/suite/topTabNavigate',[ 'Simulator' ] ); // TODO testing
            //$.publish( '/emr/patientSelected',[ { patientId:'99990070', firstName:'Jane', middleName:'Test', lastName:'Doe',hasAllergies:true, contactId:'doe.jane' } ] ); // TODO testing
            //$.publish( '/suite/topTabNavigate',[ 'Desktop' ] );
        } else{
            $.publish( '/suite/topTabNavigate',[ 'Desktop' ] );
        }
    
        parent.getCCOWFrame().contentWindow.syncContextPatient();
    });
</script>
</body>
</html>