Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A454B70F855
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 16:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjEXOIm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 May 2023 10:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbjEXOIl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 May 2023 10:08:41 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DA6119
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 07:08:35 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-760dff4b701so7729239f.0
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 07:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684937315; x=1687529315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n5fOiDkeWWk5vKlwhdYrusenR1JzKh6BZcppzLudC4Q=;
        b=GOMQL5mJ6vNNYqG81bydG0+S1dULiipdVhWhIuOcg9sNmkcBZy+gkMeNZUjQ0tQ9Rb
         n4xR2lNBf8TGZ1Sd4kC9rKTlGyyYsJgr8+iQU2Z/toQ438aipj/5IMhV/djoboK8hpcS
         /jbCG+D0+G2tG66Ne/qRoJWbWMui203EFhVHQGPT1vTp2ZmU1L4td6O1BOHjCKuRa67P
         1+3K1fvhnwtCC7DXzAgo0hBIKg/CzA/ZwhVxIb44dCeOA1Zy9YpURkWDEzfl1IKH9N/R
         pDFcbM63g2XtOFBmPYy/9s0SLlP2wWFaxUSX0y1tpP7bVmQyoQxhmbjYJ4VQRzCmkpV5
         QVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684937315; x=1687529315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n5fOiDkeWWk5vKlwhdYrusenR1JzKh6BZcppzLudC4Q=;
        b=XG8GKxcfOlk24R8xEJcxvgYR4vOgfyLOZQY0VWAt/UEGYBrU0JC7AKDRzjUJSuxYR5
         /TE2skRbKRJLm9ahgYaG4x9uHuMC2wAWMozw/HaFlKudugqPi67ppMv9eTkVrfBa/UCS
         TKh0wXUu9Mi8ptU7J7ZQEEVWK5t99ZuozHEZIDKveRho6MEOQ6ineplVxtwn48y+DvoW
         cfS9tezgFH64+/Xess86NpuW5NEsAJW2nNY4h9MF2mULPlJ+PR6XCvoWWNw/YOSS35BT
         UDDjkRE+EmpUcFNMHL7PlBIAST+V36SshH/XT+Uxi9lhJefptaM+Nc6HbqxSsvGcZQYf
         En6g==
X-Gm-Message-State: AC+VfDyQHW9SyLRO9xuPXopNdhkVcPuGBee/WxH+TDL9Sjelt2Bz0qwi
        eQvFSmNrChhz+/EVCEcX1BSsGD0BppXKJpgMD3w=
X-Google-Smtp-Source: ACHHUZ7Ht8fXR2b6+VTIv+VVwVKUoMGL9ugSkLemdNIfp9ud8qylxRdq9BAYZsrxGpsxbfzgFBxBwA==
X-Received: by 2002:a05:6602:3420:b0:774:8571:a6dd with SMTP id n32-20020a056602342000b007748571a6ddmr3575182ioz.2.1684937315040;
        Wed, 24 May 2023 07:08:35 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c16-20020a5ea910000000b00760ad468988sm3398095iod.24.2023.05.24.07.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 07:08:34 -0700 (PDT)
Message-ID: <c9b340b8-feba-21a1-de30-36da27c6dffe@kernel.dk>
Date:   Wed, 24 May 2023 08:08:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] io_uring: unlock sqd->lock before sq thread release CPU
Content-Language: en-US
To:     Wenwen Chen <wenwen.chen@samsung.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <CGME20230524052154epcas5p313d92a9cbf0fa7e9555f8dd00125539e@epcas5p3.samsung.com>
 <20230524052801.369798-1-wenwen.chen@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230524052801.369798-1-wenwen.chen@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/23 11:28?PM, Wenwen Chen wrote:
> The sq thread actively releases CPU resources by calling the 
> cond_resched() and schedule() interfaces when it is idle. Therefore,
> more resources are available for other threads to run.
> 
> There exists a problem in sq thread: it does not unlock sqd->lock before
> releasing CPU resources every time. This makes other threads pending on
> sqd->lock for a long time. For example, the following interfaces all 
> require sqd->lock: io_sq_offload_create(), io_register_iowq_max_workers()
> and io_ring_exit_work().
>        
> Before the sq thread releases CPU resources, unlocking sqd->lock will 
> provide the user a better experience because it can respond quickly to
> user requests.
> 
> Signed-off-by: Kanchan Joshi<joshi.k@samsung.com>
> Signed-off-by: Wenwen Chen<wenwen.chen@samsung.com>
> ---
>  io_uring/sqpoll.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 9db4bc1f521a..759c80fb4afa 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -255,7 +255,9 @@ static int io_sq_thread(void *data)
>  			sqt_spin = true;
>  
>  		if (sqt_spin || !time_after(jiffies, timeout)) {
> +			mutex_unlock(&sqd->lock);
>  			cond_resched();
> +			mutex_lock(&sqd->lock);
>  			if (sqt_spin)
>  				timeout = jiffies + sqd->sq_thread_idle;
>  			continue;

Since this is the spin case, and we expect (by far) most of these
to NOT need a reschedule, I think we should do:

	if (need_resched()) {
		mutex_unlock(&sqd->lock);
		cond_resched();
		mutex_lock(&sqd->lock);
	}

to make that lock shuffle dependent on the need to reschedule. And
since we're marking the timeout at that point, timeout should be
assigned first as far as I can tell. So in total:

	if (sqt_spin || !time_after(jiffies, timeout)) {
		if (sqt_spin)
 			timeout = jiffies + sqd->sq_thread_idle;
 		if (unlikely(need_resched())) {
			mutex_unlock(&sqd->lock);
			cond_resched();
			mutex_lock(&sqd->lock);
		}
		continue;
	}

would probably be the better fix.

-- 
Jens Axboe

