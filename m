Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B696D9985
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 16:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjDFOYR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 10:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbjDFOYH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 10:24:07 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DDC3C06;
        Thu,  6 Apr 2023 07:24:05 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id sg7so1822152ejc.9;
        Thu, 06 Apr 2023 07:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680791044;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1BMDugGBKbFd2rlOj+T4qAzKzXaWfgLdDkmdDGQCOLc=;
        b=ZPGNxPq3P/9Fl5dyvTIazk4+gAmjqwxYNZORNw5X0/hDU6Z3CluZEFB4U0CNgLj1F1
         ikWk4A8RG/RJAPIfkvePThYxd9n3l2qSvUDjIS/P3dttM1Rfw+wnAeerf1wmxn/tPLCo
         gmEaYu4vvfMkBd8EUQpHPZ1LgGFGiC4YHW6QzWkhljs+NOhCGXNiIITR34Z/OnY6ukxM
         KH0aMhO0m2nxqTXa2EWDrbq/v3xNHB4vvANpj9J9Aabyjfet67gFlxIGs0Ut1bZEO5JF
         J/1UASgbN31kYH5e37Cp6s/eh2ZwMtr/3WBeKhZ2BB9L5AJY6jcy0n26ZotpPxfUDvqz
         t63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680791044;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1BMDugGBKbFd2rlOj+T4qAzKzXaWfgLdDkmdDGQCOLc=;
        b=XZIGRg5cbj3pEFyA4Ccx+RkxluotuCTWyW9RC+K4j5s6ywUaiYz12ry80t7O4CH3P3
         HVVYG24vL1cm1lkQIoC3aXwjiqiPTYhkOPDrIhNtkrajjAgTJ7Cbddhti0ol2D4XROBD
         MaToIKRf1dt58yNNqn1sUlX04qfQEZy83UwS2WCMUqyRoPcLCVqvlb8wBFoY/Ofq3CJM
         FJa0Fu1XFEGtIW966dRtWkbhRxJSdMzlqXP1KdclkTH8MvBbKq/BINeluk0Z3WlkHcUg
         /A1j7hRp0hSZDTwxUzcqin78rCcWSPpUJTOJDzMtXSAe7zLE8EBFIQ8Uq35rVbaJN8ET
         8MTQ==
X-Gm-Message-State: AAQBX9dHbs46leEbVTiIokO9SAFAQQAnsGvDUHpI9g+Rte/Fy0yuoAJg
        JtZgCOZMf2hKZb91f8UHZeBKMJs6G4k=
X-Google-Smtp-Source: AKy350Ze6E4UPrhGDccFGlcrvY+B2j8ZCITqFHfjP/gStjaCkEbe065q7JzRqbFU/pyKhTA9saYJnA==
X-Received: by 2002:a17:906:a00b:b0:930:60ba:d4b with SMTP id p11-20020a170906a00b00b0093060ba0d4bmr6875278ejy.37.1680791044091;
        Thu, 06 Apr 2023 07:24:04 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id va14-20020a17090711ce00b0093a7952411asm882455ejb.48.2023.04.06.07.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 07:24:03 -0700 (PDT)
Message-ID: <7fd26d16-39da-4880-9b91-dde7b1a15c97@gmail.com>
Date:   Thu, 6 Apr 2023 15:23:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 3/8] io_uring: refactor __io_cq_unlock_post_flush()
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <cover.1680782016.git.asml.silence@gmail.com>
 <662ee5d898168ac206be06038525e97b64072a46.1680782017.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <662ee5d898168ac206be06038525e97b64072a46.1680782017.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/6/23 14:20, Pavel Begunkov wrote:
> Instead of smp_mb() + __io_cqring_wake() in __io_cq_unlock_post_flush()
> use equivalent io_cqring_wake(). With that we can clean it up further
> and remove __io_cqring_wake().

I didn't notice patches 3 and 7 have the same subj. This one
should've better been called refactor io_cqring_wake().


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c |  6 ++----
>   io_uring/io_uring.h | 11 ++---------
>   2 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index fb7215b543cd..d4ac62de2113 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -640,10 +640,8 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>   	 * it will re-check the wakeup conditions once we return we can safely
>   	 * skip waking it up.
>   	 */
> -	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
> -		smp_mb();
> -		__io_cqring_wake(ctx);
> -	}
> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> +		io_cqring_wake(ctx);
>   }
>   


-- 
Pavel Begunkov
