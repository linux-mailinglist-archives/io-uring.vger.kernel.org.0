Return-Path: <io-uring+bounces-13137-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHdGM+KF62lBNwAAu9opvQ
	(envelope-from <io-uring+bounces-13137-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 17:01:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A1046075C
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 17:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D51DB300D1C6
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 15:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B2B282F21;
	Fri, 24 Apr 2026 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="h0/Xpbkt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53E7281369
	for <io-uring@vger.kernel.org>; Fri, 24 Apr 2026 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777042892; cv=none; b=Nv0puypZ2k9EwQr7z3lwbX8flec7sxi6rvzqVgMB/JCsMtbcy5YTQ3Qae7/ErAm3uglxuzxanWdNIAUnWGpLHI4HR1bcj8HFyzS8WTvJQmZufRoPeK20FV79LmrjHdtn9HADcBjz96t+YpKlgyQaDTH14iNb8CuxhbORA09eIyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777042892; c=relaxed/simple;
	bh=95pmgBqwTgonbJx1H1y61s34Ff9WuCkh1QAiVfqFiU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=luOE8J1QTWzWFXmc2IElHfwVhVQRXsVRw4u82dXZ9NOz6yEqaNL47EJw9F0dq7KifSojLEbS9y86x8iU2HaqVwhtw1SDqqDcy3SOLKfwDXP+8nENBWzseZa+Z71SurAqWL6/2mebIM9e2GXM3QRTR1aQysrB2AY3R+uieqTv5HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=h0/Xpbkt; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7de46b8e432so2102406a34.1
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2026 08:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777042888; x=1777647688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ANydeqCoJJCplUkBB/t0jJL0nnM7MZ1/879z0nRmZJU=;
        b=h0/XpbktgqDjfF+z9/EH2J/w40Lcm7U76qE9WpZnHRX+esp7yQjNrxkBzlpR/NtNWw
         2htDe8PP5pK5VaQFjL53new49QziTgmXF8fqGFU306wmUoIwxdrnKDdyGmf6kO2sB+W+
         poyXDabRjI1awu6HSLBUHn+1sfpGlKL054Z+7oB9B1D9Fw02cN4kXm+Mcgacoeb4O+AO
         OQ+jyL+cKxSjX03ZulcMHIUz6r0D1/WV2TtTaXtaDAUxV+LrJJloHtQHCrJfA4oaqiN6
         CNQpTWAL0iLoYARwpkSIcnRi1rX9ZLDSu3DYCIEjmDgxm0WfXLGheTM6xJejvJbesKf3
         opHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777042888; x=1777647688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ANydeqCoJJCplUkBB/t0jJL0nnM7MZ1/879z0nRmZJU=;
        b=DW1UYYBxxfdSSO1pp03o/lTTuWvpfGfUnjtqpK2SMx0S0judzmuZm+J3SwBm7qDx7Q
         lJeOxM5xVejn7a3JROQYaZinhO8YTxxLm7w9q0MxM2Vf66tZLfa35Te77E/17OA68FOs
         HnHLEAyJfXEIXZr/Mn9Pp/x4EQwu0zzNVoWYuWiHoVrsHXnfdSriRbHfV/3ZfgxSxjvL
         KFBQIR6q5BmVbGdy8BD4qp6Z+vpO6QTvPsibRZpbK6bgzRo1PsjlBbnT1oiQWuNsFxsW
         g/Zgu/3WFiuUvb2eO7oUe0L+rMCV6AEZ+rAqEB3SzuDSPglpP/vGz01j4ou1A9SE8QPF
         c++A==
X-Gm-Message-State: AOJu0YxnO8cF1qIWiD0WuKnd3trg97z8giSKKAitCNM2TH7nZ/Vt0+/0
	2k0E/EFc9qDiI+ZcXLneQLf+A3/ckGUv/qrW1L+GlyZbTOr/406TloFH+o38/xGZ2n8=
X-Gm-Gg: AeBDieuMHYFropqHHUXuNcUS2l0cSDo1HgV7/kU34Syf7SnPoWVoJuEn/SmrKs38+91
	GkeB8x/CzZ+ZtsfkWfR0510qE4gFPPJUiXYKxEOT9AvgvmX2K+VDHRMx8kfmRDw4x0N6b5O2171
	CaCFapt/Sukllva+V593NHlrqeAqMy1W6kuenezzv6TjxuHlchI6XYjJFeQ0v6DGuUZr3Xgh1/7
	29KdwQEvSXgIx5/pf2fC34NQlT1LDyFvJDNMgFXSq1pfP47ycI8UWoBIcw54/v58+KsfKQWiNSA
	oZzNN5PT1rdV29dZY0ZN5VQp4DwqYjiGglit+WaHdbiqe+XP+AiANnsZvHSh97Zn6lTNgqdylQo
	CIQg9CoOHwBmmBQuCjcyjpjG3O0JScbTKKMj6b9640mQizy1OQnr1gzOt0Hbb37g+Oj39qdNJXs
	cdCQ+SbNGlESFL8JUgQ2icRhMomrXLVWiSG1k2DvguR1Btzly4k9esYGA+z2+6yxW2Fidd+6UaK
	mIgDozye4tqWpcToW0=
X-Received: by 2002:a05:6830:7301:b0:7d7:f13a:761c with SMTP id 46e09a7af769-7dc9524815dmr19269655a34.23.1777042888026;
        Fri, 24 Apr 2026 08:01:28 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcd164d2c3sm10924493a34.24.2026.04.24.08.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 08:01:27 -0700 (PDT)
Message-ID: <f04047a8-4101-4995-94b1-6afdf0f80d94@kernel.dk>
Date: Fri, 24 Apr 2026 09:01:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/register: fix ring resizing with
 mixed/large SQEs/CQEs
To: Dan Carpenter <error27@gmail.com>
Cc: io-uring@vger.kernel.org
References: <aesA-_AEKgF_oucO@stanley.mountain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aesA-_AEKgF_oucO@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 32A1046075C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13137-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid]

