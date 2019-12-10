Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67929119B4E
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2019 23:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLJWGi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Dec 2019 17:06:38 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40917 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbfLJWFZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Dec 2019 17:05:25 -0500
Received: by mail-ot1-f65.google.com with SMTP id i15so16987987oto.7
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2019 14:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8j1utx508S5/TvNItlGvK7J8skQp+XJtz585eAmQOY=;
        b=oQoy24F4W+3HEnQHY3kqxhyCRrgbihW2p+NtMsvMO+yWUSnGsN7KjaZ/j12OZqylPG
         RDTSD78gK1nTi8JszGUq2QB3PcUE5yKacpkgCSbhkdr+OMP/LIf1oBF3QHqfa5HN5H4X
         V98yTsV/FAVlwMRhY5YVG7FsTnJO9UEbXI3XWtVx7U9BMHQkZMLRKChzan7V91XQWURr
         1aPZgtmtuhs9aHOC66Ef62wcCUDJXaLLJwwWih8PMjugAGqOnJb/X+O0jLbIinIqwhH1
         WsP7k1R2W5hFniX99RJGyvIkpX/mJTbd59jsax0I2eS0lBUOoKtwQPHvuEcRn0H1jt3W
         l3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8j1utx508S5/TvNItlGvK7J8skQp+XJtz585eAmQOY=;
        b=tdGsWmcVYrPhIOJ9sIYrXrjatwpA9eiRhfIdrYFfaBm6cB2tDiX+it8D0PqsNywEoe
         VceVwUeEtlSypPLtI2WHcrKhVqGF+OmUktrEiUtABdUnUz5Noum69b0/JH4Uium0ioDm
         QaqfxiQVtRGI/LZQ0azQFB1b4RlFK9sCs20gdhqXEfO2QvG/u6SdqjdgBXXMJxEedUyM
         gHG1P8Jpgc4/BugeWlikiwqkwc0nCGjot199CxDeQQFLyI7LHUqVKn56FjY3OJAcFAKq
         Zxp4c2Qa7BEskvLhS9feNHEUjncMv+XDHAExIVM7/fV1haozHkUjEkMwhYbVkF9IXCH3
         cJxg==
X-Gm-Message-State: APjAAAWZ1TRrieHwTIILYeo1UgmCPUegQWRQ/D6tl+EUGzyTRYBOXjXo
        zjQLN8yI23GGLGKP+ElgE2s3S71fFVjDg9BYR/Ty5Q==
X-Google-Smtp-Source: APXvYqw9AHcZc7P3F/ugnCZTqo/2VwWhuZ4lejg+yte3f6J4FIMjtd/N6HKWzeO7qr80QJRuV8TXt6qnPUCzanMfF5o=
X-Received: by 2002:a9d:6481:: with SMTP id g1mr29371otl.180.1576015524724;
 Tue, 10 Dec 2019 14:05:24 -0800 (PST)
MIME-Version: 1.0
References: <20191210155742.5844-1-axboe@kernel.dk> <20191210155742.5844-8-axboe@kernel.dk>
In-Reply-To: <20191210155742.5844-8-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 10 Dec 2019 23:04:58 +0100
Message-ID: <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[context preserved for additional CCs]

On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
> Recently had a regression that turned out to be because
> CONFIG_REFCOUNT_FULL was set.

I assume "regression" here refers to a performance regression? Do you
have more concrete numbers on this? Is one of the refcounting calls
particularly problematic compared to the others?

I really don't like it when raw atomic_t is used for refcounting
purposes - not only because that gets rid of the overflow checks, but
also because it is less clear semantically.

> Our ref count usage is really simple,

In my opinion, for a refcount to qualify as "really simple", it must
be possible to annotate each relevant struct member and local variable
with the (fixed) bias it carries when alive and non-NULL. This
refcount is more complicated than that.

