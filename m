Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A343E4AC9B8
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 20:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiBGThk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 14:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiBGTgh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 14:36:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8849FC0401E0;
        Mon,  7 Feb 2022 11:36:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C08614C1;
        Mon,  7 Feb 2022 19:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1754BC340EE;
        Mon,  7 Feb 2022 19:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644262595;
        bh=X85IxOM9alAAsRrIinDHcQgMGXL1xHuMRVkHNR1XB5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FeOnvFbTZmncgid/0FHDbyDbdWHmnTq/PTM23fUR91cF+/eNIeh6gSRtARDHjevUe
         W2KUfUSbZJVPxk4GoYW/UkD7kN1b2D6eHyiecKvvKh/AiAQ2QNtnwxIbavn2TV90/l
         x+r05+BeQIv8biOZ/J15ZPFzHCCiQJBr6tXUDHwcOU6xIUAEfYwgssz4fv/5gd69pO
         khlwPMhHmwg9JVNDYG1+t/9I57ATPm8LFzNX/H9zLdBL1WqR+lqVIM+XlRIwKaMpSP
         Cv7G438E6JYBQ+tKOXcsyNGzAxAUbuFzgV7akZvMBCP+F8BlJetGnlUkJtpcxyfqgR
         tGGXLnfBYj5dQ==
Date:   Mon, 7 Feb 2022 12:36:31 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] io_uring: Fix use of uninitialized ret in
 io_eventfd_register()
Message-ID: <YgF0vyDgnsSARZf1@dev-arch.archlinux-ax161>
References: <20220207162410.1013466-1-nathan@kernel.org>
 <CAKwvOdnfQeY8sC0iET4hm-kgeFhurWf_jrh4=czBj17zQ5+x0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnfQeY8sC0iET4hm-kgeFhurWf_jrh4=czBj17zQ5+x0Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 07, 2022 at 11:32:03AM -0800, Nick Desaulniers wrote:
> On Mon, Feb 7, 2022 at 8:24 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Clang warns:
> >
> >   fs/io_uring.c:9396:9: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
> >           return ret;
> >                  ^~~
> >   fs/io_uring.c:9373:13: note: initialize the variable 'ret' to silence this warning
> >           int fd, ret;
> >                      ^
> >                       = 0
> >   1 warning generated.
> >
> > Just return 0 directly and reduce the scope of ret to the if statement,
> > as that is the only place that it is used, which is how the function was
> > before the fixes commit.
> >
> > Fixes: 1a75fac9a0f9 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")
> 
> Did SHA's change? In linux-next, I see:
> commit b77e315a9644 ("io_uring: avoid ring quiesce while
> registering/unregistering eventfd")
> otherwise LGTM

Yes, this is against Jens' latest for-5.18/io_uring branch, which was
rebased after next-20220207 was released.

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.18/io_uring

Cheers,
Nathan

> > Link: https://github.com/ClangBuiltLinux/linux/issues/1579
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  fs/io_uring.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 5479f0607430..7ef04bb66da1 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -9370,7 +9370,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
> >  {
> >         struct io_ev_fd *ev_fd;
> >         __s32 __user *fds = arg;
> > -       int fd, ret;
> > +       int fd;
> >
> >         ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
> >                                         lockdep_is_held(&ctx->uring_lock));
> > @@ -9386,14 +9386,14 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
> >
> >         ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
> >         if (IS_ERR(ev_fd->cq_ev_fd)) {
> > -               ret = PTR_ERR(ev_fd->cq_ev_fd);
> > +               int ret = PTR_ERR(ev_fd->cq_ev_fd);
> >                 kfree(ev_fd);
> >                 return ret;
> >         }
> >         ev_fd->eventfd_async = eventfd_async;
> >
> >         rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
> > -       return ret;
> > +       return 0;
> >  }
> >
> >  static void io_eventfd_put(struct rcu_head *rcu)
> >
> > base-commit: 88a0394bc27de2dd8a8715970f289c5627052532
> > --
> > 2.35.1
> >
> >
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
