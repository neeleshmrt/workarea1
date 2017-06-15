<?xml version="1.0" encoding="UTF-8" standalone="yes"?>

<!DOCTYPE tvdxtat [
	<!ENTITY ff "'###,###,###,###,##0.000'">           <!-- float format -->
	<!ENTITY if "'###,###,###,###,###,##0'">           <!-- integer format -->
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8"/>

<!--  M A I N  -->

<xsl:template match="/tvdxtat">
	<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">]]></xsl:text>
	<html lang="en">
		<head>
			<title>TVD$XTAT Output</title>
			<style type="text/css">
				body { background-color: rgb(244,244,244); }
				h1 { color: rgb(55,55,55); font-family: helvetica; font-size: 15pt; font-weight: bold; }
				h2 { color: rgb(55,55,55); font-family: helvetica; font-size: 13pt; font-weight: bold; }
				h3 { color: rgb(55,55,55); font-family: helvetica; font-size: 11pt; font-weight: bold; }
				p { color: rgb(55,55,55); font-family: helvetica; font-size: 10pt; font-weight: normal; }
				a { color: rgb(55,55,55); font-family: helvetica; font-size: 10pt; font-weight: normal; }
				a.th { color: rgb(244,244,244); background-color: rgb(55,55,55); font-family: helvetica; font-size: 10pt; font-weight: normal; }
				p.error { color: rgb(255,0,0); font-family: helvetica; font-size: 10pt; font-weight: normal; }
				th.color { color: rgb(244,244,244); background-color: rgb(55,55,55); font-family: helvetica; font-size: 10pt; font-weight: normal; vertical-align: top; }
				th.no_color { color: rgb(55,55,55); font-family: helvetica; font-size: 10pt; font-weight: normal; vertical-align: top; }
				td.color { color: rgb(55,55,55); background-color: rgb(220,208,192); font-family: helvetica; font-size: 10pt; font-weight: normal;  vertical-align: top; }
				td.color_pre { color: rgb(55,55,55); background-color: rgb(220,208,192); font-family: helvetica; font-size: 10pt; font-weight: normal; white-space: pre; vertical-align: top; }
				td.no_color { color: rgb(55,55,55); font-family: helvetica; font-size: 10pt; font-weight: normal; vertical-align: top; }
				td.no_color_pre { color: rgb(55,55,55); font-family: helvetica; font-size: 10pt; font-weight: normal; white-space: pre; vertical-align: top; }
		        table { border: 0px solid rgb(55,55,55); border-collapse: separate; border-spacing: 2px 2px; }
			</style>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
			<script type="text/javascript">
				$(document).ready(function() {
					$(".toggle").click(function() {
						var text = $(this).text();
						if (text.indexOf("hide") != -1) {
							$(this).text(text.replace("hide", "show"));
						}
						else {
							$(this).text(text.replace("show", "hide"));
						}
						$(this).parent().next().toggle("slow");
						return false;
					});
					// make sure that the target element is displayed
					$("a").click(function() {
						var href = $(this).attr("href");
						if (href.length > 1) { // do nothing when href is "#"
							var element = $($(this).attr("href"));
							var parent = element.parent();
							// handle the element itself
							var text = element.children(".toggle").text();
							if (text == "show") {
								text = text.replace("show", "hide");
								element.children(".toggle").text(text);
								element.next().show();
							}
							// handle its parent
							var text = parent.prev().children(".toggle").text();
							if (text == "show") {
								text = text.replace("show", "hide");
								parent.prev().children(".toggle").text(text);
								parent.show();
							}
						}
					});
				});
			</script>
		</head>
		<body>
			<table>
				<tr>
					<td class="title" colspan="2">
						<h1><xsl:value-of select="header/version"/></h1>
					</td>
				</tr>
				<tr>
					<td class="no_color">
						<xsl:variable name="email" select="header/author/email"/>
						<a href='mailto:{$email}'><xsl:value-of select="header/copyright"/></a>
					</td>
					<td class="no_color">
						<a href='http://www.trivadis.com'>Trivadis AG</a>
						<br/>Sägereistrasse 29
						<br/>CH-8152 Glattbrugg / Zürich
					</td>
				</tr>
			</table>
			<h1>Overall Information</h1>
			<xsl:apply-templates select="database"/>
			<xsl:apply-templates select="tracefiles"/>
			<xsl:apply-templates select="period"/>
			<xsl:apply-templates select="transactions"/>
			<xsl:call-template name="cursors0"/>
			<xsl:apply-templates select="profile"/>
			<xsl:for-each select="cursors/cursor">
				<p><br/></p>
				<hr/>
				<xsl:variable name="id" select="@id"/>
				<h1 id="stm{$id}">
					Statement <xsl:value-of select="$id"/>
					&#160;<a href="#stm">overall</a>&#160;<a class="toggle" href="#">hide</a>
				</h1>
				<div>
					<xsl:call-template name="cursor_detail"/>
				</div>
			</xsl:for-each>
			<p><br/></p>
			<hr/>
			<h1><a name="units"></a>Units of Measure&#160;<a href="#top">overall</a></h1>
			<p>
				[s] = seconds
				<br/>[&#956;s] = microseconds
				<br/>[b] = database blocks
			</p>
		</body>
	</html>
</xsl:template>

<xsl:template match="database">
	<xsl:if test="line">
		<h2>Database Version</h2>
		<table>
			<xsl:for-each select="line">
				<tr>
					<td class="no_color" align="left"><xsl:value-of select="text()"/></td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:if>
</xsl:template>
  
<xsl:template match="tracefiles">
	<xsl:if test="tracefile">
		<xsl:choose>
			<xsl:when test="count(tracefile)=1">
				<h2>Analyzed Trace File</h2>
			</xsl:when>
			<xsl:otherwise>
				<h2>Analyzed Trace Files</h2>
			</xsl:otherwise>
		</xsl:choose>
		<p>
			<xsl:for-each select="tracefile">
				<xsl:value-of select="text()"/><br/>
			</xsl:for-each>
		</p>
	</xsl:if>
</xsl:template>

<xsl:template match="period">
	<h2>Interval</h2>
	<table>
		<xsl:if test="begin">
			<tr>
				<td class="no_color" align="left">Beginning</td>
				<td class="no_color" align="left"><xsl:value-of select="begin"/></td>
			</tr>
			<tr>
				<td class="no_color" align="left">End</td>
				<td class="no_color" align="left"><xsl:value-of select="end"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="duration">
			<tr>
				<td class="no_color" align="left">Duration</td>
				<td class="no_color" align="left"><xsl:value-of select="format-number(duration div 1000000,&ff;)"/>&#160;<a href="#units">[s]</a></td>
			</tr>
		</xsl:if>
	</table>
	<xsl:for-each select="warning">
		<p class="error">WARNING: <xsl:value-of select="text()"/></p>
	</xsl:for-each>
</xsl:template>
  
<xsl:template match="transactions">
	<h2>Transactions</h2>
	<table>
		<tr>
			<td class="no_color" align="left">Commit</td>
			<td class="no_color" align="left"><xsl:value-of select="format-number(commit,&if;)"/></td>
		</tr>
		<tr>
			<td class="no_color" align="left">Rollback</td>
			<td class="no_color" align="left"><xsl:value-of select="format-number(rollback,&if;)"/></td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="profile">
	<xsl:variable name="id" select="../@id"/>
	<xsl:variable name="totalElapsed" select="@total_elapsed"/>
	<xsl:choose>
		<xsl:when test="../@id">
			<h2>
				Resource Usage Profile
				&#160;<a href="#top">overall</a>&#160;<a href="#stm{$id}">current</a>&#160;<a class="toggle" href="#">hide</a>
			</h2>
		</xsl:when>
		<xsl:otherwise>
			<h2 id="top">
				Resource Usage Profile
				&#160;<a class="toggle" href="#">hide</a>
			</h2>
		</xsl:otherwise>
	</xsl:choose>			
	<div>
	<table>
		<tr>
			<th class="color" align="left">Component</th>
			<th class="color" align="right">Total Duration <a class="th" href="#units">[s]</a></th>
			<th class="color" align="right">%</th>
			<th class="color" align="right">Number of Events</th>
			<th class="color" align="right">Duration per Event <a class="th" href="#units">[s]</a></th>
		</tr>
		<xsl:for-each select="event">
			<xsl:variable name="name" select="translate(translate(@name,'*',''),' ','')"/>
			<tr>
				<td class="color" align="left">
					<xsl:choose>
						<xsl:when test="histogram or contributors">
							<a href="#{$name}-stm{$id}"><xsl:value-of select="@name"/></a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@name"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
				<td class="color" align="right">
					<xsl:choose>
						<xsl:when test="$totalElapsed > 0">
							<xsl:value-of select="format-number(@elapsed div $totalElapsed * 100, &ff;)"/>
						</xsl:when>
						<xsl:otherwise>
							n/a
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="color" align="right">
					<xsl:choose>
	 					<xsl:when test="@count">
							<xsl:value-of select="format-number(@count,&if;)"/>
						</xsl:when>
						<xsl:otherwise>
							n/a
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="color" align="right">
					<xsl:choose>
						<xsl:when test="@count">
							<xsl:value-of select="format-number(@elapsed div 1000000 div @count,&ff;)"/>
						</xsl:when>
						<xsl:otherwise>
							n/a
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:if test="count(event)>1">
			<tr>
				<td class="color" align="left">Total</td>
				<td class="color" align="right"><xsl:value-of select="format-number($totalElapsed div 1000000,&ff;)"/></td>
				<td class="color" align="right">
					<xsl:choose>
						<xsl:when test="@total_elapsed > 0">
							<xsl:value-of select="format-number(100,&ff;)"/>
						</xsl:when>
						<xsl:otherwise>
							n/a
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
	</table>
	<!-- only true for the profile at statement level -->
	<xsl:if test="../children/cursor">
		<p>
			<xsl:choose>
				<xsl:when test="../children/@count = 1">
					1 recursive statement was executed.
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../children/@count"/> recursive statements were executed.
				</xsl:otherwise>
			</xsl:choose>
			<br/>
			<xsl:if test="../children/@count > ../children/@limit">
				In the following table, only the top <xsl:value-of select="../children/@limit"/> recursive statements are reported.
			</xsl:if>
		</p>
		<table>
			<tr>
				<th class="color" align="left">Statement ID</th>
				<th class="color" align="left">Type</th>
				<th class="color" align="right">Total Duration <a class="th" href="#units">[s]</a></th>
				<th class="color" align="right">%</th>
			</tr>
			<xsl:for-each select="../children/cursor">
				<tr>
					<td class="color" align="left"><xsl:call-template name="anchor4cursor"/></td>
					<td class="color" align="left"><xsl:call-template name="cursortype"/></td>
					<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="$totalElapsed > 0">  
								<xsl:value-of select="format-number(@elapsed div $totalElapsed * 100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:for-each>
			<xsl:if test="../children/@count > 1">
				<tr>
					<td class="color" align="left">Total</td>
					<td class="color" align="left"/>
					<td class="color" align="right"><xsl:value-of select="format-number(../children/@elapsed div 1000000,&ff;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="$totalElapsed > 0">  
								<xsl:value-of select="format-number(../children/@elapsed div $totalElapsed * 100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:if>
		</table>    
	</xsl:if>
	<xsl:apply-templates select="event"/>
	</div>
</xsl:template>

<xsl:template name="cursors0">
	<xsl:variable name="totalElapsed" select="profile/@total_elapsed"/>				
	<xsl:variable name="sumElapsed" select="sum(profile/contributors/cursor/@elapsed)"/>
	<h2 id="stm">
		Statements
		&#160;<a class="toggle" href="#">hide</a>
	</h2>
	<div>
	<p>
		The input file contains <xsl:value-of select="profile/contributors/@count"/> distinct statements, 
		<xsl:choose>
			<xsl:when test="profile/contributors/@count_recursive = 1">
				<xsl:value-of select="profile/contributors/@count_recursive"/> of which is recursive.
			</xsl:when>
			<xsl:when test="profile/contributors/@count_recursive > 1">
				<xsl:value-of select="profile/contributors/@count_recursive"/> of which are recursive.
			</xsl:when>
			<xsl:otherwise>
				no one is resursive.
			</xsl:otherwise>
		</xsl:choose>
    </p>
	<xsl:if test="profile/contributors/cursor">
	    <p>
			In the following table, only
			<xsl:if test="profile/contributors/@count - profile/contributors/@count_recursive > profile/contributors/@limit">
				the top 
				<xsl:value-of select="profile/contributors/@limit"/>
			</xsl:if>
			non-recursive statements are reported.
		</p>
		<table>
			<tr>
				<th class="color" align="left">Statement ID</th>
				<th class="color" align="left">Type</th>
				<th class="color" align="right">Total Duration <a class="th" href="#units">[s]</a></th>
				<th class="color" align="right">%</th>
				<th class="color" align="right">Number of Executions</th>
				<th class="color" align="right">Duration per Execution <a class="th" href="#units">[s]</a></th>
			</tr>
			<xsl:for-each select="profile/contributors/cursor">
				<tr>
					<td class="color" align="left">
						<xsl:call-template name="anchor4cursor"/>
					</td>
					<td class="color" align="left"><xsl:call-template name="cursortype"/></td>
					<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="@elapsed > 0">  
								<xsl:value-of select="format-number(@elapsed div $totalElapsed * 100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(0,&ff;)"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="color" align="right"><xsl:value-of select="format-number(@count,&if;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="@count > 0">  
								<xsl:value-of select="format-number(@elapsed div 1000000 div @count,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:for-each>
			<tr>
				<td class="color" align="left">Total</td>
				<td class="color" align="left"/>
				<td class="color" align="right"><xsl:value-of select="format-number($sumElapsed div 1000000,&ff;)"/></td>
				<td class="color" align="right">
					<xsl:choose>
						<xsl:when test="$sumElapsed > 0">  
							<xsl:value-of select="format-number($sumElapsed div $totalElapsed * 100,&ff;)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number(0,&ff;)"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
	</xsl:if>
	</div>
</xsl:template>

<xsl:template match="event">
	<xsl:variable name="id" select="../../@id"/>
	<xsl:variable name="name" select="translate(translate(@name,'*',''),' ','')"/>
	<xsl:variable name="totalElapsed" select="@elapsed"/>
	<xsl:variable name="sumElapsed" select="sum(contributors/cursor/@elapsed)"/>
	<xsl:variable name="totalCount" select="@count"/>
	<xsl:variable name="totalBlocks" select="@blocks"/>
	<xsl:if test="histogram or contributors">
	<xsl:choose>
		<xsl:when test="../../@id">
			<h3 id="{$name}-stm{$id}">
				<xsl:value-of select="@name"/>
				&#160;<a href="#{$name}-stm">overall</a><xsl:if test="../../@id">&#160;<a href="#stm{$id}">current</a></xsl:if>&#160;<a class="toggle" href="#">hide</a>
			</h3>
		</xsl:when>
		<xsl:otherwise>
			<h3 id="{$name}-stm">
				<xsl:value-of select="@name"/>
				&#160;<a href="#top">overall</a><xsl:if test="../../@id">&#160;<a href="#stm{$id}">current</a></xsl:if>&#160;<a class="toggle" href="#">hide</a>
			</h3>
		</xsl:otherwise>				
	</xsl:choose>
	</xsl:if>
	<div>
	<xsl:if test="histogram">
		<table>
			<tr>
				<th class="color" align="left">Range <a class="th" href="#units">[&#956;s]</a></th>
				<th class="color" align="right">Total Duration <a class="th" href="#units">[s]</a></th>
				<th class="color" align="right">%</th>
				<th class="color" align="right">Number of Events</th>
				<th class="color" align="right">%</th>
				<th class="color" align="right">Duration per Event <a class="th" href="#units">[&#956;s]</a></th>
				<xsl:if test="$totalBlocks>0">
					<th class="color" align="right">Blocks <a class="th" href="#units">[b]</a></th>
					<th class="color" align="right">Blocks per Event <a class="th" href="#units">[b]</a></th>
				</xsl:if>
			</tr>
			<xsl:for-each select="histogram/bucket">
				<tr>
					<td class="color" align="center"><xsl:value-of select="@range"/></td>
					<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="$totalElapsed > 0">
								<xsl:value-of select="format-number(@elapsed div $totalElapsed * 100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="color" align="right"><xsl:value-of select="format-number(@count,&if;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="$totalCount > 0">
								<xsl:value-of select="format-number(@count div $totalCount * 100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="@count > 0">
								<xsl:value-of select="format-number(@elapsed div @count,&if;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<xsl:if test="$totalBlocks>0">
						<td class="color" align="right"><xsl:value-of select="format-number(@blocks,&if;)"/></td>
						<td class="color" align="right"><xsl:value-of select="format-number(@blocks div @count,&ff;)"/></td>
					</xsl:if>
				</tr>
			</xsl:for-each>
			<xsl:if test="count(histogram/bucket)>1">
				<tr>
					<td class="color" align="left">Total</td>
					<td class="color" align="right"><xsl:value-of select="format-number($totalElapsed div 1000000,&ff;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="$totalElapsed > 0">  
								<xsl:value-of select="format-number(100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="color" align="right"><xsl:value-of select="format-number($totalCount,&if;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="$totalCount > 0">  
								<xsl:value-of select="format-number(100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="color" align="right"><xsl:value-of select="format-number($totalElapsed div $totalCount,&if;)"/></td>
					<xsl:if test="$totalBlocks>0">
						<td class="color" align="right"><xsl:value-of select="format-number($totalBlocks,&if;)"/></td>
						<td class="color" align="right"><xsl:value-of select="format-number($totalBlocks div $totalCount,&ff;)"/></td>
					</xsl:if>
				</tr>
			</xsl:if>
		</table>
		<p/>
		<xsl:if test="distribution">
			<xsl:variable name="totalDistributionBlocks" select="sum(distribution/bucket/@blocks)"/>
			<xsl:variable name="totalDistributionCount" select="sum(distribution/bucket/@count)"/>
			<xsl:variable name="totalDistributionElapsed" select="sum(distribution/bucket/@elapsed)"/>
			<p>
				<xsl:if test="distribution/@count > distribution/@limit">
					In total there are <xsl:value-of select="distribution/@count"/> entries.
					In the following table, only the top <xsl:value-of select="distribution/@limit"/> entries are reported.
				</xsl:if>
			</p>
			<table>
				<tr>
					<xsl:if test="distribution/bucket[1]/@file">
						<th class="color" align="left">File</th>
					</xsl:if>
					<xsl:if test="distribution/bucket[1]/@block">
						<th class="color" align="left">Block Number</th>
					</xsl:if>
					<th class="color" align="right">Total Duration <a class="th" href="#units">[s]</a></th>
					<xsl:if test="$totalDistributionElapsed>0">
						<th class="color" align="right">%</th>
					</xsl:if>
					<xsl:if test="distribution/bucket[1]/@count">
						<th class="color" align="right">Number of Events</th>
						<xsl:if test="$totalDistributionCount>0">
							<th class="color" align="right">%</th>
						</xsl:if>
					</xsl:if>
					<xsl:if test="distribution/bucket[1]/@blocks">
						<th class="color" align="right">Blocks <a class="th" href="#units">[b]</a></th>
						<xsl:if test="$totalDistributionBlocks>0">
							<th class="color" align="right">%</th>
						</xsl:if>
					</xsl:if>
					<th class="color" align="right">Duration per Event <a class="th" href="#units">[&#956;s]</a></th>
					<xsl:if test="distribution/bucket[1]/@reason">
						<th class="color" align="left">Class/Reason</th>
					</xsl:if>
				</tr>
				<xsl:for-each select="distribution/bucket">
					<tr>
						<xsl:if test="../bucket[1]/@file">
							<td class="color" align="left"><xsl:value-of select="@file"/></td>
						</xsl:if>
						<xsl:if test="../bucket[1]/@block">
							<td class="color" align="left"><xsl:value-of select="format-number(@block,&if;)"/></td>
						</xsl:if>
						<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
						<xsl:if test="$totalDistributionElapsed>0">
							<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div $totalDistributionElapsed * 100,&ff;)"/></td>
						</xsl:if>
						<xsl:if test="../bucket[1]/@count">
							<td class="color" align="right"><xsl:value-of select="format-number(@count,&if;)"/></td>
							<xsl:if test="$totalDistributionCount>0">
								<td class="color" align="right"><xsl:value-of select="format-number(@count div $totalDistributionCount * 100,&ff;)"/></td>
							</xsl:if>
						</xsl:if>
						<xsl:if test="../bucket[1]/@blocks">
							<td class="color" align="right"><xsl:value-of select="format-number(@blocks,&if;)"/></td>
							<xsl:if test="$totalDistributionBlocks>0">
								<td class="color" align="right"><xsl:value-of select="format-number(@blocks div $totalDistributionBlocks * 100,&ff;)"/></td>
							</xsl:if>
						</xsl:if>
						<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div @count,&if;)"/></td>
						<xsl:if test="../bucket[1]//@reason">
							<td class="color" align="left"><xsl:value-of select="@reason"/></td>
						</xsl:if>
					</tr>
				</xsl:for-each>
				<xsl:if test="count(distribution/bucket)>1">
					<tr>
						<xsl:if test="distribution/bucket[1]/@file">
							<td class="color" align="left">Total</td>
						</xsl:if>
						<xsl:if test="distribution/bucket[1]/@block">
							<td class="color" align="right"></td>
						</xsl:if>
						<td class="color" align="right"><xsl:value-of select="format-number($totalDistributionElapsed div 1000000,&ff;)"/></td>
						<xsl:if test="$totalDistributionElapsed>0">
							<td class="color" align="right"><xsl:value-of select="format-number(100,&ff;)"/></td>
						</xsl:if>
						<xsl:if test="distribution/bucket[1]/@count">
							<td class="color" align="right"><xsl:value-of select="format-number($totalDistributionCount,&if;)"/></td>
							<xsl:if test="$totalDistributionCount>0">
								<td class="color" align="right"><xsl:value-of select="format-number(100,&ff;)"/></td>
							</xsl:if>
						</xsl:if>
						<xsl:if test="distribution/bucket[1]/@blocks">
							<td class="color" align="right"><xsl:value-of select="format-number($totalDistributionBlocks,&if;)"/></td>
							<xsl:if test="$totalDistributionBlocks>0">
								<td class="color" align="right"><xsl:value-of select="format-number(100,&ff;)"/></td>
							</xsl:if>
						</xsl:if>
						<td class="color" align="right"><xsl:value-of select="format-number($totalDistributionElapsed div $totalDistributionCount,&if;)"/></td>
					</tr>
				</xsl:if>
			</table>
		</xsl:if>
	</xsl:if>
	<xsl:if test="contributors">
		<p>
			<xsl:choose>
				<xsl:when test="contributors/@count = 1"> 
					1 statement contributed to this event.
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="contributors/@count"/> statements contributed to this event.
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="contributors/@count > contributors/@limit">
				In the following table, only the top <xsl:value-of select="contributors/@limit"/> contributors are reported.
			</xsl:if>
		</p>
		<table>
			<tr>
				<th class="color" align="left">Statement ID</th>
				<th class="color" align="left">Type</th>
				<th class="color" align="right">Total Duration <a class="th" href="#units">[s]</a></th>
				<th class="color" align="right">%</th>
			</tr>
			<xsl:for-each select="contributors/cursor">
				<tr>
					<td class="color" align="left">
						<xsl:call-template name="anchor4cursor"/>
					</td>
					<td class="color" align="left">
						<xsl:call-template name="cursortype"/>               
					</td>
					<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="$totalElapsed > 0">  
								<xsl:value-of select="format-number(@elapsed div $totalElapsed * 100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:for-each>
			<xsl:if test="contributors/@count > 1">
				<tr>
					<td class="color" align="left">Total</td>
					<td class="color" align="left"/>
					<td class="color" align="right"><xsl:value-of select="format-number($sumElapsed div 1000000,&ff;)"/></td>
					<td class="color" align="right">
						<xsl:choose>
							<xsl:when test="$totalElapsed > 0">  
								<xsl:value-of select="format-number($sumElapsed div $totalElapsed * 100,&ff;)"/>
							</xsl:when>
							<xsl:otherwise>
								n/a
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:if>
		</table>    
	</xsl:if>
	</div>
</xsl:template>
 
<xsl:template name="cursor_detail">
	<table>
		<xsl:if test="container_id">
			<tr>
				<th class="no_color" align="left">Container&#160;ID</th>
				<td class="no_color" align="left"><xsl:value-of select="container_id"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="session_id">
			<tr>
				<th class="no_color" align="left">Session&#160;ID</th>
				<td class="no_color" align="left"><xsl:value-of select="session_id"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="client_id">
			<tr>
				<th class="no_color" align="left">Client&#160;ID</th>
				<td class="no_color" align="left"><xsl:value-of select="client_id"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="client_driver">
			<tr>
				<th class="no_color" align="left">Client&#160;Driver</th>
				<td class="no_color" align="left"><xsl:value-of select="client_driver"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="service_name">
			<tr>
				<th class="no_color" align="left">Service&#160;Name</th>
				<td class="no_color" align="left"><xsl:value-of select="service_name"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="module_name">
			<tr>
				<th class="no_color" align="left">Module&#160;Name</th>
				<td class="no_color" align="left"><xsl:value-of select="module_name"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="action_name">
			<tr>
				<th class="no_color" align="left">Action&#160;Name</th>
				<td class="no_color" align="left"><xsl:value-of select="action_name"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@uid">
			<tr>
				<th class="no_color" align="left">Parsing&#160;User</th>
				<td class="no_color" align="left"><xsl:value-of select="@uid"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@depth!=0">
			<tr>
				<th class="no_color" align="left">Recursive&#160;Level</th>
				<td class="no_color" align="left"><xsl:value-of select="@depth"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@depth!=0">
			<tr>
				<th class="no_color" align="left">Parent&#160;Statement&#160;ID</th>
				<td class="no_color" align="left">
					<a href="#stm{@parent}"><xsl:value-of select="@parent"/></a>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="@hash_value">
			<tr>
				<th class="no_color" align="left">Hash&#160;Value</th>
				<td class="no_color" align="left"><xsl:value-of select="@hash_value"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@sql_id">
			<tr>
				<th class="no_color" align="left">SQL&#160;ID</th>
				<td class="no_color" align="left"><xsl:value-of select="@sql_id"/></td>
			</tr>
		</xsl:if>
		<tr>
			<th class="no_color" align="left">Text</th>
			<td class="no_color_pre" align="left">
				<xsl:for-each select="sql/line">
					<xsl:value-of select="."/><br/>
				</xsl:for-each>
			</td>
		</tr>
		<xsl:if test="errors">
			<tr>
				<th class="no_color" align="left">Errors</th>
				<td class="no_color" align="left">
					<xsl:for-each select="errors/error">
						ORA-<xsl:value-of select="format-number(.,'00000')"/>&#160;
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
	</table>
	<xsl:apply-templates select="binds"/>
	<xsl:apply-templates select="execution_plans"/>
	<xsl:apply-templates select="cumulated_statistics"/>
	<xsl:apply-templates select="current_statistics"/>
	<xsl:apply-templates select="profile"/>
</xsl:template>

<xsl:template match="cumulated_statistics">
	<xsl:variable name="id" select="../@id"/>
	<h2>
		<xsl:choose>
			<xsl:when test="../current_statistics">
				Database Call Statistics with Recursive Statements
			</xsl:when>
			<xsl:otherwise>
				Database Call Statistics
			</xsl:otherwise>
		</xsl:choose>
		&#160;<a href="#stm{$id}">current</a>&#160;<a class="toggle" href="#">hide</a>
	</h2>
	<table>
		<tr>
			<th class="color" align="left">Call</th>
			<th class="color" align="right">Count</th>
			<th class="color" align="left">Misses</th>
			<th class="color" align="right">CPU <a class="th" href="#units">[s]</a></th>
			<th class="color" align="right">Elapsed <a class="th" href="#units">[s]</a></th>
			<th class="color" align="right">PIO <a class="th" href="#units">[b]</a></th>
			<th class="color" align="right">LIO <a class="th" href="#units">[b]</a></th>
			<th class="color" align="right">Consistent <a class="th" href="#units">[b]</a></th>
			<th class="color" align="right">Current <a class="th" href="#units">[b]</a></th>
			<th class="color" align="right">Rows</th>
		</tr>
		<xsl:apply-templates select="statistic"/>
	</table>
</xsl:template>

<xsl:template match="current_statistics">
	<xsl:variable name="id" select="../@id"/>
	<h2>
    Database Call Statistics without Recursive Statements
    &#160;<a href="#stm{$id}">current</a>&#160;<a class="toggle" href="#">hide</a>
  </h2>
	<table>
		<tr>
			<th class="color" align="left">Call</th>
			<th class="color" align="right">Count</th>
			<th class="color" align="left">Misses</th>
			<th class="color" align="right">CPU <a class="th" href="#units">[s]</a></th>
			<th class="color" align="right">Elapsed <a class="th" href="#units">[s]</a></th>
			<th class="color" align="right">PIO <a class="th" href="#units">[b]</a></th>
			<th class="color" align="right">LIO <a class="th" href="#units">[b]</a></th>
			<th class="color" align="right">Consistent <a class="th" href="#units">[b]</a></th>
			<th class="color" align="right">Current <a class="th" href="#units">[b]</a></th>
			<th class="color" align="right">Rows</th>
		</tr>
		<xsl:apply-templates select="statistic"/>
	</table>
</xsl:template>

<xsl:template match="statistic[@call='Parse' or @call='Execute' or @call='Fetch' or @call='Total']">
	<tr>
		<td class="color" align="left"><xsl:value-of select="@call"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@count,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@misses,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@cpu div 1000000,&ff;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@pio,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@lio,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@consistent,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@current,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@rows,&if;)"/></td>
	</tr>
</xsl:template>

<xsl:template match="statistic[substring(@call,1,7)='Average']">
	<tr>
		<td class="color" align="left"><xsl:value-of select="@call"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@count,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@misses,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@cpu div 1000000,&ff;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@pio,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@lio,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@consistent,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@current,&if;)"/></td>
		<td class="color" align="right"><xsl:value-of select="format-number(@rows,&if;)"/></td>
	</tr>
</xsl:template>

<xsl:template match="execution_plans">
	<xsl:variable name="id" select="../@id"/>
	<h2>
		Execution Plans
		&#160;<a href="#stm{$id}">current</a>&#160;<a class="toggle" href="#">hide</a>
	</h2>
	<div>
	<xsl:for-each select="execution_plan">
		<table>
			<tr>
				<th class="no_color" align="left">Optimizer Mode</th>
				<td class="no_color" align="left"><xsl:value-of select="@goal"/></td>
			</tr>
			<xsl:if test="@hash_value">
				<tr>
					<th class="no_color" align="left">Hash Value</th>
					<td class="no_color" align="left"><xsl:value-of select="@hash_value"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="count(../execution_plan)>1">
				<tr>
					<th class="no_color" align="left">Number of Executions</th>
					<td class="no_color" align="left"><xsl:value-of select="@executions"/></td>
				</tr>
			</xsl:if>
		</table>
		<xsl:if test="@incomplete='true'">
			<p class="error">WARNING: The following execution plan is incomplete.</p>
		</xsl:if>
		<p/>
		<table>
			<xsl:if test="line/@elapsed">
				<tr>
					<th class="no_color" colspan="9"></th>
					<th class="color" align="center" colspan="5">Cumulated (incl. descendants)</th>
				</tr>
			</xsl:if>
			<tr>
				<th class="color" align="right">Rows</th>
				<th class="color" align="left">Operation</th>
				<xsl:if test="line/@elapsed">
					<th class="color" align="right">Elapsed <a class="th" href="#units">[s]</a></th>
					<th class="color" align="right">PIO <a class="th" href="#units">[b]</a></th>
					<th class="color" align="right">Consistent <a class="th" href="#units">[b]</a></th>
					<th class="color" align="right">Elapsed <a class="th" href="#units">[s]</a></th>
					<th class="color" align="right">PIO <a class="th" href="#units">[b]</a></th>
					<th class="color" align="right">Consistent <a class="th" href="#units">[b]</a></th>
				</xsl:if>
			</tr>
			<xsl:for-each select="line">
				<tr>
					<td class="color" align="right"><xsl:value-of select="format-number(@rows,&if;)"/></td>
					<td class="color" align="left">
						<xsl:value-of select="substring('&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;',1,3*@level)"/>
						<xsl:value-of select="text()"/>
					</td>
					<xsl:if test="@elapsed">
						<td class="color" align="right"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></td>
						<td class="color" align="right"><xsl:value-of select="format-number(@pio,&if;)"/></td>
						<td class="color" align="right"><xsl:value-of select="format-number(@lio,&if;)"/></td>
						<td class="color" align="right"><xsl:value-of select="format-number(@cum_elapsed div 1000000,&ff;)"/></td>
						<td class="color" align="right"><xsl:value-of select="format-number(@cum_pio,&if;)"/></td>
						<td class="color" align="right"><xsl:value-of select="format-number(@cum_lio,&if;)"/></td>
					</xsl:if>
				</tr>
			</xsl:for-each>
		</table>
		<p/>
	</xsl:for-each>
	</div>
</xsl:template>

<xsl:template match="binds[@count&gt;0]">
	<xsl:variable name="id" select="../@id"/>
    <h2>
    	Bind Variables
		  &#160;<a href="#stm{$id}">current</a>&#160;<a class="toggle" href="#">hide</a>
    </h2>
    <div>
		<p>
			<xsl:choose>
				<xsl:when test="@count = 1">
					1 bind variable set was used to execute this statement.
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@count"/> bind variable sets were used to execute this statement.
				</xsl:otherwise>
			</xsl:choose>
			<br/>
			<xsl:if test="@count > @limit">
				In the following table, only the first <xsl:value-of select="@limit"/> bind variable sets are reported.
			</xsl:if>
		</p>
    	<table>
			<tr>
				<th class="color" align="left">Execution</th>
				<th class="color" align="left">Batch</th>
				<th class="color" align="left">Bind</th>
				<th class="color" align="left">Datatype</th>
				<th class="color" align="left">Value</th>
			</tr>
      	<xsl:apply-templates select="bind_batch/bind_set/bind"/>
    	</table>
    </div>
</xsl:template>

<xsl:template match="bind_batch/bind_set/bind">
	<tr>
		<td class="color" align="left">
		<xsl:if test="@nr=1 and ../@nr=1">
			<xsl:value-of select="../../@nr"/>
		</xsl:if>
		</td>
		<td class="color" align="left">
		<xsl:if test="@nr=1">
			<xsl:value-of select="../@nr"/>
		</xsl:if>
		</td>
		<td class="color" align="left"><xsl:value-of select="@nr"/></td>
		<td class="color" align="left"><xsl:value-of select="@datatype"/></td>
		<td class="color_pre" align="left"><xsl:value-of select="text()"/></td>
    </tr>
</xsl:template>

<!-- small pieces of code reused many times... -->
  
<xsl:template name="anchor4cursor">
	<xsl:variable name="currentId" select="@id"/>
	<xsl:choose>
		<xsl:when test="/tvdxtat/cursors/cursor[@id=$currentId]">
			<a href="#stm{$currentId}"><xsl:value-of select="$currentId"/></a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$currentId"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="cursortype">
	<xsl:value-of select="@type"/>
	<xsl:if test="@uid = 0 and @depth > 0">
		(SYS recursive)
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
