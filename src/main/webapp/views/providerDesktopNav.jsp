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
    <div id="emrNavigation"></div>

<script type="text/javascript">
    $(document).ready ( function(){
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'providerDesktopNav';
        var _navContainer = $('#emrNavigation');

        $.subscribe('/suite/widgetLoaded', _thisView, function(dataObj) {
            if (dataObj.container.attr('id')!='suiteContent') return false;  // Return if not loading the main container

            // Remove the previous selected item, and select the new one.
            _navContainer.find('span').removeClass('navSelected primaryText');
            if (dataObj.label) _navContainer.find('li:contains("' + dataObj.label + '")').children().last().addClass('navSelected primaryText');
            else {
                // Find which view is being shown in the main container based on view name
                $.each($('li', _navContainer), function() {
                    if ($(this).text().toLowerCase() == dataObj.viewName) {
                        $(this).children().last().addClass('navSelected primaryText');
                        return false;
                    }
                });
            }
        });

// INITIALIZATION
        // Display the left menus from the config file
        $.each(sirona.providerTemplate.leftNav, function() {
            var _cssClass = this.cssClass || '';
            _navContainer.append('<div class="suiteLeftNavHeading ' + _cssClass + '">' + this.label +'</div><ul class="' + _cssClass + '"></ul>');
            var _navParent = _navContainer.children('ul').last();

            $.each(this.children, function() {
                var _navItem = '<li' + ((this.cssClass)?(' class="' + this.cssClass + '"'):'') + ' title=""><span>' + this.label
                if (this.domain=='allergies') _navItem += '<span class="allergyIcon"></span>';
                _navItem += '</span></li>';
                // Attach the data object from the config to the element, so it can be used later
                _navParent.append(_navItem).children('li').last().data(this);
            });
        });
        // After the elements are created, assign the click handler
        $('li', _navContainer).click(function() {
            // Pass the data from the element
            if ($('.navSelected', $(this)).length > 0) return;
            sirona.getView($(this).data('view'), $.extend($(this).data(),{split:true}) );
        });
    });
    </script>
</body>
</html>