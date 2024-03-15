Return-Path: <io-uring+bounces-978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA31D87D2C5
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 18:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 130B41F26A2C
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E73F3B79E;
	Fri, 15 Mar 2024 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4d0gUfE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5644B4AEC6;
	Fri, 15 Mar 2024 17:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710523673; cv=none; b=Hq7Nq7r8zdtS4IR5waZkHhF7rD5CQj63sD3M58CEkNV1RXr1cnVcg6CNGc+0qENf00d2vPEF8KJoT72RtsiHV421letVAO1/sp2mLHiPDAw0sXwPpUv6pd5SOA4vuhwDpZ/HEhDgB78YCPmME+cfszGyB0LveDVDDMQw86vd/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710523673; c=relaxed/simple;
	bh=aNTEH84txPyaDXOeeEu2URaqXrwSyYq4eQl7ZotGFvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dNO9lf8VDxIrkj6GvWml8yWMGla2f2JpzJV5rRNcsn+2INmlPkrSB2R9Hpa+bmMcHKYZz4WxUuKSORsMB+BklkylK5QGBYd7r3bsfJ9xlETBXqa6VrcgAmVbTkG/Jy9NEF25gdVm+4Y70ESRaMQ4vzljC+PaLEmxI41DjipWzAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4d0gUfE; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-568b7350397so752646a12.1;
        Fri, 15 Mar 2024 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710523669; x=1711128469; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WGggEgdevfwKLnOQ1PP/dwEqPnd5YH/YUXOFssVPSNA=;
        b=P4d0gUfE3Yr4hLNOmQ+yrXk77KiZMJrjP8WAmL4w4dNTbuFYa7GxWThDCjTcWR9VLT
         Wbj8ERyVPlJlRbc+bkeK+F7z6JfLMRK8hl8sAjpMpt7IT922zkX7L+9Sddfd6Agog8Bo
         sHy5o4ja7dPIOF6ftYIGJ2IB+jMjbmgscW1BP+9H05d6Y2MYElTZ60i3I0FFbscruljR
         liI9IGEdOdru/8l4Vj5FGHTSK9EcJbEVquEqs8gwuw0LTT0s3ZrSKfse43vF+Q4Klwdd
         deSGhi+OuGFOMf7jxUDHIF+NepREBHbBfpm11kFpWgzwQ2Wqwd7LUVZWuwoYmMzQpkzI
         /EOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710523669; x=1711128469;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WGggEgdevfwKLnOQ1PP/dwEqPnd5YH/YUXOFssVPSNA=;
        b=TjaO+vkHXdBNNL0R8tkeQZAgAMp4l+mq555t8PfSmGO6JXZxkVhS196iH7cn1Nhwgo
         mbpc9Uu9Tm6bMoZGBYRa7KquXmkI6XdF/uZvtag1HTONtXfIWpvuu0Tx9X3N4Q31Ff4F
         Sn4r6EQMdYoSgrx6qjH/SsxnPRF+kikOppzYtTEsGfkaxWxfT6CRYAJQbSZgudIGL69p
         +ExselFMM6cq8ncE6U3PS4hmbR89BbZTgPNeckl7HqMqpFsp88s1kOCuJMbOSK1nw/rv
         OnwI1iSkGeYjDwfzg0yLLcA8hdqwcNK2/5y/dVH4e7RqCzk1eYZ3KYKas1AZIOucmzQv
         dsFw==
X-Forwarded-Encrypted: i=1; AJvYcCWj+gkviEDXBNo8WVWpCJR5T8CypvJcbptgdUHmCOC7wM5Q2+jxa/qsCjWvdUlsxztvi3blIilWYwBj5PSVCDVGNyhn8IyOL7w=
X-Gm-Message-State: AOJu0YynxKxwUzbFGiWB797AdiepYe6UrDrpnpL4iNyaQ4QDlPTJUsHp
	YtrmN0Sar5lyouryGPX1gFBp1HUt3QtXxmDoC4Jf46PGEjgTBeWxb4RJfEKw
X-Google-Smtp-Source: AGHT+IEPbWIB/azYXSq7seUwpVk1tgUedRyZODmpya8nJWmzeScCgPIQPyRn0P2JOdXVHjowA0oiRw==
X-Received: by 2002:a17:906:d8ac:b0:a46:4c8e:18a8 with SMTP id qc12-20020a170906d8ac00b00a464c8e18a8mr2795162ejb.51.1710523669310;
        Fri, 15 Mar 2024 10:27:49 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id a11-20020a170906190b00b00a44e2f3024bsm1881004eje.68.2024.03.15.10.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 10:27:49 -0700 (PDT)
