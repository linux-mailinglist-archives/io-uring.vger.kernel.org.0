Return-Path: <io-uring+bounces-1001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB26187D754
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 00:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5546282FEC
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BF35A11B;
	Fri, 15 Mar 2024 23:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NJyH7fQm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C6654745
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 23:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710545371; cv=none; b=XI2wa8mUjbjMBfHyTp9O6D6ZK1Rv6nkEN1NBf3uTtzBYuOicHXAWKbPiB+X1Pmtbdhfs7mv6jEQWX8MmfnKiWbGDfZa67exQzcIXo2dEA5rqN6TRWgJNB/ee/2myN79iLh1J3+S2nKPpMKeyjgoTeBAQgKEF/YA+FmWSyd1xi4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710545371; c=relaxed/simple;
	bh=j0EvM0lZfLnWFv7MtFt0G4Dd1FDPfBmuUuELflkJJ9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Bm+N4FOGA6A22PmNgf0nxFCL938wCkqIouOeIbPj46dqD9auBkwVlLPTZAzyBq3Vv/yjdP1geyLoq0N1Uw6zZDg/+Ts3oFfy7f2RvG/PxDwNY8y621T9g6YgjKBUVxSpdqol0xG4d1NgX4YPfEjoXKdsV3cFiZ7xBNiIiHp5v30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NJyH7fQm; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33d90dfe73cso1568513f8f.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710545368; x=1711150168; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dErIH7vHMO5/BWsbeDShHcJuQjNcZ+Dt3sBphYITDE8=;
        b=NJyH7fQmPElkbjBzB22HwpGBRftI7znnN+A2BtKUSh6ReDsDW+O20jRixgrmThJydh
         yDVgMLIy4KpakfdrO9UVInVbvwCtGQK8gk5NBjmyUAIO6C0HOmHG78d4O+S/xJQ9FH80
         UDo3bEzkQNejJkCtIqNgiZzbcivTXNldFavrSXtK39yuC1lcrHLilA0al4Qoyt0FVgw8
         BN+EXaj432H2RgvwxI9gbTQyU37/h6IGbchNmU2lzcGIBp7otMODAyBZPmFufEvxQ6nA
         crqK3YG403XTC1zHmBXtp/NlbkDjQUzQYAKG++sI7dVZ1LwOrgLc9tKqokMW0YrUl4GR
         wcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710545368; x=1711150168;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dErIH7vHMO5/BWsbeDShHcJuQjNcZ+Dt3sBphYITDE8=;
        b=XF5IgakuAqbfCqONzG6yNqP67E/65ASZyTCdnKwkKTP9332MOAJksWYFqd2QLm7Y9r
         eqRqf1w0+u8A2s5G/FXbcL8UKM/wzbckna/m9m55DnaE5m2/L+hD3r83rRbSkdp/xidd
         LIYeaGUSrP/2EXSeOdkEnFD/jjuTsXd33roOEuBnvPRbej3Gpi3SvHXwg/YEHMlo15EP
         F5XcnbLVGsuou0voyEP54GbLpQ2llhhbaZCORK2+tfreP1ypO5GcS9ns0OVhpNMrREOz
         IiKBYG4Y1obhzHQ3LoswTJ9PplKGQHTaSlL6w4nVzNcTZ/FNo/IPnYxajsXWf31UJ5iB
         F4gA==
X-Forwarded-Encrypted: i=1; AJvYcCUGF5dJsKaTeRIRZv2cuvRe7M6F9SgdRTM7b/On3ITsy8JhbpF8K3aStsXUlP8jPQdAl5VEyfRZ3uKrxF5yYBpil0VZhjF/XuM=
X-Gm-Message-State: AOJu0YwxU/mFEvLNfSpUHXQQrnnelWmeIp1eNHEJMA2GqtM87jmCpgOV
	UJbqAC8cO1Tp5lgLEm3+m8iGLb/6Lxxg6Di7fCGRkeQKwLUteflM/JUxKZL5
X-Google-Smtp-Source: AGHT+IFBnEGZYaBcz6FFL5mw4/7yC9uSnmWy7pCVP55odMbBESAceDB2eS66RmPHOzowX8lrEa+wGg==
X-Received: by 2002:adf:ca0f:0:b0:33e:79d7:1e6e with SMTP id o15-20020adfca0f000000b0033e79d71e6emr9286872wrh.33.1710545367627;
        Fri, 15 Mar 2024 16:29:27 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id j3-20020a05600c1c0300b004131310a29fsm7248758wms.15.2024.03.15.16.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:29:27 -0700 (PDT)
Message-ID: <f44e113c-a70f-4293-aea9-bd7b2f9e1b32@gmail.com>
Date: Fri, 15 Mar 2024 23:28:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
 <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
 <2af3dfa2-a91c-4cae-8c4c-9599459202e2@gmail.com>
 <cafdf8d7-2798-4d91-a6e5-3f9486303c6a@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cafdf8d7-2798-4d91-a6e5-3f9486303c6a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 23:25, Jens Axboe wrote:
> On 3/15/24 5:19 PM, Pavel Begunkov wrote:
>> On 3/15/24 23:13, Pavel Begunkov wrote:
>>> On 3/15/24 23:09, Pavel Begunkov wrote:
>>>> On 3/15/24 22:48, Jens Axboe wrote:
>>>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>>>> async handlers. But if we then fail setting it up and want to post
>>>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>>>> potential errors, but we need to cover the async setup too.
>>>>
>>>> You can hit io_req_defer_failed() { opdef->fail(); }
>>>> off of an early submission failure path where def->prep has
>>>> not yet been called, I don't think the patch will fix the
>>>> problem.
>>>>
>>>> ->fail() handlers are fragile, maybe we should skip them
>>>> if def->prep() wasn't called. Not even compile tested:
>>>>
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index 846d67a9c72e..56eed1490571 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>> [...]
>>>>            def->fail(req);
>>>>        io_req_complete_defer(req);
>>>>    }
>>>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>            }
>>>>            req->flags |= REQ_F_CREDS;
>>>>        }
>>>> -
>>>> -    return def->prep(req, sqe);
>>>> +    return 0;
>>>>    }
>>>>
>>>>    static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>>        int ret;
>>>>
>>>>        ret = io_init_req(ctx, req, sqe);
>>>> -    if (unlikely(ret))
>>>> +    if (unlikely(ret)) {
>>>> +fail:
>>
>> Obvious the diff is crap, but still bugging me enough to write
>> that the label should've been one line below, otherwise we'd
>> flag after ->prep as well.
> 
> It certainly needs testing :-)
> 
> We can go either way - patch up the net thing, or do a proper EARLY_FAIL
> and hopefully not have to worry about it again. Do you want to clean it
> up, test it, and send it out?

I'd rather leave it to you, I suspect it wouldn't fix the syzbot
report w/o fiddling with done_io as in your patch.

-- 
Pavel Begunkov

