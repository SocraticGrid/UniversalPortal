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
<div id="suiteTopTabNav" style="display:none">
    <table class="tblClean">
        <tr id="suiteTopTabs" style="cursor:pointer;">
            <td class="suiteTabL"></td><td class="suiteTabActive" id="login"><span class="suiteTabText">Log In</span></td><td class="suiteTabR"></td>
            <td class="suiteTabLD"></td><td class="suiteTabInactive" id="about"><span class="suiteTabText">About</span></td><td class="suiteTabRD"></td>
            <td class="suiteTabLD"></td><td class="suiteTabInactive" id="medicalNews"><span class="suiteTabText">Medical News</span></td><td class="suiteTabRD"></td>
        </tr>
    </table>
</div>
<!-- Script to load data should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'navTabs';
        var _tabContain = $('#suiteTopTabs');
        function clearTabs() {
            $('.suiteTabL').attr('class','suiteTabLD');
            $('.suiteTabActive').attr('class','suiteTabInactive');
            $('.suiteTabR').attr('class','suiteTabRD');
        }

        $.subscribe('/suite/topTabCreate', _thisView, function(deleteFlag) {
            if (deleteFlag) _tabContain.empty();
            _tabContain.append('<td class="suiteTabL"></td><td class="suiteTabActive" id="' + sirona.viewData.navTabs.data.patientId + '"><span class="suiteTabText">' + sirona.patient.displayName + '</span></td><td class="suiteTabR"></td>');
            $.publish( '/suite/topTabNavigate',[ sirona.patient.displayName ] );
        });
        $.subscribe('/suite/navigateView', _thisView, function(view, args) {
            var _highlightTab = _tabContain.find('#' + view);
            if (_highlightTab.length == 0 && sirona.patient) _highlightTab = _tabContain.children('td:contains(' + sirona.patient.displayName + ')');
            if (_highlightTab.length > 0) {
                if (_highlightTab.hasClass('suiteTabInactive')) {
                    clearTabs();
                    _highlightTab.attr('class', 'suiteTabActive');
                    _highlightTab.prev().attr('class', 'suiteTabL');
                    _highlightTab.next().attr('class', 'suiteTabR');
                }
            } else clearTabs();  // View navigated to was not a tabbed one, so clear all tabs
        });

        // Assign a click event to all tabs now and in the future (delegate)
        _tabContain.undelegate().delegate('td','click', function() {
            var _tabClicked = parseInt(this.cellIndex/3)*3; // Get the starting index of the tab clicked
            var _view = _tabContain.children(":eq(" + (_tabClicked+1) + ")").attr('id');
            $.publish( '/suite/topTabNavigate',[ _view ]);
            return false;
        });

        // All done with setup, now show the tabs
        $('#suiteTopTabNav').css('display','inline');
    });
</script>
</body>
</html>