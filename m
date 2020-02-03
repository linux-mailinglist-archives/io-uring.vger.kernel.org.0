Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEA51501C8
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2020 07:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgBCGkt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Feb 2020 01:40:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgBCGkt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Feb 2020 01:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+oruxRScDmkGc5AbbIcp+LddBqgaqdady2ZMcAFy+7I=; b=kI5wBMsehb5l7wNQktLEpISuE
        tnFVjk26Bi0+Bjke91WN6eTwkhQ5n4vZlGmgNBm9BQOe2UopVEHNIrBjuphbrfunaURvLD19Skaiy
        cG9sjRpU3fmtdVqYFUh+ovqJzcW9DcBO/vZs7ag/bP55JMgCyHGeZKsJpMTkfSQwDqZnfb5kard59
        Mne7b+GKTI4GJYCRcPRrzoZrFOVn59UhPNVyuCMGQujc0eev373jzclLf1Ea31KOyil3JyluPu1Vl
        atwNNSxz5Vf5KAcyQA6QOZcQDShBWItN7CEmoaT3gPCbqQI6W8xrsVQila8USZd/q5tIwH9S6mdXM
        MYOX+qx8Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyVPb-0006Xo-O5; Mon, 03 Feb 2020 06:40:47 +0000
Date:   Sun, 2 Feb 2020 22:40:47 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Andres Freund <andres@anarazel.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: io_uring force_nonblock vs POSIX_FADV_WILLNEED
Message-ID: <20200203064047.GC8731@bombadil.infradead.org>
References: <20200201094309.6si5dllxo4i25f4u@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201094309.6si5dllxo4i25f4u@alap3.anarazel.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 01, 2020 at 01:43:09AM -0800, Andres Freund wrote:
> As far as I can tell POSIX_FADV_WILLNEED synchronously starts readahead,
> including page allocation etc, which of course might trigger quite
> blocking. The fs also quite possibly needs to read metadata.
> 
> 
> Seems like either WILLNEED would have to always be deferred, or
> force_page_cache_readahead, __do_page_cache_readahead would etc need to
> be wired up to know not to block. Including returning EAGAIN, despite
> force_page_cache_readahead and generic_readahead() intentially ignoring
> return values / errors.

The first step is going to be letting the readahead code know that it
should have this behaviour, which is tricky because the code flow looks
like this:

io_fadvise
  vfs_fadvise
    file->f_op->fadvise()

... and we'd be breaking brand new ground trying to add a gfp_t to a
file_operations method.  Which is not to say it couldn't be done, but
would mean changing filesystems, just so we could pass the gfp
flags through from the top level to the low level.  It wouldn't be
too bad; only two filesystems implement an ->fadvise op today.

Next possibility, we could add a POSIX_FADV_WILLNEED_ASYNC advice flag.
This would be kind of gnarly; look at XFS for example:

        if (advice == POSIX_FADV_WILLNEED) {
                lockflags = XFS_IOLOCK_SHARED;
                xfs_ilock(ip, lockflags);
        }
        ret = generic_fadvise(file, start, end, advice);
        if (lockflags)
                xfs_iunlock(ip, lockflags);

so if there's some other filesystem which decides to start taking a lock
here and we miss it, it'll break when executing async.

Something I already want to see in an entirely different context is
a flag in the task_struct which says, essentially, "don't block in
memory allocations" -- ie behave as if __GFP_NOWAIT | __GFP_NOWARN
is set.  See my proposal here:

https://lore.kernel.org/linux-mm/20200106220910.GK6788@bombadil.infradead.org/
(option 2)
You can see Kirill, Vlastimil and Michal are in favour of adding a
memalloc_nowait_*() API, and it would also save us here from having to
pass this information down the stack to force_page_cache_readahead()
and friends.

I've got my head stuck in the middle of the readahead code right now,
so this seems like a good time to add this functionality.  Once I'm done
with finding out who broke my test VM, I'll take a shot at adding this.
