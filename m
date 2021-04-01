Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BB33511B7
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 11:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhDAJQA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 05:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbhDAJPw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 05:15:52 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F85C0613E6
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 02:15:51 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k128so679875wmk.4
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 02:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dhUGpHjm7W6NN0Nbh6WuEFS/FaFWfRZuSNMBsVNYnoc=;
        b=q1K1+UD4yOCdF6GUscJnyjQ3q8Spgr4V/FGxB3zpPoyp2AH1u+UNmkw1lW46DSteUe
         /ao/qUmzwPQo/Ftr33+HAkxn01e6aoo3TgmNmSvSwa8+9Ye5g1MYMp+mIaRadO4wIU30
         j4TAkHTv1A6mYeEH4BQoTnwuyfdRARGfrDpR3QVMgeBIn51yRpFtoBYR8Fs5wPaoIUnb
         8UelCAlqGb6VMhOt0pBH2dBa/zkbCaaW6jK/lEvOKP9a/xEKmfQzHDYhRLDxIR/qsxdX
         LB6r0AItV1JVfme9SqVp+PzXyMIsAQ6XsH0aQFORwwq5rKMB/bXg0i2nbAe6uLhaTaTx
         hutg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dhUGpHjm7W6NN0Nbh6WuEFS/FaFWfRZuSNMBsVNYnoc=;
        b=LOB8O3a/c1/5WTYARb4napdOavsArqkjW6Iv1YlpEEvNVvbsdQT7hDNbNwCyxA1l/M
         gTmWQWIqIotGK4scac7/JJqTxljdbywLIbMDIMkrjKX2lsehsK1wc/kPXJAvCJpu5FrJ
         FzmdAoqGkLIFOLIJcmpACtAn5TNJMoGLK96hGQdXk8czjfx4oRXFRA3rracLyrcqVESN
         cZ6OHUv4mjURp1KsZ+CfeAge/BYHMunNnLHYmBQCzfpiMKhN1Lw9jo1yPjjtmWbG4v2Q
         pILmi7tMAunyp17WUaWi4hsVwwRpHVGbpjWPMshNtxio6iwYqcbXOyG+UJzpk5XbdDHV
         YGvQ==
X-Gm-Message-State: AOAM5319uYV7VxhBlULDGTfe+UxARuqFxIjLNw0WZZUpG6E275WqJ/73
        MhwWaPNhf9LlXbavxQUuqCg6WvxJZsYiMg==
X-Google-Smtp-Source: ABdhPJwCgiR3IdjDBQ1MjKkJ+yFxlg6zli/dK6EHeuVpicRmOficOTl6871xsn/enW/BAw5ey4r/jA==
X-Received: by 2002:a05:600c:3515:: with SMTP id h21mr7095664wmq.35.1617268550708;
        Thu, 01 Apr 2021 02:15:50 -0700 (PDT)
Received: from [192.168.8.122] ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id i17sm8861976wrp.77.2021.04.01.02.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 02:15:50 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix ctx cancellation for rings allocation
 failure
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617268222-151286-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <800534b6-1dff-ea79-d53a-c1743e9abb3a@gmail.com>
Date:   Thu, 1 Apr 2021 10:11:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1617268222-151286-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> This is caused by access ctx->rings in io_ring_ctx_wait_and_kill()
> while ctx->rings is NULL because of allocation failure.

Yep, missed it out but already fixed
https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.12&id=51520426f4bc3e61cbbf7a39ccf4e411b665002d

 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1949b80677e7..03f593f5e740 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8616,12 +8616,16 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>  	unsigned long index;
>  	struct creds *creds;
>  
> +	if (!ctx->rings) {
> +		io_ring_ctx_free(ctx);
> +		return;
> +	}
> +
>  	mutex_lock(&ctx->uring_lock);
>  	percpu_ref_kill(&ctx->refs);
>  	/* if force is set, the ring is going away. always drop after that */
>  	ctx->cq_overflow_flushed = 1;
> -	if (ctx->rings)
> -		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
> +	__io_cqring_overflow_flush(ctx, true, NULL, NULL);
>  	xa_for_each(&ctx->personalities, index, creds)
>  		io_unregister_personality(ctx, index);
>  	mutex_unlock(&ctx->uring_lock);
> 

-- 
Pavel Begunkov
