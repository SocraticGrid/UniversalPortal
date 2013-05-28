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
    <link type="text/css" href="css/diagnosticGuide.css" rel="stylesheet" />
</head>
<body>
    <div id="suiteBodyHeader">
        <div class="suiteBodyHeaderTop"><div id="suiteBodyTitle">Diagnostic Guide</div></div>
    </div>

    <div id="suiteBody">
        <div id="suiteSplitBottom">
            <div id="suiteBodyHeaderBottom">
                <div style="line-height:20px;border-bottom:1px solid #ccc" class="contentPadding">
                    <span id="dxGuideModel" style="font-size:14px;font-weight:bold"></span>
                    <div id="dxGuideDiseaseProb" style="float:right;line-height:15px;">
                            <div style="padding-right:10px">Disease Probability:</div><div id="dxGuideDiseaseProbColors"><div>LOW</div><div>AVERAGE</div><div>HIGH</div><div>VERY HIGH</div></div>
                    </div>
                </div>
            </div>
            <div id="emrDiagGuideWrapper" class="contentPadding">
                <div id="emrDiagGuide"></div>
            </div>
            <!-- Dialog overlay and input div -->
            <div id="dxGuideActionDetail" class="dxGuideDialog emrDiagActionNodeNormal" style="padding:0 15px 15px 15px">
                <div class="suiteCloseButtonHeader"><div class="suiteCloseGraphic" style="padding-right:3px" onclick="$.publish( '/dxGuide/dialogClose',[])"></div></div>
                <div style="width:400px;float:left;">
                    <div id="dxGuideSurveyHeader" style="height:70px"></div>
                    <div id="dxGuideSurvey" class="suiteBorder contentPadding" style="height:175px;overflow-y:auto"></div>
                </div>
                <div style="float:left;padding-left:20px; width:100px">
                    <!--<div class="primaryBG emrDiagActionNodeHeading lightLines" style="font-size:10px;font-weight:bold;">AVAILABILITY</div>-->
                    <!--<div class="primaryBG" style="height:60px"></div>-->
                    <div class="primaryBG emrDiagActionNodeHeading lightLines" style="margin-top:70px;font-size:10px;font-weight:bold;">OPTION STATUS</div>
                    <div id="dxGuideStatus" class="primaryBG dxDiagActionStatus" style="padding:10px"></div>
                </div>
                <div style="clear:both;position:relative">
                    <div id="dxGuideActionControl"></div>
                    <div style="position:absolute;right:0;top:0"><button onclick="$.publish( '/dxGuide/dialogClose',[])">Done</button></div>
                </div>
            </div>
        </div>
    </div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(document).ready (function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'diagnosticGuide';
        var _dxGuide = $('#emrDiagGuide');
        var _dxSurvey = $('#dxGuideSurvey');

        function getDxGuide(refresh) {
            var _api = (sirona.debugIt)?'getDiagnosticGuideProcessStatus-PSTest2':'getDiagnosticGuideProcessStatus';
            if (sirona.debugIt) sirona.localOnce=true;
            sirona.reqPS(_api, { view:_thisView, data: { 'forceRefresh':true, 'patientId':sirona.patient.id, 'dxProcessId':sirona.viewData[_thisView].dxProcessId },
                success: function(data) {
                    if (refresh) decisionTree.drawEntire(data);
                    else decisionTree.init(data, _dxGuide);

                    // Draw the status <div> box to show the status of the current decision.
                    var _statusBox =
                        '<div id="dxGuideDecisionStatus" class="lightBG"><div style="line-height:25px;border-bottom:1px solid #fff; padding-left:15px">Decision status - </div>' +
                            '<div class="contentPaddingFixed"><h3>You are running ' + _dxGuide.find('.emrDiagActionClickable.lightBG').length + ' options.' + '</h3>' +
                                '<table>';
                    // Create a status row for each active
                    _dxGuide.find('.emrDiagActionClickable.lightBG').each( function() {
                        _statusBox += '<tr><td style="text-align:right">' + $('.emrDiagActionNodeHeading',this).html() + '</td><td>' + $(this).next().text() + '</td></tr>'
                    });
                    _statusBox += '</table>';

                    // PS will return a flag whether or not the current entire diagnostic guide can be cancelled  Expose the button if available.
                    if (data.canCancel) {_statusBox +=
                                '<div style="padding-top:15px">Press Cancel Dx Guide if you do not intend continue with this Diagnostic Guide.<br/>' +
                                    '<button onclick="$.publish(\'/dxGuide/complete\',[\'Cancel\'])">Cancel Dx Guide</button>' +
                                '</div>';
                    }
                    // PS will return a flag whether or not the current decision can be advanced.  Expose the button if available.
                    if (data.canAdvance) {_statusBox +=
                                '<div style="padding-top:15px">Press Move Forward if you do not intend to start any other Options and are ready to proceed to the next decision stage.<br/>' +
                                    '<button onclick="$.publish(\'/dxGuide/advance\',[])">Move Forward</button><button onclick="$.publish(\'/dxGuide/complete\',[ \'Complete\'])">Complete Dx Guide</button>' +
                                '</div>';
                    }
                    _statusBox +=
                            '</div>' +
                        '</div>';

                    _dxGuide.append(_statusBox);
                    resizeContent.updateAll();
                }
            }, 'diagnosticGuideProcess');
        }

// SUBSCRIBERS
        $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
            $('#emrDiagGuideWrapper').outerHeight(resizeObj.suiteSplitBottomH - resizeObj.suiteBodyHeaderBottomH );
        });
        $.subscribe('/emr/severityLevel', _thisView, function(severityIdx, severityColor) {
            // Displays the current disease probability in a graphic if published
            $('#dxGuideDiseaseProbColors div').removeClass('dxGuideDiseaseProbActive');
            $('#dxGuideDiseaseProbColors div:eq(' + severityIdx + ')').css({ backgroundColor:severityColor }).addClass('dxGuideDiseaseProbActive');
        });

