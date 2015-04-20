<sch:pattern name="Check format name" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:rule context="ffprobe:ffprobe/format">
        <sch:assert test="@format_name = 'mpegts'">The format must be mpeg transport stream</sch:assert>
    </sch:rule>
</sch:pattern>
