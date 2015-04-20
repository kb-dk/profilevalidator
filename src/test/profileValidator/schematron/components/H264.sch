<sch:pattern name="H264 video Stream properties" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:rule context="ffprobe:ffprobe/streams">
        <sch:assert test="boolean(stream[@codec_type = 'video'])">must have video stream</sch:assert>
    </sch:rule>

    <sch:rule context="ffprobe:ffprobe/streams/stream[@codec_type = 'video']">
        <sch:assert test="@codec_name = 'h264'">Stream must be h264 video</sch:assert>
        <!--<sch:assert test="@pix_fmt = 'yuv420p'">Colordepth yuv420p</sch:assert>-->
        <sch:assert test="@profile = 'Baseline' or @profile = 'Main'">Profile must be Baseline or Main</sch:assert><!--profile test requires ffprobe version at least 4.2-->
        <sch:assert test="@level >= '40'">Level must be at least 4.0</sch:assert>
    </sch:rule>
</sch:pattern>
