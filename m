Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A40536FA09
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 14:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhD3MUs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 08:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhD3MUG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 08:20:06 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02899C061359;
        Fri, 30 Apr 2021 05:18:49 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t18so12769564wry.1;
        Fri, 30 Apr 2021 05:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OG/VfqIKsVJhlNNfmKnIykXujtFM0kyplMhTxwa1xFo=;
        b=GNdmBeY1twnd3Q8oX0LolqX1nSJlTYr4OZVm+b+dL/9BDCTJRtTzGjBEyTFKfvrTXM
         +e/kM3DCYID3hWTa1c+0+CVrSXXCsOL9NthbF8HypdALWPn/ODSUrc0O7A2Y7w67uUxE
         sZaYQWSEJW/X0q8u3nPgu3rFyiJPeJ+syiY74KpR0gt9RXu8LINfrrEcRTHPjrv57tLx
         VUPpOht6JlhWiIPZNod1BsgcqmZm/TKzhUUMtPglg9grDC5bVTp8Edv6luqGWzacuckt
         lBNFSWvhI0bcjJjFpT5rIO0U1zCVfb4qG78zx6nx44WcAPXf+vRmqCh5qE4cbaK9l8fY
         ulrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OG/VfqIKsVJhlNNfmKnIykXujtFM0kyplMhTxwa1xFo=;
        b=bWG68Oi26bPJ+ovaqeYbLn0zLD9lMIqynjLTDnU3Ktx1zQs9QmzMHaEkLV1635Sqd6
         i4QP1heRdgDVbXf5sq6sBeTbB/Vzh2lqRWNzqt5VtI0TDMzOVmptiKtXlkPW8ndNPcrO
         qIiVTanlVoKT1fw6VZkPTW3XJd7YdZ1W9p+Np2hjm5hOwnFY/076EdyRV7xUCjZwsQK5
         1cyWNGcIapTlZOtRVbQI5MB7xK7zl72CiD2eRNqJf+ulAgAQl0G7T/XYPsU1LmtUqC7V
         gqBiqnEeky7umRBgO8UFH2ptPv7rbvLolycvCKiTg1oVyxKdNAuyxxy/kSmg2qezuMDV
         SLmw==
X-Gm-Message-State: AOAM532uh8QhafGfW7eZ+Is+VCJ6UJpgFwwOjAKWRrO3+JLOSuMisNA6
        fvmBgjFvMHvXtS1D8PdXmJJkzs5M90c=
X-Google-Smtp-Source: ABdhPJxN+rm17fponHMkauT7LpdmNsjre2bKk8fTvQbYN4E1sLwWouaK6ZT0J++1BylEKb0u9YExoQ==
X-Received: by 2002:adf:ed07:: with SMTP id a7mr6649688wro.113.1619785127463;
        Fri, 30 Apr 2021 05:18:47 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id g6sm2529682wrr.63.2021.04.30.05.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 05:18:47 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Fix memory leak in io_sqe_buffers_register()
To:     qiang.zhang@windriver.com, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20210430082515.13886-1-qiang.zhang@windriver.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8abc2d55-a72f-0b84-a200-6faf97b18701@gmail.com>
Date:   Fri, 30 Apr 2021 13:18:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210430082515.13886-1-qiang.zhang@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/21 9:25 AM, qiang.zhang@windriver.com wrote:
> From: Zqiang <qiang.zhang@windriver.com>
> 
> unreferenced object 0xffff8881123bf0a0 (size 32):
> comm "syz-executor557", pid 8384, jiffies 4294946143 (age 12.360s)
> backtrace:
> [<ffffffff81469b71>] kmalloc_node include/linux/slab.h:579 [inline]
> [<ffffffff81469b71>] kvmalloc_node+0x61/0xf0 mm/util.c:587
> [<ffffffff815f0b3f>] kvmalloc include/linux/mm.h:795 [inline]
> [<ffffffff815f0b3f>] kvmalloc_array include/linux/mm.h:813 [inline]
> [<ffffffff815f0b3f>] kvcalloc include/linux/mm.h:818 [inline]
> [<ffffffff815f0b3f>] io_rsrc_data_alloc+0x4f/0xc0 fs/io_uring.c:7164
> [<ffffffff815f26d8>] io_sqe_buffers_register+0x98/0x3d0 fs/io_uring.c:8383
> [<ffffffff815f84a7>] __io_uring_register+0xf67/0x18c0 fs/io_uring.c:9986
> [<ffffffff81609222>] __do_sys_io_uring_register fs/io_uring.c:10091 [inline]
> [<ffffffff81609222>] __se_sys_io_uring_register fs/io_uring.c:10071 [inline]
> [<ffffffff81609222>] __x64_sys_io_uring_register+0x112/0x230 fs/io_uring.c:10071
> [<ffffffff842f616a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
> [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Fix data->tags memory leak, through io_rsrc_data_free() to release
> data memory space.

My bad, I've added io_rsrc_data_free() specifically to use it with
buffers. The patch looks good, thanks

> 
> Reported-by: syzbot+0f32d05d8b6cd8d7ea3e@syzkaller.appspotmail.com
> Signed-off-by: Zqiang <qiang.zhang@windriver.com>
> ---
>  fs/io_uring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a880edb90d0c..7a2e83bc005d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8140,7 +8140,7 @@ static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>  	for (i = 0; i < ctx->nr_user_bufs; i++)
>  		io_buffer_unmap(ctx, &ctx->user_bufs[i]);
>  	kfree(ctx->user_bufs);
> -	kfree(ctx->buf_data);
> +	io_rsrc_data_free(ctx->buf_data);
>  	ctx->user_bufs = NULL;
>  	ctx->buf_data = NULL;
>  	ctx->nr_user_bufs = 0;
> @@ -8400,7 +8400,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  		return -ENOMEM;
>  	ret = io_buffers_map_alloc(ctx, nr_args);
>  	if (ret) {
> -		kfree(data);
> +		io_rsrc_data_free(data);
>  		return ret;
>  	}
>  
> 

-- 
Pavel Begunkov
