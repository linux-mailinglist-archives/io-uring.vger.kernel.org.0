Return-Path: <io-uring+bounces-6596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 578EEA3F4A0
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 13:44:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73253188698D
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 12:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C408C206F10;
	Fri, 21 Feb 2025 12:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAr3127B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C11EB1B9;
	Fri, 21 Feb 2025 12:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740141841; cv=none; b=RaHogCWr9isZYSr5IwFjZeKaGhHikaJ4x3oAOIcI6ETBDVrzqD1t4e2b3uX2vmRN6UFyGn4yiShML1AFI2ER/V+Kp1ah1F9gYC2sQ0sZmKjH2pjlZpo1qx/5xMwV/KOK8C7oYDQs5WAPG39Ud+S/F+L0QMY+twdm0ZgmuYPdSs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740141841; c=relaxed/simple;
	bh=wmWMEkUQsIN9xt9G63zu5Ck8F9Gc1CKSw0ZPTAdHg6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eovJCcTQtNJjnw+a2MWkHKYlZtebYTd1AveI96EfKJJ3JS2AQBaenXpG8DdyryfBSZnCx0Tx1bWkOIRP+wKnZ28YogNJ1+aWwFKWaHTFo530ex1WnKe0MQS7seSRZW4mpyy989dVwiDacZ+5UuacgHm88L1b61HK5JRkwGjYhr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAr3127B; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e0939c6456so3542437a12.3;
        Fri, 21 Feb 2025 04:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740141838; x=1740746638; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IMjHdrCwSch3uFM/ndaNKWEDQtMF6jOGpIMYbHevwA4=;
        b=RAr3127B7B98W+ory7cPUQUEAhm3AJvxS4ma+6QPO3Rnb55yIEcBrgynleJQ62HFH5
         9lgAHSmkCdVOr3YFYMFQQ0niqDRqRl3oJQIHy68BDBkDSAar4v2CZ61IJxsX65TfOtm4
         RDRMcotozicf/lFTSQrvj5XLasOxIJRS+e9V5a5cWa55N5OOS8XdslQS3E+ZxUd7o/bg
         de47C6r8zBH5SKAgxmiXkK7yudO5SbIWZ5AUXya6YN+NrCkLa87/OUTjL8hvdPlNVAPI
         EyFZcr0E7OliBYHMhmTGNTLs3gNFyzk8tlogcoLZigqL0OVt9DRHu8kKwWvFEpfvLXH+
         KI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740141838; x=1740746638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMjHdrCwSch3uFM/ndaNKWEDQtMF6jOGpIMYbHevwA4=;
        b=cm5u87D8i73825eFqwsFCwd/kZP3yLCLd0ZjFqfv6eCYOalpWyAvWJdKbRi67rulfH
         Z+c7i1UGTa7fqOA+QsJlvVJCnNJYrqppmyRny56jDNoPnaBzMlPOIWNbSh164iS+D3/b
         JIqpahGtFpq7XbVpRTNFffobr4yq2E82Be529rDtXluODbIRzSHQPtCKOTXvCS7C432y
         T+Ps9043bU7KsqCByYbOjT2Wp/iXbzx+StJARsDyy2pOA94BOOsAmjJd3PfUQ6/vYyTn
         GOmb5rdNfUh7Pz0XOBNoiXYMn/2CB+jiyEtFRUp+WoPiP6C9K/5MxEotC3SkOYIihdIS
         ipiw==
X-Forwarded-Encrypted: i=1; AJvYcCVr27UM8WDaNwTYEK+ledxg5wE0SyhAjSHzuT0AFR4rhC2QkzeyoSq1iuCRqktGQYOciNr5ZrqI7p32WQLK@vger.kernel.org, AJvYcCX+VS0SYfz+ZsmumX8pbi3hjFs+FPJgwEZqZOEqZwlUk3DAC92VxQ/bn1WC38RL3BEmbYAeKSVcwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVNQ9U9MSbBMCFFWDVEE6WTlqS0wdOtCyyl24RJS7495mCz6mM
	5YgX4t0rNAMP1iJZMPUgG/cvKRQplq1jpwws7XtLgmgvjCGQEC/G
X-Gm-Gg: ASbGncu4LLA/tP2Q/COLqxpG/y1KUkWftQQ5thA4il+g+8hKR2Zyo1dFdGSQcBP42uX
	jpdaDIqvKhxKp+LLWfxaTOMNj8/uZU7LbRotfQnxOyF7KoZ2X7vlFhsfvb2pdqqwoM+sYF4aoxP
	777G/Tk1ZAWT0z6tRkAtYb26OJdKckJ0RyLLzI6ffBODWwA1sS7QnwfEtKZ/mx1MAyle1AGsb+c
	ADYFjCJwpPhg+5azBNGqUWILe/RQtb/UDslVpFngy8SRehGi5kE4DooNpS//XBhoFfjgBt6EV2n
	Jqv/N+xjbbjzlH8ZQVfNuGiFOOo0Z4LkfZdfUodaWojA27dFby5OCb92e/g=
