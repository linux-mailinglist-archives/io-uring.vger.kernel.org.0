Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59714AC9C0
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 20:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiBGTju (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 14:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbiBGTiX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 14:38:23 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B05C0401DA
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 11:38:22 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o12so28893233lfg.12
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 11:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Yt7ZvJovg2QAocXCl+HRPbqydrsknVjCbRsvR6IR8M=;
        b=VTofCTNW2o3FILm4vzr1hNG65FttBoBZjnvu5pXxlclzK91RiQSBG635y0Pn3Oq45F
         nGPdube6VQGmsErLaPoFreoHxF7vhJUnWIbUAEwtOJKQRBZXzgCx0O2pk/KYBLtU0iTn
         s9mZLmKu7ywtHkkW6wd4hp7RVUAvA/OgcjD9217bAxUDODLJs13Yc+q30U0S1djiweSA
         uLkZxK9SK4264vD8Ym5SROaaNI6k/w8w/2J9pP4oLkdZV+3UGVY+OQ7hmolyIS2OsJ/e
         bqHVbPDog4xhtM9y2LUxfTrUplrjkd2/ShZFVygUvE982TUJrsWm0IjQAILjwhrflYWR
         J/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Yt7ZvJovg2QAocXCl+HRPbqydrsknVjCbRsvR6IR8M=;
        b=Vc9zJpjh3fxzR7oVMutYAfdKsnVGWs+8DsaYlgjS3uC1Efm6gyLvBgQK341mVRQI9j
         fKF7kqJfvNYBb2tJfQ5lehM/twQdY79fhQQnDlKkKCOT5qTYNvJ3GS6I5N4NXZap+Ey0
         /OYwpchA6nTNFkm+4q2Dq5ExAKzo4swRoHFuZgw2+T7hzqvx2hUbuVl7EvfLlgDA6iI1
         x9aw6igJ8pkW5URk3Pio3KuRxoftRy2NfcQVTN0572fBVV2PjsyGqGItwqFuxtEyoKwV
         6ZgivP3H478z1KzqKXHduiNfQHAZVJfe0B1AzFHMRwpxlGMDh+0SYc7Y0HQbRQeXVD19
         buAw==
X-Gm-Message-State: AOAM533wi4dygZWhuw/6gWe4EUa0NcPGAQK0nBOxeQS6k3u1qo7ogo/0
        k5lTgw1OdnxLeBCRxx/1PdJncG4coaYEwaIp6EJyDg==
X-Google-Smtp-Source: ABdhPJyx0GeiIkJSO+d8OmtXQTXYOg6hSZ+hEKGf0KkrGZHoaSLZxbl+Eg7pRHp13/NqtBIcN9UJnSX0JLWkrQqOvss=
X-Received: by 2002:ac2:5627:: with SMTP id b7mr688504lff.489.1644262700296;
 Mon, 07 Feb 2022 11:38:20 -0800 (PST)
MIME-Version: 1.0
References: <20220207162410.1013466-1-nathan@kernel.org> <CAKwvOdnfQeY8sC0iET4hm-kgeFhurWf_jrh4=czBj17zQ5+x0Q@mail.gmail.com>
 <YgF0vyDgnsSARZf1@dev-arch.archlinux-ax161>
In-Reply-To: <YgF0vyDgnsSARZf1@dev-arch.archlinux-ax161>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 7 Feb 2022 11:38:08 -0800
Message-ID: <CAKwvOd=428ceq=GmjbkPu0fXx6b-T6J56HTy-DPdKKvaHwuSsA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Fix use of uninitialized ret in io_eventfd_register()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 7, 2022 at 11:36 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Mon, Feb 07, 2022 at 11:32:03AM -0800, Nick Desaulniers wrote:
> > On Mon, Feb 7, 2022 at 8:24 AM Nathan Chancellor <nathan@kernel.org> wrote:
> > >
> > > Clang warns:
> > >
> > >   fs/io_uring.c:9396:9: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
> > >           return ret;
> > >                  ^~~
> > >   fs/io_uring.c:9373:13: note: initialize the variable 'ret' to silence this warning
> > >           int fd, ret;
> > >                      ^
> > >                       = 0
> > >   1 warning generated.
> > >
> > > Just return 0 directly and reduce the scope of ret to the if statement,
> > > as that is the only place that it is used, which is how the function was
> > > before the fixes commit.
> > >
> > > Fixes: 1a75fac9a0f9 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")
> >
> > Did SHA's change? In linux-next, I see:
> > commit b77e315a9644 ("io_uring: avoid ring quiesce while
> > registering/unregistering eventfd")
> > otherwise LGTM
>
> Yes, this is against Jens' latest for-5.18/io_uring branch, which was
> rebased after next-20220207 was released.
>
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.18/io_uring

Thanks for the explanation.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Cheers,
> Nathan
>
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1579
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  fs/io_uring.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > > index 5479f0607430..7ef04bb66da1 100644
> > > --- a/fs/io_uring.c
> > > +++ b/fs/io_uring.c
> > > @@ -9370,7 +9370,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
> > >  {
> > >         struct io_ev_fd *ev_fd;
> > >         __s32 __user *fds = arg;
> > > -       int fd, ret;
> > > +       int fd;
> > >
> > >         ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
> > >                                         lockdep_is_held(&ctx->uring_lock));
> > > @@ -9386,14 +9386,14 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
> > >
> > >         ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
> > >         if (IS_ERR(ev_fd->cq_ev_fd)) {
> > > -               ret = PTR_ERR(ev_fd->cq_ev_fd);
> > > +               int ret = PTR_ERR(ev_fd->cq_ev_fd);
> > >                 kfree(ev_fd);
> > >                 return ret;
> > >         }
> > >         ev_fd->eventfd_async = eventfd_async;
> > >
> > >         rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
> > > -       return ret;
> > > +       return 0;
> > >  }
> > >
> > >  static void io_eventfd_put(struct rcu_head *rcu)
> > >
> > > base-commit: 88a0394bc27de2dd8a8715970f289c5627052532
> > > --
> > > 2.35.1
> > >
> > >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers
>


-- 
Thanks,
~Nick Desaulniers
