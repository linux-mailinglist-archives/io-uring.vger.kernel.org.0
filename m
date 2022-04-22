Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CEF50AD33
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 03:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443049AbiDVB3I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 21:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbiDVB3H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 21:29:07 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FFD4991B
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 18:26:16 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id a10so7488927oif.9
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 18:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e5xjJcY2IvXvl336wRr+GG0dQ4Cu3i4RocXC4IltrlM=;
        b=bh+AdA9s9Z/JTNIn0Ju9Mu849EjjPwkZ8ypjhEwDxL8Gw/SbV1+VrNXWvGlpb/jfvE
         +T5iOr6QTWWJ2UdvpC/M7YQdHWiUudAGl6d3xXWIoSLGrCwwlkJJfA1HmfhMsQMs8LCb
         rlDu87i0tfCtfhqZgbGSL5baOqMlDUQYiMpLCKaa7CefeeJm2eGBJlFb69kIbg4NXjql
         xmbLX2Fh3BYy4pWEeEv9i7Dxa4EvwNnHRGmFsQDJzKP114J3H9RTQHXNPGJCOH5pmZGj
         A0mUrK/cWighxXLeW5aVY3CMT6yVTVrqJC3Lff74BgH7Q3+0S+0PY3l1j/13H6FMlDJ0
         8WKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e5xjJcY2IvXvl336wRr+GG0dQ4Cu3i4RocXC4IltrlM=;
        b=CUi4vhLmxVbsk3vo79sRH5m5CzZ75NIfOHLSM8rESUBKTOIm/6fpI4J4F8Zl+jwkRZ
         WYiL4Vp852dDPBcQLFa4xHjr8+ujHmtuUakIiqmEuUYGKF5vx7OYzyMfXPS43oKeUn+N
         8TrRPV83a4nSjBehl5G9YVqHxcvc824FVshQ4Ng4ZrZ2k5gM80K+xj8elMVzvmP5oBku
         3sqYhBbmzaZjpX6w2aZM1Z7YCav7fS1XkuQgsb5O+lmQ8Jr6/zseqeN6d7V7zJOw8omS
         b0ICyUHDTTANCKOnpsKawQIxiO52ujPh7hpRQS1UTIaWmQFfI0pbExyoguXhXTYP9uzp
         mb6A==
X-Gm-Message-State: AOAM533BTylPmzlnJE7mq2dYzhs19aESsYWcO8mMd9QCRR41nvsac6L5
        52ElH3ZloApKs/Wc8ShEXiBBEEOhB97FBqRIxXTKQeujP5E=
X-Google-Smtp-Source: ABdhPJylscnP0C8gkcXlsd86wzgzjuWBdtaw4B7wSVuPJ15ZDoy43r53vpemJdEBak4mJXSvxhfaTImBlhOFtAEhsVQ=
X-Received: by 2002:a05:6808:f88:b0:323:c50f:8442 with SMTP id
 o8-20020a0568080f8800b00323c50f8442mr506689oiw.160.1650590775767; Thu, 21 Apr
 2022 18:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220420191451.2904439-1-shr@fb.com> <20220420191451.2904439-7-shr@fb.com>
In-Reply-To: <20220420191451.2904439-7-shr@fb.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 22 Apr 2022 06:55:49 +0530
Message-ID: <CA+1E3rKEr4ULc=065kRu_p1265vTE4x+0q+XNa49ie-YRXabdA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] io_uring: modify io_get_cqe for CQE32
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
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

On Thu, Apr 21, 2022 at 3:54 PM Stefan Roesch <shr@fb.com> wrote:
>
> Modify accesses to the CQE array to take large CQE's into account. The
> index needs to be shifted by one for large CQE's.
>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c93a9353c88d..bd352815b9e7 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1909,8 +1909,12 @@ static noinline struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
>  {
>         struct io_rings *rings = ctx->rings;
>         unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
> +       unsigned int shift = 0;
>         unsigned int free, queued, len;
>
> +       if (ctx->flags & IORING_SETUP_CQE32)
> +               shift = 1;
> +
>         /* userspace may cheat modifying the tail, be safe and do min */
>         queued = min(__io_cqring_events(ctx), ctx->cq_entries);
>         free = ctx->cq_entries - queued;
> @@ -1922,12 +1926,13 @@ static noinline struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
>         ctx->cached_cq_tail++;
>         ctx->cqe_cached = &rings->cqes[off];
>         ctx->cqe_sentinel = ctx->cqe_cached + len;
> -       return ctx->cqe_cached++;
> +       ctx->cqe_cached++;
> +       return &rings->cqes[off << shift];
>  }
>
>  static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
>  {
> -       if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
> +       if (likely(ctx->cqe_cached < ctx->cqe_sentinel && !(ctx->flags & IORING_SETUP_CQE32))) {
>                 ctx->cached_cq_tail++;
>                 return ctx->cqe_cached++;
>         }

This excludes CQE-caching for 32b CQEs.
How about something like below to have that enabled (adding
io_get_cqe32 for the new ring) -

+static noinline struct io_uring_cqe *__io_get_cqe32(struct io_ring_ctx *ctx)
+{
+       struct io_rings *rings = ctx->rings;
+       unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
+       unsigned int free, queued, len;
+
+       /* userspace may cheat modifying the tail, be safe and do min */
+       queued = min(__io_cqring_events(ctx), ctx->cq_entries);
+       free = ctx->cq_entries - queued;
+       /* we need a contiguous range, limit based on the current
array offset */
+       len = min(free, ctx->cq_entries - off);
+       if (!len)
+               return NULL;
+
+       ctx->cached_cq_tail++;
+       /* double increment for 32 CQEs */
+       ctx->cqe_cached = &rings->cqes[off << 1];
+       ctx->cqe_sentinel = ctx->cqe_cached + (len << 1);
+       return ctx->cqe_cached;
+}
+
+static inline struct io_uring_cqe *io_get_cqe32(struct io_ring_ctx *ctx)
+{
+       struct io_uring_cqe *cqe32;
+       if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
+               ctx->cached_cq_tail++;
+               cqe32 = ctx->cqe_cached;
+       } else
+               cqe32 = __io_get_cqe32(ctx);
+       /* double increment for 32b CQE*/
+       ctx->cqe_cached += 2;
+       return cqe32;
+}
