Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F06670A6C1
	for <lists+io-uring@lfdr.de>; Sat, 20 May 2023 11:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjETJif (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 May 2023 05:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjETJie (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 May 2023 05:38:34 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8741BD
        for <io-uring@vger.kernel.org>; Sat, 20 May 2023 02:38:33 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-76efc56e1cfso67013739f.1
        for <io-uring@vger.kernel.org>; Sat, 20 May 2023 02:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684575513; x=1687167513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fi+IsU0oxIjmTBTWPbToJHWLkDAUAMQGnjINxQC50E=;
        b=XFb9LHxuugn0Iix6TdZy59lagM6arlPy0iUL5OVKTKvnqEp49fgp8WeYIlUmZYPE5R
         mCQc7/YCD97u0zRqFl+BD3eSLO/lwqwvQ43pOR+Skcw4iAYbvEAzhbSjYE2sOuWdP2tP
         HvFqeuyBUVvwabpYEwBv6WOyNnZe2YZQ4EeTVZ5vXwrTxQ5xspRoQJIy9tITbebvv2SY
         IFanszwJyFduEpoZd0LlYU7ONUxTI7OA7eBDUgeSV7h0o/STpchacQUYIAieypZ7kPdC
         pBA8sml+qfIRGMDPma/J/3UA2/uIKvgUQmsYQ31jTsvoS6dXWoc6YukHuWRtZQemEz28
         imEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684575513; x=1687167513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4fi+IsU0oxIjmTBTWPbToJHWLkDAUAMQGnjINxQC50E=;
        b=JN1RafGtBRQMeMrstOmHvRCPARdAEXOOjpbNkGcFxnHutA12UPqM8zh4s9+PkrqpNy
         dGuFq+t2DolrxR7uJfOfWpjhV4JuRLgpJcOohCMHqe7AoJ563M4CIu+6fWictW623Vdy
         FPsBdeecr7fEt/Nv47KGJc1ATwW/OZFqIC2dQwDHKRAKsjKsD30P3WdtN1xRr0v+5C/v
         evnubaMyWV0HcbOko7EyLEcLhd5SFujZE3z59rrAC3g7Nn0kAJO69d8IEvI9F7jUmdX4
         aYqs4P6wI68/EEyoWDKKJ8tSjieCUtiQ19o/a3jpECloMmmewpxoaz1teg4BxyGIsBPB
         RQlA==
X-Gm-Message-State: AC+VfDwoYbH0BVxYkAPYFffa32ahi2MC8oxAzuHlEhbo8e4iKSp5pz5w
        ynud4u1/F8/wluZUcu0qB3+y1pFZLH3CXPkDB10=
X-Google-Smtp-Source: ACHHUZ5tbbP9ufmZQgFDOwa/K13Pg4BRhLW2m3hy9SYLgEguvWU8GpxmBWPdO/5eaeq/i/APd6q261Dd6ug811sL6ps=
X-Received: by 2002:a5e:8407:0:b0:76c:59c4:64ba with SMTP id
 h7-20020a5e8407000000b0076c59c464bamr3458217ioj.13.1684575512854; Sat, 20 May
 2023 02:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
In-Reply-To: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
From:   yang lan <lanyang0908@gmail.com>
Date:   Sat, 20 May 2023 17:38:20 +0800
Message-ID: <CAAehj2nmnN98ZYzcFMR0DsKXqEM7L8DH8SM4NusPqzoHu_VNPw@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring: more graceful request alloc OOM
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Thanks for your response.

But I applied this patch to LTS kernel 5.10.180, it can still trigger this =
bug.

--- io_uring/io_uring.c.back    2023-05-20 17:11:25.870550438 +0800
+++ io_uring/io_uring.c 2023-05-20 16:35:24.265846283 +0800
@@ -1970,7 +1970,7 @@
static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
        __must_hold(&ctx->uring_lock)
 {
        struct io_submit_state *state =3D &ctx->submit_state;
-       gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN;
+       gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY;
        int ret, i;

        BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);

The io_uring.c.back is the original file.
Do I apply this patch wrong?

Regards,

Yang

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2023=E5=B9=B45=E6=9C=8819=
=E6=97=A5=E5=91=A8=E4=BA=94 22:06=E5=86=99=E9=81=93=EF=BC=9A
>
> It's ok for io_uring request allocation to fail, however there are
> reports that it starts killing tasks instead of just returning back
> to the userspace. Add __GFP_NORETRY, so it doesn't trigger OOM killer.
>
> Cc: stable@vger.kernel.org
> Fixes: 2b188cc1bb857 ("Add io_uring IO interface")
> Reported-by: yang lan <lanyang0908@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index dab09f568294..ad34a4320dab 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1073,7 +1073,7 @@ static void io_flush_cached_locked_reqs(struct io_r=
ing_ctx *ctx,
>  __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
>         __must_hold(&ctx->uring_lock)
>  {
> -       gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN;
> +       gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY;
>         void *reqs[IO_REQ_ALLOC_BATCH];
>         int ret, i;
>
> --
> 2.40.0
>
