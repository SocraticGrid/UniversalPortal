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
<div id="simNavigation"></div>

<script type="text/javascript">
$(function(){
    if (!sirona) return false; // Cannot be loaded without a template which loads the global namespace
    var _thisView = 'providerSimulatorNav';
    var _navContainer = $('#simNavigation');

// PUBLISHERS
    _navContainer.undelegate().delegate('.simDiseaseNav,li', 'click', function() {
        // Handle all the click events for the navigator.
        if ($(this).hasClass('simDiseaseNav')) {
            if ($('.navSelected', $(this).next()).length != 0) return;  // Dont do anything if there is an active model in this section

            // Expand or collapse the disease
            $(this).prev().toggleClass('ui-icon-triangle-1-e ui-icon-triangle-1-s');
            if ($(this).prev('.ui-icon-triangle-1-s').length == 0) $(this).next().hide();
            else $(this).next().show();
        } else {
            // Model was clicked, select the new one and publish the new model data
            if ($('div:first-child',this).hasClass('navSelected')) return;  // Exit if already selected
            // Remove the previous selected item, and select the new one.
            _navContainer.find('div').removeClass('navSelected primaryText');
            $('div:first-child',this).addClass('navSelected primaryText');

            $.publish('/simulator/modelSelected',[ $(this).data() ]);
        }

        return false;
    });

// SUBSCRIBERS
    $.subscribe('/simulator/modelSelected', _thisView, function(objData) {
        // Initialize the first selected model
        $('#' + objData.modelId + ' div:first-child', _navContainer).addClass('navSelected primaryText');
    });

// INITIALIZATION
    var _disease = '';
    sirona.localOnce=true;  // TODO testing
    sirona.reqPS('getPlanningModels', { view:_thisView,
        success: function(data) {
            var _diseaseCnt = 0;
            $.each(data.models, function(idx) {
                if (this.disease != _disease) {
                    _diseaseCnt ++;
                    // Diseases
                    _navContainer.append(
                        '<div style="cursor:pointer;clear:both"><div style="float:left" class="ui-icon ui-icon-triangle-1-s"></div><div class="simDiseaseNav" >' + this.disease +'</div>' +
                        '<div><ul id="disease' + _diseaseCnt + '"></ul></div></div>'
                    );
                    _disease = this.disease;
                }
                // Model data
                $('#disease' + _diseaseCnt).append(
                    '<li id="' + this.modelId + '" class="simModelNav"><div>' + this.shortDescr +
                        ((this.modelRunInfo)?('<br/>(' + this.modelRunInfo[0].startedSimulations + '/' + this.modelRunInfo[0].resultedSimulations + ')'):'no') +
                    '</div></li>'
                ).children(':last-child').data(this);  // Add the model and it's data


                // Initial click on the first item
                if (idx==0) $.publish('/simulator/modelSelected',[ this ]);
            });
        }
    }, 'simulationProcess');
});
</script>
</body>
</html>