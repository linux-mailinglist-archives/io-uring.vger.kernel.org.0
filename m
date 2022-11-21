Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037FC632B24
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 18:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiKURhR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 12:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiKURhL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 12:37:11 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1E1D229F
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 09:37:06 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q13so520134ild.3
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 09:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MO0lXOaUJMcSU5gcE4R86VgJetqMf/tYYGUYIliy6BY=;
        b=qtEtmo04Cip0qdaiMu9+pZcN+2ePGBLBpZ3xi6T8E9z5eUaIPyaHkY8qdoa8Za8u0k
         msifVNk12PLwyfGTvnMZ/PUJy2tRbi3m2YSyRfwVtNks/l+UoQ4CG/dODyTInAsLHOFd
         GVmEgYW9jHiYwT92EVavk8sxPF/RXxsfxoKjCzPpLmS2zKi4wYH+URuzpWwmTEsMfPBP
         6vV49eGw4cK8TA0z77up72hQbUQtew6eBtu76BDG766jiGjEVlLTnhYimP93Q8qKH5iD
         X42vaD9SCIqHaPbQajf9MvhDZe7bhHnSDjWGHCz3AAVFsG84uwZAbr4vu8G2uNERzQVZ
         ANFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MO0lXOaUJMcSU5gcE4R86VgJetqMf/tYYGUYIliy6BY=;
        b=AFDBusFiS9Nb4zaiJw8CFsM8o1TZzjHHtFY75aZ/vu73Gx7Tso+5jTJK3zKO5loEXq
         8w+q8SheIkOxV6pBGWa/tfqjU0+PrsjjFk5eihVcCmyKa6eiK/gfGf2drPo9ZAIdxZUi
         irhfMKRvCzu9L8bLL+MN098EhRp7QytZvIAlSW8e8aYKy6WvRwJLa+2I6gGoJAaHhn5M
         kKfB/jCw+fojZ8Jh/A4mjJXaoOjP7pPG/hk9jk+hH3xZJ/3c6fAxr/3qO57PGOoa1/fu
         22mtsDM54L1H0ez40m2P0MBGccIJaN3srWIDKziL2e6eQDkN59Karo+u7BH50zhQSPdb
         FZHg==
X-Gm-Message-State: ANoB5pkhxmQjQVX5jyBFaksVTA4ywKcd/eWezb09zB9ZztsC8gkQWq7+
        SavcANQf8toJeLmUvEvIltzWyQ==
X-Google-Smtp-Source: AA0mqf7Bss4XzXRaMHLIiEwELIJgyOiC4NAJfphjOUwsXlCDwvtalBnz1hyWRY7spIAWa/7EqtQJJA==
X-Received: by 2002:a92:dd82:0:b0:2f6:52ad:27e2 with SMTP id g2-20020a92dd82000000b002f652ad27e2mr8158908iln.285.1669052226081;
        Mon, 21 Nov 2022 09:37:06 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b21-20020a056602331500b006ccc36c963fsm4462455ioz.43.2022.11.21.09.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 09:37:05 -0800 (PST)
Message-ID: <33473b5b-5d56-a6cd-b95e-726d778502c9@kernel.dk>
Date:   Mon, 21 Nov 2022 10:37:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH v4 2/3] io_uring: add api to set / get napi
 configuration.
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
References: <20221121172953.4030697-1-shr@devkernel.io>
 <20221121172953.4030697-3-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221121172953.4030697-3-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/21/22 10:29?AM, Stefan Roesch wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4f432694cbed..cf0e7cc8ad2e 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -4122,6 +4122,48 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>  	return ret;
>  }
>  
> +static int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	const struct io_uring_napi curr = {
> +		.busy_poll_to = ctx->napi_busy_poll_to,
> +	};
> +	struct io_uring_napi *napi;
> +
> +	napi = memdup_user(arg, sizeof(*napi));
> +	if (IS_ERR(napi))
> +		return PTR_ERR(napi);
> +
> +	WRITE_ONCE(ctx->napi_busy_poll_to, napi->busy_poll_to);
> +
> +	kfree(napi);
> +
> +	if (copy_to_user(arg, &curr, sizeof(curr)))
> +		return -EFAULT;
> +
> +	return 0;
> +#else
> +	return -EINVAL;
> +#endif
> +}

This should return -EINVAL if any of the padding or reserved fields are
non-zero. If you don't do that, then it's not expendable in the future.

-- 
Jens Axboe
