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
    <style type="text/css">
        /* Diagnostic guide indicator */
        #providerClinicalAccordion .dxGuideProgress { position:absolute; display:none; right:30px; bottom:10px; height:14px; width:12px }
        #providerClinicalAccordion .dxGuideOpen { background: url("images/dxGuide_active.png") no-repeat }
        #providerClinicalAccordion .dxGuideClosed { background:url("images/dxGuide_inactive.png") no-repeat }
        /* Risk Model open or closed*/
        #providerClinicalAccordion .riskModelOpen { position:absolute; background:url("images/riskModelActive.png") no-repeat; width:14px; height:8px; right:10px; bottom:11px; }
        #providerClinicalAccordion .riskModelClosed { position:absolute; background: url("images/riskModelClosed.png") no-repeat; width:8px; height:14px; right:10px; bottom:11px; }

        /* Override the styles for the accordion */
        #providerClinicalAccordion .ui-accordion-content{ padding:0 0 0 10px; margin:-2px 0 0 0; font-size:11.5px; background:#ddeeee; border-color:#0092b4 } /* Content area background and styling */
        #providerClinicalAccordion .ui-state-active { border-left-color:#0092b4 }   /* Put a border color on the left for active sections */
        #providerClinicalAccordion .ui-accordion-header.ui-state-active { margin-top:0 }  /* Get rid of margin top spacing */
        .providerPredictiveSurvey { border-top:2px solid #fff; border-bottom:2px solid #fff }   /* Border on top and bottom of survey */
     </style>
</head>
<body>
<div id="suiteBodyHeaderTop"></div>
<table id="providerClinicalContent" class="tblClean">
    <tr>
        <td style="padding-top:25px"><img id="providerClinicalHandle" src="images/Clinical-Analytics-Handle-8.png" style="cursor:pointer"></td>
        <td id="providerClinicalLabel" class="primaryBG" style="padding-top:25px"><img src="images/clinicalAnalytics.png"></td>
        <td class="primaryBG" style="padding-top:25px">
            <div id="providerClinicalAccordion" class="darkLinesTop"></div>
            <img id="maintainModels" src="images/gears3.png" style="cursor:pointer;padding:5px 0">
        </td>
    </tr>
</table>

<script type="text/javascript">
    $(function() {
        if (!sirona) return false; // Cannot be loaded without a template which loads the global namespace
        var _thisView = 'providerPredictive', _drawerInit = false;

        var _favoriteModelIds = [], _displayThresholds = [], _cssClass='suiteSurveyRisk';         // Used to setup the publishes and CSS class for each question inside the renderSurvey function.
        var _accordion =  $('#providerClinicalAccordion');

        $('#maintainModels').click( function() {
            // Maintenance dialog, using relative positions of the accordion and the drawer.  Also pass the favorite models to it so they can be preselected
            showDialog('dialogSelectRiskModels', { width:400 });
        });

        // Pulsating function for in progress Dx Guides
        function pulsate() {
            $('.dxGuideInProgress').animate({backgroundColor:"#c7eaf2" }, 1000) // , 'linear'
                .animate({backgroundColor:"#2cb2ce" }, 1000, null, pulsate);
        }
        function getModels(bUpdate) {
            if (!sirona.patient.id) return false;

            // Get the providers favorite list of models, then render them
            if (sirona.debugIt) sirona.localOnce=true;
            sirona.reqPS('getRiskModels', { view:_thisView, data:{ patientId:sirona.patient.id, type:"Favorites" },
                success: function(data) { _drawerInit=true; renderModels(data, bUpdate) }
            }, 'riskModels');
        }
        function renderModels(modelData, bUpdate) {
            if (!sirona.patient.id) return false;

            if (!bUpdate) {
                _accordion.empty(); _favoriteModelIds=[];

                // Loop through all the models, storing the modelId and the displayThreshold for each, then opening the drawer if any of them have crossed threshold
                $.each(modelData.models, function() {
                    _favoriteModelIds.push(this.modelId);
                    _displayThresholds[this.modelId] = (this.displayThreshold)?this.displayThreshold:100;
                });
            }
// MODELS
            if (sirona.debugIt) sirona.localOnce=true;
            sirona.reqPS('getRiskModelsDetail', { view:_thisView, data:{ modelIds:_favoriteModelIds.join(','), patientId:sirona.patient.id },
                success: function(modelDetailData) {
//                    if (sirona.debugIt) sirona.getView('diagnosticGuide', modelDetailData); // TODO testing

                    // Preprocess the result to sort by the severity level based on the description in the metadata
                    $.each(modelDetailData.riskModels, function(idxRiskModel) {
                        this.severityLevel = sirona.providerTemplate.dxGuideStageSeverities.indexOf(this.severity);
                    });
                    modelDetailData.riskModels.sort(sort_by('relativeRisk', true));     // Sort by decending relative risk

                    // Update the models list
                    $.each(modelDetailData.riskModels, function(idxRiskModel) {
                        if (!bUpdate) {
                            // For each model object received, build and display the clickable heading
                            var _accordionData =
                                '<div><h3 id="' + this.modelId + '" class="darkLines"><div style="padding:3px 0 3px 10px">' +
                                    '<span class="riskModelHeadingText"></span><span class="dxGuideClosed dxGuideProgress"></span><span class="riskModelClosed providerModelStatus"></span></div></h3>' +
                                '<div><div style="font-weight:bold;padding-top:12px;margin-right:10px;border-top:1px dashed #ffffff">' + this.disease + '</div>' +
                                    '<div class="providerPredictiveSurvey"></div>' +
                                    '<div class="providerDxGuideControl" style="padding:5px 0">' +
                                        '<span><button class="providerRiskSurveySubmit" style="display:none">Submit</button></span>' +
                                        '<span style="padding-left:5px"><button class="providerDxGuideButton">' + ((this.dxProcessId)?'Show':'Start') + ' Dx Guide</button></span>' +
                                    '</div>' +
                                '</div>'; // Only 2 divs per Accordion item

                            _accordion.append(_accordionData);

                            // Apply the dxGuide icon as necessary
                            if (this.dxProcessId) {
                                var _dxStatus = $('#' + this.modelId).find('.dxGuideProgress');
                                _dxStatus.show();
                                if (this.dxGuideStatus && this.dxGuideStatus == 'Started') {
                                    _dxStatus.addClass('dxGuideInProgress');
                                }
                                if (idxRiskModel==0) _dxStatus.toggleClass('dxGuideOpen dxGuideClosed');
                            }
                        }
                        // Update the relative risk heading
                        var _newModelHeading = $('#providerClinicalAccordion #'+this.modelId);
                        $('.riskModelHeadingText', _newModelHeading).html('<b>' + this.title.substr(0, 25) + '</b><br/>' + this.relativeRisk + '%&nbsp;(+/-' + this.relativeRiskRange + ')');

                        // Put the risk model data object into the <h3> heading, so it can be used when it's clicked
                        _newModelHeading.data(this);

                        // Check to see if the drawer should be displayed
                        if (this.relativeRisk && (parseInt(this.relativeRisk) >= _displayThresholds[this.modelId]) )
                            $.publish('/provider/drawerHandle',[true]);  // Force open the drawer (passing true)

                    });

                    if (!bUpdate) {
                        // Destroy and recreate the accordion
                        _accordion.accordion('destroy').accordion({
                            header: "h3", autoHeight:false, icons:false,
                            changestart: function (e, ui) {
                                $.publish('/riskModels/changeModel',[ui.newHeader.data()]);
                            },
                            create: function(e, ui) {  // Create the accordion and default to the first item
                                if (modelDetailData.riskModels[0]) $.publish('/riskModels/changeModel',[modelDetailData.riskModels[0]]);
                            }
                        });
                    }

                    // Done loading, so style the drawer handle probability color
                    var _highestSeverity = 0;
                    $.each(_accordion.find('h3'), function() {
                        var _idxSeverity = sirona.providerTemplate.dxGuideStageSeverities.indexOf($(this).data('severity'));
                        if (_idxSeverity < 0) _idxSeverity = 0;
                        if (_idxSeverity > _highestSeverity) _highestSeverity = _idxSeverity;

                        $('.providerModelStatus', $(this)).css({
                             backgroundColor: sirona.providerTemplate.predictiveSeverityColors[_idxSeverity]});
                    });
                    $('#providerClinicalHandle').css({ backgroundColor:sirona.providerTemplate.predictiveSeverityColors[_highestSeverity]});

                    pulsate();
                }
            }, 'riskModels');
        }
// SURVEYS
        function getSurvey(modelObj) {
            if (!sirona.patient.id) return false;

            $('.providerRiskSurveySubmit').hide();
            if (!modelObj.modelId || $('#'+modelObj.modelId).length == 0) return;
            // Get the parent of the <h3> accordion header, then find the survey container class
            var _surveyContainer = $('#' + modelObj.modelId).parent().find('.providerPredictiveSurvey');
//            _surveyContainer.empty().hide();

            // Look to see if the selected model has a surveyId loaded
            if (sirona.debugIt) sirona.localOnce=true;
            sirona.reqPS('getSurvey', { view:_thisView, data:{ patientId:sirona.patient.id, surveyId:modelObj.surveyId },
                success: function(data) {
                    renderSurvey($.extend(data,{'cssClass':_cssClass}), _surveyContainer );
                    if (_surveyContainer.not(':empty')) $('.providerRiskSurveySubmit').show();
                }
            }, 'surveyFact');
        }

        function pollForRiskModels() {
            // Check for any dirty models
            if (sirona.patient.id) renderModels({ modelIds:_favoriteModelIds }, true);  // Update the models displayed by sending true
        }

// SUBSCRIBERS
        // Publisher for starting a diagnostic guide
        $('#providerClinicalAccordion').undelegate().delegate('.providerDxGuideButton', 'click', function() {
            if (!sirona.debugIt) {alert('Waiting to do initial testing with refactored DSA'); return false; }
            var _modelData = $(this).closest('.ui-accordion-content').prev().data();  // Selects the H3 container, which has the data needed
            if (!_modelData.dxProcessStatus || _modelData.dxProcessStatus.toLowerCase() == 'not started') {
                if (sirona.debugIt) sirona.localOnce=true;
                sirona.reqPS('startDiagnosticGuideProcess', { view:_thisView, data: { patientId:sirona.patient.id, disease:_modelData.disease },
                    success: function(data) {
                        _modelData.dxProcessId = data.dxProcessId;
                        sirona.getView('diagnosticGuide', _modelData);
                    }
                }, 'diagnosticGuideProcess');   // , 'POST'
            } else {
                sirona.getView('diagnosticGuide', _modelData);
            }
            return false;
        });
        $.subscribe('/suite/widgetLoaded', _thisView, function(dataObj) {
            // This subscription is used to tell when the main body changes
            $(".providerDxGuideButton").toggle(!sirona.viewData['diagnosticGuide']);  // Do not show the "Show" button if the Dx Guide is already visible
        });


        $.subscribe('/suite/surveyAnswered', _thisView, function(objData) {
            if (objData.cssClass != _cssClass) return false; // Only process answered questions for this widget

            var _modelData = objData.question.closest('.ui-accordion-content').prev().data();
            // Get the current relative risk from the data object stored in the heading of the accordion
            // If the tasksProgress reaches 100%, or moves from 100% by unanswering a question, then getRiskModelsDetail to see if the relativeRisk or severity changed
            if ( (objData.tasksProgress && parseInt(objData.tasksProgress) == 100) || !_modelData.tasksProgress || _modelData.tasksProgress == 100) {
                _modelData.tasksProgress = parseInt(objData.tasksProgress);
                renderModels({ modelIds:[_modelData.modelId] }, true);  // Render only this model by sending bUpdate=true
            }
        });

        $.subscribe('/riskModels/changeModel',_thisView, function(objData) {
            $('.riskModelOpen').toggleClass('riskModelOpen riskModelClosed');
            $('.providerModelStatus', '#'+ objData.modelId).toggleClass('riskModelOpen riskModelClosed');

            $('.dxGuideOpen').toggleClass('dxGuideOpen dxGuideClosed');
            $('.dxGuideProgress', '#'+ objData.modelId).toggleClass('dxGuideOpen dxGuideClosed');

            $(".providerDxGuideButton").toggle((!objData.dxProcessId || !sirona.viewData['diagnosticGuide']));
            getSurvey(objData);
        });
        $.subscribe('/riskModels/selected',_thisView, function(modelIds) {
            getModels(false);   // Send false to create the accordion from scratch
        });
        $.subscribe('/provider/drawerOpen', _thisView, function() {
            if (!_drawerInit) getModels(false);
        });

// PUBLISHERS
        // Publish that the drawer handle was clicked
        $('#providerClinicalHandle').click(function (e) {
            $.publish('/provider/drawerHandle',[],e)
        });

        
// INITIALIZATION
//        getModels(false);   // Send false to create the accordion from scratch

// TIMER - set in the global config.  Cannot be set for less than 10 seconds
        var _pollingInt = sirona.providerTemplate.predictiveAnalysisPollingInterval;
//        if (!sirona.timers[_thisView]) sirona.timers[_thisView] = setInterval(pollForRiskModels, ((_pollingInt && parseInt(_pollingInt)<10000)?10000:_pollingInt));
    });
</script>
</body>
</html>