Return-Path: <io-uring+bounces-4907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2069D451F
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 01:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DB27282CD1
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA258230985;
	Thu, 21 Nov 2024 00:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="oAF0F5He"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FA429A0
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 00:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732150337; cv=none; b=ALjj3Z3xI3nmJv6CdTXtBdm4aFJftcEFXL7Jbu/f8XNlsY+4b2Oo7CIroz6B18SAyshm8WBZ/bqP/ZGMNTGDDYqJCe0zgDkdYiC3kuVIz7JqZKkfbrJysh0/1mwunmjOvA79UCPMbRHu1FjSxYrVayYeYHXa9nYxkThnoUonTso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732150337; c=relaxed/simple;
	bh=2/cHJKCkeQAvJWWdpn/z7VSg+9DbU1YA0SjhDRdGeeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D518UwFUy0EDPctCdUtyTAnZSxcXybkI0yzPyXPzU+N1PY9Mg57m5XcIXi4hh5I1ipPkKDFz0tc1Ji4CnOxYS5RV+mgZBQOOLIZTsaPHRAkEtzJDco6EC/v8WV4yJNklNLNQJpEYDA0bVsHEHj+HQVjhvWnDC6Gnaign4kROf2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=oAF0F5He; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7f12ba78072so326020a12.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 16:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1732150335; x=1732755135; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2xhSI6iKaURRMQqqc8WcMbHaO/CNTCfSQnpslyJLaUE=;
        b=oAF0F5HeJuozTKPR248A1/nuJFWqJaFIjXygY/GaTJBAVJbJhKdXj0hfPbFgcF2TpH
         IPsRbtHsP+Gs5ExN4ZRdLQz5K9NdiX7Hyq8xGTz8tEIZDrgt2sKdn+6xxrgav8VrVsPt
         sYAPfldbqlJYTP1vSyja9+7XX18DBsiuWrGnpFDMjJI393I+SCdhEU9tQZUX3WBfSOlO
         1/NZ4Znk5nuAzJt3N5lMcCxHAuTBZ0lLaMMliqSzqICxC57zdGeXbm1Qiu+ZtZPFiG2p
         vyuzc+dAIq5lZ+imUZQGjWo4uWTBf1VxHjG71HP2efS/brL1W9LU7RBvGCM9CzoYl32q
         pSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732150335; x=1732755135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xhSI6iKaURRMQqqc8WcMbHaO/CNTCfSQnpslyJLaUE=;
        b=CyRB7c5DvGJh/xwD7V/zSxOnT64SKY9Xmmqsw+Eg9iw+5JmZ+uSDuusIu+xgffJwTe
         lZp2VabP9HiTKwhNteBobfpD3bzzHHVe/RTUtZJTELbf3ECb4ZNdyQ177rD9c5QcGbk8
         2m+msjLesae/4Gy1X/E9IAbrsNeYw3nJH/hZ3dzbV3g4OtXOk1n9IE8XopbUFL7KAwFw
         YLnFEJN06YCypan2MYGxuj5PsGMY5qpyH9Bcc9/WL8rI7BRLJT9UNztySV+zbK7UUSAG
         YzM3WJkHDSepZudxCEYtBpjjMPh+F2pMxg+RfA2M3NoY7lBM+xDCZr+MRu4jB2XWa1xI
         QRkA==
X-Forwarded-Encrypted: i=1; AJvYcCXN05xAVIZ1GhK9mN6U5eZWrwzqNQaDQVsZlR/j4SO2UYPXfIJ9Zbkhnrv5roppPdHNV5t5iAbXYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRd9Jj49YUMM3QogSEwrrGUZ4GMeJ+mfSK5hJar149w3oZhCZ0
	QCgwIa8yO9Oxh0BnIOP9tWM0dhPzTZsGWsJ44BoN+vB5nlGlopZ2q5v8Xh0OR1w=
X-Gm-Gg: ASbGncuhQTUkhXM3sCBAF6RnNIkXyKrNrPFAAzlrhyG3TleKggm87LRT1Zilc3rkn/q
	BQV0PvvrB3+dP1kI5AUgcrXnDuLDN7mdRfwSPOA/YN6dXF+2XEYbhF4eaS0HLPBucYrntGviKVD
	nTQNwho53+LfaAR9AjWk3fGJbU7nbGLqj0JSJhquWU4RaHyPtqi3o5po5sY3TzwglAuahA/olVK
	IZ9QsjGvQO1W3/oPQ4pKTH0ySELq33KH4x9tRCasdRuOAsk5Zmr1Mkr6vMqXGVEkKt/0lTxQ1hn
	E3wrZV8urag=
X-Google-Smtp-Source: AGHT+IECBsNmlHZFxP7KTVYRuDfllZvTqwduSi/Cc0yoxU4MjL23euiKQJ0m72o48Dfd69ILXWbyOA==
X-Received: by 2002:a05:6a20:72a2:b0:1db:f51b:429 with SMTP id adf61e73a8af0-1ddb042e788mr7290325637.39.1732150335567;
        Wed, 20 Nov 2024 16:52:15 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:f444])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724beeb83dfsm2328503b3a.4.2024.11.20.16.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 16:52:15 -0800 (PST)
Message-ID: <4d71017c-8a88-40bb-a643-0efb92413d3d@davidwei.uk>
Date: Wed, 20 Nov 2024 16:52:13 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-11-20 15:56, Pavel Begunkov wrote:
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

Yeah, it doesn't. Keeping it as a llist_head means being able to re-use
helpers that take llist_head or llist_node.

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
> 
> I wonder, can we just requeue it via task_work again? We can even
> add a variant efficiently adding a list instead of a single entry,
> i.e. local_task_work_add(head, tail, ...);

That was an early idea, but it means re-reversing the list and then
atomically adding each node back to work_llist concurrently with e.g.
io_req_local_work_add().

Using a separate retry_llist means we don't need to concurrently add to
either retry_llist or work_llist.

> 
> I'm also curious what's the use case you've got that is hitting
> the problem?
> 

There is a Memcache-like workload that has load shedding based on the
time spent doing work. With epoll, the work of reading sockets and
processing a request is done by user, which can decide after some amount
of time to drop the remaining work if it takes too long. With io_uring,
the work of reading sockets is done eagerly inside of task work. If
there is a burst of work, then so much time is spent in task work
reading from sockets that, by the time control returns to user the
timeout has already elapsed.

