Return-Path: <io-uring+bounces-3518-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 689B3997576
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84E3D1C22825
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62E11E0495;
	Wed,  9 Oct 2024 19:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTgF7zGH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723917332C;
	Wed,  9 Oct 2024 19:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728501101; cv=none; b=PbvF5T8yXH+ftk2YzcqISbbJdfnQ0aCNGu5meQge9KdugH/acVz+ar7WsrplwawgHQw/7OSSKHPfFZA41yioQla8bldc5u5aJZls0BR2g7WD1n+gaJOJIpg+pi1RULVW5jAF4XvksaMRcU9axfwCVZQh1WIs0IGGFyqdNOn00j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728501101; c=relaxed/simple;
	bh=Nu2bYL8LuHCjSMn9TSEypvoCVON3G/WfL7hu0dYK2aA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Zgp5gpCZ9KJuX/SWQqgM5aoRB4K9A7yjueHJ8I9WCTt5DZo7RxNCLTAw27kjNaz5VAiYGeNKu/hIkgV6MtWn8K/4LXyCpbT2bokIU/yGXXVqYVLXkhxdo2LKgCHo/4lpUKS+Z175T+jI5QDDTC+X+nPUQkMjBeeMGLhZyDNnG1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTgF7zGH; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c42e7adbddso64898a12.2;
        Wed, 09 Oct 2024 12:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728501098; x=1729105898; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GiPB8AoUiM93yNDSFmmV4wPtRYjJAVzhcLHdW+BnWss=;
        b=dTgF7zGHQVOu6ZU35JW5BHCCC89UnHsaicFDrrh8B+udYrq/wJEAH3vTk+xGCwAXOF
         ySGtFLMTJgXwG455MMTqfe0G//nqY3/fib+ctdPHdgzB8gL8/xLjzTQYtWPMAVhjYEJN
         HseN22VoMZXOA9MTBHgTA/QutxCK/VTXkDz2crX//IT0jU3arBvfqF86tnK+lNGa0/Dw
         wiSPspk+ovU6MF3H9BccppPFz09oxCjQyL/E93Vdm3JGLvIMuPcrr2O4o8aG2UgkYE3I
         zqJyijuVa7ty/USWBAwFfZXyPNm71Pmht2QPE5GbJLo/v15kBkY+1DLhmIvz8UgGQXbe
         nK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728501098; x=1729105898;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GiPB8AoUiM93yNDSFmmV4wPtRYjJAVzhcLHdW+BnWss=;
        b=O+ec68fiAugtwXNcIOPJTkpSahybaGgTZt200jIokS8wOAW6HkC569gidleMLQfmN7
         iDJqWb9fwlD/TOIlunsfsjBcv8X1Bc2zDpvoIq1+N+aJL1x2M4D1jsy3g3AWQ0JRaINo
         c6B7LVkfpR/S5vZRea4S1YzTmYF9DkyyLLm+8cw8rgBOtMJ+36j8wI0uS2CQd/+SSrAL
         3v6yR2mdWxjzDJw3X7e5KLmczW7a//pHo7SLMCw4g7FCSzVLOINEyHMS2pawjwXja7zA
         DXuoa6B6aaimEZuLoEkFtS8KjjK4SR2+nNtsxPXC1Nd4fQa1NaHC6hfKt/wyHU8AgMGR
         D3vQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFIG3G0TpXPmcGsiI75ZU+GTjlsDchBusINZYp0fieoJWG8X36uuciWvEuPhf/mUcCtBImFis9@vger.kernel.org, AJvYcCXqVXNH0TwVJ7R6WhPVRvNro7BQEBI+HIiyYeZXA7jrnXBeJPaalbfAC4ZCVKqLWVEgXz5PI1+tjw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt98K9zUOKbORYS2Dq0Xnqwso8GRvvGABpsjgPH8PeYBaHXioJ
	F0++44g75KDZlmAeQYV3EMZrTm6OU5yECBPJcB4u3GXJjL4SDgRB
