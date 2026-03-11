Return-Path: <io-uring+bounces-12636-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YNPoFRZqsWnsugIAu9opvQ
	(envelope-from <io-uring+bounces-12636-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:11:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B072326433C
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E1BD31E92D1
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 13:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E0D2F4A14;
	Wed, 11 Mar 2026 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g2wm+sPO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E4F285CA2
	for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 13:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234356; cv=none; b=b29TTcnUhLSMYN82WvYswMNlB0OMjL2rRQGKwFXI3jEyjhe6ZjBMnaLbiRbr7NUUQb+rvVQ6cEAbQs+Hh/rUdrYKGStdNqMFfNx5+RkuvRmveZIC9FjzboWkjSYmeLAhnMFCNsTlXT+hwNLRGPkk9zVt1iJQTwbngYUCMvvDX0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234356; c=relaxed/simple;
	bh=bJi3SD4Mwyy2yZWRzO1pVERGmTmxO5jP67fzbHbAobU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=HeeIt98ylU3DCR6WtAC+6cNHosC4HZ5isMgXMeMG5Ht7bqC65sXQuv65+JRVlA8FTpYir0VviNbLJZxs43wAZQCz2zt4zMika/mGFafTRGJaO+3FzGXPVwAuCb0qRei14GMkeAV1gNuBJUBS4TDkUrZkEWHYiAmK2BtfgIx6w4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g2wm+sPO; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d773a4af0aso29489a34.0
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 06:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773234354; x=1773839154; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bjVugnZuCfuGXRjgoZH8YMIj4TwEFnE+7fLVanx/ETY=;
        b=g2wm+sPOvKFGdkPnLKMywnODadlKb9+8NKCiJcqvu1E88tUGU24+WECdDKAj/9V9GT
         tYQ+VqT8qjsNRVCzAHH84WeH2BOkwugyZE3emfrSLig7TViMx6q0MyiIFd27CJea5GuD
         YkRMaCqsvAIGN8pYol/gkhHTYkVpllz9bnMAp/GF5QavLE9YQgzPVG4sqwg7SWdEzyf2
         FGqkWIAqIJoIOfduwFh46fO19wv4ZVfCLWpZaad/IDatgvboRlo3aOSaoWYf5UMJ3e/R
         LRCeqdzpjNteWDs4GvVQ/1JyLD1jfUzkySYrPmzSIUBNXTKLWK84xt0gTGEGIaYt1EYV
         J0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773234354; x=1773839154;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bjVugnZuCfuGXRjgoZH8YMIj4TwEFnE+7fLVanx/ETY=;
        b=ELByE3mx6zZzXyfncZO8Pgu2PLalq0541BWDf4kqqoUrdl3YhW/WQXEYgAI/F1h2MA
         tpf8UIo34mM+VbngpRK9l2kcF9LrSvzOD3sJaRtVQcJEnres42raAnrVBkRaNt6mEwDo
         TdS4i8cbkHmldqESsTxJ0Z2JemOBG5oycKzG4MCRboJi4ITxaxEdWPNvSJMW/uDqCaGv
         ZwqVZFl/RlDEhbMdRgBTrlmTzu3aPlyCQIBJzK3ZRAvbre/t3mRbzCS6gXhpf3ile2Pg
         O78vVxhCxjXyWI2ny5z8iafHe5jq7M/fjNTuHo3zTcQL6C9TGsQAMaNdX6KTKZYXQJeN
         xJSg==
X-Forwarded-Encrypted: i=1; AJvYcCXFZvqPBDgtAVG6P+WWgDGocG09rE/eBWPoEBWk7ksxBk8/vURLBDjhFMpSt2uldRz4LfBwuaLyEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFADaDb1Oz7ZELN1tqCnavUVqMIu+cRPpbu+FpDRZpkLTVx2ZT
	OeOM1E0KluL1ahfPnB1vI0DOo2UeBJunMJ9Xm5dIllvoUbZ4hFl1zYXzccB9SWYgEoA=
X-Gm-Gg: ATEYQzx9Abrr1kBpVcL8LLAUnoXH0zS86TdmDfq6UaZUhnmVWQPDd6JomePWpeq6/LR
	uNwwAOjh2//DiuOuMpJOFfz7h/mUUellpCnDoGzJ6o9tnQCGQuVPxBaQlTx9Q7F0HnFAAjJ29hf
	0Aiz9PwWKuqcwjycfFgHQy7eZfFCNPpa9wQa7Pkb+HwmkzQODjGIkkcS+0AiKKaPb8xxp52IcYQ
	axKWsyu2fryhPMhOMX+kIeUMxI737SN9f4AHivLFPFpKUp+4g95AxzdT6uMYJHFF3ggMCRdSRV8
	qq7DPqsZJa63s3WV2oJcpuc1n+7XKIHhr4aEgAqOWYsgKF+t9R8jUlk62vf/fuQBOj0ciGs6QM9
	7eeJyJ8oO3r5YHh6wnhcov5whUCw+AXh3fvIGDMUkkk0oWu0sNS2Z63wzMTMBZbOQmc2DtHg+Fr
	cfaNZoPZin34l6Dvp3b8HMpk/ybvxr0Y0L+DNjkh54u50b8bqPqFf4SSEFv6uFmDtRD7L54/vun
	tS64Z2+WA==
X-Received: by 2002:a05:6830:4c08:b0:7d5:13eb:6010 with SMTP id 46e09a7af769-7d76a84cb2emr1579534a34.33.1773234353694;
        Wed, 11 Mar 2026 06:05:53 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae68a4bsm1812449a34.19.2026.03.11.06.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:05:52 -0700 (PDT)
Message-ID: <b50163ce-bb1c-48e4-9a32-037b26c50161@kernel.dk>
Date: Wed, 11 Mar 2026 07:05:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] io_uring: ensure ctx->rings is stable for task work
 flags manipulation
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: naup96721@gmail.com, stable@vger.kernel.org
References: <20260310145521.68268-1-axboe@kernel.dk>
 <20260310145521.68268-2-axboe@kernel.dk>
 <39d1678f-7a7e-43d5-a92d-0b26b9bfd44e@gmail.com>
