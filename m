Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF8B6C2937
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 05:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCUEjP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 00:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCUEjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 00:39:14 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151B1A5DE
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 21:39:13 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id ip21-20020a05600ca69500b003ed56690948so8276884wmb.1
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 21:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679373551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttOLOq6iBiVXMcDPBuFl8jkvgCzXDgUUCllOQHMyGs8=;
        b=KJKr7mgtZHuyeEhHkxiFJTpIkPV+Z8qGnSJFRJTkL3gxja+bDmU/+LFNPnQ/XSbzW4
         U9D2uH81KIEjGhVIxfrqZnHaxGd/C/k5XfPwumzrD5z7wg7CoAkKmRRHGxIpLoFbbe3f
         lBOKkSPMQsvSNwSq0CdFmvbZ2CzQhgmYJzwqWThOFfLZ/rsmVHyAAqqDvxbYV9/WDqsS
         rTJH3S18Ho1W51iw3S1q8gu5p6PLN6QIhK2TT6BEG+ye76a4UJJB7CXPe/kXGwOjzui0
         hCqMhuzcjmTnBSA1F5lAaFM4F8IQWtVmJMTXP+IrkUbGjNmiHVnwiWmmzG+YXQU+XsDg
         lMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679373551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttOLOq6iBiVXMcDPBuFl8jkvgCzXDgUUCllOQHMyGs8=;
        b=hXO5yfuxFYI4G77ik0TN93OFnZx2JfcGtWSMy9rX5EGIyBVB9ndt79m4NQ01coQ4Ya
         PXEH4UVLmwI5HG9Nhte3ihpLO7zuhiojsGdCy4DIVu2g3ZcLeTsQ2Xh0mdbSMNdgY9uN
         bnA/aBuTW10TC6CdRUbVLODQrsysmNvQ/ni5QfdffHHmqGbCZlsnTvsUvBh+m/ZwrYEk
         4gz16ioiHBkENmoYIa7e3t8yzC743yC6DWgTLwvEVrOoy/bo6xFmN+XdtSZJglghwnY5
         6FO0FoOvN2xldcBGw4Hy0EA1fP55mvk/W3E5v96gPbi5VduTXWijIs2PsC+HM1l04GX9
         KtfQ==
X-Gm-Message-State: AO0yUKWdwme4tq8Z6iIASwpv4GXi3NHVqxC/t65sLgw7Epfew7L2NNSs
        Ef/kkkhBvr5u/x0fZRVJqjROslQ8wLbh1eaHCytOAr7U
X-Google-Smtp-Source: AK7set/avynLD5EotJWb4vmW7Qg4zHC4Wq0InSmSd5SS/pnZOXxbjtBrUaWO849TnXYsVpV5baJcBczBmOMZO7E25hU=
X-Received: by 2002:a05:600c:21c7:b0:3ed:39b2:7c3c with SMTP id
 x7-20020a05600c21c700b003ed39b27c3cmr424037wmj.6.1679373551292; Mon, 20 Mar
 2023 21:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
 <a3c007ee-f324-df9c-56ae-2356f10d76e6@kernel.dk> <b488449b-3acc-35dd-1a44-ef6c8193a08d@kernel.dk>
 <CA+1E3r+ANR2dk=KqAOiQ300B+QdfEt2HHCtze1qcz5P60SuSow@mail.gmail.com>
In-Reply-To: <CA+1E3r+ANR2dk=KqAOiQ300B+QdfEt2HHCtze1qcz5P60SuSow@mail.gmail.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 21 Mar 2023 10:08:45 +0530
Message-ID: <CA+1E3rKsrpp80qRuRM1K=cv6vTivhNO8J4bV_hXC96QrsB=dhw@mail.gmail.com>
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

