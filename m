Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BFF25A235
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 02:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgIBAQX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 20:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBAQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 20:16:21 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D772C061244
        for <io-uring@vger.kernel.org>; Tue,  1 Sep 2020 17:16:21 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id k25so3693321ljg.9
        for <io-uring@vger.kernel.org>; Tue, 01 Sep 2020 17:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vfO5OccBriKqhFmmfkmf30IG3O/QcipjkkS5/OdbUK4=;
        b=mDLMZQNwrQqlRvUEls6d+aL7T/xZobyBDcEOOnkZq64sd9KdYcjasb0xYmoenvXUuO
         EcR/DkiyPNAKVRb4ROjlDmkjY3CRodL+JhsjMzVtKg+Dm0rmToCLHmohhsOcb0UDYABM
         /nww7koaQ+KjAnDEnA+jexBGVylZuu3VYicZmWaD2vUBkcIDy/E8AwO25Vc2RgobW88W
         t3073hdOqTQcNd85ch9ZAnD8D+FBkAufrJxnY0Mh4jO8DNMTesLiOjeUaOB6GIA3hleT
         utXrUgT4bUtFHYpPuwmRfth10WraBjDW7S3tO1BGwSxdy7krvirhRtPPu4UmiFRSC3iO
         OHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vfO5OccBriKqhFmmfkmf30IG3O/QcipjkkS5/OdbUK4=;
        b=ggt1gxrbWuIOw0cByO0XuuFdvGfdihk1LFRvZdD95XB/J3ZuKt0JmUHYLvF6gAj+Tz
         jfB3q8jL3UbqDsR2kNPi7zgy+kxuRDhlLAtY8jz9aggYDHJVvtWuqJmSy6SbRJ82GAX8
         vkRnYw+rGvj3JoUx3OK17ZR8K/oJhkwNVL+eDvxm4pZXEvmdJecYonfFc4X3KAkXWXZN
         msJz2LguhF9Mcvh6jlSmKe5hX5aJs1jouHy5+kN0wZ9jv1Kb9KHMpqtnQ/hJW9T1d3Ml
         BF/bZnReSBwznwDjP8iFgeCDY2rRC5hVE3EVXK5Yb8RPOGmG3G6vWD36fsPJ8H25vACA
         dZpQ==
X-Gm-Message-State: AOAM530tPMOANV6y/1MkKxI1CAx6VOJAk4LZrkrm+U2PkjrFk6g2e1vO
        HtoCbb5BZY0jGMyXi7EBs7JECleZBKGYBF3rqdwq2h1ENrM=
X-Google-Smtp-Source: ABdhPJyGe8aVFem5VOUac8t2gzTO+Qw2p0+14iQ5WhgePTkzrC5uWKP2DAYEecBND4FP/onTQkDwJL87PgM87iYoCpA=
X-Received: by 2002:a2e:92cd:: with SMTP id k13mr1750044ljh.138.1599005779107;
 Tue, 01 Sep 2020 17:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <f56e97d5-b47c-1310-863a-50664056e5a7@kernel.dk>
In-Reply-To: <f56e97d5-b47c-1310-863a-50664056e5a7@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 2 Sep 2020 02:15:53 +0200
Message-ID: <CAG48ez12XsTUtxrebDzGQD5bYwss3hUguTHtfE-L3XstGPuTCw@mail.gmail.com>
Subject: Re: [PATCH for-next] io_uring: allow non-fixed files with SQPOLL
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 2, 2020 at 1:11 AM Jens Axboe <axboe@kernel.dk> wrote:
> The restriction of needing fixed files for SQPOLL is problematic, and
> prevents/inhibits several valid uses cases.
>
> There's no real good reason for us not to allow it, except we need to
> have the sqpoll thread inherit current->files from the task that setup
> the ring. We can't easily do that, since we'd introduce a circular
> reference by holding on to our own file table.
>
> If we wait for the sqpoll thread to exit when the ring fd is closed,
> then we can safely reference the task files_struct without holding
> a reference to it. And once we inherit that in the SQPOLL thread, we
> can support non-fixed files for SQPOLL.
[...]
> diff --git a/fs/io_uring.c b/fs/io_uring.c
[...]
> +       /*
> +        * For SQPOLL usage - no reference is held to this file table, we
> +        * rely on fops->flush() and our callback there waiting for the users
> +        * to finish.
> +        */
> +       struct files_struct     *sqo_files;
[...]
> @@ -6621,6 +6622,10 @@ static int io_sq_thread(void *data)
>
>         old_cred = override_creds(ctx->creds);
>
> +       task_lock(current);
> +       current->files = ctx->sqo_files;
> +       task_unlock(current);
[...]
> @@ -7549,6 +7557,13 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>                 if (!capable(CAP_SYS_ADMIN))
>                         goto err;
>
> +               /*
> +                * We will exit the sqthread before current exits, so we can
> +                * avoid taking a reference here and introducing weird
> +                * circular dependencies on the files table.
> +                */
> +               ctx->sqo_files = current->files;
[...]
> @@ -8239,8 +8254,10 @@ static int io_uring_flush(struct file *file, void *data)
>         /*
>          * If the task is going away, cancel work it may have pending
>          */
> -       if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> +       if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
> +               io_sq_thread_stop(ctx);
>                 io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
> +       }

What happens when the uring setup syscall fails around
io_uring_get_fd() (after the sq offload thread was started, but before
an fd was installed)? Will that also properly wait for the sq_thread
to go away before returning from the syscall (at which point the
files_struct could disappear)?
