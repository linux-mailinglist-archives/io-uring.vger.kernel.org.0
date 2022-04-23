Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACDA50C832
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 10:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiDWIKd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 04:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiDWIKc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 04:10:32 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605C6BC3E
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 01:07:36 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u15so20337133ejf.11
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 01:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=gl7MJKC91l/Fb4hq2V4Drla2M00HU1yuWVJBvkS7vqU=;
        b=Wwp3b0xYyT+2biwn/D6RgD2rHn1TROmFQKf4mdRZI4XhwUDiuGHJovi2uKFtgWhCtD
         0ZhtA4thKnVXZ5zNANJl7HZdEihbv6grlFGfr0oR1oXtEkZyiuMCeTSDdyayQeXYoeFZ
         wSNURVE2Rr7Ez27r90DRcwbORTY96K5xp7Nhm+tif7bW1WkXZlRVZURfe+OAV3/JjmNY
         0iYnfV5rEKfUbLMBv9C+H4bK7rkP+ND/P09+7uEmYV2v97mWr92r3SQLQ8Ad9E6x1sgM
         TPkPe4fm60mSyZbp7sU/03i+OIUUvk1XZeINNYjwSYsWmra61oJ/z+Pff+mciZR91EEL
         91LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gl7MJKC91l/Fb4hq2V4Drla2M00HU1yuWVJBvkS7vqU=;
        b=gxC6IIW1B4lZKmCJeBXhqs6R6cJ2PwhJA0VqAifQer8vCKTSUQqMd1jXpjRNH1PRX0
         sMKWQ1aYID49V52B04iut84mQmro4EgpQfp0726cSFjweg6k9AaEWqDVc+rdbExXVILc
         a+iPCQzB+DN5NLFIprmH8WPCRDNivTaLf/hWOtbE59wVdpopvEKH5h9tPSfEVa59RE1Q
         t1QQHF7D5B9bvEpKSqsX/+052WtHz7vDhhkZKU1Wp2alTkQP3+WVcGtntOQIQERAiuIx
         25elcnMum8tOMRBtKfX2lx1Poh9xj8wDOmCoTAk/rERlTmXF6O4xQUPqxv+EwjsGdbiP
         UoDw==
X-Gm-Message-State: AOAM533vuPMh1Ir7SJJLzEHvrNBZ+fqwYQT9wNu1xtrWeMfZf6epDcDh
        mOr8VM3aPdKWd0oRxbmh9/u1IWthM7A=
X-Google-Smtp-Source: ABdhPJwxZIgAyhhC284X2yLSE3yv/OQWry62Cy70x8NvFiCGaAz9DIUcUNXlXcpn6xoAY2Ipa6vGyw==
X-Received: by 2002:a17:906:66c8:b0:6e8:8b06:1b32 with SMTP id k8-20020a17090666c800b006e88b061b32mr7418549ejp.236.1650701254781;
        Sat, 23 Apr 2022 01:07:34 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.144.28])
        by smtp.gmail.com with ESMTPSA id ec40-20020a0564020d6800b00420916b32c9sm1883010edb.59.2022.04.23.01.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 01:07:34 -0700 (PDT)
Message-ID: <baf8826d-b94f-d009-c912-7262a825a409@gmail.com>
Date:   Sat, 23 Apr 2022 09:06:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/5] io_uring: serialize ctx->rings->sq_flags with
 cmpxchg()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220422214214.260947-1-axboe@kernel.dk>
 <20220422214214.260947-3-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220422214214.260947-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/22 22:42, Jens Axboe wrote:
> Rather than require ctx->completion_lock for ensuring that we don't
> clobber the flags, use try_cmpxchg() instead. This removes the need
> to grab the completion_lock, in preparation for needing to set or
> clear sq_flags when we don't know the status of this lock.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c | 54 ++++++++++++++++++++++++++++++---------------------
>   1 file changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 626bf840bed2..38e58fe4963d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1999,6 +1999,34 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>   		io_cqring_wake(ctx);
>   }
>   
> +static void io_ring_sq_flag_clear(struct io_ring_ctx *ctx, unsigned int flag)
> +{
> +	struct io_rings *rings = ctx->rings;
> +	unsigned int oldf, newf;
> +
> +	do {
> +		oldf = READ_ONCE(rings->sq_flags);
> +
> +		if (!(oldf & flag))
> +			break;
> +		newf = oldf & ~flag;
> +	} while (!try_cmpxchg(&rings->sq_flags, &oldf, newf));
> +}
> +
> +static void io_ring_sq_flag_set(struct io_ring_ctx *ctx, unsigned int flag)
> +{
> +	struct io_rings *rings = ctx->rings;
> +	unsigned int oldf, newf;
> +
> +	do {
> +		oldf = READ_ONCE(rings->sq_flags);
> +
> +		if (oldf & flag)
> +			break;
> +		newf = oldf | flag;
> +	} while (!try_cmpxchg(&rings->sq_flags, &oldf, newf));
> +}

atomic and/or might be a better fit

-- 
Pavel Begunkov
