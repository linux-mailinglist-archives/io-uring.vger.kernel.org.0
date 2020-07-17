Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E15B22466F
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 00:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgGQWkX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 18:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgGQWkX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 18:40:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5297C0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 15:40:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f2so12632524wrp.7
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 15:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uAHPaPbaC2TPKtuonlx6H081V/p8HFgzI17a0tZK+p4=;
        b=qZ5cfL3aIC2drSte4E0XAEh+10OOICPqmw9iPAt3dU9z/6cVokJ/+h+ZDZI1MxAUkZ
         D4C2ggTPjKHLUAGq5Z7uJxmrvLN0r4EWT+xHuNTs5XtCRqfa50+baTmVPXcWqMRzZZpY
         VKV5BJjj7kQGzkj6OoX2KOs6CeA877T7E5s2na6y2aiHnn8j4GeZSY4rZN1IT+HjuGiQ
         +6iMr3jkrHWxVhCtCAujBz6buaqgB7sDCRipxrSaVEPriQsf+iLQ1Q4YRtTYwhQ0uARn
         vp6teRD4oeMSMYCcCIw3DNypCqEbXwymsoo8cuEHOtmU3dmFfJrNIVfP9IKZLnUQ36xD
         nLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uAHPaPbaC2TPKtuonlx6H081V/p8HFgzI17a0tZK+p4=;
        b=CoMNKlxBzSak7jhET0G8hs04PRQMCkhuMIwwZxOvbenaTiGgc8O2Kdef4zI4eqLpNG
         yRu41sA652RQgL6orJPREcuKSD78VTLpONfUTCgrK//yOp4hkJT0ferCgCmv/yc/a6Hq
         L7ttUrBeqFfx2BdNK0qytUR7nfJ7ghhNho+p9Y1vPG4358WCFvCg9mBCfeHXb9zYL4F/
         TDUS5tzRJUurbWVKUUJgpw8QnOPWbCqvi3N9SfNeAdT971k9xON7GYUgK/miiAgbQqQC
         Lhj7Hoyzgg8uUSX+IQwS+8Jh7wFNQrnpjjiuZIGP3fzYOX3MLQFJxgL52S+ltc7d4qT/
         eoww==
X-Gm-Message-State: AOAM533UGTURNjgVokyoQtdBVDcFyus/nrrkFmFWLciiU+eHdR0mOWo3
        61mmtWR5CQvmxg62DTrn2HOyNK1X3pmP73quIFAXBg==
X-Google-Smtp-Source: ABdhPJzBQzhQK8FBmYntpbUPwtNnEvkNp0qmz8zHV11BmLGj+QIkJ8SfuGdIlppzyf4qM8fuEVK0ih2my1Q/Ia0PH8g=
X-Received: by 2002:adf:f083:: with SMTP id n3mr12308923wro.297.1595025621353;
 Fri, 17 Jul 2020 15:40:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
 <CAKq9yRiSyHJu7voNUiXbwm36cRjU+VdcSXYkGPDGWai0w8BG=w@mail.gmail.com> <bf3df7ce-7127-2481-602c-ee18733b02bd@kernel.dk>
In-Reply-To: <bf3df7ce-7127-2481-602c-ee18733b02bd@kernel.dk>
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Fri, 17 Jul 2020 23:39:55 +0100
Message-ID: <CAKq9yRhrqMv44sHK-P_A7=OUvLXf=3dZxPysVrPP=sL43ZGiDQ@mail.gmail.com>
Subject: Re: [PATCH] io_files_update_prep shouldn't consider all the flags invalid
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sure thing, tomorrow I will put it together review all the other ops
as well, just in case (although I believe you may already have done
it), and test it.

For the test cases, should I submit a separate patch for liburing or
do you prefer to use pull requests on gh?

On Fri, 17 Jul 2020 at 17:21, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/17/20 10:13 AM, Daniele Salvatore Albano wrote:
> > On Tue, 14 Jul 2020 at 18:32, Daniele Salvatore Albano
> > <d.albano@gmail.com> wrote:
> >>
> >> Currently when an IORING_OP_FILES_UPDATE is submitted with the
> >> IOSQE_IO_LINK flag it fails with EINVAL even if it's considered a
> >> valid because the expectation is that there are no flags set for the
> >> sqe.
> >>
> >> The patch updates the check to allow IOSQE_IO_LINK and ensure that
> >> EINVAL is returned only for IOSQE_FIXED_FILE and IOSQE_BUFFER_SELECT.
> >>
> >> Signed-off-by: Daniele Albano <d.albano@gmail.com>
> >> ---
> >>  fs/io_uring.c | 9 ++++++++-
> >>  1 file changed, 8 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index ba70dc62f15f..7058b1a0bd39 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -5205,7 +5205,14 @@ static int io_async_cancel(struct io_kiocb *req)
> >>  static int io_files_update_prep(struct io_kiocb *req,
> >>                                 const struct io_uring_sqe *sqe)
> >>  {
> >> -       if (sqe->flags || sqe->ioprio || sqe->rw_flags)
> >> +       unsigned flags = 0;
> >> +
> >> +       if (sqe->ioprio || sqe->rw_flags)
> >> +               return -EINVAL;
> >> +
> >> +       flags = READ_ONCE(sqe->flags);
> >> +
> >> +       if (flags & (IOSQE_FIXED_FILE | IOSQE_BUFFER_SELECT))
> >>                 return -EINVAL;
> >>
> >>         req->files_update.offset = READ_ONCE(sqe->off);
> >> --
> >> 2.25.1
> >
> > Hi,
> >
> > Did you get the chance to review this patch? Would you prefer to get
> > the flags loaded before the first branching?
>
> I think it looks fine, but looking a bit further, I think we should
> extend this kind of checking to also include timeout_prep and cancel_prep
> as well. They suffer from the same kind of issue where they disallow all
> flags, and they should just fail on the same as the above.
>
> And we should just use req->flags for this checking, and get rid of the
> sqe->flags reading in those prep functions. Something like this:
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 74bc4a04befa..5c87b9a686dd 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4732,7 +4732,9 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
>  {
>         if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>                 return -EINVAL;
> -       if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
> +       if (req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT))
> +               return -EINVAL;
> +       if (sqe->ioprio || sqe->buf_index || sqe->len)
>                 return -EINVAL;
>
>         req->timeout.addr = READ_ONCE(sqe->addr);
> @@ -4910,8 +4912,9 @@ static int io_async_cancel_prep(struct io_kiocb *req,
>  {
>         if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>                 return -EINVAL;
> -       if (sqe->flags || sqe->ioprio || sqe->off || sqe->len ||
> -           sqe->cancel_flags)
> +       if (req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT))
> +               return -EINVAL;
> +       if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
>                 return -EINVAL;
>
>         req->cancel.addr = READ_ONCE(sqe->addr);
> @@ -4929,9 +4932,10 @@ static int io_async_cancel(struct io_kiocb *req)
>  static int io_files_update_prep(struct io_kiocb *req,
>                                 const struct io_uring_sqe *sqe)
>  {
> -       if (sqe->flags || sqe->ioprio || sqe->rw_flags)
> +       if (sqe->ioprio || sqe->rw_flags)
> +               return -EINVAL;
> +       if (req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT))
>                 return -EINVAL;
> -
>         req->files_update.offset = READ_ONCE(sqe->off);
>         req->files_update.nr_args = READ_ONCE(sqe->len);
>         if (!req->files_update.nr_args)
>
> --
> Jens Axboe
>
