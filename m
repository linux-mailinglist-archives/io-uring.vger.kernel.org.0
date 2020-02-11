Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972F1158F61
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 14:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgBKNBW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 08:01:22 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41050 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbgBKNBW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 08:01:22 -0500
Received: by mail-lj1-f194.google.com with SMTP id h23so11459814ljc.8
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 05:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cnZQZQRTdXOcI2Kx8IxwLX1Mue3RjA6QCtmyyVGO7Bg=;
        b=ijbMUm+rnGfu1C865ihBd2dpr1uauppQNYQWoDreW30vFyOYnC/JdXhgNUjA0v5K52
         osbAmd1TdmaRGAtHqBdem6A1v0YTTB38hYU9krE5MFORzbsu7diKUaBuI28WObK0wOvK
         wzCgLAV0SYe+fh4bZHqy+ogKxw8w2GaVOqhD67TDmBYFhPzHTDffZ9V+YAaNWK9HTHLc
         ud5B8zpX8FnZDZAmB10f6jgUVXZ54bHjCWyQpQHt7270Im4Jrr2b2n5rWCexd1AkhG/9
         KQYrC5TklerGKKVmXy6SVbKXC9Zqlj95V6xmMHlebwZGg8we+5I/wteHJ6YJRjmdNM1p
         II8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cnZQZQRTdXOcI2Kx8IxwLX1Mue3RjA6QCtmyyVGO7Bg=;
        b=uOtv2SEpsTJ2urekQEkApR6WOCD83knJ9xtyRofhSdZULRGKNJ7nn4FSCEhFAzG+fn
         Cx8Hrfb5kGi+W4i0Ah9A6qIMF3dIXUwrb6WECXdApNPyDZDGfKgks+hsItxt7LMQlcL0
         dV7wLF7aNgZULGwE+xoH1tWrjZl++jjZeEr2dxZc2gbQkH/jqEVNOQ+KKcdFB6Use5Zc
         qyTIMZU/sHrxcGUKui6pCxGGiHme7cspLDM896Ill522b1hYt+aTOXUaOS2KbLTweJIL
         nmZqo0ljMhG57aBLPxAdbmPCzuTkQHa9qeHVTRp3gMY80EHPaOFyLcP8aRL5+MpVdAH2
         HVaQ==
X-Gm-Message-State: APjAAAXxJFqM6BSLOTT2a4MOozoMOi57QsEF03BtMO2e5Wx7mgRQhVQJ
        r8K22YxpUUd8QeVgB0+RqqBlfU54zheDqCxyoPGf9Q==
X-Google-Smtp-Source: APXvYqwF6oASt/jlnUnGbEo6hswer7vrht6PpuqTLzvk/hMXNEitkoLVyefqcuEHJ/6isYGayoKC2I8sLGoFjkb3Sxc=
X-Received: by 2002:a2e:3514:: with SMTP id z20mr4129821ljz.261.1581426079389;
 Tue, 11 Feb 2020 05:01:19 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
 <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk> <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
 <c192d9b8-fab9-1c29-7266-acd48b380338@kernel.dk>
In-Reply-To: <c192d9b8-fab9-1c29-7266-acd48b380338@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Tue, 11 Feb 2020 08:01:08 -0500
Message-ID: <CAD-J=zYUCFG=RTf=d98sBD=M4yg+i=qag2X9JxFa-KW0Un19Qw@mail.gmail.com>
Subject: Re: Kernel BUG when registering the ring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This works.

Thanks

On Mon, Feb 10, 2020 at 10:50 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/10/20 8:45 PM, Glauber Costa wrote:
> > It crashes all the same
> >
> > New backtrace attached - looks very similar to the old one, although
> > not identical.
>
> I missed the other spot we do the same thing... Try this.
>
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 182aa17dc2ca..b8ef5a5483de 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -1115,12 +1116,15 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>
>         for_each_node(node) {
>                 struct io_wqe *wqe;
> +               int alloc_node = node;
>
> -               wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, node);
> +               if (!node_online(alloc_node))
> +                       alloc_node = NUMA_NO_NODE;
> +               wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
>                 if (!wqe)
>                         goto err;
>                 wq->wqes[node] = wqe;
> -               wqe->node = node;
> +               wqe->node = alloc_node;
>                 wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
>                 atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
>                 if (wq->user) {
> @@ -1128,7 +1132,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>                                         task_rlimit(current, RLIMIT_NPROC);
>                 }
>                 atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
> -               wqe->node = node;
>                 wqe->wq = wq;
>                 spin_lock_init(&wqe->lock);
>                 INIT_WQ_LIST(&wqe->work_list);
>
> --
> Jens Axboe
>
