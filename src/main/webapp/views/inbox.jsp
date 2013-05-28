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
    <div id="suiteBodyHeader">
        <div class="suiteBodyHeaderTop">
            <div id="suiteBodyTitle">Inbox</div>
            <div class="suiteBodyHeaderButtonsL">
                <div class="suiteDropL"></div><div id="inboxLocation" class="suiteDropM"></div><div id="inboxLocationDrop" class="suiteDropR"></div>
                <div class="suiteDropL"></div><div id="inboxFilter" class="suiteDropM"></div><div id="inboxFilterDrop" class="suiteDropR"></div>
                <div><button onclick="$.publish('/suite/inboxCompose')" style="margin-left:20px">Compose</button></div>
                <div id="inboxAction"><div class="suiteDropL"></div><div id="inboxActionText" class="suiteDropM"></div><div id="inboxActionDrop" class="suiteDropR"></div></div>
                <div><button onclick="$.publish( '/suite/inboxGetMessages', [true])" style="margin-left:20px"><img src="images/refresh_black.png"></button></div>
            </div>
            <div class="suiteBodyHeaderButtonsR">
                <button id="documentsState">Request NwHIN Documents</button>
                <button onclick="$.publish('/suite/notImpl')">Print</button>
                <button id="closeRecord" onclick="sirona.requestPatientChange('')">Close Record</button>
            </div>
        </div>
    </div>
    <div id="suiteBody">
        <div id="suiteSplitTop">
            <table id="suiteTopGrid" class="suiteGrid"></table>
        </div>
        <div id="suiteSplitBottom">
            <div id="suiteBodyHeaderBottom">
                <div id="suiteSplitter"><div id="suiteSplitterHandle"></div></div>
                <div id="inboxDetailHeader" class="suiteSplitBottomDetail lightBG" style="display:none">
                    <table class="tblClean">
                        <tr><td class="rightLabel">From:</td><td id="inboxMessageFrom"></td></tr>
                        <tr style="display:none"><td class="rightLabel">To:</td><td id="inboxMessageTo"></td></tr>
                        <tr><td class="rightLabel">CC:</td><td id="inboxMessageCC"></td></tr>
                        <tr><td class="rightLabel">Subject:</td><td id="inboxMessageSubject"></td></tr>
                    </table>
                </div>
            </div>
            <div id="inboxDetail" class="contentPadding"></div>
        </div>
    </div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'inbox'; _nwhinRequestText = $('#documentsState').text();
        var _contextClass=(sirona.patient.id)?'emrContext':(sirona.portal=='patient')?'pmrContext':'';                  // Only certain controls can be visible depending on context
        if (sirona.portal=='patient')
        var _messagePatientId;
        var _grid=$('#suiteTopGrid'), _detail=$('#inboxDetail');


        function populateGrid(data) {
            // Load and populate the Inbox grid
            _grid.jqGrid({
                datatype: "jsonstring",
                datastr:data,
                jsonReader: {
                    root: "messageObjects",
                    repeatitems:false
                },
                colNames:['messageId','status','location','', '<img id="inboxSelections" src="images/checkboxDrop.png" style="padding-left:1px" onclick="$.publish(\'/suite/selectDropdown\',[{ container:\'inboxSelections\', items:sirona.inboxSelections }, $(event.target) ])">',
                    '<img src="images/starred4.png" style="padding-left:4px">', 'Date', 'Time', 'From', 'Message','Type','Priority','Task' ],
                colModel:[
                    {name:'messageId', index:'messageId', hidden:true },
                    {name:'status', index:'status', hidden:true },
                    {name:'location', index:'location', hidden:true },
                    {name:'spacer', fixed:true, sortable:false, width:3, resizable:false },
                    {name:'messageSelected', index:'messageSelected', editable:true, formatoptions:{disabled:false},
                        edittype:'checkbox', formatter:"checkbox", width:30, fixed:true, sortable:false },
                    {name:'labels', index:'labels', editable:true, formatter:folderFormatter, width:20, fixed:true, resizable:false, align:'center', firstsortorder:'desc'  },
                    {name:'messageDate',index:'messageDate', width:8 },  // formatter:'dateFmatter'
                    {name:'messageTime',index:'messageTime', width:5 },
                    {name:'from',index:'from', width:10 },
                    {name:'title',index:'title', width:35},
//                    {name:'description',index:'description', width:35 },
                    {name:'type',index:'type', width:5},
                    {name:'priority',index:'priority', width:5}, // align:"right"
                    {name:'tasksProgress',index:'tasksProgress', formatter:taskFormatter, width:10, firstsortorder:'desc' },
                ],
                loadComplete: function() {
                    if (sirona.patient.id) { $('td input', _grid).attr('disabled','disabled'); $('#inboxSelections').hide() }   // Disable checkboxes if in EMR
                    $.publish( '/suite/topGridLoaded',[] )
                }, afterInsertRow: function(rowid, rowdata) {
                    // Bold the row if it has not been read by adding the suiteGridBold CSS class
                    if ( rowdata.status =='Unread' ) _grid.jqGrid('setRowData', rowid, null, 'suiteGridBold');
//                    alert('inbox: insert '+ rowdata.messageId);
                }, onCellSelect: function(rowid, iCol, cellcontent, e) {
                    // Display appropriate action buttons depending on message type
                    var _gridRow = _grid.getRowData(rowid);
                    if (iCol==5 && !sirona.patient.id) {            // Only allow updating this column if not in EMR
                        // Toggle the starred column if clicked
                        var _labels = (cellcontent==' ')?['Starred']:[''];
                        // Call PS to update the flag, then update the grid display on response
                        sirona.reqPS('setMessages', { view:_thisView, data: { patientId:sirona.patient.id, 'messageIds':_gridRow.messageId, 'location':_currentLocation, 'types':_gridRow.type,
                            'action':'update', 'labels':_labels.join(',') },
                            success: function(data){
                                _grid.jqGrid('setCell', rowid, iCol, _labels, ' ' );
                            }
                        }, 'setMessagesFact', 'POST');
                        return false;
                    }
              }, onSelectRow: function(rowid, status) {
                    // Check current message Id and publish to get new message data if different
                    if (_grid.getRowData(rowid).messageId != _currentMessageId ) $.publish( '/suite/inboxMessage', [ rowid ] );
                }
            });
        }
        function folderFormatter (cellvalue, options, rowObject) {
            // Formatting function for the 'Starred' messages.  Inserts the proper image if 'Starred' is found in the labels array value
            if (!cellvalue) return ' ';
            return ($.inArray('Starred',cellvalue) < 0) ? ' ' : '<img src="images/starredGrid.png">';
        }
        function taskFormatter (cellvalue, options, rowObject) {
            // Formatting function for the Tasks progress column.
            if (!cellvalue || cellvalue==0) return ''; // Don't show the progress bar for messages with no tasks
            return "<div class='tasksProgress'><div class='taskProgress primaryBG' style='width:" + cellvalue.toString() + "%'></div></div>";
        }   // End of grid definition and formatters

