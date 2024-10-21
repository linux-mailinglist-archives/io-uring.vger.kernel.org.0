Return-Path: <io-uring+bounces-3870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC629A70C6
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 19:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08B29281522
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5709F19342E;
	Mon, 21 Oct 2024 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaMw0EYf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42753137750;
	Mon, 21 Oct 2024 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729530935; cv=none; b=Wl3JtinOoXTDHh6c1K6ehcIk7Hf6UPSUDHbEDWXLp388Y9B2rpY8B0l3wFBCEYQ9Wdv+oJNB1RaaQ+R9mgWYL1oqyDmgSBn8I4QSBqYaziSJveltSmqFIaV3+7bd92UowGZwVjoRKyo0XZiLzPWvZGphrb787WUBTgmsAvp3COw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729530935; c=relaxed/simple;
	bh=M9VD2mMVVu7ouNqpkXpdN5xM61Z+7Iayser+4fhnJ/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jjt086HeuehsyjlI2iRvYMabJfQxN4Y5gnYstOPdAF3F8DsR5NVJiTGROaAcKK7zj6Y8O3Q9848Ab7bzjIvohW6YrHqYsilF2lCfuyQbqgVWPPRjrJ0IBN/ab4FB61KKZVSy3x5DIoTjLbxA1E2yfOCW5n6LxA5M1XJOOFw3GUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jaMw0EYf; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d47b38336so3201860f8f.3;
        Mon, 21 Oct 2024 10:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729530931; x=1730135731; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w5qN6OuKcxpGdanZ/du03rbiEJuX0vwDAFIhX+Xuljc=;
        b=jaMw0EYft8m8if7y6Xdk80FC0hrffZ1btvuNVNy6SaQML3ag/eP6jvIuoFB8I0sGj0
         OxjyNF0oACMMW2O2Re0tmb7AS99kBFz/H0g2vRl+88n0xzRLcWDXMfXQ4OLK+Kw2KpwT
         /AxshGgLiyz9U5aV8B/9/UIgtqZce4P6s7lIcXETxOEVS2creB6S8FLzOUUp5CuNV72V
         gyBmn6nvzLGaOKfV7DJA2gvROzejChFEVjdOQ9iJWt2QNcFgkc88XCPPmMdUz1ozGcly
         s1oSxslte+HMNqB9DG1uvyun/3RNo8sDdkPeTLpoq/XDtrxN7OYRjRvu+aInqlToRD5f
         rVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729530931; x=1730135731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5qN6OuKcxpGdanZ/du03rbiEJuX0vwDAFIhX+Xuljc=;
        b=W+0vPfaqDWDtOnRwQG1NcvlxsOSPs5jeVXJNz4hbpmdZckZRYnmpgx4cELFVuiyUtB
         Otz507q3PMyx2HwBYUrNb2HrHeo0LGXKAb0ZxwkLg6i2ZsUBOXXy9p58RtEFNiuZcDzt
         BbMsH0T+ST+AaP5cGudbNnDa66SH7d06N1+FQmXvk8N82l4F/H72NcGkrZuwkTZFl1Hn
         Rs0ekmF7xF7n0m1qUyIO30Uo90R6LPnB0epkzw5Y3HjHI/6fIsZtxgdoBZLf9Ig4a4OX
         9mUGmsuy8blGEVW3sREYY8WgBDkMm1i0Ob8zLpzwkUX9tE6eOjmXyEH6Glk75vkEBVKX
         Q+ug==
X-Forwarded-Encrypted: i=1; AJvYcCVIDl+Z3BKvvDrhrJfl0uj2lPo30wJYh3gFgxjNXTMXK6N8xl4AORPUNNOtWGFTGri41JkRIrm+BQ==@vger.kernel.org, AJvYcCWoyLTpiT7FcuOvjUwq9KZ8COWvOcD0IbhHJ6eF7Q9dBL0N8DpowmdpZBR50hOq7vHlMFvs0dRO@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7ID136RChecUfAn7oH5sl0cXT/FuhYgXYojBFpCY91pL4LpvB
	DJUXq9Bi1Q7//OH4b32Z/A23Ccp5+g1WkKW+7CfQHkh5m64UlVwN
