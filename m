Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E30850ADA8
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 04:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354300AbiDVCSb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 22:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiDVCSb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 22:18:31 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C0648389
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 19:15:39 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so7251438fac.7
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 19:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LGrONx+wkhrpUlS+rcpq5ILMvZXMXR346aKn7PDj6C8=;
        b=SaewUy8rsb+R6GJ4S4QGBQJvSVsQaqkA1tvgoAg7cKVnSZisc0eySccK/ceS3M3S+7
         yzjrhQfqbE+tHAKqSJuj2vlj9TyVMbHAdg/hnNCUaYWZDapqUtlFl4kFPN8wFjOgDiZ5
         n29/ZVkZPYEsaW5PUD/nSFIYvD7HJKDr3YBBeL4nKXEoRRbNbIhqhCVVJnnOkHDlRUxA
         hwzf0AfdZJezb0IpdmkDL9Ji3X91dsce307HySfCrPGfGdxBvrtZ/XhBUeU2LNQtt4j4
         pfalRV0UI8DOKmK2FkfdFKEb7TO0GY+2sLzbrZ9WtU+QMzFEaBn75JtQsSh82BPaKsLZ
         Mz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LGrONx+wkhrpUlS+rcpq5ILMvZXMXR346aKn7PDj6C8=;
        b=g6ZvGtuz9lr+bV/eNE8yBSL+sU4zfHC0wfg3PXrF7rwa0c0RAT/EdPK0ktD+iesfEH
         xLUnPBID8CCdYnVvcopB8bG34Ru7Rxq4Hat3owVkseNAzy2A6+VjTHQ5r5xhwEE29vw4
         ZqnqNlN5izL9ol9Al66hbyRAWVnIt1aiXtx0yN4SAo+QDtnu+er3pwofr9Kh3GwTpGhg
         PmpRdnPSdP1blMwr2Jy5VbwNzFoAmXxbpgCw8GuGTDdlNoairG8Yvm34UHtuorA2Jjlc
         KofHOfdZ5oUa9mfdjogT1yvYDshM/PlM+T8Sg83hxh+uEEXFMFAdcEnMNeuVBGiTypJA
         ZZhg==
X-Gm-Message-State: AOAM5333XFIxJfHjmz/CWOIkRUYcC1xrccusIp+4BxLrd3H6qBYcjhB4
        DpVb/ovVI9EUQu7nNyKW6CE0dh+6Tq68sC0ve+oFr1Y2
X-Google-Smtp-Source: ABdhPJyQCGq+yPnoDA/axuPW+6lUd39q9sFD0KXu/3XQWoeOY80FHJRXpO6nWXZcMJfVKs+8FfhOHTVw9HsbUNG9CZU=
X-Received: by 2002:a05:6870:6006:b0:e5:e6f1:5f2a with SMTP id
 t6-20020a056870600600b000e5e6f15f2amr1016712oaa.160.1650593738137; Thu, 21
 Apr 2022 19:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220420191451.2904439-1-shr@fb.com> <20220420191451.2904439-9-shr@fb.com>
In-Reply-To: <20220420191451.2904439-9-shr@fb.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 22 Apr 2022 07:45:12 +0530
Message-ID: <CA+1E3rJVJKEjmhLzdKYjKB3UgLs334hWXaDNUN2xp92E+XR=ag@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] io_uring: overflow processing for CQE32
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 21, 2022 at 1:37 PM Stefan Roesch <shr@fb.com> wrote:
>
> This adds the overflow processing for large CQE's.
>
> This adds two parameters to the io_cqring_event_overflow function and
> uses these fields to initialize the large CQE fields.
>
> Allocate enough space for large CQE's in the overflow structue. If no
> large CQE's are used, the size of the allocation is unchanged.
>
> The cqe field can have a different size depending if its a large
> CQE or not. To be able to allocate different sizes, the two fields
> in the structure are re-ordered.
>
> Co-developed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ff6229b6df16..50efced63ec9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -220,8 +220,8 @@ struct io_mapped_ubuf {
>  struct io_ring_ctx;
>
>  struct io_overflow_cqe {
> -       struct io_uring_cqe cqe;
>         struct list_head list;
> +       struct io_uring_cqe cqe;
>  };
>
>  struct io_fixed_file {
> @@ -2016,13 +2016,17 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>         while (!list_empty(&ctx->cq_overflow_list)) {
>                 struct io_uring_cqe *cqe = io_get_cqe(ctx);
>                 struct io_overflow_cqe *ocqe;
> +               size_t cqe_size = sizeof(struct io_uring_cqe);
> +
> +               if (ctx->flags & IORING_SETUP_CQE32)
> +                       cqe_size <<= 1;
>
>                 if (!cqe && !force)
>                         break;
>                 ocqe = list_first_entry(&ctx->cq_overflow_list,
>                                         struct io_overflow_cqe, list);
>                 if (cqe)
> -                       memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
> +                       memcpy(cqe, &ocqe->cqe, cqe_size);
>                 else
>                         io_account_cq_overflow(ctx);
>
> @@ -2111,11 +2115,15 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
>  }
>
>  static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
> -                                    s32 res, u32 cflags)
> +                                    s32 res, u32 cflags, u64 extra1, u64 extra2)
>  {
>         struct io_overflow_cqe *ocqe;
> +       size_t ocq_size = sizeof(struct io_overflow_cqe);
>
> -       ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
> +       if (ctx->flags & IORING_SETUP_CQE32)

This can go inside in a bool variable, as this check is repeated in
this function.