// SUBSCRIBERS
        $('#inboxFilterDrop').click(function() {
            $.publish( '/suite/selectDropdown', [ { container:'inboxFilter', classRemove:_contextClass, items:sirona.inboxFilters}, $(this) ] )
        });
        $('#inboxLocationDrop').click(function() {
            $.publish( '/suite/selectDropdown', [ { container:'inboxLocation', classRemove:_contextClass, items:sirona.inboxLocations}, $(this) ] )
        });
        $('#inboxActionDrop').click(function() {
            $.publish( '/suite/selectDropdown', [ { container:'inboxActions', classRemove:_contextClass, items:sirona.viewData.inbox.currentActions}, $(this) ] )
        });
        $.subscribe('/suite/inboxCompose', _thisView, function(action) {
            // Call the Compose widget and send the current action and location to be used when returning to this widget
            // If the Compose button was pressed, then there will be no action, so dont send the message data
            sirona.getView('inboxCompose', $.extend((action)?sirona.viewData.inboxCompose:{}, {action:action, location:_currentLocation}));
        });
        $.subscribe('/suite/selectedDropdown', _thisView, function(objData) {
            // This subscription listens for any dropdowns that have been selected in this widget
            var _iRowId = 0, _rowStatus, _container = $('#'+objData.container);
            _container.removeData().data(objData);                                      // Replace any old data with the new selected data
            if (('inboxFilter|inboxLocation').indexOf(objData.container)>=0) {
                if (objData.container == "inboxLocation") _currentLocation = objData.data.location;
                _container.text(objData.label);
                $.publish( '/suite/inboxGetMessages', [true] );
            }
            else if (objData.container=='inboxSelections') {
                // Select the messages that match the type selected
                _iRowId = 0, _rowStatus = _grid.getCol('status');
                $('td input', _grid).each( function() {
                    // Check off the selected message type that was selected
                    $(this).attr('checked',false);
                    if (objData.label=='All' ||
                        (objData.label=='Read' && _rowStatus[_iRowId]!='Unread') ||
                        (objData.label=='Unread' && _rowStatus[_iRowId]=='Unread')) $(this).attr('checked',true);
                    _iRowId++;
                });
                checkActions();
            } else if (objData.container=='inboxActions') {
                // Each object contains an array of labels to use for the dropdown.
                // The "label" value is what is displayed and used in the logic conditions UNLESS an "action" value is provided
                var _action = objData.action || objData.label;
                if ('edit|reply|forward|reply all'.indexOf(_action.toLowerCase()) >= 0) {
                    $.publish('/suite/inboxCompose', [_action]);
                } else {
                    // Delete, Archive, Undelete, etc....
                    _iRowId = 0;
                    var _messageIds = [], _types=[];
                    // Load the checked items first, otherwise the highlighted row
                    if ($('td input:checked', _grid).length>0) {
                        var _idCol = _grid.getCol('messageId');        // Array of messageIds
                        var _locationCol = _grid.getCol('location');   // Array of locations
                        var _typeCol = _grid.getCol('type');           // Array of message types
                        $('td input', _grid).each( function() {
                            if ($(this).attr('checked')) {
                                _messageIds.push(_idCol[_iRowId]);
                                _types.push(_typeCol[_iRowId]);
                            }
                            _iRowId++;
                        });
                    } else {
                        _iRowId = _grid.jqGrid('getGridParam','selrow');
                        _messageIds.push(_grid.getCell(_iRowId, 'messageId'));
                        _types.push(_grid.getCell(_iRowId, 'type'));
                    }
                    if (_messageIds.length==0) return false;   // Nothing to update
                    if (objData.label.toLocaleLowerCase()=='delete forever' && !confirm(sirona.confirmPermDelete)) return false;

                    sirona.reqPS('setMessages', { view:_thisView, data: { patientId:sirona.patient.id, 'action':_action, 'messageIds':_messageIds.join(','), 'location':_currentLocation, 'types':_types.join(',') },
                        success: function(data) {
                            // Re-read the current location and type
                            $.publish( '/suite/inboxGetMessages', [true] );
                        }
                    }, 'setMessagesFact', 'POST');
                }
            }
        });
        $('#documentsState').click(function() {
            $(this).attr('disabled','disabled').text('Processing Request');
            // User clicked the Request NHIN Document button, so request to start
            sirona.reqPS('getDocuments', { view:_thisView, data:{ patientId:sirona.patient.id, action:"Start"},
                 success: function(data) { if (data.processState=='Available') $('#documentsState').removeAttr('disabled').text(_nwhinRequestText) }
            }, 'documentsFact');
        });


        function checkActions() {
            // Count the messages that are checked, and disable the Email action if there is more than one
            var _checkCnt = $('td input:checked', _grid).length;
            var _type = '';
            if (_checkCnt <= 1) {
                var _rowId = _grid.jqGrid('getGridParam', 'selrow');
                _type = _grid.getRowData(_rowId).type;
            }
            sirona.viewData.inbox.currentActions = ((_checkCnt <= 1 && _type == 'Email' && _currentLocation != 'Draft')?
                sirona.inboxEmailActions:[]).concat($('#inboxLocation').data('actions'));
            if (_currentLocation == 'Draft' && _checkCnt > 1) sirona.viewData.inbox.currentActions.shift();  // Remove the "Edit" from the choices if multiple messages are selected

            $('#inboxActionText').text(sirona.viewData.inbox.currentActions[0].label).data(sirona.viewData.inbox.currentActions[0]);
        }
        _grid.undelegate().delegate('td input', 'click', checkActions);

        $.subscribe('/suite/inboxGetMessages', _thisView, function(refresh) {
            // Initialize context display.  When in EMR context, provider has read-only permissions, so disable certain dropdowns
            var _docButton = $('#documentsState');
            var _closeRecordButton = $('#closeRecord');
            _detail.empty(); 
            $('#inboxDetailHeader').hide(); 
            _docButton.hide();
            _grid.jqGrid("clearGridData", true);
            
            if (!sirona.patient.id){
                _closeRecordButton.hide();
            }

            // Main subscriber to load or refresh the grid data.  Optional category can be supplied
            $('#inboxAction').hide();
            sirona.reqPS('getMessages', { view:_thisView, data:{ patientId:sirona.patient.id, location:_currentLocation, type:$('#inboxFilter').data('type')},
                success: function(data) {
                    if (refresh) _grid.jqGrid('setGridParam', { datatype:'jsonstring', datastr:data } ).trigger("reloadGrid"); // Make sure the datatype is reset, because after the initial load, it get set to "local"
                    else populateGrid(data);

                    if (_grid.getGridParam("reccount") > 0 ) {
                        _grid.jqGrid('setSelection',"1"); // Select the first row after the grid is loaded
                    }
                }
            },'messagesFact');

            if (sirona.patient.id || sirona.portal=='patient') {
                // Also get the state of any NHIN document requests and remove the disabled attribute from the button if available again
                sirona.reqPS('getDocuments', { view:_thisView, data:{ patientId:sirona.patient.id },
                     success: function(data) { if (data.processState=='Available') _docButton.removeAttr('disabled').text(_nwhinRequestText) }
                }, 'documentsFact');
                _docButton.show();
            }
        });

        $.subscribe('/suite/inboxMessage', _thisView, function(rowId) {
            _detail.empty(); $('#inboxDetailHeader').hide();
            var _rowData = _grid.getRowData(rowId);
            sirona.viewData.inboxCompose =  { 'from':_rowData.from, 'messageId':_rowData.messageId, 'type':_rowData.type, 'title':_rowData.title };
            _currentMessageId = _rowData.messageId;  // Update the selected messageId

            // Show or hide the appropriate controls for this message
            $('#inboxMessageFrom').closest('tr').toggle(('Sent|Draft'.indexOf(_currentLocation)<0));
            $('#inboxMessageTo').closest('tr').toggle(_currentLocation.toLowerCase()!='inbox');
            sirona.reqPS('getMessageDetail', { view:_thisView, data: { 'patientId':sirona.patient.id, 'messageId':_rowData.messageId, 'type':_rowData.type, 'location':_rowData.location },
                success: function(data){
                    _messagePatientId = data.patientId;                     // Reset the message patientId
                    checkActions();
                    if (!sirona.patient.id) $('#inboxAction').show();       // Only show the actions drowdown when not in EMR

                    $.extend(sirona.viewData.inboxCompose, data);           // Merge the new fields into the existing object

                    // TODO figure out which type of detail to display
                    if (_rowData.type=='Alert') { // TODO - parse the body field for surveyIds
                        _detail.html(data.body);
                        $('[type=survey]', _detail).each(function() {
                            // Look inside the body for <p type="survey"> tags.  If found, call getSurvey
                            var _surveyId = $(this).attr('id');
                            sirona.reqPS('getSurvey', { view:_thisView, data: { 'patientId':_messagePatientId, 'surveyId':_surveyId },
                                success: function(data2) {
                                    renderSurvey($.extend(data2,{'cssClass':'suiteSurveyInbox'}), $('#'+_surveyId) );
                                }
                            }, 'surveyFact');
                        });
                    } else {
                        if (_rowData.type=='Email') {
                            $('#inboxMessageFrom').text(_rowData.from || '');
                            if (data.sentTo) $('#inboxMessageTo').text(data.sentTo.join(', '));
                            if (data.CCTo) $('#inboxMessageCC').text(data.CCTo.join(', '));
                            $('#inboxMessageSubject').text(_rowData.title);
                            $('#inboxDetailHeader').show();
                        }
                        _detail.html(data.body || '');
                    }
                    resizeContent.init(); // Needs to recalc heading heights

                    // On successful display of the detail, mark the message read
                    if (_rowData.status.toLowerCase()=='unread' && !sirona.patient.id) {    // Only allow updates if not in EMR
                        sirona.reqPS('setMessages', { view:_thisView, data: { 'patientId':_messagePatientId, 'action':'Read', 'location':_currentLocation, 'messageIds':_rowData.messageId, 'types':_rowData.type },
                            success: function(data){
                                $(_grid[0].rows.namedItem(rowId)).removeClass('suiteGridBold');
                                _grid.jqGrid('setCell', rowId, "status", "Read" );
                            }
                        }, 'setMessagesFact', 'POST');
                    }
                }
            }, 'messageDetailFact');
        });

        $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
            _detail.outerHeight(resizeObj.suiteSplitBottomH - resizeObj.suiteBodyHeaderBottomH );
        });

// INITIALIZATION
        var _currentMessageId ='';
        var _currentLocation = sirona.viewData.inbox.data.location;
        $.each(sirona.inboxLocations, function() {
            if (this.data.location==_currentLocation){ $('#inboxLocation').text(this.label).data(this); return false }
        });
        $('#inboxFilter').text(sirona.inboxFilters[0].label).data(sirona.inboxFilters.data);
        $('#suiteBodyTitle').text(sirona.viewData.inbox.label);
        $.publish( '/suite/inboxGetMessages', [false]);
    });
</script>
</body>
</html>