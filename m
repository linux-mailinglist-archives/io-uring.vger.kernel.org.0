Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDD476589E
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 18:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjG0Q3C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jul 2023 12:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjG0Q3B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jul 2023 12:29:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C482B2D4F;
        Thu, 27 Jul 2023 09:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C12E61ECF;
        Thu, 27 Jul 2023 16:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D296BC433C8;
        Thu, 27 Jul 2023 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690475338;
        bh=N/kw/2DXB9/bXzp5aKWCWAsGdbo+VLiLXGjcuS/ygIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eSp7qmSQMHV3fG7xMfkeRz6U0hTddDV2Bec8pqMzRP/B2VgpF4NT39d4b+pWy3U1w
         nKTBq9KZdgFlVPKos9yZsyGocKADJCZPmtBbbw8TAN/KcEQobM0DjaTs204lb3Bx29
         TZjPNAMMmY+iNpf452GhgxMd6EPDiFxQFEtjhNjq4EGoUjDfk8pkNG9ZPN3Yz9TR+D
         q46nw1oVZCt1x7wytJJkhsCo5kstZ8PeetIT5v3iUM68e4WPsYdgWPdlz/0FlFzNtf
         kDPpL+SUmO0nsMG6nrS+n3UVlwNkku0BvfdQ9IUhhlMum72F2BZAQPm6S+MmXYfJVi
         9kqGWOvj/y2Nw==
Date:   Thu, 27 Jul 2023 18:28:52 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <hao.xu@linux.dev>, djwong@kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        josef@toxicpanda.com
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <20230727-daran-abtun-4bc755f668ad@brauner>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com>
 <20230727-westen-geldnot-63435c2f65ad@brauner>
 <77feb96e-adf7-56f2-dac5-ca5b075afa83@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <77feb96e-adf7-56f2-dac5-ca5b075afa83@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 27, 2023 at 05:17:30PM +0100, Pavel Begunkov wrote:
> On 7/27/23 16:52, Christian Brauner wrote:
> > On Thu, Jul 27, 2023 at 04:12:12PM +0100, Pavel Begunkov wrote:
> > > On 7/27/23 15:27, Christian Brauner wrote:
> > > > On Thu, Jul 27, 2023 at 07:51:19PM +0800, Hao Xu wrote:
> > > > > On 7/26/23 23:00, Christian Brauner wrote:
> > > > > > On Tue, Jul 18, 2023 at 09:21:10PM +0800, Hao Xu wrote:
> > > > > > > From: Hao Xu <howeyxu@tencent.com>
> > > > > > > 
> > > > > > > This add support for getdents64 to io_uring, acting exactly like the
> > > > > > > syscall: the directory is iterated from it's current's position as
> > > > > > > stored in the file struct, and the file's position is updated exactly as
> > > > > > > if getdents64 had been called.
> > > > > > > 
> > > > > > > For filesystems that support NOWAIT in iterate_shared(), try to use it
> > > > > > > first; if a user already knows the filesystem they use do not support
> > > > > > > nowait they can force async through IOSQE_ASYNC in the sqe flags,
> > > > > > > avoiding the need to bounce back through a useless EAGAIN return.
> > > > > > > 
> > > > > > > Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
> > > > > > > Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> > > > > > > Signed-off-by: Hao Xu <howeyxu@tencent.com>
> > > > > > > ---
> > > [...]
> > > > > I actually saw this semaphore, and there is another xfs lock in
> > > > > file_accessed
> > > > >     --> touch_atime
> > > > >       --> inode_update_time
> > > > >         --> inode->i_op->update_time == xfs_vn_update_time
> > > > > 
> > > > > Forgot to point them out in the cover-letter..., I didn't modify them
> > > > > since I'm not very sure about if we should do so, and I saw Stefan's
> > > > > patchset didn't modify them too.
> > > > > 
> > > > > My personnal thinking is we should apply trylock logic for this
> > > > > inode->i_rwsem. For xfs lock in touch_atime, we should do that since it
> > > > > doesn't make sense to rollback all the stuff while we are almost at the
> > > > > end of getdents because of a lock.
> > > > 
> > > > That manoeuvres around the problem. Which I'm slightly more sensitive
> > > > too as this review is a rather expensive one.
> > > > 
> > > > Plus, it seems fixable in at least two ways:
> > > > 
> > > > For both we need to be able to tell the filesystem that a nowait atime
> > > > update is requested. Simple thing seems to me to add a S_NOWAIT flag to
> > > > file_time_flags and passing that via i_op->update_time() which already
> > > > has a flag argument. That would likely also help kiocb_modified().
> > > 
> > > fwiw, we've just recently had similar problems with io_uring read/write
> > > and atime/mtime in prod environment, so we're interested in solving that
> > > regardless of this patchset. I.e. io_uring issues rw with NOWAIT, {a,m}time
> > > touch ignores that, that stalls other submissions and completely screws
> > > latency.
> > > 
> > > > file_accessed()
> > > > -> touch_atime()
> > > >      -> inode_update_time()
> > > >         -> i_op->update_time == xfs_vn_update_time()
> > > > 
> > > > Then we have two options afaict:
> > > > 
> > > > (1) best-effort atime update
> > > > 
> > > > file_accessed() already has the builtin assumption that updating atime
> > > > might fail for other reasons - see the comment in there. So it is
> > > > somewhat best-effort already.
> > > > 
> > > > (2) move atime update before calling into filesystem
> > > > 
> > > > If we want to be sure that access time is updated when a readdir request
> > > > is issued through io_uring then we need to have file_accessed() give a
> > > > return value and expose a new helper for io_uring or modify
> > > > vfs_getdents() to do something like:
> > > > 
> > > > vfs_getdents()
> > > > {
> > > > 	if (nowait)
> > > > 		down_read_trylock()
> > > > 
> > > > 	if (!IS_DEADDIR(inode)) {
> > > > 		ret = file_accessed(file);
> > > > 		if (ret == -EAGAIN)
> > > > 			goto out_unlock;
> > > > 
> > > > 		f_op->iterate_shared()
> > > > 	}
> > > > }
> > > > 
> > > > It's not unprecedented to do update atime before the actual operation
> > > > has been done afaict. That's already the case in xfs_file_write_checks()
> > > > which is called before anything is written. So that seems ok.
> > > > 
> > > > Does any of these two options work for the xfs maintainers and Jens?
> > > 
> > > It doesn't look (2) will solve it for reads/writes, at least without
> > 
> > It would also solve it for writes which is what my kiocb_modified()
> > comment was about. So right now you have:
> 
> Great, I assumed there are stricter requirements for mtime not
> transiently failing.

