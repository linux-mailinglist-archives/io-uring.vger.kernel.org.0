Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CCE6F11AE
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 08:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345282AbjD1GPT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 02:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345267AbjD1GPS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 02:15:18 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9855A26A1;
        Thu, 27 Apr 2023 23:15:16 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 6D067C020; Fri, 28 Apr 2023 08:15:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682662514; bh=ikBpfqtLZlOZlqrpnW+g3/ECohC4OFsmWiP3UX17fOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SWzHULNAlCyT6I13H9PkzLie6yuQ9htgABrLUrs2ZPbRZfpnMxt1U6dgwnYzjloGc
         KudeX/xGxKoxKC+KgtWZJsB47Af+IZAGnOI9Hv4xQTB9w0wJqwWuYSupau3CRECZum
         BjyJFD1iFJaS7N5KfziQa5jAgM2bXo7KhIXjWM2flBlUtpOEoaRUYpECuPY2/03CPc
         pOdYTpB0vH8L0oNXdjsvR5m+18pz5c4viraRlvQLf8tsAqgHXM5R/p7DMCBj2KFpiq
         zrMvn9Vi2PeE5E58qgjcWoCaMYu3IML8X8lLYPL84945wIPfmEqGzkzD56/1a6Smu0
         ylYDH9ZXInNSw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 5023CC009;
        Fri, 28 Apr 2023 08:15:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682662513; bh=ikBpfqtLZlOZlqrpnW+g3/ECohC4OFsmWiP3UX17fOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gNcNbpdyo5MMuSbJsZYCiMi/ZhAi9ozP0w+eRZrS1cw6nouk0jEjV/Ki914qsmHMf
         tpVP6hXaqOp86hw+8+hTcBsUQWBRcNgZIkV5EUe53NUcv+S5tdkXzO6CMHcfBwDFYQ
         THc6zV5iAd0vjM3VNYXi8cLERgy3fsmkNucdC98nAHNJLfHX0/ww+IlBmnulydKx9C
         EX9xYuNbcrLH6t9bF/APe0dGKINTR/rwAu0Xti2/R9EXgnltiBqLvpD2z2wOZZKrEX
         j1/O26n9dKVS/G0DOduEgILC6UE3kN0PRC+GyYOVTjNqDjXe24FANSDDO8LoOzCsDd
         5lUl0woSNxGBA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 7422cacd;
        Fri, 28 Apr 2023 06:15:07 +0000 (UTC)
Date:   Fri, 28 Apr 2023 15:14:52 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <ZEtkXJ1vMsFR3tkN@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230428050640.GA1969623@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230428050640.GA1969623@dread.disaster.area>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dave Chinner wrote on Fri, Apr 28, 2023 at 03:06:40PM +1000:
> >  - in my understanding io_uring has its own thread pool, so even if the
> > actual getdents is blocking other IOs can progress (assuming there is
> > less blocked getdents than threads), without having to build one's own
> > extra thread pool next to the uring handling.
> > Looking at io_uring/fs.c the other "metadata related" calls there also
> > use the synchronous APIs (renameat, unlinkat, mkdirat, symlinkat and
> > linkat all do), so I didn't think of that as a problem in itself.
> 
> I think you missed the point. getdents is not an exclusive operation
> - it is run under shared locking unlike all the other direcotry
> modification operations you cite above. They use exclusive locking
> so there's no real benefit by trying to run them non-blocking or
> as an async operation as they are single threaded and will consume
> a single thread context from start to end.
> 
> Further, one of the main reasons they get punted to the per-thread
> pool is so that io_uring can optimise away the lock contention
> caused by running multiple work threads on exclusively locked
> objects; it does this by only running one work item per inode at a
> time.

Ah, I didn't know that -- thank you for this piece of information.

If we're serializing readdirs per inode I agree that this implementation
is subpart for filesystems implementing iterate_shared.

> > > Filesystems like XFS can easily do non-blocking getdents calls - we
> > > just need the NOWAIT plumbing (like we added to the IO path with
> > > IOCB_NOWAIT) to tell the filesystem not to block on locks or IO.
> > > Indeed, filesystems often have async readahead built into their
> > > getdents paths (XFS does), so it seems to me that we really want
> > > non-blocking getdents to allow filesystems to take full advantage of
> > > doing work without blocking and then shuffling the remainder off to
> > > a background thread when it actually needs to wait for IO....
> > 
> > I believe that can be done without any change of this API, so that'll be
> > a very welcome addition when it is ready;
> 
> Again, I think you miss the point.
> 
> Non blocking data IO came before io_uring and we had the
> infrastructure in place before io_uring took advantage of it.
> Application developers asked the fs developers to add support for
> non-blocking direct IO operations and because we pretty much had all
> the infrastructure to support already in place it got done quickly
> via preadv2/pwritev2 via RWF_NOWAIT flags.
> 
> We already pass a struct dir_context to ->iterate_shared(), so we
> have a simple way to add context specific flags down the filesystem
> from iterate_dir(). This is similar to the iocb for file data IO
> that contains the flags field that holds the IOCB_NOWAIT context for
> io_uring based IO. So the infrastructure to plumb it all the way
> down the fs implementation of ->iterate_shared is already there.

Sure, that sounds like a good approach that isn't breaking the API (not
breaking iterate/iterate_shared implementations that don't look at the
flags and allowing the fs that want to look at it to do so)

Adding such a flag and setting it on the uring side without doing
anything else is trivial enough if polling/rescheduling can be sorted
out.

(I guess at this rate the dir_context flag could also be modified by the
FS to signal it just filled in the last entry, for the other part of
this thread asking to know when the directory has been done iterating
without wasting a trivial empty getdents)

> XFS also has async metadata IO capability and we use that for
> readahead in the xfs_readdir() implementation. hence we've got all
> the parts we need to do non-blocking readdir already in place. This
> is very similar to how we already had all the pieces in the IO path
> ready to do non-block IO well before anyone asked for IOCB_NOWAIT
> functionality....
> 
> AFAICT, the io_uring code wouldn't need to do much more other than
> punt to the work queue if it receives a -EAGAIN result. Otherwise
> the what the filesystem returns doesn't need to change, and I don't
> see that we need to change how the filldir callbacks work, either.
> We just keep filling the user buffer until we either run out of
> cached directory data or the user buffer is full.

I agree with the fs side of it, I'd like to confirm what the uring
side needs to do before proceeding -- looking at the read/write path
there seems to be a polling mechanism in place to tell uring when to
look again, and I haven't looked at this part of the code yet to see
what happens if no such polling is in place (does uring just retry
periodically?)

I'll have a look this weekend.

> > I don't think the adding the
> > uring op should wait on this if we can agree a simple wrapper API is
> > good enough (or come up with a better one if someone has a Good Idea)
> 
> It doesn't look at all hard to me. If you add a NOWAIT context flag
> to the dir_context it should be relatively trivial to connect all
> the parts together. If you do all the VFS, io_uring and userspace
> testing infrastructure work, I should be able to sort out the
> changes needed to xfs_readdir() to support nonblocking
> ->iterate_shared() behaviour.

I still think the userspace <-> ring API is unrelated to the nowait side
of it, but as said in the other part of the thread I'll be happy to give
a bit more time if that helps moving forward.

I'll send another reply around the end of the weekend with either v2 of
this patch or a few more comments.


Thanks,
-- 
Dominique Martinet | Asmadeus
