Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23AE33FEE8
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 06:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCRFe6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 01:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhCRFeU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 01:34:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7507AC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 22:34:20 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so2427916wmc.0
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 22:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oNLbqwtqC3zQTJ/OunvctMSzZaiWtNoR0TFwEeoJSpo=;
        b=oa9tShNI5vZqssznIckIOzQaPQgzUGStIWx4OShHbI6IBoZWRk6GZXcqztfIhprHPI
         S5INjlDDp95w3XgfMVmeGaxw+B33+Wp3C8WeDRKP7hiJ/9zrnOz6WrqaHZkILC6mtOxF
         ZbON5EAcVbXJVqtfWdUqOl0624Mf4T4VjduIBP9u59fJ6RFfyatsp5xreItpkmoE6kvL
         JS/stEz4rv4h1g8FcwrkPl2rDIpbrie7qORukBGfB29kuCVXqcx+Mv+Ggq4SIB4a3HXG
         MaP4ylkS/IRwmSqpECyScW9mBfEbdzl6frU9p2bZ/kjDO/yo+eOcs80zVnz1Pt8SdyBf
         AQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oNLbqwtqC3zQTJ/OunvctMSzZaiWtNoR0TFwEeoJSpo=;
        b=pdRQu7nekUil9dYyAZj2UoIHk412ZBUJkTcFiJ3Q861y5QHdjkBr8oJsFvVg5CcD7m
         7voYLAZflLxZ2Ouyy92TldJcXGtDo11dYzoKFvDy/KXa/ClfBt9/A22v4Y3Y2HN/AFfo
         7SM0ixmQetvFlyJwaLnDzMnnRtjj6hU/uwMfOzXvKWQV4WD/Vi+sp0Cf4/KgptD5uwk5
         mAj7tsCPFKSQh7IqXH9duiPHqYoFIEATRy623ywxVimC7ftGtPkRlYuqBqXLx7mXWb9Q
         pAOYDOyceQpMbM0EVdmFwQ9J1Ho0zeQ2EuADZap6D67Vydmdrn1EDkB8e4F3jrAITSUU
         RvFw==
X-Gm-Message-State: AOAM533K2aO9aIIx5y3NtCazzlAd6Pvst5LrwXQTUoAZmF/YUvA4PWbz
        JFVV8xQqfrk6aKzNPoQDbXUNp9AkH9DC0yoIWKunKVG49CB4zg==
X-Google-Smtp-Source: ABdhPJxV1V4bXjN4izL69vXbsFRYLHmYRPSUsIuA1v676FfcQY4GFpi/hyQIRFZY3MCrzAdaDtDsCR0Zyu8sNsmejVA=
X-Received: by 2002:a05:600c:1913:: with SMTP id j19mr1772482wmq.155.1616045182634;
 Wed, 17 Mar 2021 22:26:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210316140126.24900-1-joshi.k@samsung.com> <CGME20210316140233epcas5p372405e7cb302c61dba5e1094fa796513@epcas5p3.samsung.com>
 <20210316140126.24900-2-joshi.k@samsung.com> <05a91368-1ba8-8583-d2ab-8db70b92df76@kernel.dk>
