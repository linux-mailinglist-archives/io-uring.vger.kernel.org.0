Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C034AC9E8
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 20:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbiBGTx3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 14:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243741AbiBGTs1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 14:48:27 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E00C0401DA
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 11:48:26 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f10so28954376lfu.8
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 11:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xshAeQAm5Ise7n5+KqUI2Gq2vO43dYWLzj1n4M3lADI=;
        b=m2jprebEmhSHSHuYWHpyXk49Q0ycc3cDlMn8JwLTJJKi2qmYSXGGWLoz6bhYhWu4b7
         WLT19qdEsHrW5Af6zYgwyr9CHYjWxlnl1s0VchRi57EarrSycUQh196P7SyNM6uW01th
         gnPfKYQmGbsuDcYSC8LlYEKew+wRz/a4CEjh414g8M5tqRCmp5iWBjX+e2YiyFzh2wZt
         J4oGZRvK4SRlVUUa/H6PGStsTQeKvk9uoL3RvfR7e63ThSnGziaw2k4B1T6zUhLcoPMf
         nS+SBy3zu4A9uchwt1CmvnTevZEmI2ii8QW82pmdTb2FlG7lO+SGc/8Yr9dDygMfsCIZ
         7FVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xshAeQAm5Ise7n5+KqUI2Gq2vO43dYWLzj1n4M3lADI=;
        b=ymuNC8UoNCi55muAbkWk//kN3cRPxHBF5s+f2C1mha9h+DBXram0DlKupkrE0ZKprD
         UeBEkYNFPh/kl+uAeHWBjiFEmn7ixvh8BqCj0nZ6mr9KwTsd5ccgqd809ThoQjoQmymN
         yhXTGG9DCxXMrVcJBL7OquRbjVXsubeX+tCYt7qS9veMbjNMh7MAkgRd2eZaJf/ASTx0
         5T8A8xKAKg3uF/F8pu3uWXurvrGfE0s3ifSBbjFJ90dg+1fV1TCkQYmXnr/w/fTOkbjQ
         L0nO5Lh/T6sqYNQpmtoa4eZwzgPNG0WGbgWh75wbjU0313YN89PdjQqyv0EeZg6+g7qG
         FZ2A==
X-Gm-Message-State: AOAM531uCVpkva5yoNXmY5O5QQ2iUVkCV5vBp8B3qMWddB/VpQptNutZ
        PFtcX6ZD/IodRJDh6JeUlSFJrf7hnXJd0q6QrlNuyA==
X-Google-Smtp-Source: ABdhPJxGbuBFTqFUGLppr8/37eakpFsdrpJ9JwAJ3Gez87KBdM9rrL4ReL3BepKhdcb9fJ8x8e3HiDRO8sSDB9UW9qg=
X-Received: by 2002:ac2:4e10:: with SMTP id e16mr739680lfr.444.1644263304407;
 Mon, 07 Feb 2022 11:48:24 -0800 (PST)
MIME-Version: 1.0
References: <20220207185126.2085525-1-trix@redhat.com>
In-Reply-To: <20220207185126.2085525-1-trix@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 7 Feb 2022 11:48:12 -0800
Message-ID: <CAKwvOdnyPZ6w5qg-+W0H0ait3KUV5S9+-gmty-ANK46BeKd5VQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix uninitialized return
To:     trix@redhat.com
Cc:     axboe@kernel.dk, asml.silence@gmail.com, nathan@kernel.org,
        usama.arif@bytedance.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
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

On Mon, Feb 7, 2022 at 10:51 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> The clang build fails with this error
> io_uring.c:9396:9: error: variable 'ret' is uninitialized when used here
>         return ret;
>                ^~~~
> Return 0 directly.
>
> Fixes: b77e315a9644 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")
> Signed-off-by: Tom Rix <trix@redhat.com>

Thanks for the patch:
See also:
https://lore.kernel.org/llvm/20220207162410.1013466-1-nathan@kernel.org/

> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index aadabb31d6da7..74afb96af214c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9393,7 +9393,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
>         ev_fd->eventfd_async = eventfd_async;
>
>         rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
> -       return ret;
> +       return 0;
>  }
>
>  static void io_eventfd_put(struct rcu_head *rcu)
> --
> 2.26.3
>


-- 
Thanks,
~Nick Desaulniers