X-Google-Smtp-Source: AGHT+IFbaYWhRzjbYrAdv9qAXrhVxfnFuLzms4maTy0ghrTeCosRsEZiE+yFyoA8M/D47q59BGTs0w==
X-Received: by 2002:a17:906:6a02:b0:ab7:b9b5:60e7 with SMTP id a640c23a62f3a-abc0de0dfbfmr235736566b.40.1740141838285;
        Fri, 21 Feb 2025 04:43:58 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5e88])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abbbeff2a4dsm691170966b.103.2025.02.21.04.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 04:43:57 -0800 (PST)
Message-ID: <f34a5715-fae0-406e-a27b-7e94e3113641@gmail.com>
Date: Fri, 21 Feb 2025 12:44:56 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring/io-wq: try to batch multiple free work
To: Bui Quang Minh <minhquangbui99@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20250221041927.8470-1-minhquangbui99@gmail.com>
 <20250221041927.8470-3-minhquangbui99@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250221041927.8470-3-minhquangbui99@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 04:19, Bui Quang Minh wrote:
> Currently, in case we don't use IORING_SETUP_DEFER_TASKRUN, when io
> worker frees work, it needs to add a task work. This creates contention
> on tctx->task_list. With this commit, io work queues free work on a
> local list and batch multiple free work in one call when the number of
> free work in local list exceeds IO_REQ_ALLOC_BATCH.

I see no relation to IO_REQ_ALLOC_BATCH, that should be
a separate macro.

> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
> ---
>   io_uring/io-wq.c    | 62 +++++++++++++++++++++++++++++++++++++++++++--
>   io_uring/io-wq.h    |  4 ++-
>   io_uring/io_uring.c | 23 ++++++++++++++---
>   io_uring/io_uring.h |  6 ++++-
>   4 files changed, 87 insertions(+), 8 deletions(-)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 5d0928f37471..096711707db9 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
...
> @@ -601,7 +622,41 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
>   			wq->do_work(work);
>   			io_assign_current_work(worker, NULL);
>   
> -			linked = wq->free_work(work);
> +			/*
> +			 * All requests in free list must have the same
> +			 * io_ring_ctx.
> +			 */
> +			if (last_added_ctx && last_added_ctx != req->ctx) {
> +				flush_req_free_list(&free_list, tail);
> +				tail = NULL;
> +				last_added_ctx = NULL;
> +				free_req = 0;
> +			}
> +
> +			/*
> +			 * Try to batch free work when
> +			 * !IORING_SETUP_DEFER_TASKRUN to reduce contention
> +			 * on tctx->task_list.
> +			 */
> +			if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +				linked = wq->free_work(work, NULL, NULL);
> +			else
> +				linked = wq->free_work(work, &free_list, &did_free);

The problem here is that iowq is blocking and hence you lock up resources
of already completed request for who knows how long. In case of unbound
requests (see IO_WQ_ACCT_UNBOUND) it's indefinite, and it's absolutely
cannot be used without some kind of a timer. But even in case of bound
work, it can be pretty long.

Maybe, for bound requests it can target N like here, but read jiffies
in between each request and flush if it has been too long. So in worst
case the total delay is the last req execution time + DT. But even then
it feels wrong, especially with filesystems sometimes not even
honouring NOWAIT.

The question is, why do you force it into the worker pool with the
IOSQE_ASYNC flag? It's generally not recommended, and the name of the
flag is confusing as it should've been more like "WORKER_OFFLOAD".

> +
> +			if (did_free) {
> +				if (!tail)
> +					tail = free_list.first;
> +
> +				last_added_ctx = req->ctx;
> +				free_req++;
> +				if (free_req == IO_REQ_ALLOC_BATCH) {
> +					flush_req_free_list(&free_list, tail);
> +					tail = NULL;
> +					last_added_ctx = NULL;
> +					free_req = 0;
> +				}
> +			}
> +
>   			work = next_hashed;
>   			if (!work && linked && !io_wq_is_hashed(linked)) {
>   				work = linked;
> @@ -626,6 +681,9 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
>   			break;
>   		raw_spin_lock(&acct->lock);
>   	} while (1);
> +
> +	if (free_list.first)
> +		flush_req_free_list(&free_list, tail);
>   }
>   
...

-- 
Pavel Begunkov


