Return-Path: <io-uring+bounces-6494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 382C2A38AE9
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 18:50:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 081BA189328B
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 17:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DD522E004;
	Mon, 17 Feb 2025 17:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvcuxHWT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB2229B21
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739814637; cv=none; b=BBYI5uFJG0t+B18QQvWSPnVogamOx/zp38muCQ7LNWf1ReS6uqkLGI9xNKsHTwqQpyAfrPaGWJPbKTUMSS8vp5dx8HfGLJnseB1qh7LKo6Sh5xxZum/4Pp0anTuomLQBiDSGWb5HiLIcazhKzFTt6nP2rEjRClZggya0rEgMxRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739814637; c=relaxed/simple;
	bh=gDcWZHa+PcK1KwQM86kFIMt45AN+21ZGPjDQDxj0m0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Gunk9G717QHtrzjyRmiEFVt+Q0wlXHZuGNqEDoZDypEilbKj6HoNPYourGFhAK7rBAAcLURXKrDG6SE9xjRx3CBpVJ5HFag7qT0SZJGSUy6utJYtubQ8UmumNqkiztBbUb7VuplUVpUlukw1VrtI2Lg1eXgvgMu3Dgznu0yx7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IvcuxHWT; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43962f7b0e4so28181975e9.3
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 09:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739814634; x=1740419434; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jnuze1vEc1llZWXhtFzfE8ZCR3YTh1ATCX+QfyUaemw=;
        b=IvcuxHWTa4osIW48d+l+qe3KBxgxwH31biAg7iTLSuXBEreJI6keubZbxf7LyoHn+y
         aypRnzC9iKFoBobyVEtqml5jMAmLsUTozV1Hq/euBboT54eY1qJmXVV1Dg7o2q0q30se
         ZyShqfDnEaC8T3deD4mfM/KzpZixT2XZTkm7IMI102SQN8J8PyJJyLHVSlmCjiux70Mj
         7ay+oDhcqp0d1nJyks2SKYnQEunfd+EmgCej8DGr0JXZrXGZumZv/PTIbmLB32BoD3TU
         zCvqzwTN5sJXWGYmqpLGL3QFqHKJpzIqdEWK6JRPaWQr075uIhCfvO9lcbcDNDbUUcmo
         UJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739814634; x=1740419434;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnuze1vEc1llZWXhtFzfE8ZCR3YTh1ATCX+QfyUaemw=;
        b=H50q5tdNzSquI8i4Nz4IPGyJqkkpqUvIVstc3bLEKfoS7iRbeECUM670397fyVUyL5
         EdqW3SI3HahX7HSV6T1xyNdK+VycUoYcy+ASE3yc3VXoaysfmqObL5QotJZfm2lY9tvX
         x7UUOXg7v4w+JVapCjmzCYe5LGWwkb9b884AAZVLDj0u2YtUVaxCaCqMVBKc+bqyQqu0
         Gvb5F9EWE0iE2UMMciXar4ZoIdzwcLEqpVOK3X5uAwpDLHjyI3NgFvexpQKj7rXIAAm4
         d6J0JEXNBKRIcrhrogWJZgv/k5wBYlgD/I1QQhKfSqig7teLtuk4a1pyRH3XVLWeXfmE
         oUWA==
X-Forwarded-Encrypted: i=1; AJvYcCWP8lRSWlqi4FGIybWOqNBbggcH6SzvE2UZqadRPT4guV+FGOI1d8bp/GrZyYuoV6GaI7sTJhPgLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyA855GDidAteFQcnba0MoWeRva9JU5RUrQKDUeDTOEbWcC1kJ3
	tJchf9UV8oKCy+W4kGWBFIGh41kerGzZuC2IndR/yokk+2ZfExNyMlPEZw==
