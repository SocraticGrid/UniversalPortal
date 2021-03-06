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
    <div class="simSection" style="clear:both"><div class="simSubHeadings ">Scope</div>
        <table class="tblClean">
            <tr><td class="simFirstCol">Start date</td><td>Duration</td></tr>
            <tr class="suiteRegText"><td id="startDate"></td><td id="duration"></td></tr>
        </table>
    </div>
    <div class="simSection"><div class="simSubHeadings">Agents</div>
        <table class="tblClean simInputTable">
            <tr class="agents_break" style="display:none"><td colspan="6" class="simSuberHeadings"><span>Resource </span><span id="agents_type"></span></td></tr>
            <tr class="agents_break" style="display:none"><td>Agent</td><td>Datasource?</td><td>Population</td><td>Filter</td><td>Subcategory Filter</td><td>Population Range</td></tr>
            <tr class="agents_outputrow suiteRegText" style="display:none"><!-- agents_output required to create new rows ! -->
                <td id="agents_name" class="simFirstCol"></td><td></td>
                <td><span id="agents_population"></span></td>
                <td><label><input id="agents_filtered" name="agents[filtered]" type="checkbox" disabled/></label></td>
                <td><span id="agents_subfilter"></span></td>
                <td><span id="agents_populationRange"></span>%</td>
            </tr>
        </table>
    </div>
    <div class="simSection"><div class="simSubHeadings">Constraints</div>
        <table class="tblClean simInputTable">
            <tr class="constraints_break" style="display:none">
                <td class="simSuberHeadings"><span id="constraints_type"></span><span> Constraints Package </span></td><td></td><td>Requirement</td><td>Importance</td>
            </tr>
            <tr class="constraints_outputrow suiteRegText" style="display:none"><!-- constraints_output required to create new rows ! -->
                <td id="constraints_name" class="simFirstCol"></td><td></td>
                <td><label><input type="checkbox" id="constraints_required" name="constraints[required]" disabled/>Required</label></td>
                <td><span id="constraints_importance"></span></td>
            </tr>
        </table>
    </div>
    <div class="simSection"><div class="simSubHeadings">Optimization Stop</div>
        <table class="tblClean simInputTable">
            <tr>
                <td class="simFirstCol">Maximum Time(s)</td><td class="suiteRegText"><span id="stopTime"></span></td>
                <td class="simFirstCol">% Maximum Achievable Score</td><td class="suiteRegText"><span id="stopScore"></span></td>
            </tr>
            <tr>
                <td class="simFirstCol">Maximum Stops</td><td class="suiteRegText"><span id="stopIteration"></span></td>
                <td class="simFirstCol">Score Improvement</td><td class="suiteRegText"><span id="stopImprovement"></span>%</td>
            </tr>
        </table>
    </div>
</body>
</html>