<?xml version="1.0" encoding="UTF-8" standalone="yes"?>

<!DOCTYPE tvdxtat [
  <!ENTITY ff "'#,###,###,##0.000'">                  <!-- float format -->
  <!ENTITY size_ff "17">                             <!-- number of characters for a float -->
  <!ENTITY if "'#,###,###,##0'">                      <!-- integer format -->
  <!ENTITY size_if "13">                             <!-- number of characters for an integer -->
  <!ENTITY size_datatype "33">                       <!-- number of characters for a datatype -->
  <!ENTITY size_data "40">                           <!-- number of characters for bind variables data -->
  <!ENTITY size_type "32">                           <!-- number of characters for a statement type -->
  <!ENTITY size_range "34">                          <!-- number of characters for a range -->
  <!ENTITY size_component "45">                      <!-- number of characters for a component name -->
  <!ENTITY size_percent "7">                         <!-- number of characters for a percentage -->
  <!ENTITY size_call "23">                           <!-- number of characters for a call name -->
  <!ENTITY sp "<xsl:text> </xsl:text>">              <!-- space -->
  <!ENTITY nl "<xsl:text>&#xa;</xsl:text>">          <!-- new line -->
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8"/>

<!--  M A I N  -->

<xsl:template match="/tvdxtat">
  &nl;
  <xsl:text>******************************************** TVD$XTAT **********************************************</xsl:text>
  &nl;
  &nl;
  <xsl:value-of select="header/version"/>
  &nl;
  &nl;
  <xsl:value-of select="header/copyright"/>
  &sp;
  <xsl:text>(</xsl:text>
  <xsl:value-of select="header/author/email"/>
  <xsl:text>)</xsl:text>
  &nl;
  &nl;
  <xsl:text>Trivadis AG</xsl:text>
  &nl;
  <xsl:text>Sägereistrasse 29</xsl:text>
  &nl;
  <xsl:text>CH-8152 Glattbrugg / Zurich</xsl:text>
  &nl;
  &nl;
  <xsl:text>*************************************** OVERALL INFORMATION ****************************************</xsl:text>
  &nl;
  <xsl:apply-templates select="database"/>
  <xsl:apply-templates select="tracefiles"/>
  <xsl:apply-templates select="period"/>
  <xsl:apply-templates select="transactions"/>
  <xsl:call-template name="cursors0"/>
  <xsl:apply-templates select="profile"/>
  <xsl:for-each select="cursors/cursor">
    &nl;
    <xsl:text>****************************************** STATEMENT #</xsl:text><xsl:value-of select="@id"/>
    <xsl:text> ******************************************</xsl:text>
    &nl;
    &nl;
    <xsl:call-template name="cursor_detail"/>
  </xsl:for-each>
  &nl;
  <xsl:text>***************************************** UNITS OF MEASURE *****************************************</xsl:text>
  &nl;
  &nl;
  <xsl:text>[s]  seconds</xsl:text>
  &nl;
  <xsl:text>[us] microseconds</xsl:text>
  &nl;
  <xsl:text>[b]  database blocks</xsl:text>
  &nl;
  &nl;
  <xsl:text>****************************************************************************************************</xsl:text>
</xsl:template>

<xsl:template match="database">
  <xsl:if test="line">
    &nl;
    <xsl:text>Database Version</xsl:text>
    &nl;
    <xsl:text>****************</xsl:text>
    &nl;
    <xsl:for-each select="line">
      <xsl:value-of select="text()"/>
      &nl;
    </xsl:for-each>
    &nl;
  </xsl:if>
</xsl:template>
  
<xsl:template match="tracefiles">
  <xsl:if test="tracefile">
    <xsl:text>Analyzed Trace File</xsl:text>
    <xsl:if test="count(tracefile) > 1"><xsl:text>s</xsl:text></xsl:if>
    &nl;
    <xsl:text>*******************</xsl:text>
    <xsl:if test="count(tracefile) > 1"><xsl:text>-</xsl:text></xsl:if>
    &nl;
    <xsl:for-each select="tracefile">
      <xsl:value-of select="text()"/>
      &nl;
    </xsl:for-each>
    &nl;
  </xsl:if>
</xsl:template>

<xsl:template match="period">
  <xsl:text>Interval</xsl:text>
  &nl;
  <xsl:text>********</xsl:text>
  &nl;
  <xsl:if test="begin">
    <xsl:text>Beginning </xsl:text><xsl:value-of select="begin"/>
    &nl;
    <xsl:text>End       </xsl:text><xsl:value-of select="end"/>
    &nl;
  </xsl:if>
  <xsl:if test="duration">
    <xsl:text>Duration  </xsl:text><xsl:value-of select="format-number(duration div 1000000,&ff;)"/>
    <xsl:text> [s]</xsl:text>
    &nl;
  </xsl:if>
  <xsl:if test="warning">
    &nl;
    <xsl:for-each select="warning">
      <xsl:text>WARNING: </xsl:text><xsl:value-of select="text()"/>
      &nl;
    </xsl:for-each>
  </xsl:if>
</xsl:template>
  
<xsl:template match="transactions">
  &nl;
  <xsl:text>Transactions</xsl:text>
  &nl;
  <xsl:text>************</xsl:text>
  &nl;
  <xsl:text>Committed  </xsl:text><xsl:value-of select="format-number(commit,&if;)"/>
  &nl;
  <xsl:text>Rollbacked </xsl:text><xsl:value-of select="format-number(rollback,&if;)"/>
  &nl;
</xsl:template>

<xsl:template match="profile">
  <xsl:variable name="totalElapsed" select="@total_elapsed"/>       
  &nl;
  <xsl:text>Resource Usage Profile</xsl:text>
  &nl;
  <xsl:text>**********************</xsl:text>
  &nl;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value"></xsl:with-param>
    <xsl:with-param name="length">&size_component;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Total</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"></xsl:with-param>
    <xsl:with-param name="length">&size_percent;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Number of</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Duration per</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &nl;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">Component</xsl:with-param>
    <xsl:with-param name="length">&size_component;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Duration [s]</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">%</xsl:with-param>
    <xsl:with-param name="length">&size_percent;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Events</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Event [s]</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &nl;
  <xsl:call-template name="line_component"/>
  &sp;
  <xsl:call-template name="line_ff"/>
  &sp;
  <xsl:call-template name="line_percent"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_ff"/>
  &nl;
  <xsl:for-each select="event">
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"><xsl:value-of select="@name"/></xsl:with-param>
      <xsl:with-param name="length">&size_component;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="$totalElapsed > 0">
            <xsl:value-of select="format-number(@elapsed div $totalElapsed * 100, &ff;)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>n/a</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="@count">
            <xsl:value-of select="format-number(@count,&if;)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>n/a</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="@count">
            <xsl:value-of select="format-number(@elapsed div 1000000 div @count,&ff;)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>n/a</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &nl; 
  </xsl:for-each>
  <xsl:if test="count(event) > 1">
    <xsl:call-template name="line_component"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_percent"/>
    &nl; 
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Total</xsl:with-param>
      <xsl:with-param name="length">&size_component;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"><xsl:value-of select="format-number($totalElapsed div 1000000,&ff;)"/></xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="@total_elapsed > 0">
            <xsl:value-of select="format-number(100,&ff;)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>n/a</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  &nl;
  <!-- only true for the profile at statement level -->
  <xsl:if test="../children/cursor">
    &nl;
    <xsl:choose>
      <xsl:when test="../children/@count = 1">
        <xsl:text>1 recursive statement was executed.</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../children/@count"/>
        <xsl:text> recursive statements were executed.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    &nl;
    <xsl:if test="../children/@count > ../children/@limit">
      <xsl:text>In the following table, only the top </xsl:text><xsl:value-of select="../children/@limit"/>
      <xsl:text> recursive statements are reported.</xsl:text>
      &nl;
    </xsl:if>
    &nl;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_type;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Total</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &nl;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Statement ID</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Type</xsl:with-param>
      <xsl:with-param name="length">&size_type;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Duration [s]</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">%</xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &nl;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_type"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_percent"/>
    &nl;
    <xsl:for-each select="../children/cursor">
      <xsl:call-template name="rpad">
        <xsl:with-param name="value">#<xsl:value-of select="@id"/></xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="rpad">
        <xsl:with-param name="value"><xsl:call-template name="cursortype"/></xsl:with-param>
        <xsl:with-param name="length">&size_type;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="$totalElapsed > 0">  
              <xsl:value-of select="format-number(@elapsed div $totalElapsed * 100,&ff;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_percent;</xsl:with-param>
      </xsl:call-template>
      &nl;
    </xsl:for-each>
    <xsl:if test="../children/@count > 1">
      <xsl:call-template name="line_if"/>
      &sp;
      <xsl:call-template name="line_type"/>
      &sp;
      <xsl:call-template name="line_ff"/>
      &sp;
      <xsl:call-template name="line_percent"/>
      &nl;
    </xsl:if>
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Total</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_type;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"><xsl:value-of select="format-number(../children/@elapsed div 1000000,&ff;)"/></xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="$totalElapsed > 0">  
            <xsl:value-of select="format-number(../children/@elapsed div $totalElapsed * 100,&ff;)"/>
          </xsl:when>
          <xsl:otherwise>
            n/a
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &nl;
  </xsl:if>
  <xsl:apply-templates select="event"/>
</xsl:template>

<xsl:template name="cursors0">
  <xsl:variable name="totalElapsed" select="profile/@total_elapsed"/>       
  <xsl:variable name="sumElapsed" select="sum(profile/contributors/cursor/@elapsed)"/>
  &nl;
  <xsl:text>Statements</xsl:text>
  &nl;
  <xsl:text>**********</xsl:text>
  &nl;
  <xsl:text>The input file contains </xsl:text><xsl:value-of select="profile/contributors/@count"/>
  <xsl:text> distinct statements, </xsl:text>
  <xsl:choose>
    <xsl:when test="profile/contributors/@count_recursive = 1">
      <xsl:value-of select="profile/contributors/@count_recursive"/>
      <xsl:text> of which is recursive.</xsl:text>
    </xsl:when>
    <xsl:when test="profile/contributors/@count_recursive > 1">
      <xsl:value-of select="profile/contributors/@count_recursive"/>
      <xsl:text> of which are recursive.</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>no one is resursive.</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  &nl;
  <xsl:if test="profile/contributors/cursor">
    <xsl:text>In the following table, only</xsl:text>
    <xsl:if test="profile/contributors/@count - profile/contributors/@count_recursive > profile/contributors/@limit">
      <xsl:text> the top </xsl:text><xsl:value-of select="profile/contributors/@limit"/>
    </xsl:if>
    <xsl:text> non-recursive statements are reported.</xsl:text>
    &nl;
    &nl;    
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_type;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Total</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Number of</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Duration per</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &nl;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Statement ID</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Type</xsl:with-param>
      <xsl:with-param name="length">&size_type;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Duration [s]</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">%</xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Executions</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Execution [s]</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &nl;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_type"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_percent"/>
    &sp;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &nl;
    <xsl:for-each select="profile/contributors/cursor">
      <xsl:call-template name="rpad">
        <xsl:with-param name="value">#<xsl:value-of select="@id"/></xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="rpad">
        <xsl:with-param name="value"><xsl:call-template name="cursortype"/></xsl:with-param>
        <xsl:with-param name="length">&size_type;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="@elapsed > 0">  
              <xsl:value-of select="format-number(@elapsed div $totalElapsed * 100,&ff;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(0,&ff;)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_percent;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number(@count,&if;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="@count > 0">  
              <xsl:value-of select="format-number(@elapsed div 1000000 div @count,&ff;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &nl;
    </xsl:for-each>
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_type"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_percent"/>
    &nl;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Total</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_type;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"><xsl:value-of select="format-number($sumElapsed div 1000000,&ff;)"/></xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="$sumElapsed > 0">  
            <xsl:value-of select="format-number($sumElapsed div $totalElapsed * 100,&ff;)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="format-number(0,&ff;)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &nl;
  </xsl:if>
</xsl:template>

<xsl:template match="event">
  <xsl:variable name="totalElapsed" select="@elapsed"/>
  <xsl:variable name="sumElapsed" select="sum(contributors/cursor/@elapsed)"/>
  <xsl:variable name="totalCount" select="@count"/>
  <xsl:variable name="totalBlocks" select="@blocks"/>
  <xsl:if test="histogram or contributors">
    &nl;
    <xsl:value-of select="@name"/>
    &nl;
    <xsl:call-template name="starline">
      <xsl:with-param name="length"><xsl:value-of select="string-length(@name)"/></xsl:with-param>
    </xsl:call-template>
    &nl;
  </xsl:if>
  <xsl:if test="histogram">
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_range;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Total</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Number of</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Duration per</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    <xsl:if test="$totalBlocks>0">
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"></xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">Blocks per</xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    &nl;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Range [us]</xsl:with-param>
      <xsl:with-param name="length">&size_range;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Duration [s]</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">%</xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Events</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">%</xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Event [us]</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    <xsl:if test="$totalBlocks>0">
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">Blocks [b]</xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">Event [b]</xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    &nl;
    <xsl:call-template name="line_range"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_percent"/>
    &sp;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_percent"/>
    &sp;
    <xsl:call-template name="line_if"/>
    <xsl:if test="$totalBlocks>0">
      &sp;
      <xsl:call-template name="line_if"/>
      &sp;
      <xsl:call-template name="line_if"/>
    </xsl:if>
    &nl;
    <xsl:for-each select="histogram/bucket">
      <xsl:call-template name="rpad">
        <xsl:with-param name="value"><xsl:value-of select="@range"/></xsl:with-param>
        <xsl:with-param name="length">&size_range;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="$totalElapsed > 0">
              <xsl:value-of select="format-number(@elapsed div $totalElapsed * 100,&ff;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_percent;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number(@count,&if;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="$totalCount > 0">
              <xsl:value-of select="format-number(@count div $totalCount * 100,&if;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_percent;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="@count > 0">
              <xsl:value-of select="format-number(@elapsed div @count,&if;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      <xsl:if test="$totalBlocks>0">
        &sp;
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"><xsl:value-of select="format-number(@blocks,&if;)"/></xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"><xsl:value-of select="format-number(@blocks div @count,&if;)"/></xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      &nl;
    </xsl:for-each>
    <xsl:if test="count(histogram/bucket) > 1">
      <xsl:call-template name="line_range"/>
      &sp;
      <xsl:call-template name="line_ff"/>
      &sp;
      <xsl:call-template name="line_percent"/>
      &sp;
      <xsl:call-template name="line_if"/>
      &sp;
      <xsl:call-template name="line_percent"/>
      &sp;
      <xsl:call-template name="line_if"/>
      <xsl:if test="$totalBlocks>0">
        &sp;
        <xsl:call-template name="line_if"/>
        &sp;
        <xsl:call-template name="line_if"/>
      </xsl:if>
      &nl;
      <xsl:call-template name="rpad">
        <xsl:with-param name="value">Total</xsl:with-param>
        <xsl:with-param name="length">&size_range;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number($totalElapsed div 1000000,&ff;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="$totalElapsed > 0">
              <xsl:value-of select="format-number(100,&ff;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_percent;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number($totalCount,&if;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="$totalCount > 0">
              <xsl:value-of select="format-number(100,&ff;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_percent;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="@count > 0">
              <xsl:value-of select="format-number($totalElapsed div $totalCount,&if;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      <xsl:if test="$totalBlocks>0">
        &sp;
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"><xsl:value-of select="format-number($totalBlocks,&if;)"/></xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"><xsl:value-of select="format-number($totalBlocks div $totalCount,&if;)"/></xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      &nl;
    </xsl:if>

    <xsl:if test="distribution">
      <xsl:variable name="totalDistributionBlocks" select="sum(distribution/bucket/@blocks)"/>
      <xsl:variable name="totalDistributionCount" select="sum(distribution/bucket/@count)"/>
      <xsl:variable name="totalDistributionElapsed" select="sum(distribution/bucket/@elapsed)"/>
      &nl;
      <xsl:if test="distribution/@count > distribution/@limit">
        <xsl:text>In total there are </xsl:text><xsl:value-of select="distribution/@count"/>
        <xsl:text> entries. In the following table, only the top </xsl:text><xsl:value-of select="distribution/@limit"/>
        <xsl:text> entries are reported.</xsl:text>
        &nl;
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@file">
        <xsl:call-template name="rpad">
          <xsl:with-param name="value">File</xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@block">
        <xsl:call-template name="rpad">
          <xsl:with-param name="value">Block</xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
      </xsl:if>
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">Total</xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:if test="$totalDistributionElapsed > 0">
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"></xsl:with-param>
          <xsl:with-param name="length">&size_percent;</xsl:with-param>
        </xsl:call-template>
        &sp;
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@count">
        <xsl:call-template name="lpad">
          <xsl:with-param name="value">Number of</xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:if test="$totalDistributionCount>0">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value"></xsl:with-param>
            <xsl:with-param name="length">&size_percent;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@blocks">
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"></xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:if test="$totalDistributionBlocks>0">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value"></xsl:with-param>
            <xsl:with-param name="length">&size_percent;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
      </xsl:if>
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">Duration per</xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:if test="distribution/bucket[1]/@reason">
        <xsl:call-template name="rpad">
          <xsl:with-param name="value"></xsl:with-param>
          <xsl:with-param name="length">&size_type;</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      &nl;
      <xsl:if test="distribution/bucket[1]/@file">
        <xsl:call-template name="rpad">
          <xsl:with-param name="value">Number</xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@block">
        <xsl:call-template name="rpad">
          <xsl:with-param name="value">Number</xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
      </xsl:if>
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">Duration [s]</xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:if test="$totalDistributionElapsed > 0">
        <xsl:call-template name="lpad">
          <xsl:with-param name="value">%</xsl:with-param>
          <xsl:with-param name="length">&size_percent;</xsl:with-param>
        </xsl:call-template>
        &sp;
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@count">
        <xsl:call-template name="lpad">
          <xsl:with-param name="value">Events</xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:if test="$totalDistributionCount>0">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value">%</xsl:with-param>
            <xsl:with-param name="length">&size_percent;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@blocks">
        <xsl:call-template name="lpad">
          <xsl:with-param name="value">Blocks [b]</xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:if test="$totalDistributionBlocks>0">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value">%</xsl:with-param>
            <xsl:with-param name="length">&size_percent;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
      </xsl:if>
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">Event [us]</xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:if test="distribution/bucket[1]/@reason">
        <xsl:call-template name="rpad">
          <xsl:with-param name="value">Class</xsl:with-param>
          <xsl:with-param name="length">&size_type;</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      &nl;
      <xsl:if test="distribution/bucket[1]/@file">
        <xsl:call-template name="line_if"/>
        &sp;
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@block">
        <xsl:call-template name="line_if"/>
        &sp;
      </xsl:if>
      <xsl:call-template name="line_ff"/>
      &sp;
      <xsl:if test="$totalDistributionElapsed > 0">
        <xsl:call-template name="line_percent"/>
        &sp;
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@count">
        <xsl:call-template name="line_if"/>
        &sp;
        <xsl:if test="$totalDistributionCount>0">
          <xsl:call-template name="line_percent"/>
          &sp;
        </xsl:if>
      </xsl:if>
      <xsl:if test="distribution/bucket[1]/@blocks">
        <xsl:call-template name="line_if"/>
        &sp;
        <xsl:if test="$totalDistributionBlocks>0">
          <xsl:call-template name="line_percent"/>
          &sp;
        </xsl:if>
      </xsl:if>
      <xsl:call-template name="line_if"/>
      &sp;
      <xsl:if test="distribution/bucket[1]/@reason">
        <xsl:call-template name="line">
          <xsl:with-param name="length"><xsl:value-of select="string-length(distribution/bucket[1]/@reason)"/></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      &nl;
      <xsl:for-each select="distribution/bucket">
        <xsl:if test="@file">
          <xsl:call-template name="rpad">
            <xsl:with-param name="value"><xsl:value-of select="@file"/></xsl:with-param>
            <xsl:with-param name="length">&size_if;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
        <xsl:if test="@block">
          <xsl:call-template name="rpad">
            <xsl:with-param name="value"><xsl:value-of select="format-number(@block,&if;)"/></xsl:with-param>
            <xsl:with-param name="length">&size_if;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></xsl:with-param>
          <xsl:with-param name="length">&size_ff;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:if test="$totalDistributionElapsed > 0">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div $totalDistributionElapsed * 100,&ff;)"/></xsl:with-param>
            <xsl:with-param name="length">&size_percent;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
        <xsl:if test="@count">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value"><xsl:value-of select="format-number(@count,&if;)"/></xsl:with-param>
            <xsl:with-param name="length">&size_if;</xsl:with-param>
          </xsl:call-template>
          &sp;
          <xsl:if test="$totalDistributionCount>0">
            <xsl:call-template name="lpad">
              <xsl:with-param name="value"><xsl:value-of select="format-number(@count div $totalDistributionCount * 100,&ff;)"/></xsl:with-param>
              <xsl:with-param name="length">&size_percent;</xsl:with-param>
            </xsl:call-template>
            &sp;
          </xsl:if>
        </xsl:if>
        <xsl:if test="@blocks">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value"><xsl:value-of select="format-number(@blocks,&if;)"/></xsl:with-param>
            <xsl:with-param name="length">&size_if;</xsl:with-param>
          </xsl:call-template>
          &sp;
          <xsl:if test="$totalDistributionBlocks>0">
            <xsl:call-template name="lpad">
              <xsl:with-param name="value"><xsl:value-of select="format-number(@blocks div $totalDistributionBlocks * 100,&ff;)"/></xsl:with-param>
              <xsl:with-param name="length">&size_percent;</xsl:with-param>
            </xsl:call-template>
            &sp;
          </xsl:if>
        </xsl:if>
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div @count,&if;)"/></xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:if test="@reason">
          <xsl:call-template name="rpad">
            <xsl:with-param name="value"><xsl:value-of select="@reason"/></xsl:with-param>
            <xsl:with-param name="length"><xsl:value-of select="string-length(@reason)"/></xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        &nl;
      </xsl:for-each>
      <xsl:if test="count(distribution/bucket) > 1">
        <xsl:if test="distribution/bucket[1]/@file">
          <xsl:call-template name="line_if"/>
          &sp;
        </xsl:if>
        <xsl:if test="distribution/bucket[1]/@block">
          <xsl:call-template name="line_if"/>
          &sp;
        </xsl:if>
        <xsl:call-template name="line_ff"/>
        &sp;
        <xsl:if test="$totalDistributionElapsed > 0">
          <xsl:call-template name="line_percent"/>
          &sp;
        </xsl:if>
        <xsl:if test="distribution/bucket[1]/@count">
          <xsl:call-template name="line_if"/>
          &sp;
          <xsl:if test="$totalDistributionCount>0">
            <xsl:call-template name="line_percent"/>
            &sp;
          </xsl:if>
        </xsl:if>
        <xsl:if test="distribution/bucket[1]/@blocks">
          <xsl:call-template name="line_if"/>
          &sp;
          <xsl:if test="$totalDistributionBlocks>0">
            <xsl:call-template name="line_percent"/>
            &sp;
          </xsl:if>
        </xsl:if>
        <xsl:call-template name="line_if"/>
        &nl;
        <xsl:if test="distribution/bucket[1]/@file">
          <xsl:call-template name="rpad">
            <xsl:with-param name="value">Total</xsl:with-param>
            <xsl:with-param name="length">&size_if;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
        <xsl:if test="distribution/bucket[1]/@block">
          <xsl:call-template name="rpad">
            <xsl:with-param name="value"></xsl:with-param>
            <xsl:with-param name="length">&size_if;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"><xsl:value-of select="format-number($totalDistributionElapsed div 1000000,&ff;)"/></xsl:with-param>
          <xsl:with-param name="length">&size_ff;</xsl:with-param>
        </xsl:call-template>
        &sp;
        <xsl:if test="$totalDistributionElapsed>0">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value"><xsl:value-of select="format-number(100,&ff;)"/></xsl:with-param>
            <xsl:with-param name="length">&size_percent;</xsl:with-param>
          </xsl:call-template>
          &sp;
        </xsl:if>
        <xsl:if test="distribution/bucket[1]/@count">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value"><xsl:value-of select="format-number($totalDistributionCount,&if;)"/></xsl:with-param>
            <xsl:with-param name="length">&size_if;</xsl:with-param>
          </xsl:call-template>
          &sp;
          <xsl:if test="$totalDistributionCount>0">
            <xsl:call-template name="lpad">
              <xsl:with-param name="value"><xsl:value-of select="format-number(100,&ff;)"/></xsl:with-param>
              <xsl:with-param name="length">&size_percent;</xsl:with-param>
            </xsl:call-template>
            &sp;
          </xsl:if>
        </xsl:if>
        <xsl:if test="distribution/bucket[1]/@blocks">
          <xsl:call-template name="lpad">
            <xsl:with-param name="value"><xsl:value-of select="format-number($totalDistributionBlocks,&if;)"/></xsl:with-param>
            <xsl:with-param name="length">&size_if;</xsl:with-param>
          </xsl:call-template>
          &sp;
          <xsl:if test="$totalDistributionBlocks>0">
            <xsl:call-template name="lpad">
              <xsl:with-param name="value"><xsl:value-of select="format-number(100,&ff;)"/></xsl:with-param>
              <xsl:with-param name="length">&size_percent;</xsl:with-param>
            </xsl:call-template>
            &sp;
          </xsl:if>
        </xsl:if>
        <xsl:call-template name="lpad">
          <xsl:with-param name="value"><xsl:value-of select="format-number($totalDistributionElapsed div $totalDistributionCount,&if;)"/></xsl:with-param>
          <xsl:with-param name="length">&size_if;</xsl:with-param>
        </xsl:call-template>
        &nl;
      </xsl:if>
    </xsl:if>
  </xsl:if>
  <xsl:if test="contributors">
    &nl;
    <xsl:choose>
      <xsl:when test="contributors/@count = 1"> 
        <xsl:text>1 statement contributed to this event.</xsl:text>
        &nl;
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="contributors/@count"/>
        &sp;
        <xsl:text>statements contributed to this event.</xsl:text>
        &nl;
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="contributors/@count > contributors/@limit">
      <xsl:text>In the following table, only the top </xsl:text><xsl:value-of select="contributors/@limit"/>
      &sp;
      <xsl:text>contributors are reported.</xsl:text>
      &nl;
    </xsl:if>
    &nl;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_type;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Total</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value"></xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &nl;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Statement ID</xsl:with-param>
      <xsl:with-param name="length">&size_if;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="rpad">
      <xsl:with-param name="value">Type</xsl:with-param>
      <xsl:with-param name="length">&size_type;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Duration [s]</xsl:with-param>
      <xsl:with-param name="length">&size_ff;</xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">%</xsl:with-param>
      <xsl:with-param name="length">&size_percent;</xsl:with-param>
    </xsl:call-template>
    &nl;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_type"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_percent"/>
    &nl;
    <xsl:for-each select="contributors/cursor">
      <xsl:call-template name="rpad">
        <xsl:with-param name="value">#<xsl:value-of select="@id"/></xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="rpad">
        <xsl:with-param name="value"><xsl:call-template name="cursortype"/></xsl:with-param>
        <xsl:with-param name="length">&size_type;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="$totalElapsed > 0">
              <xsl:value-of select="format-number(@elapsed div $totalElapsed * 100,&ff;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_percent;</xsl:with-param>
      </xsl:call-template>
      &nl;
    </xsl:for-each>
    <xsl:if test="count(contributors/cursor) > 1">
      <xsl:call-template name="line_if"/>
      &sp;
      <xsl:call-template name="line_type"/>
      &sp;
      <xsl:call-template name="line_ff"/>
      &sp;
      <xsl:call-template name="line_percent"/>
      &nl;
      <xsl:call-template name="rpad">
        <xsl:with-param name="value">Total</xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="rpad">
        <xsl:with-param name="value"></xsl:with-param>
        <xsl:with-param name="length">&size_type;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number($sumElapsed div 1000000,&ff;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_ff;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:call-template name="lpad">
        <xsl:with-param name="value">
          <xsl:choose>
            <xsl:when test="$totalElapsed > 0">  
              <xsl:value-of select="format-number($sumElapsed div $totalElapsed * 100,&ff;)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>n/a</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="length">&size_percent;</xsl:with-param>
      </xsl:call-template>
      &nl;
    </xsl:if>
  </xsl:if>
</xsl:template>
 
<xsl:template name="cursor_detail">
  <xsl:if test="container_id">
    <xsl:text>Container ID           </xsl:text><xsl:value-of select="container_id"/>
    &nl;
  </xsl:if>
  <xsl:if test="session_id">
    <xsl:text>Session ID           </xsl:text><xsl:value-of select="session_id"/>
    &nl;
  </xsl:if>
  <xsl:if test="client_id">
    <xsl:text>Client ID            </xsl:text><xsl:value-of select="client_id"/>
    &nl;
  </xsl:if>
  <xsl:if test="client_driver">
    <xsl:text>Client Driver        </xsl:text><xsl:value-of select="client_driver"/>
    &nl;
  </xsl:if>
  <xsl:if test="service_name">
    <xsl:text>Service Name         </xsl:text><xsl:value-of select="service_name"/>
    &nl;
  </xsl:if>
  <xsl:if test="module_name">
    <xsl:text>Module Name          </xsl:text><xsl:value-of select="module_name"/>
    &nl;
  </xsl:if>
  <xsl:if test="action_name">
    <xsl:text>Action Name          </xsl:text><xsl:value-of select="action_name"/>
    &nl;
  </xsl:if>
  <xsl:if test="@uid">
    <xsl:text>Parsing User         </xsl:text><xsl:value-of select="@uid"/>
    &nl;
  </xsl:if>
  <xsl:if test="@depth!=0">
    <xsl:text>Recursive Level      </xsl:text><xsl:value-of select="@depth"/>
    &nl;
  </xsl:if>
  <xsl:if test="@depth!=0">
    <xsl:text>Parent Statement ID  </xsl:text><xsl:value-of select="@parent"/>
    &nl;
  </xsl:if>
  <xsl:if test="@hash_value">
    <xsl:text>Hash Value           </xsl:text><xsl:value-of select="@hash_value"/>
    &nl;
  </xsl:if>
  <xsl:if test="@sql_id">
    <xsl:text>SQL ID               </xsl:text><xsl:value-of select="@sql_id"/>
    &nl;
  </xsl:if>
  <xsl:if test="errors">
    <xsl:text>Errors               </xsl:text>
      <xsl:for-each select="errors/error">
        <xsl:text>ORA-</xsl:text><xsl:value-of select="format-number(.,'00000')"/>
      </xsl:for-each>
    &nl;
  </xsl:if>
  &nl;
  <xsl:for-each select="sql/line">
    <xsl:value-of select="."/>
    &nl;
  </xsl:for-each>
  <xsl:apply-templates select="binds"/>
  <xsl:apply-templates select="execution_plans"/>
  <xsl:apply-templates select="cumulated_statistics"/>
  <xsl:apply-templates select="current_statistics"/>
  <xsl:apply-templates select="profile"/>
</xsl:template>

<xsl:template match="cumulated_statistics">
  <xsl:choose>
    <xsl:when test="../current_statistics">
      &nl;
      <xsl:text>Database Call Statistics with Recursive Statements</xsl:text>
      &nl;
      <xsl:text>**************************************************</xsl:text>
      &nl;
    </xsl:when>
    <xsl:otherwise>
      &nl;
      <xsl:text>Database Call Statistics</xsl:text>
      &nl;
      <xsl:text>************************</xsl:text>
      &nl;
    </xsl:otherwise>
  </xsl:choose>
  &nl;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">Call</xsl:with-param>
    <xsl:with-param name="length">&size_call;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Count</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Misses</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">CPU [s]</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Elapsed [s]</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">PIO [b]</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">LIO [b]</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Consistent [b]</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Current [b]</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Rows</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &nl;
  <xsl:call-template name="line_call"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_ff"/>
  &sp;
  <xsl:call-template name="line_ff"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_ff"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &nl;
  <xsl:apply-templates select="statistic"/>
</xsl:template>

<xsl:template match="current_statistics">
  &nl;
  <xsl:text>Database Call Statistics without Recursive Statements</xsl:text>
  &nl;
  <xsl:text>*****************************************************</xsl:text>
  &nl;  
  &nl;  
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">Call</xsl:with-param>
    <xsl:with-param name="length">&size_call;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Count</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Misses</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">CPU [s]</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Elapsed [s]</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">PIO [b]</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">LIO [b]</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Consistent [b]</xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Current [b]</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value">Rows</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &nl;
  <xsl:call-template name="line_call"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_ff"/>
  &sp;
  <xsl:call-template name="line_ff"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_ff"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &nl;
  <xsl:apply-templates select="statistic"/>
</xsl:template>

<xsl:template match="statistic[@call='Parse' or @call='Execute' or @call='Fetch' or @call='Total']">
  <xsl:if test="@call='Total'">
    <xsl:call-template name="line_call"/>
    &sp;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_ff"/>
    &sp;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line_if"/>
    &nl;
  </xsl:if>
  <xsl:call-template name="rpad">
    <xsl:with-param name="value"><xsl:value-of select="@call"/></xsl:with-param>
    <xsl:with-param name="length">&size_call;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@count,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@misses,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@cpu div 1000000,&ff;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@pio,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@lio,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@consistent,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@current,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@rows,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &nl;
</xsl:template>

<xsl:template match="statistic[substring(@call,1,7)='Average']">
  <xsl:call-template name="rpad">
    <xsl:with-param name="value"><xsl:value-of select="@call"/></xsl:with-param>
    <xsl:with-param name="length">&size_call;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@count,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@misses,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@cpu div 1000000,&ff;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@elapsed div 1000000,&ff;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@pio,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@lio,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@consistent,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@current,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="lpad">
    <xsl:with-param name="value"><xsl:value-of select="format-number(@rows,&if;)"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &nl;
</xsl:template>

<xsl:template match="execution_plans">
  &nl;
  <xsl:text>Execution Plan</xsl:text>
  <xsl:if test="count(execution_plan) > 1"><xsl:text>s</xsl:text></xsl:if>
  &nl;
  <xsl:text>**************</xsl:text>
  <xsl:if test="count(execution_plan) > 1"><xsl:text>*</xsl:text></xsl:if>
  &nl;
  <xsl:for-each select="execution_plan">
    &nl;
    <xsl:text>Optimizer Mode       </xsl:text><xsl:value-of select="@goal"/>
    &nl;
    <xsl:if test="@hash_value">
      <xsl:text>Hash Value           </xsl:text><xsl:value-of select="@hash_value"/>
      &nl;
    </xsl:if>
    <xsl:if test="count(../execution_plan) > 1">
      <xsl:text>Number of Executions </xsl:text><xsl:value-of select="@executions"/>
      &nl;
    </xsl:if>

    <xsl:if test="@incomplete='true'">
      &nl;
      <xsl:text>WARNING: The following execution plan is incomplete.</xsl:text>
      &nl;
    </xsl:if>
    &nl;
    <xsl:call-template name="lpad">
      <xsl:with-param name="value">Rows</xsl:with-param>
      <xsl:with-param name="length"><xsl:value-of select="string-length(&if;)"/></xsl:with-param>
    </xsl:call-template>
    &sp;
    <xsl:text>Operation</xsl:text>
    &nl;
    <xsl:call-template name="line_if"/>
    &sp;
    <xsl:call-template name="line">
      <xsl:with-param name="length"><xsl:value-of select="99-&size_if;"/></xsl:with-param>
    </xsl:call-template>
    &nl;
    <xsl:for-each select="line">
      <xsl:call-template name="lpad">
        <xsl:with-param name="value"><xsl:value-of select="format-number(@rows,&if;)"/></xsl:with-param>
        <xsl:with-param name="length">&size_if;</xsl:with-param>
      </xsl:call-template>
      &sp;
      <xsl:value-of select="substring('                                                                                          ',1,2*@level)"/>
      <xsl:value-of select="text()"/>
      &nl;
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template match="binds[@count&gt;0]">
  &nl;
  <xsl:text>Bind Variables</xsl:text>
  &nl;
  <xsl:text>**************</xsl:text>
  &nl;
  &nl;
  <xsl:choose>
    <xsl:when test="@count = 1">
      <xsl:text>1 bind variable set was used to execute this statement.</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@count"/>
      <xsl:text> bind variable sets were used to execute this statement.</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  &nl;
  <xsl:if test="@count > @limit">
    <xsl:text>In the following table, only the first </xsl:text><xsl:value-of select="@limit"/>
    <xsl:text> bind variable sets are reported.</xsl:text>
  </xsl:if>
  &nl;
  <xsl:text>Number of</xsl:text>
  &nl;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">Execution</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">Batch</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">Bind</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">Datatype </xsl:with-param>
    <xsl:with-param name="length">&size_datatype;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:text>Value</xsl:text>
  &nl;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_if"/>
  &sp;
  <xsl:call-template name="line_datatype"/>
  &sp;
  <xsl:call-template name="line_data"/>
  &nl;
  <xsl:apply-templates select="bind_batch/bind_set/bind"/>
</xsl:template>

<xsl:template match="bind_batch/bind_set/bind">
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">
    	<xsl:if test="@nr=1 and ../@nr=1">
			<xsl:value-of select="../../@nr"/>
		</xsl:if>
	</xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value">
		<xsl:if test="@nr=1">
			<xsl:value-of select="../@nr"/>
		</xsl:if>
    </xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value"><xsl:value-of select="@nr"/></xsl:with-param>
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:call-template name="rpad">
    <xsl:with-param name="value"><xsl:value-of select="@datatype"/></xsl:with-param>
    <xsl:with-param name="length">&size_datatype;</xsl:with-param>
  </xsl:call-template>
  &sp;
  <xsl:value-of select="text()"/>
  &nl;
</xsl:template>

<!-- small pieces of code reused many times... -->
  
<xsl:template name="cursortype">
  <xsl:value-of select="@type"/>
  <xsl:if test="@uid = 0 and @depth > 0">
    &sp;
    <xsl:text>(SYS recursive)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="lpad">
  <xsl:param name="value"/>
  <xsl:param name="length"/>
  <xsl:value-of select="substring('                                                                                                    ',1,$length - string-length($value))"/>
  <xsl:value-of select="substring($value,1,$length)"/>
</xsl:template>

<xsl:template name="rpad">
  <xsl:param name="value"/>
  <xsl:param name="length"/>
  <xsl:value-of select="substring($value,1,$length)"/>
  <xsl:value-of select="substring('                                                                                                    ',1,$length - string-length($value))"/>
</xsl:template>

<xsl:template name="line">
  <xsl:param name="length"/>
  <xsl:value-of select="substring('----------------------------------------------------------------------------------------------------',1,$length)"/>
</xsl:template>

<xsl:template name="starline">
  <xsl:param name="length"/>
  <xsl:value-of select="substring('****************************************************************************************************',1,$length)"/>
</xsl:template>

<xsl:template name="line_component">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_component;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="line_ff">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_ff;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="line_if">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_if;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="line_percent">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_percent;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="line_range">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_range;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="line_type">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_type;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="line_datatype">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_datatype;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="line_data">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_data;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="line_call">
  <xsl:call-template name="line">
    <xsl:with-param name="length">&size_call;</xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
