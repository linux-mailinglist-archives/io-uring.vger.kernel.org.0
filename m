Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF174847E
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 14:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjGEM6Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 08:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjGEM6P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 08:58:15 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD5DA;
        Wed,  5 Jul 2023 05:58:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9891c73e0fbso136081866b.1;
        Wed, 05 Jul 2023 05:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688561893; x=1691153893;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AIZp05Hfv426kPlGeCqZ2clQ1popvUqLEfsP9qoz2zI=;
        b=k4M/511uYJVvxigA5YCnJi4vyFeiSxMqW4xu4SrPU6dScT0xgpCs5O4MXL7flQJKkQ
         2lpR4hyawqVt2tmBPEW6wh6Js/p0dgRMwwckljelkaC/4Lvoyg3XWQsebzs6dDaaP8yk
         KoyeP96rgPpPCLiaAwmWWoeiiKTD5S9BtdIrH7fhP/CzXi/4hDA/2rCKPMW0A0TKUztG
         o9UvaFkFzR4N7LpXll85yvIwLex2G88SBUEV1gNq15g3dKZLnHo2ATMrLD7zfFFsyK0a
         RhZlw7Hs5YzqXpTPZ6gUXf//P4G1wOWR+oOihBfZYUlf0vHHivaKTh53TMWKBDCrXDlR
         j/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688561893; x=1691153893;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AIZp05Hfv426kPlGeCqZ2clQ1popvUqLEfsP9qoz2zI=;
        b=UfnkPxkzimUeKstGxJ4Qt5GyI5LlH7uJ2rIKlheC0Jlk9SZHd9YgQsLGmnFKSMH252
         oBTaJ+rqC7t1qNACdJnYOX/zBwlGRNQHRDJwgz3KsxncE43ercqu5a7zF7X7bofB9EN2
         /sqTXIn+Yb8Xumc/QxL9uPBatsiZh19cECk5kutfY6uhbvfVHhvq2mXdfOZjFQe3DH0L
         sbB2Iplr42FHcrP9m1K6FzEP1unmWHls2IxqJLR7unAoIr4VurDvTkR/Z1V2EKMpIGch
         vM30dkzLtNGbDX6uN9tMdANtRvGptKFTKQsPlM2SVfmfRxkA4IksRgi2qZ/IcGjSq1+o
         uPcw==
X-Gm-Message-State: ABy/qLachvv9LbyL5oeti04jTBlSVLum4L2UmeQBKnGevYr6bu+PT3YE
        VuLas5pYegbgGKspEbLv7sa7wfD3rhU=
X-Google-Smtp-Source: APBJJlHwuP22vcLedYqB+E8cnSscA65/HpTnO32PrKLIdBul80aHWTPG/4KX1zsk/o5wBhTOM3cfUw==
X-Received: by 2002:a17:906:151:b0:989:1a52:72a1 with SMTP id 17-20020a170906015100b009891a5272a1mr1832966ejh.28.1688561892992;
        Wed, 05 Jul 2023 05:58:12 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id f5-20020a1709064dc500b0099342c87775sm5236548ejw.20.2023.07.05.05.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 05:58:12 -0700 (PDT)
Message-ID: <18d85f67-2952-3649-7716-eaf947f99123@gmail.com>
Date:   Wed, 5 Jul 2023 13:54:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 05/11] io-wq: add a new parameter for creating a new fixed
 worker
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-6-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-6-hao.xu@linux.dev>
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
> Add a new parameter when creating new workers to indicate if users
> want a normal or fixed worker.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/io-wq.c | 33 ++++++++++++++++++++-------------
>   1 file changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index bf9e9af8d9ca..048856eef4d4 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
[...]
>   
> +static bool is_fixed_worker(struct io_worker *worker)
> +{
> +	return worker->flags & IO_WORKER_F_FIXED;
> +} 

That's what I mentioned in the other comment.

> +
>   static void create_worker_cb(struct callback_head *cb)
>   {
>   	struct io_worker *worker;
> @@ -331,7 +337,7 @@ static void create_worker_cb(struct callback_head *cb)
>   	}
>   	raw_spin_unlock(&wq->lock);
>   	if (do_create) {
> -		create_io_worker(wq, worker->create_index);
> +		create_io_worker(wq, worker->create_index, is_fixed_worker(worker));
>   	} else {
>   		atomic_dec(&acct->nr_running);
>   		io_worker_ref_put(wq);
> @@ -398,6 +404,8 @@ static void io_wq_dec_running(struct io_worker *worker)
>   		return;
>   	if (!io_acct_run_queue(acct))
>   		return;
> +	if (is_fixed_worker(worker))
> +		return;

Aha, it's here. I was thinking about it a little bit more.
Is it even correct? If you have a mixed fixed/non-fixed setup
you presumably want non-fixed workers to kick in such situations.
I don't remember this creation voodoo well, maybe Jens does have
an idea.

>   
>   	atomic_inc(&acct->nr_running);
>   	atomic_inc(&wq->worker_refs);
> @@ -601,11 +609,6 @@ static bool is_worker_exiting(struct io_worker *worker)
>   	return worker->flags & IO_WORKER_F_EXIT;
>   }
[...]
> -static bool create_io_worker(struct io_wq *wq, int index)
> +static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
>   {
>   	struct io_wq_acct *acct = &wq->acct[index];
>   	struct io_worker *worker;
> @@ -833,10 +836,14 @@ static bool create_io_worker(struct io_wq *wq, int index)
>   	if (index == IO_WQ_ACCT_BOUND)
>   		worker->flags |= IO_WORKER_F_BOUND;
>   
> +	if (fixed)
> +		worker->flags |= IO_WORKER_F_FIXED;
> +
>   	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
>   	if (!IS_ERR(tsk)) {
> -		io_init_new_worker(wq, worker, tsk);
> -	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
> +		if (!fixed)
> +			io_init_new_worker(wq, worker, tsk);

Why do we skip io_init_new_worker()? I assume you putting it
into lists, but what about the rest? I.e.

	tsk->worker_private = worker;
	worker->task = tsk;
	set_cpus_allowed_ptr(tsk, wq->cpu_mask);


> +	} else if (fixed || !io_should_retry_thread(PTR_ERR(tsk))) {
>   		kfree(worker);
>   		goto fail;
>   	} else {
> @@ -947,7 +954,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
>   	    !atomic_read(&acct->nr_running))) {
>   		bool did_create;
>   
> -		did_create = io_wq_create_worker(wq, acct);
> +		did_create = io_wq_create_worker(wq, acct, false);
>   		if (likely(did_create))
>   			return;

-- 
Pavel Begunkov
