Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ADD6C292D
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 05:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCUEdG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 00:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCUEdF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 00:33:05 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097BC2A15F
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 21:33:04 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso10365486wmb.0
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 21:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679373182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsnCQgs2d86HAuq/igDBGLxA/v837MU0VksrCORJ0Vk=;
        b=hJ2qL5Br96+073y3P/uoEvDrqPgvO8C6NHRRqim0nly2AnFexrbAyfDJHgSkFiMszD
         kShJpactGn1I9BwhTnCAA7p38gwJq7/SfToWQwFuYqOOU72r5VokB/oif7wmxrd1sz9/
         BnnGgClbrDv4Nu3ld0gBrqG9kbwPrpeEg0NIkpgx4+v03w6qZcgsmmSRwhmnyMgsP8b0
         d6/DNAXSCq1XTBDVWbh7RIj5fqs6ZY0BC6dYvmcjfAfdQOIxTEMpeiIJnvLRt3+PoppC
         o7HQJXlqc+raEMOLRL8qtZKTjyyyyQzBs0T12ynyXDOH/qS+kCY8qC2W4hQ2AhT4myI9
         VXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679373182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vsnCQgs2d86HAuq/igDBGLxA/v837MU0VksrCORJ0Vk=;
        b=ZYsGqDCfHncJBpvTTRaynUWoyZCFXXwLqEDjj5h7O+XwGeBZf7+cAY4ut0orTLnpXA
         XfbUl2qU47P6yRb9HkDyoVsYsxnRx9Ymst+vzT+UuPRp4sUJ+2AD9sbmqeZNh2+uDjPX
         ErcEv0fiREWkz0ysaYEIHStChHPrrn1RpI5RgpAGPPkuwtxHY4xnf2omi6WtmzCYI56C
         feyQlyxOLFHHY7LZqNDfXjSyeqX8NqS+e2t9CzUpn8PTQPYP2eytRsLmcXhtR/8RzddI
         Qjo9bKtA1rexsOzH7dambAZQGwU9/42CJKaNKrv3CyU30mJ2S0Q+HWcNxN3tpG6C0BRx
         TtXQ==
X-Gm-Message-State: AO0yUKV7nxW15+CN8wg9W+IQ0Z+g7bo9ph9lcQMMc9WU+L7cqbK45Cg/
        OZjREBYkTTfFvJI4XvRNiLgWE9B8XOUZbpp6SVk=
X-Google-Smtp-Source: AK7set/Wju0XqO7ifhXGZRB2LrnKpHSeYog5dz2RX2KQrE2Bgg9gTCbNJ1xWz/HP1lQ0hKWG/mIJSwbsPR3gsizkFGE=
X-Received: by 2002:a05:600c:3b9d:b0:3eb:3998:8bed with SMTP id
 n29-20020a05600c3b9d00b003eb39988bedmr5225212wms.1.1679373182031; Mon, 20 Mar
 2023 21:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
 <a3c007ee-f324-df9c-56ae-2356f10d76e6@kernel.dk> <b488449b-3acc-35dd-1a44-ef6c8193a08d@kernel.dk>
In-Reply-To: <b488449b-3acc-35dd-1a44-ef6c8193a08d@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 21 Mar 2023 10:02:36 +0530
Message-ID: <CA+1E3r+ANR2dk=KqAOiQ300B+QdfEt2HHCtze1qcz5P60SuSow@mail.gmail.com>
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

On Tue, Mar 21, 2023 at 2:12=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/20/23 2:03?PM, Jens Axboe wrote:
> > On 3/20/23 9:06?AM, Kanchan Joshi wrote:
> >> On Sun, Mar 19, 2023 at 8:51?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> This is similar to what we do on the non-passthrough read/write side,
> >>> and helps take advantage of the completion batching we can do when we
> >>> post CQEs via task_work. On top of that, this avoids a uring_lock
> >>> grab/drop for every completion.
> >>>
> >>> In the normal peak IRQ based testing, this increases performance in
> >>> my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
> >>>
> >>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>
> >>> ---
> >>>
> >>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> >>> index 2e4c483075d3..b4fba5f0ab0d 100644
> >>> --- a/io_uring/uring_cmd.c
> >>> +++ b/io_uring/uring_cmd.c
> >>> @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct =
io_kiocb *req,
> >>>  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssi=
ze_t res2)
> >>>  {
> >>>         struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> >>> +       struct io_ring_ctx *ctx =3D req->ctx;
> >>>
> >>>         if (ret < 0)
> >>>                 req_set_fail(req);
> >>>
> >>>         io_req_set_res(req, ret, 0);
> >>> -       if (req->ctx->flags & IORING_SETUP_CQE32)
> >>> +       if (ctx->flags & IORING_SETUP_CQE32)
> >>>                 io_req_set_cqe32_extra(req, res2, 0);
> >>> -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
> >>> +       if (ctx->flags & IORING_SETUP_IOPOLL) {
> >>>                 /* order with io_iopoll_req_issued() checking ->iopol=
l_complete */
> >>>                 smp_store_release(&req->iopoll_completed, 1);
> >>> -       else
> >>> -               io_req_complete_post(req, 0);
> >>> +               return;
> >>> +       }
> >>> +       req->io_task_work.func =3D io_req_task_complete;
> >>> +       io_req_task_work_add(req);
> >>>  }
> >>
> >> Since io_uring_cmd_done itself would be executing in task-work often
> >> (always in case of nvme), can this be further optimized by doing
> >> directly what this new task-work (that is being set up here) would
> >> have done?
> >> Something like below on top of your patch -
> >>
> >> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> >> index e1929f6e5a24..7a764e04f309 100644
> >> --- a/io_uring/uring_cmd.c
> >> +++ b/io_uring/uring_cmd.c
> >> @@ -58,8 +58,12 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd,
> >> ssize_t ret, ssize_t res2)
> >>                 smp_store_release(&req->iopoll_completed, 1);
> >>                 return;
> >>         }
> >> -       req->io_task_work.func =3D io_req_task_complete;
> >> -       io_req_task_work_add(req);
> >> +       if (in_task()) {
> >> +               io_req_complete_defer(req);
> >> +       } else {
> >> +               req->io_task_work.func =3D io_req_task_complete;
> >> +               io_req_task_work_add(req);
> >> +       }
> >>  }
> >>  EXPORT_SYMBOL_GPL(io_uring_cmd_done);
> >
> > Good point, though I do think we should rework to pass in the flags
> > instead. I'll take a look.
>
> Something like this, totally untested... And this may be more
> interesting than it would appear, because the current:
>
>         io_req_complete_post(req, 0);
>
> in io_uring_cmd_done() is passing in that it has the CQ ring locked, but
> that does not look like it's guaranteed? So this is more of a
> correctness thing first and foremost, more so than an optimization.
>
> Hmm?

When zero is passed to io_req_complete_post, it calls
__io_req_complete_post() which takes CQ lock as the first thing.
So the correct thing will happen. Am I missing something?
