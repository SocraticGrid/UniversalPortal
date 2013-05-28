
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
            <div id="suiteBodyTitle">Address Book</div>
        </div>
    </div>
    <div id="suiteBody">
        <div id="suiteSplitTop">
            <table id="suiteTopGrid" class="suiteGrid"></table>
        </div>
        <div id="suiteSplitBottom">
            <div id="suiteBodyHeaderBottom">
                <div id="suiteSplitter"><div id="suiteSplitterHandle"></div></div>
                <div id="factDetailTabs" class="primaryBG"></div>
            </div>
            <div id="factDetail">
                <div id="factDetailGridWrapper"></div>
                <div id="suiteFactDetailContent" class="contentPadding"></div>
            </div>
        </div>
    </div>

    <!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'addressBook';

        function populateGrid(data) {
            var _grid=$('#suiteTopGrid');
            // Load and populate the Inbox grid
            _grid.jqGrid({
                datatype: "jsonstring",
                datastr:data,
                loadonce: true,  // loads the data from the server only once.  Sets the datatype to local afterwards for sorting
                jsonReader: {
                    root: "contacts",   // facts
                    repeatitems:false
                },
                colNames:['Name','Address', 'City', 'State', 'Zip', 'Phone', 'Primary Email' ],
                colModel:[
                    {name:'name', index:'name', width:10 },
                    {name:'address1', index:'address1', width:10 },
                    {name:'city', index:'city', width:10 },
                    {name:'state', index:'state', width:10 },
                    {name:'zipCode', index:'zipCode', width:10 },
                    {name:'phones', index:'phones', width:10, formatter:phoneFormatter },
                    {name:'email', index:'email', width:20 }
                ],
                gridComplete: function() { $.publish( '/suite/topGridLoaded',[] ) },
                forceFit:true, hoverrows:false, scrollrows:true
            });
            function phoneFormatter (cellvalue, options, rowObject) {
                if (!cellvalue || cellvalue.length==0) return '';
                return cellvalue[0].number || '';
            }

            //            // Initialize the grid after it is loaded
            if (_grid.getGridParam("reccount") > 0 ) {
                _grid.jqGrid('setSelection',"1"); // Select the first row after the grid is loaded
            }
        }

// INITIALIZATION
//        sirona.localOnce = true;            // TODO take out
        sirona.reqPS('getAddressBook', { view:_thisView,
            success: populateGrid
        }, 'addressBookFact');


    });
</script>
</body>
</html>