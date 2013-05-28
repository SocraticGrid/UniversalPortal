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
    <title>Patient and Provider Portal</title>
    <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>

    <!--CSS-->
    <link type="text/css" href="css/suite.css" rel="stylesheet" />
    <link type="text/css" href="css/home.css" rel="stylesheet" />
    </head>
<body>
    <div id="suiteHeader" style="background:url('images/PatientBanner3.png')">
        <div id="homeHeader" class="homeContent">
            <div style="position:absolute;margin-left:-24px"><img src="images/Masthead-Logo.png"></div>
            <div id="homeHeaderTop">
            <!--     <span id="debug"></span>
                <span id="suiteVersion"></span><span>|</span>
            -->
                <span id="suiteDate"></span>
                <div id="homeSearch" class="lighterBG">
                    <label for="homeSearchVal"></label><input id="homeSearchVal" class="lighterBG" type="text" value="Search"/>
                    <img src="images/Magnifying-Glass.png" style="padding-right:5px"/>
                </div>
            </div>
            <div id="homeTopTabs"></div>

            <div id="suiteFonts">
                <span style="display:none">Full Screen<span></span></span><span>A</span><span style="padding-bottom:6px">|</span><span style="font-size:18px">A</span>
            </div>
        </div>
    </div>

    <div id="homeContent">
        <div class="ajaxWait"></div>
        <table class="tblClean tblCenter" style="width:100%">
            <tr>
                <td><div id="homeNav">&nbsp;</div></td>
                <td style="width:100%"><div id="homeBody">&nbsp;</div></td>
            </tr>
        </table>
    </div>

    <div id="homeFooter" style="background:#f6f6f2"></div>


<script type="text/javascript" src="servlet/config"></script>                   <!--Global config file -->
<script type="text/javascript" src="js/pubsub.js"></script>             <!--Publish/Subscribe JQuery Plugin-->
<script type="text/javascript" src="js/suiteUtility.js"></script>
<script type="text/javascript">
    $(document).ready (function($) {
        var _thisView = 'home';
        $('#suiteDate').html(new Date().toDateString().substr(4));
        $('#suiteVersion').html(sirona.version);

// Subscribers
        // Debugger
        $.subscribe('/suite/debug', _thisView, function(msg) { $('#debug').html(msg) });

        $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
//            if ( ($('#suiteHeader').height() + $('#homeContent').height() + $('#homeFooter').height()) < $(window).height() ) {
//                $('#homeFooter').css({ position:'absolute',bottom:'0',width:'100%' });
//            } else $('#homeFooter').css({ position:'relative'});
            if (sirona.debugIt) $.publish( '/suite/debug', ['index: '+  new Date() +': '+resizeObj.suiteHeaderH +'/'+ $('#homeContent').height()  +'/'+ $('#homeFooter').height() ] );
            $('#homeFooter').toggleClass('homeFooterBottom', ((resizeObj.suiteHeaderH + $('#homeContent').height() + $('#homeFooter').height()) < $(window).height()));
        });

        // Subscribe to the new views that are published
        $.subscribe('/suite/navigateView', _thisView, function(view, args) {
            sirona.getView(view, { container:$('#homeBody'),
                error:function() { sirona.getView( 'blank', { container:$('#homeBody') } )}
            });
        });
        $.subscribe('/suite/widgetLoaded',_thisView, function(dataObj) {
            if (dataObj && dataObj.container.attr('id') == 'homeBody') {
//                alert('index: '+ concatObject(dataObj));
                $('#homeContent').toggleClass('homeContent', dataObj.viewName != 'login');  // Add/remove the homeContent class if not on login screen
                $('#homeNav').toggle('login|newAccount'.indexOf(dataObj.viewName) < 0);
                resizeContent.updateAll();
            }
        });

        $.subscribe('/suite/topTabNavigate',_thisView, function(viewName) {
            $.publish('/suite/navigateView', [viewName])
        });
        $.subscribe('/suite/homeLeftNavigate',_thisView, function(viewName) {
            $.publish('/suite/navigateView', [viewName])
        });

// INITIALIZATION
        // Load the default views
        sirona.getView('navTabs', { container:$('#homeTopTabs'),
            success:function() {
                sirona.getView('homeFooter', { container:$('#homeFooter') });
                sirona.getView('homeLeftNav', { container:$('#homeNav') });
                sirona.getView('login', { container:$('#homeBody') });
            }
        });
    });

</script>
</body>
</html>

