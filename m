Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9FB97484C7
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 15:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjGENSz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 09:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjGENSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 09:18:54 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAE01719;
        Wed,  5 Jul 2023 06:18:53 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f766777605so10437879e87.1;
        Wed, 05 Jul 2023 06:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688563132; x=1691155132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u6OXN6xrnDuH3VdZutuoWMpvkMrJk+27Xq+IM0BBk+o=;
        b=sb5mtd11vzDJJjiqWY5L9CdExjLK2ZdJZErws26JSL5yL1ip/z1N34J2nO0gyUjEeq
         rS6UBu9RG2gDBtn4lQZ8+G+R+G5btnrxJWNv22FJua8ErF/LyRSg8kgPKmuKtNqqfEGs
         2H9z/5rvuChjGInxdRY4xyP/xTZSVQZAG0L1rhisN//e5IRXroQ1zdG9hwG51aipfQVk
         uhyZ0OKd97JTBD272HU/DeUP1Q1T4Bn4PTeY2SDxGm7Uondawq6CveqadmiElrHsOyFc
         +z/ItOAut1ISVgBIe47Qatw+23PLt40/uFueBOEi+mEPsD9TFTlg9H/ACNgKr9AfdKpC
         cpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688563132; x=1691155132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u6OXN6xrnDuH3VdZutuoWMpvkMrJk+27Xq+IM0BBk+o=;
        b=HvSDXs/N5vbqD0LlXcl0BUi1074mCCHs+X8smVywzuPnK+D44cHOHARVf7PXhq5TdV
         p7LkQWRHq75Ua/hLV3Fd5hAowpi1aXZIWuihn4jZY0ilhQcQ0/QVAdS2Rm8z3nlrZJ12
         /1NVJBaLc4C7duuL1+KqL6vBW7+Lb3KVhnfA699YCiIwMSsCeYuBIz9krJb293cPJWjH
         NUA0kupYLxbZwBLQOy67FLkevEBjm1LiEoQ5umW62pEKWhOJ06Jw1lmcxvmSKzUwa4rV
         q6K1Uac+OZ11uMjfCG7rxyVxV8Hz3w8XCXbBMTINZpqnwHVJQ4RaswHVfUu1A9PEzBry
         lxEg==
X-Gm-Message-State: ABy/qLb4z9v/sCBYff79E9gO8ToWvQinBgyQJiLa5YFgDnV/DjmtfeU5
        CjhCQFg2rnvewmgrQwxH0yw=
X-Google-Smtp-Source: APBJJlGNPcsUlaz6tiZUtXuYALjr2dsNo6lVRnRxgiC/aYX+m0ZsYLHgKs8kFoPq50s8Y3okCkwTuQ==
X-Received: by 2002:a05:6512:3b28:b0:4fb:73ce:8e7d with SMTP id f40-20020a0565123b2800b004fb73ce8e7dmr13955098lfv.15.1688563131482;
        Wed, 05 Jul 2023 06:18:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id d1-20020a056402516100b0051e186a6fb0sm3175235ede.33.2023.07.05.06.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 06:18:51 -0700 (PDT)
Message-ID: <c6fdbcfd-a9dc-629d-8312-d82158325933@gmail.com>
Date:   Wed, 5 Jul 2023 14:15:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 10/11] io-wq: distinguish fixed worker by its name
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-11-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-11-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/23 13:20, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Distinguish fixed workers and normal workers by their names.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/io-wq.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 61cf6da2c72f..7a9e5fa19b81 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -634,10 +634,12 @@ static int io_wq_worker(void *data)
>   	struct io_wq *wq = worker->wq;
>   	bool exit_mask = false, last_timeout = false;
>   	char buf[TASK_COMM_LEN];
> +	bool fixed = is_fixed_worker(worker);
>   
>   	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
>   
> -	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
> +	snprintf(buf, sizeof(buf), fixed ? "iou-fixed-%d" : "iou-wrk-%d",
> +		 wq->task->pid);

Minor nit: iou-wrk-fixed should be better, it still tells that it's
a worker and I think it should be more familiar to users.

>   	set_task_comm(current, buf);
>   
>   	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
> @@ -656,7 +658,7 @@ static int io_wq_worker(void *data)
>   		 * fixed worker, they can be manually reset to cpu other than
>   		 * the cpuset indicated by io_wq_worker_affinity()
>   		 */
> -		if (!is_fixed_worker(worker) && last_timeout &&
> +		if (!fixed && last_timeout &&
>   		    (exit_mask || acct->nr_workers > 1)) {
>   			acct->nr_workers--;
>   			raw_spin_unlock(&wq->lock);

-- 
Pavel Begunkov