// SUBSCRIBERS
        $.subscribe('/dxGuide/dialogClose', _thisView, function() {
            $('.dxGuideDialog').hide();
            $('#suiteDialogOverlay').hide();
//            $.publish( '/suite/dialogClose',[]);
            _dxSurvey.empty();
            $("#emrDiagGuideWrapper").css( { overflow:'auto' } );
            getDxGuide(true);  // Redraw the entire diagram when the action dialog closes (for now)
        });

        $.subscribe('/dxGuide/advance', _thisView, function() {
            if (sirona.debugIt) sirona.localOnce=true;
             sirona.reqPS('advanceDiagnosticGuideProcess', { view:_thisView, data: { patientId:sirona.patient.id, dxProcessId:sirona.viewData[_thisView].dxProcessId },
                 success: function(data) {
                     getDxGuide(true);  // Redraw the entire diagram when the action dialog closes (for now)
                 }
             }, 'diagnosticGuideProcess'); // , 'POST'
        });
        $.subscribe('/dxGuide/complete', _thisView, function(status) {
            if (sirona.debugIt) sirona.localOnce=true;
             sirona.reqPS('completeDiagnosticGuideProcess', { view:_thisView, data: { patientId:sirona.patient.id, dxProcessId:sirona.viewData[_thisView].dxProcessId, status:status },
                 success: function(data) {
                     getDxGuide(true);  // Redraw the entire diagram when the action dialog closes (for now)
                 }
             }, 'diagnosticGuideProcess'); // , 'POST'
        });
        $.subscribe('/riskModels/changeModel',_thisView, function(objData) {
            sirona.viewData.diagnosticGuide = objData;
            $('#dxGuideModel').html(objData.title);
            $('#dxGuideDiseaseProb').toggle(objData.dxProcessId!=undefined);
            if (objData.dxProcessId) getDxGuide(true);
            else _dxGuide.html('<div>A Diagnostic Guide has not been started for this Risk Model</div>');
        });

        $.subscribe('/suite/surveyAnswered', _thisView, function(objData) {
            alert('dxguide: '+ concatObject(objData));
            if (objData.cssClass != 'suiteSurveyDxGuideControl') return false; // Only process control questions

        });
        $.subscribe('/dxGuide/actionDetail', _thisView, function( action ) {
            // Subscribe to when a user clicks an Action node.  Display the Action detail dialog.
            $("#emrDiagGuideWrapper").css( { overflow:'hidden' } );

            $('#dxGuideActionDetail').css({ top:30, left:_dxGuide.offset().left +
                    ( ( _dxGuide.width() - $('#dxGuideActionDetail').width() ) / 2 ) });

            // Check the action type clicked.  If it's either a Low or Other action, then display the choices instead of a survey
            if (action.attr('id')) {
                var _actionData = action.closest('.emrDiagStage').data(action.attr('id'));
                $('#dxGuideStatus').html(_actionData.status);
                $('#dxGuideSurveyHeader').html(action.children('div').clone()).children('.emrDiagActionContent').addClass('dxGuideActionHeader');

                // Look for all surveys inside of the content body
//alert('dxguide: '+ concatObject(_actionData));
                _dxSurvey.html(_actionData.body);
                $('[type="survey"]', _dxSurvey).each(function() {
                    // Look inside the body for <p type="survey"> tags.  If found, call getSurvey
                    var _surveyId = $(this).attr('id');
                    if (sirona.debugIt) sirona.localOnce=true;
                    sirona.reqPS('getSurvey', { view:_thisView, data: { 'patientId':sirona.patient.id, 'surveyId':_surveyId },
                        success: function(data2) {
                            // force the questions to be disabled if the action has not been started yet
//                            if (_actionData.status.toLowerCase()=='not started') $.each(data2.surveyQuestions, function() { this.action = 'disable'});
                            renderSurvey($.extend(data2,{'cssClass':'suiteSurveyDxGuideAction'}), $('#'+_surveyId) );
                            if (_actionData.status.toLowerCase()=='not started') $('input,button,select', $('#'+_surveyId)).attr('disabled','disabled');
                        }
                    }, 'surveyFact');
                });

                // Get the control questionnaire (survey) for the selected action node
                var _api = (sirona.debugIt)?'getSurvey-control':'getSurvey';
                if (sirona.debugIt) sirona.localOnce=true;
                sirona.reqPS(_api, { view:_thisView, data:{ patientId:sirona.patient.id, surveyId:_actionData.questionnaireId },
                    success: function(data) {
                        renderSurvey($.extend(data,{'cssClass':'suiteSurveyDxGuideControl'}), $('#dxGuideActionControl') );
                    }
                }, 'surveyFact');
            } else {
                $('#dxGuideActionButtons').removeData();  // Clear the data for when the buttons are pressed
                $('#dxGuideSurveyHeader').html('<h4>Please choose an option to start:</h4>');
                $('#dxGuideSurveyHeader').prepend(action.html());

                var _options = '<ul>';
                $.each(action.data(), function() {
                    _options += '<li><input name="chooseDxAction" type="radio" value="' + this.actionId + '">' + this.descr + '</input></li>'
                });
                $('#dxGuideSurvey').append(_options + '</ul>');
            }
            $('#suiteDialogOverlay').show();
            $('.dxGuideDialog').css( { display:'inline'} ).show();
//            $.publish('/suite/dialogShow',[ null, { body:$('#dxGuideActionDetail').html(), 'width':700, 'height':500, 'top':($(window).height()-500)/2, 'left':($(window).width()-700)/2 }] );

        });

// INITIALIZATION
        $('#dxGuideModel').html(sirona.viewData.diagnosticGuide.title);
        getDxGuide(false);
     });
</script>
</body>
</html>