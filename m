Return-Path: <io-uring+bounces-12601-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IPY7MPUSr2nJNQIAu9opvQ
	(envelope-from <io-uring+bounces-12601-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 19:35:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 409B823EA5D
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 19:35:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CFAB4300ECAA
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 18:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8A3346E73;
	Mon,  9 Mar 2026 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Nulg7Ba1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1191934A3D6
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 18:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773081331; cv=none; b=Own6PT6rUxpuCfGCWXb2QGXP1apE9f57OT5u1RDEhhQifuVq4W4NsF66oSifQxPc8iz/11roSPrl4pnrAtSN/MHepAn73/vIBGR3ZN8xs7zw5LYIjOu15HeyjYnfqHWQO9T3+FHROoQ2ya/jSt1d20MvBfeDmmWtx9TPxWjHAf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773081331; c=relaxed/simple;
	bh=HAN3N6jeQKDjvIZ167FIiA6G4mXhi/oV957GutIJIjc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XiF80p9PaDTdAEfqCq3h5xVMQHh3CqL7yagD35I9UoVV8pTgHNQBE3d4Eg7yJVM7wbhWcfW4qEQikZLvZNmTibvndNFK4fKQ7L48kwSDW2mLbjJgruwhOHqeiPBqkXoVwmq1zcR/v3NLJNG7hF/pBlVP/e3n7/2RLg7VxzeCKi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Nulg7Ba1; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-67bb5e4d06eso383324eaf.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 11:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773081329; x=1773686129; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lKMylyAsrLYWjOb2qPL+ddu+jKkQFh6OKHeWnc+vyrg=;
        b=Nulg7Ba1JH7K5Lgv9/KTUWv1eWvkL6O1Ck0GVbXwhML6FwNKa2BSp79pV6EG3ZcXsl
         SWTU+hXDsYynj05Lvs2TPwF9/JyXUfod4iLmaGUgTE0nj64aNNXaFBr1ZLCkr3lyyf1N
         EreI+1RnmAKfiZA4J832CleGuXZVJZyyBFE8mVwtAIDtGyQIqIlxx5cnqsdyTMxshuJV
         ypy6zJ6RFdV0u2aw8bvc4wTEifrW0GgXmCV0kUE4Z6FveZAaIcrFi5aPAV/N2oeTXjRK
         fU12JHxqvwalhkmniZEBpS2+jo8SjQ/RrYfy9w/tx1TMwTLajZ0CwM76O9vqZUg2bCii
         tthQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773081329; x=1773686129;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lKMylyAsrLYWjOb2qPL+ddu+jKkQFh6OKHeWnc+vyrg=;
        b=Qvzr8M3IIS7F2Ex/FsvE8hKAJje8yc7UHAEof5ExhFQT/b3rdRA48tqBCexcUlwIUz
         4KFq1F0PBS+MsnQ52KyP7kS2svwvYRFuuGgI2dnOKFkNxfKytL5hiQeKwNshoZ+n+tKT
         xNVa1p2OM6akYSFlfqABy/ukYM0Dy9+iPZltnRVcYoMDAmnikgO2FK0hpMl3sPd+r3/Y
         8EkhL0Jlx/rmHwShc+vB48kz5iCNYyvOR+IhvoGKuKcX36LKGj/KduwvEdCsjripaAG7
         MMH9iODVyT8xFE4fTFooasKFr+ekVz7YZckhy7NPdkqSWJCcbIXTsz/5krNuUGnkcly8
         iY9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8ygk1QgVQyY/FjZgara14LLOF5QQW0w9II9pTS9G/ASGXXX0m783SDV5DTJ684SiGGtgyKrz9ng==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiAwExAF70nsmMJP0XINFkRePltM8rPiOe8pgma7wmkEEDsrYO
	nwDo4b+44TvztmrJg0iEx43/NoLk0PFFfnKjkFh6YzM4s2/cSUPb64Vo1gGlpE5xNI8liMSYmaQ
	nLrgA+9s=
X-Gm-Gg: ATEYQzyPKivN0mWZPNl4NtiuAnXqxyI8hB9OY0SRSgKPC/9NSIrEQF/lcE4KmpfQdv7
	PaDbAJi5Oxe5tsGlurYCIudzYxXYglKE3TC6HB+AgRUP6rhuDr1tdn3gLOKHXL7/0fa+txNk1Dr
	kxwDsW5GgEu/MyXs9DZPcCs/mfQbzkP8QgS79zFgXMiVpaqaDuGF5TpIfsn80HOwoqFZOsKTR0t
	30olh3WiiyC90bTF7hz/Rg2XG8YXUPlcgxL2s5yV45CKa79AKeUKBSyak035R1fHNdftbg3ANZE
	SgOX7MnWoCQx0bj6ooz8J22iF15o1cJe5ayUSjc9ajM0OENZvD7g94kVlNvL18fYOfF4NXT3Ppl
	Ex/F3NI3t8ibY72Vce9eTTB7VeCk14AwBDmv1iiTkUqzw5l5WXcBWH5p0ztEFGfM7IgCxssIQHz
	YDUeYVxNjrWbrZEOlrpi6rOu6+m2fvdijMpvjzlVfMOCPIReYQu6S2oFG6If4O+phip4lOeaa1S
	JJBT/DaSw==
X-Received: by 2002:a05:6820:308a:b0:67b:b4b3:8217 with SMTP id 006d021491bc7-67bb4b3865emr2556641eaf.50.1773081328961;
        Mon, 09 Mar 2026 11:35:28 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67ba777c53fsm4617159eaf.6.2026.03.09.11.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 11:35:28 -0700 (PDT)
Message-ID: <e9a7152d-3be9-44c2-8626-75ca9da7d408@kernel.dk>
Date: Mon, 9 Mar 2026 12:35:27 -0600
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
 <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
Content-Language: en-US
In-Reply-To: <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 409B823EA5D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12601-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 12:34 PM, Jens Axboe wrote:
> How about something like this? I don't particularly like using ->flags
> for this, as these are otherwise static after the ring has been set up.
> Hence it'd be better to to just use a separate value for this,
> ->in_resize, and use smp_load_acquire/release. The write side can be as
> expensive as we want it to be, as it's not a hot path at all. And the
> acquire read should light weight enough here.

_actual_ patch, doesn't help if we don't kill the manual atomic_or()...


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
index 1ee2b8ab07c8..3414cb27879a 100644
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
@@ -206,8 +213,7 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	 */
 
 	if (!head) {
-		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+		io_mark_taskrun(ctx);
 		if (ctx->has_evfd)
 			io_eventfd_signal(ctx, false);
 	}
@@ -231,8 +237,7 @@ void io_req_normal_work_add(struct io_kiocb *req)
 	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
 
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+	io_mark_taskrun(ctx);
 
 	/* SQPOLL doesn't need the task_work added, it'll run it itself */
 	if (ctx->flags & IORING_SETUP_SQPOLL) {

-- 
Jens Axboe

