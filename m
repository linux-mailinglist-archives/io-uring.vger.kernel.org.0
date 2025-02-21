Return-Path: <io-uring+bounces-6598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03393A3F7BB
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 15:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48F581895FCD
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 14:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23DFA20F09A;
	Fri, 21 Feb 2025 14:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J86z8Gl9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EF720967C;
	Fri, 21 Feb 2025 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740149533; cv=none; b=uzgzsfb0AOOy9NVrNK1cwqJuhEv31sCc6TrVwoiohT6177zq16Q5mN/e7KneqUOViFAGyzA+d192H2FpPGIcOZtX5g2i1v7yE+ueiDcU9CWsrGSRdXDHwGh1TKwSYsM0Hl1oT3yYL9/uRvA2DjviYC+m3TWBXnxSm5o/J8myyxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740149533; c=relaxed/simple;
	bh=jOzG//OB7HazWjzxykobiDHLTtbvup7+jAPb7XO27XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ukge5ldlCUT9p2BkvvLRaZHVN1luLj3y0wRdUvZmHhjGNLb7gyMQRxFmrwZ6Rh8YWnnCph6JE2l3o1lWx/thKMFPKPhIjxAADkM7UJtpqpXt3jmIqZHwfAzunrkncqBR7p65HRkYieKIgQ7J+yUMonvJXYeN6GX7YCOUNfDgRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J86z8Gl9; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-219f8263ae0so46550835ad.0;
        Fri, 21 Feb 2025 06:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740149531; x=1740754331; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YAzrrkv63/2lrOgaumrXtlZ/zBs/xebGmvO88gw3evk=;
        b=J86z8Gl9vwB+IZls7KoB5iCXezK/4RFKRUhY+URJtofQaG45Kfc+UZYBMIdCMYHIuZ
         svOXGK080j8waNMwo1PUzZA9+S4jDQzikmilWKEE8kwSrlwtD3cSeX+j+xX6V+YGkXGX
         c+b9kFl4rViR3v9K1Wa8NmMz+olKPATKsjpgH57NfNHMNZdT8bVyWrdlxa4eQUscWZpM
         hZsmG5eL3wmOnDI54dvsD9mjErzqhxHmLRiFoFlC535zCKYT3O978tVGD9XmWQHs51Wq
         vElJILIWIES0OwAfYnal2Q8IwGjVYbjpisJAstm95MZC/QHRpCPKoFZnTXtii/HjlwNc
         Em7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740149531; x=1740754331;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YAzrrkv63/2lrOgaumrXtlZ/zBs/xebGmvO88gw3evk=;
        b=QgdyhpwqJGJMB6IO+B82ddTDiqkRWnLhWgJ5Nc+oMgR1u/Ua0PdtgkUpr/S2N/SQng
         PCMGF2VMiyyOJ60aLxUAQQdUECKNnTJ7R9NDWK0BzJd/YC/NLfMy7UDlM87fD1dxN9sE
         jlecKLNE3af1pK3Zxi5lNVUi1C/b+y/aol6+4siiydP/WaIikXx2Vmj3Q2sN71NZRS8R
         9yGjZF3v7ahfCmX/oCA8ZB3uDQwwPhNhRV6SUhTwo4IJbXbG2TrbdqmzXrh6rhwcteLG
         I+3KP5zrjcaQCZeRq3BNorB13iM12Nl/sAzXHlX/O0shMI2IB2bifqXUrJpiqoyO3d40
         LhLg==
X-Forwarded-Encrypted: i=1; AJvYcCUpJDvDaQxvEIRMTLrQXX+9CXit7CaaO0+Wq+vKZC7I+2kDQ+f5yw+Bu5fa+/NWDcuhiN993hDIKgATItI/@vger.kernel.org, AJvYcCVl1VJ6nvXMg1WQVeJZh+bqGLWvzMOZx53ZvAvIIxAu7QLYKrpo7WWR6e5XM20QBPexAFnIzamnAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtM51rRSYrLqrArS7x19QHvYE0AfJ/BiK7GSw4ie/jO720QfFr
	VnUhMWqdtZHIzEz9mfFQw/7kgB3O5ADpo0FuSJ/Wc+GbR/ZjVXBi
X-Gm-Gg: ASbGncu8VcmikxM03ttlN2JSSq4ukak38mOVYb4dT/H09RwwPQvfX8dvezUUtNNj1OG
	M4jlXsMAV8CnCv8wLngN2f/x67WGb80Nlh96/7O8pC3YnW4NqpIyvCk+DtxErnNQFCNbSKcvPGL
	bgcHQkK28MKP1VSA0g2ytgHX3NxC/sYVlnvdCKcUZNCMjIilO4cyZCGM0G4Zl5eMLPY/oznQwbg
	+hhl5GnCWD93eEH9TN2ObZLwqEGhvRjy1V68CgO2DMiI+HC15txLkKedEAeHWTWjBmCQKu6qscz
	BoDoIjuOoepISvlVMrPTZE/IewKi4tDcn9VFGkrsyv8Sm0izZcMbVchHrNINK8vEq8k1PVFm+NW
	EIg==
