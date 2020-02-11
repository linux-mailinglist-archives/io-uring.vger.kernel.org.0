Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FEA1599AB
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 20:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgBKTYK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 14:24:10 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37361 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbgBKTYK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 14:24:10 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so7863893lfc.4
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 11:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gb6ZVZK/pk0PW0Ja0llRUaw1xivPSA+eVsfVrs0Q2eg=;
        b=ANUmp5D/s7AofGriD49VsqKSlQiIDMa5TxcJ8W11y3HOeUusLA6+Z2/WA275jEu60C
         RkfW6V7oXWWSANh+O+8GmIs8TI0P3p3okUslk8MQy5qxPG4mlpthDjjLCPrhGQGzANim
         Uba1bRSic9id0JFbKLqd1z8k8UlrUz2kxlXjZdnuujneAYWvQyO/u5Ti+wjks8WR02G1
         zhb3ckN9tC9zu9j4OCxRpXzMuu9sSawB2HI3RcVIvOwZS9lm5MH4SDMOtyrOOGHa54vR
         MwoDX1MLX5AYsMpeCXYmcXcLiefhEY2Nc35wo8lBFHH/oUvT3HvzShut0XN9c++YBBS3
         D0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gb6ZVZK/pk0PW0Ja0llRUaw1xivPSA+eVsfVrs0Q2eg=;
        b=Zl6O0PbfJ4wTZwhw/5U02R1k0XgFBlulNe0hladc7rutvfznnhXRpphTt5ut/p7Ftt
         6175aFR2upRHxsXFrJ0sH6WwcsVQMDe0h+U4A7lQOsJfgb00PfraPy6UFsLI1nQ6/C7u
         IPxF9NTIH8FTaR2eqOfR6q2SgnNT/rZnDMKG1qtQMaFIyrmpAApg+ebdEOeYdwQrxzBc
         fZ2nbIi2cZkwlciXDwCPGBMzNfGS37uKsidNXgUtwseABF3KR7KmVR1gmjecX4LD+Zx0
         DVZB66aVWsG9Cfu+roNNNa7y0/b90fgSIXuMYplwT/3zT9/XC7wZaU4pGhAyLzEWyJD4
         kiDg==
X-Gm-Message-State: APjAAAXdkmavsNWF5o3deZvAB4J7Y0xrfTTEx6ab1JhZzDtxboUNTKgy
        0G7+03KUzySox676NG5U6Pr99vCMeVBkAZJ9iXgV06bfTlA=
X-Google-Smtp-Source: APXvYqyZuueyjkCAEaIRr5S/TrZjnO7s0cyh7pPy/erEFOgnSfgkPbp1v7VXiAEf9gm1QVake/3YMOfo9iDFA8MboSU=
X-Received: by 2002:a19:c014:: with SMTP id q20mr4494326lff.208.1581449047540;
 Tue, 11 Feb 2020 11:24:07 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
 <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk> <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
 <c192d9b8-fab9-1c29-7266-acd48b380338@kernel.dk> <CAD-J=zYUCFG=RTf=d98sBD=M4yg+i=qag2X9JxFa-KW0Un19Qw@mail.gmail.com>
 <059cfdbf-bcfe-5680-9b0a-45a720cf65c5@kernel.dk>
In-Reply-To: <059cfdbf-bcfe-5680-9b0a-45a720cf65c5@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Tue, 11 Feb 2020 14:23:56 -0500
Message-ID: <CAD-J=zYfbtQaGy8KatprCPdzrKTg3sbHp6Vc2D8Y+mK2G08s4A@mail.gmail.com>
Subject: Re: Kernel BUG when registering the ring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tested-by: Glauber Costa <glauber@scylladb.com>

On Tue, Feb 11, 2020 at 1:58 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/11/20 6:01 AM, Glauber Costa wrote:
> > This works.
>
> Can you try this one as well?
>
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 182aa17dc2ca..2d741fb76098 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -699,11 +699,16 @@ static int io_wq_manager(void *data)
>         /* create fixed workers */
>         refcount_set(&wq->refs, workers_to_create);
>         for_each_node(node) {
> +               if (!node_online(node))
> +                       continue;
>                 if (!create_io_worker(wq, wq->wqes[node], IO_WQ_ACCT_BOUND))
>                         goto err;
>                 workers_to_create--;
>         }
>
> +       while (workers_to_create--)
> +               refcount_dec(&wq->refs);
> +
>         complete(&wq->done);
>
>         while (!kthread_should_stop()) {
> @@ -711,6 +716,9 @@ static int io_wq_manager(void *data)
>                         struct io_wqe *wqe = wq->wqes[node];
>                         bool fork_worker[2] = { false, false };
>
> +                       if (!node_online(node))
> +                               continue;
> +
>                         spin_lock_irq(&wqe->lock);
>                         if (io_wqe_need_worker(wqe, IO_WQ_ACCT_BOUND))
>                                 fork_worker[IO_WQ_ACCT_BOUND] = true;
> @@ -849,6 +857,8 @@ void io_wq_cancel_all(struct io_wq *wq)
>         for_each_node(node) {
>                 struct io_wqe *wqe = wq->wqes[node];
>
> +               if (!node_online(node))
> +                       continue;
>                 io_wq_for_each_worker(wqe, io_wqe_worker_send_sig, NULL);
>         }
>         rcu_read_unlock();
> @@ -929,6 +939,8 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
>         for_each_node(node) {
>                 struct io_wqe *wqe = wq->wqes[node];
>
> +               if (!node_online(node))
> +                       continue;
>                 ret = io_wqe_cancel_cb_work(wqe, cancel, data);
>                 if (ret != IO_WQ_CANCEL_NOTFOUND)
>                         break;
> @@ -1021,6 +1033,8 @@ enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
>         for_each_node(node) {
>                 struct io_wqe *wqe = wq->wqes[node];
>
> +               if (!node_online(node))
> +                       continue;
>                 ret = io_wqe_cancel_work(wqe, &match);
>                 if (ret != IO_WQ_CANCEL_NOTFOUND)
>                         break;
> @@ -1050,6 +1064,8 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
>         for_each_node(node) {
>                 struct io_wqe *wqe = wq->wqes[node];
>
> +               if (!node_online(node))
> +                       continue;
>                 ret = io_wqe_cancel_work(wqe, &match);
>                 if (ret != IO_WQ_CANCEL_NOTFOUND)
>                         break;
> @@ -1084,6 +1100,8 @@ void io_wq_flush(struct io_wq *wq)
>         for_each_node(node) {
>                 struct io_wqe *wqe = wq->wqes[node];
>
> +               if (!node_online(node))
> +                       continue;
>                 init_completion(&data.done);
>                 INIT_IO_WORK(&data.work, io_wq_flush_func);
>                 data.work.flags |= IO_WQ_WORK_INTERNAL;
> @@ -1115,12 +1133,15 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
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
> @@ -1128,7 +1149,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>                                         task_rlimit(current, RLIMIT_NPROC);
>                 }
>                 atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
> -               wqe->node = node;
>                 wqe->wq = wq;
>                 spin_lock_init(&wqe->lock);
>                 INIT_WQ_LIST(&wqe->work_list);
> @@ -1184,8 +1204,11 @@ static void __io_wq_destroy(struct io_wq *wq)
>                 kthread_stop(wq->manager);
>
>         rcu_read_lock();
> -       for_each_node(node)
> +       for_each_node(node) {
> +               if (!node_online(node))
> +                       continue;
>                 io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
> +       }
>         rcu_read_unlock();
>
>         wait_for_completion(&wq->done);
>
> --
> Jens Axboe
>
