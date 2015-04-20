<sch:pattern name="Audio Stream properties" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:rule context="ffprobe:ffprobe/streams">
        <sch:assert test="boolean(stream[@codec_type = 'audio'])">must have audio stream</sch:assert>
        <sch:assert test="boolean(stream[@codec_name = 'mp2'])">must have mp2 (audio) stream</sch:assert>
    </sch:rule>

    <sch:rule context="ffprobe:ffprobe/streams/stream[@codec_name = 'mp2']">
        <sch:assert test="@codec_type = 'audio'">Stream must be audio</sch:assert>
        <!--<sch:assert test="@channels >= '2'">Channels must be at least 2</sch:assert>-->
        <!--<sch:assert test="@sample_fmt = 's16'">must be 16 bits</sch:assert>-->
        <!--<sch:assert test="@sample_rate >= 48000">Sample rate must be at least 48kHz</sch:assert>-->
    </sch:rule>
</sch:pattern>