X-Google-Smtp-Source: AGHT+IEZvsIkWYOOtIvyy/40kQht9XU9C7/IBNPS0HQdnJ6W8A3A4E7eI65Q5gRAUjkZzxC4R34WDg==
X-Received: by 2002:a05:6a00:3e0e:b0:730:7600:aeab with SMTP id d2e1a72fcca58-73426ce7678mr4771362b3a.13.1740149530544;
        Fri, 21 Feb 2025 06:52:10 -0800 (PST)
Received: from ?IPV6:2001:ee0:4f4d:ece0:3744:320e:7a6:5279? ([2001:ee0:4f4d:ece0:3744:320e:7a6:5279])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-732511dfd9esm14512998b3a.67.2025.02.21.06.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 06:52:10 -0800 (PST)
Message-ID: <e4be0a96-8e09-4591-96fe-a1d38208875a@gmail.com>
Date: Fri, 21 Feb 2025 21:52:06 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring/io-wq: try to batch multiple free work
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20250221041927.8470-1-minhquangbui99@gmail.com>
 <20250221041927.8470-3-minhquangbui99@gmail.com>
 <f34a5715-fae0-406e-a27b-7e94e3113641@gmail.com>
Content-Language: en-US
From: Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <f34a5715-fae0-406e-a27b-7e94e3113641@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/21/25 19:44, Pavel Begunkov wrote:
> On 2/21/25 04:19, Bui Quang Minh wrote:
>> Currently, in case we don't use IORING_SETUP_DEFER_TASKRUN, when io
>> worker frees work, it needs to add a task work. This creates contention
>> on tctx->task_list. With this commit, io work queues free work on a
>> local list and batch multiple free work in one call when the number of
>> free work in local list exceeds IO_REQ_ALLOC_BATCH.
>
> I see no relation to IO_REQ_ALLOC_BATCH, that should be
> a separate macro.
>
>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>> ---
>>   io_uring/io-wq.c    | 62 +++++++++++++++++++++++++++++++++++++++++++--
>>   io_uring/io-wq.h    |  4 ++-
>>   io_uring/io_uring.c | 23 ++++++++++++++---
>>   io_uring/io_uring.h |  6 ++++-
>>   4 files changed, 87 insertions(+), 8 deletions(-)
>>
>> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
>> index 5d0928f37471..096711707db9 100644
>> --- a/io_uring/io-wq.c
>> +++ b/io_uring/io-wq.c
> ...
>> @@ -601,7 +622,41 @@ static void io_worker_handle_work(struct 
>> io_wq_acct *acct,
>>               wq->do_work(work);
>>               io_assign_current_work(worker, NULL);
>>   -            linked = wq->free_work(work);
>> +            /*
>> +             * All requests in free list must have the same
>> +             * io_ring_ctx.
>> +             */
>> +            if (last_added_ctx && last_added_ctx != req->ctx) {
>> +                flush_req_free_list(&free_list, tail);
>> +                tail = NULL;
>> +                last_added_ctx = NULL;
>> +                free_req = 0;
>> +            }
>> +
>> +            /*
>> +             * Try to batch free work when
>> +             * !IORING_SETUP_DEFER_TASKRUN to reduce contention
>> +             * on tctx->task_list.
>> +             */
>> +            if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>> +                linked = wq->free_work(work, NULL, NULL);
>> +            else
>> +                linked = wq->free_work(work, &free_list, &did_free);
>
> The problem here is that iowq is blocking and hence you lock up resources
> of already completed request for who knows how long. In case of unbound
> requests (see IO_WQ_ACCT_UNBOUND) it's indefinite, and it's absolutely
> cannot be used without some kind of a timer. But even in case of bound
> work, it can be pretty long.
That's a good point, I've overlooked the fact that work handler might 
block indefinitely.
> Maybe, for bound requests it can target N like here, but read jiffies
> in between each request and flush if it has been too long. So in worst
> case the total delay is the last req execution time + DT. But even then
> it feels wrong, especially with filesystems sometimes not even
> honouring NOWAIT.
>
> The question is, why do you force it into the worker pool with the
> IOSQE_ASYNC flag? It's generally not recommended, and the name of the
> flag is confusing as it should've been more like "WORKER_OFFLOAD".


I launched more workers to parallel the work handler, but as you said, 
it seems like an incorrect use case.

However, I think the request free seems heavy, we need to create a task 
work so that we can hold the uring_lock to queue the request to 
ctx->submit_state->compl_reqs. Let me play around more to see if I can 
find an optimization for this.


Sorry for messing up in the previous reply, I've resent the reply for 
better read.

Quang Minh.


