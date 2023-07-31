Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BE1768FD5
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 10:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjGaIQD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 04:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjGaIPf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 04:15:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823E32D73;
        Mon, 31 Jul 2023 01:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 150F060C1B;
        Mon, 31 Jul 2023 08:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF04C433C8;
        Mon, 31 Jul 2023 08:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690791207;
        bh=xCGxFchb0YcKG9P013WWnyO24peMwP1ZpfaLDj47lNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uy1BnoIw6+xyiQfBFaPQfxJW5EU1ktGNthPPzn2kluwl6qcy2eMleATifAKm0CVdA
         OMxtOyY31iaYXQ247MkbRw+cwqiJw20u83ExRqY0p4CHgBE8F2HOhgvJY5mSOibIei
         ByvhKRneuMBdb68OxPVzt/Df3M95Oaad+9pYc2KQjY3sChGJgr5B9iHJoNRZ9SA0pE
         pYlOrkdHyYcHe5Vreg9/MzfYy/W9MstvZqEG79NmawgzsTnrKSA8fu9+FKgA34Qk+/
         LBTAELBE8OvLZ5+FVU9yZYS62mYk0FC6ApSwhF6V2dmTmaSGJbZM8nCBfE6M5VNb9y
         6ZcJsUIpEeOkA==
Date:   Mon, 31 Jul 2023 10:13:21 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Hao Xu <hao.xu@linux.dev>, djwong@kernel.org,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZMcPUX0lYC2nscAm@dread.disaster.area>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 31, 2023 at 11:33:05AM +1000, Dave Chinner wrote:
> On Thu, Jul 27, 2023 at 04:27:30PM +0200, Christian Brauner wrote:
> > On Thu, Jul 27, 2023 at 07:51:19PM +0800, Hao Xu wrote:
> > > I actually saw this semaphore, and there is another xfs lock in
> > > file_accessed
> > >   --> touch_atime
> > >     --> inode_update_time
> > >       --> inode->i_op->update_time == xfs_vn_update_time
> > > 
> > > Forgot to point them out in the cover-letter..., I didn't modify them
> > > since I'm not very sure about if we should do so, and I saw Stefan's
> > > patchset didn't modify them too.
> > > 
> > > My personnal thinking is we should apply trylock logic for this
> > > inode->i_rwsem. For xfs lock in touch_atime, we should do that since it
> > > doesn't make sense to rollback all the stuff while we are almost at the
> > > end of getdents because of a lock.
> > 
> > That manoeuvres around the problem. Which I'm slightly more sensitive
> > too as this review is a rather expensive one.
> > 
> > Plus, it seems fixable in at least two ways:
> > 
> > For both we need to be able to tell the filesystem that a nowait atime
> > update is requested. Simple thing seems to me to add a S_NOWAIT flag to
> > file_time_flags and passing that via i_op->update_time() which already
> > has a flag argument. That would likely also help kiocb_modified().
> 
> Wait - didn't we already fix this for mtime updates on IOCB_NOWAIT
> modification operations? Yeah, we did:
> 
> kiocb_modified(iocb)
>   file_modified_flags(iocb->ki_file, iocb->ki_flags)
>     ....
>     ret = inode_needs_update_time()
>     if (ret <= 0)
> 	return ret;
>     if (flags & IOCB_NOWAIT)
> 	return -EAGAIN;
>     <does timestamp update>
> 
> > file_accessed()
> > -> touch_atime()
> >    -> inode_update_time()
> >       -> i_op->update_time == xfs_vn_update_time()
> 
> Yeah, so this needs the same treatment as file_modified_flags() -
> touch_atime() needs a flag variant that passes IOCB_NOWAIT, and
> after atime_needs_update() returns trues we should check IOCB_NOWAIT
> and return EAGAIN if it is set. That will punt the operation that
> needs to the update to a worker thread that can block....

As I tried to explain, I would prefer if we could inform the filesystem
through i_op->update_time() itself that this is async and give the
filesystem the ability to try and acquire the locks it needs and return
EAGAIN from i_op->update_time() itself if it can't acquire them.

> 
> > Then we have two options afaict:
> > 
> > (1) best-effort atime update
> > 
> > file_accessed() already has the builtin assumption that updating atime
> > might fail for other reasons - see the comment in there. So it is
> > somewhat best-effort already.
> > 
> > (2) move atime update before calling into filesystem
> > 
> > If we want to be sure that access time is updated when a readdir request
> > is issued through io_uring then we need to have file_accessed() give a
> > return value and expose a new helper for io_uring or modify
> > vfs_getdents() to do something like:
> > 
> > vfs_getdents()
> > {
> > 	if (nowait)
> > 		down_read_trylock()
> > 
> > 	if (!IS_DEADDIR(inode)) {
> > 		ret = file_accessed(file);
> > 		if (ret == -EAGAIN)
> > 			goto out_unlock;
> > 
> > 		f_op->iterate_shared()
> > 	}
> > }
> 
> Yup, that's the sort of thing that needs to be done.
> 
> But as I said in the "llseek for io-uring" thread, we need to stop
> the game of whack-a-mole passing random nowait boolean flags to VFS
> operations before it starts in earnest.  We really need a common
> context structure (like we have a kiocb for IO operations) that
> holds per operation control state so we have consistency across all
> the operations that we need different behaviours for.

Yes, I tend to agree and thought about the same. But right now we don't
have a lot of context. So I would lean towards a flag argument at most.

But I also wouldn't consider it necessarily wrong to start with booleans
or a flag first and in a couple of months if the need for more context
arises we know what kind of struct we want or need.
