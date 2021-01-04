Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52E82E9B5A
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 17:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbhADQuq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 11:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbhADQuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 11:50:46 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A61C061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 08:50:05 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id y19so65695269lfa.13
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 08:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EMdwByPbIrPUY+4hyrg28Pj34Ne9hWVcb19TmShjpuA=;
        b=vUQ4RTyedl+2HCpvbkv3jA6YZmJFT8hi/fj0zvx/xsI4FbXAhnGm6gD8Beak2qkNp+
         aFxNAWp9BoZIg3fJn/P4/Zbaby6qtR1chhXKVlFjD99t93iZi8qcjlt5QqXM5+yzQdra
         O2OewZNxGM8wtb4AlOp8DhatEHrOTThqYztTmz9hDjOl7WiM4M6FlNSV+naBB+D9NTHy
         XhgoxMLA4OIm9f3N+vJ/ObHmbo5J2fRzvism1/OaZQojEo8xnBhUtLs5wIcjMyIdj0WS
         qA/DkGhKh/SlNnHUGxyFmtT4IQxVMIbWb8zTRBooFVRp6CdoE566X5vs9UwqhAqv9s1I
         +yzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMdwByPbIrPUY+4hyrg28Pj34Ne9hWVcb19TmShjpuA=;
        b=Tfhp9KlsgOQMc8fSTzqGWlP8bR5YiRgrnFoUQ8m8tI5mnc9m5EADotAWNMbhUFtcHa
         HspP7FrOz8ypaoJDo0BhTnd1WF/V26T31LWAzJbKH3rdH41GX5VlXEXWsjrfD1++zFVX
         OUk7F2cGOvD9AY04uJGszyO4AFMof9XA/Bt8qfz9Dp+dlcLbY8/tYZlCvxADah4LBTgI
         AU+rHPr/TbJ25uJpRkq+C5tBV4tbLHSQkszrKX50bnHInQzSr2vOyUaUf4jKtt9gVkvL
         5PRKv90ZFPQGprbcscTFOndZUdSvvNHfss/TQrhCsVSN4AQopMnpvJ7ymChn5ZyXuS2s
         /UZA==
X-Gm-Message-State: AOAM5305VjKgzpYaN3wslDxXQNxT1KRGMGKUtDrM3lLHwh7j3deR5o7M
        L0QN4Dih10GWRX1lktfUqLsXBDH5PQmr6LTEXRzCFQi3
X-Google-Smtp-Source: ABdhPJxho20hj4voOXpoxyBK8oC6pCQ0tHKlJcvBa/rmqQ5tmJT/PHwQULeKP5QudtJJvCXM6nP2NsAy0PCz91XsIbc=
X-Received: by 2002:a2e:9218:: with SMTP id k24mr38108896ljg.41.1609779003950;
 Mon, 04 Jan 2021 08:50:03 -0800 (PST)
MIME-Version: 1.0
References: <20201219191521.82029-1-marcelo827@gmail.com> <20201219191521.82029-2-marcelo827@gmail.com>
 <f06c14be-da77-6946-38ba-2ded59743f98@gmail.com>
In-Reply-To: <f06c14be-da77-6946-38ba-2ded59743f98@gmail.com>
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Date:   Mon, 4 Jan 2021 11:49:52 -0500
Message-ID: <CA+saATWskd9u9iSt6G-FaXmzw=n2osAasxBWGCEup2esbZE1XQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: only increment ->cq_timeouts along with ->cached_cq_tail
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Yeah I agree this one is kindof ugly... I'll try to think of a different way

-Marcelo

On Sat, Jan 2, 2021 at 3:07 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 19/12/2020 19:15, Marcelo Diop-Gonzalez wrote:
> > The quantity ->cached_cq_tail - ->cq_timeouts is used to tell how many
> > non-timeout events have happened, but this subtraction could overflow
> > if ->cq_timeouts is incremented more times than ->cached_cq_tail.
> > It's maybe unlikely, but currently this can happen if a timeout event
> > overflows the cqring, since in that case io_get_cqring() doesn't
> > increment ->cached_cq_tail, but ->cq_timeouts is incremented by the
> > caller. Fix it by incrementing ->cq_timeouts inside io_get_cqring().
> >
> > Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
> > ---
> >  fs/io_uring.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index f3690dfdd564..f394bf358022 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -1582,8 +1582,6 @@ static void io_kill_timeout(struct io_kiocb *req)
> >
> >       ret = hrtimer_try_to_cancel(&io->timer);
> >       if (ret != -1) {
> > -             atomic_set(&req->ctx->cq_timeouts,
> > -                     atomic_read(&req->ctx->cq_timeouts) + 1);
> >               list_del_init(&req->timeout.list);
> >               io_cqring_fill_event(req, 0);
> >               io_put_req_deferred(req, 1);
> > @@ -1664,7 +1662,7 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
> >       return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
> >  }
> >
> > -static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
> > +static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx, u8 opcode)
> >  {
> >       struct io_rings *rings = ctx->rings;
> >       unsigned tail;
> > @@ -1679,6 +1677,10 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
> >               return NULL;
> >
> >       ctx->cached_cq_tail++;
> > +     if (opcode == IORING_OP_TIMEOUT)
> > +             atomic_set(&ctx->cq_timeouts,
> > +                        atomic_read(&ctx->cq_timeouts) + 1);
> > +
>
> Don't think I like it. The function is pretty hot, so wouldn't want that extra
> burden just for timeouts, which should be cold enough especially with the new
> timeout CQ waits. Also passing opcode here is awkward and not very great
> abstraction wise.
>
> >       return &rings->cqes[tail & ctx->cq_mask];
> >  }
> >
> > @@ -1728,7 +1730,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
> >               if (!io_match_task(req, tsk, files))
> >                       continue;
> >
> > -             cqe = io_get_cqring(ctx);
> > +             cqe = io_get_cqring(ctx, req->opcode);
> >               if (!cqe && !force)
> >                       break;
> >
> > @@ -1776,7 +1778,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
> >        * submission (by quite a lot). Increment the overflow count in
> >        * the ring.
> >        */
> > -     cqe = io_get_cqring(ctx);
> > +     cqe = io_get_cqring(ctx, req->opcode);
> >       if (likely(cqe)) {
> >               WRITE_ONCE(cqe->user_data, req->user_data);
> >               WRITE_ONCE(cqe->res, res);
> > @@ -5618,8 +5620,6 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
> >
> >       spin_lock_irqsave(&ctx->completion_lock, flags);
> >       list_del_init(&req->timeout.list);
> > -     atomic_set(&req->ctx->cq_timeouts,
> > -             atomic_read(&req->ctx->cq_timeouts) + 1);
> >
> >       io_cqring_fill_event(req, -ETIME);
> >       io_commit_cqring(ctx);
> >
>
> --
> Pavel Begunkov
