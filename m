Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8684543057D
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 00:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241058AbhJPWyk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 18:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240998AbhJPWyk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 18:54:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69433C061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 15:52:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so4525560pjd.1
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 15:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sr7OWoyQkEYfrcWhL4M0/kueciLZMTtqenaqCF6E9Xg=;
        b=gJkE6cloB4J4MIugg6mX7fO3MfZIHhNT8WIgxynt3uiMFWlhpPEemvR5sfUTAcZQRL
         fnQWjqQFtdR0qpJ5NYD5gH0WSj3JrJ+FUQOe6iNsL6rZ+s6W5U6t1R03G9nbgVRng4Ft
         1HwRlfHJ4P+zFC34/Vo731af90VNI3345eHODzmHZOBIPJtX2zN3k02Mx7l+uRJSIae5
         DlLzlD6xAdgPbDOn44bcy4C5SDsHwJqs42UqK+RzxTqCJkQngZG/2taAAnysyBcFj0wB
         CLnZJReaGoJ7wPWFhqCuxCS/qsWIR1Q4YNeDR/7VJBKAkVEWvd7wGScxRaTEkJZtr2Oh
         VDhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sr7OWoyQkEYfrcWhL4M0/kueciLZMTtqenaqCF6E9Xg=;
        b=TSq0jbCIpjJDp4XZBDE1szdWCbdR6LV/YDuvZj/we/JEeFoHOGPfqSRN2vcw7I0G16
         z8o4WMH2yNU7H1saHUv70Wfa2FSJNhCsHXENyOXAxiTqU7NZfxzR+ZNb11e38S30ynBS
         dYrlq1Slxf0tSGMvtWDBpu+5VBYi4zotrjhDOJsua/9GvF29lHnjkmktCbDSPyUefHzw
         MhgELzOXGsefAGgQbllYTd9V+Qpant3mq8XllusemO6WzyQh1dz2q0RwYNPm4771ZmAv
         Ny7zo4dgLNZ3o9UomHqZNxrJXxbeYzaTb43xc1j1b23MuZkPuT7KgIvTw22rciS4su10
         UJvg==
X-Gm-Message-State: AOAM533h1UqQPpGHWmOAAoxQ0qI/MhPTP9AATrDQYyIkv5VMZ74d7QpW
        YefypUIM/kPSVls0GaGF4a4FXkV20VEpQtuGq8AnkT1Ww68=
X-Google-Smtp-Source: ABdhPJwLQiZM07CE1Ck1+sKFYymBYibHSmiG6gLFsorCYDIZp5IsMDL9nDVazRBxecl4vuGeGeFrhbOsUXWKnT5D0uE=
X-Received: by 2002:a17:902:8d8b:b0:138:e09d:d901 with SMTP id
 v11-20020a1709028d8b00b00138e09dd901mr19076017plo.34.1634424750568; Sat, 16
 Oct 2021 15:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634144845.git.asml.silence@gmail.com> <2c2536c5896d70994de76e387ea09a0402173a3f.1634144845.git.asml.silence@gmail.com>
