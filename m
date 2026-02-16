Return-Path: <io-uring+bounces-12253-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iEghO2U9k2kg2wEAu9opvQ
	(envelope-from <io-uring+bounces-12253-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:53:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F99145CF0
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 860F530221C3
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91AB2745C;
	Mon, 16 Feb 2026 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hmnllFn1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C10330667
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771257132; cv=none; b=dMPTySuzSkLigoL6NYfU3LhtYnILNlFyEbKH0L9nq2Ufg9DToIG6+xbge5DGTSFrMqDis0GyiO7BueVasTdWpCWd8QCWoxdzBoC1VDbne8qUGGa2CaifdxYb0/6lLi62P4RO5uY4rIsh0qC4qmzaA5t8mHEbURdyrzSBOvb0oHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771257132; c=relaxed/simple;
	bh=P3O79oj15raX71a9N6uiFmox8ZOvb/WNXUbFW5ssWMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A6p6R5dpK5Cg9klJsWFcFTTEjAG4LpkdxBoIV8wVXgkiwSJ/1Q3DQ1RUqEMtPMKsBbeJLsLUfvGCedyxCcW9SSRndVKIrNjcpl+81RGI6KvAJfwQHADxzd13nYaCKVPBj2WLXdVw9eN/c/w+0UVhP6u/KOxd1FWD7AEhwFKLk5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hmnllFn1; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40fb2789476so783395fac.1
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771257130; x=1771861930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VWIvuckknEhqu2mlLaRMS0FDY+9i0VBrjPrCotKkxGI=;
        b=hmnllFn1aoF1X0H5bsDbfLXNER4yI6WfWgfTKD65FISjZWwQgE1/lHQPTZHtUHgxYV
         +vOl3/YhjNqVdqS0qQFZ3LRZeKBpoxFSxSZqfajDGkQ66xzM6CBvahhZY4JGKEZdz7gK
         K+2EMB8gQJDmcDT7x4NPTwZzuNHdliLINheVNBWer84Ltg5wjHUAiSBzHcpb50yOQ5RJ
         1HGM9czySVtsjnFytfiG7Hj2a7kArvGg9S6Km9oSaiEiyDEgriQ/3ErYcTfrZplJqUEX
         Yon95XhVRVnorND4BsKkHA9H+Y9KJMposrH8gTcibr4TsTKbIEyK53PHCDMaVeaDoOxc
         ez2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771257130; x=1771861930;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWIvuckknEhqu2mlLaRMS0FDY+9i0VBrjPrCotKkxGI=;
        b=Qd5lNZfkp5yEXuTUfRiFO8+uCnEAnCvn5hlAmPZ5eH8hjlm0GPTAFFeBpuPNknfuB0
         78EzbpgumqUNqfCXSHGSKwGWZf2bZRlJ5u1QcGMwb/u2qJgLbRx8AS378BXDSbOs1h+m
         dhXvDaChbw+a93PekMY1zvPm1HYOmWhW0GJa6K/Qn7+825gN4ZVMcGkQSXw4wfmzmSYq
         eJqpNZ4qWvFhVcwWx9Mr3nvO5YkiX38MYUGcp3OcY2HnRTNnbwgUosPLllQ6zjGgBOWd
         d3qHPhrqHxVQVhSchBHHkWzaaAn6w+tRzLZe7SB3EgtFearcl4ERVfbF6u8u/mIr5g7B
         1bpw==
X-Forwarded-Encrypted: i=1; AJvYcCViQVm4sxH+Vyt1ewvwOhD8D3MCj35mwR/AaVF5LjNK/Oe0bK5/OW6W0n1TyYetkfVQsmwxT7++vw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGWdfaXpANyRNxX1j0yve/Ne0JYgK+RFbV2yaO81bQ/TgkYE6D
	eZ++wfgX43vtt9cwlTEAr9gJw46Asf2GTyPXq5r8EaEMZId/bom9gVJWchJ1aJ50XXg=
X-Gm-Gg: AZuq6aI7pV+bcGw0pvESa4xE2G0EDO10OmS9mKQlD76mMTs5ptIK3JPZyK0T718vdE6
	Dq6SHpu6oU8YJbl4XjzLe6eV4BC5qDLpjiaIEqbLb3ywpRL/6xKD5idsj0O7jucGsCHLGK93Nys
	0zafF3907APs0j4oLbhoy/hELKsB337uN4WjZ/5E+Pd7ksQNY0YBCFWRB/6Z6DE0gkhbiWIfRTn
	7kR+KDxBDh7q517Bw1bRngXTCdG3cBECO4dvU40JNUhaZ6SLo1PIKhzkgZAQim8eAQIZ/U7BT8F
	NdznBbTmZD0Uk+0TY7YE+EBBdEVoMOzD3JvIurqa93j4838rxDmGEgBvuxoamu2YB+1Lv7B1xrL
	6GcPNqhh3ApJrT1PdDLeRI2fE59GH58S94j1DTJxbGHRXVbZR1NklHF4Yy42HQZpIO20Sm+5xt3
	6MLzbEdvaxE9fV+l+WhGVwu3P99Fn48UGWhLeP487ZcPYiRKsKe7mdBcpI1CGQMGFe9DEjWucjf
	f7gtYM5Kg==
X-Received: by 2002:a05:6871:8910:b0:409:5df2:a266 with SMTP id 586e51a60fabf-40f0875bd14mr4977013fac.12.1771257130027;
        Mon, 16 Feb 2026 07:52:10 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaee45d12sm15847697fac.1.2026.02.16.07.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:52:09 -0800 (PST)
Message-ID: <64ab6b3e-3746-4076-9c0b-b2edc2de92d1@kernel.dk>
Date: Mon, 16 Feb 2026 08:52:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
 <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
 <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12253-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 57F99145CF0
X-Rspamd-Action: no action

On 2/16/26 8:48 AM, Pavel Begunkov wrote:
> On 2/16/26 15:10, Jens Axboe wrote:
>> On 2/16/26 4:48 AM, Pavel Begunkov wrote:
>>> People previously asked for the notification CQE to have a different
>>> user_data value from the main request completion. It's useful to
>>> separate buffer and request handling logic and avoid separately
>>> refcounting the request.
>>>
>>> Let the user pass the notification user_data in sqe->addr3. If zero,
>>> it'll inherit sqe->user_data as before. It doesn't change the rules for
>>> when the user can expect a notification CQE, and it should still check
>>> the IORING_CQE_F_MORE flag.
>>
>> This should use and sqe->ioprio flag to manage it, otherwise you're
>> excluding 0. Which may not be important in and of itself, but the
>> flag approach is expected way to do this.
> 
> What's the benefit? It's not unreasonable to exclude zero, it won't
> limit any use cases, and it's not new either (i.e. buffer tags).
> On the other hand, the user will now have to modify two fields
> instead of one, which is cleaner. And you're taking one extra bit
> out of 16bit ->ioprio, which is not critical if it's all going to
> be flags, but it wouldn't be an outrageous idea to take 8 bits
> out of it for some index, for example.

The benefit is that it's weird to exclude a given user_data value, just
so it can get used as both a key and a flag. IMHO much cleaner to have a
flag for it which explicitly says "use the user_data I provide". Also
easier to explain in docs, set this flag and then the value in X will be
the user_data for the completion.

-- 
Jens Axboe

