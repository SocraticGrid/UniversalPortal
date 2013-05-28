
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
<div id="suiteSplitTop" class="primaryText">
    <div id="suiteSplitTopHeader" class="primaryText">
        <div id="simulatorConfigInit" style="width:600px" class="contentPadding simSectionBegin">
            <div id="simModelTitle" class="simHeadings">Simulator Configuration</div>
            <div id="simModelDescr">Please select either load a Saved Configuration, or create a New Configuration</div>
            <div id="simMainAction" style="padding:20px 0"><button>Load Saved Configuration</button><span class="suiteButtonSpacing"></span><button>Create New Configuration</button></div>
        </div>
        <div id="simulatorConfigSearch" class="simSectionSearch simSectionResults" style="display:none">
            <div class="simHeadings simPadding">Search for a Saved Configuration</div>
            <div class="lightBG contentPadding">
                <table class="tblClean simInputTable">
                    <tr>
                        <td class="simFirstCol"><label for="searchNameContains">Name Contains</label></td><td colspan="4"><input id="searchNameContains" type="text" style="width:300px"></td>
                        <td>Last saved</td><td><label for="searchLastSavedAfter">after</label></td><td><input id="searchLastSavedAfter" type="text" style="width:100px"></td>
                        <td style="text-align:right"><label for="searchLastSavedBefore">before</label></td><td style="text-align:right"><input id="searchLastSavedBefore" type="text" style="width:100px"></td>
                    </tr>
                    <tr><td>Last run</td><td><label for="searchLastRunAfter">after</label></td><td><input id="searchLastRunAfter" type="text" style="width:100px"></td>
                        <td style="text-align:right"><label for="searchLastRunBefore">before</label></td><td style="text-align:right"><input id="searchLastRunBefore" type="text" style="width:100px"></td>
                        <td>Score</td><td><label for="searchScoreAtLeast">&gt;=</label></td><td><input id="searchScoreAtLeast" type="number" style="width:75px"></td>
                        <td><label for="searchScoreUpTo" style="padding:0 20px">&lt;=</label></td><td><input id="searchScoreUpTo" type="number" style="width:75px"></td>
                    </tr>
                </table>
            </div>
            <div class="simPadding simSectionSearch simSectionResults">
                <div id="simSearchAction" class="suiteBodyHeaderButtonsR"><button>Cancel</button><span class="suiteButtonSpacing"></span><button>Reset</button><span class="suiteButtonSpacing"></span><button>Search</button></div>
                <span class="simHeadings simPadding simSectionResults">Configurations Found</span>
            </div>
        </div>
    </div>
    <div class="simSectionResults">
        <table id="suiteTopGrid" class="suiteGrid"></table>
    </div>
</div>
<div id="suiteSplitBottom">
    <div id="suiteBodyHeaderBottom" class="simSectionResults">
        <div id="suiteSplitter"><div id="suiteSplitterHandle"></div></div>
    </div>
    <div id="simulatorBottomContent" class="primaryText" style="overflow-y:auto">
        <div id="simulatorConfig" class="lightBG contentPadding simSectionConfig" style="min-width:800px;margin-top:20px;display:none"></div>
        <div id="simulatorConfigActions" style="float:right;display:none" class="contentPadding simSectionConfig">
            <button>Cancel</button><span class="suiteButtonSpacing"></span><button>Save</button><span class="suiteButtonSpacing"></span><button class="configExists">Save New Version</button>
            <span class="suiteButtonSpacing"></span><span class="suiteButtonSpacing"></span><button style="background:#bdd851">Save and Run Configuration</button>
        </div>

        <div id="simulatorConfigDescr" class="contentPadding lightBG simSectionResults"></div>
        <div class="contentPadding simSectionResults">
            <button id="simulatorLoadConfig" style="float:right;margin-top:15px">Load Selected Configuration</button>
        </div>
    </div>
</div>

<!--<div id="simulatorConfigSections" class="primaryText">-->
<!--</div>-->

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'providerSimulatorConfig';
        sectionShow('Begin');

// FORM TEMPLATES
        var _selectedConfig={};
        var configTmpl = {
            containerId:"simulatorConfig",
            name:{type:"text", dataType:"text", width:275 },
            description:{type:"text", dataType:"text", width:400 },
            score:{type:"text", dataType:"integer", width:75 },
            startDate:{type:"text", dataType:"date", width:150 },
            stopTime:{dataType:"integer", width:40},
            stopScore:{dataType:"integer", width:40},
            stopIteration:{dataType:"integer", width:40},
            stopImprovement:{dataType:"integer", width:40},
            agents: {
                breakClass:{field:"type"},
                population:{type:"label", dataType:"integer", width:60},
                subfilter:{type:"label", width:150},
                filtered:{type:"checkbox"},
                populationRange:{type:"label",dataType:"integer", width:40}
            },
            constraints: {
                breakClass:{field:"title"},
                required:{type:"checkbox"}
            }
        };

// PUBLISHERS

