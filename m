Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1626C172A
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 16:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjCTPMK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 11:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbjCTPLn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 11:11:43 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E35F10F2
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 08:06:44 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o40-20020a05600c512800b003eddedc47aeso2301046wms.3
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 08:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679324802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73HzY3hsH/YI3qr+IUyO5OS8guFwA/CBRcsz0+L+B3s=;
        b=KuG373zv9Wdhnyysq/eSxStkpp2+aVAtnkXGqwyjBD2AfHh4pRJspqTX1VyOH9Ljuf
         Ho2TglxxuhjHOnIjhPD36JKD/ffAqL8r1KwJ9C634pKLEA4ll6HmVS9XygVks8zGYkSn
         otUqGLAWdwDq/5Lb3tbQZnpkxf9Q/s1mPYsGXknCQ6fi7wLjIDCmPOGUSYErwIa1uw1Y
         DFUq2al3CbNgQV+GVxIrZjmkp5Fwh45ie6U3nb+5+hp8NjfImYqw2SywYIH2xST1t76M
         AF+/sl7oW3E3QNUv8cAxKhxlXmsVr6RlIcuTpCg8daGEW1UkrUaOFBO1UYaJxeeSBBUf
         lI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679324802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73HzY3hsH/YI3qr+IUyO5OS8guFwA/CBRcsz0+L+B3s=;
        b=oCv15hAhcyIq86eeBP65wX8V8B+o18MS2D/QD0owQwdJFCMtTktj3jnEiDpmoZH3Ru
         S2Z/mq4Vxx4c4o2CphAJfCQLBLDIYlybGFb2NdAUrGDmLYQZkjBq+Doq/uiFHk1dKx4L
         CAffk03V8lTF+tSkzzG3EMsXY0TA4ud84+EUMUm5Qw9CgbOZAiENvzMgxyFtX46OZdBm
         sTR4HToFTCMA/ICddfiBZ8tuM1/unbStvFz2q6xyivZvTVv3meYZ5zS1uck5dHh298vO
         6XXB1ubGsu9CRWOQ7lkkctj9G6jsTsmNyEHDVh1JfvXnEgRi83t66wDbiW6ZiGUCgA/i
         yNBw==
X-Gm-Message-State: AO0yUKWiUNLeuEKpaDEV+Z91+1d57izzNbfeXcCAYLCjI/fDTWDlq919
        a9L0yhgress+60adDbD+sner738/Uk0JODuR3wS1wT1FUMA=
X-Google-Smtp-Source: AK7set/fLB7HCrJGd+4WyvKBu8QEWq4GbpVV3yjDtxKK1EtfDx2/0l3L9aUITycNYMEj34MQ4RDZs/Z38NreGCcsYag=
X-Received: by 2002:a05:600c:511b:b0:3ed:241a:bd2d with SMTP id
 o27-20020a05600c511b00b003ed241abd2dmr7457163wms.6.1679324801892; Mon, 20 Mar
 2023 08:06:41 -0700 (PDT)
MIME-Version: 1.0
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
In-Reply-To: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 20 Mar 2023 20:36:15 +0530
Message-ID: <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: push IRQ based completions through task_work
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Mar 19, 2023 at 8:51=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> This is similar to what we do on the non-passthrough read/write side,
> and helps take advantage of the completion batching we can do when we
> post CQEs via task_work. On top of that, this avoids a uring_lock
> grab/drop for every completion.
>
> In the normal peak IRQ based testing, this increases performance in
> my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 2e4c483075d3..b4fba5f0ab0d 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct io_k=
iocb *req,
>  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t=
 res2)
>  {
>         struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> +       struct io_ring_ctx *ctx =3D req->ctx;
>
>         if (ret < 0)
>                 req_set_fail(req);
>
>         io_req_set_res(req, ret, 0);
> -       if (req->ctx->flags & IORING_SETUP_CQE32)
> +       if (ctx->flags & IORING_SETUP_CQE32)
>                 io_req_set_cqe32_extra(req, res2, 0);
> -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
> +       if (ctx->flags & IORING_SETUP_IOPOLL) {
>                 /* order with io_iopoll_req_issued() checking ->iopoll_co=
mplete */
>                 smp_store_release(&req->iopoll_completed, 1);
> -       else
> -               io_req_complete_post(req, 0);
> +               return;
> +       }
> +       req->io_task_work.func =3D io_req_task_complete;
> +       io_req_task_work_add(req);
>  }

Since io_uring_cmd_done itself would be executing in task-work often
(always in case of nvme), can this be further optimized by doing
directly what this new task-work (that is being set up here) would
have done?
Something like below on top of your patch -

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e1929f6e5a24..7a764e04f309 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -58,8 +58,12 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd,
ssize_t ret, ssize_t res2)
                smp_store_release(&req->iopoll_completed, 1);
                return;
        }
-       req->io_task_work.func =3D io_req_task_complete;
-       io_req_task_work_add(req);
+       if (in_task()) {
+               io_req_complete_defer(req);
+       } else {
+               req->io_task_work.func =3D io_req_task_complete;
+               io_req_task_work_add(req);
+       }
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
