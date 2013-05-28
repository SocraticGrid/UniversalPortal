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
<%@page import="nl.bitwalker.useragentutils.UserAgent, nl.bitwalker.useragentutils.OperatingSystem, org.socraticgrid.universalportal.config.Configuration" %>
<%
 UserAgent ua = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
 OperatingSystem os = ua.getOperatingSystem();
 
 String locateURL = "http://127.0.0.1:2116/";
 if (os.compareTo(OperatingSystem.WINDOWS_7) == 0 || os.compareTo(OperatingSystem.WINDOWS_VISTA) == 0){
     locateURL = "http://[::1]:2116/";
 } 
 
 locateURL = "http://127.0.0.1:2116/";
 
 Configuration cfg = Configuration.getInstance();
 
 boolean useServerSideNotifications = cfg.getPropertyAsBoolean(Configuration.PROPERTY_NAME.CCOW_SERVER_SIDE_NOTIFICATIONS);
 
 String webSocketParameter = "";
 if (useServerSideNotifications){
     webSocketParameter = "?websocket=true";
 }
 
%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Patient and Provider Portal</title>
    
    <style media="screen" type="text/css">
        html, body { height: 100%; margin: 0px; }
        iframe { border: none; overflow-y: hidden; }
        
        #app {height: 100%; width: 100%}
    </style>
    
    <script type="text/javascript" src="./js/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        function getCCOWFrame(){
            return document.getElementById('ccow');
        }
    
        function leaveCCOWContext(){
            $.ajax({
                url: "<%= response.encodeURL("http://"+request.getServerName()+":"+request.getServerPort()+"/UniversalPortal/servlet/ccow?action=leave") %>"
            });
        }
    
        <%
        if (useServerSideNotifications){
        %>  

        
        <% } %>
    
    </script>
</head>
<body onunload="leaveCCOWContext();">
    <div style="z-index: -10; position: absolute; right: 0; top: 0;">
        <iframe name="ccow" id="ccow" src="./ccow/common.jsp" height="0" width="0"></iframe>  
    </div>
    <iframe name="app" id="app" src="./main.jsp" scrolling="no"></iframe>  
</body>
</html>