X-Gm-Gg: ASbGncta9h6rnR818cEHS6BvFc2yRIp37Bt6+ME+HyVy1f4O0chgVlr0Hq6lsGsv+XR
	seqsi5xCIW751yGt8iArWJQYvBPfHjZJZTl23xvPsMyONK+prpgo2g1exCBL/ON1CZe+zU4CNpf
	nMcY1eRynajqs1hiZrg6v3geIJefwWAdiBpv6UI0BCuv944zOCa6QqtcKKmVGDKnXF96hdmiRYs
	qfcXnZsFTnH2/gytAyS2vJjxCU5ca30jUHA5JSqmPhiz7DfwElGvwgOpTN1uoq1qMdnYEnVa8de
	uuwGhRSyXGdd/1Z8HaV/nX9d
X-Google-Smtp-Source: AGHT+IFHDcGPtmGM4BcMtDwJzSA/HYlD4ixZybL6te7eUK8mWHkwZK2sonsoSgub2MqCdGZJJNcuMA==
X-Received: by 2002:a05:6000:2c8:b0:38f:3224:65ff with SMTP id ffacd0b85a97d-38f33f118bdmr9913834f8f.5.1739814633772;
        Mon, 17 Feb 2025 09:50:33 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b44a7sm13061698f8f.12.2025.02.17.09.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 09:50:33 -0800 (PST)
Message-ID: <f4ede72f-dd27-4333-997e-8454cc0570bf@gmail.com>
Date: Mon, 17 Feb 2025 17:51:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
 <b89b5ef0-9db9-44e6-9ae3-aabf39a70759@gmail.com>
 <b4c65139-b1e4-4a00-a70b-f1e1c3661d83@kernel.dk>
 <5d50f5bf-1f2a-4b01-9749-d65b52d77e76@gmail.com>
 <4fcb1ef3-689e-4c1f-9734-d4affd518d58@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4fcb1ef3-689e-4c1f-9734-d4affd518d58@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/17/25 15:57, Jens Axboe wrote:
> On 2/17/25 8:33 AM, Pavel Begunkov wrote:
>> On 2/17/25 15:06, Jens Axboe wrote:
>>> On 2/17/25 7:12 AM, Pavel Begunkov wrote:
>>>> On 2/17/25 13:58, Jens Axboe wrote:
>>>>> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>>>>>> At the moment we can't sanely handle queuing an async request from a
>>>>>> multishot context, so disable them. It shouldn't matter as pollable
>>>>>> files / socekts don't normally do async.
>>>>>
>>>>> Having something pollable that can return -EIOCBQUEUED is odd, but
>>>>> that's just a side comment.
>>>>>
>>>>>
>>>>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>>>>> index 96b42c331267..4bda46c5eb20 100644
>>>>>> --- a/io_uring/rw.c
>>>>>> +++ b/io_uring/rw.c
>>>>>> @@ -878,7 +878,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>         if (unlikely(ret))
>>>>>>             return ret;
>>>>>>     -    ret = io_iter_do_read(rw, &io->iter);
>>>>>> +    if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
>>>>>> +        void *cb_copy = rw->kiocb.ki_complete;
>>>>>> +
>>>>>> +        rw->kiocb.ki_complete = NULL;
>>>>>> +        ret = io_iter_do_read(rw, &io->iter);
>>>>>> +        rw->kiocb.ki_complete = cb_copy;
>>>>>> +    } else {
>>>>>> +        ret = io_iter_do_read(rw, &io->iter);
>>>>>> +    }
>>>>>
>>>>> This looks a bit odd. Why can't io_read_mshot() just clear
>>>>> ->ki_complete?
>>>>
>>>> Forgot about that one, as for restoring it back, io_uring compares
>>>> or calls ->ki_complete in a couple of places, this way the patch
>>>> is more contained. It can definitely be refactored on top.
>>>
>>> I'd be tempted to do that for the fix too, the patch as-is is a
>>> bit of an eye sore... Hmm.
>>
>> It is an eyesore, sure, but I think a simple/concise eyesore is
>> better as a fix than having to change a couple more blocks across
>> rw.c. It probably wouldn't be too many changes, but I can't say
>> I'm concerned about this version too much as long as it can be
>> reshuffled later.
> 
> Sure, as discussed let's do a cleanup series on top. You'll send out
> a v2 with some improved commit message wording?

Yeah, I'll resend it a bit later

-- 
Pavel Begunkov


