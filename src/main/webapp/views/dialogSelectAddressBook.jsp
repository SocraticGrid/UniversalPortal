
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

<!-- <table> isnt working because height/width of grid is off from it's container -->
<div id="dialogBody" class="suiteGrayBG" style="padding:0 15px 15px">
    <div class="suiteCloseButtonHeader"><span class="suiteCloseButton" onclick="$.publish( '/suite/dialogClose',['dialogSelectAddressBook']);">X</span></div>
    <div id="dialogHeader">
        <span class="suiteDialogHeading">Address Book</span>
        <!--<span style="float:right;line-height:40px"><label for="suiteAddressBookSearch">Search: </label><input id="suiteAddressBookSearch" type="text"/></span>-->
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
        var _thisView = 'dialogSelectAddressBook';

        $('#dialogBody :button').click(function() {
            var _button = $(this).text();
            if (_button=='Select') {
                var _grid = $('#dialogGrid');
                var _contactIds = [];
                var _selectedRows = _grid.jqGrid('getGridParam','selarrrow');
                if (_selectedRows.length > 0) {
                    $.each(_selectedRows, function(idx, rowId) {
                         _contactIds.push(_grid.getRowData(rowId).contactId);
                    });
                }
                $.publish( '/addressBook/selected',[_contactIds.join(',')]);
            }
            $.publish( '/suite/dialogClose',[_thisView]);
        });

// SUBSCRIBERS
        $.subscribe('/suite/dialogResize', _thisView, function(ui) {
            $('#dialogGrid').jqGrid('setGridWidth', $('#suiteDialogBody').width() );
        });

// / INITIALIZATION
        var _gridHeightOffset;  // Global height offset for this dialog

        // Request all of the grid data.  Populate the grid on success
        sirona.reqPS('getAddressBook', { view:_thisView,
            success: function(data) {
                // Load and populate the AddressBook grid
                $("#dialogGrid").jqGrid({
                    datatype: "jsonstring",
                    datastr:data,
                    loadonce: true,  // loads the data from the server only once.  Sets the datatype to local afterwards for sorting
                    jsonReader: {
                        root: "contacts",
                        repeatitems:false
                    },
                    colNames:[ '',"Contact", 'Email'  ],
                    colModel:[
                        {name:'contactId', index:'contactId', hidden:true },
                        {name:'name',index:'name', width:40},
                        {name:'email',index:'email', width:60}
                    ],
                    forceFit:true, hoverrows:false, multiselect:true,
                    loadComplete: function() {
                        $.publish( '/suite/dialogResize',[]);
                    },
                    onCellSelect: function(rowid, iCol, cellcontent, e) { },
                    onSelectRow: function(rowid, status) { }
                });
            }
        },'addressBookFact');

    });
</script>
</body>
</html>