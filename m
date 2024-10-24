Return-Path: <io-uring+bounces-3969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D55409AE943
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 028861C212CC
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BAB88614E;
	Thu, 24 Oct 2024 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3Ko7/c7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113451DD0E6;
	Thu, 24 Oct 2024 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729781311; cv=none; b=MfCZrO8rxuNlPWHo6Zy1FiilZMJEkjMpv1qoA7aQR9E4i+luZtQIhf1xVLBkFcIRE76rbx3QMSrQ2MU42wFScPyR+teYgT6+wNPrn9vlG0HcY69IO2W7S3L3q7U85NrTEyAA4guUUDAdMTU6DfBVIuQbVLAbtSQ+uWDsyI0zdjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729781311; c=relaxed/simple;
	bh=Kf7IH7Ia1MQegT0zCCcPUUT7/Ni5m/YrbrJlFScLiGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QAYOigYB+PrO/b5UJPUVtXUrixcoyYzK2aKWVx3ZwCRg7B28b6QmbeYq+tzcqPUAlkNB7KQzVYtSoVNtY53zooaytFsKRI44LRt+kWB2wrvTmjIX/Eiu1v/sGwRaERXs+gFqFbBokVARtAne1smVAgjaW/+Rejs3NGi1ARk/VFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3Ko7/c7; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539e5c15fd3so998538e87.3;
        Thu, 24 Oct 2024 07:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729781307; x=1730386107; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G1ze1FAkv4Dqw0QEQR2ZCGcnAZHEGZrNScY6wG9W5uY=;
        b=N3Ko7/c7a8InmVTrJz4lp8E126SuY3kZdbj6ErylhuzSpebgK2vFkOXR2qJGUstIXP
         plYcbKRKXNTjmGPjihLAsIbAk+OHTrY/RmL8zWFRBuO+dtv0dlqQ+jcuUPuzAbOJTYxv
         oEIE7XvtCYBNnAeR8ZtQhwIN8ISpJmY1Oj2DHz4uYFC78eSVeiUOz0nSzaK0WjDpR0vj
         LlwrNQHFK4tePLXjteUFdWScOs07rQIlSazVJO8uGbVLLKM/WwtwHDVWK0+ORXgyqK/M
         BtSnBnjy5ZxQb2l4NSHTLtmm8niDCHwgx9G+CI/F/nv+ZYGhldNpePBgnqVmoYwvavdC
         UxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729781307; x=1730386107;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1ze1FAkv4Dqw0QEQR2ZCGcnAZHEGZrNScY6wG9W5uY=;
        b=RSSx4OrLyPoKJBgU91IeUm4eE0T8/VoMGCiq3ntwE57w/6W4wRUp3R8qRRuYoCZico
         lXmJNpWoys3pNGOQjgF+SvZMIOJ1w8aXq4J7oIO8YvUSnxMXyJ1J732kOH+x9PmeZ+RW
         cfBtwWHDwt0Wqo58egOPo7lNVjPY/25JnlyHWdTt/ZrZ5urKQNPRx9ZVSkQXqe6M6WQV
         RjwVyZ3ahTQC50J4rUm2r8MakBXzNAsMKLostU5YNiOHff40x0nvOabxf3Npb2h90UJZ
         TNs7W1nVz9YD5VlGZkF0D9lF9W02sd+a0E7fHB5vY768tY4wxyn4m/IOp+99GToZhRs3
         +N3A==
X-Forwarded-Encrypted: i=1; AJvYcCVj+mQUNi5fQS541f8i/tK/OXN7O8vOCxAP5Hm28m+5KkUUFa4PrOUb1gVQifthbaq+kalcF0bZr/dgQno=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKhi2HOoPr+xQP/anqRc8oXBqK8+9srvxiLts7JsjGN/IznVbQ
	Pc2I5X1b5A2sfCrCVLotl48LcChvV/uy9DBd9m7OevrCa4TgZ+6C
X-Google-Smtp-Source: AGHT+IE2ctdQKfTUxcYMHQ9xUqbhJ0Pcik/Mb3DaOc2KCi8IUlK89tQqbUAiTmghBI0O47SN8dBzxQ==
X-Received: by 2002:a05:6512:12cd:b0:539:ebe5:298e with SMTP id 2adb3069b0e04-53b23ea0e81mr1707345e87.59.1729781306811;
        Thu, 24 Oct 2024 07:48:26 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912ee077sm629443366b.65.2024.10.24.07.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:48:26 -0700 (PDT)
Message-ID: <8e0f74c1-aa11-4036-ba20-6f4dc0c40333@gmail.com>
Date: Thu, 24 Oct 2024 15:49:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] io_uring: releasing CPU resources when polling
To: Jens Axboe <axboe@kernel.dk>, hexue <xue01.he@samsung.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <293e5757-4160-4734-931c-9830df7c2f88@gmail.com>
 <CGME20241024023812epcas5p1e5798728def570cb57679eebdd742d7b@epcas5p1.samsung.com>
 <20241024023805.1082769-1-xue01.he@samsung.com>
 <9bc8f8c4-3415-48bb-9bd1-0996f2ef6669@kernel.dk>
 <f60116a5-8c35-4389-bbb6-7bf6deaf71c6@gmail.com>
 <b50ce7d2-b2a8-4552-8246-0464602bfd84@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b50ce7d2-b2a8-4552-8246-0464602bfd84@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 15:40, Jens Axboe wrote:
