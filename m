Return-Path: <io-uring+bounces-1358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 645B789467C
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 23:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 963CB1C20EC5
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 21:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2291A54919;
	Mon,  1 Apr 2024 21:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mAVGkrtF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8469D8480
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 21:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712006525; cv=none; b=OzLMRaUI8Z1m8ML7OqjhGL+It7PJUrZEAdsW36ivk1dH5c0+pv35UdAfO9qvAOR85COJ+TABaWx9K32UbWwRR9kjr4JGqvOdhzedTrrgnh9HF0Nw+hZhkri2Lo3L9ONAb4zn/wNir8RLYYGMPreQgzByZ9lBJaCl7qv4HkBK3Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712006525; c=relaxed/simple;
	bh=E3em3zFJ4LZtYOSlC797qf/TQ2OLqel30UnTFs9SkDo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=UzE1LQGQCx5N9xVutEL//v1UUnXjUSnXtkLAiQQmkjRnvf/7LOF5Izf9TY9FcdQEcb9kBmiGcOSjzzhApEzCgbMdtvVy0wbmSlj+w2NbDjQMMd9u7o0/MGm+Qwa7R0fBLWvnmcSNxG5650cl1POAWZyswdv06OGVsP85A1ZIMjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mAVGkrtF; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ea895eaaadso1217904b3a.1
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 14:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712006520; x=1712611320; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4BSVr4Wcvwyj+2Sce7jFTh2E72nbg0Ss6vJr/o2GKnQ=;
        b=mAVGkrtFYH+qOwMxPVsg2J4uRNwtQz9RtUTW13R4zUg0ngqUaylegbtwyOhhls+E5U
         ylByxKdzw64g6I8x2Gpwnd5mAtLHgKxW1jnRzqdoIqmI2reMqbw1B2ymXolqcvTuBMbc
         jhJfR6F4A8XrEWGrvXCtanyK++GsAUGWnktQCfXnht3E158DDO5/wVroz0lLGPGqDRlR
         bGA6eeuWISQ9xOi+nWeX8GVUUreAzJQZgONPcRIbY7Ar4UFxYtL4UURFESw7+dQYt2yd
         u2uMb0+VIOX01wnJ0dIRo/DVlxIJGUFegRmHgFuRSEfZHI9LwNRtQB9YK/YxKxjYCFbE
         EFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712006520; x=1712611320;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4BSVr4Wcvwyj+2Sce7jFTh2E72nbg0Ss6vJr/o2GKnQ=;
        b=andvrbMraTv1zXq1OqIGlxJIwfEQi4bZDmy+q1QKWfjIf9ol2RhYLyT048L2vZazYI
         LKtzxTVW2YxpEmajkLILnLLwK7Alxx5vp3+F7xkUkm/77SrJ1tUGOQyFJ1ZXEOfiTD16
         hzJR9diVt0CVuPRKRC7GIuI9zhzDReIVRuP6cCW9fn15uIQ0+ZnN1/4PYiDbimB2t5Rb
         BjVXKhnZ1GqZqGVhOLX6R4YmHaLemiTvBNEt+aEp5+7HdUUj/2CpT0gH25oL5qR+MWaC
         wNEVTZatgCHTJ1Nf4DyvHNMBVcqjr/sIRl6eRGND9zN7hxxCZzGXjtrmCgGZQR+mHZBd
         UgTQ==
X-Gm-Message-State: AOJu0YysUqUbelXWQl8fwbLhk0bKDdbP5EjYc45KXlXHOQGEXh3KvEEl
	1RcbQ5MEFYqMa8p04Yn2XUAxjlzred4RQRoT0bRQ5DDEsl7gaCJaeESMmsgLzOZfpMsAIrTb+2Q
	X
X-Google-Smtp-Source: AGHT+IHZAASrMRihqk9MsFsn7yXuCKoD+KVsJ6r2Fh8WYSuBKrbCizs5rLgiPWb1FZXLPQqf/2A0DQ==
X-Received: by 2002:a05:6a20:3ca9:b0:1a7:c2e:41eb with SMTP id b41-20020a056a203ca900b001a70c2e41ebmr8970627pzj.2.1712006519769;
        Mon, 01 Apr 2024 14:21:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id a18-20020aa78e92000000b006e6c0080466sm8606483pfr.176.2024.04.01.14.21.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 14:21:59 -0700 (PDT)
Message-ID: <5018c04c-ea11-4a52-a3fa-3b053aad355a@kernel.dk>
Date: Mon, 1 Apr 2024 15:21:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: use private workqueue for exit work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Rather than use the system unbound event workqueue, use an io_uring
specific one. This avoids dependencies with the tty, which also uses
the system_unbound_wq, and issues flushes of said workqueue from inside
its poll handling.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/1113
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8baf8afb79c2..d1defb99b89e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -147,6 +147,7 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void io_queue_sqe(struct io_kiocb *req);
 
 struct kmem_cache *req_cachep;
+static struct workqueue_struct *iou_wq __ro_after_init;
 
 static int __read_mostly sysctl_io_uring_disabled;
 static int __read_mostly sysctl_io_uring_group = -1;
@@ -3166,7 +3167,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	 * noise and overhead, there's no discernable change in runtime
 	 * over using system_wq.
 	 */
-	queue_work(system_unbound_wq, &ctx->exit_work);
+	queue_work(iou_wq, &ctx->exit_work);
 }
 
 static int io_uring_release(struct inode *inode, struct file *file)
@@ -4190,6 +4191,8 @@ static int __init io_uring_init(void)
 	io_buf_cachep = KMEM_CACHE(io_buffer,
 					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 
+	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
+
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
 #endif
-- 
Jens Axboe


