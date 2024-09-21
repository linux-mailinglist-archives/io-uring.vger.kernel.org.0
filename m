Return-Path: <io-uring+bounces-3253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FEA97DC31
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 10:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 166E8282BA4
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 08:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D09150997;
	Sat, 21 Sep 2024 08:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DYkGpW+d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2A013FD72
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 08:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726906732; cv=none; b=pzwGVEMWQZwusbs1CX0lG2xk4q8VP7TQjf5ndfc/tgUn3aiSzIYCwmuz23rgnQ+PDDnihBq26kf1kGeJ3rn7SZ1z3cOFzoyUg3Js0FritO7H6qSgkCGrXs8MZjrdymA8Sf0y9gNELrILGc1Eh8apG4E/FkDsxPUFraVsN85DVmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726906732; c=relaxed/simple;
	bh=/CdgUBQiQaKFy6hnDDSRlNXlEYW3+pivbcVZuNW7tLQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=U6TSkP/1FcOxXlUrWT5x7kqx5P3VetJXC2bBdMUql4hACUPRAmK57pJ1g62SptF116R0bgSrPG2uScGw/8YPgxw76rh3ydqGUS4rU+r2cnR6I6jKvaxZ5RxWcr3AT+gfnvD3gwYG9kNnllyDrX8gAgU9NpsPJV72HJcyiWzRHtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DYkGpW+d; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8d2b24b7a8so696881266b.1
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 01:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726906726; x=1727511526; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nMh5iQO6Bk/i7++rtylHpbqcSvoTiSAuMRdymQjJO8k=;
        b=DYkGpW+d5k4JOWIT5GisDj4VrdnbMq+DON7LA/Hzy5VFkGKKTrRsLM8Wc+xMgbO0KY
         csyZslFDX9HPnxiWsWnROkpFXs4g6WdvbPQqkYa5zq2Z2g24LR7THz6xmIwM+UfSlboc
         b6uzuvLR/MJLtZoHcJr7OE5GOyFCEgu0OdUi9Rz02eGAdQdcsWEDrrpqzNAHidaHY84z
         TVi2vUJQhBWPL3848ueRTtcyrX1EL5FB8Zxp9vfU63d18XfdrtButeCa8F0axDJUhq15
         hCDOHXFnoO7AQBez3/wPs4mBGJIbZd6ayp0GfLxEY9vl/kAewHrMxuvd9bNHJ5oUbw0X
         kf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726906726; x=1727511526;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMh5iQO6Bk/i7++rtylHpbqcSvoTiSAuMRdymQjJO8k=;
        b=lWGN4UMH3gNiHwhWu5ibur47fm+5R0LEglkdDc+MFOxeIONZYfXG2wEZJwhAUmiyyo
         pHnbCZf+IU9Vh3f39BIk6PcZGbiG0KbkkC2O8oJGjQev7xt2ydKtyv8gHgcufhvS3v+C
         DFDyYkJIv5hSFAQoIG2Vb1QV9WJI1HRdcA+rmQlmpa7GpWZrlUXwXeMvrXnNvT6KP+xc
         xoSKhABzsphlx4+yZS9iJ0g1u9XTKlId9lcg6E2EHr1RYGiNiq7PPrY84t94HFO7rEmW
         TPd/9144hQHS8d97dgc8EIzsd8Jg3qIGTBJK0cuqh8dsYLr0r7dAUK8VkKbF/UozQSSf
         kQiQ==
X-Gm-Message-State: AOJu0YwHFPr4DqfG60gFKQ4oICyQR0XJJmG2N5VlOh1AYJ+g1BWODfPR
	sjibqXnxeXyGtg/5OQzIHAVFuMoOhmEd/AEp4xWb+ur8IsYyOvcer2MbrcWhvAb2/E3kx9qkotV
	/Si/i9QWZ
X-Google-Smtp-Source: AGHT+IFvxTLc9JZkzQbzF56f4tHD4rEbf3toWSA5Xqnc216/Dk5UEvg1iwjsQOLhaKY2UAoYTPEIxQ==
X-Received: by 2002:a17:907:3daa:b0:a86:6a9a:d719 with SMTP id a640c23a62f3a-a90d364310fmr527765566b.29.1726906726424;
        Sat, 21 Sep 2024 01:18:46 -0700 (PDT)
