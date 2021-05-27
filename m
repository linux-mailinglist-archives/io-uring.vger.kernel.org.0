Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B692A39386C
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 23:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhE0VxB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 17:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhE0VxB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 17:53:01 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C188C061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 14:51:26 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v13so614833ple.9
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 14:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdh5BfBa7w3UT107nActD7bM2Z4ky8NcdtntK+e++cE=;
        b=TT+Yi1w3VCzF7vPNQw3O8UkVYxLUfyuVXSKNfgomFIQ6G+z3O44+VQ+dI3V+cmpoGp
         RHdgQu1MX4+ek8tjCs3K3Vku3ldrtv8SbadK+m2cg1MBvBK4hLYVWDsd0iYWX4RT1RyQ
         ASDry/rEr4sMXGUi7cinWD6AsQdVeBzv4NBJW4Y0ECI3nqkuNPt1f8Vh+wPRMv81C773
         +kGbSKBWxsAeGsiFt487doe1uECNeGWhBh7DnVBbRr9KdaszYhGqb1UclEcToZcEMRxg
         xnzR8pWyA+JRu7nck3apbgI2Ds7QSIndL74K92PAjwrT2m9ebfKnBAz/XEvJZMnspI13
         Mr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdh5BfBa7w3UT107nActD7bM2Z4ky8NcdtntK+e++cE=;
        b=Nh9y8rHfeiVQFdzUGZHCOI51S4ERGyrAm0FmJV2QiAfzYpqWSDM4i7r7g2w/is7+m/
         Q+tSpK6ZuypEhfplBRYaoAwCy1vBhOLAgq3fZKiuZ0KEiJLbIVIOxPCMqHqezGGuRcH9
         57+eEkDCAzgBBFbqOJiTf/bWFUHeEdn8/jZSMaQ0MhYjoPLtxb3heHoqCHZ2RpcdvOS7
         rsV433p0mfUYr2BqTNdBqOHoyHe01PMge/cB6+h+PBHj2bhFzQo1ybGgufdf6nmlMe3a
         aXX95dw2d7iXtuNMT03zHiJGmb1gr0YiBsNqUsQyvSgMO0muazf0mLGqs/YRbnB0y0Kr
         5ffw==
X-Gm-Message-State: AOAM532NgkPtMQv6s946lgQxpwhaumBpM6/ouh0TwQU30mNqQ9i2X5wY
        Io3GyrexFbKjc8SF8l+xpkQEM0hlZ8Glff3/xhtCV+Z+kzeIdQ==
X-Google-Smtp-Source: ABdhPJyfTvp2xTrTN2Gnp5/ZOHQi0VZuUR1HcjrTK1TsGdtpgVsTjT4IMr+hS7105JpTy4iKxrKqXSDbO2/ZCEc1pKo=
X-Received: by 2002:a17:90a:ab90:: with SMTP id n16mr639064pjq.223.1622152286103;
 Thu, 27 May 2021 14:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1621899872.git.asml.silence@gmail.com> <d124d2af721af9d9d5fa7c187cdee9431b7fe831.1621899872.git.asml.silence@gmail.com>
