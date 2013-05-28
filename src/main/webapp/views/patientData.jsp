
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
    <style>
        /* Word wrap the headings and the cells of the grids */
        .ui-jqgrid th.ui-th-column div { white-space:normal !important; height:auto; padding:2px } /*text-align: center */
        .ui-jqgrid tr.jqgrow td { white-space: normal !important; height:auto; vertical-align:text-top; padding-top:2px; }
    </style>
</head>
<body>
    <div id="suiteBodyHeader">
        <div class="suiteBodyHeaderTop">
            <div id="suiteBodyTitle"></div>
            <div class="suiteBodyHeaderButtonsR">
                <button onclick="$.publish('/suite/notImpl')">Print</button>
                <button onclick="sirona.requestPatientChange('')">Close Record</button>
            </div>
        </div>
    </div>

    <div id="suiteBody">
        <div id="suiteSplitTop">
            <div id="suiteSplitTopHeader">
                <div id="factListTabs" class="gridTabInactive"></div>
            </div>
            <div id="factListGridWrapper" style="position:relative">
                <table id="suiteTopGrid" class="suiteGrid"></table>
                <div id="suiteTopGridNavWrapper" class="suiteSplitTopFooter suiteGridNavWrapper">
                    <div class="suiteBorderLine"></div>
                    <div class="suiteGridSliderWrapper"><div id="suiteTopGridSlider"></div></div>
                    <div id="suiteTopGridSliderArrows" class="suiteGridSliderArrows">
                        <div id="suiteSplitTopSliderArrowL" class="suiteGridSliderArrow" style="background:url('images/sliderL.png') white no-repeat center"></div>
                        <div id="suiteSplitTopSliderArrowR" class="suiteGridSliderArrow" style="background:url('images/sliderR.png') white no-repeat center"></div>
                    </div>
                </div>
            </div>
        </div>

        <div id="suiteSplitBottom" style="position:relative">
            <div id="suiteBodyHeaderBottom">
                <div id="suiteSplitter"><div id="suiteSplitterHandle"></div></div>
                <div id="factDetailTabs" class="gridTabInactive"></div>
                <div id="suiteBottomGridSpacer" class="primaryBG"></div>
            </div>
            <div id="factDetail" class="primaryBorder" style="position:relative">
                <div id="suiteBottomGridWrapper">
                    <table id="suiteBottomGrid" class="suiteGrid"></table>
                    <div id="suiteBottomGridNavWrapper" class="suiteSplitBottomFooter suiteGridNavWrapper">
                        <div class="suiteBorderLine"></div>
                        <div class="suiteGridSliderWrapper"><div id="suiteBottomGridSlider"></div></div>
                        <div id="suiteBottomGridSliderArrows" class="suiteGridSliderArrows">
                            <div id="suiteSplitBottomSliderArrowL" class="suiteGridSliderArrow" style="background:url('images/sliderL.png') white no-repeat center"></div>
                            <div id="suiteSplitBottomSliderArrowR" class="suiteGridSliderArrow" style="background:url('images/sliderR.png') white no-repeat center"></div>
                        </div>
                    </div>
                </div>
                <div id="suiteFactDetailContent" class="contentPadding">
                    <div id="graphLegend" style="float:left"></div>
                    <div id="graphContent" style="float:right; clear:none; margin-right:50px;width:100px;height:100px"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="popupDetail" style="position:absolute;width:600px;height:400px;display:none;border:1px solid gray;background:#f5f5f5;overflow:auto;z-index:9999 !important;"></div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="js/excanvas.min.js"></script><![endif]-->
<script type="text/javascript" src="js/jquery.flot.js"></script>
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'patientData';
        var _suiteFactDetailContent = $('#suiteFactDetailContent');     // Lot of manipulation for this element, so find it only once for performance
        var _suiteSplitTopChildren = $('#suiteSplitTop').children();    // Find only once for resizing optimization
        var _graphChart = $('#graphContent');                           // For resizing the graph
        var _graphLegend = $('#graphLegend');                           // For resizing the graph legend
        var _graphData, _graphOptions;
        $('#suiteBodyTitle').html(sirona.viewData.patientData.label);