But I mean then wouldn't this already be a problem today?
kiocb_modified() can error out with EAGAIN today:

          ret = inode_needs_update_time(inode, &now);
          if (ret <= 0)
                  return ret;
          if (flags & IOCB_NOWAIT)
                  return -EAGAIN;

          return __file_update_time(file, &now, ret);

the thing is that it doesn't matter for ->write_iter() - for xfs at
least - because xfs does it as part of preparatory checks before
actually doing any real work. The problem happens when you do actual
work and afterwards call kiocb_modified(). That's why I think (2) is
preferable.

> 
> 
> > kiocb_modified(IOCB_NOWAI)
> > -> file_modified_flags(IOCB_NOWAI)
> >     -> file_remove_privs(IOCB_NOWAIT) // already fully non-blocking
> >     -> file_accessed(IOCB_NOWAIT)
> >        -> i_op->update_time(S_ATIME | S_NOWAIT)
> > 
> > and since xfs_file_write_iter() calls xfs_file_write_checks() before
> > doing any actual work you'd now be fine.
> > 
> > For reads xfs_file_read_iter() would need to be changed to a similar
> > logic but that's for xfs to decide ultimately.
> > 
> > > the pain of changing the {write,read}_iter callbacks. 1) sounds good
> > > to me from the io_uring perspective, but I guess it won't work
> > > for mtime?
> > 
> > I would prefer 2) which seems cleaner to me. But I might miss why this
> > won't work. So input needed/wanted.
> 
> Maybe I didn't fully grasp the (2) idea
> 
> 2.1: all read_iter, write_iter, etc. callbacks should do file_accessed()
> before doing IO, which sounds like a good option if everyone agrees with
> that. Taking a look at direct block io, it's already like this.

Yes, that's what I'm talking about. I'm asking whether that's ok for xfs
maintainers basically. i_op->write_iter() already works like that since
the dawn of time but i_op->read_iter doesn't and I'm proposing to make
it work like that and wondering if there's any issues I'm unaware of.

> 
> 2.2: Having io_uring doing file_accessed(). Since it's all currently
> hidden behind {read,write}_iter() callbacks and not easily extractable,
> it doesn't like a good option, unless I missed sth.

I think that would be the wrong approach and is definitely not what I
meant.
