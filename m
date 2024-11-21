Return-Path: <io-uring+bounces-4908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 683BD9D4530
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 02:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A231D2810F5
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 01:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4852FB6;
	Thu, 21 Nov 2024 01:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yZ7bVs2J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6800333C9
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 01:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732151539; cv=none; b=b40KnKRHTy8/Jgm46OPZ9SbteP4UZQz3aom0sEmiy+2ML5kdkJLA03ZQYpN7HDBy2qHZ15H/MwgZ172RMCfPfDZ5pQbBbsNZWf6VLJZTX5b8T81iCImJQbPJvbVrXSun82hjmgLDqbiAfnNH0lQxxCvWFIPiZ6wROHpIUU/9iK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732151539; c=relaxed/simple;
	bh=3dtCurfJyS298pcmxYYF0DpZD0ZWgXP3X0644QpS6Ww=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KuSqknR/OWk0HLXONIUQfyb5kMFyBX2leaM0+TDR4K2aogg0X2nAYALZSfoge3O5xbS6AqmKC1+gmUJhd6EdZzzg5KpkMs0uvgeVwBx5UldDDVsT2sQwEV5FNStGnLAW3T56WqI4MtQheVdBkRU/cp9yoXNwGheuRL7XzJlioIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yZ7bVs2J; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7246c8c9b1cso311128b3a.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 17:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732151534; x=1732756334; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WSYTCyoW7g9OgmHz50PNQL8SdQ9F539I6/2ULRG2qYE=;
        b=yZ7bVs2J1Vy2Y7F9/gk9reOicqSiX9kUR2+QRSMfmJLhOtV43xCEirkaJKl5nvQss/
         bjYjUXrUhtAbM7Q+Gum4JwKbLLLOHne2mxNpB6oYvlOF3wn3Macf8RyG2S+QK2uOvipW
         UxtUvdWyAT3qrVkwsjW848hUIN8Ayw6lLsmT6ml6ASmxsp8kL3aWcbk/9SaT4xgMwDzt
         is5CS5u7BadDaaZXK4zoB8wlOlA71y9GyIGEJN9g3MoFZQDtQGoNq4Dbd5aiPQ/DCp/I
         P1CkONprdDXFluUI3Rkih2YMz9XvsLwRJhPQooLTRMeB7c5PEDURqYqvQNYdfZV1P68u
         784g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732151534; x=1732756334;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSYTCyoW7g9OgmHz50PNQL8SdQ9F539I6/2ULRG2qYE=;
        b=I9BXjZ3B6ktj1Y9seHhVGQX4886F0GEzrwP8o0GsyvThuZ45Iw+0nhjkxN7tCbwlYp
         WyWnDaT9B/yw5V5HTV/rcBUiLk88CS5cHVxgib/Owv1o1SR4m7jvXi3TdX7GQSI7jIwa
         yQyUva9q3xn7Qv6xdROKs7TMmkSS2r+N2L/7IfZMg4oymPEshxWNLRdW/BL+HR1cHQRB
         7h4vscdq0ysBm0Dd5goj5N258vPbMzQ5pTowZw0ccAOZz/t3uX8atcQvMeAly9RA7Wq0
         Sn2dYrxFD7O+kgpl7TXfL9fMQwcxZyorGYn+non0EsDLIyXsTT6Vv9hmTX2mzomffc5T
         eOCw==
X-Forwarded-Encrypted: i=1; AJvYcCU6M2RUdbe9LSUH7Aqd7FFPHianyhKA4a1lKybiC6heqSXHF7Cz6n/tppt74m8dqYwKj3ZA/MeU5A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkwJ/9Y74qyN7wEv2cIru4aHbqbLaA/U7fZiEIq4gufqJevOzv
	soEqPoOn9hD6NCRf1cNoE1ACqzvcpVunMisNeILeoPMcVTc9+DZWYpXgSB4NV6tido3wKmHnjwQ
	rfRo=
X-Gm-Gg: ASbGncuoRHT78zb+W/n3JCpWv8HHIU4iIweZ+4ZgNLNlQ67bzlfw0DRcIBk7RrSrg6W
	XLYoK/+JoFTVYUUejdnz5huLDE+JF5d265yywItwfpAqXW64byFcgRC6ojS84//kxFeUEJxX/mM
	4zCybGoRX3IfUymr1XspOnVuZUMT0oadbsxZIiQRJLvoBY8ELlh/M74BfolET3peXhZIOMq1Lhi
	G41q6+0e66UqR2d4Wt/v6rM8Xj5NxRGMLr7B6OruCS/Yms=
