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
    <title>Patient Portal</title>
    <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>

    <script type="text/javascript" src="js/grid.locale-en.js"></script>
    <script type="text/javascript" src="js/jqGrid-4.3.1.min.js"></script>
    <link type="text/css" href="css/pmrTheme/jquery-ui-1.8.18.custom.css" rel="stylesheet" />
    <link type="text/css" href="css/ui.jqgrid-4.3.1.css" rel="stylesheet" />
    <link type="text/css" href="css/suite.css" rel="stylesheet" />
    <link type="text/css" href="css/pmr.css" rel="stylesheet" />
</head>
<body>
    <div id="suiteHeader" style="background:url('images/PatientBanner3.png')">
        <div id="debug"></div>
        <div id="suiteHeaderWrapper"  style="height:90px; position:relative; background:url('images/Masthead-Logo.png') no-repeat">
            <div id="suiteHeaderTop">
                <div style="float:left">
                    <span id="suiteWelcome"></span><span class="vertLine">|</span>
                    <span id="suiteDate"></span><span class="vertLine">|</span>
                    <span><a id="logout" href="#">Log Out</a></span><span class="vertLine">|</span>
                    <span>Account</span>
                </div>
                <div class="fullScreen" style="float:left">
                    <span class="vertLine">|</span><span><img class="fullScreen changeScreen" src="images/downWhiteArrow.png"></span>
                </div>
            </div>
            <div id="patientTopTabs"></div>
        </div>

        <div id="suiteFonts" class="normalScreen">
            <span class="changeScreen">Full Screen</span><span></span><span>A</span><span style="padding-bottom:6px">|</span><span style="font-size:18px;padding-right:20px">A</span>
        </div>
    </div>

    <div id="pmrContent">
        <div class="ajaxWait"></div>
        <div id="pmrNav"></div>
        <div id="suiteContent"></div>
    </div>

    <div id="suiteFooter">Footer</div>

    <!-- Dialog overlay and input div -->
    <div id="suiteDialogOverlay" class="suiteDialog">&nbsp;</div>
    <div id="suiteDialogContent" class="suiteDialog"></div>

    <!-- Custom dropdown -->
    <div id="suiteDropdown" style="position:absolute;display:none"><ul id="suiteDropdownList"></ul></div>

    <script type="text/javascript" src="servlet/config"></script>                   <!--Global Sirona config file -->
    <script type="text/javascript" src="js/pubsub.js"></script>
    <script type="text/javascript" src="js/suiteUtility.js"></script>
    <script type="text/javascript">
        $(document).ready ( function(){
            var _thisView = 'patient';
            $('#suiteDate').html(new Date().toDateString().substr(4));
// Stop the main window from ever scrolling via keyboard or mouse.  Issue in Firefox
            $(window).scroll( function() { $(this).scrollLeft(0); $(this).scrollTop(0) });

// PUBLISHERS
            //  Publish when the user clicks buttons in the header
            $('#logout').click(function (e) { $.publish('/suite/logout',[],e); });
            $('.changeScreen').click( function() { $.publish('/suite/changeScreenSize',[ $(this) ]); });

// SUBSCRIBERS
            // Debugger
            $.subscribe('/suite/debug', _thisView, function(msg) { $('#debug').html(msg) });

    // HORIZONTAL SLIDER
            // Subscribe to when the content size changes and the containing controls need to be resized
            $.subscribe('/suite/topGridLoaded', _thisView, function() {
                resizeContent.updateGrids();
            });
            $.subscribe('/suite/bottomHalfLoaded', _thisView, function() {
                resizeContent.updateGrids();
            });

// NAVIGATION SUBSCRIPTIONS
            // The initialization of the top tabs will include a publish to this subscription to initialize calling the inbox view
            $.subscribe('/suite/topTabNavigate', _thisView, function(tabLabel) {
                // Handle when the upper navigation tabs are clicked
                sirona.getView('inbox', sirona.patientTemplate.inboxDefaultActions );
            });

// INITIALIZATION
            $("#suiteDialogOverlay").css( { opacity:.5 } );   // Use JQuery here to set opacity for browser compatibility
            sirona.securityData.userId = urlParams['userId'];
            sirona.securityData.token = urlParams['token'];
            sirona.securityData.providerId = urlParams['providerId'];
            sirona.patient = {}; sirona.portal="patient";

            // Override global grid defaults
            $.extend(jQuery.jgrid.defaults, { rowNum:1000, datatype: "jsonstring",loadonce: true, forceFit:true, hoverrows:false, scrollrows:true, autoencode:true } );


            // Load the configuration into a global namespace
            sirona.getView('pmrDesktopNav', { container:$('#pmrNav') });
            sirona.getView('suiteFooter', { container:$('#suiteFooter') });

            sirona.localOnce = true;
            sirona.reqPS('getHeaderDetail', { view:_thisView,
                success: function(headerData) {
                    sirona.patient.displayName = headerData.displayName;
                    $('#suiteWelcome').html('Welcome ' + headerData.displayName);

                    sirona.getView('navTabs', { container:$('#patientTopTabs'), data:headerData,
                        success:function() { $.publish( '/suite/topTabCreate',[ true ] )}           // Send true to create tabs from scratch
                    });
                 }
             }, 'headerDetailFact');
        });
    </script>
</body>
</html>

