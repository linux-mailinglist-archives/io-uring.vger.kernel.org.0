Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0C426C6DB
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 20:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgIPSGD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 14:06:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49026 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727698AbgIPSFv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 14:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600279546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mSX8NWEQwLVtBx+6CA+ZWPEVTtU3nzmZO5InOTBMRDE=;
        b=W6Owlmodh0U3sDTwHJw3CqRxSa8OQBssOKbvaxkZlr5Ft0WqPmuzLmguQJGhoMhVfbO370
        8+aa2dkX9Q4Xf2VzXkdQphdO2+WUZv7GUoruc5AxrgieAGADaKIC7akMWbCIGKbJP0EZ6Z
        az6aCP7kGQ4QA108JZWOb7eW63HxGtA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-IC4D0smMPziuWIqul-yy_A-1; Wed, 16 Sep 2020 14:05:43 -0400
X-MC-Unique: IC4D0smMPziuWIqul-yy_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DA11186DD2F;
        Wed, 16 Sep 2020 18:05:42 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A25CA60CC0;
        Wed, 16 Sep 2020 18:05:41 +0000 (UTC)
Date:   Wed, 16 Sep 2020 14:05:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-xfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: occasional metadata I/O errors (-EOPNOTSUPP) on XFS + io_uring
Message-ID: <20200916180539.GC1681377@bfoster>
References: <20200915113327.GA1554921@bfoster>
 <20200916131957.GB1681377@bfoster>
 <0b6da658-54b1-32ea-b172-981c67aaf29e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b6da658-54b1-32ea-b172-981c67aaf29e@kernel.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 16, 2020 at 10:55:08AM -0600, Jens Axboe wrote:
> On 9/16/20 7:19 AM, Brian Foster wrote:
> > On Tue, Sep 15, 2020 at 07:33:27AM -0400, Brian Foster wrote:
> >> Hi Jens,
> >>
> >> I'm seeing an occasional metadata (read) I/O error (EOPNOTSUPP) when
> >> running Zorro's recent io_uring enabled fsstress on XFS (fsstress -d
> >> <mnt> -n 99999999 -p 8). The storage is a 50GB dm-linear device on a
> >> virtio disk (within a KVM guest). The full callstack of the I/O
> >> submission path is appended below [2], acquired via inserting a
> >> WARN_ON() in my local tree.
> >>
> >> From tracing around a bit, it looks like what happens is that fsstress
> >> calls into io_uring, the latter starts a plug and sets plug.nowait =
> >> true (via io_submit_sqes() -> io_submit_state_start()) and eventually
> >> XFS needs to read an inode cluster buffer in the context of this task.
> >> That buffer read ultimately fails due to submit_bio_checks() setting
> >> REQ_NOWAIT on the bio and the following logic in the same function
> >> causing a BLK_STS_NOTSUPP status:
> >>
> >> 	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
> >> 		goto not_supported;
> >>
> >> In turn, this leads to the following behavior in XFS:
> >>
> >> [ 3839.273519] XFS (dm-2): metadata I/O error in "xfs_imap_to_bp+0x116/0x2c0 [xfs]" at daddr 0x323a5a0 len 32 error 95
> >> [ 3839.303283] XFS (dm-2): log I/O error -95
> >> [ 3839.321437] XFS (dm-2): xfs_do_force_shutdown(0x2) called from line 1196 of file fs/xfs/xfs_log.c. Return address = ffffffffc12dea8a
> >> [ 3839.323554] XFS (dm-2): Log I/O Error Detected. Shutting down filesystem
> >> [ 3839.324773] XFS (dm-2): Please unmount the filesystem and rectify the problem(s)
> >>
> >> I suppose it's possible fsstress is making an invalid request based on
> >> my setup, but I find it a little strange that this state appears to leak
> >> into filesystem I/O requests. What's more concerning is that this also
> >> seems to impact an immediately subsequent log write submission, which is
> >> a fatal error and causes the filesystem to shutdown.
> >>
> >> Finally, note that I've seen your patch associated with Zorro's recent
> >> bug report [1] and that does seem to prevent the problem. I'm still
> >> sending this report because the connection between the plug and that
> >> change is not obvious to me, so I wanted to 1.) confirm this is intended
> >> to fix this problem and 2.) try to understand whether this plugging
> >> behavior introduces any constraints on the fs when invoked in io_uring
> >> context. Thoughts? Thanks.
> >>
> > 
> > To expand on this a bit, I was playing more with the aforementioned fix
> > yesterday while waiting for this email's several hour trip to the
> > mailing list to complete and eventually realized that I don't think the
> > plug.nowait thing properly accommodates XFS' use of multiple devices. A
> > simple example is XFS on a data device with mq support and an external
> > log device without mq support. Presumably io_uring requests could thus
> > enter XFS with plug.nowait set to true, and then any log bio submission
> > that happens to occur in that context is doomed to fail and shutdown the
> > fs.
> 
> Do we ever read from the logdev? It'll only be a concern on the read
> side. And even from there, you'd need nested reads from the log device.
> 

We only read from the log device on log recovery (during filesystem
mount), but I don't follow why that matters since log writes originate
within XFS (not userspace). Do you mean to ask whether we access the log
in the context of userspace reads.. ?

We currently write to the log from various runtime contexts. I don't
_think_ that we currently ever do so during a file read, but log forces
can be async and buried under layers of indirection which makes it
difficult to reason about (and prevent in the future, if necessary). For
example, attempting to lock a stale buffer can issue an async log force.

FWIW and to confirm the above, a simple experiment to issue a log force
in XFS' read_iter() does reproduce the same shutdown condition described
above when XFS is mounted with a mq data device and !mq external log
device. That may or may not be a theoretical condition at the moment,
but it kind of looks like a landmine to me. Perhaps we'll need to come
up with a more explicit way of ensuring we never submit log bios from a
context where we know the block subsystem will swat them away...

> In general, the 'can async' check should be advisory, the -EAGAIN
> or -EOPNOTSUPP should be caught and reissued. The failure path was
> just related to this happening off the retry path on arming for the
> async buffered callback.
> 

I think the issue here is that io_uring is not in the path between XFS
and the log device. Therefore, XFS receives the log I/O error directly
and shuts down. I do think it's fair to argue that io_uring should not
be setting task level context that enforces strict device specific
requirements on I/O submission and then call into subsystems that can
submit I/O to disparate/unrelated devices. That said, I'm not intimately
familiar with the problem this is trying to solve...

Brian

> -- 
> Jens Axboe
> 

