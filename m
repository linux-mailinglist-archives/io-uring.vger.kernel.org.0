Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9F7145BC9
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 19:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAVSx6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 13:53:58 -0500
Received: from mail-qt1-f177.google.com ([209.85.160.177]:33457 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVSx6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 13:53:58 -0500
Received: by mail-qt1-f177.google.com with SMTP id d5so436059qto.0
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 10:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=JtTvNccN+0/+lCGUOatY00GbzmTZrZ9tQej/2dZXgxw=;
        b=X05Rcjb9XwjNUo2eOyHgXQGu2QN6NTfiYJc+NCOgf8vCxXoZdy3lbUt5qYLHAEkgEg
         x//I397xeScNLHR6AkVGpL6qSlmZa0vodUk85KF53FjlmPm6gi3eswwIlCJyjAJl+H9J
         UXId3JqsFICh6Qc7QYAzYtWGpEUoHpOds/MTBf02YyGMAHhN0Icq60XP6BzCqYlQKfMl
         NOCsOv2DmN4KrbiTW0BVv6t/s08fLVA5WKVnZWDzvidJTzOOYS6DAks5qiQivJyiL6hS
         Kw01JB1F3v5AKKjdfOH42pjNogytjdxSHo4sq57nHo9KJJM6x76t7nHNLpmHKX85Dvll
         zJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=JtTvNccN+0/+lCGUOatY00GbzmTZrZ9tQej/2dZXgxw=;
        b=mvg64lE7qGBPWrF4Hdr1NTwHSZ6F131JOUf81qZJcmkwVmSV99gpB0WtLtI2cMPpc+
         2Tz+ZIsI6/RoayatuN0UFHVWMtXlexhwjR7Mi+iZYzSFIWptB9trJm7BAYFobmG+NX8D
         BS0DVF6BUyJ9+RiVy5gZLIsfnnbiJAyOTScfPUxkRwr5g70AnTTSLXC5MpSU5eqbXICw
         eapJ2QhPDdyRhH2nSeAtKefCW0U/sQgDMBlTiQkV6CaGI/SFAHaqTICia9VRnDh72Ey5
         XaSy4td5wZTDuizo3HKNrrpLfpUazg0TERQECNfxZ6aUa0CbrgPth8zCId6yz3wK/fPZ
         7PWA==
X-Gm-Message-State: APjAAAWXnKahhwLHqy2tUt5Z50CCZrPZoq7fP/qcZMDy9pUkNsoVOPVw
        nJjOILS4EAo+v9+ymQ8WHqAUGuw8lzwY6Q==
X-Google-Smtp-Source: APXvYqzGacqvQOS2dQ1EM9OvhZpYzGc7VCEfzL9nQZpNUTixJ5DE8BiLE5H/PQQFoeSRtUklT5Q13w==
X-Received: by 2002:ac8:749a:: with SMTP id v26mr12409332qtq.264.1579719237274;
        Wed, 22 Jan 2020 10:53:57 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::7e55])
        by smtp.gmail.com with ESMTPSA id r13sm3958011qtt.70.2020.01.22.10.53.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:53:56 -0800 (PST)
Date:   Wed, 22 Jan 2020 13:53:55 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     io-uring@vger.kernel.org
Subject: REMINDER: LSF/MM/BPF: 2020: Call for Proposals
Message-ID: <20200122185355.vnr3afhyyikjvekl@jbacik-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a reminder that we are still taking requests for this years Linux
Storage, Filesystem, Memory Management, and BPF Summit.  Below is the original
announcement but we would like to hilight a few changes and re-iterate a few
things.

1) The venue has been finalized and as such the website is now live

	https://events.linuxfoundation.org/lsfmm/

2) Please make sure to fill out the google form to make sure we don't miss your
request.

3) PLEASE STILL SUBMIT TOPICS TO THE RELEVANT MAILINGLISTS.  The topics of
interest part of the form is so we can figure out what topics from the
mailinglist are the relevant discussions to have.  If you submit a topic please
feel free to paste a lore link in your form if you've not already filled out the
form.

The rest of the details of course are in the original announcment which is
included below.  Thanks,

Josef

-------------- Original announcement ---------------------
The annual Linux Storage, Filesystem, Memory Management, and BPF
(LSF/MM/BPF) Summit for 2020 will be held from April 27 - April 29 at
The Riviera Palm Springs, A Tribute Portfolio Resort in Palm Springs,
California. LSF/MM/BPF is an invitation-only technical workshop to map
out improvements to the Linux storage, filesystem, BPF, and memory
management subsystems that will make their way into the mainline kernel
within the coming years.

LSF/MM/BPF 2020 will be a three day, stand-alone conference with four
subsystem-specific tracks, cross-track discussions, as well as BoF and
hacking sessions.

On behalf of the committee I am issuing a call for agenda proposals
that are suitable for cross-track discussion as well as technical
subjects for the breakout sessions.

If advance notice is required for visa applications then please point
that out in your proposal or request to attend, and submit the topic
as soon as possible.

This year will be a little different for requesting attendance.  Please
do the following by February 15th, 2020.

1) Fill out the following Google form to request attendance and
suggest any topics

	https://forms.gle/voWi1j9kDs13Lyqf9

In previous years we have accidentally missed people's attendance
requests because they either didn't cc lsf-pc@ or we simply missed them
in the flurry of emails we get.  Our community is large and our
volunteers are busy, filling this out will help us make sure we don't
miss anybody.

2) Proposals for agenda topics should still be sent to the following
lists to allow for discussion among your peers.  This will help us
figure out which topics are important for the agenda.

        lsf-pc@lists.linux-foundation.org

and CC the mailing lists that are relevant for the topic in question:

        FS:     linux-fsdevel@vger.kernel.org
        MM:     linux-mm@kvack.org
        Block:  linux-block@vger.kernel.org
        ATA:    linux-ide@vger.kernel.org
        SCSI:   linux-scsi@vger.kernel.org
        NVMe:   linux-nvme@lists.infradead.org
        BPF:    bpf@vger.kernel.org

Please tag your proposal with [LSF/MM/BPF TOPIC] to make it easier to
track. In addition, please make sure to start a new thread for each
topic rather than following up to an existing one. Agenda topics and
attendees will be selected by the program committee, but the final
agenda will be formed by consensus of the attendees on the day.

We will try to cap attendance at around 25-30 per track to facilitate
discussions although the final numbers will depend on the room sizes
at the venue.

For discussion leaders, slides and visualizations are encouraged to
outline the subject matter and focus the discussions. Please refrain
from lengthy presentations and talks; the sessions are supposed to be
interactive, inclusive discussions.

There will be no recording or audio bridge. However, we expect that
written minutes will be published as we did in previous years:

2019: https://lwn.net/Articles/lsfmm2019/

2018: https://lwn.net/Articles/lsfmm2018/

2017: https://lwn.net/Articles/lsfmm2017/

2016: https://lwn.net/Articles/lsfmm2016/

2015: https://lwn.net/Articles/lsfmm2015/

2014: http://lwn.net/Articles/LSFMM2014/

3) If you have feedback on last year's meeting that we can use to
improve this year's, please also send that to:

        lsf-pc@lists.linux-foundation.org

Thank you on behalf of the program committee:

	Josef Bacik (Filesystems)
	Amir Goldstein (Filesystems)
	Martin K. Petersen (Storage)
	Omar Sandoval (Storage)
	Michal Hocko (MM)
	Dan Williams (MM)
	Alexei Starovoitov (BPF)
	Daniel Borkmann (BPF)
