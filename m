Return-Path: <io-uring+bounces-3971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B5A9AE946
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C12581F2295A
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC41C1D63C5;
	Thu, 24 Oct 2024 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fhUMtAIh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988DF145B0B
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729781374; cv=none; b=DkCpteAimndUKsZF9j6p1uMq1iuHll1esblRxegR6a3V5RrTqqKV+6ozMwb6PvFQmW+J015K3ARKl2ZxOHVn+eBwRGHvjmSlwdkDyzirMRMLYWiQTfgQRUGocQsjFK3u0hOPcgjgkPRqK5/jsTpItxzizUmnxXGn8t85zMhad3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729781374; c=relaxed/simple;
	bh=7EB+KL34+gso/d+CRmWtKh7IFrlB8NA85v8f0Vq6yks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NqmKxi3uwp87KTjfBI6vo4CYGh2PX1VP5nwXFe0qaxlcojkFM+wSkjOdf9WLp6DGlkVwa0jMs0xnZwC9TaXYATCNkFchKh10InO6PnkChbktiLAGQY2RgrYNcKfRrsdz0Dvk1JYkOf65TNOtwJt2SWSZtqcLL7yBPWemkZMjQAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fhUMtAIh; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83abcfb9f39so33317839f.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 07:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729781371; x=1730386171; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cEE+Tifceqc/YN/4H/k/q++NkaaA/JoseVNvq94j9Nc=;
        b=fhUMtAIhEQhKRn4scE0i4wE+lXOnp7h/5WYMVi3D867VdMohXzBKRal3lMOm/IG+C6
         n/TBInoaOkXaXmUlUJIZv3xbr5B83Twxy5sUdCUEzMv4WRBsjePdqu5UMa9rupDCztZh
         InS69FycAfvyOabHS8xAuGRVfX2oMBgbLZkAFGmeuWyyFORU5Kjfo1OpB1J6UhSi4+bO
         7iQhsWQwokQ/trCnx2/evVikwSqMX777MP5SwfZBu5OrLQeSpQmhSnS364QOVpw3sqVC
         YiXxjvPmT8RfZlXD89GYJ4+VQB+cwtwY0XF0ShkbrWKl32vu1XiY6q31TxYErYutu2CY
         5J2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729781371; x=1730386171;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cEE+Tifceqc/YN/4H/k/q++NkaaA/JoseVNvq94j9Nc=;
        b=YC2cRaxfTv41CNRPExbyJ+k7zTwNlZfQy01rifwv6zRZ/UeGan+0WQ8MrenRr4C3Ph
         I9q8n64Xg5R3iQ2MSiojnJWp5JrsiGPE7c2eM0XPISevc+/NA7kgzy3WBEmpob90YkRJ
         vu6WNuKqFNB+k+eoVq1u9t0ribc21Zxd796qhyub2yghynxD1rTyaLLxMQFphfjA8MAG
         PGlW9veVEnOU0KUBP8KBRg3XAuFbirKSrGQqf48mXPoK6IehxQI020RdOGBoX/gALGIe
         utCHC2udXEHZL/E4EHADnSz38+lFJ1piNxF24c9l1f83dpupIrBmvYdEwcWfJW6aildD
         meDQ==
X-Gm-Message-State: AOJu0YzSvU+3we6BPp/EFO+F2nHySlzCJBIT0/H1Bx/7jI3LAzA8CBOm
	MJBQQ4+s8FuvzUQOUB6XRM+2QXqcUE/D5xQxKtjxdFBWNYq+W1vZhfzw45VUulLopf7Q/SUzMyX
	W
X-Google-Smtp-Source: AGHT+IFcKagZNVxnbRrEEdWW6Ze2R6s46McKtz+x9BGvmpgEPZVvMa8svouKm2Z1ah8rRi3Na3hI0Q==
X-Received: by 2002:a05:6602:2b0d:b0:83a:adb4:e2c9 with SMTP id ca18e2360f4ac-83b043405f4mr158559839f.1.1729781371488;
        Thu, 24 Oct 2024 07:49:31 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83ad1df0658sm284877139f.49.2024.10.24.07.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:49:30 -0700 (PDT)
Message-ID: <62e57b0e-b646-4f96-bb83-5a0ecb4050da@kernel.dk>
Date: Thu, 24 Oct 2024 08:49:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] io_uring: releasing CPU resources when polling
To: Pavel Begunkov <asml.silence@gmail.com>, hexue <xue01.he@samsung.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <293e5757-4160-4734-931c-9830df7c2f88@gmail.com>
 <CGME20241024023812epcas5p1e5798728def570cb57679eebdd742d7b@epcas5p1.samsung.com>
 <20241024023805.1082769-1-xue01.he@samsung.com>
 <9bc8f8c4-3415-48bb-9bd1-0996f2ef6669@kernel.dk>
 <f60116a5-8c35-4389-bbb6-7bf6deaf71c6@gmail.com>
 <b50ce7d2-b2a8-4552-8246-0464602bfd84@kernel.dk>
 <8e0f74c1-aa11-4036-ba20-6f4dc0c40333@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8e0f74c1-aa11-4036-ba20-6f4dc0c40333@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 8:49 AM, Pavel Begunkov wrote:
