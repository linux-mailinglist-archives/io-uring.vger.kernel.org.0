Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D12C560390
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 16:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiF2OqP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 10:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiF2OqO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 10:46:14 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631AE32050
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 07:46:13 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d5so14301145plo.12
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 07:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eL3eeC0Iob2m/nwMP0RJ7jXcLHDbzdzqLETnK8JIhg8=;
        b=wn1IOiIdLB96SV/KFiypk3XqUMeDeWe89LZppFNyPQACPUd7wQhLebIRJyETZvVibd
         4apEyr2vHax4+WUMR42l1c60+TGZQLoXBmzDvlVogi1qy/Y82yN4v5fZ0Lm6XwWbX4tL
         WFXcR28zqN/+eRq2l4UUzb84RJlqydnCekMqV/bGwYL4RRx58m4UP9qEO1QAmi+vJPdM
         cSS74j8ICMUat9OTrpacztZ0yhV2XnNk7V50XedxZ7i+mYrSeTrc51S5WR/WdZSwgYI+
         tyJZmZyKsCYt8gbd16qRWPX8hkXdsGHOEhNb4+h6Gamvmxnw4L4UjOJfCuCIKJsAo8oq
         lIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eL3eeC0Iob2m/nwMP0RJ7jXcLHDbzdzqLETnK8JIhg8=;
        b=H0CHL9IzGfXxBNv5S2Dd0EagpZ0xRe1zjG27g5lS6PfyFLTqV6Ow5YLoulfhMcT/QO
         xKZKBKLud7PGFsh3XauD34WlPT4B9WWJxCE4MxtzmftalLRvCOFKHfRNCEbccvayU8mv
         J7bqmmwjrELn/64DOQ7XHYk2ilpAY+s1glLm/W9iY0/NeQiASqM43kj0B7xcDKZ7TIpt
         3QAK4GJ30U2HNH450lEADXXtII2dObZrOcKxDsppUu5sWiHWYKGNbcjElsxRqFm+MVYY
         pUeGhkUmacfx6XTRINd3qcWFgIrSrN3VKOcLVeOiJP1gOOgEGtEFrpoHTGx2Zcay07/y
         iOiQ==
X-Gm-Message-State: AJIora8N5ux8/nFwyxgBxFVTWBqVYavAqfC/8uFFHpy686CDt2ohFAMf
        TUoonjIvbm10SCypcGGV6zEySg==
X-Google-Smtp-Source: AGRyM1txT+ZrMJMVvS17lAeyoRx8ZbEgcY9VSKMzGxNQfGMabIPYccYJ3vWeq2XeiFbRWpBUViDJ+A==
X-Received: by 2002:a17:90a:68cf:b0:1ee:db09:739b with SMTP id q15-20020a17090a68cf00b001eedb09739bmr4177688pjj.179.1656513972832;
        Wed, 29 Jun 2022 07:46:12 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id mn9-20020a17090b188900b001ec9d45776bsm2238350pjb.42.2022.06.29.07.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 07:46:12 -0700 (PDT)
Message-ID: <4768f72e-6c23-b2ac-d446-b69ded9c19a1@kernel.dk>
Date:   Wed, 29 Jun 2022 08:46:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: fix a typo in comment
Content-Language: en-US
To:     korantwork@gmail.com, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinghui Li <korantli@tencent.com>
References: <20220629144301.9308-1-korantwork@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220629144301.9308-1-korantwork@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/29/22 8:43 AM, korantwork@gmail.com wrote:
> From: Xinghui Li <korantli@tencent.com>
> 
> fix a typo in comment in io_allocate_scq_urings.
> sane -> same.
> 
> Signed-off-by: Xinghui Li <korantli@tencent.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d3ee4fc532fa..af17adf3fa79 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -12284,7 +12284,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>  	struct io_rings *rings;
>  	size_t size, sq_array_offset;
>  
> -	/* make sure these are sane, as we already accounted them */
> +	/* make sure these are same, as we already accounted them */
>  	ctx->sq_entries = p->sq_entries;
>  	ctx->cq_entries = p->cq_entries;

That's not really a typo, though I can see why you'd think so. It's
trying to say that we need to ensure that the ctx entries are sane,
as they have already been accounted. This means that if we teardown
past this point, they need to be assigned (eg sane) so that we undo
that accounting appropriately.


-- 
Jens Axboe

