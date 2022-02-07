Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA704AC9B5
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 20:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiBGTfP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 14:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237259AbiBGTcR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 14:32:17 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F340CC0401DA
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 11:32:16 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id i17so2885261lfg.11
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 11:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kNXJ/3JYeOdOA7DH0CUuMRYUlFkKsOTuLs1vioWo7w=;
        b=h+mCGkMYZDJ2VmGTrhAw2KavAcmOsthjQkVi+QdZ+ZkiV9+fSapdS2uzHf/ukcLtPC
         vRMH36btXdXZw4Ye257+NkEVUOXQ85HWugB/ZhQX8fVUxns1ppL9bbQn13QOA3ElZuOG
         w/woARgt0jaLHbggZleqoiutYHT5OJpNXqshM0nOaRT6yu8ba+36GM7vOQkVtn+q+KMz
         PrViwbkfN0W+BU23IVkmRKIfKyqmi1i+hfYNh3aPzbDCWEmi298Kiaj1FG9p3y59070a
         yT9dTx74o7gwmNbXRdcfA+scReMr+Pi9A/l2N0+4dLetZsnbwfaTYZnVUOnLHuSETGIp
         DGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kNXJ/3JYeOdOA7DH0CUuMRYUlFkKsOTuLs1vioWo7w=;
        b=jcJb4ahAXDTjcOqWe8h9pZJUDbsnUjTDEXZd/QsRetciW6z2KtbTKmag7X5lxg5/29
         qri7Z/IrkIeAeqenkrFVURZPZ+WBDtD568t/bi8WyObw0Fem6bhDDS9KIMKdrxhwqtHv
         icIluHC746GVYZGyTh96/3m/fHFtvxBHg9PQW+rVGeP1/zoKH0ec5c4lJEcM0XdalXVs
         esdMFSJEJxhJtg+Z+5csYN1Hiq0JvzicmTEvENLCILkviK0ltkBVWd5AtQLUrgiMoAC4
         0WyaD7bn/KqJAIb/2dDgfZ+prdtqUlHXx24lMXslFMC/U9jnyedvbcmDNnCgK+rTLL51
         QYqA==
X-Gm-Message-State: AOAM533luW4ySkxn/NmS85KcQNydIytEju52t8SArKjJzVa6bzS7Z3Ky
        5XxKxvoPPYSvF6yau5iz+1qQzNXHBgLOeXT9EihLow==
X-Google-Smtp-Source: ABdhPJysHyL+1pJLsLclE94GhiA8i/bGjovo8W+T16GtnH/4rOMgZ92vLex2xjh0nrjH88dfPBFkxZUzaXe4biaSDQQ=
X-Received: by 2002:ac2:4c4c:: with SMTP id o12mr637262lfk.523.1644262335129;
 Mon, 07 Feb 2022 11:32:15 -0800 (PST)
MIME-Version: 1.0
References: <20220207162410.1013466-1-nathan@kernel.org>
In-Reply-To: <20220207162410.1013466-1-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 7 Feb 2022 11:32:03 -0800
Message-ID: <CAKwvOdnfQeY8sC0iET4hm-kgeFhurWf_jrh4=czBj17zQ5+x0Q@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Fix use of uninitialized ret in io_eventfd_register()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 7, 2022 at 8:24 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
>   fs/io_uring.c:9396:9: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
>           return ret;
>                  ^~~
>   fs/io_uring.c:9373:13: note: initialize the variable 'ret' to silence this warning
>           int fd, ret;
>                      ^
>                       = 0
>   1 warning generated.
>
> Just return 0 directly and reduce the scope of ret to the if statement,
> as that is the only place that it is used, which is how the function was
> before the fixes commit.
>
> Fixes: 1a75fac9a0f9 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")

Did SHA's change? In linux-next, I see:
commit b77e315a9644 ("io_uring: avoid ring quiesce while
registering/unregistering eventfd")
otherwise LGTM

> Link: https://github.com/ClangBuiltLinux/linux/issues/1579
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  fs/io_uring.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5479f0607430..7ef04bb66da1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9370,7 +9370,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
>  {
>         struct io_ev_fd *ev_fd;
>         __s32 __user *fds = arg;
> -       int fd, ret;
> +       int fd;
>
>         ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
>                                         lockdep_is_held(&ctx->uring_lock));
> @@ -9386,14 +9386,14 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
>
>         ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
>         if (IS_ERR(ev_fd->cq_ev_fd)) {
> -               ret = PTR_ERR(ev_fd->cq_ev_fd);
> +               int ret = PTR_ERR(ev_fd->cq_ev_fd);
>                 kfree(ev_fd);
>                 return ret;
>         }
>         ev_fd->eventfd_async = eventfd_async;
>
>         rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
> -       return ret;
> +       return 0;
>  }
>
>  static void io_eventfd_put(struct rcu_head *rcu)
>
> base-commit: 88a0394bc27de2dd8a8715970f289c5627052532
> --
> 2.35.1
>
>


-- 
Thanks,
~Nick Desaulniers
