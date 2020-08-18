Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A29248DB0
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 20:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgHRSHW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 14:07:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46207 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgHRSHV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 14:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597774038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YR0Zm7N8QHDSV7Zh/0RiZwgv3Iauh67M3VGxTrALrZI=;
        b=Bj+TJCddOk4VV6XSruf3RgoXsukp+PxAR3OJUAwapEU3mb70crA5393PUrgQb+1Ypc/EIk
        zuVDYU38YV6RKknRe9UlJCqV0GcoBzca4nEgVvXeXzII1EPNOmD8R2uq2sTbZNK92noRAx
        GqwdfTwnuDuq3wq6dz5vg8ntufGmoco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-zW0Z5d64Pp2hOIgcLkIzdA-1; Tue, 18 Aug 2020 14:07:16 -0400
X-MC-Unique: zW0Z5d64Pp2hOIgcLkIzdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 761D187309E;
        Tue, 18 Aug 2020 18:07:15 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26AAB5D9DC;
        Tue, 18 Aug 2020 18:07:15 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
References: <20200813175605.993571-1-axboe@kernel.dk>
        <x497du2z424.fsf@segfault.boston.devel.redhat.com>
        <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
        <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
        <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
        <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
        <b25ecbbd-bb43-c07d-5b08-4850797378e7@kernel.dk>
        <x49y2mixk42.fsf@segfault.boston.devel.redhat.com>
        <aadb4728-abc5-b070-cd3b-02f480f27d61@kernel.dk>
        <x49sgclf0w8.fsf@segfault.boston.devel.redhat.com>
        <8cc4bc11-eb56-63e1-bb5c-702b75068462@kernel.dk>
        <x49blj7x2hh.fsf@segfault.boston.devel.redhat.com>
        <56f5cc5c-e915-60be-4e25-4a22ec734612@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 18 Aug 2020 14:07:14 -0400
In-Reply-To: <56f5cc5c-e915-60be-4e25-4a22ec734612@kernel.dk> (Jens Axboe's
        message of "Tue, 18 Aug 2020 11:00:53 -0700")
Message-ID: <x497dtvx1yl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>> We must be hitting different problems, then.  I just tested your
>> 5.7-stable branch (running the test suite from an xfs file system on an
>> nvme partition with polling enabled), and the read-write test fails:
>> 
>> Running test read-write:
>> Non-vectored IO not supported, skipping
>> cqe res -22, wanted 2048
>> test_buf_select_short vec failed
>> Test read-write failed with ret 1
>> 
>> That's with this head: a451911d530075352fbc7ef9bb2df68145a747ad
>
> Not sure what this is, haven't seen that here and my regular liburing
> runs include both xfs-on-nvme(with poll queues) as one of the test
> points. Seems to me like there's two oddities in the above:
>
> 1) Saying that Non-vectored isn't supported, that is not true on 5.7.
>    This is due to an -EINVAL return.
> 2) The test_buf_select_short_vec failure
>
> I'll see if I can reproduce this. Anything special otherwise enabled?
> Scheduler on the nvme device? nr_requests? XFS options?

No changes from defaults.

/dev/nvme0n1p1 on /mnt/test type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)

# xfs_info /dev/nvme0n1p1
meta-data=/dev/nvme0n1p1         isize=512    agcount=4, agsize=22893222 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=91572885, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=44713, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# cat /sys/block/nvme0n1/queue/scheduler 
[none] mq-deadline kyber bfq 

# cat /sys/block/nvme0n1/queue/nr_requests 
1023

# cat /sys/module/nvme/parameters/poll_queues 
8

I'll see if I can figure out what's going on.

-Jeff

