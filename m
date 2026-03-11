Return-Path: <io-uring+bounces-12633-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AP8LmxOsWlCtAIAu9opvQ
	(envelope-from <io-uring+bounces-12633-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 12:13:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E613262CB4
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 12:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8B06730439F9
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 11:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D643D891F;
	Wed, 11 Mar 2026 11:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjJ1hyo8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB073D8919
	for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 11:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773227611; cv=none; b=X53lXqr+ND+D3Bo/hWxbZr5We3pdFE8wMC3mqSPk1/X4FP9Yes4EcuDigyoFqy58NSUwQDNl3zrfTG9WVmSIIFU/Oh6wMQF3XHpGWWP+ACo8/pJRT+YSCwpsTS3etE8caofL5b+jedwB5pe9oseaPMoNZtn7Oc0OZqQlsZXrk0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773227611; c=relaxed/simple;
	bh=4lX+kBPGqJ3QkimSYJuNi93y7EH2IixXEvvpadxc03o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WGi1umf8QUC8gXrKm30iLZzh/2KPgFQC8a0v9nT3oKcOnU0g9sFO8t/3jezKcVbU2hESjDLd88xcXeD62UG4TgpZhnraF5yBC73+U2GmEA88M8UCkXpOU8GpDsbl4KxjXfGYxZM/wM+UOGq0HGId26I6xJ7MtTOPjJeoiGoSR90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjJ1hyo8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so43433335e9.2
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 04:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773227603; x=1773832403; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qnfnqQA087ph9rwVER4jOdXVQrVQv1Zi9ON3TBE4BwA=;
        b=OjJ1hyo8Y5G/h08jF6fcpkZ/oUtq73oQ2VePvyE0nB61vPEBr/OxPycmCrWe8Qf8M/
         RpJvLNph+gVHFZ72lnvHFj5wQiJMudZkGFiuvXe9It7U6H6+czYawu4BalY8qOsRFHPG
         POeWRyvDR8uaqK7MpsFeZNFWLPFzqcdqaKYKMn5unOcp1RLdz9jeCqHjxo7aGcZzY018
         wtLsIOaL4CZX/P14wspHteJV3ZEmBVpstKsl7W+O50RefN0dvwRtlk/RHvKh/ihpQeaI
         oYH2pyW36OKypvh+SWOemCmLzyEPj6qhN29+q0P1Uo3R9SS4FbvPylZjMWE9eVuNPW1h
         ASfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773227603; x=1773832403;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qnfnqQA087ph9rwVER4jOdXVQrVQv1Zi9ON3TBE4BwA=;
        b=DDSni7WHgXwCQaGKRrnl9zphnXVwpDBJy4/+lCo8rxn41zeBH5IvwX/bzwxeOQZNFe
         JciSXsK4/tlvO5lF6pvBUVPqKjvWVJfQuaHEoWsaUuPrwTitZUXGFQPdLVT0WXp3vnkI
         ++VgLe1AGb/z8X8ZeUjI9xv22NllpK9tEg1TnYbiFmdAPplFWcoY96vttYB+DvUvBktP
         pBS87s9TOKPViCPpnFkutY6WhuEYuGg0IpqaJo1c6nFQDZDIYfVrPUQYRbLny2K39/Lb
         2jfXX1kjD0cteSsjG+bPQf7ErMJLAcniKXUyN92GGICJIG1BYlbQQMqoLO9DreYHtP1B
         BTWg==
X-Forwarded-Encrypted: i=1; AJvYcCUK2zjBBWPDCuJRquCtqH9lzOMaiZFvQTzSq5euLdRHNERf/fYMnn8Cp4RxRDHpLJF3ZrQFO+dWEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxruXbaXoz58OjhCQ/a3pgazedIiGZIROPk9dyUPrXrIjuEFQ7
	mVl2tW6KdTIBI789QwxtGbHEndZOPrahuQ56w0JpYgdwCcEmFbJl4igzKfhW4A==
X-Gm-Gg: ATEYQzw4sJn5Qg6uZ9PmIGbF+q/2ePF1SfIVNMQgae8IrOnYXrK5upcLEh3e+7XymES
	z1NxlXqHBaEbs6tHmAMWMC6Kyccbqd74xzLa5xP/3X6ZU9FgHggacwP21S1b5kXcp/IVUvcssDn
	5PQeh1ss0yZaqCTt/g+Y41m90/Be3I3htVME9tvPwsExGq95NCwHQ3sUe0xSSKxEKm89PYdsL1X
	FXHWg3IHFUVYN+ylfS0soCPO80q7JnFTB3WLubD46n11fiFaXmaFNby5mIda9RLJxWma99dxAYi
	LiMtaI1K3j5pyLmmTdHxto7wmqEhwqyTrvbiYrzJiDMQCYkKJSiTbK6mksaoMNcz9t6bGKMFAcb
	Br8dHp5JLGgkwxYCZZVyTxZ9yCU6hVXG4fIOUEsv7dPt33EShAPXtIWnTiN+awt7A+kJ6B+ZkMk
	zh1dCPpep//UV5AL6YNPyYKNYLzsTo4rP132+Dc0D/HWoBfkessNWuJ9qyu/UGaMQgflnO/1blY
	n++2xvNXxDbZA1tml1yFkv+skNeWGEoOf++2j64CKC2uza2ItAGSWEiew==
X-Received: by 2002:a05:600c:154d:b0:485:3983:aba2 with SMTP id 5b1f17b1804b1-4854b109d15mr35244795e9.23.1773227603058;
        Wed, 11 Mar 2026 04:13:23 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:bf9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854e67e8d6sm2339475e9.1.2026.03.11.04.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 04:13:22 -0700 (PDT)
Message-ID: <39d1678f-7a7e-43d5-a92d-0b26b9bfd44e@gmail.com>
Date: Wed, 11 Mar 2026 11:13:20 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: ensure ctx->rings is stable for task work
 flags manipulation
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: naup96721@gmail.com, stable@vger.kernel.org
References: <20260310145521.68268-1-axboe@kernel.dk>
 <20260310145521.68268-2-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260310145521.68268-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0E613262CB4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12633-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/10/26 14:45, Jens Axboe wrote:
> If DEFER_TASKRUN | SETUP_TASKRUN is used and task work is added while
> the ring is being resized, it's possible for the OR'ing of
> IORING_SQ_TASKRUN to happen in the small window of swapping into the
> new rings and the old rings being freed.
> 
> Prevent this by adding a 2nd ->rings pointer, ->rings_rcu, which is
> protected by RCU. The task work flags manipulation is inside RCU
> already, and if the resize ring freeing is done post an RCU synchronize,
> then there's no need to add locking to the fast path of task work
> additions.
> 
> Note: this is only done for DEFER_TASKRUN, as that's the only setup mode
> that supports ring resizing. If this ever changes, then they too need to
> use the io_ctx_mark_taskrun() helper.
> 
> Link: https://lore.kernel.org/io-uring/20260309062759.482210-1-naup96721@gmail.com/
> Cc: stable@vger.kernel.org
> Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
> Reported-by: Hao-Yu Yang <naup96721@gmail.com>
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/io_uring_types.h |  1 +
>   io_uring/io_uring.c            |  2 ++
>   io_uring/register.c            | 20 ++++++++++++++++++--
>   io_uring/tw.c                  | 24 ++++++++++++++++++++++--
>   4 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 3e4a82a6f817..dd1420bfcb73 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -388,6 +388,7 @@ struct io_ring_ctx {
>   	 * regularly bounce b/w CPUs.
>   	 */
>   	struct {
> +		struct io_rings	__rcu	*rings_rcu;
>   		struct llist_head	work_llist;
>   		struct llist_head	retry_llist;
>   		unsigned long		check_cq;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ccab8562d273..20fdc442e014 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2066,6 +2066,7 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>   	io_free_region(ctx->user, &ctx->sq_region);
>   	io_free_region(ctx->user, &ctx->ring_region);
>   	ctx->rings = NULL;
> +	RCU_INIT_POINTER(ctx->rings_rcu, NULL);
>   	ctx->sq_sqes = NULL;
>   }
>   
> @@ -2703,6 +2704,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>   	if (ret)
>   		return ret;
>   	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
> +	rcu_assign_pointer(ctx->rings_rcu, rings);
>   	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
>   		ctx->sq_array = (u32 *)((char *)rings + rl->sq_array_offset);
>   
> diff --git a/io_uring/register.c b/io_uring/register.c
> index a839b22fd392..5f2985ba0879 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -487,6 +487,18 @@ static void io_register_free_rings(struct io_ring_ctx *ctx,
>   			 IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP | \
>   			 IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED)
>   
> +static void io_resize_assign_rings(struct io_ring_ctx *ctx, struct io_rings *rings)
> +{
> +	/*
> +	 * Just mark any flag we may have missed and that the application
> +	 * should act on unconditionally. Worst case it'll be an extra
> +	 * syscall.
> +	 */
> +	atomic_or(IORING_SQ_TASKRUN | IORING_SQ_NEED_WAKEUP, &rings->sq_flags);
> +	ctx->rings = rings;
> +	rcu_assign_pointer(ctx->rings_rcu, rings);
> +}
> +
>   static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>   {
>   	struct io_ctx_config config;
> @@ -579,6 +591,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>   	spin_lock(&ctx->completion_lock);
>   	o.rings = ctx->rings;
>   	ctx->rings = NULL;
> +	RCU_INIT_POINTER(ctx->rings_rcu, NULL);
>   	o.sq_sqes = ctx->sq_sqes;
>   	ctx->sq_sqes = NULL;

Should be better to not have a transient null, and then there
is no need to check for that in task_work. I.e. don't zero it
and only assign the new value if you successfully created a
new set of rings.

-- 
Pavel Begunkov


