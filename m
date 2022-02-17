Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE064BA4A1
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 16:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbiBQPkL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 10:40:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242614AbiBQPkK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 10:40:10 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520842B2E15;
        Thu, 17 Feb 2022 07:39:56 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id x18so1046pfh.5;
        Thu, 17 Feb 2022 07:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TE8n2qHv14fuB3CwoM4G4MqgZMfIJ3HjzCk+Yfyt5N8=;
        b=qMt5VtEERrppHzkcA843sKlSXVkDWwJVCc8xr8+WeAWWtHU+r71qgQBRYbX1ux5DHL
         NTb7U6GXDPSHTmip7AfIy5Ko8VL/n2wYZkfTF+oblRqdZyRfvEJN8zeIrsT+U1xUpvfJ
         riVOgdNN8btUUwTA2klq9U/ssBcB0UxtckmqrZ9tEwGNj1BJ21gr/PO2oSD17bvd5xTR
         WaPxX9eN4glrpIkVpONkOkPCdwiqP9MsrN3kghCci+eV1jQZ8IyRz1YxvinGdbLTKvYS
         g0yJtFpgUiwqm4F4jDITroCd2gmObqxz7e5DqX7MyAaS2lksK8rHnhn45TfDiH1mcbj+
         z0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TE8n2qHv14fuB3CwoM4G4MqgZMfIJ3HjzCk+Yfyt5N8=;
        b=kygUEExA9ls2eY9mP3l1m+7HNipYu3K0HPgAtc5fP7Hvhf0611sonb/+WE5HFgs6O8
         g4e8c0pLOQve2Oi/h2Hj7XNF/4gESq72fq3DHGVInzXqn9LfFcxRoIoRG1AAvNU4XiRO
         EeM5R+IwUFq8MNrGY6VOHeYIeptzqzKfwVgZK6daQrwPMAhX52I/JJUT9WWhIdiHjj7q
         agQ3b5GQQFGorgECrJXK0yoRa4bDcg4dXxXUbZmLvz/u6yAf1cvcvpuIVT5ziGXvwtzW
         itDDHWgkQezEGlif9G4atfBcGFbGzkqGqmJ8VPrtU843AJZSMXy5LXNjco27q6ozr021
         lGfQ==
X-Gm-Message-State: AOAM532jCfIG3ExumzhnK4yfb6SCfUjomLEvWuuaKVQb5NmZHLySg9cv
        eum6kbkUrfETFMjBUzW2NW0VtzBUnNEvAsnLHaQ=
X-Google-Smtp-Source: ABdhPJzPHsLcfwtzgYqMUfCU52gOXoVikjFPcVCnRLCbbJ9C8FYtQSZ8LnF5dDCB8RmVXuGNHrzFCDcOFwUhqIC04Qk=
X-Received: by 2002:a05:6a00:a8b:b0:4cd:6030:4df3 with SMTP id
 b11-20020a056a000a8b00b004cd60304df3mr3442934pfl.40.1645112395768; Thu, 17
 Feb 2022 07:39:55 -0800 (PST)
MIME-Version: 1.0
References: <20211220141734.12206-1-joshi.k@samsung.com> <CGME20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e@epcas5p2.samsung.com>
 <20211220141734.12206-2-joshi.k@samsung.com> <Yg2vP7lo3hGLGakx@bombadil.infradead.org>
In-Reply-To: <Yg2vP7lo3hGLGakx@bombadil.infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 17 Feb 2022 21:09:30 +0530
Message-ID: <CA+1E3rLpKp0h2x7CoFPXwsYOc4ZYg_sqQQ+ed8cJhq77ESOAjg@mail.gmail.com>
Subject: Re: [RFC 01/13] io_uring: add infra for uring_cmd completion in submitter-task
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Pankaj Raghav <pankydev8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 17, 2022 at 7:43 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Mon, Dec 20, 2021 at 07:47:22PM +0530, Kanchan Joshi wrote:
> > Completion of a uring_cmd ioctl may involve referencing certain
> > ioctl-specific fields, requiring original submitter context.
> > Export an API that driver can use for this purpose.
> > The API facilitates reusing task-work infra of io_uring, while driver
> > gets to implement cmd-specific handling in a callback.
> >
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > ---
> >  fs/io_uring.c            | 16 ++++++++++++++++
> >  include/linux/io_uring.h |  8 ++++++++
> >  2 files changed, 24 insertions(+)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index e96ed3d0385e..246f1085404d 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -2450,6 +2450,22 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
> >               io_req_complete_failed(req, -EFAULT);
> >  }
> >
> > +static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
> > +{
> > +     req->uring_cmd.driver_cb(&req->uring_cmd);
>
> If the callback memory area is gone, boom.

Why will the memory area be gone?
Module removal is protected because try_module_get is done anyway when
the namespace was opened.

> > +}
> > +
> > +void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> > +                     void (*driver_cb)(struct io_uring_cmd *))
>
> Adding kdoc style comment for this would be nice. Please document
> the context that is allowed.

Sure, for all kdoc style comments. Will add that in the next version.

> > +{
> > +     struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> > +
> > +     req->uring_cmd.driver_cb = driver_cb;
> > +     req->io_task_work.func = io_uring_cmd_work;
> > +     io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
>
> This can schedules, and so the callback may go fishing in the meantime.

io_req_task_work_add is safe to be called in atomic context.
FWIW, io_uring uses this for regular (i.e. direct block) io completion too.

> > +}
> > +EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
> > +
> >  static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
> >  {
> >       req->result = ret;
> > diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> > index 64e788b39a86..f4b4990a3b62 100644
> > --- a/include/linux/io_uring.h
> > +++ b/include/linux/io_uring.h
> > @@ -14,11 +14,15 @@ struct io_uring_cmd {
> >       __u16           op;
> >       __u16           unused;
> >       __u32           len;
> > +     /* used if driver requires update in task context*/
>
> By using kdoc above youcan remove this comment.
>
> > +     void (*driver_cb)(struct io_uring_cmd *cmd);
>
> So we'd need a struct module here I think if we're going to
> defer this into memory which can be removed.
>
Same as the previous module-removal comment.Do we really need that?

Thanks,
--
