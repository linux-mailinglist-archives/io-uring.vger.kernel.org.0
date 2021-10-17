Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C084305EE
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 03:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbhJQBhb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 21:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbhJQBhb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 21:37:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55602C061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 18:35:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so12023944pjb.5
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 18:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mfATsEyVXnKtDnKQQIy1pz4sFb42CHndPmSa00Zw5mU=;
        b=TO/arzVPoWtjcUZgSI69qV/tsuFqyC+agL6bckZ7+s9nF4OMfC3CK/EKGhHIxgHRu2
         EAthdl/oQuHROVsGUE+KsfHwdA6cPeFc5Az4Hn9pq6IHPbyMe0jU0loFE4Jy5TBM8SKf
         6faj0NINfKsv29agp8UBTXZu77sYSLRCUfhXonQATATRbvSgfxg3HziHp04/jFX3UNYS
         1GcoH8gWMklUkl7sByyafWM51YRtuTs6mr1XiotfhAh68gGAbVbrrMhHct+ElpPDBwMn
         pbZkUWCAgkp91jEh3yzPx6BIVANYr7W0lFpiJjfs7/eiv207upGKeDRu0bHj2p4Rq0Ci
         WTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mfATsEyVXnKtDnKQQIy1pz4sFb42CHndPmSa00Zw5mU=;
        b=LDCQAt2PQlrHHYRMQKhE1t+OZxvWPcKDVWUgTsNUB92h/PccLv1e18FeKvGVbasT3Z
         naBppQmCwrH47HTf8nii9xaTVS+29RO3HjENXUKcvOHb6FrjQ0jQtNsr6OTGClh8Yskg
         K4P1VP0uyEhiJSyKVTIlZYD9wa+yodBJGRNjagFXHAIzszjO8pDf9JgiFS9S5BmjvxL/
         45SFYVBblgKX6ITtSrl4BvfW1h+gm0MeL51aJrdm3njEUrVPh6BEX7ZfYR8rkKcAzb0L
         AsZxVgMpM1GwalAy3Mi48RRF54y81h61mClpIwTudv651E5tsdCjBfnHgPXiqBe3KvhX
         eJNA==
X-Gm-Message-State: AOAM533tn/j90GSfE+9mEg4tyvavIzGpGA7GZYUIwuKrbAli69Xm9Y5B
        rwn/Xhn31YOKZm7bBFQY+u8hkaa/iRH+6bgU9Nk=
X-Google-Smtp-Source: ABdhPJyhbO8hvuS9auafTKMnVDW59ot88SJoFAIawgt51oiRrh1LPX5dZZt40Gb31Ho0eLD2TPFEwodsmBoblwYTDug=
X-Received: by 2002:a17:902:8d8b:b0:138:e09d:d901 with SMTP id
 v11-20020a1709028d8b00b00138e09dd901mr19691397plo.34.1634434521760; Sat, 16
 Oct 2021 18:35:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634144845.git.asml.silence@gmail.com> <2c2536c5896d70994de76e387ea09a0402173a3f.1634144845.git.asml.silence@gmail.com>
 <CAFUsyfKyRnXhcxOVfSAxeyKsQqGXJ7PdDYw3TXC3H+q_yp5LMA@mail.gmail.com> <869d5110-973b-6c70-604d-48d6108c0379@gmail.com>
In-Reply-To: <869d5110-973b-6c70-604d-48d6108c0379@gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Sat, 16 Oct 2021 20:35:11 -0500
Message-ID: <CAFUsyfKbCbLL-yVPvf-QofauEzU91RuFGmhTUZ+nhe7aNXry0w@mail.gmail.com>
Subject: Re: [PATCH 8/8] io_uring: rearrange io_read()/write()
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     "open list:IO_URING" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Oct 16, 2021 at 6:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 10/16/21 23:52, Noah Goldstein wrote:
> > On Thu, Oct 14, 2021 at 10:13 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> -       /* If the file doesn't support async, just async punt */
> >> -       if (force_nonblock && !io_file_supports_nowait(req, WRITE))
> >> -               goto copy_iov;
> >> +               /* file path doesn't support NOWAIT for non-direct_IO */
> >> +               if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
> >
> > You can drop this 'force_nonblock' no?
>
> Indeed
>
> >
> >> +                   (req->flags & REQ_F_ISREG))
> >> +                       goto copy_iov;
> >>
> >> -       /* file path doesn't support NOWAIT for non-direct_IO */
> >> -       if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
> >> -           (req->flags & REQ_F_ISREG))
> >> -               goto copy_iov;
> >> +               kiocb->ki_flags |= IOCB_NOWAIT;
> >> +       } else {
> >> +               /* Ensure we clear previously set non-block flag */
> >> +               kiocb->ki_flags &= ~IOCB_NOWAIT;
> >> +       }
> >>
> >>          ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
> >>          if (unlikely(ret))
> >
> > ...
> >
> > What swapping order of conditions below:
> > if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
> >
> > The ret2 check will almost certainly be faster than 2x deref.
>
> Makes sense. Want to send a patch?
Done.
>
> --
> Pavel Begunkov

As an aside regarding the reorganization of io_write/io_read, maybe
it's worth it
to add seperate versions of the function for w/w.o force_nonblock?
Isn't something
that will change during the function and seems to really just be
adding 4-5 branches
(of runtime and code complexity) to each where factoring it would just
be +1 branch.
