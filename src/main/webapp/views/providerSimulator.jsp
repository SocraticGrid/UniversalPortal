
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
        #simulatorTopTabs { position:absolute; bottom:-1px }
        .simTabActive td { border-bottom:1px solid #fff;}
        #simulatorTopTabs span { padding:0 5px }
        .simTabM { background: white url("images/simTabMiddle.png");margin:0 5px; font-size:13px; line-height:22px; font-weight:bold; color:black; }
        .simTabMD { font-size:13px; line-height:22px; color:white; white-space:nowrap }
        .simTabL { background: url("images/simTabLeft.png") no-repeat; width:7px; height:22px; }
        .simTabR { background: url("images/simTabRight.png") no-repeat; width:12px; height:22px; }
        .simTabLD { background: url("images/simTabLeftD.png") no-repeat; width:7px; height:22px; }
        .simTabRD { background: url("images/simTabRightD.png") no-repeat; width:12px; height:22px; }

        .simInputTable td { border-right:10px solid #dcecf0; line-height:30px; white-space:nowrap }
        .simHeadings { font-size:18px; line-height:50px }
        .simSubHeadings { font-size:16px; font-weight:bold; line-height:40px }
        .simSuberHeadings { font-size:14px; font-weight:bold; line-height:30px }
        .simPadding { padding:0 15px } /* should match the contentPadding for the suite */
        .simSection { border-top:1px solid #FFF;margin-top:10px } /* should match the contentPadding for the suite */
        .simFirstCol { min-width:200px }
        button { padding: 0 10px }
        .simSearchResults { display:none }
    </style>
</head>
<body>
    <div id="suiteBodyHeader" style="min-height:75px">
        <div id="suiteBodyTitle" class="suiteBodyHeaderTop"></div>
        <div class="suiteBodyHeaderButtonsR"><button onclick="$.publish('/suite/notImpl')">Print</button></div>
        <div style="clear:both">
            <table class="tblClean">
                <tr id="simulatorTopTabs" style="cursor:pointer;">
                    <td class="simTabLD"></td><td class="simTabMD primaryBG"><span>1. Model Description</span></td><td class="simTabRD"></td>
                    <td class="simTabLD"></td><td class="simTabMD primaryBG"><span>2. Configuration</span></td><td class="simTabRD"></td>
                    <td class="simTabLD"></td><td class="simTabMD primaryBG"><span>3. Simulations in Progress</span></td><td class="simTabRD"></td>
                    <td class="simTabLD"></td><td class="simTabMD primaryBG"><span>4. New Results</span></td><td class="simTabRD"></td>
                    <td class="simTabLD"></td><td class="simTabMD primaryBG"><span>5. Saved Results</span></td><td class="simTabRD"></td>
                </tr>
            </table>
        </div>
    </div>
    <div id="suiteBody">
        <div id="simTabDetail" style="overflow-y:auto;overflow-x:hidden"></div>
    </div>

    <!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false;              // Cannot be loaded without the config
        var _thisView = 'providerSimulator';

// PUBLISHERS
        $('#simulatorTopTabs td').click(function() {
            var _tabIndex = parseInt(this.cellIndex/3)*3;                                                       // Get the starting index of the tab clicked
            if ($('#simulatorTopTabs').children(":eq(" + _tabIndex + ")").hasClass('simTabActive')) return;     // Return if the tab is already active
             $.publish( '/simulator/tabNavigate',[ _tabIndex/3 ] );
        });

// SUBSCRIPTIONS
        $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
            $('#simTabDetail').outerHeight(resizeObj.suiteBodyH - 15);
        });
        $.subscribe('/simulator/tabNavigate', _thisView, function(tabIndex, objData) {
            var _parent = $('#simulatorTopTabs');

             //  Change the styling for the active tab
             $('.simTabL').attr('class','simTabLD'); $('.simTabM').attr('class','simTabMD primaryBG'); $('.simTabR').attr('class','simTabRD');
             _parent.children(":eq(" + tabIndex*3 + ")").attr('class','simTabL simTabActive');
             _parent.children(":eq(" + (tabIndex*3+1) + ")").attr('class','simTabM simTabActive');
             _parent.children(":eq(" + (tabIndex*3+2) + ")").attr('class','simTabR simTabActive');

            // Load the appropriate view widget into the simulator detail container
            $('#simTabDetail').css({overflowY:(tabIndex > 2)?'hidden':'auto'});
            sirona.getView('providerSimulator' + 'Model|Config|InProgress|NewResults|SavedResults'.split('|')[tabIndex],
                { container:$('#simTabDetail'), split:true, data:(objData)?objData:{} });
        });
        $.subscribe('/simulator/config', _thisView, function(objData) {
            if (objData.action && objData.action == 'cancel') {
                // Navigate to the first tab if cancelling out of the configuration screen
                $.publish( '/simulator/tabNavigate',[ 1 ] );
            } else {
                // Store when configIds change so that they an be passed when navigating tabs above
                $.publish( '/simulator/tabNavigate',[ 2, objData ] );
            }
        });
        $.subscribe('/simulator/inProgress', _thisView, function(objData) {
            // A simulation in progress is not "Running" anymore, change tabs if not paused
            $.publish( '/simulator/tabNavigate',[ 3 ] );
        });
        $.subscribe('/simulator/modelSelected', _thisView, function(objData) {
            sirona.planningModel = objData;
            $('#suiteBodyTitle').text(objData.disease +' - '+ objData.shortDescr);
            $.publish( '/simulator/tabNavigate',[ 0 ] );
        });
// INITIALIZATION
    });
</script>
</body>
</html>