Return-Path: <io-uring+bounces-3966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA6D9AE920
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AA8F1C21E8C
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F40F1E5731;
	Thu, 24 Oct 2024 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cdKeYq31"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097281E3DE8
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729780843; cv=none; b=C70NoT8lwpASmiKba0pahIstcRkyIZ62MgGGrfufKA5D6T1LWL9nPXuxNbs7DmG2rtsGLe5B0rab9IpD5Ksg25NejII1IXxRRaGFy1Vk5cLcsbeK7Jlz0g1OxU9SHe3SYlGO95wqun21UOzZwbbyfchNx7DDkEv/iv0DtLewMmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729780843; c=relaxed/simple;
	bh=Zqyf6G7EWpyPb0E6EP/8o4ogo4doOTNJFut5sn+GPt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=twf0wKpr65alVCxs32ThI7d9bOBr3W3LfeaFBqVQ38ZH/8yCQEUi77y8U8VVvb2xl/sumQv67J7tltsI0UdO8YI5rf2QBy1If10j5MkCtmIzAcLZY/TWTDM+M2ANc6lI6s/rWYDPLwUI1bQ4gQRnLGrpzSmZrDchuFh8iEzD9uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cdKeYq31; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83a9be2c028so39151939f.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 07:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729780839; x=1730385639; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c8dgch9h6/ddwkKcahJf8uCo+FVSUUTd8MNxrHmVrWk=;
        b=cdKeYq31MZVKougG1wfxrXkNMP43cmqUEv54h2W1aiUkIszJ02cCJwsZPTMlfFdZvF
         uUWO93cK9n6Fwc/YWqaR3+PIZwjbyvJhKF1I0bXBDRwEGwb3sZtGuQ4V3u5v/+KMdhSn
         dLWN9h8G18VuOyjZVJYGq/p+bDipMCIhC0fAnq/1EhXAlXSaZKcfgwOTOs6R0CqeeaY/
         1jqpSUiPowhJ2VrhR+UzNEQz0egpptTF9VEpZ9lb5JNCsy2h39KqVM7HLM3pjuKfCKL+
         OjksLOzjwKW866Hq98IvToNDp6vSkxwokefWNHd8gvJku3YUxg9WL475H2WNkmvAhtaE
         +6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729780839; x=1730385639;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c8dgch9h6/ddwkKcahJf8uCo+FVSUUTd8MNxrHmVrWk=;
        b=a9CaSRxg0RHixakXuUvVHwcueFTLcOBgDyfqeq6knA/Bl7R1/NLyZEaoYBBtoBE3d5
         UpViaO5SlM2TGpRg2JIA68iRm3LwpfA+i/juO1KDnzXmpy0qfukZGEqITf4Sp04O+tvK
         UxzSOgEzLXRemQmXxIDu1oYzx+1NGUOUdrWyTimPDLcrtGx4X7rNhBzCo+GErZgyjmnh
         eI9fzY0f5924x7lNSc5VvPensCpsi8xm+Gmgi9D91vlIw2TXkDhSjS23lfXj7PYGIn7+
         IMzFUR2NwtD8b+nWfabYuIIdqugafjopS6fIgMaodYskhJd7aV3Sz6YRe/9FDSbsczdI
         0/qA==
X-Gm-Message-State: AOJu0Yw/UZGn42K6R1wzUVRsX8I1/74RmbIbuEks2w1CC9/ku9byQnWV
	XObE/S7CmlRRnhUyhaHKRFg9rWY6pty6jKsjKV8RqzFuGDwEhfds3H0ATZg+b14=
X-Google-Smtp-Source: AGHT+IEPUVvgxne25Bp0uIrpKmbnJk51XcDluIHPBNH8hGAkBt9cRAM+LoNsopUyfgAaVBbnBBvCKw==
X-Received: by 2002:a05:6602:2cc9:b0:83a:aa8e:5f72 with SMTP id ca18e2360f4ac-83af6163931mr618697939f.4.1729780838796;
        Thu, 24 Oct 2024 07:40:38 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc49baafd1sm1440243173.104.2024.10.24.07.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:40:38 -0700 (PDT)