X-Google-Smtp-Source: AGHT+IF1Oh9HyTn48P45KE/pXeE4if0YIjQs8X6lzdpbcAryfp39AnnETqWBs4+X9+jiAWoly4C1lg==
X-Received: by 2002:a5d:67d1:0:b0:37d:238:983 with SMTP id ffacd0b85a97d-37eab6ed4e6mr7934667f8f.22.1729530931220;
        Mon, 21 Oct 2024 10:15:31 -0700 (PDT)
Received: from [192.168.42.158] ([185.69.144.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0b944fbsm4812998f8f.72.2024.10.21.10.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 10:15:30 -0700 (PDT)
Message-ID: <9d2c123d-9e1e-4365-a047-e4fe84444ab9@gmail.com>
Date: Mon, 21 Oct 2024 18:16:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/15] net: add helper executing custom callback from
 napi
To: Paolo Abeni <pabeni@redhat.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-9-dw@davidwei.uk>
 <cd9c2290-f874-49e6-bc99-5336a096cffb@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cd9c2290-f874-49e6-bc99-5336a096cffb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 15:25, Paolo Abeni wrote:
> Hi,
> 
> On 10/16/24 20:52, David Wei wrote:
>> @@ -6503,6 +6511,41 @@ void napi_busy_loop(unsigned int napi_id,
>>   }
>>   EXPORT_SYMBOL(napi_busy_loop);
>>   
>> +void napi_execute(unsigned napi_id,
>> +		  void (*cb)(void *), void *cb_arg)
>> +{
>> +	struct napi_struct *napi;
>> +	void *have_poll_lock = NULL;
> 
> Minor nit: please respect the reverse x-mas tree order.
> 
>> +
>> +	guard(rcu)();
> 
> Since this will land into net core code, please use the explicit RCU
> read lock/unlock:
> 
> https://elixir.bootlin.com/linux/v6.12-rc3/source/Documentation/process/maintainer-netdev.rst#L387

I missed the doc update, will change it, thanks


>> +	napi = napi_by_id(napi_id);
>> +	if (!napi)
>> +		return;
>> +
>> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
>> +		preempt_disable();
>> +
>> +	for (;;) {
>> +		local_bh_disable();
>> +
>> +		if (napi_state_start_busy_polling(napi, 0)) {
>> +			have_poll_lock = netpoll_poll_lock(napi);
>> +			cb(cb_arg);
>> +			local_bh_enable();
>> +			busy_poll_stop(napi, have_poll_lock, 0, 1);
>> +			break;
>> +		}
>> +
>> +		local_bh_enable();
>> +		if (unlikely(need_resched()))
>> +			break;
>> +		cpu_relax();
> 
> Don't you need a 'loop_end' condition here?

As you mentioned in 14/15, it can indeed spin for long and is bound only
by need_resched(). Do you think it's reasonable to wait for it without a
time limit with NAPI_STATE_PREFER_BUSY_POLL? softirq should yield napi
after it exhausts the budget, it should limit it well enough, what do
you think?

The only ugly part is that I don't want it to mess with the
NAPI_F_PREFER_BUSY_POLL in busy_poll_stop()

busy_poll_stop() {
	...
	clear_bit(NAPI_STATE_IN_BUSY_POLL, &napi->state);
	if (flags & NAPI_F_PREFER_BUSY_POLL) {
		napi->defer_hard_irqs_count = READ_ONCE(napi->dev->napi_defer_hard_irqs);
		timeout = READ_ONCE(napi->dev->gro_flush_timeout);
		if (napi->defer_hard_irqs_count && timeout) {
			hrtimer_start(&napi->timer, ns_to_ktime(timeout), HRTIMER_MODE_REL_PINNED);
			skip_schedule = true;
		}
	}
}

Is it fine to set PREFER_BUSY_POLL but do the stop call without? E.g.

set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
...
busy_poll_stop(napi, flags=0);


-- 
Pavel Begunkov

