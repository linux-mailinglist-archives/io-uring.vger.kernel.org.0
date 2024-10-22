Return-Path: <io-uring+bounces-3919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 949A59AB23B
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 17:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3CD5B214F4
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D0D19AD7E;
	Tue, 22 Oct 2024 15:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NTP6I1e8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B156F14658D;
	Tue, 22 Oct 2024 15:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729611360; cv=none; b=NfJMzkIT9dPRoDUecAy+JqowV3qgscahuf3fAdL83Msd5ayC8qX0ouc0ZbtBHxxPiZAZfk5lypQpjLxEOCMknAR+qcoGbSydG+7BmamdC5VwDsIeEnKiagT1dP/Ab7M5UNHyBh164Gtiel+Wkh6Jx6Z5eDVy6XhZsS6FXjY7RVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729611360; c=relaxed/simple;
	bh=l7gTsq/iHGpbhAxR7F1erEIlrkJOhaGRUHSmiCHCLjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fiUFCKAYQReO4rXK5B4HoHO/fQtWeU0goJuceUDFhCxzmTh/gqUWnDu1egnQZWM3rP/ail99yeKcIbw75J9yMy+J+Nx3RG06z+W2E0fbUZ6aWJckZQmKYD09qdLrj6ldfZbbokn7QM0JLR/pjTRFV7lXKlP6zsVFkZiLq07321A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NTP6I1e8; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a850270e2so551999666b.0;
        Tue, 22 Oct 2024 08:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729611357; x=1730216157; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f/XxWA/UzVLbtvjvtSjdWsn/Tv5USqZaP4/G3cjmFzc=;
        b=NTP6I1e8F4ZdYiQ/jgPYwyM31Sn9qbdhlXinOQ2zqdyQnmtWfEkwLtgLCkKMUP1PFD
         VU9hirsqEM1TLtvx67fd+tvc2Jw/IiAUislYZnsDeuhHARnq+Ixlvu1EUDpQZCud1LBq
         p0SOgRfD6dWEqBsenotexstH0iKfMoThbMOK03/e4ygyAQW0tlHxlySOLFL3WzTtGpnH
         LcCt2A2bvsEFcNHhNp5G2M0cRIMbU6TfJvPFgyBCG0krrLna8g4SRPwnnAOMkCcxmHVH
         8H5No54TSDdJ88lWXkCtE0f6oMJDW0tQXFQZw4h3okiAUVQV2KGvUgFht4t/gM+YHpYo
         6PHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729611357; x=1730216157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f/XxWA/UzVLbtvjvtSjdWsn/Tv5USqZaP4/G3cjmFzc=;
        b=os4vcHbtf0GOh6wJNJIdQmaybZiPowTg/HsnZoipj9E5u+1pFyXfPNHFv3tNuly6Jo
         4y24yJBDYgqlVcsOBs5CITuecx9jmcIXfuIpNN3ZgaZqTmFDAy6m5VqwJa1ujhgHOjx1
         mcDZOoI9N13rHm52kVL5kI1wCikVyJaQS4MwW2Fq2FZDfD+UMQdv3Q4z7rdLBfb6QckY
         jw5Owo81v9Uw2ylShzK8LpA2MEnrn5WxsbJA/WJCtTDChWEoT+BzwhSgU8Cdg0DfG7I9
         EMehEwrFPw+iNJNTgGMTqYkjdvAR9I/fTAPmgPajp/tGgkBaf2YAhTM50ovO5xnCRioh
         aBmg==
X-Forwarded-Encrypted: i=1; AJvYcCWaZa4zdB7KuaIF1j5PaMe9eb0kVVvx91lDXrzL6dGjmEdLawYy5bdhXBeqn/c7DPXi0YZMIuM4RA==@vger.kernel.org, AJvYcCXC8n95Md6/3EFlqxuKQwafkuMqIlIi+7P8dhHQkYNaX6E/RogJg5x3QGDHihFIRcb9G4kevi7Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyToPxGhqvPgiY5xaVaMTjnKM6cKGXd6daRG4U593O+HcIPADg1
	d0RuoN2Xyigk3PCViduxCQ0hGKrKVQw91RFgHxHe/ELjWojWdF8w
