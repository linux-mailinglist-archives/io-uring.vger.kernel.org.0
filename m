Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28425F3B5A
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 04:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJDCVL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 22:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiJDCT7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 22:19:59 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E58C4317A
        for <io-uring@vger.kernel.org>; Mon,  3 Oct 2022 19:17:35 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id x40so3127231ljq.9
        for <io-uring@vger.kernel.org>; Mon, 03 Oct 2022 19:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=INLZOvh7cZ7m2U3UgqNadzmgMrVV210x21bOh76HyzY=;
        b=QkqRAyZmxekbAvdc45WylpxT0IkwmU8c8DQjU1UHP9JQMbcQDKx9JpSxikHB4MFedL
         cjX/CFg7ckWmNyxw/xnlPZ+0MnsqIVNY9vh19hZaoS0ITwQ/MHOzBDRR5p52DH911nJv
         vadd31cYPEqVpnvUcla4u3cNh57l52eS24+7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=INLZOvh7cZ7m2U3UgqNadzmgMrVV210x21bOh76HyzY=;
        b=poaJSWRsA/GmZR7EQ8+L+DgGqIr2vMW0c9ni0rMe0aMRx3IRvPunnrh+/4OPGz486o
         YCmNK8XEHOB3KnMzWJ8G1c3RdfXIV8AmS2jyBwa9mkHpnxLFSH9o7GFcZwjbJeZP3dc5
         4VsysFcp29q9YUPK8mXyY2gQ16fkniKEoCup56cR9wea5b83AL+L1auePQ7LzAUcYQ9j
         mtJvHM6OhzHaNbuLDzU2KiJ+s6EiQtIrUBBX1Qv2nimL1vX5mX8ruK3K+f3G8cJCiGWc
         tJYMJwM9mxP0H0div6g9YMjtVp51vRd97UcCAqMgydIzB9qKG1ABoHysyKE+49Os35i3
         2I+A==
X-Gm-Message-State: ACrzQf2GSVlRoQri5FMe1qwj7iQjqr+hiY7kYoTIRVmO0EATTD+KLJ0F
        hK8dUmO6lgR0DwWDPQECXPLgLfeopke1eoW9XOf/sWBz6GY=
X-Google-Smtp-Source: AMsMyM6q8/rYLtHKfEBT3xNCUlcV8dFdxczByC5L0OgRuI/ty966FbiyQjE3gFQvHRdIrM6UKQ8YDerS22d0cAJrB7I=
X-Received: by 2002:a2e:8756:0:b0:26d:e096:a0d8 with SMTP id
 q22-20020a2e8756000000b0026de096a0d8mr2143937ljj.500.1664849845619; Mon, 03
 Oct 2022 19:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20221003091923.2096150-1-stevensd@google.com> <6932613a-e900-3cd3-cecf-5b982ae84a19@gmail.com>
In-Reply-To: <6932613a-e900-3cd3-cecf-5b982ae84a19@gmail.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Tue, 4 Oct 2022 11:17:14 +0900
Message-ID: <CAD=HUj47N5_zHPr7ObfZSk4wt0BvONNrkRgw3Dx1Or-Odgu-yQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix short read/write with linked ops
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 3, 2022 at 7:40 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 10/3/22 10:19, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> >
> > When continuing a short read/write, account for any completed bytes when
> > calculating the operation's target length. The operation's actual
> > accumulated length is fixed up by kiocb_done, and the target and actual
> > lengths are then compared by __io_complete_rw_common. That function
> > already propagated the actual length to userspace, but the incorrect
> > target length was causing it to always cancel linked operations, even
> > with a successfully completed read/write.
>
> The issue looks same as fixed with
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-6.1/io_uring&id=bf68b5b34311ee57ed40749a1257a30b46127556
>
> Can you check if for-6.1 works for you?
>
> git://git.kernel.dk/linux.git for-6.1/io_uring
> https://git.kernel.dk/cgit/linux-block/log/?h=for-6.1/io_uring

Yes, it looks like that fixes the bug I was running into.

-David

> > Fixes: 227c0c9673d8 ("io_uring: internally retry short reads")
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >   io_uring/rw.c | 12 ++++++++----
> >   1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/io_uring/rw.c b/io_uring/rw.c
> > index 76ebcfebc9a6..aa9967a52dfd 100644
> > --- a/io_uring/rw.c
> > +++ b/io_uring/rw.c
> > @@ -706,13 +706,14 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
> >       struct kiocb *kiocb = &rw->kiocb;
> >       bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> >       struct io_async_rw *io;
> > -     ssize_t ret, ret2;
> > +     ssize_t ret, ret2, target_len;
> >       loff_t *ppos;
> >
> >       if (!req_has_async_data(req)) {
> >               ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
> >               if (unlikely(ret < 0))
> >                       return ret;
> > +             target_len = iov_iter_count(&s->iter);
> >       } else {
> >               io = req->async_data;
> >               s = &io->s;
> > @@ -733,6 +734,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
> >                * need to make this conditional.
> >                */
> >               iov_iter_restore(&s->iter, &s->iter_state);
> > +             target_len = iov_iter_count(&s->iter) + io->bytes_done;
> >               iovec = NULL;
> >       }
> >       ret = io_rw_init_file(req, FMODE_READ);
> > @@ -740,7 +742,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
> >               kfree(iovec);
> >               return ret;
> >       }
> > -     req->cqe.res = iov_iter_count(&s->iter);
> > +     req->cqe.res = target_len;
> >
> >       if (force_nonblock) {
> >               /* If the file doesn't support async, just async punt */
> > @@ -850,18 +852,20 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
> >       struct iovec *iovec;
> >       struct kiocb *kiocb = &rw->kiocb;
> >       bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> > -     ssize_t ret, ret2;
> > +     ssize_t ret, ret2, target_len;
> >       loff_t *ppos;
> >
> >       if (!req_has_async_data(req)) {
> >               ret = io_import_iovec(WRITE, req, &iovec, s, issue_flags);
> >               if (unlikely(ret < 0))
> >                       return ret;
> > +             target_len = iov_iter_count(&s->iter);
> >       } else {
> >               struct io_async_rw *io = req->async_data;
> >
> >               s = &io->s;
> >               iov_iter_restore(&s->iter, &s->iter_state);
> > +             target_len = iov_iter_count(&s->iter) + io->bytes_done;
> >               iovec = NULL;
> >       }
> >       ret = io_rw_init_file(req, FMODE_WRITE);
> > @@ -869,7 +873,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
> >               kfree(iovec);
> >               return ret;
> >       }
> > -     req->cqe.res = iov_iter_count(&s->iter);
> > +     req->cqe.res = target_len;
> >
> >       if (force_nonblock) {
> >               /* If the file doesn't support async, just async punt */
>
> --
> Pavel Begunkov