In-Reply-To: <d124d2af721af9d9d5fa7c187cdee9431b7fe831.1621899872.git.asml.silence@gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Thu, 27 May 2021 17:51:15 -0400
Message-ID: <CAFUsyfJ-1iKiSA31C5cgZ3fDqskVEAdQmzSf8nbcVV1ParPvDA@mail.gmail.com>
Subject: Re: [PATCH 12/13] io_uring: cache task struct refs
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 24, 2021 at 7:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> tctx in submission part is always synchronised because is executed from
> the task's context, so we can batch allocate tctx/task references and
> store them across syscall boundaries. It avoids enough of operations,
> including an atomic for getting task ref and a percpu_counter_add()
> function call, which still fallback to spinlock for large batching
> cases (around >=32). Should be good for SQPOLL submitting in small
> portions and coming at some moment bpf submissions.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 37 ++++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 9 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2b2d70a58a87..a95d55a0f9be 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -110,6 +110,8 @@
>                                 IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
>                                 IOSQE_BUFFER_SELECT)
>
> +#define IO_TCTX_REFS_CACHE_NR  (1U << 10)
> +
>  struct io_uring {
>         u32 head ____cacheline_aligned_in_smp;
>         u32 tail ____cacheline_aligned_in_smp;
> @@ -472,6 +474,7 @@ struct io_ring_ctx {
>
>  struct io_uring_task {
>         /* submission side */
> +       int                     cached_refs;
>         struct xarray           xa;
>         struct wait_queue_head  wait;
>         const struct io_ring_ctx *last;
> @@ -6702,16 +6705,23 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
>
>  static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>  {
> +       struct io_uring_task *tctx;
>         int submitted = 0;
>
>         /* make sure SQ entry isn't read before tail */
>         nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
> -
>         if (!percpu_ref_tryget_many(&ctx->refs, nr))
>                 return -EAGAIN;
>
> -       percpu_counter_add(&current->io_uring->inflight, nr);
> -       refcount_add(nr, &current->usage);
> +       tctx = current->io_uring;
> +       tctx->cached_refs -= nr;
> +       if (unlikely(tctx->cached_refs < 0)) {
> +               unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;

Might be cleared to use:

unsigned int refill =  IO_TCTX_REFS_CACHE_NR - tctx->cached_refs;
> +
> +               percpu_counter_add(&tctx->inflight, refill);
> +               refcount_add(refill, &current->usage);
> +               tctx->cached_refs += refill;
> +       }
>         io_submit_state_start(&ctx->submit_state, nr);
>
>         while (submitted < nr) {
> @@ -6737,12 +6747,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>
>         if (unlikely(submitted != nr)) {
>                 int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
> -               struct io_uring_task *tctx = current->io_uring;
>                 int unused = nr - ref_used;
>
> +               current->io_uring->cached_refs += unused;
>                 percpu_ref_put_many(&ctx->refs, unused);
> -               percpu_counter_sub(&tctx->inflight, unused);
> -               put_task_struct_many(current, unused);
>         }
>
>         io_submit_state_end(&ctx->submit_state, ctx);
> @@ -7924,7 +7932,7 @@ static int io_uring_alloc_task_context(struct task_struct *task,
>         struct io_uring_task *tctx;
>         int ret;
>
> -       tctx = kmalloc(sizeof(*tctx), GFP_KERNEL);
> +       tctx = kzalloc(sizeof(*tctx), GFP_KERNEL);
>         if (unlikely(!tctx))
>                 return -ENOMEM;
>
> @@ -7944,13 +7952,11 @@ static int io_uring_alloc_task_context(struct task_struct *task,
>
>         xa_init(&tctx->xa);
>         init_waitqueue_head(&tctx->wait);
> -       tctx->last = NULL;
>         atomic_set(&tctx->in_idle, 0);
>         atomic_set(&tctx->inflight_tracked, 0);
>         task->io_uring = tctx;
>         spin_lock_init(&tctx->task_lock);
>         INIT_WQ_LIST(&tctx->task_list);
> -       tctx->task_state = 0;
>         init_task_work(&tctx->task_work, tctx_task_work);
>         return 0;
>  }
> @@ -7961,6 +7967,7 @@ void __io_uring_free(struct task_struct *tsk)
>
>         WARN_ON_ONCE(!xa_empty(&tctx->xa));
>         WARN_ON_ONCE(tctx->io_wq);
> +       WARN_ON_ONCE(tctx->cached_refs);
>
>         percpu_counter_destroy(&tctx->inflight);
>         kfree(tctx);
> @@ -9097,6 +9104,16 @@ static void io_uring_try_cancel(bool cancel_all)
>         }
>  }
>
> +static void io_uring_drop_tctx_refs(struct task_struct *task)
> +{
> +       struct io_uring_task *tctx = task->io_uring;
> +       unsigned int refs = tctx->cached_refs;
> +
> +       tctx->cached_refs = 0;
> +       percpu_counter_sub(&tctx->inflight, refs);
> +       put_task_struct_many(task, refs);
> +}
> +
>  /* should only be called by SQPOLL task */
>  static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
>  {
> @@ -9112,6 +9129,7 @@ static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
>
>         WARN_ON_ONCE(!sqd || sqd->thread != current);
>
> +       io_uring_drop_tctx_refs(current);
>         atomic_inc(&tctx->in_idle);
>         do {
>                 /* read completions before cancelations */
> @@ -9149,6 +9167,7 @@ void __io_uring_cancel(struct files_struct *files)
>                 io_wq_exit_start(tctx->io_wq);
>
>         /* make sure overflow events are dropped */
> +       io_uring_drop_tctx_refs(current);
>         atomic_inc(&tctx->in_idle);
>         do {
>                 /* read completions before cancelations */
> --
> 2.31.1
>