> On 10/24/24 8:26 AM, Pavel Begunkov wrote:
>> On 10/24/24 15:18, Jens Axboe wrote:
>>> On 10/23/24 8:38 PM, hexue wrote:
>>>> On 9/25/2024 12:12, Pavel Begunkov wrote:
>> ...
>>>> When the number of threads exceeds the number of CPU cores,the
>>>> database throughput does not increase significantly. However,
>>>> hybrid polling can releasing some CPU resources during the polling
>>>> process, so that part of the CPU time can be used for frequent
>>>> data processing and other operations, which speeds up the reading
>>>> process, thereby improving throughput and optimizaing database
>>>> performance.I tried different compression strategies and got
>>>> results similar to the above table.(~30% throughput improvement)
>>>>
>>>> As more database applications adapt to the io_uring engine, I think
>>>> the application of hybrid poll may have potential in some scenarios.
>>>
>>> Thanks for posting some numbers on that part, that's useful. I do
>>> think the feature is useful as well, but I still have some issues
>>> with the implementation. Below is an incremental patch on top of
>>> yours to resolve some of those, potentially. Issues:
>>>
>>> 1) The patch still reads a bit like a hack, in that it doesn't seem to
>>>      care about following the current style. This reads a bit lazy/sloppy
>>>      or unfinished. I've fixed that up.
>>>
>>> 2) Appropriate member and function naming.
>>>
>>> 3) Same as above, it doesn't care about proper placement of additions to
>>>      structs. Again this is a bit lazy and wasteful, attention should be
>>>      paid to where additions are placed to not needlessly bloat
>>>      structures, or place members in cache unfortunate locations. For
>>>      example, available_time is just placed at the end of io_ring_ctx,
>>>      why? It's a submission side member, and there's room with other
>>>      related members. Not only is the placement now where you'd want it to
>>>      be, memory wise, it also doesn't add 8 bytes to io_uring_ctx.
>>>
>>> 4) Like the above, the io_kiocb bloat is, by far, the worst. Seems to me
>>>      that we can share space with the polling hash_node. This obviously
>>>      needs careful vetting, haven't done that yet. IOPOLL setups should
>>>      not be using poll at all. This needs extra checking. The poll_state
>>>      can go with cancel_seq_set, as there's a hole there any. And just
>>>      like that, rather than add 24b to io_kiocb, it doesn't take any extra
>>>      space at all.
>>>
>>> 5) HY_POLL is a terrible name. It's associated with IOPOLL, and so let's
>>>      please use a name related to that. And require IOPOLL being set with
>>>      HYBRID_IOPOLL, as it's really a variant of that. Makes it clear that
>>>      HYBRID_IOPOLL is really just a mode of operation for IOPOLL, and it
>>>      can't exist without that.
>>>
>>> Please take a look at this incremental and test it, and then post a v9
>>> that looks a lot more finished. Caveat - I haven't tested this one at
>>> all. Thanks!
>>>
>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index c79ee9fe86d4..6cf6a45835e5 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
>>> @@ -238,6 +238,8 @@ struct io_ring_ctx {
>>>            struct io_rings        *rings;
>>>            struct percpu_ref    refs;
>>>    +        u64            poll_available_time;
>>> +
>>>            clockid_t        clockid;
>>>            enum tk_offsets        clock_offset;
>>>    @@ -433,9 +435,6 @@ struct io_ring_ctx {
>>>        struct page            **sqe_pages;
>>>          struct page            **cq_wait_page;
>>> -
>>> -    /* for io_uring hybrid poll*/
>>> -    u64            available_time;
>>>    };
>>>      struct io_tw_state {
>>> @@ -647,9 +646,22 @@ struct io_kiocb {
>>>          atomic_t            refs;
>>>        bool                cancel_seq_set;
>>> +    bool                poll_state;
>>
>> As mentioned briefly before, that can be just a req->flags flag
> 
> That'd be even better, I generally despise random bool addition.
> 
>>>        struct io_task_work        io_task_work;
>>> -    /* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
>>> -    struct hlist_node        hash_node;
>>> +    union {
>>> +        /*
>>> +         * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
>>> +         * poll
>>> +         */
>>> +        struct hlist_node    hash_node;
>>> +        /*
>>> +         * For IOPOLL setup queues, with hybrid polling
>>> +         */
>>> +        struct {
>>> +            u64        iopoll_start;
>>> +            u64        iopoll_end;
>>
>> And IIRC it doesn't need to store the end as it's used immediately
>> after it's set in the same function.
> 
> Nice, that opens up the door for less esoteric sharing as well. And
> yeah, I'd just use:
> 
> runtime = ktime_get_ns() - req->iopoll_start - sleep_time;
> 
> in io_uring_hybrid_poll() and kill it entirely, doesn't even need a
> local variable there. And then shove iopoll_start into the union with
> comp_list/apoll_events.

That's with what the current request is hooked into the list,
IOW such aliasing will corrupt the request

-- 
Pavel Begunkov

