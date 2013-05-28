
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
    <div id="simConfigHeading" class="simHeadings" style="text-align:center;color:#000">SAVED CONFIGURATION</div>
    <form id="simulatorConfigForm"><input type="hidden" id="configId" name="configId"/><input type="hidden" id="modelId" name="modelId"/>
    <div class="simSection" style="overflow-x:auto"><div class="simSubHeadings ">Name/Author/Configuration</div>
        <div style="float:left">
            <table class="tblClean simInputTable">
                <tr><td class="simFirstCol"><label for="name">Configuration Name</label></td><td><input type="text" id="name" name="name"/></td></tr>
                <tr><td>Author</td><td id="author"></td></tr>
            </table>
        </div>
        <div style="float:left">
            <table class="tblClean simInputTable" style="width:100%">
                <tr><td><label for="description">Description</label></td><td><textarea id="description" name="description" style="resize:none"></textarea></td></tr>
            </table>
        </div>
    </div>
    <div class="simSection" style="clear:both"><div class="simSubHeadings ">Scope</div>
        <table class="tblClean simInputTable">
            <tr>
                <td class="simFirstCol"><label for="startDate">Start date</label></td><td><label for="duration">Duration</label></td>
            </tr>
            <tr>
                <td><input id="startDate" name="startDate" type="text"/></td>
                <td><select id="duration" name="duration"></select></td>
            </tr>
        </table>
    </div>
    <div class="simSection"><div class="simSubHeadings">Agents</div>
        <table class="tblClean simInputTable">
            <tr class="agents_break" style="display:none"><td colspan="6" class="simSuberHeadings"><span>Resource </span><span id="agents_type"></span></td></tr>
            <tr class="agents_break" style="display:none"><td>Agent</td><td></td><td>Population</td><td>Filter</td><td>Subcategory Filter</td><td>Population Range</td></tr>
            <tr class="agents_outputrow" style="display:none"><!-- agents_output required to create new rows ! -->
                <td id="agents_name" class="simFirstCol suiteRegText"></td><td><input id="agents_agentId" name="agents[agentId]" type="hidden"/></td>
                <td><label for="agents_population"></label><input id="agents_population" name="agents[population]"/></td>
                <td><label for="agents_filtered"></label><input id="agents_filtered" name="agents[filtered]" type="checkbox"/></td>
                <td><label for="agents_subfilter"></label><select id="agents_subfilter" name="agents[subfilter]"></select></td>
                <td><label for="agents_populationRange"></label><input id="agents_populationRange" name="agents[populationRange]"/>%</td>
            </tr>
        </table>
    </div>
    <div class="simSection"><div class="simSubHeadings">Constraints</div>
        <table class="tblClean simInputTable">
            <tr class="constraints_break" style="display:none">
                <td class="simSuberHeadings"><span id="constraints_title"></span></td><td></td><td>Requirement</td><td>Importance</td>
            </tr>
            <!-- constraints_output required to create new rows ! -->
            <tr class="constraints_outputrow" style="display:none">
                <td id="constraints_name" class="simFirstCol suiteRegText"></td><td><input id="constraints_constraintId" type="hidden" name="constraints[constraintId]"/></td>
                <td><input type="checkbox" id="constraints_required" name="constraints[required]"/><label for="constraints_required">Required</label></td>
                <td><label for="constraints_importance"></label><select id="constraints_importance" name="constraints[importance]"></select></td>
            </tr>
        </table>
    </div>
    <div class="simSection"><div class="simSubHeadings">Optimization Stop</div>
        <table class="tblClean simInputTable">
            <tr>
                <td class="simFirstCol"><label for="stopTime">Maximum Time(s)</label></td><td><input id="stopTime" name="stopTime"/></td>
                <td><label for="stopScore">% Maximum Achievable Score</label></td><td><input id="stopScore" name="stopScore"/></td>
            </tr>
            <tr>
                <td><label for="stopIteration">Maximum Stops</label></td><td><input id="stopIteration" name="stopIteration"/></td>
                <td><label for="stopImprovement">Score Improvement</label></td><td><input id="stopImprovement" name="stopImprovement"/>%</td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>