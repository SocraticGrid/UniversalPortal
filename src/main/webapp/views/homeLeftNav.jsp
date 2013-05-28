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
    <ul id="suiteLeftNav"></ul>
    <!--<div id="pmrNavigation"></div>-->

    <script type="text/javascript">
        $(document).ready ( function() {
            if (!sirona) return false; // Cannot be loaded without the config
            var _thisView = 'homeLeftNav';

            var _navContainer = $('#suiteLeftNav');

            // Delegate all click events now and in the future, and run this function
            _navContainer.undelegate().delegate('span','click', function(e) {
                if ($(this).hasClass('navSelected')) return;    // Return if already viewing

                // Remove the previous selected item, and select the new one.
                _navContainer.find('span').removeClass('navSelected primaryText');
                $(this).addClass('navSelected primaryText');

                var _label = $(this).html();
                // Look for the label in the configuration
                $.each(sirona.suiteFooterNav, function() {
                    $.each(this.secondary, function() {
                        if ( this.label==_label ) {
                            $.publish( '/suite/homeLeftNavigate',[ this.view ]);
                            return false;
                        }
                    });
                });
            });
            $.subscribe('/suite/navigateView', _thisView, function(view, args) {
               // Remove the previous selected item, and select the new one.
                $('#suiteLeftNav li').removeClass('navSelected primaryText');

                // Display the correct menu based on what was navigated to
                $.each(sirona.suiteFooterNav, function() {
                    var _secondary = '<li style="font-weight:bold">' + this.label + '</li>';  // Store the secondary menu
                    var _found=false;
                    $.each( this.secondary, function() {
                        _secondary += '<li><span';
                        if (this.view==view) {
                            _secondary += ' class="navSelected primaryText"';
                            _found = true;
                        }
                        _secondary += '>' + this.label + '</span></li>';
                    });
//                    alert('homeleftnav: '+ view + '/' + _found);
                    if  (_found || this.view == view) {
                        $('#suiteLeftNav').html(_secondary);
                        return false;
                    }
                });
            });
// INITIALIZATION
            // Default the initial menu to main navigation
            var _defaultMenu = '';
            $.each(sirona.suiteFooterNav, function() { _defaultMenu += '<li>' + this.label + '</li>' } );
         });
    </script>
</body>
</html>