Return-Path: <io-uring+bounces-1979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 636618D2191
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 18:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01B6EB243EB
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 16:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F303917332B;
	Tue, 28 May 2024 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Swv9Awsy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A47172BDE
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716913409; cv=none; b=HtNBlVzg6ujJXLE+QH2Xvp3zL5rkneh6so9O+Itp1zukq9zX7UhqVHQya+zvu6NcWFYraR2P+a1mLrgFSAy/jCAzp3LdyvTsnFew3WpzdtmvWlcUNQIG26RObi1R3aKqSKd+2cfwnOagCD8L4aTFZqmrF/o+kuZ/BHZYJgbLde8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716913409; c=relaxed/simple;
	bh=a6ta1AT7fqmDPbCSHMzSBuJCzQa6sYDd6kT2j8Bw0s0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=adW1MXpvo2G1up//4wJqh4gsq/38ukNU1fgSh3Sxk1l2VIjUvvHLGpb5IXlctsoXpBN3HO7pHI5SWJDdWCJjxJnmanJvOUbO077bc9Htedlw301x4uLIMHznmXp0PSEVks0PD00JgKFHzPANuUsnoDzR4lStiehN6LUEyGyRKbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Swv9Awsy; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a5dcb5a0db4so138978366b.2
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 09:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716913407; x=1717518207; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zWMIb2QsqOs99lOXFw4eo/a550eW+V/F9Z1Z8v4w4hw=;
        b=Swv9AwsyCo5t8OWpuGckXPyED4WcEKFWIgXj86mngVsfrPijlLtKSmszauzffGBGwe
         OHmirmntO51vJxTmW5k+1cp1Iz7oHzPm0vPrRUZI7vsq/qW6xr8jHnZbOoP7MYvrXOtt
         jQP4w1hNBpWRkP35UdZT1FT4D1zmi8Q1D+NsooTtg4nXQGK1mQT/jC7nm/AJdlcnybNA
         2Yivj7qmmKjzjL83IbGIEMITDyn7dvZSQImZ/JaJ/A28hPTz4tEj97piG0yfmde0Bved
         9bIJnxhmZ6C0LOrP1TdJFdVfd93PMMGas2+qsJJ3XDm5qoPKrTXD7i+/11ceW44TRRBw
         mgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716913407; x=1717518207;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWMIb2QsqOs99lOXFw4eo/a550eW+V/F9Z1Z8v4w4hw=;
        b=iKz6R++zPxiata5GoAQRTbWINUHyzx3bNiahDWjJjwAckjl8ZJvPN57XELHEfrvfCO
         FnQw59Tv9ipKgKYZ85Gh2pwCoflo/QMw/wvRsLnd7CKc7zI3/iy5i+Rp1Dz6/Co8eZRs
         /7YH7NSTbqPbHDv6J0pcGXlsuXyfP6HvXYc1rz101F3s8kyS5si0pD6isryaPguNMEHm
         ZpjtFL6RQQFFb7jygbiEuIdRtcgEojaCVMt/DWWm62bXEEBPHRaOld51EQdJokfGZjf0
         o6T9E9pzXCSG+q5IkdiAk4ZvtBDTJQkx/gEhDnRGUUNUc0defJtw6eRJWYttYClrZGYB
         0SIA==
X-Forwarded-Encrypted: i=1; AJvYcCVHHwRjRo0m47/gx84QQOK8ww3BmntvUTTviLEMSOhxbTJZtyn7Bo9cPluYUtzVZJabOP7uBR8kGNMamIhyagvxOPg9/pUziUE=
X-Gm-Message-State: AOJu0Yx8idGImfLMkU/seLH3hPsNp1/xQJdus7vKJudJG1qUxru7b14C
	iH9a04Zpi0Nki7+msB5Uy35tb6o13u6S1MLFhaIf/b3OQ7J2Q6NTkqWaRw==
X-Google-Smtp-Source: AGHT+IEyjtn4RKCG2+P5/qrLWDf7oMXdptvlknnnOmK5TOH4Co1EftYI36KdIN9px3ZWK++TZ+3nUQ==
X-Received: by 2002:a17:906:413:b0:a63:4e95:5639 with SMTP id a640c23a62f3a-a634e95579dmr120735666b.47.1716913406388;
        Tue, 28 May 2024 09:23:26 -0700 (PDT)
Received: from [192.168.42.198] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a63395fb1d0sm107039066b.89.2024.05.28.09.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 09:23:26 -0700 (PDT)
Message-ID: <8566094d-0bcb-4280-b179-a5c273e8e182@gmail.com>
Date: Tue, 28 May 2024 17:23:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/msg_ring: avoid double indirection task_work
 for data messages
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <20240524230501.20178-3-axboe@kernel.dk>
 <d0ea0826-2929-4a52-86b1-788a521a6356@gmail.com>
 <c0dedf57-26b4-4b29-acbf-6624d89bd0ac@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c0dedf57-26b4-4b29-acbf-6624d89bd0ac@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 15:23, Jens Axboe wrote:
> On 5/28/24 7:32 AM, Pavel Begunkov wrote:
>> On 5/24/24 23:58, Jens Axboe wrote:
>>> If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
>>> to the target ring. Instead, task_work is queued for the target ring,
>>> which is used to post the CQE. To make matters worse, once the target
>>> CQE has been posted, task_work is then queued with the originator to
>>> fill the completion.
>>>
>>> This obviously adds a bunch of overhead and latency. Instead of relying
>>> on generic kernel task_work for this, fill an overflow entry on the
>>> target ring and flag it as such that the target ring will flush it. This
>>> avoids both the task_work for posting the CQE, and it means that the
>>> originator CQE can be filled inline as well.
>>>
>>> In local testing, this reduces the latency on the sender side by 5-6x.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
>>>    1 file changed, 74 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>>> index feff2b0822cf..3f89ff3a40ad 100644
>>> --- a/io_uring/msg_ring.c
>>> +++ b/io_uring/msg_ring.c
>>> @@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
>>>        io_req_queue_tw_complete(req, ret);
>>>    }
>>>    +static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
>>> +{
>>> +    bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
>>> +    size_t cqe_size = sizeof(struct io_overflow_cqe);
>>> +    struct io_overflow_cqe *ocqe;
>>> +
>>> +    if (is_cqe32)
>>> +        cqe_size += sizeof(struct io_uring_cqe);
>>> +
>>> +    ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
>>
>> __GFP_ACCOUNT looks painful
> 
> It always is - I did add the usual alloc cache for this after posting
> this series, which makes it a no-op basically:

Simple ring private cache wouldn't work so well with non
uniform transfer distributions. One way messaging, userspace
level batching, etc., but the main question is in the other
email, i.e. maybe it's better to go with the 2 tw hop model,
which returns memory back where it came from.

> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-msg_ring&id=c39ead262b60872d6d7daf55e9fc7d76dc09b29d
> 
> Just haven't posted a v2 yet.
> 

-- 
Pavel Begunkov

