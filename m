Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8E23CF7B0
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 12:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbhGTJj5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 05:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbhGTJgf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 05:36:35 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E2FC061767;
        Tue, 20 Jul 2021 03:17:12 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id f190so10395584wmf.4;
        Tue, 20 Jul 2021 03:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AugJvUHmNLwVe4K3M4JvLu9/Qwaqre5FdmA9hig+zEQ=;
        b=fVYMpZShmZNLF/LwODLjalyG0mu2S75VcBPavmWuECSCQ+OWdUgbiOzSb1IXnd2w5o
         +yMVEoz0hTKqNqNyWL4Y2s99X+i226Qmv6fGpF8yLzhozMe3WiYiddRI+5qkOVdmqadJ
         FbIP5/rmjTQLicWDZwoGsTm4Xs0OlENB23LtassEFusT+uFvCfWC2kPPpsF61xb9jRxd
         uMLyqOafUzSckcIe6pyejZPPx1e1OXcJAbZDx0vL+NpbpHCvo+PGYk+blJzWQFru/ObD
         lSaMBVq8B7hXMb6jZ0ADWlSEenLp6aAHOx7jl/8nYcm3GOsAjrZsLJt/ICe0VLyI7uC/
         XT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AugJvUHmNLwVe4K3M4JvLu9/Qwaqre5FdmA9hig+zEQ=;
        b=CxFLoSJ2pQs7llyfJex10ZXpbNeTbMmpBjchvfjsFXAcfkaKJlFnA7RDzupOIIl/zo
         0g0jELtq/QFkqJ5y0SHsqTamLRFHnXvmEPEOrSInJVC8D6HTo5a8qBQoqX+sqy/kT9il
         DHbB6BKcQeJbeXso3DLPGJC/gG3Mdiri5Gf7wy1PN/iQHeYkXjSLoe2Di3zzrlbTbSpe
         vOIBm7kYFn2/UDHmdaZmfcfhSb26bycJI4p3ETho/iBT7z2/zh3sAup6EK5kHx39VBkY
         z1fmEUbUO+DWDvARXWaGY/KxsUNmZ2fvS8HCQJR/RXpGY17kwQFFflALvi7F2SNUl/AS
         oeug==
X-Gm-Message-State: AOAM533OrhVsek19WkVvN5yyEg/25MOmMrmB2zUdt2z8CRNtEHqzkztU
        xTkm7GB3FHKg85YoP3hBc/s=
X-Google-Smtp-Source: ABdhPJxPr+hdoNl6h9ajS7dMKkCYUsu29ut43v3UGCCMvgjaGHg9aLMEGvbI62hPJSonMcVIsW9glA==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr30678441wmk.70.1626776231579;
        Tue, 20 Jul 2021 03:17:11 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.204])
        by smtp.gmail.com with ESMTPSA id l39sm1677599wms.1.2021.07.20.03.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 03:17:11 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix memleak in io_init_wq_offload()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20210720083805.3030730-1-yangyingliang@huawei.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <990880a3-2f0f-3b2c-88e8-a626032b44df@gmail.com>
Date:   Tue, 20 Jul 2021 11:16:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720083805.3030730-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/21 9:38 AM, Yang Yingliang wrote:
> I got memory leak report when doing fuzz test:

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org

> 
> BUG: memory leak
> unreferenced object 0xffff888107310a80 (size 96):
> comm "syz-executor.6", pid 4610, jiffies 4295140240 (age 20.135s)
> hex dump (first 32 bytes):
> 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> 00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00 .....N..........
> backtrace:
> [<000000001974933b>] kmalloc include/linux/slab.h:591 [inline]
> [<000000001974933b>] kzalloc include/linux/slab.h:721 [inline]
> [<000000001974933b>] io_init_wq_offload fs/io_uring.c:7920 [inline]
> [<000000001974933b>] io_uring_alloc_task_context+0x466/0x640 fs/io_uring.c:7955
> [<0000000039d0800d>] __io_uring_add_tctx_node+0x256/0x360 fs/io_uring.c:9016
> [<000000008482e78c>] io_uring_add_tctx_node fs/io_uring.c:9052 [inline]
> [<000000008482e78c>] __do_sys_io_uring_enter fs/io_uring.c:9354 [inline]
> [<000000008482e78c>] __se_sys_io_uring_enter fs/io_uring.c:9301 [inline]
> [<000000008482e78c>] __x64_sys_io_uring_enter+0xabc/0xc20 fs/io_uring.c:9301
> [<00000000b875f18f>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> [<00000000b875f18f>] do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
> [<000000006b0a8484>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> CPU0                          CPU1
> io_uring_enter                io_uring_enter
> io_uring_add_tctx_node        io_uring_add_tctx_node
> __io_uring_add_tctx_node      __io_uring_add_tctx_node
> io_uring_alloc_task_context   io_uring_alloc_task_context
> io_init_wq_offload            io_init_wq_offload
> hash = kzalloc                hash = kzalloc
> ctx->hash_map = hash          ctx->hash_map = hash <- one of the hash is leaked
> 
> When calling io_uring_enter() in parallel, the 'hash_map' will be leaked, 
> add uring_lock to protect 'hash_map'.
> 
> Fixes: e941894eae31 ("io-wq: make buffered file write hashed work map per-ctx")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  fs/io_uring.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0cac361bf6b8..63d3a9c2a2a6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7899,15 +7899,19 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
>  	struct io_wq_data data;
>  	unsigned int concurrency;
>  
> +	mutex_lock(&ctx->uring_lock);
>  	hash = ctx->hash_map;
>  	if (!hash) {
>  		hash = kzalloc(sizeof(*hash), GFP_KERNEL);
> -		if (!hash)
> +		if (!hash) {
> +			mutex_unlock(&ctx->uring_lock);
>  			return ERR_PTR(-ENOMEM);
> +		}
>  		refcount_set(&hash->refs, 1);
>  		init_waitqueue_head(&hash->wait);
>  		ctx->hash_map = hash;
>  	}
> +	mutex_unlock(&ctx->uring_lock);
>  
>  	data.hash = hash;
>  	data.task = task;
> 

-- 
Pavel Begunkov
