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
<form id="simulatorConfigForm"><input type="hidden" name="configId" value="000000000001"/><input type="hidden" name="modelId" value="modid1"/>
    <input type="text" name="name" value="Name of the configuration">
    <input name="startDate" type="text" value="2011-11-07 10:00"/>
    <select name="duration"><option selected>20</option></select>

    <input name="agents[0][id]" value="0001" type="hidden">
    <input name="agents[0][name]" value="0001" type="hidden">
    <input name="agents[0][filter]" type="checkbox" checked>
    <input name="agents[0][population]" value="5">
    <input name="agents[1][id]" value="0001" type="hidden">
    <input name="agents[1][name]" value="0002" type="hidden">
    <input name="agents[1][filter]" type="checkbox">
    <input name="agents[1][population]" value="50">
    <input name="agents[2][id]" value="0001" type="hidden">
    <input name="agents[2][name]" value="0003" type="hidden">
    <input name="agents[2][filter]" type="checkbox" checked>
    <input name="agents[2][population]" value="5000">

    <input name="constraints[0][id]" value="0001" type="hidden">
    <input name="constraints[0][required]" type="checkbox" checked>
    <input name="constraints[0][importance]" value="Low">
    <input name="constraints[1][id]" value="0002" type="hidden">
    <input name="constraints[1][required]" type="checkbox">
    <input name="constraints[1][importance]" value="Medium">
    <input name="constraints[2][id]" value="0003" type="hidden">
    <input name="constraints[2][required]" type="checkbox" checked>
    <input name="constraints[2][importance]" value="High">

<!--
    <input name="agentId" value="0001" type="hidden">
    <input name="population" value="5">
    <input name="filter" type="checkbox" checked>
    <input name="agentId" value="0002" type="hidden">
    <input name="population" value="1000">
    <input name="filter" type="checkbox">
    <input name="agentId" value="0003" type="hidden">
    <input name="population" value="50">
    <input name="filter" type="checkbox" checked>
-->

<!--
    <input name="agents[agentId]" value="0001" type="hidden">
    <input name="agents[population]" value="5">
    <input name="agents[filter]" type="checkbox" checked>
    <input name="agents[agentId]" value="0002" type="hidden">
    <input name="agents[population]" value="1000">
    <input name="agents[filter]" type="checkbox">
    <input name="agents[agentId]" value="0003" type="hidden">
    <input name="agents[population]" value="50">
    <input name="agents[filter]" type="checkbox" checked>
-->

<!--
    <input name="agents[agentId]" value="0001" type="hidden">
    <input name="agents[population]" value="5">
    <input name="agents[filter]" type="checkbox" checked>
    <input name="agents[agentId]" value="0002" type="hidden">
    <input name="agents[population]" value="1000">
    <input name="agents[filter]" type="checkbox">
    <input name="agents[agentId]" value="0003" type="hidden">
    <input name="agents[population]" value="50">
    <input name="agents[filter]" type="checkbox" checked>
-->
</form>
<!--
<form id="simAgentsForm">
    <input name="agentId[0]" value="0001" type="hidden">
    <input name="filter[0]" type="checkbox" checked>
    <input name="population[0]" value="5">
    <input name="agentId[1]" value="0002" type="hidden">
    <input name="population[1]" value="1000">
    <input name="filter[1]" type="checkbox">
    <input name="agentId[2]" value="0003" type="hidden">
    <input name="population[2]" value="50">
    <input name="filter[2]" type="checkbox" checked>
</form>
<form id="simConstraintsForm">
    <input name="constraintId[0]" value="0001" type="hidden">
    <input name="required[0]" type="checkbox" checked>
    <input name="importance[0]" value="5">
    <input name="constraintId[1]" value="0002" type="hidden">
    <input name="importance[1]" value="1000">
    <input name="required[1]" type="checkbox">
    <input name="constraintId[2]" value="0003" type="hidden">
    <input name="importance[2]" value="50">
    <input name="required[2]" type="checkbox" checked>
</form>
-->
<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'providerSimulatorConfig';

//        alert($('#simulatorConfigForm').serialize());
//        alert($('#simulatorConfigForm').serializeObject());
//        sirona.reqPS('saveConfiguration', { view:_thisView, data: { configuration: $('#simulatorConfigForm').serialize(),
//            agents: $('#simAgentsForm').serialize(),constraints: $('#simConstraintsForm').serialize() },

        sirona.localOnce=true;  // TODO testing
        sirona.reqPS('saveConfiguration', { view:_thisView, data: $('#simulatorConfigForm').serialize(),
            success: function(data) {
//                if (data.configId) renderConfig(data.configId);
            }
        }, 'simulationProcess', 'POST');
    });
</script>
</body>
</html>