On 4/23/26 11:34 PM, Dan Carpenter wrote:
> Hello Jens Axboe,
> 
> Commit 45cd95763e19 ("io_uring/register: fix ring resizing with
> mixed/large SQEs/CQEs") from Apr 20, 2026 (linux-next), leads to the
> following Smatch static checker warning:
> 
>     io_uring/register.c:613 io_register_resize_rings()
>     warn: potential integer overflow from user (local copy) 'p->sq_entries << 1'
> 
>     io_uring/register.c:643 io_register_resize_rings()
>     warn: potential integer overflow from user (local copy) 'p->cq_entries << 1'
> 
> io_uring/register.c
>     498 static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>     499 {
>     500         struct io_ctx_config config;
>     501         struct io_uring_region_desc rd;
>     502         struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
>     503         unsigned i, tail, old_head;
>     504         struct io_uring_params *p = &config.p;
>     505         struct io_rings_layout *rl = &config.layout;
>     506         int ret;
>     507 
>     508         memset(&config, 0, sizeof(config));
>     509 
>     510         /* limited to DEFER_TASKRUN for now */
>     511         if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>     512                 return -EINVAL;
>     513         if (copy_from_user(p, arg, sizeof(*p)))
> 
> p comes from the user.  p->sq_entries and p->cq_entries are u32.
> 
>     514                 return -EFAULT;
>     515         if (p->flags & ~RESIZE_FLAGS)
>     516                 return -EINVAL;
>     517 
>     518         /* properties that are always inherited */
>     519         p->flags |= (ctx->flags & COPY_FLAGS);
>     520 
>     521         ret = io_prepare_config(&config);
>     522         if (unlikely(ret))
>     523                 return ret;
>     524 
>     525         memset(&rd, 0, sizeof(rd));
>     526         rd.size = PAGE_ALIGN(rl->rings_size);
>     527         if (p->flags & IORING_SETUP_NO_MMAP) {
>     528                 rd.user_addr = p->cq_off.user_addr;
>     529                 rd.flags |= IORING_MEM_REGION_TYPE_USER;
>     530         }
>     531         ret = io_create_region(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
>     532         if (ret)
>     533                 return ret;
>     534 
>     535         n.rings = io_region_get_ptr(&n.ring_region);
>     536 
>     537         /*
>     538          * At this point n.rings is shared with userspace, just like o.rings
>     539          * is as well. While we don't expect userspace to modify it while
>     540          * a resize is in progress, and it's most likely that userspace will
>     541          * shoot itself in the foot if it does, we can't always assume good
>     542          * intent... Use read/write once helpers from here on to indicate the
>     543          * shared nature of it.
>     544          */
>     545         WRITE_ONCE(n.rings->sq_ring_mask, p->sq_entries - 1);
>     546         WRITE_ONCE(n.rings->cq_ring_mask, p->cq_entries - 1);
> 
> If p->sq_entries is 0 then this wraps to U32_MAX
> 
>     547         WRITE_ONCE(n.rings->sq_ring_entries, p->sq_entries);
>     548         WRITE_ONCE(n.rings->cq_ring_entries, p->cq_entries);
>     549 
>     550         if (copy_to_user(arg, p, sizeof(*p))) {
>     551                 io_register_free_rings(ctx, &n);
>     552                 return -EFAULT;
>     553         }
>     554 
>     555         memset(&rd, 0, sizeof(rd));
>     556         rd.size = PAGE_ALIGN(rl->sq_size);
>     557         if (p->flags & IORING_SETUP_NO_MMAP) {
>     558                 rd.user_addr = p->sq_off.user_addr;
>     559                 rd.flags |= IORING_MEM_REGION_TYPE_USER;
>     560         }
>     561         ret = io_create_region(ctx, &n.sq_region, &rd, IORING_OFF_SQES);
>     562         if (ret) {
>     563                 io_register_free_rings(ctx, &n);
>     564                 return ret;
>     565         }
>     566         n.sq_sqes = io_region_get_ptr(&n.sq_region);
>     567 
>     568         /*
>     569          * If using SQPOLL, park the thread
>     570          */
>     571         if (ctx->sq_data) {
>     572                 mutex_unlock(&ctx->uring_lock);
>     573                 io_sq_thread_park(ctx->sq_data);
>     574                 mutex_lock(&ctx->uring_lock);
>     575         }
>     576 
>     577         /*
>     578          * We'll do the swap. Grab the ctx->mmap_lock, which will exclude
>     579          * any new mmap's on the ring fd. Clear out existing mappings to prevent
>     580          * mmap from seeing them, as we'll unmap them. Any attempt to mmap
>     581          * existing rings beyond this point will fail. Not that it could proceed
>     582          * at this point anyway, as the io_uring mmap side needs go grab the
>     583          * ctx->mmap_lock as well. Likewise, hold the completion lock over the
>     584          * duration of the actual swap.
>     585          */
>     586         mutex_lock(&ctx->mmap_lock);
>     587         spin_lock(&ctx->completion_lock);
>     588         o.rings = ctx->rings;
>     589         ctx->rings = NULL;
>     590         o.sq_sqes = ctx->sq_sqes;
>     591         ctx->sq_sqes = NULL;
>     592 
>     593         /*
>     594          * Now copy SQ and CQ entries, if any. If either of the destination
>     595          * rings can't hold what is already there, then fail the operation.
>     596          */
>     597         tail = READ_ONCE(o.rings->sq.tail);
>     598         old_head = READ_ONCE(o.rings->sq.head);
>     599         if (tail - old_head > p->sq_entries)
>     600                 goto overflow;
> 
> I guess if p->sq_entries were zero then we would hit this goto
> 
>     601         for (i = old_head; i < tail; i++) {
>     602                 unsigned index, dst_mask, src_mask;
>     603                 size_t sq_size;
>     604 
>     605                 index = i;
>     606                 sq_size = sizeof(struct io_uring_sqe);
>     607                 src_mask = ctx->sq_entries - 1;
>     608                 dst_mask = p->sq_entries - 1;
>     609                 if (ctx->flags & IORING_SETUP_SQE128) {
>     610                         index <<= 1;
>     611                         sq_size <<= 1;
>     612                         src_mask = (ctx->sq_entries << 1) - 1;
> --> 613                         dst_mask = (p->sq_entries << 1) - 1;
> 
> These shifts could integer overflow.  So if you picked p->sq_entries
> which was (1U << 31) then the (p->sq_entries << 1) would be zero and
> the mask would be 0xffffffff.  Which might even be intentional, since
> overflowing to zero and subtracting one is an idiom...

These are both fine, as SQ entries are capped at IORING_MAX_ENTRIES
(32k) and CQ entries are capped at IORING_MAX_CQ_ENTRIES (64k). Anything
larger is rejected earlier, as is 0.

IOW, false positives.

-- 
Jens Axboe

