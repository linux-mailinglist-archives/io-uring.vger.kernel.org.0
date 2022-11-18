Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B173862FCF5
	for <lists+io-uring@lfdr.de>; Fri, 18 Nov 2022 19:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbiKRSq7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Nov 2022 13:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbiKRSq6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Nov 2022 13:46:58 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489C18FB02
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 10:46:57 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z18so8353434edb.9
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 10:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FbVYV76zfJefcPQII/hZLOrQIsWs0YNKnrJYQDyuY8M=;
        b=JS8Lsrtx+qH+LMpxkqiCGPoIVvyN3G8u5sNkpwsthAMlKwX9QdWo7MpLQiuBzAKGTJ
         G0m3v5GvW6zKVbJhYShQgGWH+qUqGEwRw75giRAsLG6Ul6LkYDWAA2oiEiXEua+wSDbZ
         bPRcTDz4zOMWSUJeetqdnv5PhSfMyKE1g7viYeBtYMJh7QEXnZ80JWC18J1WTs5zGpkx
         yb7Olc53OxBPQa4kiarV12HIkUHZ/EIJDLoL05SXsHlZz4awG27Smmnw+YAd/ekSt00f
         3Z91DaNpo08xbKzAMUi817xeocbaRuqpDoyRm28jTodmsA587e01E4uarmQ7j7m4NRe3
         A+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FbVYV76zfJefcPQII/hZLOrQIsWs0YNKnrJYQDyuY8M=;
        b=F1o+ifnxZCCzcHxtHf9IkwdNCeMWWXrYh4rFMI+mrSQ6QY0qpsAUW56XOsKIdkAoyn
         P73X7B8Vkf8UbeOqAQrk9+95OHsztPbv/0mOe5j5diDki4zYDkBwJPWsduFoTTbQ//G8
         gkw+YhF4vRDT4UbU99InB0epLVlsVEuBBLHr/lCNujYBkG1tFybycItUZkiCzumVIWFf
         7xPkVmK3JU2Q8EcA1iN5eewgQduk5iAIU92dM2+o4/OfcxUhCRkGYmFBm123Obnv+ihg
         1mQflrrVBaVLTXG7MvBL8HXi+dDKed1Lepw2LR6rFxrL5u4MX/yyhJ7Vc9duDkDAeGaU
         PFHA==
X-Gm-Message-State: ANoB5plgVs6OTq93AvlPEYIzwqGPc4sdEl2MZUlIqFt3vwdxMTAHGO8B
        neHpwYfcHA7G41Vrrg0rJxBJqle9Qc8=
X-Google-Smtp-Source: AA0mqf6wXdZIavTVJy/4/vjV/8wcittA8lKw/ORb5uCRXWmhCOWmQrVjExPG4bgTzyoVn1K0H0NJHQ==
X-Received: by 2002:a05:6402:370e:b0:464:fa1:9dc3 with SMTP id ek14-20020a056402370e00b004640fa19dc3mr2417298edb.343.1668797215643;
        Fri, 18 Nov 2022 10:46:55 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:38ce])
        by smtp.gmail.com with ESMTPSA id q23-20020a170906361700b007adbd01c566sm2030648ejb.146.2022.11.18.10.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 10:46:55 -0800 (PST)
Message-ID: <4235ff19-205d-4034-c586-75c7356909a4@gmail.com>
Date:   Fri, 18 Nov 2022 18:46:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-6.1 1/1] io_uring: make poll refs more robust
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Lin Horse <kylin.formalin@gmail.com>
References: <47cac5a4cb6b2e8d2f72f8f94adb088dbfd9308c.1668796727.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <47cac5a4cb6b2e8d2f72f8f94adb088dbfd9308c.1668796727.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/18/22 18:39, Pavel Begunkov wrote:
> poll_refs carry two functions, the first is ownership over the request.
> The second is notifying the io_poll_check_events() that there was an
> event but wake up couldn't grab the ownership, so io_poll_check_events()
> should retry.
> 
> We want to make poll_refs more robust against overflows. Instead of
> always incrementing it, which covers two purposes with one atomic, check
> if poll_refs is large and if so set a retry flag without attempts to
> grab ownership. The gap between the bias check and following atomics may
> seem racy, but we don't need it to be strict. Moreover there might only
> be maximum 4 parallel updates: by the first and the second poll entries,
> __io_arm_poll_handler() and cancellation. From those four, only poll wake
> ups may be executed multiple times, but they're protected by a spin.

Hmm, a second though, it may lose some events, I need to come up
with something better.


> Cc: stable@vger.kernel.org
> Reported-by: Lin Horse <kylin.formalin@gmail.com>
> Fixes: aa43477b04025 ("io_uring: poll rework")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/poll.c | 33 +++++++++++++++++++++++++++++----
>   1 file changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 055632e9092a..63f152332bf6 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -40,7 +40,15 @@ struct io_poll_table {
>   };
>   
>   #define IO_POLL_CANCEL_FLAG	BIT(31)
> -#define IO_POLL_REF_MASK	GENMASK(30, 0)
> +#define IO_POLL_RETRY_FLAG	BIT(30)
> +#define IO_POLL_REF_MASK	GENMASK(29, 0)
> +#define IO_POLL_RETRY_MASK	(IO_POLL_REF_MASK | IO_POLL_RETRY_FLAG)
> +
> +/*
> + * We usually have 1-2 refs taken, 128 is more than enough and we want to
> + * maximise the margin between this amount and the moment when it overflows.
> + */
> +#define IO_POLL_REF_BIAS	128
>   
>   #define IO_WQE_F_DOUBLE		1
>   
> @@ -58,6 +66,21 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
>   	return priv & IO_WQE_F_DOUBLE;
>   }
>   
> +static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
> +{
> +	int v;
> +
> +	/*
> +	 * poll_refs are already elevated and we don't have much hope for
> +	 * grabbing the ownership. Instead of incrementing set a retry flag
> +	 * to notify the loop that there might have been some change.
> +	 */
> +	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
> +	if (!(v & IO_POLL_REF_MASK))
> +		return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
> +	return false;
> +}
> +
>   /*
>    * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
>    * bump it and acquire ownership. It's disallowed to modify requests while not
> @@ -66,6 +89,8 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
>    */
>   static inline bool io_poll_get_ownership(struct io_kiocb *req)
>   {
> +	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
> +		return io_poll_get_ownership_slowpath(req);
>   	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
>   }
>   
> @@ -233,7 +258,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>   		 * and all others are be lost. Redo vfs_poll() to get
>   		 * up to date state.
>   		 */
> -		if ((v & IO_POLL_REF_MASK) != 1)
> +		if ((v & IO_POLL_RETRY_MASK) != 1)
>   			req->cqe.res = 0;
>   
>   		/* the mask was stashed in __io_poll_execute */
> @@ -274,7 +299,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>   		 * Release all references, retry if someone tried to restart
>   		 * task_work while we were executing it.
>   		 */
> -	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
> +	} while (atomic_sub_return(v & IO_POLL_RETRY_MASK, &req->poll_refs));
>   
>   	return IOU_POLL_NO_ACTION;
>   }
> @@ -590,7 +615,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   		 * locked, kick it off for them.
>   		 */
>   		v = atomic_dec_return(&req->poll_refs);
> -		if (unlikely(v & IO_POLL_REF_MASK))
> +		if (unlikely(v & IO_POLL_RETRY_MASK))
>   			__io_poll_execute(req, 0);
>   	}
>   	return 0;

-- 
Pavel Begunkov
