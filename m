Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29627484A7
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 15:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjGENIv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 09:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjGENIv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 09:08:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821371713;
        Wed,  5 Jul 2023 06:08:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-51d9695ec29so6596156a12.1;
        Wed, 05 Jul 2023 06:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688562528; x=1691154528;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OFf4C+pKolIfJ3FTnbxpNOuHewbB0HMsfKxPwpEYr2w=;
        b=LKSmiGUebgHvxwYc552nKdqelZCg0UjkxblXHZR9PEtd6EsNCgr6OYXx1/oe2QSI8Z
         QYQcHVZEslaY4kfyRC12+LIePC8O35KA0dPNo8sLm9vpybkMfDXXiMkI+F/XlmezwWRa
         Xb8kqbVx/zTtV6mEsu45D5a/aEpn0nPlJyjyHmQjfoNmrndmjTuHUYALeAOCUWU7Xx6m
         kbJaWvGJiYqgrxeKc08ynXB3zZ5PzSZPZeWpT1oANAaVaIX5KMKeRaUywudSn8AEwPij
         DZEpFt5dzaipnQsmjvhpiD4uCKt4pSdFkW6496Jh1nxeJdb+k94pnOCI81R4Eb9TtUbK
         qCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688562528; x=1691154528;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OFf4C+pKolIfJ3FTnbxpNOuHewbB0HMsfKxPwpEYr2w=;
        b=ECiZyOMUWyFg9RkQQMCchAa9cZR9ZzrsrfCk1tDwW7BobGh/7UkRC877dI3wyKieSF
         rB9aLNW8w3Aha+8/fv/iL+xe7HC+6JOVhzfjbCRd2nLsyxrYKnKhb/fcZR6DkfVMorOq
         ORGQ0jgvTMRDEHUC2iTPLPkbHbPNxTo9jE80Z/mB25RwPSLpT0jeJ+syV0PMD4/tQM7S
         EbUIHOlpVV0gtM9/eSv+e9GqGNcasREJBRp3qoe9MwcLfymS67sBCXZclVSjG9bg7Il9
         nuBMfqFEJPl0ne/k658wLongEObDEz8WyuwoJUij/YT93u32x+3e2ajjiyr5wS1Enq9m
         85Tw==
X-Gm-Message-State: ABy/qLZvzbZxOGu9VH2/VQH9g4gDg0wHl+b32MAs1Wwg2ns4tH9s9qKk
        2k9R62ET/FReZNJzteYLXce2z4zpuLA=
X-Google-Smtp-Source: APBJJlHeoWFYA2n5XwlT1gLj4iQXr07MQCK+quxyrzmDrHquH+8vbnMur+SwUvXshCvw19WiuM0JGg==
X-Received: by 2002:a17:906:abd2:b0:991:fd87:169e with SMTP id kq18-20020a170906abd200b00991fd87169emr10261988ejb.8.1688562527809;
        Wed, 05 Jul 2023 06:08:47 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id e14-20020a17090681ce00b009937dbabbd5sm3127426ejx.220.2023.07.05.06.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 06:08:47 -0700 (PDT)
Message-ID: <249ca970-23e9-7b72-722e-bce4aa644dfb@gmail.com>
Date:   Wed, 5 Jul 2023 14:05:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 06/11] io-wq: return io_worker after successful inline
 worker creation
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-7-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-7-hao.xu@linux.dev>
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
> After creating a io worker inline successfully, return the io_worker
> structure. This is used by fixed worker.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/io-wq.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 048856eef4d4..4338e5b23b07 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -137,7 +137,7 @@ struct io_cb_cancel_data {
>   	bool cancel_all;
>   };
>   
> -static bool create_io_worker(struct io_wq *wq, int index, bool fixed);
> +static struct io_worker *create_io_worker(struct io_wq *wq, int index, bool fixed);
>   static void io_wq_dec_running(struct io_worker *worker);
>   static bool io_acct_cancel_pending_work(struct io_wq *wq,
>   					struct io_wq_acct *acct,
> @@ -284,8 +284,8 @@ static bool io_wq_activate_free_worker(struct io_wq *wq,
>    * We need a worker. If we find a free one, we're good. If not, and we're
>    * below the max number of workers, create one.
>    */
> -static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct,
> -				bool fixed)
> +static struct io_worker *io_wq_create_worker(struct io_wq *wq,
> +					     struct io_wq_acct *acct, bool fixed)
>   {
>   	/*
>   	 * Most likely an attempt to queue unbounded work on an io_wq that
> @@ -297,7 +297,7 @@ static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct,
>   	raw_spin_lock(&wq->lock);
>   	if (acct->nr_workers >= acct->max_workers) {
>   		raw_spin_unlock(&wq->lock);
> -		return true;
> +		return NULL;

Something is not right here. The function could succeed even if it didn't
create a new worker. Now it's a failure.

>   	}
>   	acct->nr_workers++;
>   	raw_spin_unlock(&wq->lock);
> @@ -809,11 +809,11 @@ static void io_workqueue_create(struct work_struct *work)
>   		kfree(worker);
>   }
>   
> -static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
> +static struct io_worker *create_io_worker(struct io_wq *wq, int index, bool fixed)
>   {
>   	struct io_wq_acct *acct = &wq->acct[index];
>   	struct io_worker *worker;
> -	struct task_struct *tsk;
> +	struct task_struct *tsk = NULL;
>   
>   	__set_current_state(TASK_RUNNING);
>   
> @@ -825,7 +825,7 @@ static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
>   		acct->nr_workers--;
>   		raw_spin_unlock(&wq->lock);
>   		io_worker_ref_put(wq);
> -		return false;
> +		return tsk ? (struct io_worker *)tsk : ERR_PTR(-ENOMEM);

How it this conversion valid? I don't remember us overlaying struct
io_worker onto task_struct

>   	}
>   
>   	refcount_set(&worker->ref, 1);
> @@ -841,8 +841,8 @@ static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
>   
>   	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
>   	if (!IS_ERR(tsk)) {
> -		if (!fixed)
> -			io_init_new_worker(wq, worker, tsk);
> +		io_init_new_worker(wq, worker, tsk);
> +		return worker;
>   	} else if (fixed || !io_should_retry_thread(PTR_ERR(tsk))) {
>   		kfree(worker);
>   		goto fail;
> @@ -851,7 +851,7 @@ static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
>   		schedule_work(&worker->work);
>   	}
>   
> -	return true;
> +	return (struct io_worker *)tsk;
>   }
>   
>   /*

-- 
Pavel Begunkov