X-Google-Smtp-Source: AGHT+IFTdDm0Q4xxbvAM5CCpJQQrdo0RVDiAb6SM3l1N+yUDjHrcgMl5fVCsS+CkFkDhtzQtICsvbg==
X-Received: by 2002:a17:906:c10e:b0:a99:7bc0:bca9 with SMTP id a640c23a62f3a-a9a69a65949mr1430312766b.3.1729611356925;
        Tue, 22 Oct 2024 08:35:56 -0700 (PDT)
Received: from [192.168.42.126] ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d6360sm354603066b.29.2024.10.22.08.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 08:35:56 -0700 (PDT)
Message-ID: <b52dc14d-16a4-47db-a22d-66bcadd1c381@gmail.com>
Date: Tue, 22 Oct 2024 16:36:39 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/15] net: add helper executing custom callback from
 napi
To: Paolo Abeni <pabeni@redhat.com>, David Wei <dw@davidwei.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-9-dw@davidwei.uk>
 <cd9c2290-f874-49e6-bc99-5336a096cffb@redhat.com>
 <9d2c123d-9e1e-4365-a047-e4fe84444ab9@gmail.com>
 <be07ab23-6bc6-4c2c-8544-0a76c457bf08@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <be07ab23-6bc6-4c2c-8544-0a76c457bf08@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/24 08:47, Paolo Abeni wrote:
> Hi,
> 
> On 10/21/24 19:16, Pavel Begunkov wrote:
>> On 10/21/24 15:25, Paolo Abeni wrote:
>>> On 10/16/24 20:52, David Wei wrote:
> 
> [...]
>>>> +	napi = napi_by_id(napi_id);
>>>> +	if (!napi)
>>>> +		return;
>>>> +
>>>> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
>>>> +		preempt_disable();
>>>> +
>>>> +	for (;;) {
>>>> +		local_bh_disable();
>>>> +
>>>> +		if (napi_state_start_busy_polling(napi, 0)) {
>>>> +			have_poll_lock = netpoll_poll_lock(napi);
>>>> +			cb(cb_arg);
>>>> +			local_bh_enable();
>>>> +			busy_poll_stop(napi, have_poll_lock, 0, 1);
>>>> +			break;
>>>> +		}
>>>> +
>>>> +		local_bh_enable();
>>>> +		if (unlikely(need_resched()))
>>>> +			break;
>>>> +		cpu_relax();
>>>
>>> Don't you need a 'loop_end' condition here?
>>
>> As you mentioned in 14/15, it can indeed spin for long and is bound only
>> by need_resched(). Do you think it's reasonable to wait for it without a
>> time limit with NAPI_STATE_PREFER_BUSY_POLL? softirq should yield napi
>> after it exhausts the budget, it should limit it well enough, what do
>> you think?
>>
>> The only ugly part is that I don't want it to mess with the
>> NAPI_F_PREFER_BUSY_POLL in busy_poll_stop()
>>
>> busy_poll_stop() {
>> 	...
>> 	clear_bit(NAPI_STATE_IN_BUSY_POLL, &napi->state);
>> 	if (flags & NAPI_F_PREFER_BUSY_POLL) {
>> 		napi->defer_hard_irqs_count = READ_ONCE(napi->dev->napi_defer_hard_irqs);
>> 		timeout = READ_ONCE(napi->dev->gro_flush_timeout);
>> 		if (napi->defer_hard_irqs_count && timeout) {
>> 			hrtimer_start(&napi->timer, ns_to_ktime(timeout), HRTIMER_MODE_REL_PINNED);
>> 			skip_schedule = true;
>> 		}
>> 	}
>> }
> 
> Why do you want to avoid such branch? It will do any action only when
> the user-space explicitly want to leverage the hrtimer to check for
> incoming packets. In such case, I think the kernel should try to respect
> the user configuration.

It should be fine to pass the flag here, it just doesn't feel right.
napi_execute() is not interested in polling, but IIRC this chunk delays
the moment when softirq kicks in when there are no napi pollers. I.e.
IMO ideally it shouldn't affect napi polling timings...

>> Is it fine to set PREFER_BUSY_POLL but do the stop call without? E.g.
>>
>> set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
>> ...
>> busy_poll_stop(napi, flags=0);
> 
> My preference is for using NAPI_STATE_PREFER_BUSY_POLL consistently. It
> should ensure a reasonably low latency for napi_execute() and consistent
> infra behavior. Unless I'm missing some dangerous side effect ;)

... but let's just set it then. It only affects the zerocopy private
queue.

-- 
Pavel Begunkov

