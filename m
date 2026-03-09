Return-Path: <io-uring+bounces-12600-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QMr4BswSr2nJNQIAu9opvQ
	(envelope-from <io-uring+bounces-12600-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 19:34:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6845623EA2A
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 19:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E1BF300A38F
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 18:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF67734AAEF;
	Mon,  9 Mar 2026 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nJ8KnS2Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B2134B18E
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 18:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773081282; cv=none; b=DnysSbJoVJDgAXByJQMXBc0hnu8eTU/miCzkA6jcxL6ZXp0k8zH+ae8dpUlNpi6hkEumHNjsm1G69YVZyt0RHL/hi0KxhI3a+LVe/L9XebQkl6T5a7j7wsqX24Vsf+KHIBTk+kwqIJvO2QVx4ESmlxy8Vx+O/pflTZa49omOIww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773081282; c=relaxed/simple;
	bh=wLgP88adW/NXfqgFpyUSENvdkIgpvNTlpSOv8bLPNJU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JO1tzzsMForYAWDa0cpKumbVax5fxfrHwjsgJhzaiMJJqDut+4qwWBb5asgLUBMlNgnQTpTsG2STMdHNoWvYL0+4aYAWgGTCUChiMhMfimircdciXQkw07TK3jCCty+Wo9j6c/J/OVagReEF/CoIz3EVPYbn+6kJyQyPgO10w8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nJ8KnS2Z; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d7422b4ff1so690002a34.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 11:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773081278; x=1773686078; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NRbx5017ZY07a0PYKqimSfteOEMGjnJ74HInu2odRm8=;
        b=nJ8KnS2ZxBrWOE8LFFEHZSm0YixgEMWdQ9QhuzWzscpsvmakTk6iNiOz+FZM/oEvDO
         5KDhYvkb56Q62LcbMk80zVd3X479/PtIZJW1zyfKAuXbRKlDSGFJDpjD66OhcLdhkPCC
         SgbwIHwq9VgLIIP0+BaN3r6Bk8VCdUZcvbo+XAqkHcjnY2VvP2QH4mpBgLf6CGVc7jB/
         B7Mj6QvHjHNUBByNhcQ339kkPraLFQEFEdiWah0V4gm7jSpDykp6MWLroIKj4zm34c+v
         tSBJ3cDsS8/I9YhbJy3DQNwol5kXFwgOOIk5IZuHxmAEILJmplu5ZZAi584HR9tUaxDb
         Sekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773081278; x=1773686078;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRbx5017ZY07a0PYKqimSfteOEMGjnJ74HInu2odRm8=;
        b=QfuikoV9mecCeWTK/HOjDXtiEPOsWIh4RuseOz1N0tATLQ1/2LAcZwXsAvDqDesyNB
         ef0Q/FwJpemmTz6my632/Zt/2DHy6AqI3/Zyc7BQnGZ/HF4yw9pfKMqMIF+8xaQKKr7I
         YK9HNk94sHSJRXjB0eQ5o6PDiZQySBvcdhLF0pr3w785YgQBj6C4/WHE5RqtkEMagA+8
         eSDoie63SM69mSVCwf0F1jg0+uSIgjwMrqF5WcYV46ff8H1j1WAxitLvA8Fu0xzNzU0v
         L3eQaHvOUItF8osSXBM1Rn7plH8KYI9UbYDOH2+EoC2Sl2HLa+nJErRoGXoWNiVJRbW3
         HJfw==
X-Forwarded-Encrypted: i=1; AJvYcCWOwhb90t52/aCJ0Gt2UTNQx9uEm1ZfJnYsfkj8VIFta59gUsyx7AmZevNtHTlgR+EUNvRtK5fC5w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo+1MOw6IZdiA6zwgFWhYTW3WT5C3y9PM1rypsCcNoCxxRyN2x
	iXvOfhXWfCXzsrJ2KjDaUrM5bh/pMECJnGezD/rswHuRBH2wALzg2di9y6VDtlThLiQ=
X-Gm-Gg: ATEYQzxrSNQchbDGOqUxCiYuhVof/9Nd9u1Q3aJvuGpKsLq8ZGBK18QYcty5Mk5biKS
	/MnpiX5umZM1STirqeN17HwT3vJ+bKBQM9y60tekDIfHUimx1wSdOqhqEgaZ7nIpIYXEoj47ZM8
	KaMvpwaUXW6Un5KDA/cB6lsUmcGkdnKDVQnxx1g7SBE98IPzJq+nYwrUP/hYREsAkD1xcecKvRz
	SxwKUKgKhKVY7jIuWeqtvMgxA3DlSSE/qVEtP1zTaet4HeDZACZ4STJToPaZmv0aP5AcOBVdShb
	BWHmkZSD9dMn3n+NiewbaeoTl1qgAqrM7Iqe6FuEmS52H9uCHF7LndS5ZS5/DBxixrTdlAvdFa2
	ObF6TPPz5XBOmgIjHgYQhDKOC2K1s2FQR1aUlEQReQsyIwpKScsYmKR+TMl+/xY/UxOTxcizs/7
	3GfuKyC5cTM4Gy0FX2UWIjrCzAO7xuqfGYaRiqMnd2dzDp4Rf+jZR++Q88G0osdXE9CMW+fM/xN
	mzIwUo87Q==
X-Received: by 2002:a05:6830:c0b:b0:7d7:5748:b99f with SMTP id 46e09a7af769-7d75748c60bmr882983a34.4.1773081277603;
        Mon, 09 Mar 2026 11:34:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d745cac199sm3232432a34.9.2026.03.09.11.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 11:34:37 -0700 (PDT)
Message-ID: <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
Date: Mon, 9 Mar 2026 12:34:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in
 io_register_resize_rings
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, security@kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
 <42AD516A-B078-40A5-94EE-80739B9883E7@kernel.dk>
Content-Language: en-US
In-Reply-To: <42AD516A-B078-40A5-94EE-80739B9883E7@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6845623EA2A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12600-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linuxfoundation.org:email,kernel.dk:mid,kernel.dk:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 3/9/26 10:29 AM, Jens Axboe wrote:
> On Mar 9, 2026, at 10:05?AM, Linus Torvalds <torvalds@linuxfoundation.org> wrote:
>>
>> ?On Mon, 9 Mar 2026 at 06:11, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> You probably want something ala:
>>>
>>> mutex_lock(&ctx->mmap_lock);
>>> spin_lock(&ctx->completion_lock();
>>> + local_irq_disable();
>>
>> How could that ever work?
>>
>> Irqs will happily continue on other CPUs, so disabling interrupts is
>> complete nonsense as far as I can tell - whether done with
>> spin_lock_irq() *or* with local_irq_disable()/.
>>
>> So basically, touching ctx->rings from irq context in this section is
>> simply not an option - or the rings pointer just needs to be updated
>> atomically so that it doesn't matter.
>>
>> I assume this was tested in qemu on a single-core setup, so that
>> fundamental mistake was hidden by an irrelevant configuration.
>>
>> Where is the actual oops - for some inexplicable reason that had been
>> edited out, and it only had the call trace leading up toit? Based on
>> the incomplete information and the faulting address of 0x24, I'm
>> *guessing* that it is
>>
>>        if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>>                atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>>
>> in io_req_normal_work_add(), but that may be complete garbage.
>>
>> So the actual fix may be to just make damn sure that
>> IORING_SETUP_TASKRUN_FLAG is *not* set when the rings are resized.
>>
>> But for all I know, (a) I may be looking at entirely the wrong place
>> and (b) there might be millions of other places that want to access
>> ctx->rings, so the above may be the rantings of a crazy old man.
> 
> Nah you?re totally right. I?m operating in few hours of sleep and on a
> plane. I?ll take a closer look later. The flag mask protecting it is a
> good idea, another one could be just a specific irq safe resize lock
> would be better here.

How about something like this? I don't particularly like using ->flags
for this, as these are otherwise static after the ring has been set up.
Hence it'd be better to to just use a separate value for this,
->in_resize, and use smp_load_acquire/release. The write side can be as
expensive as we want it to be, as it's not a hot path at all. And the
acquire read should light weight enough here.


diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3e4a82a6f817..428eb5b2c624 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -394,6 +394,7 @@ struct io_ring_ctx {
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
 		struct wait_queue_head	cq_wait;
+		int			in_resize;
 	} ____cacheline_aligned_in_smp;
 
 	/* timeouts */
diff --git a/io_uring/register.c b/io_uring/register.c
index 3378014e51fb..048a1dcd9df1 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -575,6 +575,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 * ctx->mmap_lock as well. Likewise, hold the completion lock over the
 	 * duration of the actual swap.
 	 */
+	smp_store_release(&ctx->in_resize, 1);
 	mutex_lock(&ctx->mmap_lock);
 	spin_lock(&ctx->completion_lock);
 	o.rings = ctx->rings;
@@ -647,6 +648,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (ctx->sq_data)
 		io_sq_thread_unpark(ctx->sq_data);
 
+	smp_store_release(&ctx->in_resize, 0);
 	return ret;
 }
 
diff --git a/io_uring/tw.c b/io_uring/tw.c
index 1ee2b8ab07c8..c66ffa787ec7 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -152,6 +152,13 @@ void tctx_task_work(struct callback_head *cb)
 	WARN_ON_ONCE(ret);
 }
 
+static void io_mark_taskrun(struct io_ring_ctx *ctx)
+{
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG &&
+	    !smp_load_acquire(&ctx->in_resize))
+		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+}
+
 void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -206,6 +213,7 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	 */
 
 	if (!head) {
+		io_mark_taskrun(ctx);
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
@@ -231,8 +239,7 @@ void io_req_normal_work_add(struct io_kiocb *req)
 	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
 
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+	io_mark_taskrun(ctx);
 
 	/* SQPOLL doesn't need the task_work added, it'll run it itself */
 	if (ctx->flags & IORING_SETUP_SQPOLL) {

-- 
Jens Axboe

