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
<div id="suiteSimpleTopNav" style="display:none;overflow-x:hidden">
    <table class="tblClean">
        <tr style="white-space:nowrap"></tr>
    </table>
</div>
<!-- Script to load data should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config

        // Create the tabs from the labels passed in
        if (sirona.viewData.simpleTabs.data) {
            var _row = $('#suiteSimpleTopNav tr'), _tabFound=false;
            _row.empty();
            $.each(sirona.viewData.simpleTabs.data, function(idx, objTabData) {
                // Create the individual tabs which are cells of the table
                var _cell = '<td class="gridTabSeparator ';
                if (!_tabFound && objTabData.domain && objTabData.domain!='') {
                    _cell += 'gridTabActive';
                    _tabFound = true;
                } else _cell += 'gridTabInactive';
                _row.append(_cell + ((objTabData.disable)?' gridTabDisabled':'') + '">' + objTabData.label + '</td>')
                    .children(':last-child').data(this);
            });

            $('#suiteSimpleTopNav').undelegate().delegate('td.gridTabInactive', 'click', function(e) {
//                if (!$(this).data('domain') || $(this).data('domain')=='') return false;
                if ($(this).data('disable')) return false;

                // Toggle the display classes for both the old tab and new clicked tab
                $('#suiteSimpleTopNav .gridTabActive').toggleClass('gridTabActive gridTabInactive');
                $(this).toggleClass('gridTabActive gridTabInactive');
                $.publish( '/suite/simpleTabNavigate',[ $(this).data() ],e );
                return false;
            });

            // All done with setup, now show the tabs
            $('#suiteSimpleTopNav').show();
        }
    });
</script>
</body>
</html>