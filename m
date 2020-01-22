Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E231459A5
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 17:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgAVQVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 11:21:01 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35715 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVQVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 11:21:01 -0500
Received: by mail-ot1-f68.google.com with SMTP id i15so6798021oto.2
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 08:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dmI3giScWK0hAcx6XhcuOxJcaxJiTzzztsj6uMOL9UM=;
        b=r78Pgsde9wT9/51gi5zsXtJIYKfaLG9jufzRwXm1JuHe4KJgL+u0UR7RTQCHMD6weo
         ckJouuVwiECPkSwCn1++YpVXaStNTojs1TKydpxSTRvgAqZuS51/O40sh9C8GAEdmjnG
         rvuUtivJ1H/vzyOiPYvY5fMErPoAaI4ZtFtCme7CnmpZrWmrGnntdXEYV1au/GNeeyFD
         jFTKMm5yftmUp6EhdWC9oUh6jx1AMH/stcRVDjB5EmPie/tCTTsAfAeSyhEZsQhnMoe6
         XS8xWU+wQBCNyVRij12u/jxWBIB10tQGc2dpjZ8bpaDJV30hJWI5GJk34aXmd3VGhZCk
         2gXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dmI3giScWK0hAcx6XhcuOxJcaxJiTzzztsj6uMOL9UM=;
        b=AjeGI13vwYUsGPJJvblIXnchgmttqp/t1ubmYJIn3SUqFZIv7flczepbO0IGe1b6nV
         y1nKPCP3MeVsDWERROdXWZJqCffGlXytNU1cBAmGx3H5ubV7dFo7mHh5NlrTC9OVDPyS
         M4uJEUnev3DZi0I/HjX64k465Ht3Std9QecOxbvsTHEWIOj6AxiJevrNAMuFaz5o2GJq
         Tc3nPAqQQVHSrE5iKOMXyWB5OGmXIwpXrRzvpZc037p7TPZuEmsKqeZMFqKNaIhcV+8E
         n6HwMQCNv02mI34MKGVlpzDpGs9fgyK/TRaR0vbv/9jxU/ObCYVFhRllPKQKw/AlX2FB
         x8Jg==
X-Gm-Message-State: APjAAAVmjEgr/6aLmPw+RrRWbhpRG7RjedL/AdBNf7eO2/dJdozJGKyV
        vd38jLzRJl+msvNJktm3c6I2ku0dKySRxkUX8a25nA==
X-Google-Smtp-Source: APXvYqyO0iaPZQF/ygonA8LD39Ae2U+2cHHBZaw9cR5/uRsGCUyqUhghuPYgGd875B7ngRFetX2h8wuVdOerOPRAWds=
X-Received: by 2002:a05:6830:44e:: with SMTP id d14mr7597274otc.228.1579710060193;
 Wed, 22 Jan 2020 08:21:00 -0800 (PST)
MIME-Version: 1.0
References: <20200122160231.11876-1-axboe@kernel.dk> <20200122160231.11876-3-axboe@kernel.dk>
In-Reply-To: <20200122160231.11876-3-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 22 Jan 2020 17:20:33 +0100
Message-ID: <CAG48ez0+wiY4i0nFFXpKvqpQDNYQvzHAJhAMVD0rv5cpEicWkw@mail.gmail.com>
Subject: Re: [PATCH 2/3] eventpoll: support non-blocking do_epoll_ctl() calls
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 22, 2020 at 5:02 PM Jens Axboe <axboe@kernel.dk> wrote:
> Also make it available outside of epoll, along with the helper that
> decides if we need to copy the passed in epoll_event.
[...]
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index cd848e8d08e2..162af749ea50 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
[...]
> -static int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds)
> +static inline int epoll_mutex_lock(struct mutex *mutex, int depth,
> +                                  bool nonblock)
> +{
> +       if (!nonblock) {
> +               mutex_lock_nested(mutex, depth);
> +               return 0;
> +       }
> +       if (!mutex_trylock(mutex))
> +               return 0;
> +       return -EAGAIN;

The documentation for mutex_trylock() says:

 * Try to acquire the mutex atomically. Returns 1 if the mutex
 * has been acquired successfully, and 0 on contention.

So in the success case, this evaluates to:

    if (!1)
      return 0;
    return -EAGAIN;

which is

    if (0)
      return 0;
    return -EAGAIN;

which is

    return -EAGAIN;

I think you'll have to get rid of the negation.

> +}
> +
> +int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
> +                bool nonblock)
>  {
>         int error;
>         int full_check = 0;
> @@ -2145,13 +2152,17 @@ static int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds)
>          * deep wakeup paths from forming in parallel through multiple
>          * EPOLL_CTL_ADD operations.
>          */
> -       mutex_lock_nested(&ep->mtx, 0);
> +       error = epoll_mutex_lock(&ep->mtx, 0, nonblock);
> +       if (error)
> +               goto error_tgt_fput;
>         if (op == EPOLL_CTL_ADD) {
>                 if (!list_empty(&f.file->f_ep_links) ||
>                                                 is_file_epoll(tf.file)) {
>                         full_check = 1;
>                         mutex_unlock(&ep->mtx);
> -                       mutex_lock(&epmutex);
> +                       error = epoll_mutex_lock(&epmutex, 0, nonblock);
> +                       if (error)
> +                               goto error_tgt_fput;

When we reach the "goto", full_check==1 and epmutex is not held. But
at the jump target, this code runs:

error_tgt_fput:
  if (full_check) // true
    mutex_unlock(&epmutex);

So I think we're releasing a lock that we don't hold.

>                         if (is_file_epoll(tf.file)) {
>                                 error = -ELOOP;
>                                 if (ep_loop_check(ep, tf.file) != 0) {
> @@ -2161,10 +2172,17 @@ static int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds)
>                         } else
>                                 list_add(&tf.file->f_tfile_llink,
>                                                         &tfile_check_list);
> -                       mutex_lock_nested(&ep->mtx, 0);
> +                       error = epoll_mutex_lock(&ep->mtx, 0, nonblock);
> +                       if (error) {
> +out_del:
> +                               list_del(&tf.file->f_tfile_llink);
> +                               goto error_tgt_fput;
> +                       }
>                         if (is_file_epoll(tf.file)) {
>                                 tep = tf.file->private_data;
> -                               mutex_lock_nested(&tep->mtx, 1);
> +                               error = epoll_mutex_lock(&tep->mtx, 1, nonblock);
> +                               if (error)
> +                                       goto out_del;

When we reach this "goto", ep->mtx is held and never dropped.

>                         }
>                 }
>         }
> @@ -2233,7 +2251,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>             copy_from_user(&epds, event, sizeof(struct epoll_event)))
>                 return -EFAULT;
>
> -       return do_epoll_ctl(epfd, op, fd, &epds);
> +       return do_epoll_ctl(epfd, op, fd, &epds, false);
>  }