On Tue, Mar 21, 2023 at 10:02=E2=80=AFAM Kanchan Joshi <joshiiitr@gmail.com=
> wrote:
>
> On Tue, Mar 21, 2023 at 2:12=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrot=
e:
> >
> > On 3/20/23 2:03?PM, Jens Axboe wrote:
> > > On 3/20/23 9:06?AM, Kanchan Joshi wrote:
> > >> On Sun, Mar 19, 2023 at 8:51?PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>
> > >>> This is similar to what we do on the non-passthrough read/write sid=
e,
> > >>> and helps take advantage of the completion batching we can do when =
we
> > >>> post CQEs via task_work. On top of that, this avoids a uring_lock
> > >>> grab/drop for every completion.
> > >>>
> > >>> In the normal peak IRQ based testing, this increases performance in
> > >>> my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
> > >>>
> > >>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > >>>
> > >>> ---
> > >>>
> > >>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > >>> index 2e4c483075d3..b4fba5f0ab0d 100644
> > >>> --- a/io_uring/uring_cmd.c
> > >>> +++ b/io_uring/uring_cmd.c
> > >>> @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struc=
t io_kiocb *req,
> > >>>  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, s=
size_t res2)
> > >>>  {
> > >>>         struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> > >>> +       struct io_ring_ctx *ctx =3D req->ctx;
> > >>>
> > >>>         if (ret < 0)
> > >>>                 req_set_fail(req);
> > >>>
> > >>>         io_req_set_res(req, ret, 0);
> > >>> -       if (req->ctx->flags & IORING_SETUP_CQE32)
> > >>> +       if (ctx->flags & IORING_SETUP_CQE32)
> > >>>                 io_req_set_cqe32_extra(req, res2, 0);
> > >>> -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
> > >>> +       if (ctx->flags & IORING_SETUP_IOPOLL) {
> > >>>                 /* order with io_iopoll_req_issued() checking ->iop=
oll_complete */
> > >>>                 smp_store_release(&req->iopoll_completed, 1);
> > >>> -       else
> > >>> -               io_req_complete_post(req, 0);
> > >>> +               return;
> > >>> +       }
> > >>> +       req->io_task_work.func =3D io_req_task_complete;
> > >>> +       io_req_task_work_add(req);
> > >>>  }
> > >>
> > >> Since io_uring_cmd_done itself would be executing in task-work often
> > >> (always in case of nvme), can this be further optimized by doing
> > >> directly what this new task-work (that is being set up here) would
> > >> have done?
> > >> Something like below on top of your patch -
> > >>
> > >> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > >> index e1929f6e5a24..7a764e04f309 100644
> > >> --- a/io_uring/uring_cmd.c
> > >> +++ b/io_uring/uring_cmd.c
> > >> @@ -58,8 +58,12 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucm=
d,
> > >> ssize_t ret, ssize_t res2)
> > >>                 smp_store_release(&req->iopoll_completed, 1);
> > >>                 return;
> > >>         }
> > >> -       req->io_task_work.func =3D io_req_task_complete;
> > >> -       io_req_task_work_add(req);
> > >> +       if (in_task()) {
> > >> +               io_req_complete_defer(req);
> > >> +       } else {
> > >> +               req->io_task_work.func =3D io_req_task_complete;
> > >> +               io_req_task_work_add(req);
> > >> +       }
> > >>  }
> > >>  EXPORT_SYMBOL_GPL(io_uring_cmd_done);
> > >
> > > Good point, though I do think we should rework to pass in the flags
> > > instead. I'll take a look.
> >
> > Something like this, totally untested... And this may be more
> > interesting than it would appear, because the current:
> >
> >         io_req_complete_post(req, 0);
> >
> > in io_uring_cmd_done() is passing in that it has the CQ ring locked, bu=
t
> > that does not look like it's guaranteed? So this is more of a
> > correctness thing first and foremost, more so than an optimization.
> >
> > Hmm?
>
> When zero is passed to io_req_complete_post, it calls
> __io_req_complete_post() which takes CQ lock as the first thing.
> So the correct thing will happen. Am I missing something?

And because this CQ lock was there, optimization is able to improve the num=
bers.
