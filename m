Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF70679B12
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 15:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbjAXOFD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Jan 2023 09:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbjAXOEw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Jan 2023 09:04:52 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A696A4859B;
        Tue, 24 Jan 2023 06:04:21 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bk15so39193373ejb.9;
        Tue, 24 Jan 2023 06:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z7dRloswEV6O4FN2iiz6ZS4n2jKn6i71GuWTIh1+d6c=;
        b=ZM+3T5Y+1o/Xr4JI8qDG+x0+yhUFZx7dOowdLYw01bMwVcGvO3wY1d3/SCGoOTZNOe
         Fe0hgNCf0nVXF1VEsM6GgU0dYtbBDcUZSyScCz53HpWLmkLIiOUDtXO5sDUucZhVVmGF
         lM9z+mu0spGpmNm9nETCXb9c3hBLMJhLAIFI97q9fUAb0ZrykXtTG4qME6CHw1BnB9iv
         3jTliBp6JuLhQrJt2fiU2R6VZhDFzVj3hdXRjEa83po6+Hff1wPGrNU7aWxaLZePgLUr
         W9OugBNhPTeok059hFbqFUk6erTwddYx0AAUJRsjslOG/QGcCY7enHPopecYFgHC+2+F
         +85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z7dRloswEV6O4FN2iiz6ZS4n2jKn6i71GuWTIh1+d6c=;
        b=ORO3Cd6pyWpGnp+A4UqzVxAhMy2QshffALwtT53xM70evbst6tnxrW6AHQoQk9DN8X
         jKzVnrjAmU7rlO4jpwKZDKsUKnkfEulFBZInW9deHbkGuulKmtEr0YHKh3NuB60EyeyF
         vgko2+dCW2dpihbSls31ZNkJp4AkjgzekpF0ixWsn+1sJxqpENKoFdrvaQnFeSApJsz2
         8AlPP7DGsoJS3CIjOgcWdRWv8ItNEzGhWOR6Y6l2IGqSob5MbEI5W9qFKrF8ezg49AGK
         lEgURaJNXGhnyaOYfXGwCcQamr1Q48vBhHZzs27MtvEXNVD+K8/PI+7xZB8iuPTf/jno
         Xvug==
X-Gm-Message-State: AFqh2kqCuo5s2bBGddnZ/GabxUX/lJ4nm44hEcX+FyGMh3R9YIxANj0c
        5VzRxiS1UykbRgbQlLH2gvk=
X-Google-Smtp-Source: AMrXdXttKKi+iLAmx5d8d5yerYPKvbMZTKXClJq6rTidBrzh7/IKlMLyt82AtvsCotlbkVuV2jyhXA==
X-Received: by 2002:a17:906:e2cd:b0:870:2aa7:6509 with SMTP id gr13-20020a170906e2cd00b008702aa76509mr30689651ejb.43.1674569059643;
        Tue, 24 Jan 2023 06:04:19 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::206f? ([2620:10d:c092:600::2:74e0])
        by smtp.gmail.com with ESMTPSA id s22-20020a170906501600b0085ca279966esm945567ejj.119.2023.01.24.06.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 06:04:19 -0800 (PST)
Message-ID: <077b10a5-5ccb-870c-3dd2-e96bc6aad5ef@gmail.com>
Date:   Tue, 24 Jan 2023 14:01:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] io_uring: initialize count variable to 0
To:     Tom Rix <trix@redhat.com>, axboe@kernel.dk, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230124125805.630359-1-trix@redhat.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230124125805.630359-1-trix@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/24/23 12:58, Tom Rix wrote:
> The clang build fails with
> io_uring/io_uring.c:1240:3: error: variable 'count' is uninitialized
>    when used here [-Werror,-Wuninitialized]
>    count += handle_tw_list(node, &ctx, &uring_locked, &fake);
>    ^~~~~
> 
> The commit listed in the fixes: removed the initialization of count.

My bad. The patch looks good, thanks


> Fixes: b5b57128d0cd ("io_uring: refactor tctx_task_work")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   io_uring/io_uring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 734d074cdd94..4cb409ae9840 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1227,7 +1227,7 @@ void tctx_task_work(struct callback_head *cb)
>   	struct llist_node fake = {};
>   	struct llist_node *node;
>   	unsigned int loops = 0;
> -	unsigned int count;
> +	unsigned int count = 0;
>   
>   	if (unlikely(current->flags & PF_EXITING)) {
>   		io_fallback_tw(tctx);

-- 
Pavel Begunkov
