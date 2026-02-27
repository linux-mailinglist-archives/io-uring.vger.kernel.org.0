Return-Path: <io-uring+bounces-12470-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UL7TGI38oWl4yAQAu9opvQ
	(envelope-from <io-uring+bounces-12470-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:20:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA7F1BD888
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0BC8030B2CBE
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D8436D50C;
	Fri, 27 Feb 2026 20:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XlAhCCwt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533C33A1E88
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 20:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772223590; cv=none; b=IsI5uZ8c44PeZlJvP3SZBHrkDZ0LRo+/0Vy2LS+dRKA4j3Z75WnI2NeND+74+8nZtvxVR1/rBrznkdb6uDWQyVr1tnI29p6hl3T0eRwXKDzr50a+UiOZYaJfLNt08h+Gs3Pw5FvcVcEyN9DSv1e4nU1eYo6DA61eqI0zRFv/ADA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772223590; c=relaxed/simple;
	bh=KxDjRuRJOb2vtbNoOURv1pmCLkh2CMp2mMgapH773Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XVVITQtoaJmCsqHkUZ1K9ZdCtcCKHfrBBuCsC1HKNa146ooVLZHFfHfnHL/BjZaZLJGdgFUUo5wBZ8LytFK6SnfN97spN6j5jRHig0VRmSl/Ye/68/AZUql9HGGusLxzBHPq8wwQaZSpXjj4WM+8wl/rsoj8U1mhIAp7RJ4r1/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XlAhCCwt; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d4c85307b2so1693997a34.0
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 12:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772223587; x=1772828387; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WiGBBcSrlWIlYuU9C5n6oY32/sPhutw5UvGN+2kDWzo=;
        b=XlAhCCwt6JQRyMT1Cul+l8YMckAINI7e/dX/UVeGtm+UTVZee4WgtVykHojY8rukC7
         5pZ6DGS3sjAh8yD4dzl4HVHfmobeCMflMKq6mz5qnAcHjWgH1RL9h+K4j2YA1MjDThKw
         G6ZZTnnXHP5RE1lQjmmgz1NDcCpf/kpvMc3UGkmMSUjM/3fJ0Uo91zpOBOXE1Hf+KX5c
         mFSxb3bQk5dsoWQBAetLrf8f1lkR3aAczGWxkY8WDfoBC3lxWGCCX3O06GmHaO135T73
         45taKXb65JQL913Q8JVa65tn2V0Sa04NSeXpXeM0fD2NfMMdFziMH8zPho+KxBEVWg/j
         YK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772223587; x=1772828387;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WiGBBcSrlWIlYuU9C5n6oY32/sPhutw5UvGN+2kDWzo=;
        b=cmKuFcIseBdBIkSF789yqUmCXZqNxjbQt5On1KtjK2jxEPlwIL0xCRxS8xHSziqh1Q
         eA2OObKvYHgbN7u3LuFtW4f6hUEhqTnTsY7LJNdfJxXI3y6rhsRJUgs8B16Gsk+9FuJS
         x0IjeJJshQJh/xVCh1D4mUhzMeVOsGxr3lQWWFkKgQe8GL8xQmd0ByIjrffc5JQ836nc
         FBvTTC7yGjFZW4XptRhltJ5AWMRpwWvGk2XDWjizjpC5i9zba/s4PUvRurGWPljI/tq4
         Cj0OcI1ahALn4hPtkujEUjx0FZEBafHoa1zjzA3FqWYsg14GgE63Wjz0LU1AcqJu8xmD
         4kuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvZy9rYhFaCuuUvKVMGAvRJINH8qn+YcMoCWl7SIAYTCELOL5nfZ/PY6pLpKxUbCZs82J8DnEHkw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwyJJfDcNH+EldMmCgv2mVK3DqggHqfbm7nO5iuNYyIMKvkROae
	D10PQIkx8yOKK0chlBDRup7LmzCup1eKfEZzxNN/COZM5mJO2Q9x7niie7x2gk9MqB8=
X-Gm-Gg: ATEYQzxQFjGmU+n1XkfnKEF/ORojPxlqwffDw9MhcpDco8gV4Z3jt40gr+SSa+M2x4M
	YkxXq/whB9R2BhR84HvfORniHLtIapqCJ2rea+yrXI61GAChTxwFRx5uxAZsjQKAZOkPcZgEoLS
	+E2IQRGA9YbZG+Q53jhwPUsMpXFOzcX75ZiLcEMX6B73pBczr9/NvLF9+a6gLkvYZHl4jtYFaQ+
	lu/hojpQcgFkmPinVsW6MwB1ZBwN76yu+i/vgA8g5Vff5ETlGw4bUVGpWZzAHjJAtNEFkkQ9nLA
	XkYNopfhjE2N/nhdwHaFIZpXJwUf1xAzsiZdg+eGC5JM8buX2tX2QbKCJmIbkiMBnFDUUp/LSWa
	ehJNpqmBuY18nLOX8wyzbx2YuPKaJ5zAsEZSF26MlalqYs0JO7oaI9Q+A3QV0ZgNBTgXccpA4rk
	G41NPldiMZkaM/vwQaV9eGvWhrGxSktZMEKw8herrGla0IZW4qU6+OgsMlcONq8RuFewqqlwgH7
	daz62QUPg==
X-Received: by 2002:a05:6870:824d:b0:404:40cf:ff1b with SMTP id 586e51a60fabf-41627100082mr2757666fac.54.1772223586857;
        Fri, 27 Feb 2026 12:19:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160d26d9absm5675365fac.16.2026.02.27.12.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 12:19:46 -0800 (PST)
Message-ID: <2daa9b01-d989-4922-b892-e7f3f06297ac@kernel.dk>
Date: Fri, 27 Feb 2026 13:19:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Pavel Begunkov <asml.silence@gmail.com>,
 Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
 <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
 <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12470-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,samba.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: CBA7F1BD888
X-Rspamd-Action: no action

On 2/27/26 1:03 PM, Pavel Begunkov wrote:
> On 2/27/26 19:39, Jens Axboe wrote:
>> On 2/27/26 12:08 PM, Pavel Begunkov wrote:
>>> On 2/27/26 14:08, Stefan Metzmacher wrote:
>>>> Hi Pavel,
>>>>
>>>>>        if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>>>>            return -EINVAL;
>>>>> @@ -460,10 +461,20 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>                return -EINVAL;
>>>>>            if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
>>>>>                tr->ltimeout = true;
>>>>> -        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
>>>>> +        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
>>>>> +                  IORING_TIMEOUT_ABS |
>>>>> +                  IORING_TIMEOUT_IMMEDIATE_ARG))
>>>>>                return -EINVAL;
>>>>> -        if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
>>>>> +
>>>>> +        arg = READ_ONCE(sqe->addr2);
>>>>> +        if (tr->flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
>>>>> +            if (tr->flags & IORING_TIMEOUT_ABS)
>>>>> +                return -EINVAL;
>>>>> +            tr->ts = ns_to_timespec64(arg);
>>>>
>>>> I'm wondering if there is enough free space in a small sqe to hold a full timespec?
>>>> So that there is no restriction for IORING_TIMEOUT_ABS...
>>>
>>> Well, u64 gives ~500 years in ns, it should be fine to just
>>> allow the abs mode. We just need to make sure to zero check
>>> the unused fields in case it'd need to be extended.
>>
>> I don't think it's about length of it - if you can avoid the div by
>> doing ns_to_timespec64(), that might be very useful? Would make
> 
> hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
>                                    ^^^
> 
> io_uring just needs to flip it and use ktime, but I left it for later.

I think we should go all the way with this if we're doing the immediate
mode. And I do think that is a good idea. Doing a half-way thing doesn't
make much sense to me.

>> userspace simpler too potentially, and basically make the immediate mode
>> _exactly_ the same as the non-immediate mode, it just delivers the
>> __kernel_timespec in a different way.
> 
> I very much want to believe that everything about kernel_timespec has
> some deep meaning, but I fail to see why they split it as sec/ns and
> left invalid ranges for ns, why ns is signed, and why even after a
> large revamp one of the fields doesn't use a fixed width type.
> I'm not sure exactly like it is actually a good idea.

But that's the API for anything timing related, whether it be timeval,
timespec, or __kernel_timespec the latter obviously only existing
because everybody else could not be bothered to do a proper 32 vs 64-bit
agnostic type before. Hence that's the API that people know and use,
there's no deeper meaning other than that. And I agree, it's kind of
crap in how you can have an invalid range and it gets masked.

It's like like I'm a huge __kernel_timespec fan, but for consistency's
sake, I do like it. With a clock source, then it does start to make
sense. Not that I think there's a lot of ABS use cases, I'd expect
relative to be what people generally use here. But at least then the
IMMED API addition will just work regardless of what you do in the app.
That's better than someone a few revisions later than saying "hey that's
cool, can we do ABS too which I use because of X and Y" and then having
to hack that on top.

-- 
Jens Axboe

