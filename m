Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AFE70099D
	for <lists+io-uring@lfdr.de>; Fri, 12 May 2023 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbjELN6y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 May 2023 09:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240564AbjELN6x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 May 2023 09:58:53 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB956E4B
        for <io-uring@vger.kernel.org>; Fri, 12 May 2023 06:58:52 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-334d0f0d537so2690565ab.0
        for <io-uring@vger.kernel.org>; Fri, 12 May 2023 06:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683899932; x=1686491932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yH2xnek6VdQOUwfJmdky94/blHNCWWMuO8qXfq6pSwM=;
        b=pYEPobvpjc6Ad0FDHAkvFWzH9s642aXV2PRSLgRt5Fr7X7gH0L2+2JPWdjTn3kys9R
         WIvgvfeuLJtXEvEObwAIEbWUicn9ICg7Fw2550TzupQBqYYqEVcBOa8RLkKY06fGDG8B
         fSs49eIiSxTn5lKuPcVk3UHxIrSyVWL072oKXPQNCDKggPbELhEHSWaP2PxgBnKdwkhN
         qzU8+uh+ClWfMuW65Z+eetpNKovEsK+aXpc8v6u31XWQAFoVVoo8XcLyHN2+dvOakCz5
         Y8oncoNuCwBQapvbzyZTONx0SjaZwI+JMwqQpJB3emXcgzC3zesbQGH5FFmkdgKa2K4F
         cuUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683899932; x=1686491932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yH2xnek6VdQOUwfJmdky94/blHNCWWMuO8qXfq6pSwM=;
        b=RymNZvmtSVuKmpW4Nk2/iWXKSFlDghFDl0IldrDMUF6yyEX/wAcCFioYmXaCQB/JLG
         X6gncJM+prjAvQQ4ah91X97AOsW/69AHab4TK82ZeX0tw0oPhacfnAacBhW7h8Yu+NgB
         IA9I/VTXfG3+qNK2tq84hlUV7SchhiaDH4xSGydNFkhNWf3wSQY4IDQZ8IAavdJ1Wy7J
         +CL5tSLYKj5TUmEL2PKfYkOmRyZ5c8+b8s8Rrjy6mB2zKSBPT5xWv9J4vcAbwSCUpoi6
         53gslpQa8RlMiDYGuUmrJORobv4vYgke2Q/UIdNFuj3431LNlRvHuB3GcBXVRCsm8hYy
         j9Lg==
X-Gm-Message-State: AC+VfDxlZqsKj3FB2j+ah+M87AqE5hFpldbNcI9aNEbM7L+aBJuvamAY
        2AlheQ9afebhy/sMoqtykWt9fA==
X-Google-Smtp-Source: ACHHUZ4D6Eq74NNkD7IfpXh7o0iMVJF9lCDFxSiZeDr+LdBgJIfNJ7BThe8l0SQ2M4ns+Mo++OxWrQ==
X-Received: by 2002:a5e:a808:0:b0:76c:7342:dde6 with SMTP id c8-20020a5ea808000000b0076c7342dde6mr4175223ioa.0.1683899932100;
        Fri, 12 May 2023 06:58:52 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d11-20020a0566380d4b00b0040f91b773d2sm4714418jak.35.2023.05.12.06.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 06:58:51 -0700 (PDT)
Message-ID: <13383a9d-2bf0-1542-bc05-cfa00975e921@kernel.dk>
Date:   Fri, 12 May 2023 07:58:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] Subject: io_uring: Fix bug in io_fallback_req_func that
 can cause deadlock
Content-Language: en-US
To:     luhongfei <luhongfei@vivo.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     opensource.kernel@vivo.com
References: <20230512095655.8968-1-luhongfei@vivo.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230512095655.8968-1-luhongfei@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/12/23 3:56?AM, luhongfei wrote:
> There was a bug in io_fallback_req_func that can cause deadlocks
> because uring_lock was not released when return.
> This patch releases the uring_lock before return.
> 
> Signed-off-by: luhongfei <luhongfei@vivo.com>
> ---
>  io_uring/io_uring.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>  mode change 100644 => 100755 io_uring/io_uring.c
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 3bca7a79efda..1af793c7b3da
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -252,8 +252,10 @@ static __cold void io_fallback_req_func(struct work_struct *work)
>  	mutex_lock(&ctx->uring_lock);
>  	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
>  		req->io_task_work.func(req, &ts);
> -	if (WARN_ON_ONCE(!ts.locked))
> +	if (WARN_ON_ONCE(!ts.locked)) {
> +		mutex_unlock(&ctx->uring_lock);
>  		return;
> +	}
>  	io_submit_flush_completions(ctx);
>  	mutex_unlock(&ctx->uring_lock);
>  }

I'm guessing you found this by reading the code, and didn't actually hit
it? Because it looks fine as-is. We lock the ctx->uring_lock, and set
ts.locked == true. If ts.locked is false, then someone unlocked the ring
further down, which is unexpected (hence the WARN_ON_ONCE()). But if
that did happen, then we definitely don't want to unlock it again.

Because of that, I don't think you're patch is correct.

-- 
Jens Axboe

