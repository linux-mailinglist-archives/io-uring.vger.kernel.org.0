Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7687174842A
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 14:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjGEM3m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 08:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjGEM3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 08:29:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C312B0;
        Wed,  5 Jul 2023 05:29:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-98e011f45ffso653728866b.3;
        Wed, 05 Jul 2023 05:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688560179; x=1691152179;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dc8VA3wsbqCNo86QVviqL+IZiWA8s57MBU3O/pEOqYc=;
        b=POHujdyZhsLMjuYlHANrc0WYJ8GCyvdYXGsPZF8KAUPSpAyiikd+RnticqdQ87/6FO
         g/tYCs7NE7/9reOxfRvSWL2A5DkTVKcfBH7SY9QkvyAeAFO0b0so/lw+SR23njpXNP+u
         /3887f4cUANoAxJXuaQI+BJXiRQCMB0SQeoUb05NLqOGFXJ+kwsxo6CnaLDIDPmrfIqz
         5Qgp7V0wI/e6UKkZfzRoHYgJ05zK2ywExt55Ux+XDOsiRuLszZbBWSncVWrquLFxvrJU
         3Dabt9v0dsBBnzJq6FHcSqeez4GtRjj8UEXX3bcQaNLEGpdVmUQP95qox+ph1XevqTG9
         G4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688560179; x=1691152179;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc8VA3wsbqCNo86QVviqL+IZiWA8s57MBU3O/pEOqYc=;
        b=BB+/vOq+ucniJAnih8RbzLeR40PssW+m+ki7noPig59crY+YKTykZkELPVwzsJqfjx
         vtC+hUl/+SLEf57S9hCsHVi1Q6TjqFksOLIRp4Qihf5rg1T8OTnd2bqW0qQ7Us7YJGpa
         PrXRkgd7Hff7mKrw6OWbxhraq/lX26SvfJzkuKsRiHUavje//fbEMQ8FXmgDR3UHPFHQ
         /ngv5LBzplwlYvDcwgnYmmt0clNJscil+VMx30eX2RH4Ht5JXa9nejpZED6dDVuT7B+/
         XXye/2INOZ3c6IyAVZNGW23RBRHaft7ssZP8d5RXZNIhp/gtZeLvdkcB0qsb1jfkftxZ
         lybg==
X-Gm-Message-State: ABy/qLZ9q5YD2Id0jjjlKsMX3LvcqFYcGoJqRJOIzFUpTGucO11avmQ3
        hDA3Z5fGHC3PNamJ41d9m8Y=
X-Google-Smtp-Source: APBJJlG+fgpUrk2ZFcfYJKTSk7YfIEe9CmxG85SOYUV/WI7+4riMRR4ADT0kGXvR62LVbenJ7dpm1A==
X-Received: by 2002:a17:906:f2da:b0:967:21:5887 with SMTP id gz26-20020a170906f2da00b0096700215887mr10359723ejb.40.1688560178939;
        Wed, 05 Jul 2023 05:29:38 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id ec10-20020a170906b6ca00b009893650453fsm14765183ejb.173.2023.07.05.05.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 05:29:38 -0700 (PDT)
Message-ID: <4433fbc1-2b11-0aa0-f895-4a1d55832a75@gmail.com>
Date:   Wed, 5 Jul 2023 13:26:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 03/11] io-wq: add a new type io-wq worker
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-4-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-4-hao.xu@linux.dev>
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
> Add a new type io-wq worker IO_WORKER_F_FIXED, this type of worker
> exists during the whole io-wq lifecycle.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/io-wq.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 1717f1465613..7326fef58ca7 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -30,6 +30,7 @@ enum {
>   	IO_WORKER_F_FREE	= 4,	/* worker on free list */
>   	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
>   	IO_WORKER_F_EXIT	= 16,	/* worker is exiting */
> +	IO_WORKER_F_FIXED	= 32,	/* is a fixed worker */
>   };
>   
>   enum {
> @@ -598,6 +599,11 @@ static bool is_worker_exiting(struct io_worker *worker)
>   	return worker->flags & IO_WORKER_F_EXIT;
>   }
>   
> +static bool is_fixed_worker(struct io_worker *worker)
> +{
> +	return worker->flags & IO_WORKER_F_FIXED;
> +}

You move it up in Patch 5/11, I suggest to move it to the top of the
file here.


>   static int io_wq_worker(void *data)
>   {
>   	struct io_worker *worker = data;
> @@ -622,8 +628,13 @@ static int io_wq_worker(void *data)
>   		/*
>   		 * Last sleep timed out. Exit if we're not the last worker,
>   		 * or if someone modified our affinity.
> +		 * Note: fixed worker always have same lifecycle as io-wq
> +		 * itself, and cpu affinity setting doesn't work well for
> +		 * fixed worker, they can be manually reset to cpu other than
> +		 * the cpuset indicated by io_wq_worker_affinity()
>   		 */
> -		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
> +		if (!is_fixed_worker(worker) && last_timeout &&
> +		    (exit_mask || acct->nr_workers > 1)) {
>   			acct->nr_workers--;
>   			raw_spin_unlock(&wq->lock);
>   			__set_current_state(TASK_RUNNING);

If there is no work it'll continue to loop every
WORKER_IDLE_TIMEOUT (5 * HZ), which sounds troublesome with many
workers in the system.

tm = is_fixed_worker(worker) ? MAX_SCHEDULE_TIMEOUT :  WORKER_IDLE_TIMEOUT;
schedule_timeout(tm);

Maybe?

-- 
Pavel Begunkov
