Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948C941428A
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 09:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhIVHVu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 03:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhIVHVu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 03:21:50 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D54C061574
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 00:20:20 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d6so3758789wrc.11
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 00:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yIWDbUeb9eVjg614LLtNWsjwRP6rzLhm90LjC7m9WB8=;
        b=RwRvzT9WSFDWEGPN4KQntoyoN9ipb/5tISApBgsHlothq1kXIF5aXHcUN/dO9CmwtV
         sWaxPZy6pH9zOYKFkBWlKASBviamDk1iBLoWeSaPjFzevqo1WiVkluoOcFYsa7UtJ/Kn
         YSB/1VPwXfiDeGLBBHuxIfOGZam6a3PfJSBcscliVvyB20E2YqWScPgT4VZd0/9MfT2f
         cYjZVfhVu54I1qhIYw2lZNCStKeLudDrXO01tdAQ0HgVNpXhKiAVuDsVXMYcG2kKfNSd
         sKLx0XNRTMMjVJyY2CVDOl6/4eR2blOql769DwE7x7jqJb6MWeuxbtr29fUHuJAw22s7
         Y2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yIWDbUeb9eVjg614LLtNWsjwRP6rzLhm90LjC7m9WB8=;
        b=fid6Zqey7Nksyqbx1Hp9b4ez8fy/qEzn71Tfal4Dhc/ToPYwBh9JJcZjGnA2hgCXtO
         4xz8/7fjZq7eF4dB9oF8TWc/f8hpf7p8sN81E02AZGRxDn3vYo/RUkxPE9g5yFWffKLY
         xltaFWq95E9d4tN80ML9qvdcpYVipDQOneNGnS9aP0/OniGBOnh+jqI6Dxz2A+TXgUil
         +u6iYQ++EdnYjvNzLtzN0zoXjjDfC26aogJyqOOGngh82HDPFuRw2STf3RmWx+Br09LI
         QGzWIpe47tQoGk3wNZS+pijnFsQ47hqV9KoFDswGoOcn7CR00fUDkh9YXg090Tbpi1nZ
         Bqdw==
X-Gm-Message-State: AOAM531S4UsiPLCCwz/JLX6xXaQnggx/Qnej4PkGbzX81MEvtrGiwm14
        OdKH3UOHMm/zURSYTyrFaRe235li0RIUJ6RLFaQ=
X-Google-Smtp-Source: ABdhPJwUTr4MdOkW7jZQVC8cFh/55BoLEygUfs6oW2DUmxurxeZfGGg2LbmR3gRaKBkDxZ/arWKjQhNTPCtMU6lM9VI=
X-Received: by 2002:adf:8b19:: with SMTP id n25mr42586574wra.216.1632295219240;
 Wed, 22 Sep 2021 00:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125923epcas5p10e6c1b95475440be68f58244d5a3cb9a@epcas5p1.samsung.com>
 <20210805125539.66958-3-joshi.k@samsung.com> <20210907074650.GB29874@lst.de>
 <CA+1E3rJAav=4abJXs8fO49aiMNPqjv6dD7HBfhB+JQrNbaX3=A@mail.gmail.com> <20210908061530.GA28505@lst.de>
In-Reply-To: <20210908061530.GA28505@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 22 Sep 2021 12:49:52 +0530
Message-ID: <CA+1E3rLeM=GZn1gR_KN7b6o8LHDistp1ZoHBb0N54ayK-2+tPA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/6] nvme: wire-up support for async-passthru on char-device.
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        Javier Gonzalez <javier.gonz@samsung.com>, hare@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I am sorry for taking longer than I should have.

On Wed, Sep 8, 2021 at 11:45 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Sep 07, 2021 at 09:50:27PM +0530, Kanchan Joshi wrote:
> > > A few other notes:
> > >
> > >  - I suspect the ioctl_cmd really should move into the core using_cmd
> > >    infrastructure
> >
> > Yes, that seems possible by creating that field outside by combining
> > "op" and "unused" below.
> > +struct io_uring_cmd {
> > + struct file *file;
> > + __u16 op;
> > + __u16 unused;
> > + __u32 len;
> > + __u64 pdu[5]; /* 40 bytes available inline for free use */
> > +};
>
> Two different issues here:
>
>  - the idea of having a two layer indirection with op and a cmd doesn't
>    really make much sense
>  - if we want to avoid conflicts using 32-bit probably makes sense
>
> So I'd turn op and unused into a single cmd field, use the ioctl encoding
> macros for it (but preferably pick different numbers than the existing
> ioctls).

I was thinking along the same lines, except the "picking different
numbers than existing ioctls" part.
Does that mean adding a new IOCTL for each operation which requires
async transport?

> > >  - that whole mix of user space interface and internal data in the
> > >    ->pdu field is a mess.  What is the problem with deferring the
> > >    request freeing into the user context, which would clean up
> > >    quite a bit of that, especially if io_uring_cmd grows a private
> > >    field.
> >
> > That mix isn't great but the attempt was to save the allocation.
> > And I was not very sure if it'd be fine to defer freeing the request
> > until task-work fires up.
>
> What would be the problem with the delaying?

When we free the request, the tag is also freed, and that may enable
someone else to pump more IO.
Pushing freeing of requests to user-context seemed like delaying that part.
If you think that is a misplaced concern, I can change.
The changed structure will look like this -

struct nvme_uring_cmd {
       __u32   ioctl_cmd;
       __u32   unused1;
       void __user *argp;
      union {
                struct bio *bio;
                struct request *req;
             };
       void *meta;
};
cmd->bio will be freed in nvme-completion while cmd->req will be freed
in user context.
Since we have the request intact, we will not store "u64 result; int
status;" anymore and overall there will be a reduction of 4 bytes in
size of nvme_uring_cmd.
Would you prefer this way?

> > Even if we take that route, we would still need a place to store bio
> > pointer (hopefully meta pointer can be extracted out of bio).
> > Do you see it differently?
>
> We don't need the bio pointer at all.  The old passthrough code needed
> it when we still used block layer bonuce buffering for it.  But that
> bounce buffering for passthrough commands got removed a while ago,
> and even before nvme never used it.

nvme_submit_user_cmd() calls blk_rq_map_user(), which sets up req->bio
(and that is regardless of bounce buffering I suppose).
For sync-ioctl, this bio pointer is locally stored and that is used to
free the bio post completion.
For async-ioctl too, we need some place to store this.
So I could not connect this to bounce buffering (alone). Am I missing
your point?

One of the way could be to change blk_update_request() to avoid
setting req->bio to NULL. But perhaps that may invite more troubles,
and we are not saving anything: bio-pointer is inside the union anyway
(in above struct nvme_uring_cmd).


-- 
Kanchan
