Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E730053EA49
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiFFL7z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 07:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiFFL7z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 07:59:55 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF23B287F7D
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 04:59:53 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n124-20020a1c2782000000b003972dfca96cso7791987wmn.4
        for <io-uring@vger.kernel.org>; Mon, 06 Jun 2022 04:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zo8ps+m5NBtsAU2q437NoTq1VpqJZncrAgFc/dWGV5A=;
        b=aHfoAlY+TwoGwHx/zWXVaXeC2CFp78yyj6ZbgCcTishvco2DXGZer0yEKlyBGtw0qV
         caGjMDIeRLv6MFS7J/PS1sW11VZS+OVx3Bj6gHc2806RS5NVefy+I+kVqQhbJIsRC+X7
         pbzBFdjemTxvrNzDdkAEWfjGwRj+6Dve/BK+WtSt9zDIU4v0cXKBRDptKwxvdwWVYmRg
         jfTU2uMQYmjXMn9jt2+85ffui0LRMRA74DSCi2PwPKhXe2qiO48xdkMD+6GY6sREgRhT
         g0wK/KtRgp1oJEw2OY3fUGMPODWqZpdnsw1tFTlIe/bkB/Z63UHci0mwJH9mn+scbiDq
         TaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zo8ps+m5NBtsAU2q437NoTq1VpqJZncrAgFc/dWGV5A=;
        b=Id8Q5oAcJX1hCM+CkO59QFehRHGvyWpy0Yr2BveYeO2sD5kDvwMThK9V7SuxeChQQm
         juFCfMf2yTcsdugHjJFDNeC+0mzhf0M/GcBe+lga/+wo2rxtr90IRBbt6qU1ghU2V1J6
         crV41UNK23iZQoPb2Z1Fc3TY67h+APIAq0+XbvpXClLitq32MnGSLjyHqkMkViY1e5HW
         UthgJMDV9SbZCmxDW2lAzCxFX1dwzrYS/dx0Ec4PJvOi2ksfB/Jr+r2voc21Aoq5y+67
         DM3ej08slHZEFPDKnr5AwamST0uEvleSwgt3a6RBbq1YM9zE4ff5X6rRJaUuKW+DdKzI
         0Bsw==
X-Gm-Message-State: AOAM530s2TF8IyhE0swBU/j7mawOEJl7b9yyNYlm64wmVYRkqlYM49aH
        OY+7sjiX3TmLFvjMtbZtm7I=
X-Google-Smtp-Source: ABdhPJxNahTh5pVqhdD+tVfCHStXOfBvHCMywrLb5yGFcdG5sA0C1KlbWxYoXZKDlsf0OcS/vfZoPA==
X-Received: by 2002:a7b:ce12:0:b0:39c:3cd4:4dd8 with SMTP id m18-20020a7bce12000000b0039c3cd44dd8mr17744911wmc.181.1654516792456;
        Mon, 06 Jun 2022 04:59:52 -0700 (PDT)
Received: from [192.168.43.77] (82-132-232-174.dab.02.net. [82.132.232.174])
        by smtp.gmail.com with ESMTPSA id o34-20020a05600c512200b003944821105esm19213066wms.2.2022.06.06.04.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 04:59:52 -0700 (PDT)
Message-ID: <3e1eaa9d-9b96-84a8-8fca-539bea3c24ae@gmail.com>
Date:   Mon, 6 Jun 2022 12:59:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/3] io_uring: add hash_index and its logic to track req
 in cancel_hash
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
 <20220606065716.270879-2-haoxu.linux@icloud.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220606065716.270879-2-haoxu.linux@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 07:57, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a new member hash_index in struct io_kiocb to track the req index
> in cancel_hash array. This is needed in later patches.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/io_uring_types.h | 1 +
>   io_uring/poll.c           | 4 +++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
> index 7c22cf35a7e2..2041ee83467d 100644
> --- a/io_uring/io_uring_types.h
> +++ b/io_uring/io_uring_types.h
> @@ -474,6 +474,7 @@ struct io_kiocb {
>   			u64		extra2;
>   		};
>   	};
> +	unsigned int			hash_index;

Didn't take a closer look, but can we make rid of it?
E.g. computing it again when ejecting a request from
the hash? or keep it in struct io_poll?

>   	/* internal polling, see IORING_FEAT_FAST_POLL */
>   	struct async_poll		*apoll;
>   	/* opcode allocated if it needs to store data for async defer */
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 0df5eca93b16..95e28f32b49c 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -74,8 +74,10 @@ static void io_poll_req_insert(struct io_kiocb *req)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct hlist_head *list;
> +	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
>   
> -	list = &ctx->cancel_hash[hash_long(req->cqe.user_data, ctx->cancel_hash_bits)];
> +	req->hash_index = index;
> +	list = &ctx->cancel_hash[index];
>   	hlist_add_head(&req->hash_node, list);
>   }
>   

-- 
Pavel Begunkov