> so let's just use atomic_t and get rid of the dependency on the full
> reference count checking being enabled or disabled.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9a596b819334..05419a152b32 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -360,7 +360,7 @@ struct io_kiocb {
>         };
>         struct list_head        link_list;
>         unsigned int            flags;
> -       refcount_t              refs;
> +       atomic_t                refs;
>  #define REQ_F_NOWAIT           1       /* must not punt to workers */
>  #define REQ_F_IOPOLL_COMPLETED 2       /* polled IO has completed */
>  #define REQ_F_FIXED_FILE       4       /* ctx owns file */
> @@ -770,7 +770,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
>                 WRITE_ONCE(ctx->rings->cq_overflow,
>                                 atomic_inc_return(&ctx->cached_cq_overflow));
>         } else {
> -               refcount_inc(&req->refs);
> +               atomic_inc(&req->refs);
>                 req->result = res;
>                 list_add_tail(&req->list, &ctx->cq_overflow_list);
>         }
> @@ -852,7 +852,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
>         req->ctx = ctx;
>         req->flags = 0;
>         /* one is dropped after submission, the other at completion */
> -       refcount_set(&req->refs, 2);
> +       atomic_set(&req->refs, 2);
>         req->result = 0;
>         INIT_IO_WORK(&req->work, io_wq_submit_work);
>         return req;
> @@ -1035,13 +1035,13 @@ static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
>  {
>         io_req_find_next(req, nxtptr);
>
> -       if (refcount_dec_and_test(&req->refs))
> +       if (atomic_dec_and_test(&req->refs))
>                 __io_free_req(req);
>  }
>
>  static void io_put_req(struct io_kiocb *req)
>  {
> -       if (refcount_dec_and_test(&req->refs))
> +       if (atomic_dec_and_test(&req->refs))
>                 io_free_req(req);
>  }
>
> @@ -1052,14 +1052,14 @@ static void io_put_req(struct io_kiocb *req)
>  static void __io_double_put_req(struct io_kiocb *req)
>  {
>         /* drop both submit and complete references */
> -       if (refcount_sub_and_test(2, &req->refs))
> +       if (atomic_sub_and_test(2, &req->refs))
>                 __io_free_req(req);
>  }
>
>  static void io_double_put_req(struct io_kiocb *req)
>  {
>         /* drop both submit and complete references */
> -       if (refcount_sub_and_test(2, &req->refs))
> +       if (atomic_sub_and_test(2, &req->refs))
>                 io_free_req(req);
>  }
>
> @@ -1108,7 +1108,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>                 io_cqring_fill_event(req, req->result);
>                 (*nr_events)++;
>
> -               if (refcount_dec_and_test(&req->refs)) {
> +               if (atomic_dec_and_test(&req->refs)) {
>                         /* If we're not using fixed files, we have to pair the
>                          * completion part with the file put. Use regular
>                          * completions for those, only batch free for fixed
> @@ -3169,7 +3169,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>         if (!list_empty(&req->link_list)) {
>                 prev = list_entry(req->link_list.prev, struct io_kiocb,
>                                   link_list);
> -               if (refcount_inc_not_zero(&prev->refs)) {
> +               if (atomic_inc_not_zero(&prev->refs)) {
>                         list_del_init(&req->link_list);
>                         prev->flags &= ~REQ_F_LINK_TIMEOUT;
>                 } else
> @@ -4237,7 +4237,7 @@ static void io_get_work(struct io_wq_work *work)
>  {
>         struct io_kiocb *req = container_of(work, struct io_kiocb, work);
>
> -       refcount_inc(&req->refs);
> +       atomic_inc(&req->refs);
>  }
>
>  static int io_sq_offload_start(struct io_ring_ctx *ctx,
> @@ -4722,7 +4722,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>                         if (req->work.files != files)
>                                 continue;
>                         /* req is being completed, ignore */
> -                       if (!refcount_inc_not_zero(&req->refs))
> +                       if (!atomic_inc_not_zero(&req->refs))
>                                 continue;
>                         cancel_req = req;
>                         break;
> --
> 2.24.0
>
