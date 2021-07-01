Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F9B3B929B
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 16:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhGAOEm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 10:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbhGAOEl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 10:04:41 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B752C061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 07:02:11 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bg14so10554303ejb.9
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 07:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s9GoIHa6V3N5jhO2nqaUKzNDtnaluPqFEJcnrfNU5z4=;
        b=A1lw681CEzeG3jDSUUKbMwcI9hLRsr2Iiees4NcCSnX9IZfigW1/3GafP3IFddTjjf
         8HDpJjJYTNJTbvuQJgKIcv+SmNdzqiIGV9Xq4u/teXvB/gfp7twyG+ssh89lMZEF17LP
         QybDSLv138DuMOUXbqvaomiOd2Wvyd8MsgWIl4n6anxrj3PiG17RKbjzDxgDLcEmw2Sd
         uRhlipoH2rxgcRi4eO1PmP1ORB+pZgTn35mIcXseLkfmsv+zG8/06UB8WWOuKuJp2dsV
         9eE0XqJj5PEVgxD6fG8EoaGbUeNeCFAnanbaijxWDOnx1LFA6yu0y/MvlUZNvkTbqKsJ
         6/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s9GoIHa6V3N5jhO2nqaUKzNDtnaluPqFEJcnrfNU5z4=;
        b=UkrkgxSfTy8IQRCF1+1jguGOxCA8CpueLato6HeBigg0GeoyH8X8gpt6RXPGCMMH3l
         y1w/PskdAl0O5AC7/GTPXV5qdv6yJYM+CsDDoO1Sew3c7RH2BpieU8n8WLGbrTnfsSPn
         fK+cydOYiawqWsMdPNXFqHwZp6i2GVloXDKqBNz4SgZ8hDKHimZXV5mFNYDKxLCmALoj
         tc0NvZ/A6sql4jkDGR9N3YC/STh5qg2DGY3Fi6ZW8y9nhN0SZ6OgSHUKk4kXH/iUTeOD
         OuOoFvq+/0qLCnL0TMGstT2N6+C/w42T4n4eE7hBWt6eS3s0eLEH5bcvMCioQXc32BkO
         luSw==
X-Gm-Message-State: AOAM530hRWkRHNdDdgEBvLCN4PEgf/Dy+QhYcARLPR/n20hUbJE6NH1Y
        2aFQymWbNNabhfZGxlXSLWs7gcs1JdMz4eU0/m8=
X-Google-Smtp-Source: ABdhPJzl1F9iDlExOHZ8Dd9v1By67m7/zh85aXX1r1Pyfqj3M5RN9u/3OAD0mJeYIGqva33vyhdR8Dsnepdm/hO/vps=
X-Received: by 2002:a17:907:7b9f:: with SMTP id ne31mr14984156ejc.99.1625148129714;
 Thu, 01 Jul 2021 07:02:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwgU2V0RsE+77mRUg+mr6WL5PJpbFKh4FrEGOnfzZ5vZ3A@mail.gmail.com>
 <89a4bff4-958b-d1c0-8dc3-01aface97011@gmail.com>
In-Reply-To: <89a4bff4-958b-d1c0-8dc3-01aface97011@gmail.com>
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Thu, 1 Jul 2021 17:01:43 +0300
Message-ID: <CAKq9yRgJFU84ZqjA_05WBs9J5NQnH1c4G+NUXj41mV_v+wDJ5Q@mail.gmail.com>
Subject: Re: [Bug] io_uring_register_files_update broken
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 1 Jul 2021 at 00:28, Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/30/21 10:14 PM, Victor Stewart wrote:
> > i'm fairly confident there is something broken with
> > io_uring_register_files_update,
> > especially the offset parameter.
> >
> > when trying to update a single fd, and getting a successful result of
> > 1, proceeding
> > operations with IOSQE_FIXED_FILE fail with -9. but if i update all of
> > the fds with
> > then my recv operations succeed, but close still fails with -9.
> >
> > on Clear LInux 5.12.13-1050.native
>
> Thanks for letting know, I'll take a look
>
>
> > here's a diff for liburing send_recv test, to demonstrate this.
> >
> > diff --git a/test/send_recv.c b/test/send_recv.c
> > index 19adbdd..492b591 100644
> > --- a/test/send_recv.c
> > +++ b/test/send_recv.c
> > @@ -27,6 +27,8 @@ static char str[] = "This is a test of send and recv
> > over io_uring!";
> >  #      define io_uring_prep_recv io_uring_prep_read
> >  #endif
> >
> > +static int *fds;
> > +
> >  static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock,
> >                      int registerfiles)
> >  {
> > @@ -54,17 +56,28 @@ static int recv_prep(struct io_uring *ring, struct
> > iovec *iov, int *sock,
> >                 goto err;
> >         }
> >
> > +       fds = malloc(100 * sizeof(int));
> > +       memset(fds, 0xff, sizeof(int) * 100);
> > +
> >         if (registerfiles) {
> > -               ret = io_uring_register_files(ring, &sockfd, 1);
> > +               ret = io_uring_register_files(ring, fds, 100);
> >                 if (ret) {
> >                         fprintf(stderr, "file reg failed\n");
> >                         goto err;
> >                 }
> > -               use_fd = 0;
> > -       } else {
> > -               use_fd = sockfd;
> > +
> > +               fds[sockfd] = sockfd;
> > +               int result = io_uring_register_files_update(ring,
> > sockfd, fds, 1);
> > +
> > +               if (result != 1)
> > +               {
> > +                       fprintf(stderr, "file update failed\n");
> > +                       goto err;
> > +               }
> >         }
> >
> > +       use_fd = sockfd;
> > +
> >         sqe = io_uring_get_sqe(ring);
> >         io_uring_prep_recv(sqe, use_fd, iov->iov_base, iov->iov_len, 0);
> >         if (registerfiles)
> >
>
> --
> Pavel Begunkov
I sent an email a while ago to raise a question about a potential bug
related to close.

Looks like the close doesn't support registered files (although I saw
some code within a patch from Jens to fix it while I was
investigating).

Attached below

On Fri, 21 May 2021 at 21:28, Daniele Salvatore Albano
<d.albano@gmail.com> wrote:
>
> Hi,
>
> Is there any specific reason for which io_close_prep returns EBADF if
> using REQ_F_FIXED_FILE?
>
> I discovered my software was failing to close sockets when using fixed
> files a while ago but I put it to the side, initially thinking it was
> a bug I introduced in my code.
> In recent days I picked it up again and after investigating it, it
> looks like that, instead, that's the expected behaviour.
>
> From what I see, although the behaviour was slightly changed with a
> couple of commits (ie. with
> https://github.com/torvalds/linux/commit/cf3040ca55f2085b0a372a620ee2cb93ae19b686
> ) the io_close_prep have had this behaviour from the very beginning
> https://github.com/torvalds/linux/commit/b5dba59e0cf7e2cc4d3b3b1ac5fe81ddf21959eb
> .
>
> @Jens during my researches I have also found
> https://lkml.org/lkml/2020/5/7/1575 where there is a patch that
> allows, at least from what it looks like at a first glance, fixed
> files with io_close_prep but seems that the email thread died there.
>
> Shouldn't the close op match the behaviour of the other I/O related
> ops when it comes to fds?
>
> If there aren't specific reasons, happy to look into it and write a patch.
>
>
> Thanks,
> Daniele