Message-ID: <d82a07b8-a65d-4551-8516-5e50e0fab2fe@gmail.com>
Date: Fri, 15 Mar 2024 17:26:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
 <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
 <7a6b4d7f-8bbd-4259-b1f1-e026b5183350@gmail.com>
 <70e18e4c-6722-475d-818b-dc739d67f7e7@kernel.dk>
 <dfdfcafe-199f-4652-9e79-7fb0e7b2ab4f@kernel.dk>
 <e40448f1-11b4-41a8-81ab-11b4ffc1b717@gmail.com>
 <0f164d26-e4da-4e96-b413-ec66cf16e3d7@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0f164d26-e4da-4e96-b413-ec66cf16e3d7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 16:49, Jens Axboe wrote:
> On 3/15/24 10:44 AM, Pavel Begunkov wrote:
>> On 3/15/24 16:27, Jens Axboe wrote:
>>> On 3/15/24 10:25 AM, Jens Axboe wrote:
>>>> On 3/15/24 10:23 AM, Pavel Begunkov wrote:
>>>>> On 3/15/24 16:20, Jens Axboe wrote:
>>>>>> On 3/15/24 9:30 AM, Pavel Begunkov wrote:
>>>>>>> io_post_aux_cqe(), which is used for multishot requests, delays
>>>>>>> completions by putting CQEs into a temporary array for the purpose
>>>>>>> completion lock/flush batching.
>>>>>>>
>>>>>>> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
>>>>>>> directly into the CQ and defer post completion handling with a flag.
>>>>>>> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
>>>>>>> multishot requests, so have conditional locking with deferred flush
>>>>>>> for them.
>>>>>>
>>>>>> This breaks the read-mshot test case, looking into what is going on
>>>>>> there.
>>>>>
>>>>> I forgot to mention, yes it does, the test makes odd assumptions about
>>>>> overflows, IIRC it expects that the kernel allows one and only one aux
>>>>> CQE to be overflown. Let me double check
>>>>
>>>> Yeah this is very possible, the overflow checking could be broken in
>>>> there. I'll poke at it and report back.
>>>
>>> It does, this should fix it:
>>>
>>>
>>> diff --git a/test/read-mshot.c b/test/read-mshot.c
>>> index 8fcb79857bf0..501ca69a98dc 100644
>>> --- a/test/read-mshot.c
>>> +++ b/test/read-mshot.c
>>> @@ -236,7 +236,7 @@ static int test(int first_good, int async, int overflow)
>>>            }
>>>            if (!(cqe->flags & IORING_CQE_F_MORE)) {
>>>                /* we expect this on overflow */
>>> -            if (overflow && (i - 1 == NR_OVERFLOW))
>>> +            if (overflow && i >= NR_OVERFLOW)
>>
>> Which is not ideal either, e.g. I wouldn't mind if the kernel stops
>> one entry before CQ is full, so that the request can complete w/o
>> overflowing. Not supposing the change because it's a marginal
>> case, but we shouldn't limit ourselves.
> 
> But if the event keeps triggering we have to keep posting CQEs,
> otherwise we could get stuck. 

Or we can complete the request, then the user consumes CQEs
and restarts as usual

> As far as I'm concerned, the behavior with
> the patch looks correct. The last CQE is overflown, and that terminates
> it, and it doesn't have MORE set. The one before that has MORE set, but
> it has to, unless you aborted it early. But that seems impossible,
> because what if that was indeed the last current CQE, and we reap CQEs
> before the next one is posted.
> 
> So unless I'm missing something, I don't think we can be doing any
> better.

You can opportunistically try to avoid overflows, unreliably

bool io_post_cqe() {
	// Not enough space in the CQ left, so if there is a next
	// completion pending we'd have to overflow. Avoid that by
	// terminating it now.
	//
	// If there are no more CQEs after this one, we might
	// terminate a bit earlier, but that better because
	// overflows are so expensive and unhandy and so on.
	if (cq_space_left() <= 1)
		return false;
	fill_cqe();
	return true;
}

some_multishot_function(req) {
	if (!io_post_cqe(res))
		complete_req(req, res);
}

Again, not suggesting the change for all the obvious reasons, but
I think semantically we should be able to do it.

-- 
Pavel Begunkov