X-Google-Smtp-Source: AGHT+IFtXTWkv2l/SdiWm92BuwRo5CLyH1Ln1KGyCz4+xpVuGKweJRIArkkxe6MrBzNNC6i82h022A==
X-Received: by 2002:a05:6a00:998:b0:71e:b8:1930 with SMTP id d2e1a72fcca58-724bedf0768mr5950494b3a.16.1732151534165;
        Wed, 20 Nov 2024 17:12:14 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724bef9142dsm2404387b3a.100.2024.11.20.17.12.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 17:12:13 -0800 (PST)
Message-ID: <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
Date: Wed, 20 Nov 2024 18:12:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 4:56 PM, Pavel Begunkov wrote:
> On 11/20/24 22:14, David Wei wrote:
>> Instead of eagerly running all available local tw, limit the amount of
>> local tw done to the max of IO_LOCAL_TW_DEFAULT_MAX (20) or wait_nr. The
>> value of 20 is chosen as a reasonable heuristic to allow enough work
>> batching but also keep latency down.
>>
>> Add a retry_llist that maintains a list of local tw that couldn't be
>> done in time. No synchronisation is needed since it is only modified
>> within the task context.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   include/linux/io_uring_types.h |  1 +
>>   io_uring/io_uring.c            | 43 +++++++++++++++++++++++++---------
>>   io_uring/io_uring.h            |  2 +-
>>   3 files changed, 34 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 593c10a02144..011860ade268 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -336,6 +336,7 @@ struct io_ring_ctx {
>>        */
>>       struct {
>>           struct llist_head    work_llist;
>> +        struct llist_head    retry_llist;
> 
> Fwiw, probably doesn't matter, but it doesn't even need
> to be atomic, it's queued and spliced while holding
> ->uring_lock, the pending check is also synchronised as
> there is only one possible task doing that.
> 
>>           unsigned long        check_cq;
>>           atomic_t        cq_wait_nr;
>>           atomic_t        cq_timeouts;
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 83bf041d2648..c3a7d0197636 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -121,6 +121,7 @@
> ...
>>   static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
>>                      int min_events)
>>   {
>>       struct llist_node *node;
>>       unsigned int loops = 0;
>> -    int ret = 0;
>> +    int ret, limit;
>>         if (WARN_ON_ONCE(ctx->submitter_task != current))
>>           return -EEXIST;
>>       if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>>           atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>> +    limit = max(IO_LOCAL_TW_DEFAULT_MAX, min_events);
>>   again:
>> +    ret = __io_run_local_work_loop(&ctx->retry_llist.first, ts, limit);
>> +    if (ctx->retry_llist.first)
>> +        goto retry_done;
>> +
>>       /*
>>        * llists are in reverse order, flip it back the right way before
>>        * running the pending items.
>>        */
>>       node = llist_reverse_order(llist_del_all(&ctx->work_llist));
>> -    while (node) {
>> -        struct llist_node *next = node->next;
>> -        struct io_kiocb *req = container_of(node, struct io_kiocb,
>> -                            io_task_work.node);
>> -        INDIRECT_CALL_2(req->io_task_work.func,
>> -                io_poll_task_func, io_req_rw_complete,
>> -                req, ts);
>> -        ret++;
>> -        node = next;
>> -    }
>> +    ret = __io_run_local_work_loop(&node, ts, ret);
> 
> One thing that is not so nice is that now we have this handling and
> checks in the hot path, and __io_run_local_work_loop() most likely
> gets uninlined.

I don't think that really matters, it's pretty light. The main overhead
in this function is not the call, it's reordering requests and touching
cachelines of the requests.

I think it's pretty light as-is and actually looks pretty good. It's
also similar to how sqpoll bites over longer task_work lines, and
arguably a mistake that we allow huge depths of this when we can avoid
it with deferred task_work.

> I wonder, can we just requeue it via task_work again? We can even
> add a variant efficiently adding a list instead of a single entry,
> i.e. local_task_work_add(head, tail, ...);

I think that can only work if we change work_llist to be a regular list
with regular locking. Otherwise it's a bit of a mess with the list being
reordered, and then you're spending extra cycles on potentially
reordering all the entries again.

> I'm also curious what's the use case you've got that is hitting
> the problem?

I'll let David answer that one, but some task_work can take a while to
run, eg if it's not just posting a completion.

-- 
Jens Axboe

