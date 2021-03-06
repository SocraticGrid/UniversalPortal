
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
    <style type="text/css">
        .simSection { margin-top:10px; border:none } /* overrides providerSimulator CSS */
    </style>
</head>
<body>

<div class="contentPadding">
    <div style="float:left;"><select id="simsInProgress" style="width:400px"></select></div>
    <!--<div style="float:left;width:50%"></div>-->
    <div id="simulationRunning"  class="primaryText simSuberHeadings" style="float:right">
        <img src="images/wait_icon2.gif" style="padding-right:20px">SIMULATION RUNNING
    </div>
</div>
<div id="simulatorSimsInProgress"></div> <!-- Simulations in Progress template loaded here -->
<div class="lightBG"><div style="padding:10px 0;float:right">Refresh Every: <select id="simulationRefresh"></select></div></div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'providerSimulatorInProgress';

        var simTmpl = {
            containerId:"simulatorSimsInProgress",
            scoreDetails: {
                breakClass:{field:"type"},
            }
        };
// PUBLISHERS

// SUBSCRIPTIONS
        $('#simsInProgress').change( getSimulationDetail );
        $('#simulationRefresh').change( getSimulationDetail );

        // Manually unload the timer here since the container is not the suiteBody
        $.subscribe('/suite/unloadView', _thisView, function(viewName) {
            if (viewName == _thisView) abortTimer('providerSimulator');
        });

        function getSimulationDetail() {
            abortTimer('providerSimulator');
            var _offset = $('#simulatorSimsInProgress').parent().scrollTop();
            sirona.getView('providerSimulatorSimTmpl', { container:$('#simulatorSimsInProgress'),
                success: function() {
                    var _simData = $('#simsInProgress').find('option:selected').data();      // Get the data from the <option> element
                    $('#simDescription').text(_simData.name);

                    sirona.localOnce=true;  // TODO testing
                    sirona.reqPS('getSimulationDetail', { view:_thisView, data:{ simulationId:_simData.simulationId, modelId:sirona.planningModel.modelId },
                        success: function(data) {
                            formTemplate.loadForm(data, simTmpl);
                            $('#simulatorSimsInProgress').parent().scrollTop(_offset);  // Preserve the vertical scroll location
                            if (data.status != 'Running') $.publish( '/simulator/inProgress', [ data ] )
//                            $('#simulationRunning').toggle(data.status == 'Running');
                            sirona.timers['providerSimulator'] = setInterval(getSimulationDetail, $('#simulationRefresh').find('option:selected').data('milliseconds') );
//$.publish( '/suite/debug', [ new Date() + 'provsiminprogress: '+ _offset + '/' + $('#simulationRefresh').find('option:selected').data('milliseconds') ] );
                        }
                    }, 'simulationProcess');
                }
            });
        }
// INITIALIZATION
        var _refresh = $('#simulationRefresh');
        $.each(sirona.providerTemplate.simulatorInProgressRefresh, function() {
            _refresh.append('<option>' + this.label + '</option>').children(':last-child').data(this);
        });

        var _simId = sirona.viewData.providerSimulatorInProgress.data.simulationId || '';
        sirona.localOnce=true;  // TODO testing
        sirona.reqPS('getSimulations', { view:_thisView, data:{ modelId:sirona.planningModel.modelId },
            success: function(data) {
                if (data.simulationDescriptors)
                    $.each(data.simulationDescriptors, function() {
                        // '<option' + ((this.simulationId==sirona.viewData[_thisView].data.simulationId)?' selected':'') + '>'
                        $('#simsInProgress').append('<option' +
                            ((_simId == this.simulationId)?' selected':'') + '>' + this.name + '</option>')
                            .children(':last-child').data(this);
                    });
                _refresh.change();
            }
        }, 'simulationProcess');
    });
</script>
</body>
</html>