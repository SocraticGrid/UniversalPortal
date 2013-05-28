
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

<div id="dialogBody" class="suiteGrayBG" style="padding:0 15px 15px">
    <div class="suiteCloseButtonHeader"><span class="suiteCloseButton" onclick="$.publish( '/suite/dialogClose',['dialogSelectRiskModels']);">X</span></div>
    <div id="dialogHeader">
        <span class="suiteDialogHeading">Model List</span>
        <!--<span style="float:right;line-height:40px"><label for="emrRiskModelSearch">Search: </label><input id="emrRiskModelSearch" type="text"/></span>-->
    </div>
    <div id="suiteDialogBody">
        <table id="dialogGrid" class="suiteGrid"></table>
    </div>
    <div style="padding-top:5px"><button>Select</button><button>Cancel</button></div>
</div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'dialogSelectRiskModels';

// SUBSCRIBERS
        $('#dialogBody :button').click(function() {
            if ($(this).text()=='Select') {
                // Executes when a Action button (Reply, Archive, Delete... is pressed
                var _iRowId = 0;
                var _modelIds = [], _thresholds =[];
                var _error = false;

                // Load the checked items first, otherwise the highlighted row
                if ($('#dialogGrid td input:checked').length>0) {
                    var _idCol = $('#dialogGrid').getCol('modelId'); // Array of modelIds
//alert($('#dialogGrid').getChangedCells().length);

                    var _thresholdCol = $('#dialogGrid').getCol('displayThreshold'); // Array of modelIds
                    $('#dialogGrid td input:checked').each( function() {
                        if (_thresholdCol[_iRowId].indexOf('<input')>=0) {
                            var _displayThreshold = $('#dialogGrid #'+_thresholdCol[_iRowId].match(/id\="(.+?)"/)[1]).val();
                            if (!isNumber(_displayThreshold)) { alert('Value is not a number'); _error=true; return false; }
                            _thresholds.push( _displayThreshold );
                        }
                        else _thresholds.push( parseInt(_thresholdCol[_iRowId]) );

                        _modelIds.push(_idCol[_iRowId]);  // If it passes the numeric test, then push the modelId
                        _iRowId++;
                    });
                }
                if (_error || _modelIds.length==0) return false;

                // Update the selected favorite models
                sirona.reqPS('setRiskModelFavorites', { view:_thisView, data: { 'patientId':sirona.patient.id, 'modelIds':_modelIds.join(','), 'displayThresholds':_thresholds.join(',') },
                    success: function(data){
                        $.publish( '/riskModels/selected',[_modelIds.join(',')]);
                        $.publish( '/suite/dialogClose',[_thisView]);
                    }
                }, 'riskModels', 'POST');
            } else
                $.publish( '/suite/dialogClose',[_thisView]);
        });

        $.subscribe('/suite/dialogResize', _thisView, function(ui) {
            $('#dialogGrid').jqGrid('setGridWidth', $('#suiteDialogBody').width() );
        });


// INITIALIZATION
        var _gridHeightOffset;  // Global height offset for this dialog
        var _favorites = [];

        // Request all of the grid data.  Populate the grid on success
        sirona.reqPS('getRiskModels', { view:_thisView, data:{ patientId:sirona.patient.id, type:"All" },
            success: function(data) {
                // Load and populate the Inbox grid
                $("#dialogGrid").jqGrid({
                    datastr:data,
                    jsonReader: {
                        root: "models",
                        repeatitems:false
                    },
                    colNames:[ '','', 'Disease', 'Threshold' ],
                    colModel:[
                        {name:'modelId', hidden:true },
                        {name:'tags',formatter:chkFormatter, width:5, align:'center', sortable:false  },
                        {name:'disease', width:30, sortable:false},
                        {name:'displayThreshold', width:20, align:'center', editable:true, edittype:'text',
                            editoptions:{size:3}, editrules:{number:true}, sortable:false }
                ],
                    cellEdit:true, cellsubmit:'clientArray',
                    afterInsertRow: function(rowid, rowdata) {
                        if (rowdata.tags && rowdata.tags.indexOf('E')>=0 ) {
                            $(this).jqGrid('setRowData', rowid, false, 'suiteGridBold');
                        }
                    },
                    loadComplete: function() {
                        $.publish( '/suite/dialogResize',[]);
                    },
                    onCellSelect: function(rowid, iCol, cellcontent, e) { },
                    onSelectRow: function(rowid, status) { return false }
                });
            }
        },'riskModels');
        function chkFormatter (cellvalue, options, rowObject) {
//            options = {disabled:true};
            var _input = '<input type="checkbox"';
            if (rowObject.tags && rowObject.tags.indexOf('E') >= 0) { _input += ' checked=checked disabled=disabled'; }
            else if (rowObject.favorite) _input += ' checked="checked"';
//         alert('dlgselectriskmodels'+ _input + "\n" + concatObject(rowObject));
            return (_input + '>');
        }
    });
</script>
</body>
</html>