In-Reply-To: <2c2536c5896d70994de76e387ea09a0402173a3f.1634144845.git.asml.silence@gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Sat, 16 Oct 2021 17:52:19 -0500
Message-ID: <CAFUsyfKyRnXhcxOVfSAxeyKsQqGXJ7PdDYw3TXC3H+q_yp5LMA@mail.gmail.com>
Subject: Re: [PATCH 8/8] io_uring: rearrange io_read()/write()
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     "open list:IO_URING" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 14, 2021 at 10:13 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> Combine force_nonblock branches (which is already optimised by
> compiler), flip branches so the most hot/common path is the first, e.g.
> as with non on-stack iov setup, and add extra likely/unlikely
> attributions for errror paths.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 75 +++++++++++++++++++++++++--------------------------
>  1 file changed, 37 insertions(+), 38 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f9af54b10238..8bbbe7ccad54 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3395,7 +3395,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
>
>  static inline int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
>  {
> -       if (req->file->f_op->read_iter)
> +       if (likely(req->file->f_op->read_iter))
>                 return call_read_iter(req->file, &req->rw.kiocb, iter);
>         else if (req->file->f_op->read)
>                 return loop_rw_iter(READ, req, iter);
> @@ -3411,14 +3411,18 @@ static bool need_read_all(struct io_kiocb *req)
>
>  static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  {
> -       struct io_rw_state __s, *s;
> +       struct io_rw_state __s, *s = &__s;
>         struct iovec *iovec;
>         struct kiocb *kiocb = &req->rw.kiocb;
>         bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>         struct io_async_rw *rw;
>         ssize_t ret, ret2;
>
> -       if (req_has_async_data(req)) {
> +       if (!req_has_async_data(req)) {
> +               ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
> +               if (unlikely(ret < 0))
> +                       return ret;
> +       } else {
>                 rw = req->async_data;
>                 s = &rw->s;
>                 /*
> @@ -3428,24 +3432,19 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>                  */
>                 iov_iter_restore(&s->iter, &s->iter_state);
>                 iovec = NULL;
> -       } else {
> -               s = &__s;
> -               ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
> -               if (unlikely(ret < 0))
> -                       return ret;
>         }
>         req->result = iov_iter_count(&s->iter);
>
> -       /* Ensure we clear previously set non-block flag */
> -       if (!force_nonblock)
> -               kiocb->ki_flags &= ~IOCB_NOWAIT;
> -       else
> +       if (force_nonblock) {
> +               /* If the file doesn't support async, just async punt */
> +               if (unlikely(!io_file_supports_nowait(req, READ))) {
> +                       ret = io_setup_async_rw(req, iovec, s, true);
> +                       return ret ?: -EAGAIN;
> +               }
>                 kiocb->ki_flags |= IOCB_NOWAIT;
> -
> -       /* If the file doesn't support async, just async punt */
> -       if (force_nonblock && !io_file_supports_nowait(req, READ)) {
> -               ret = io_setup_async_rw(req, iovec, s, true);
> -               return ret ?: -EAGAIN;
> +       } else {
> +               /* Ensure we clear previously set non-block flag */
> +               kiocb->ki_flags &= ~IOCB_NOWAIT;
>         }
>
>         ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
> @@ -3541,40 +3540,40 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>
>  static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  {
> -       struct io_rw_state __s, *s;
> -       struct io_async_rw *rw;
> +       struct io_rw_state __s, *s = &__s;
>         struct iovec *iovec;
>         struct kiocb *kiocb = &req->rw.kiocb;
>         bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>         ssize_t ret, ret2;
>
> -       if (req_has_async_data(req)) {
> -               rw = req->async_data;
> -               s = &rw->s;
> -               iov_iter_restore(&s->iter, &s->iter_state);
> -               iovec = NULL;
> -       } else {
> -               s = &__s;
> +       if (!req_has_async_data(req)) {
>                 ret = io_import_iovec(WRITE, req, &iovec, s, issue_flags);
>                 if (unlikely(ret < 0))
>                         return ret;
> +       } else {
> +               struct io_async_rw *rw = req->async_data;
> +
> +               s = &rw->s;
> +               iov_iter_restore(&s->iter, &s->iter_state);
> +               iovec = NULL;
>         }
>         req->result = iov_iter_count(&s->iter);
>
> -       /* Ensure we clear previously set non-block flag */
> -       if (!force_nonblock)
> -               kiocb->ki_flags &= ~IOCB_NOWAIT;
> -       else
> -               kiocb->ki_flags |= IOCB_NOWAIT;
> +       if (force_nonblock) {
> +               /* If the file doesn't support async, just async punt */
> +               if (unlikely(!io_file_supports_nowait(req, WRITE)))
> +                       goto copy_iov;
>
> -       /* If the file doesn't support async, just async punt */
> -       if (force_nonblock && !io_file_supports_nowait(req, WRITE))
> -               goto copy_iov;
> +               /* file path doesn't support NOWAIT for non-direct_IO */
> +               if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&

You can drop this 'force_nonblock' no?

> +                   (req->flags & REQ_F_ISREG))
> +                       goto copy_iov;
>
> -       /* file path doesn't support NOWAIT for non-direct_IO */
> -       if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
> -           (req->flags & REQ_F_ISREG))
> -               goto copy_iov;
> +               kiocb->ki_flags |= IOCB_NOWAIT;
> +       } else {
> +               /* Ensure we clear previously set non-block flag */
> +               kiocb->ki_flags &= ~IOCB_NOWAIT;
> +       }
>
>         ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
>         if (unlikely(ret))

...

What swapping order of conditions below:
if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)

The ret2 check will almost certainly be faster than 2x deref.
> --
> 2.33.0
>