In-Reply-To: <05a91368-1ba8-8583-d2ab-8db70b92df76@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 18 Mar 2021 10:55:55 +0530
Message-ID: <CA+1E3r+Mt7KKeFeYf7WY3CoKwnkXT-jE2EgJSTE6zaAfJX0dzQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/3] io_uring: add helper for uring_cmd completion
 in submitter-task
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 18, 2021 at 7:31 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/16/21 8:01 AM, Kanchan Joshi wrote:
> > Completion of a uring_cmd ioctl may involve referencing certain
> > ioctl-specific fields, requiring original subitter context.
> > Introduce 'uring_cmd_complete_in_task' that driver can use for this
> > purpose. The API facilitates task-work infra, while driver gets to
> > implement cmd-specific handling in a callback.
> >
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > ---
> >  fs/io_uring.c            | 36 ++++++++++++++++++++++++++++++++----
> >  include/linux/io_uring.h |  8 ++++++++
> >  2 files changed, 40 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 583f8fd735d8..ca459ea9cb83 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -772,9 +772,12 @@ struct io_kiocb {
> >               /* use only after cleaning per-op data, see io_clean_op() */
> >               struct io_completion    compl;
> >       };
> > -
> > -     /* opcode allocated if it needs to store data for async defer */
> > -     void                            *async_data;
> > +     union {
> > +             /* opcode allocated if it needs to store data for async defer */
> > +             void                            *async_data;
> > +             /* used for uring-cmd, when driver needs to update in task */
> > +             void (*driver_cb)(struct io_uring_cmd *cmd);
> > +     };
>
> I don't like this at all, it's very possible that we'd need async
> data for passthrough commands as well in certain cases. And what it
> gets to that point, we'll have no other recourse than to un-unionize
> this and pay the cost. It also means we end up with:
>
> > @@ -1716,7 +1719,7 @@ static void io_dismantle_req(struct io_kiocb *req)
> >  {
> >       io_clean_op(req);
> >
> > -     if (req->async_data)
> > +     if (io_op_defs[req->opcode].async_size && req->async_data)
> >               kfree(req->async_data);
> >       if (req->file)
> >               io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
>
> which are also very fragile.

I did not want to have it this way....but faced troubles with the more
natural way of doing this. Please see below.

> We already have the task work, just have the driver init and/or call a
> helper to get it run from task context with the callback it desires?
>
> If you look at this:
>
> > @@ -2032,6 +2035,31 @@ static void io_req_task_submit(struct callback_head *cb)
> >       __io_req_task_submit(req);
> >  }
> >
> > +static void uring_cmd_work(struct callback_head *cb)
> > +{
> > +     struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
> > +     struct io_uring_cmd *cmd = &req->uring_cmd;
> > +
> > +     req->driver_cb(cmd);
> > +}
> > +int uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> > +                     void (*driver_cb)(struct io_uring_cmd *))
> > +{
> > +     int ret;
> > +     struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> > +
> > +     req->driver_cb = driver_cb;
> > +     req->task_work.func = uring_cmd_work;
> > +     ret = io_req_task_work_add(req);
> > +     if (unlikely(ret)) {
> > +             req->result = -ECANCELED;
> > +             percpu_ref_get(&req->ctx->refs);
> > +             io_req_task_work_add_fallback(req, io_req_task_cancel);
> > +     }
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL(uring_cmd_complete_in_task);
>
> Then you're basically jumping through hoops to get that callback.
> Why don't you just have:
>
> io_uring_schedule_task(struct io_uring_cmd *cmd, task_work_func_t cb)
> {
>         struct io_kiocb *req = container_of(cmd, struct io_kiocb, uring_cmd);
>         int ret;
>
>         req->task_work.func = cb;
>         ret = io_req_task_work_add(req);
>         if (unlikely(ret)) {
>                 req->result = -ECANCELED;
>                 io_req_task_work_add_fallback(req, io_req_task_cancel);
>         }
>         return ret;
> }
>
> ?
I started with that, but the problem was implementing the driver callback .
The callbacks receive only one argument which is "struct callback_head
*", and the driver needs to extract "io_uring_cmd *" out of it.
This part -
+static void uring_cmd_work(struct callback_head *cb)
+{
+     struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+     struct io_uring_cmd *cmd = &req->uring_cmd;

If the callback has to move to the driver (nvme), the driver needs
visibility to "struct io_kiocb" which is uring-local.
Do you see a better way to handle this?
I also thought about keeping the driver_cb inside the unused part of
uring_cmd (instead of union with req->async_data), but it had two
problems - 1. uring needs to peek inside driver-part of uring_cmd to
invoke this callback
2. losing precious space  (I am using that space to avoid per-command
dynamic-allocation in driver)

> Also, please export any symbol with _GPL. I don't want non-GPL drivers
> using this infrastructure.

Got it.


-- 
Kanchan
