Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A22F50AD41
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 03:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348265AbiDVBiQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 21:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344083AbiDVBiP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 21:38:15 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F38547543
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 18:35:24 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id a10so7505640oif.9
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 18:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQCUCDX4xC64zMyc99+FcBV7ZY0Bjs+sh1od4bIPR7o=;
        b=pSmPlQIJ5pISkmDXvqUJa0B0ql8D+1+i2sO+ax4W0N0UK85u9tFkGB/2q04G7b7Fie
         HbU/A6A+lY1/JCOY7JNB2aO2RH5vkBH39QQDHtFZQbT1dmcKQGQ7K0lvNOXDMrYkeOU+
         0XCav++hGuJ/1txY2c7HnkrIoejjuN0qxTQ6MinsSDnc+LWVXYeycJ3P/upgwlhGM+PA
         upxM0kPV1ijqGVhMlKDSXnGw2THJTEIVJLhjKEblR8mGtQ9Bx/FaaWkqw+afEKlj5G1S
         CDBaizDLrY3thFIAVkcsL5PpxqwK5SlLwXNouIys14PVLKKShkD7ZaU2QKnowNGDOLdh
         Q6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQCUCDX4xC64zMyc99+FcBV7ZY0Bjs+sh1od4bIPR7o=;
        b=t2y30YV9XVt7H7FjyntPkyDG00pI9HLVqtCiYN7TQKXxx4Cpw0JvdIT5sqQVS7TNLu
         u8r9aFZknO5F6WaF9B0AnRwOiimfjHtzDdB5PMsXk3bS0QGhjqd6ZS0iaCCjMBOf9G1X
         Y6CfCCE0ReOW0URiCYEfuzbOKZndHvRl43pN6QbyVjdCrlyQ5DTFCxgRMlRGIM1ouLQc
         kviD4+TS6UUOhcRkU5O/xins3qcl926vdKKic8Lx8tu+xXMxDW28Glxi5D938BfMW0VU
         9n4gu7aFB4V43gLIeSx9KcomsxVUmQ0loDfMPyGAXTMisSQZ5fJdZBe65nALTqIwsLO0
         kQ8A==
X-Gm-Message-State: AOAM530v+XYvfRJAChZ9PnksPgIFRdTas0bytkZEpQoMahJ0E8MIw7GR
        nC00vOo1NaM+VZDG6fZcf2Gm4He5MnMOq23FPzU=
X-Google-Smtp-Source: ABdhPJz1vAlr9wTwcFgWnrYN8yfNUdwuHX5MfUUEoHjieSkI2M2PZBBYVcmjWMq1yBsx7E/ya6EZHVi/L7s3F2Gl/YY=
X-Received: by 2002:a05:6808:1929:b0:322:695e:3576 with SMTP id
 bf41-20020a056808192900b00322695e3576mr5263489oib.15.1650591323686; Thu, 21
 Apr 2022 18:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220420191451.2904439-1-shr@fb.com> <20220420191451.2904439-6-shr@fb.com>
In-Reply-To: <20220420191451.2904439-6-shr@fb.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 22 Apr 2022 07:04:57 +0530
Message-ID: <CA+1E3rLpz3FE76++pQK4rhHKN6xdhcF8YoUV_g+75rEwwj4OyA@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] io_uring: add CQE32 completion processing
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

On Thu, Apr 21, 2022 at 10:44 AM Stefan Roesch <shr@fb.com> wrote:
>
> This adds the completion processing for the large CQE's and makes sure
> that the extra1 and extra2 fields are passed through.
>
> Co-developed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 55 +++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 47 insertions(+), 8 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index abbd2efbe255..c93a9353c88d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2247,18 +2247,15 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
>         return __io_fill_cqe(ctx, user_data, res, cflags);
>  }
>
> -static void __io_req_complete_post(struct io_kiocb *req, s32 res,
> -                                  u32 cflags)
> +static void __io_req_complete_put(struct io_kiocb *req)
>  {
> -       struct io_ring_ctx *ctx = req->ctx;
> -
> -       if (!(req->flags & REQ_F_CQE_SKIP))
> -               __io_fill_cqe_req(req, res, cflags);
>         /*
>          * If we're the last reference to this request, add to our locked
>          * free_list cache.
>          */
>         if (req_ref_put_and_test(req)) {
> +               struct io_ring_ctx *ctx = req->ctx;
> +
>                 if (req->flags & IO_REQ_LINK_FLAGS) {
>                         if (req->flags & IO_DISARM_MASK)
>                                 io_disarm_next(req);
> @@ -2281,8 +2278,23 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
>         }
>  }
>
> -static void io_req_complete_post(struct io_kiocb *req, s32 res,
> -                                u32 cflags)
> +static void __io_req_complete_post(struct io_kiocb *req, s32 res,
> +                                  u32 cflags)
> +{
> +       if (!(req->flags & REQ_F_CQE_SKIP))
> +               __io_fill_cqe_req(req, res, cflags);
> +       __io_req_complete_put(req);
> +}
> +
> +static void __io_req_complete_post32(struct io_kiocb *req, s32 res,
> +                                  u32 cflags, u64 extra1, u64 extra2)
> +{
> +       if (!(req->flags & REQ_F_CQE_SKIP))
> +               __io_fill_cqe32_req(req, res, cflags, extra1, extra2);
> +       __io_req_complete_put(req);
> +}
> +
> +static void io_req_complete_post(struct io_kiocb *req, s32 res, u32 cflags)
>  {
>         struct io_ring_ctx *ctx = req->ctx;
>
> @@ -2293,6 +2305,18 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
>         io_cqring_ev_posted(ctx);
>  }
>
> +static void io_req_complete_post32(struct io_kiocb *req, s32 res,
> +                                  u32 cflags, u64 extra1, u64 extra2)
> +{
> +       struct io_ring_ctx *ctx = req->ctx;
> +
> +       spin_lock(&ctx->completion_lock);
> +       __io_req_complete_post32(req, res, cflags, extra1, extra2);
> +       io_commit_cqring(ctx);
> +       spin_unlock(&ctx->completion_lock);
> +       io_cqring_ev_posted(ctx);
> +}
> +
>  static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
>                                          u32 cflags)
>  {
> @@ -2310,6 +2334,21 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
>                 io_req_complete_post(req, res, cflags);
>  }
>
> +static inline void __io_req_complete32(struct io_kiocb *req,
> +                                      unsigned int issue_flags, s32 res,
> +                                      u32 cflags, u64 extra1, u64 extra2)
> +{
> +       if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
> +               req->cqe.res = res;
> +               req->cqe.flags = cflags;
> +               req->extra1 = extra1;
> +               req->extra2 = extra2;
> +               req->flags |= REQ_F_COMPLETE_INLINE;

nit: we can use the existing helper (io_req_complete_state) to
populate these fields rather than open-coding.