> On 10/24/24 15:40, Jens Axboe wrote:
>> On 10/24/24 8:26 AM, Pavel Begunkov wrote:
>>> On 10/24/24 15:18, Jens Axboe wrote:
>>>> On 10/23/24 8:38 PM, hexue wrote:
>>>>> On 9/25/2024 12:12, Pavel Begunkov wrote:
>>> ...
>>>>> When the number of threads exceeds the number of CPU cores,the
>>>>> database throughput does not increase significantly. However,
>>>>> hybrid polling can releasing some CPU resources during the polling
>>>>> process, so that part of the CPU time can be used for frequent
>>>>> data processing and other operations, which speeds up the reading
>>>>> process, thereby improving throughput and optimizaing database
>>>>> performance.I tried different compression strategies and got
>>>>> results similar to the above table.(~30% throughput improvement)
>>>>>
>>>>> As more database applications adapt to the io_uring engine, I think
>>>>> the application of hybrid poll may have potential in some scenarios.
>>>>
>>>> Thanks for posting some numbers on that part, that's useful. I do
>>>> think the feature is useful as well, but I still have some issues
>>>> with the implementation. Below is an incremental patch on top of
>>>> yours to resolve some of those, potentially. Issues:
>>>>
>>>> 1) The patch still reads a bit like a hack, in that it doesn't seem to
>>>>      care about following the current style. This reads a bit lazy/sloppy
>>>>      or unfinished. I've fixed that up.
>>>>
>>>> 2) Appropriate member and function naming.
>>>>
>>>> 3) Same as above, it doesn't care about proper placement of additions to
>>>>      structs. Again this is a bit lazy and wasteful, attention should be
>>>>      paid to where additions are placed to not needlessly bloat
>>>>      structures, or place members in cache unfortunate locations. For
>>>>      example, available_time is just placed at the end of io_ring_ctx,
>>>>      why? It's a submission side member, and there's room with other
>>>>      related members. Not only is the placement now where you'd want it to
>>>>      be, memory wise, it also doesn't add 8 bytes to io_uring_ctx.
>>>>
>>>> 4) Like the above, the io_kiocb bloat is, by far, the worst. Seems to me
>>>>      that we can share space with the polling hash_node. This obviously
>>>>      needs careful vetting, haven't done that yet. IOPOLL setups should
>>>>      not be using poll at all. This needs extra checking. The poll_state
>>>>      can go with cancel_seq_set, as there's a hole there any. And just
>>>>      like that, rather than add 24b to io_kiocb, it doesn't take any extra
>>>>      space at all.
>>>>
>>>> 5) HY_POLL is a terrible name. It's associated with IOPOLL, and so let's
>>>>      please use a name related to that. And require IOPOLL being set with
>>>>      HYBRID_IOPOLL, as it's really a variant of that. Makes it clear that
>>>>      HYBRID_IOPOLL is really just a mode of operation for IOPOLL, and it
>>>>      can't exist without that.
>>>>
>>>> Please take a look at this incremental and test it, and then post a v9
>>>> that looks a lot more finished. Caveat - I haven't tested this one at
>>>> all. Thanks!
>>>>
>>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>>> index c79ee9fe86d4..6cf6a45835e5 100644
>>>> --- a/include/linux/io_uring_types.h
>>>> +++ b/include/linux/io_uring_types.h
>>>> @@ -238,6 +238,8 @@ struct io_ring_ctx {
>>>>            struct io_rings        *rings;
>>>>            struct percpu_ref    refs;
>>>>    +        u64            poll_available_time;
>>>> +
>>>>            clockid_t        clockid;
>>>>            enum tk_offsets        clock_offset;
>>>>    @@ -433,9 +435,6 @@ struct io_ring_ctx {
>>>>        struct page            **sqe_pages;
>>>>          struct page            **cq_wait_page;
>>>> -
>>>> -    /* for io_uring hybrid poll*/
>>>> -    u64            available_time;
>>>>    };
>>>>      struct io_tw_state {
>>>> @@ -647,9 +646,22 @@ struct io_kiocb {
>>>>          atomic_t            refs;
>>>>        bool                cancel_seq_set;
>>>> +    bool                poll_state;
>>>
>>> As mentioned briefly before, that can be just a req->flags flag
>>
>> That'd be even better, I generally despise random bool addition.
>>
>>>>        struct io_task_work        io_task_work;
>>>> -    /* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
>>>> -    struct hlist_node        hash_node;
>>>> +    union {
>>>> +        /*
>>>> +         * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
>>>> +         * poll
>>>> +         */
>>>> +        struct hlist_node    hash_node;
>>>> +        /*
>>>> +         * For IOPOLL setup queues, with hybrid polling
>>>> +         */
>>>> +        struct {
>>>> +            u64        iopoll_start;
>>>> +            u64        iopoll_end;
>>>
>>> And IIRC it doesn't need to store the end as it's used immediately
>>> after it's set in the same function.
>>
>> Nice, that opens up the door for less esoteric sharing as well. And
>> yeah, I'd just use:
>>
>> runtime = ktime_get_ns() - req->iopoll_start - sleep_time;
>>
>> in io_uring_hybrid_poll() and kill it entirely, doesn't even need a
>> local variable there. And then shove iopoll_start into the union with
>> comp_list/apoll_events.
> 
> That's with what the current request is hooked into the list,
> IOW such aliasing will corrupt the request

Ah true, well some other spot then, should be pretty easy to find 8
bytes for iopoll_start. As mentioned, the point is really just to THINK
about where it should go, rather than lazily just shove it at the end
like no thought has been given to it.

-- 
Jens Axboe

