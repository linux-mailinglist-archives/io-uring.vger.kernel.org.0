Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E478374840F
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 14:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjGEMUX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 08:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjGEMUW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 08:20:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0289B171A;
        Wed,  5 Jul 2023 05:20:18 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9936b3d0286so367182666b.0;
        Wed, 05 Jul 2023 05:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688559616; x=1691151616;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XJqWuDTxOojV52nKGH6FuhUr3MDJzai49WVwFsAjh4U=;
        b=QLhrb0VGTOq66Q23uaDP39gNyBwoRWWAeShXnLJv18OzaxJFFTMdVWB5gfuBm8D+pS
         fh2gAjDasBqDylwTKHq8vP5riZR/ljin8E/+MY1XmFw3cww9qHsHxQ/hnL//PgxElX6B
         nITy9xoGNmT8ba9l3VmN6RgEhKjCqgh/tDsZbEyHB4cz3CxA1WyOpatf8vvlEF4wy9JA
         aOSYl6dFmLsTd7qw6U8tRfaLiuATS4q3f6PfEAkfJ9ZwIt50Z6iDJx/g87QX2CmqfzVs
         cjlH5mM/NsV4Atc34+2MwL7/YOGUezKlwpgM2Xm0aaNTgBuC+MYOC1xTtbbPs2Q6FWuD
         xowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688559616; x=1691151616;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XJqWuDTxOojV52nKGH6FuhUr3MDJzai49WVwFsAjh4U=;
        b=Jv6b+U7obRfvOHBjRmR/ipoNuI2On3b2h/eGX7j9kjdqlotQ4nWSgBknrlA90PXrKI
         hrv636+DlgMcW/FMgZUpceiE3HJ1Ycdln0NwbL+9+mnE3AG2+ZSGNjLNJXUwn5lv2yxD
         r8KAtDhCwbxa4ZcpCXCcUfDLsBwe3/gghtzWL13OaHxfAVilsbVXQGGeZTaLRMe+vTRy
         OQhJGFllQ73UDAdbRi8aK7PLX8BjjK4F2ric676hbI880LuJ/Q88jpTqPTX7d6C0jtom
         1u3AU5jPGJkWaFU5m/niKNtlw6SXS7weg3Xqqu8KqU5Ic5NW6f/hW17AVpI9cICZ9dyp
         32Cg==
X-Gm-Message-State: ABy/qLYJseR4JzQsjYEdvh4Q4t8rOaFBraztoNm5S4bii0ZZEmotSEf3
        qdoPGdqZmRh9kSlMbl+qfqk=
X-Google-Smtp-Source: APBJJlHnlzSwSHJtCt5EPhFwZnqHqyBR8IULNUJPkpW0nL45JqlZMoq8j+xo3j027sriCJu5gf0fgg==
X-Received: by 2002:a17:906:3516:b0:985:34b:83b4 with SMTP id r22-20020a170906351600b00985034b83b4mr13660471eja.10.1688559616233;
        Wed, 05 Jul 2023 05:20:16 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id us3-20020a170906bfc300b00991bba473e2sm12456194ejb.85.2023.07.05.05.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 05:20:16 -0700 (PDT)
Message-ID: <7b13b4fa-42ff-40f7-bbf8-6f0f2f0ae052@gmail.com>
Date:   Wed, 5 Jul 2023 13:16:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 02/11] io-wq: add a new worker flag to indicate worker
 exit
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-3-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-3-hao.xu@linux.dev>
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
> Add a new worker flag IO_WORKER_F_EXIT to indicate a worker is going to
> exit. This is important for fixed workers.

nit: would be nice to add a small sentence _how_ it's important
for fixed workers



> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/io-wq.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index b70eebec2845..1717f1465613 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -29,6 +29,7 @@ enum {
>   	IO_WORKER_F_RUNNING	= 2,	/* account as running */
>   	IO_WORKER_F_FREE	= 4,	/* worker on free list */
>   	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
> +	IO_WORKER_F_EXIT	= 16,	/* worker is exiting */
>   };
>   
>   enum {
> @@ -592,6 +593,11 @@ static void io_worker_handle_work(struct io_worker *worker)
>   	} while (1);
>   }
>   
> +static bool is_worker_exiting(struct io_worker *worker)
> +{
> +	return worker->flags & IO_WORKER_F_EXIT;
> +}
> +
>   static int io_wq_worker(void *data)
>   {
>   	struct io_worker *worker = data;
> @@ -609,7 +615,7 @@ static int io_wq_worker(void *data)
>   		long ret;
>   
>   		set_current_state(TASK_INTERRUPTIBLE);
> -		while (io_acct_run_queue(acct))
> +		while (!is_worker_exiting(worker) && io_acct_run_queue(acct))
>   			io_worker_handle_work(worker);

Why it differs from the condition in io_wq_dec_running()? Would
sth like this work?

bool io_worker_run_queue(worker) {
         return !is_worker_exiting(worker) &&
                 io_acct_run_queue(worker_get_acct(worker));	
}


>   
>   		raw_spin_lock(&wq->lock);
> @@ -628,6 +634,12 @@ static int io_wq_worker(void *data)
>   		raw_spin_unlock(&wq->lock);
>   		if (io_run_task_work())
>   			continue;
> +		if (is_worker_exiting(worker)) {
> +			raw_spin_lock(&wq->lock);
> +			acct->nr_workers--;
> +			raw_spin_unlock(&wq->lock);
> +			break;
> +		}
>   		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
>   		if (signal_pending(current)) {
>   			struct ksignal ksig;

-- 
Pavel Begunkov
