Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841533B9440
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhGAPt0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 11:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbhGAPt0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 11:49:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28C6C061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 08:46:55 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l24so9062981edr.11
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 08:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oedd2vERiW1FEwOPeX/VtER+5Q4+xm9mSufMWyyMB4w=;
        b=mOKhF7UTcuif0aKOa+ZrYx6jRr1LqkT+qYMTS3CVhpK+yHLm7FUTd4P2HN4FTCC2R1
         jLLqFmABUBSRMp/K/jjm1jffnmpZJars6EWa5S9qCAx0HQyyTSxUFJACv17z2PuCyDiT
         pOu3D/roFSEzan9JB7zHiFZJ/QvHL4tgsVRa0UBAnXxYU459C7Aa2qV32oXB3pfBCTcr
         FYj+fdWSObC4RqTzAJjGL9iJIXpdJxdb0rTZquhX//YSETjjcu8px8g3BsYTHaYgQdPZ
         O3z+coeCMAmjCC3b400S94oR5CEz8qYXkJy8uryvmGOwZdvqUNKSOyWT8trTxh+rg3xk
         QL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oedd2vERiW1FEwOPeX/VtER+5Q4+xm9mSufMWyyMB4w=;
        b=UY6FgRRWNlmDw8R4+erm62dXuJzcbl6cqLu0E12tIBtVcjbcBB/m8Yk9nOfJPPXOOQ
         6M9BVd/MkT8FtW+KSWPbjRqSmKCb+YTulYrwQKM2mdyyI49kkcRQ0KRqZRODqdp03SK2
         TmdmTSwgDyPdPDs/vl2Ni9sSbjWf+2C4pA2BGB8GQlV4jmQdeBGfQ867Ou/I1ry7Erbl
         6gUWn2DWTHHeRotmgmHeXd56b0N6QfYTmgB1CqGJt7EjvJ8lh/i5GaazaW1ouIS6wHNe
         EbuPzPh3TXanhPIZ8g9TTRUP5YK5zR+YtF75PNcjgUNlltAJImeivby2+BQ9pmAH/EGM
         8N6g==
X-Gm-Message-State: AOAM532N3YmvC0amMLmYySgTvd0pVxdBOPps868dF5eZF9YOpG5YEsbf
        psDzk0LpuOr6USnhJeeVGKs56NXB/QkJ9/9ZAtMxcQ==
X-Google-Smtp-Source: ABdhPJxbHKIzBXvn9k+HWJF4vAaEwSHQMpwYysnmMp63qx07A2+Ytg4pkW7k/Euz4S2Uuw/5I4aWu+H3sySOWHxWCfA=
X-Received: by 2002:a05:6402:524d:: with SMTP id t13mr604375edd.303.1625154414489;
 Thu, 01 Jul 2021 08:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwgU2V0RsE+77mRUg+mr6WL5PJpbFKh4FrEGOnfzZ5vZ3A@mail.gmail.com>
 <5201d747-121d-4e5e-d2a6-9442a5e4c534@gmail.com>
In-Reply-To: <5201d747-121d-4e5e-d2a6-9442a5e4c534@gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Thu, 1 Jul 2021 16:46:41 +0100
Message-ID: <CAM1kxwgEZ1bPMGgJixqQPVm4AP84xwYU8zrPOohvGp9nCQPpZg@mail.gmail.com>
Subject: Re: [Bug] io_uring_register_files_update broken
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 1, 2021 at 3:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
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
> >
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
>
> s/fds/&fds[sockfd]/
>
> Does it help? io_uring_register_files_update() doesn't
> apply offset parameter to the array, it's used only as
> an internal index.

i see yes, it works it like this!

io_uring_register_files_update(&ring, fd, &(socketfds[fd]), 1);
io_uring_register_files_update(&ring, fd, &(socketfds[fd] = -1), 1);

and this behavior is clear upon a closer reading of...
https://github.com/axboe/liburing/blob/11f6d56302c177a96d7eb1df86995939a4feb736/test/file-register.c#L80

i guess it's sometimes ambiguous whether int* is requesting an array
or an actual pointer to a single int.

all good now.

>
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
