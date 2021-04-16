Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C9D3620A8
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 15:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhDPNRP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 09:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbhDPNRO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 09:17:14 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF5C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 06:16:47 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id y124-20020a1c32820000b029010c93864955so16515482wmy.5
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 06:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I8eiEkvd2zCXQ3nIM6u0QCmM9LDttZ0Xw3sXWTKAL+g=;
        b=d9+L43C1br5ZrjEnHuEd9kYTTb/LFYZNuLxRDSTeElWK7iBX6sSBr5VtjWZrUCUz3N
         yZ9CYaz2+IdLM9yyQJJKUscpwbZ5OMx+g0W/l3gCs2Lv6kQzl6E6Eb1wnaCMbFEKVHn4
         le+4vpU/+l37Nn28rjOZIkafXF60eIH3rD3fbPMf9c6vyFS7QZz3uU9VCPzfah0gHjtz
         3tluq34OKAB8YR/5/8bxbZiaTFGGsbY1h++m1JMlIinnjBQre+pNX74pou/5CG4l6AJC
         RWnOoszh0qOT8vLm5OGof3rhqKL1gMltoAfjzB3CMjJdYBPMdhs8F7c6NkDCTHy1Qf0h
         cl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=I8eiEkvd2zCXQ3nIM6u0QCmM9LDttZ0Xw3sXWTKAL+g=;
        b=JRVXkYWcMffwdZVnZQBZ+tsXHUFS0DdpKxqX234ar1mu5Gmm0Rvk8tN/gIg1XgRoWD
         SxXt7WjkPA+4PfNIg4tAYeEFnQudsq8IxvnbjGlAuzS+nxRPfIWgCBk8P2fm2k1sDnYP
         mR7iu0qLBtuutTLEiYLhtoSGdXMXlUtPuuD2AbFrHj54Hm2hPR1mDToC9d0NfSb/URbB
         /L+ahMMJQLD7++yv/v8UPuMVXWFm8T1PLQeZ3oLmgp3UBOxV+H4fghL95zRMvIQi2Del
         CcbqHLjvFW7X+3+5VXm+S74XlzPq5BzvuakStXd9+yJwkuqPhlFXub31FgVIjV5uCuoB
         c1FQ==
X-Gm-Message-State: AOAM530EDE/iZvcUbaOiliz3x5e2ZIHKykEwq2fHae6nxChfiFPDNW/l
        uMq7hRiE1/GjVc7Z4WAxyp4=
X-Google-Smtp-Source: ABdhPJxGovH6Il/YtVb2Jnpxwa8p1Q2IcIiz7JCQKGXLLsXgaRW72tR9RPc+za8PRmrBhsqyO9dYog==
X-Received: by 2002:a1c:7901:: with SMTP id l1mr8237928wme.7.1618579006583;
        Fri, 16 Apr 2021 06:16:46 -0700 (PDT)
Received: from [192.168.8.191] ([148.252.132.77])
        by smtp.gmail.com with ESMTPSA id g84sm4778307wmg.42.2021.04.16.06.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 06:16:46 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <8d04fa58-d8d0-8760-a6aa-d2bd6d66d09d@gmail.com>
 <36df5986-0716-b7e7-3dac-261a483d074a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/2] fix hangs with shared sqpoll
Message-ID: <dd77a2f6-c989-8970-b4c4-44380124a894@gmail.com>
Date:   Fri, 16 Apr 2021 14:12:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <36df5986-0716-b7e7-3dac-261a483d074a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/04/2021 14:04, Jens Axboe wrote:
> On 4/15/21 6:26 PM, Pavel Begunkov wrote:
>> On 16/04/2021 01:22, Pavel Begunkov wrote:
>>> Late catched 5.12 bug with nasty hangs. Thanks Jens for a reproducer.
>>
>> 1/2 is basically a rip off of one of old Jens' patches, but can't
>> find it anywhere. If you still have it, especially if it was
>> reviewed/etc., may make sense to go with it instead
> 
> I wonder if we can do something like the below instead - we don't
> care about a particularly stable count in terms of wakeup
> reliance, and it'd save a nasty sync atomic switch.

But we care about it being monotonous. There are nuances with it.
I think, non sync'ed summing may put it to eternal sleep.

Are you looking to save on switching? It's almost always is already
dying with prior ref_kill

> 
> Totally untested...
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6c182a3a221b..9edbcf01ea49 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8928,7 +8928,7 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
>  	atomic_inc(&tctx->in_idle);
>  	do {
>  		/* read completions before cancelations */
> -		inflight = tctx_inflight(tctx, false);
> +		inflight = percpu_ref_sum(&ctx->refs);
>  		if (!inflight)
>  			break;
>  		io_uring_try_cancel_requests(ctx, current, NULL);
> @@ -8939,7 +8939,7 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
>  		 * avoids a race where a completion comes in before we did
>  		 * prepare_to_wait().
>  		 */
> -		if (inflight == tctx_inflight(tctx, false))
> +		if (inflight == percpu_ref_sum(&ctx->refs))
>  			schedule();
>  		finish_wait(&tctx->wait, &wait);
>  	} while (1);
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 16c35a728b4c..2f29f34bc993 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -131,6 +131,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
>  void percpu_ref_resurrect(struct percpu_ref *ref);
>  void percpu_ref_reinit(struct percpu_ref *ref);
>  bool percpu_ref_is_zero(struct percpu_ref *ref);
> +long percpu_ref_sum(struct percpu_ref *ref);
>  
>  /**
>   * percpu_ref_kill - drop the initial ref
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index a1071cdefb5a..b09ed9fdd32d 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -475,3 +475,31 @@ void percpu_ref_resurrect(struct percpu_ref *ref)
>  	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_resurrect);
> +
> +/**
> + * percpu_ref_sum - return approximate ref counts
> + * @ref: perpcu_ref to sum
> + *
> + * Note that this should only really be used to compare refs, as by the
> + * very nature of percpu references, the value may be stale even before it
> + * has been returned.
> + */
> +long percpu_ref_sum(struct percpu_ref *ref)
> +{
> +	unsigned long __percpu *percpu_count;
> +	long ret;
> +
> +	rcu_read_lock();
> +	if (__ref_is_percpu(ref, &percpu_count)) {
> +		ret = atomic_long_read(&ref->data->count);
> +	} else {
> +		int cpu;
> +
> +		ret = 0;
> +		for_each_possible_cpu(cpu)
> +			ret += *per_cpu_ptr(percpu_count, cpu);
> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> 

-- 
Pavel Begunkov