// LIST GRID
        function loadUpperGrid(refresh) {
            if (!_domain) return;
            _suiteFactDetailContent.hide();

            var _psAPI = 'getPatientData', _refactor = sirona.viewData.patientData.refactor, _root = (_refactor)?'':'patientDataFact';
            if (sirona.localAll) { _psAPI += '-' + sirona.viewData.patientData.label.toCamel() + ((_refactor)?'-Raw':'') }  // TODO take out
            sirona.reqPS(_psAPI, { view:_thisView, data: { patientId:sirona.patient.id, 'domain':_domain, 'responseType':'list' },
                success: function(data) {
                    data.trxnType='list';
                    gridFacts.resetDisplay('Top');
                    gridFacts.resetDisplay('Bottom');
                    if (sirona.viewData.patientData.refactor) data = gridFacts.tempRemap(data, _remapTmpl[_domain+'-'+'list']);             // TODO temporary data remapping function for raw fact data

                    if (!refresh) gridFacts.defineListTabs(data.listTabs);          // Keeps the currently loaded upper tabs if refreshing
                    gridFacts.defineDetailTabs(data.detailTabs);
                    gridFacts.drawGrid($('#suiteTopGrid'), 'upper', data);
                    resizeContent.updateGrids();
                }
            }, _root);
        }

// FACT DETAIL
        function loadDetail () {
            // Hide and display the appropriate elements based on the type of detail displayed
            gridFacts.resetDisplay('Bottom');
            var _detailType = gridFacts.gridData['lower'].type || '';
            if (_detailType == 'grid') {

            } else {
                $('#suiteBottomGridWrapper').hide();
                if (_detailType == 'graph') { drawGraph(); return }
                $('#suiteBottomGridSpacer').addClass('suiteGridSpacer');
            }
            _suiteFactDetailContent.hide(); // empty().

            // Create the parameters for the request
            var _detailParams = { patientId:sirona.patient.id, 'itemId':gridFacts.gridData['upper'].rowData.itemId, 'responseType':gridFacts.gridData['lower'].responseType };
            // .filters is an array of field names for the detail tabs that need to be sent with the request to "filter" the data result
            if (gridFacts.gridData['lower'].filters) $.each( gridFacts.gridData['lower'].filters, function() { _detailParams[this] = gridFacts.gridData['upper'].rowData[this] });
            if (gridFacts.gridData['lower'].responseType == 'ecs') _detailParams.sectionId = gridFacts.gridData['lower'].sectionId;
            else _detailParams.domain = _domain;      // Only send the domain if not and ECS call

            var _psAPI = 'getPatientData', _refactor = sirona.viewData.patientData.refactor, _root = (_refactor)?'':'patientDataFact';
            if (sirona.localAll) { _psAPI += '-' + (sirona.viewData.patientData.label + gridFacts.gridData['lower'].label).toCamel() + ((_refactor)?'-Raw':'') }  // TODO take out
            sirona.reqPS(_psAPI, { view:_thisView, data: _detailParams,
                success: function(data) {
                    if (gridFacts.gridData['lower'].type == 'grid') {
                        $('#suiteBottomGridWrapper').show();

                        if (sirona.viewData.patientData.refactor) data = gridFacts.tempRemap(data, _remapTmpl[_domain+'-'+'detail']);  // TODO temporary data remapping function for raw fact data
                        gridFacts.drawGrid($('#suiteBottomGrid'), 'lower', data);
                    } else {
                        $('#suiteBottomGridNavWrapper').hide();// .height(0);
                        // Data is in a field supplied in the "index" field
                        var _field = (gridFacts.gridData['lower'].responseType == 'ecs') ? 'report' : gridFacts.gridData['lower'].sectionId;

                        if (data.facts[0][_field]) _suiteFactDetailContent.html(data.facts[0][_field]);
                        else _suiteFactDetailContent.html(new Date() + '  Still need the ECS call or fact "sectionId" data for ' + gridFacts.gridData['lower'].label +
                                ', with and sectionId: ' + gridFacts.gridData['lower'].sectionId + '.....');
                        _suiteFactDetailContent.show();
                    }
                    resizeContent.updateGrids();
                }
            }, _root);
        }
        function drawGraph() {
            if (!$('#suiteTopGrid').getGridParam("colModel")) return;
            var _graphVals = [];
            // Push the visible column values into the graph values
            $.each($('#suiteTopGrid').getGridParam("colModel"), function(idx, val) {
                var _graphVal = gridFacts.gridData['upper'].rowData[this.name];
                if (!this.hidden && (idx >= (gridFacts.gridCache['upper'].fixedColumns+3))) // TODO calc fixed
                    _graphVals.push([_graphVals.length, (!_graphVal || _graphVal=='')?null:_graphVal]);
            });
            _graphData = { label:gridFacts.gridData['upper'].rowData.description, data:_graphVals };
            _graphOptions = {
                series: { lines: { show: true }, points: { show: true } },
                legend: { show: true, position:"sw", container:_graphLegend},
                xaxis: { show:false}
//                      yaxis: { labelWidth:200 }
            };
            $.plot(_graphChart, [_graphData], _graphOptions);

            _suiteFactDetailContent.show();
        }