// SUBSCRIPTIONS
        function sectionShow(cssClass) {
            // Hide and show the appropriate sections, controlled by the class name
            $(".simSectionBegin, .simSectionSearch, .simSectionResults, .simSectionConfig").hide();
            $(".simSection"+ cssClass).show();
        }
        $('#simMainAction :button').click(function() {
            // Populate the detail with the appropriate screen
            if ($(this).text().indexOf('Load') >=0 ) sectionShow('Search');
            else renderConfig('null');
        });
        $('#simSearchAction :button').click(function() {
            // Handle the search button options
            if ($(this).text() == 'Cancel') { sectionShow('Begin'); return }
            else if ($(this).text() == "Reset") { $('#simulatorConfigSearch :input').val(''); return }

            // Request the search
            sectionShow('Results');
            sirona.localOnce=true;  // TODO testing
            sirona.reqPS('searchConfigurations', { view:_thisView,
                success: function(data) {
                    var _grid=$('#suiteTopGrid');
                    // Load and populate the Inbox grid
                    _grid.jqGrid({
                        datastr:data, height:77,
                        jsonReader: { root: "configInfo", repeatitems:false },
                        colNames:['','', '', 'Name', 'Author', 'Last Saved Date', 'Last Run Date', 'Score' ],
                        colModel:[
                            {name:'configId', hidden:true}, {name:'description', hidden:true}, {width:10, fixed:true, resizable:false},
                            {name:'name'}, {name:'author'}, {name:'lastSavedDate'}, {name:'lastRunDate'}, {name:'score'}
                        ],
                        gridComplete: function() { resizeContent.updateGrids() },
                        onSelectRow:function(rowid) {
                            _selectedConfig = $(this).getRowData(rowid);
                            $('#simulatorConfigDescr').html(_selectedConfig.description) }
                    });
                    // Initialize the grid after it is loaded
                    if (_grid.getGridParam("reccount") > 0 ) {
                        _grid.jqGrid('setSelection',"1"); // Select the first row after the grid is loaded
                    }
                }
            }, 'simulationProcess');
        });
        $('#simulatorLoadConfig').click(function() {
//            $('#simulatorConfigSearch').hide();
            renderConfig(_selectedConfig.configId);
        });
        function renderConfig(configId) {
            sectionShow('Config');
            sirona.getView('providerSimulatorConfigInputTmpl', { container:$('#simulatorConfig'),
                success:function() {
                    // Request the search
                    var _api = 'getConfigurationDetail';
                    sirona.localOnce=true;  // TODO testing
                    if (sirona.debugIt && configId=='null') _api += 'Blank';  // TODO testing
                    sirona.reqPS(_api, { view:_thisView, data:{ modelId:sirona.planningModel.modelId, configId:configId },
                        success: function(data) {
                            // For now, create the needed structure for the form template generator.  In the future... convert to a new template scheme
                            var _packages = {}, _constraints = [];
                            $.each(data.configuration.constraintPackages, function() { _packages[this.packageId] = this });
                            $.each(data.configuration.constraints, function() {
                                if (_packages[this.packageId]) {        // Only use the constraints that have a package with the needed title
                                    _constraints.push($.extend({title:_packages[this.packageId].name}, this));
                                }
                            });
                            // Overwrite the constraints sent in the API, adding the title to display from the constraint packages
                            data.configuration.constraints = _constraints;
                            formTemplate.loadForm(data.configuration, configTmpl);
                            $('#modelId').val(sirona.planningModel.modelId);
                        }
                    }, 'simulationProcess');

                    $('.configExists').toggle(configId != 'null');  // Context for configuration that exists.  Toggles button display.
                    $('#simConfigHeading').text( ((configId=='null')?'NEW':'SAVED') + ' CONFIGURATION');
//alert('provsimconfig: '+ configId);
                }
            });
        }
        $('#simulatorConfigActions :button').click(function(e) {
            var _action =  $(e.target).text().toLowerCase();
            if (_action == "cancel") {
                $.publish( '/simulator/config',[ {action:_action} ] );    // Reload the initial config screen
            } else if (_action.indexOf('save') >= 0) {
                if (_action == 'save and run configuration') {
                    // Launching the simulation with the configuration will implicitly save the configuration
                    sirona.localOnce=true;  // TODO testing
                    sirona.reqPS('launchSimulation', { view:_thisView, data: $('#simulatorConfigForm').serialize(),
                        success: function(data) {
                            $.publish( '/simulator/config', [ data ] )
                        }
                    }, 'simulationProcess', 'POST');
                } else {
                    // One of the other "Save" options was clicked
                    var _configId = $('#simulatorConfigForm #configId');
                    if (_action == 'save new version') _configId.val('null');
                    // Save the config
                    sirona.localOnce=true;  // TODO testing
                    sirona.reqPS('saveConfiguration', { view:_thisView, data: $('#simulatorConfigForm').serialize(),
                        success: function(data) {
                            if (data.configId) renderConfig(data.configId);
                        }
                    }, 'simulationProcess', 'POST');
                }

            }
        });
        $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
//if (sirona.debugIt) $.publish( '/suite/debug', [ 'provsimconfig: ' +  new Date() + ': ' + resizeObj.suiteSplitTopH +'/' + resizeObj.suiteSplitBottomH ] );
//            $('#simulatorBottomContent').outerHeight(resizeObj.suiteSplitBottomH - resizeObj.suiteBodyHeaderBottomH - $('#simLoadResult').outerHeight() );
        });
    });
</script>
</body>
</html>