Content-Language: en-US
In-Reply-To: <39d1678f-7a7e-43d5-a92d-0b26b9bfd44e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B072326433C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12636-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/11/26 5:13 AM, Pavel Begunkov wrote:
> On 3/10/26 14:45, Jens Axboe wrote:
>> If DEFER_TASKRUN | SETUP_TASKRUN is used and task work is added while
>> the ring is being resized, it's possible for the OR'ing of
>> IORING_SQ_TASKRUN to happen in the small window of swapping into the
>> new rings and the old rings being freed.
>>
>> Prevent this by adding a 2nd ->rings pointer, ->rings_rcu, which is
>> protected by RCU. The task work flags manipulation is inside RCU
>> already, and if the resize ring freeing is done post an RCU synchronize,
>> then there's no need to add locking to the fast path of task work
>> additions.
>>
>> Note: this is only done for DEFER_TASKRUN, as that's the only setup mode
>> that supports ring resizing. If this ever changes, then they too need to
>> use the io_ctx_mark_taskrun() helper.
>>
>> Link: https://lore.kernel.org/io-uring/20260309062759.482210-1-naup96721@gmail.com/
>> Cc: stable@vger.kernel.org
>> Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
>> Reported-by: Hao-Yu Yang <naup96721@gmail.com>
>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   include/linux/io_uring_types.h |  1 +
>>   io_uring/io_uring.c            |  2 ++
>>   io_uring/register.c            | 20 ++++++++++++++++++--
>>   io_uring/tw.c                  | 24 ++++++++++++++++++++++--
>>   4 files changed, 43 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 3e4a82a6f817..dd1420bfcb73 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -388,6 +388,7 @@ struct io_ring_ctx {
>>        * regularly bounce b/w CPUs.
>>        */
>>       struct {
>> +        struct io_rings    __rcu    *rings_rcu;
>>           struct llist_head    work_llist;
>>           struct llist_head    retry_llist;
>>           unsigned long        check_cq;
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index ccab8562d273..20fdc442e014 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2066,6 +2066,7 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>>       io_free_region(ctx->user, &ctx->sq_region);
>>       io_free_region(ctx->user, &ctx->ring_region);
>>       ctx->rings = NULL;
>> +    RCU_INIT_POINTER(ctx->rings_rcu, NULL);
>>       ctx->sq_sqes = NULL;
>>   }
>>   @@ -2703,6 +2704,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>       if (ret)
>>           return ret;
>>       ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
>> +    rcu_assign_pointer(ctx->rings_rcu, rings);
>>       if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
>>           ctx->sq_array = (u32 *)((char *)rings + rl->sq_array_offset);
>>   diff --git a/io_uring/register.c b/io_uring/register.c
>> index a839b22fd392..5f2985ba0879 100644
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -487,6 +487,18 @@ static void io_register_free_rings(struct io_ring_ctx *ctx,
>>                IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP | \
>>                IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED)
>>   +static void io_resize_assign_rings(struct io_ring_ctx *ctx, struct io_rings *rings)
>> +{
>> +    /*
>> +     * Just mark any flag we may have missed and that the application
>> +     * should act on unconditionally. Worst case it'll be an extra
>> +     * syscall.
>> +     */
>> +    atomic_or(IORING_SQ_TASKRUN | IORING_SQ_NEED_WAKEUP, &rings->sq_flags);
>> +    ctx->rings = rings;
>> +    rcu_assign_pointer(ctx->rings_rcu, rings);
>> +}
>> +
>>   static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>>   {
>>       struct io_ctx_config config;
>> @@ -579,6 +591,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>>       spin_lock(&ctx->completion_lock);
>>       o.rings = ctx->rings;
>>       ctx->rings = NULL;
>> +    RCU_INIT_POINTER(ctx->rings_rcu, NULL);
>>       o.sq_sqes = ctx->sq_sqes;
>>       ctx->sq_sqes = NULL;
> 
> Should be better to not have a transient null, and then there
> is no need to check for that in task_work. I.e. don't zero it
> and only assign the new value if you successfully created a
> new set of rings.

That's a good idea, I like that. I'll make the change.

-- 
Jens Axboe


