Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC48F16AA7C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgBXPug (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:50:36 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38825 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBXPuf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:50:35 -0500
Received: by mail-oi1-f194.google.com with SMTP id r137so9357077oie.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4jqimHHl7YJeuqQncihJlZ/Iiqu4dvdOSsZADjFQM90=;
        b=P4rDwT4L7t55QsGhyEXziBc7l6QMLok9M04TCgIrXyLS1tP2toMkBMQKsvRCxdNAP4
         5FMDJU53BnSBCQcn6TZM8P3J5cf5xDBdOuTr7VeAu3e+9t3eTxhpbTV4SgkFIq+5pbC3
         uoIJSUXZkCAQNZXLzPiEIzvn5BXBtsPdiVCnpdizc5AA3y/dA7R0rbWzswES7O6RJrMK
         TbN6+RJ0fE51xqchtb6pFdeeVfCU0Z2GAgZwXGLGTiD2UnQwgRA91cqKQd6vzNed490y
         dHD56lQ9S57G3BVu1tKQom5tUMEpWNcYYMlTL0f9NPpNv9EHeF2VQ48d2PFPtEu+cwyP
         4xgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4jqimHHl7YJeuqQncihJlZ/Iiqu4dvdOSsZADjFQM90=;
        b=EDbVgNaQ12SjpbURPtWjej4RGWV0+Qv7tVPn71xHIPFkiQcKfW+Yee8I/76ZsscJqE
         00AKw2AqNOI8RUFmDpWZUxnbYh1p7tQ7qwjOwvr7Ghfw2VymKs3m3lK3xxW6oclj+dRh
         mjT6ofn6diTb9ngUHjILMeJG+YkV96GCUsKcLOUyITtz3GWgfQ8xTPnPWYW5rj5KrtPK
         xaiAqMPIQLHse3VQQbfGrFQy4H5PtC+Otc8aPeGrnKJJZVkwwqCXRhLtgk2qA3rHGwQs
         J6jOGQNgg6QPsNkCzZomUWRYqBK86LbUKBhwQeNvZvMYMaqUbKR9hbkT3+wuwyCtK64P
         LN5w==
X-Gm-Message-State: APjAAAUa9BmWbX2jIQBr9PbKUGojXqjUQHnMobYqD1cGHhWPNxZkrEnJ
        vfDk5/0c6ialqchz6XEF9hn3mCEhxdWSTch0LYK6VQ==
X-Google-Smtp-Source: APXvYqw+km4ePBcI1Ze+DovS2eMkVsV2SftZtzYy9SEJgx1vEVlE+p12/yAuV/vsU6YEuWmRT1apdj12w0hfqiLu9KE=
X-Received: by 2002:a05:6808:8d0:: with SMTP id k16mr12935411oij.68.1582559434909;
 Mon, 24 Feb 2020 07:50:34 -0800 (PST)
MIME-Version: 1.0
References: <20200224025607.22244-1-axboe@kernel.dk> <20200224025607.22244-4-axboe@kernel.dk>
In-Reply-To: <20200224025607.22244-4-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 24 Feb 2020 16:50:07 +0100
Message-ID: <CAG48ez2UDoAOnGaVzXkdZGikc+=0mreMD=57LoGf6bG6uRh6hw@mail.gmail.com>
Subject: Re: [PATCH 3/3] io_uring: support buffer selection
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>, andres@anarazel.de
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 24, 2020 at 3:56 AM Jens Axboe <axboe@kernel.dk> wrote:
[...]
> With IORING_OP_PROVIDE_BUFFER, an application can register buffers to
> use for any request. The request then sets IOSQE_BUFFER_SELECT in the
> sqe, and a given group ID in sqe->buf_group. When the fd becomes ready,
> a free buffer from the specified group is selected. If none are
> available, the request is terminated with -ENOBUFS. If successful, the
> CQE on completion will contain the buffer ID chosen in the cqe->flags
> member, encoded as:
[...]
> +static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
> +                                         void *buf)
> +{
> +       struct list_head *list;
> +       struct io_buffer *kbuf;
> +
> +       if (req->flags & REQ_F_BUFFER_SELECTED)
> +               return buf;
> +
> +       list = idr_find(&req->ctx->io_buffer_idr, gid);
> +       if (!list || list_empty(list))
> +               return ERR_PTR(-ENOBUFS);
> +
> +       kbuf = list_first_entry(list, struct io_buffer, list);
> +       list_del(&kbuf->list);
> +       return kbuf;
> +}

This function requires some sort of external locking, right? Since
it's removing an entry from a list.

[...]
> +static struct io_buffer *io_send_recv_buffer_select(struct io_kiocb *req,
> +                                                   struct io_buffer **kbuf,
> +                                                   int *cflags)
> +{
> +       struct io_sr_msg *sr = &req->sr_msg;
> +
> +       if (!(req->flags & REQ_F_BUFFER_SELECT))
> +               return req->sr_msg.buf;
> +
> +       *kbuf = io_buffer_select(req, sr->gid, sr->kbuf);

But we use it here in io_send_recv_buffer_select(), not taking any
extra locks before calling it...

> +       if (IS_ERR(*kbuf))
> +               return *kbuf;
> +
> +       sr->kbuf = *kbuf;
> +       if (sr->len > (*kbuf)->len)
> +               sr->len = (*kbuf)->len;
> +       req->flags |= REQ_F_BUFFER_SELECTED;
> +
> +       *cflags = (*kbuf)->bid << IORING_CQE_BUFFER_SHIFT;
> +       *cflags |= IORING_CQE_F_BUFFER;
> +       return u64_to_user_ptr((*kbuf)->addr);
> +}
> +
>  static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
>                    bool force_nonblock)
>  {
>  #if defined(CONFIG_NET)
> +       struct io_buffer *kbuf = NULL;
>         struct socket *sock;
> -       int ret;
> +       int ret, cflags = 0;
>
>         if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>                 return -EINVAL;
> @@ -3217,9 +3323,16 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
>                 struct io_sr_msg *sr = &req->sr_msg;
>                 struct msghdr msg;
>                 struct iovec iov;
> +               void __user *buf;
>                 unsigned flags;
>
> -               ret = import_single_range(WRITE, sr->buf, sr->len, &iov,
> +               buf = io_send_recv_buffer_select(req, &kbuf, &cflags);

... and call io_send_recv_buffer_select() from here without holding
any extra locks in this function. This function is then called from
io_issue_sqe() (no extra locks held there either), which is called
from __io_queue_sqe() (no extra locks AFAICS), which is called from
places like task work.

Am I missing something?

It might in general be helpful to have more lockdep assertions in this
code, both to help the reader understand the locking rules and to help
verify locking correctness.
