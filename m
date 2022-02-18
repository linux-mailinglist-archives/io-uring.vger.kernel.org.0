Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA314BBE96
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 18:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiBRRmJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 12:42:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbiBRRmI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 12:42:08 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B26412D90C;
        Fri, 18 Feb 2022 09:41:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso9152396pjh.5;
        Fri, 18 Feb 2022 09:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KSli5rCrJB0W3FEtPi/UFqHqSyfkR/GxEvw8Vsf0wq0=;
        b=KIFNCgz5A3jkvjPREYY404JrN5BdDM7HCekAcSiFxZ9BZq+0X5ARFpw0Ae9G4RKvFD
         ZlbXBXjVATg72xZh0JWKmI9RJizkhYNxJwKrQgC++IqYMx9vYdaX8ID1rT16hY4aM9G8
         KtIvM3F+89hPvzaT7nv/ZbBswkpFEmp5rE5mvYO4IzWleJv4cYE4tAlo7WGIHmv2FY0l
         fgFjVQ0x1WWNEREZnMufZ3Ku4rzKSRFytC6mN0ktm2IKVuW364SGP/09CYQmGsNTOCu0
         SSxuHdlEOkFyiOx9T/edLiRPOkaFC15T1g2AL4s/MtZAk8GdMp/U65AHk12myhbpFGkQ
         r+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KSli5rCrJB0W3FEtPi/UFqHqSyfkR/GxEvw8Vsf0wq0=;
        b=Dgicni2sgjKVfwEONrWNtaHoIIn7XX6tx4Q5cFdZh6Syh0iCMWy0mp+YS+9r8yfvww
         6nqNpGhO5aKo5YdJ68E5nFWdJ5yJyzU/TAswYT78M5iDl6q5XIbmIfraRdqISFFkVJCO
         k9OVQfm9sUosAOEtOO8JzRYfHAO9OXRhXOPPTojSrNa6xjPniicrXHpOhGZEI06GFHpX
         tIfvAQKkWmCSJX7t26Qzf3ZNT3+YK54mtZYtItfkL+nL97nZzEzYW51cAghegAs57wzr
         I5founaC94zCF92r61uCPhTzCqfaSzHrTB0q/z3DxzWkjABsD8DT8LDfCYq+zADOc5rv
         KwKQ==
X-Gm-Message-State: AOAM532Ji86WzxHOmTAXda7A0OMKkN30mr7tPST0AyQfB1PYwSJeTH6v
        YtQFEX5wrs4O5Gl1oTOF3QprvS9UOQSdxj8JdFtwD3Sc
X-Google-Smtp-Source: ABdhPJzMHCKthZOO2Ql1mmgaOUdLWEnOAXoAJjDZ2Ed1STB6HaeTHcYgODUuzLKdUsC1c5XVubuD3v/f1pkkVeNuHqc=
X-Received: by 2002:a17:902:cf0e:b0:14f:8a60:475c with SMTP id
 i14-20020a170902cf0e00b0014f8a60475cmr221751plg.146.1645206110764; Fri, 18
 Feb 2022 09:41:50 -0800 (PST)
MIME-Version: 1.0
References: <20211220141734.12206-1-joshi.k@samsung.com> <CGME20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e@epcas5p2.samsung.com>
 <20211220141734.12206-2-joshi.k@samsung.com> <Yg2vP7lo3hGLGakx@bombadil.infradead.org>
 <CA+1E3rLpKp0h2x7CoFPXwsYOc4ZYg_sqQQ+ed8cJhq77ESOAjg@mail.gmail.com>
 <b11ede2b-b737-f99a-7b31-20d6b4eccb42@kernel.dk> <Yg6MVe2Qpy92CsNF@bombadil.infradead.org>
In-Reply-To: <Yg6MVe2Qpy92CsNF@bombadil.infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 18 Feb 2022 23:11:25 +0530
Message-ID: <CA+1E3r+41WZRR_AOodvQnVbRo3+fG=sLT4LJpSjgd2SsJCNuow@mail.gmail.com>
Subject: Re: [RFC 01/13] io_uring: add infra for uring_cmd completion in submitter-task
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
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

On Thu, Feb 17, 2022 at 11:26 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Thu, Feb 17, 2022 at 08:50:59AM -0700, Jens Axboe wrote:
> > On 2/17/22 8:39 AM, Kanchan Joshi wrote:
> > > On Thu, Feb 17, 2022 at 7:43 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >>
> > >> On Mon, Dec 20, 2021 at 07:47:22PM +0530, Kanchan Joshi wrote:
> > >>> Completion of a uring_cmd ioctl may involve referencing certain
> > >>> ioctl-specific fields, requiring original submitter context.
> > >>> Export an API that driver can use for this purpose.
> > >>> The API facilitates reusing task-work infra of io_uring, while driver
> > >>> gets to implement cmd-specific handling in a callback.
> > >>>
> > >>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > >>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > >>> ---
> > >>>  fs/io_uring.c            | 16 ++++++++++++++++
> > >>>  include/linux/io_uring.h |  8 ++++++++
> > >>>  2 files changed, 24 insertions(+)
> > >>>
> > >>> diff --git a/fs/io_uring.c b/fs/io_uring.c
> > >>> index e96ed3d0385e..246f1085404d 100644
> > >>> --- a/fs/io_uring.c
> > >>> +++ b/fs/io_uring.c
> > >>> @@ -2450,6 +2450,22 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
> > >>>               io_req_complete_failed(req, -EFAULT);
> > >>>  }
> > >>>
> > >>> +static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
> > >>> +{
> > >>> +     req->uring_cmd.driver_cb(&req->uring_cmd);
> > >>
> > >> If the callback memory area is gone, boom.
> > >
> > > Why will the memory area be gone?
> > > Module removal is protected because try_module_get is done anyway when
> > > the namespace was opened.
> >
> > And the req isn't going away before it's completed.
>
> Groovy, it would be nice to add a little /* comment */ to just remind
> the reader?
>
> > >>> +{
> > >>> +     struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
> > >>> +
> > >>> +     req->uring_cmd.driver_cb = driver_cb;
> > >>> +     req->io_task_work.func = io_uring_cmd_work;
> > >>> +     io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
> > >>
> > >> This can schedules, and so the callback may go fishing in the meantime.
> > >
> > > io_req_task_work_add is safe to be called in atomic context. FWIW,
> > > io_uring uses this for regular (i.e. direct block) io completion too.
> >
> > Correct, it doesn't schedule and is safe from irq context as long as the
> > task is pinned (which it is, via the req itself).
>
> Great, a kdoc explaining the routine and that it can be called from
> atomic context and the rationale would be very useful to users. And ..
> so the callback *must* be safe in atomic context too or can it sleep?

Callback will be invoked in task/process context. Allowing much more
to do than we can in atomic context, including sleep if necessary.