Received: from [10.17.14.1] (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612b3fcesm945068166b.133.2024.09.21.01.18.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Sep 2024 01:18:45 -0700 (PDT)
Message-ID: <5d26ea46-f380-4cdd-a26f-356235710b65@kernel.dk>
Date: Sat, 21 Sep 2024 02:18:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] io_uring/eventfd: move ctx->evfd_last_cq_tail into
 io_ev_fd
To: io-uring <io-uring@vger.kernel.org>
References: <20240921080307.185186-1-axboe@kernel.dk>
 <20240921080307.185186-7-axboe@kernel.dk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240921080307.185186-7-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/21/24 1:59 AM, Jens Axboe wrote:> Everything else about the io_uring eventfd support is nicely kept
> private to that code, except the cached_cq_tail tracking. With
> everything else in place, move io_eventfd_flush_signal() to using
> the ev_fd grab+release helpers, which then enables the direct use of
> io_ev_fd for this tracking too.

Of course forgot to refresh io_uring_types.h as well, so this patch is
missing the hunk that deletes it from io_ring_ctx. Refreshed version
below, that's the only change.

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4b9ba523978d..0deec302595a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -413,10 +413,6 @@ struct io_ring_ctx {
 
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
-
-	/* protected by ->completion_lock */
-	unsigned			evfd_last_cq_tail;
-
 	/*
 	 * If IORING_SETUP_NO_MMAP is used, then the below holds
 	 * the gup'ed pages for the two rings, and the sqes.
diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index d1fdecd0c458..fab936d31ba8 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -13,10 +13,12 @@
 
 struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
-	unsigned int		eventfd_async: 1;
-	struct rcu_head		rcu;
+	unsigned int		eventfd_async;
+	/* protected by ->completion_lock */
+	unsigned		last_cq_tail;
 	refcount_t		refs;
 	atomic_t		ops;
+	struct rcu_head		rcu;
 };
 
 enum {
@@ -123,25 +125,31 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 
 void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 {
-	bool skip;
-
-	spin_lock(&ctx->completion_lock);
-
-	/*
-	 * Eventfd should only get triggered when at least one event has been
-	 * posted. Some applications rely on the eventfd notification count
-	 * only changing IFF a new CQE has been added to the CQ ring. There's
-	 * no depedency on 1:1 relationship between how many times this
-	 * function is called (and hence the eventfd count) and number of CQEs
-	 * posted to the CQ ring.
-	 */
-	skip = ctx->cached_cq_tail == ctx->evfd_last_cq_tail;
-	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
-	spin_unlock(&ctx->completion_lock);
-	if (skip)
-		return;
+	struct io_ev_fd *ev_fd;
 
-	io_eventfd_signal(ctx);
+	ev_fd = io_eventfd_grab(ctx);
+	if (ev_fd) {
+		bool skip, put_ref = true;
+
+		/*
+		 * Eventfd should only get triggered when at least one event
+		 * has been posted. Some applications rely on the eventfd
+		 * notification count only changing IFF a new CQE has been
+		 * added to the CQ ring. There's no dependency on 1:1
+		 * relationship between how many times this function is called
+		 * (and hence the eventfd count) and number of CQEs posted to
+		 * the CQ ring.
+		 */
+		spin_lock(&ctx->completion_lock);
+		skip = ctx->cached_cq_tail == ev_fd->last_cq_tail;
+		ev_fd->last_cq_tail = ctx->cached_cq_tail;
+		spin_unlock(&ctx->completion_lock);
+
+		if (!skip)
+			put_ref = __io_eventfd_signal(ev_fd);
+
+		io_eventfd_release(ev_fd, put_ref);
+	}
 }
 
 int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
@@ -172,7 +180,7 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	spin_lock(&ctx->completion_lock);
-	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
+	ev_fd->last_cq_tail = ctx->cached_cq_tail;
 	spin_unlock(&ctx->completion_lock);
 
 	ev_fd->eventfd_async = eventfd_async;

-- 
Jens Axboe