// SUBSCRIBERS
        // LIST grid navigation
        $.subscribe('/suite/simpleTabNavigate', _thisView, function(objTabData) {
            loadUpperGrid(true);
        });

        $.subscribe('/suite/simpleTabBottomNavigate', _thisView, function(objTabData) {
            $.extend(gridFacts.gridData['lower'], objTabData);
            loadDetail();
        });

        $.subscribe('/patientData/pageIconHover',_thisView, function(sigContent,e) {
            showDialog('dialogFormatter', {data:{body:sigContent},  width:600, height:500 });
        });
        // Hide the hover div when the mouse leaves
        $('#popupDetail').mouseleave( function() { $(this).hide() });

        $.subscribe('/suite/gridRowChanged/upper',_thisView, loadDetail);         // Load the detail when the upper row changes

        $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
            _suiteFactDetailContent.outerHeight(resizeObj.suiteSplitBottomH - resizeObj.suiteBodyHeaderBottomH );
            _suiteSplitTopChildren.width(resizeObj.suiteSplitBottom.width());
//if (sirona.debugIt) $.publish( '/suite/debug', ['patientdata: '+ resizeObj.suiteSplitBottomH +'/'+ resizeObj.suiteBodyHeaderBottomH ] );

            // TODO - get fixedColumns value and calculate width of them from upper grid, instead of hardcoding
            if (gridFacts.gridData['lower'] && gridFacts.gridData['lower'].type=='graph') {
                _graphChart.width(_suiteFactDetailContent.width() - $('#suiteTopGrid_description').outerWidth() - 30)
                    .height( resizeObj.suiteSplitBottomH - resizeObj.suiteBodyHeaderBottomH - 15 );
                _graphLegend.width({maxWidth:_suiteFactDetailContent.width() - _graphChart.width()});

                if (_graphData) $.plot(_graphChart, [_graphData], _graphOptions);  // Redraw the graph with saved data when resizing
            }
        });

// INITIALIZATION
        var _remapTmpl, _domain = sirona.viewData.patientData.domain;
        if (sirona.viewData.patientData.refactor) {
            // If the getPatientData needs to be restructured before processing, get the template object, THEN load the upper grid
            sirona.localOnce = true;
            sirona.reqPS('getPatientData-tempMappings', {                               // Get the mapping data
                success: function(tmplData) { _remapTmpl=tmplData; loadUpperGrid() }
            });
        } else loadUpperGrid();
   });
</script>
</body>
</html>