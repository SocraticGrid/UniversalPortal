/*******************************************************************************
 *
 * Copyright (C) 2012 by Cognitive Medical Systems, Inc (http://www.cognitivemedciine.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not 
 * use this file except in compliance with the License. You may obtain a copy of 
 * the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed 
 * under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ******************************************************************************/
 
 /******************************************************************************
 * Socratic Grid contains components to which third party terms apply. To comply 
 * with these terms, the following notice is provided:
 *
 * TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
 * Copyright (c) 2008, Nationwide Health Information Network (NHIN) Connect. All 
 * rights reserved.
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * 
 * - Redistributions of source code must retain the above copyright notice, this 
 *   list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *   this list of conditions and the following disclaimer in the documentation 
 *   and/or other materials provided with the distribution.
 * - Neither the name of the NHIN Connect Project nor the names of its 
 *   contributors may be used to endorse or promote products derived from this 
 *   software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 * END OF TERMS AND CONDITIONS
 *
 ******************************************************************************/

var decisionTree = {
    container:null,
    actionsPerRow:5,
    actionMinW:170,     // Used to leave space between the Action nodes
    init: function(data, container) {
        this.container=container;
        container.undelegate().delegate('.emrDiagActionClickable', 'click', function() {
            $.publish( '/dxGuide/actionDetail', [ $(this) ] );
            return false;
        });
        this.drawEntire(data);
    },
    drawEntire: function(data) {
        // Clear the container and redraw the entire diagram
        this.container.empty();
        // Iterate over all of the stages or decisions of the guide
        $.each(data.diagnosticProcessHistory.DxDecision, function() {
//            alert('dxguide: '+ concatObject(this));
            decisionTree.drawDecision(this);
        });
        this.container.attr({ scrollTop: this.container.height() });    // Start the guide at the bottom
    },
    drawDecision: function(decision){
        // Get the severity color based on the decision severity
        var _severityIdx = sirona.providerTemplate.dxGuideStageSeverities.indexOf(decision.severity);
        var _severityColor = sirona.providerTemplate.predictiveSeverityColors[_severityIdx];
        $.publish( '/emr/severityLevel',[ _severityIdx, _severityColor  ] );

        // Create the Stage node, style the severity color for it, then append the Other actions <div>
        var _decision =
            '<div id="dxGuideStage-' + decision.nodeId + '" class="emrDiagStage' + ((!decision.current)?' emrDiagStageCompleted':'') + '">' +
                '<table class="tblClean emrDiagStageNode" style="border:2px solid ' + _severityColor + '">' +
                '<tr><td class="emrDiagStageHeader" style="background:' + _severityColor + '">Stage ' + decision.stage + '</td>' +
                    '<td style="vertical-align:middle">' + decision.response + '</td>';
        if (decision.current) _decision += '<td><div class="emrDiagOtherActions emrDiagActionContent emrDiagActionClickable' + '">Other Diagnostic Choices</div></td>';
        _decision +=
                '</tr></table>' +
                '<div class="emrDiagStageArrow" style="background-color:' + _severityColor + '"></div>' +
            '</div>';
        this.container.append(_decision);

        // Iterate through all the actions for this decision, looking for Low and Other actions, and setting decision level flags/variables
        var _lowActions=[], _otherActions=[], _keepActions=[];
        $.each(decision.actions, function() {
            if (this.status.toLowerCase() == 'not started') {
                if (!this.utilityLevel || !this.utility || parseFloat(this.utility)==0 ) _otherActions.push(this);
                else if (this.utilityLevel=='Low') {
                    var _lowCnt = _lowActions.push(this);
                    if (decision.current && _lowCnt == 1) _keepActions.unshift({lowActions:true});     // If there are any low utility actions, put an entry on the top
                } else _keepActions.push(this);
            } else {
                this.wasStarted = true;
                _keepActions.push(this);
            }
        });
        // Actions were processed above, remove from decision object to save memory
//        if (decision.current) { alert('emrutil: '+ concatObject(action.data));}
        delete decision.actions;

        // Now call the getActions to draw the remaining actions
        if (_keepActions.length > 0) {
            var _stageNode = $('#dxGuideStage-' + decision.nodeId );
            _stageNode.append(this.getActions( _keepActions, decision ));

            // Store the data for the current decision.  They will only be visible, and therefore found, on the current decision stage
            if (decision.current) {
                _stageNode.data(decision.actions);
                $('.emrDiagOtherActions').data(_otherActions);
                $('.emrDiagActionNodeLow', _stageNode).data(_lowActions);
            }

            // Draw the vertical lines below all the started actions and calculate starting and ending values for horizontal line
            var _arrowDrawn = false;
            $('.lightBG', _stageNode).each(function(idx, ele) {         // Iterate though all the actions drawn
                var _vertContainer = $(this).next();                    // Get the vertical line container (status text div)
                
                // Put an arrow on the bottom of the line if the action is in the middle  
                var _length = (_vertContainer.hasClass('dxLastRow'))?'Short':'Long', _arrow = '';
                var _atMiddle = $(this).closest('td').index()==((decision.lastRowCnt-1)/2);
                if (_atMiddle ) { _arrowDrawn = true; _arrow += 'Arrow' + _length }

                // Draw a vertical line under started actions
                // Append a div inside the next sibling (.dxDiagActionStatusText), which is styled in diagnosticGuide CSS.  
                _vertContainer.append(
                    '<div class="dxVertical dxVertical' + _arrow + '">' +               // Centers and draws a line,
                        '<div class="primaryBG dxVertical' + _length + '"></div>' +
                    '</div>');
            });

            // Draw the last horizontal row based on percentages calculated in getActions
//alert('dxguide: '+ decision.firstVert +'/'+ decision.lastVert);
            if (decision.firstVert != decision.lastVert) {
                var _horizLine = '<tr style="height:26px">' +
                    '<td style="width:' + (decision.firstVert * decision.actionWidth) + '%;min-width:' + (decisionTree.actionMinW * decision.firstVert) + 'px"></td>' +
                    '<td style="vertical-align:bottom;min-width:' + ((decision.lastVert - decision.firstVert) * decisionTree.actionMinW) + 'px"><div class="primaryBG dxHorizontal"></div></td>' +
                    '<td style="width:' + ((decision.lastRowCnt-decision.lastVert) * decision.actionWidth) + '%"></td></tr>';
                if (!_arrowDrawn) _horizLine += '<tr><td colspan="3"><div class="dxVertical dxVerticalArrowShortNotMid"></div></a></td></tr>';
                $('.dxHorizontalRow', _stageNode).append( _horizLine );
            }
        }
    },
    getActions: function(decisionActions, decisionData) {
        var _actionsPerRow = this.actionsPerRow, _totalActions = decisionActions.length;
        decisionData.twoRows = _totalActions > _actionsPerRow;
        decisionData.lastRowCnt = (decisionData.twoRows)?_actionsPerRow:_totalActions;
        var _actionRow = '<table class="tblClean emrDiagActionRow" style="width:100%"><tr>';
        var _actionWidth = parseInt(100 / decisionData.lastRowCnt);                                             // Percentage width of an action
        var _actionStyle = 'width:' + _actionWidth + '%;min-width:' + decisionTree.actionMinW + 'px';           // Normal action width styles
        var _spacerStyle = 'width:' + (_actionWidth/2) + '%;min-width:' + (decisionTree.actionMinW/2) + 'px';   // 1/2 width styles for spacing bottom row percentages
        var _actionNodes = _actionRow;
        decisionData.actionWidth = _actionWidth;
        decisionData.firstVert = decisionData.lastRowCnt/2; decisionData.lastVert = decisionData.lastRowCnt/2;  // Initialize to the middle
        decisionData.actions = {};

        // Loop through and display all actions for a decision
        $.each(decisionActions, function(idxAction, decisionAction) {
            if (idxAction > (decisionTree.actionsPerRow*2-1)) return false;  // Maximum displayable actions is based on the maximum actions per row

            // Style the colors for all the actions
            var _actionNodeHeadingClass = 'emrDiagActionNodeHeading primaryBG';             // Default node heading size and text color
            var _actionNodeClass = (decisionData.current)?'emrDiagActionClickable':'';      // Clickable only if the stage is the current on (passed in)

            if (this.lowActions) _actionNodeClass += ' emrDiagActionNodeLow primaryBorder'; // Low utility actions
            else if (this.utilityLevel == 'Suggested') {                                    // Suggested actions
                _actionNodeClass += ' emrDiagActionNodeSuggested';
                _actionNodeHeadingClass += ' emrDiagSuggestedBG';
            } else _actionNodeClass += ' emrDiagActionNodeNormal primaryBorder';            // Regular actions

            if (this.wasStarted) {
                // Draw index is the offset position of the started action.  The last row will have 1/2 action width offset
                var _drawIdx = ((idxAction >= _actionsPerRow)?idxAction - _actionsPerRow + .5:idxAction) + .5;  // Calculate drawing index
                _actionNodeClass += ' lightBG';     // Shade the background if action was started
                if (!decisionData.twoRows || idxAction >= _actionsPerRow) this.vertLineClass = 'dxLastRow';     // Add a class to started actions that are on the last row
                // Store the first and last drawing indexes for started actions into the decision object
                if (_drawIdx < decisionData.firstVert) decisionData.firstVert = _drawIdx;
                if (_drawIdx > decisionData.lastVert) decisionData.lastVert = _drawIdx;
            }

            // Create another row if maximum actions per row is reached, and set the short line style
            if (idxAction == _actionsPerRow) _actionNodes += '</tr></table>' + _actionRow + '<td style="' + _spacerStyle + '"></td>';

            var _cellContent = decisionTree.getNode(this, _actionNodeClass, _actionNodeHeadingClass);
            if (decisionData.current && !this.lowActions) decisionData.actions[this.actionId] = this;                           // Store the action data by id into the decision object

            _actionNodes += '<td style="' + _actionStyle + '">' + _cellContent + '</td>';
        });
        if (decisionData.twoRows) {  // Append blank action cells to fill rest of bottom row
            for (var i=_totalActions-_actionsPerRow; i<_actionsPerRow; i++)
                _actionNodes += '<td style="' + ((i<_actionsPerRow-1)?_actionStyle:_spacerStyle) + '"></td>';
        }
        // Create a row for the horizontal line if needed in drawLines
        return _actionNodes + '</tr></table><table class="tblClean dxHorizontalRow"></table>';
    },
    getNode: function(actionData, actionNodeClass, actionNodeHeadingClass) {
        // Create the visible Action node
        var _node = '<div style="position:relative"><div id="' + actionData.actionId + '" class="emrDiagActionNode ' + actionNodeClass + '">';
//        alert('emrutil: '+ concatObject(actionData));

        if (actionData.lowActions) _node += 'Low Utility Options';
        else _node += '<div class="' + actionNodeHeadingClass + '" >' + 'Diagnostic Utility = ' + (Math.round(parseFloat(actionData.utility) * 100)/100).toFixed(2) +
                '</div><div class="emrDiagActionContent">' + actionData.descr + '</div>';
        _node += '</div><div class="dxDiagActionStatusText ' + (actionData.vertLineClass || '') +'">';
        if (actionData.wasStarted) _node += actionData.status + ': ' + actionData.statusUpdated;
         return _node + '</div>';
    }
};
