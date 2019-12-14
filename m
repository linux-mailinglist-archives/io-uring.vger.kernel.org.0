Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68F911F2E9
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 18:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfLNRMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 12:12:31 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45334 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfLNRMb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 12:12:31 -0500
Received: by mail-ot1-f66.google.com with SMTP id 59so3212611otp.12
        for <io-uring@vger.kernel.org>; Sat, 14 Dec 2019 09:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LfuFNZhwpZHLnF3djKVjiT3EXeRjqk5hTlCJtr0Ug00=;
        b=TlCmN7o1+fMNUBHz9erkJfWUoUdU6UO2mLwWb8l2OezOxScfm59l9mw928OPcn/yBa
         Xhl+xxt7CRSQs9M26xhDkm0qpkDohbNZy5JaN5ECOL9h9XnMmCPoEBL1boRtojpbvgrc
         Ght8Wj+dD1eb0lSCrS3fpEAdVkxj2pV3eVXKkOg2ENf8l6nkaINwPxGpfnRGOwnquFZc
         pL+qz0HFXn0mlj4DE6458MEirDfF3fb7wxRjGscI3mH4+5qfrIvYwDZFGFMHTIVinPJ6
         SeqqPws1nPIVuGyx08gfwwZCFxeSIBu8z58WeOa3KajNbYjPAgDuhFKblJLY/acUYb2P
         EJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LfuFNZhwpZHLnF3djKVjiT3EXeRjqk5hTlCJtr0Ug00=;
        b=MjsIY/0k0crflGkCbcLOPq7TMRBd/08bHUneLhkbf4+++12PSs3Uux4XVt7YI80eQS
         0NxTyH2NDHf6vZ9OE+c5oWmlPZ7TIuxQ1JKaWaHRjoD5EsbL3ZMO36FoHWRyOPdl4IaP
         NEds+EpVjL/8HJLbjBD44PDuOcBA9tWqkvvNJsvJGTpKAYURbw1CRALSB95MAXyBPTBV
         +uhWNyMbpoyMYqNZ1Xz9YWvj+f3HICygi8Hdp1Xl3CALIZ3y1+yOZEW/Hb1L92Z3rLfK
         usx2SVVpy+FhVgo/aXMT20GlHoB6NAQlDnM5BkUZjkn7lq/WkPpy6ZfqCGrIu5Ca5Zj5
         DMhQ==
X-Gm-Message-State: APjAAAXAyxnhhi7sErabrTHildFtKCcyyUiu6d2CzNTsZSf2yEnIb/mx
        sy7pjPlewD8JEl0AXWf1tb/WqOWEG32xbRGVPnvjkBMYIWA=
X-Google-Smtp-Source: APXvYqwwTQGCvVFuCI2TTbbAbQLnslTRGC4VFL+IaeZvnsp8ao1oG8F9eYiooFOo0Htw4V8HHQU3yDHWMVglPTU+OSw=
X-Received: by 2002:a9d:4789:: with SMTP id b9mr22242455otf.110.1576343549895;
 Sat, 14 Dec 2019 09:12:29 -0800 (PST)
MIME-Version: 1.0
References: <f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com>
In-Reply-To: <f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 14 Dec 2019 18:12:03 +0100
Message-ID: <CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com>
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_IOCTL
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Dec 14, 2019 at 4:30 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> This works almost like ioctl(2), except it doesn't support a bunch of
> common opcodes, (e.g. FIOCLEX and FIBMAP, see ioctl.c), and goes
> straight to a device specific implementation.
>
> The case in mind is dma-buf, drm and other ioctl-centric interfaces.
>
> Not-yet Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>
> It clearly needs some testing first, though works fine with dma-buf,
> but I'd like to discuss whether the use cases are convincing enough,
> and is it ok to desert some ioctl opcodes. For the last point it's
> fairly easy to add, maybe except three requiring fd (e.g. FIOCLEX)
>
> P.S. Probably, it won't benefit enough to consider using io_uring
> in drm/mesa, but anyway.
[...]
> +static int io_ioctl(struct io_kiocb *req,
> +                   struct io_kiocb **nxt, bool force_nonblock)
> +{
> +       const struct io_uring_sqe *sqe = req->sqe;
> +       unsigned int cmd = READ_ONCE(sqe->ioctl_cmd);
> +       unsigned long arg = READ_ONCE(sqe->ioctl_arg);
> +       int ret;
> +
> +       if (!req->file)
> +               return -EBADF;
> +       if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +               return -EINVAL;
> +       if (unlikely(sqe->ioprio || sqe->addr || sqe->buf_index
> +               || sqe->rw_flags))
> +               return -EINVAL;
> +       if (force_nonblock)
> +               return -EAGAIN;
> +
> +       ret = security_file_ioctl(req->file, cmd, arg);
> +       if (!ret)
> +               ret = (int)vfs_ioctl(req->file, cmd, arg);

This isn't going to work. For several of the syscalls that were added,
special care had to be taken to avoid bugs - like for RECVMSG, for the
upcoming OPEN/CLOSE stuff, and so on.

And in principle, ioctls handlers can do pretty much all of the things
syscalls can do, and more. They can look at the caller's PID, they can
open and close (well, technically that's slightly unsafe, but IIRC
autofs does it anyway) things in the file descriptor table, they can
give another process access to the calling process in some way, and so
on. If you just allow calling arbitrary ioctls through io_uring, you
will certainly get bugs, and probably security bugs, too.

Therefore, I would prefer to see this not happen at all; and if you do
have a usecase where you think the complexity is worth it, then I
think you'll have to add new infrastructure that allows each
file_operations instance to opt in to having specific ioctls called
via this mechanism, or something like that, and ensure that each of
the exposed ioctls only performs operations that are safe from uring
worker context.

Also, I'm not sure, but it might be a good idea to CC linux-api if you
continue working on this.
