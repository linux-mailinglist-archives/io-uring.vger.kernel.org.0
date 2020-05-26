Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8666E1E3201
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 00:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391830AbgEZWE6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 18:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389342AbgEZWE5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 18:04:57 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23ECC061A0F
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 15:04:56 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q2so26438792ljm.10
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 15:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4PRMzfztpVwa44SR1LBT6Wn2XQ/qM8MOK+/wfE30B7Y=;
        b=GPgbXkmAEESZdyxf+1Za1ll4HQv+kBmXAVZEeLjdByq43VdfKuzCB5BI7XWmf/tZrf
         IWm4piDPtnxVDYioI9ze4ws7jR7M5r2Qf5h5rfyJoMkhaW0YUDhNeWz6PvLoC5Aff9RR
         rLTwNZUAydURqHdJOlAAMKzFm/SyF7zld0W76M8eXseJEg9WlCWFFklUcoQmNhSA7zbY
         47bXJnKE1o1ipbJQ1Jx2V14MmMOgeNp9v9tYIp2jDI2SYKgzWDvDXu6+K6VLfwP329dO
         Vp85WnIN+hoClvAI/h43+xMAwYxMfdBcRf2zcBiG53Pqn3LpxSLTTFbX+g3Xv+jtwyHs
         132A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4PRMzfztpVwa44SR1LBT6Wn2XQ/qM8MOK+/wfE30B7Y=;
        b=YeaHLNiGImUNg4O1qq9EOL+Q07jNfkNSiSzzoi+Ff9px2610xJ4ZkaFK60OCr88TUZ
         4M+e7whe8IVhBfqLuSRUcvGMu3ZAsiCO+9XoqTTVcc6HdChi7svNFRjYF2ZNlowmzcBP
         N6BarmTIv2l4dE2zbJC+XgEpnfVA01aYVpRwhsoTGScmaBo3GMVQ1BvyXxelkwvAXeFU
         1kMZ1NNX04lvpxFjd8dAABehSIxYVZOzWO8jQ0E8ohOgcugRzlcctp/7N9P9AkXss13s
         8OvwTp6/HLbEeecoDUg5bHG+YuOskvM7wS/ksrgtlLYRflcORWFBG3BTxvxdipWgqa2X
         FLaw==
X-Gm-Message-State: AOAM531w1OObLqK3E5+5Dfabh6SPkxGircwZL/hcQUiZrPYC8NpGr4wz
        Wcn4oW58LiKlDTUy5wNH+Yhq/DTCN3pIFziSOoI8BiEIjzA=
X-Google-Smtp-Source: ABdhPJwsDNIOZr9jYcBL8FNNI39FmYL7w8n1ohtzaJO1kGrR9Y7S5vYekVUie/TvV+XeEzC5BhYmvRdspeH2hyHBqeQ=
X-Received: by 2002:a05:651c:1183:: with SMTP id w3mr1593579ljo.265.1590530695169;
 Tue, 26 May 2020 15:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <94f75705-3506-4c58-c1ff-cced9c045956@gmail.com>
In-Reply-To: <94f75705-3506-4c58-c1ff-cced9c045956@gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 27 May 2020 00:04:28 +0200
Message-ID: <CAG48ez24_NGyYEXyO+AaWZNEkK=CVmvOQDoGUoaJxtORoLU=OA@mail.gmail.com>
Subject: Re: [RFC] .flush and io_uring_cancel_files
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 8:11 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> It looks like taking ->uring_lock should work like kind of grace
> period for struct files_struct and io_uring_flush(), and that would
> solve the race with "fcheck(ctx->ring_fd) == ctx->ring_file".
>
> Can you take a look? If you like it, I'll send a proper patch
> and a bunch of cleanups on top.
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a3dbd5f40391..012af200dc72 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5557,12 +5557,11 @@ static int io_grab_files(struct io_kiocb *req)
>          * the fd has changed since we started down this path, and disallow
>          * this operation if it has.
>          */
> -       if (fcheck(ctx->ring_fd) == ctx->ring_file) {
> -               list_add(&req->inflight_entry, &ctx->inflight_list);
> -               req->flags |= REQ_F_INFLIGHT;
> -               req->work.files = current->files;
> -               ret = 0;
> -       }
> +       list_add(&req->inflight_entry, &ctx->inflight_list);
> +       req->flags |= REQ_F_INFLIGHT;
> +       req->work.files = current->files;
> +       ret = 0;
> +
>         spin_unlock_irq(&ctx->inflight_lock);
>         rcu_read_unlock();
>
> @@ -7479,6 +7478,10 @@ static int io_uring_release(struct inode *inode, struct
> file *file)
>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>                                   struct files_struct *files)
>  {
> +       /* wait all submitters that can race for @files */
> +       mutex_lock(&ctx->uring_lock);
> +       mutex_unlock(&ctx->uring_lock);
> +
>         while (!list_empty_careful(&ctx->inflight_list)) {
>                 struct io_kiocb *cancel_req = NULL, *req;
>                 DEFINE_WAIT(wait);

First off: You're removing a check in io_grab_files() without changing
the comment that describes the check; and the new comment you're
adding in io_uring_cancel_files() is IMO too short to be useful.

I'm trying to figure out how your change is supposed to work, and I
don't get it. If a submitter is just past fdget() (at which point no
locks are held), the ->flush() caller can instantly take and drop the
->uring_lock, and then later the rest of the submission path will grab
an unprotected pointer to the files_struct. Am I missing something?
