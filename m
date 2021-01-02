Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB0F2E884B
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 20:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbhABTaC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 14:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbhABT36 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 14:29:58 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FC2C061573;
        Sat,  2 Jan 2021 11:29:17 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d26so26927909wrb.12;
        Sat, 02 Jan 2021 11:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GnlwVWvkpbQ8SE3Dyv9Mq0E/QzLOYrHMEiAwrZu78NU=;
        b=M/Oa2EKLq4X+hUWWwnVHA6PBYTUFkGejI8UOCRLKXi/CcPzPPF3hdQzxJ2t/Y7wYRe
         UqpGj7LSv9KUNnNaGIt/CGrefwW8RiiPR5hD2fL4LGFHNABEKG3xvP8zrYJx5z1eGWYw
         gafP8IpA8Em0ndh/y9gLReIIyhdHKRCYJQ3DdX/HVDcGYgGy/qKGWHpAP0Odvio5k2qB
         znf4nWv6zPFtiw0rv5Iup7zBm6pftJqh3E9sNZl73tF5PzkyqDhYzpy2eYfeA5qN0C8n
         kDMCM42gkpsrhvnej00Ry8Rl/TprTh9fE8eG9uR/A/ocfn7nf0N9HRX0Xy73q8vnsgJs
         AeCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GnlwVWvkpbQ8SE3Dyv9Mq0E/QzLOYrHMEiAwrZu78NU=;
        b=fWdq4yluxLlZcsUvfMdxVPzLoyCTmj9D7jBzB0PqvvEVC7W3jYUKVBDbKdZ5Ly4/nZ
         5Ct4NdIytk8kKctgd2kSHlcKMaGU4y1p+PJyjX+xRtiFvIhbWAq6iyZ3N5W/K4VkaQzl
         qkWvWEaXAJ1Ai0pjpcP7xhASI4y3qieKKbNoK+WkjEBPx0bEJILf4GCTnZQ+sRMvYPqa
         dnZVfeulwNi/rO/Hg6uE6RAiNqRnE5kkhbcKzjDV+6vfUDX1tg1C5/LpPt4ypAn7s2u3
         Q54fWXKRJniRiFlQvW5YSUXLd7MkGNEDCMoJfxHZOzjkjjHXL9GYmZT+IxS0z2gPAroj
         GIXg==
X-Gm-Message-State: AOAM530D/s0G7p2p0ybzMerS9XaM6zoRD20/RtlVPy8loE5fwhcLUh1S
        QmOlSmRH0+GfjZ+c345yRpEPKDVifDg=
X-Google-Smtp-Source: ABdhPJzhyNz4p3AvpO/1cVw6mvO9BZQLfF44Lh3zpV4yZH3Q4NFCDUoSEPfIhki6DcGPiuTzX5qnzw==
X-Received: by 2002:a5d:5442:: with SMTP id w2mr73199180wrv.418.1609615756230;
        Sat, 02 Jan 2021 11:29:16 -0800 (PST)
Received: from [192.168.8.179] ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id j2sm80516668wrt.35.2021.01.02.11.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Jan 2021 11:29:15 -0800 (PST)
Subject: Re: [PATCH] io_uring: simplify io_remove_personalities()
To:     Yejune Deng <yejune.deng@gmail.com>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1608778940-16049-1-git-send-email-yejune.deng@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <2c9df437-b5e9-51a8-1ccb-a16f5ed4fae6@gmail.com>
Date:   Sat, 2 Jan 2021 19:25:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1608778940-16049-1-git-send-email-yejune.deng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/12/2020 03:02, Yejune Deng wrote:
> The function io_remove_personalities() is very similar to
> io_unregister_personality(),so implement io_remove_personalities()
> calling io_unregister_personality().

Please, don't forget to specify a version in the subject, e.g.
[PATCH v2], add a changelog after "---" and add tags from previous
threads if any.

Looks good
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  fs/io_uring.c | 28 +++++++++++-----------------
>  1 file changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b749578..dc913fa 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8608,9 +8608,8 @@ static int io_uring_fasync(int fd, struct file *file, int on)
>  	return fasync_helper(fd, file, on, &ctx->cq_fasync);
>  }
>  
> -static int io_remove_personalities(int id, void *p, void *data)
> +static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>  {
> -	struct io_ring_ctx *ctx = data;
>  	struct io_identity *iod;
>  
>  	iod = idr_remove(&ctx->personality_idr, id);
> @@ -8618,7 +8617,17 @@ static int io_remove_personalities(int id, void *p, void *data)
>  		put_cred(iod->creds);
>  		if (refcount_dec_and_test(&iod->count))
>  			kfree(iod);
> +		return 0;
>  	}
> +
> +	return -EINVAL;
> +}
> +
> +static int io_remove_personalities(int id, void *p, void *data)
> +{
> +	struct io_ring_ctx *ctx = data;
> +
> +	io_unregister_personality(ctx, id);
>  	return 0;
>  }
>  
> @@ -9679,21 +9688,6 @@ static int io_register_personality(struct io_ring_ctx *ctx)
>  	return ret;
>  }
>  
> -static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
> -{
> -	struct io_identity *iod;
> -
> -	iod = idr_remove(&ctx->personality_idr, id);
> -	if (iod) {
> -		put_cred(iod->creds);
> -		if (refcount_dec_and_test(&iod->count))
> -			kfree(iod);
> -		return 0;
> -	}
> -
> -	return -EINVAL;
> -}
> -
>  static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
>  				    unsigned int nr_args)
>  {
> 

-- 
Pavel Begunkov