X-Google-Smtp-Source: AGHT+IGvmPOnaaxNnyUHDmfhJTWExS3Mi0hxE0fMOwiMpt+HjovxGhNFkMa1tld/SS/djFXBM4vcdw==
X-Received: by 2002:a05:6402:2741:b0:5c8:7a0b:2848 with SMTP id 4fb4d7f45d1cf-5c91d68d22fmr3655013a12.36.1728501098059;
        Wed, 09 Oct 2024 12:11:38 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05956ddsm5747302a12.4.2024.10.09.12.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:11:37 -0700 (PDT)
Message-ID: <8fcb5c94-959e-4daa-836b-ab14e25c3a89@gmail.com>
Date: Wed, 9 Oct 2024 20:12:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/15] net: add helper executing custom callback from
 napi
To: Joe Damato <jdamato@fastly.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-9-dw@davidwei.uk> <ZwWxQjov3Zc_oeiR@LQ3V64L9R2>
 <6e20af86-8b37-4e84-8ac9-ab9f8c215d00@gmail.com>
 <ZwartzLxnL7MXam6@LQ3V64L9R2>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwartzLxnL7MXam6@LQ3V64L9R2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 17:13, Joe Damato wrote:
> On Wed, Oct 09, 2024 at 04:09:53PM +0100, Pavel Begunkov wrote:
>> On 10/8/24 23:25, Joe Damato wrote:
>>> On Mon, Oct 07, 2024 at 03:15:56PM -0700, David Wei wrote:
>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>
>>> [...]
>>>
>>>> However, from time to time we need to synchronise with the napi, for
>>>> example to add more user memory or allocate fallback buffers. Add a
>>>> helper function napi_execute that allows to run a custom callback from
>>>> under napi context so that it can access and modify napi protected
>>>> parts of io_uring. It works similar to busy polling and stops napi from
>>>> running in the meantime, so it's supposed to be a slow control path.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>>
>>> [...]
>>>
>>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>>> index 1e740faf9e78..ba2f43cf5517 100644
>>>> --- a/net/core/dev.c
>>>> +++ b/net/core/dev.c
>>>> @@ -6497,6 +6497,59 @@ void napi_busy_loop(unsigned int napi_id,
>>>>    }
>>>>    EXPORT_SYMBOL(napi_busy_loop);
>>>> +void napi_execute(unsigned napi_id,
>>>> +		  void (*cb)(void *), void *cb_arg)
>>>> +{
>>>> +	struct napi_struct *napi;
>>>> +	bool done = false;
>>>> +	unsigned long val;
>>>> +	void *have_poll_lock = NULL;
>>>> +
>>>> +	rcu_read_lock();
>>>> +
>>>> +	napi = napi_by_id(napi_id);
>>>> +	if (!napi) {
>>>> +		rcu_read_unlock();
>>>> +		return;
>>>> +	}
>>>> +
>>>> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
>>>> +		preempt_disable();
>>>> +	for (;;) {
>>>> +		local_bh_disable();
>>>> +		val = READ_ONCE(napi->state);
>>>> +
>>>> +		/* If multiple threads are competing for this napi,
>>>> +		* we avoid dirtying napi->state as much as we can.
>>>> +		*/
>>>> +		if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
>>>> +			  NAPIF_STATE_IN_BUSY_POLL))
>>>> +			goto restart;
>>>> +
>>>> +		if (cmpxchg(&napi->state, val,
>>>> +			   val | NAPIF_STATE_IN_BUSY_POLL |
>>>> +				 NAPIF_STATE_SCHED) != val)
>>>> +			goto restart;
>>>> +
>>>> +		have_poll_lock = netpoll_poll_lock(napi);
>>>> +		cb(cb_arg);
>>>
>>> A lot of the above code seems quite similar to __napi_busy_loop, as
>>> you mentioned.
>>>
>>> It might be too painful, but I can't help but wonder if there's a
>>> way to refactor this to use common helpers or something?
>>>
>>> I had been thinking that the napi->state check /
>>> cmpxchg could maybe be refactored to avoid being repeated in both
>>> places?
>>
>> Yep, I can add a helper for that, but I'm not sure how to
>> deduplicate it further while trying not to pollute the
>> napi polling path.
> 
> It was just a minor nit; I wouldn't want to hold back this important
> work just for that.
> 
> I'm still looking at the code myself to see if I can see a better
> arrangement of the code.
> 
> But that could always come later as a cleanup for -next ?

It's still early, there will be a v6 anyway. And thanks for
taking a look.

-- 
Pavel Begunkov