Message-ID: <b50ce7d2-b2a8-4552-8246-0464602bfd84@kernel.dk>
Date: Thu, 24 Oct 2024 08:40:37 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f60116a5-8c35-4389-bbb6-7bf6deaf71c6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 8:26 AM, Pavel Begunkov wrote:
> On 10/24/24 15:18, Jens Axboe wrote:
>> On 10/23/24 8:38 PM, hexue wrote:
>>> On 9/25/2024 12:12, Pavel Begunkov wrote:
> ...
>>> When the number of threads exceeds the number of CPU cores,the
>>> database throughput does not increase significantly. However,
>>> hybrid polling can releasing some CPU resources during the polling
>>> process, so that part of the CPU time can be used for frequent
>>> data processing and other operations, which speeds up the reading
>>> process, thereby improving throughput and optimizaing database
>>> performance.I tried different compression strategies and got
>>> results similar to the above table.(~30% throughput improvement)
>>>
>>> As more database applications adapt to the io_uring engine, I think
>>> the application of hybrid poll may have potential in some scenarios.
>>
>> Thanks for posting some numbers on that part, that's useful. I do
>> think the feature is useful as well, but I still have some issues
>> with the implementation. Below is an incremental patch on top of
>> yours to resolve some of those, potentially. Issues:
>>
>> 1) The patch still reads a bit like a hack, in that it doesn't seem to
>>     care about following the current style. This reads a bit lazy/sloppy
>>     or unfinished. I've fixed that up.
>>
>> 2) Appropriate member and function naming.
>>
>> 3) Same as above, it doesn't care about proper placement of additions to
>>     structs. Again this is a bit lazy and wasteful, attention should be
>>     paid to where additions are placed to not needlessly bloat
>>     structures, or place members in cache unfortunate locations. For
>>     example, available_time is just placed at the end of io_ring_ctx,
>>     why? It's a submission side member, and there's room with other
>>     related members. Not only is the placement now where you'd want it to
>>     be, memory wise, it also doesn't add 8 bytes to io_uring_ctx.
>>
>> 4) Like the above, the io_kiocb bloat is, by far, the worst. Seems to me
>>     that we can share space with the polling hash_node. This obviously
>>     needs careful vetting, haven't done that yet. IOPOLL setups should
>>     not be using poll at all. This needs extra checking. The poll_state
>>     can go with cancel_seq_set, as there's a hole there any. And just
>>     like that, rather than add 24b to io_kiocb, it doesn't take any extra
>>     space at all.
>>
>> 5) HY_POLL is a terrible name. It's associated with IOPOLL, and so let's
>>     please use a name related to that. And require IOPOLL being set with
>>     HYBRID_IOPOLL, as it's really a variant of that. Makes it clear that
>>     HYBRID_IOPOLL is really just a mode of operation for IOPOLL, and it
>>     can't exist without that.
>>
>> Please take a look at this incremental and test it, and then post a v9
>> that looks a lot more finished. Caveat - I haven't tested this one at
>> all. Thanks!
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index c79ee9fe86d4..6cf6a45835e5 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -238,6 +238,8 @@ struct io_ring_ctx {
>>           struct io_rings        *rings;
>>           struct percpu_ref    refs;
>>   +        u64            poll_available_time;
>> +
>>           clockid_t        clockid;
>>           enum tk_offsets        clock_offset;
>>   @@ -433,9 +435,6 @@ struct io_ring_ctx {
>>       struct page            **sqe_pages;
>>         struct page            **cq_wait_page;
>> -
>> -    /* for io_uring hybrid poll*/
>> -    u64            available_time;
>>   };
>>     struct io_tw_state {
>> @@ -647,9 +646,22 @@ struct io_kiocb {
>>         atomic_t            refs;
>>       bool                cancel_seq_set;
>> +    bool                poll_state;
> 
> As mentioned briefly before, that can be just a req->flags flag

That'd be even better, I generally despise random bool addition.

>>       struct io_task_work        io_task_work;
>> -    /* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
>> -    struct hlist_node        hash_node;
>> +    union {
>> +        /*
>> +         * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
>> +         * poll
>> +         */
>> +        struct hlist_node    hash_node;
>> +        /*
>> +         * For IOPOLL setup queues, with hybrid polling
>> +         */
>> +        struct {
>> +            u64        iopoll_start;
>> +            u64        iopoll_end;
> 
> And IIRC it doesn't need to store the end as it's used immediately
> after it's set in the same function.

Nice, that opens up the door for less esoteric sharing as well. And
yeah, I'd just use:

runtime = ktime_get_ns() - req->iopoll_start - sleep_time;

in io_uring_hybrid_poll() and kill it entirely, doesn't even need a
local variable there. And then shove iopoll_start into the union with
comp_list/apoll_events.

My main points are really: don't randomly sprinkle additions to structs.
Think about if they are needed, and if they are, be a bit smarter about
where to place them. The original patch did neither of those, and that's
a non-starter.

-- 
Jens Axboe

