Return-Path: <io-uring+bounces-11707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E98EAD1FCC9
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49E84303E412
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7A511CBA;
	Wed, 14 Jan 2026 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gSyZETwh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f67.google.com (mail-oa1-f67.google.com [209.85.160.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BA12C0293
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768404535; cv=none; b=QBB8wLG/BT87dwR+jqqaC9f+f4IP72rW8y67Ts/0Ro6Dc7iYodaiobuYGwDLWrzDfYyw8H6UqzqICDpiin/vrJ6cmQr8kRNgI7w2PBKTCYlBhdWIH6qKaLqbS/X5eet6p2Tpg82CtL9+N424jyQYp5KrjlWgibOS0Q6yrtRmrUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768404535; c=relaxed/simple;
	bh=NdAMKnjDIt4YhVv+tti3QlufE1PUAvqzYWRcSWdd5dk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=PzEcJvFZCxw/GGM7wnP5B++jt5NvUroLJA4MXLxyWSUAvBuKIdtXW//AhdULgyysFzVeW1MvG8brePJZ/HW++9DlqcejurZY+rc6/94dngy3vA0+Dh7CidxPRRHBFm1pCD3ou7gfkjpcJMecSMd8Ueb2VqCqrEGbFOU+/C4YNuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gSyZETwh; arc=none smtp.client-ip=209.85.160.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f67.google.com with SMTP id 586e51a60fabf-404254ffe8aso101736fac.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 07:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768404532; x=1769009332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OgNvUDQOu/L6Zs5cgOeYW4dQncCJMIqOefIuM1j9drE=;
        b=gSyZETwho036m6l5LRhgUEiGYxdtfPqOjLeH8liOjigiKL4KBRRxlfaw+s9J9rsHqg
         6CQX/fKjXSdAm4QsgpyqbFDuTWuG9hxt3SB2plWRPoLzydx+vHnOoUvNtbszIyxiCU9C
         R7qQj/pQTIRPjPQq7ZPTMuITrNj4OinaJSfwVMDFL1rs11+hNVoN/BuY8PzeshCAR4yj
         74zCjEzAhLK0llpAeRv0iesMTgpvR1rl49qK5xtq6mkUfavwXmQf2QfIYGP0YNJXGwXL
         4a2PRYv8lu+VNhx7Enc7xreDlaQdf3B7cH0JfObMJUM5l1zs2FHwJTCiaw+JFTMDrYIN
         /TZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768404532; x=1769009332;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OgNvUDQOu/L6Zs5cgOeYW4dQncCJMIqOefIuM1j9drE=;
        b=FB3Oc4csUZ9Ngk+txLdasCq5R6NHnG+k/z++t5ZlWhZ6EuR4cL+s7AD0WUiCh/kzr2
         2xxijKAz1g6cpdtdt4JQ711s7gxyAZd4EBT+yP2ucAc6j/0EaVYyAA7biC0rzzRIP5jj
         TPlYVMvPkqRVog4LhI18QMPMAEgLG6qzJZnvGirGisrFRivPpsz6enOjGwI2GbSOx+K+
         DtoONEzcPO24Jr9kfE3fXoeLvaLjSrBx83GZtJLZoKrelfD7ogCZvRNll3Xid8anL48z
         OgFIoa0W054BLe/ozrfVl4s1XgM0hHvA2XZR8mlrbgtH4OZvq0vUHZCkdyfZttfkLsqT
         0G6A==
X-Gm-Message-State: AOJu0YzHwn0YuYTmzlZesEmupDuO+pxxphKisBRv+yAi6NPwkYR6MW+g
	L0dFrVKx/VyjBQ7tE8ovvpbdRFW1Ww/s8vA/MLJaGiTCEWMyHz7Hd2KMrx5Jpzj3uLN94ST2Qt8
	TgfmsC8s=
X-Gm-Gg: AY/fxX4mmqwUIV82oAcnVz4QGXLLqyLbdEet0UYmdNW2HBxIf4GbR03MHxSq9B+H+6y
	kwlckj/lMtHN25uUY4zf8+deu55gUke/mtBPtXuzwnjdKi+VJh405qjkuCDIyksp189do7hOu36
	fztiuUooE4rrQPkRRmg5wQM2j+zKqumru0mp/M2LGLPTJ+kBU+XLJyAw1OgvmfEpqcwjnlHvrGH
	dEy0/rCTo3tpLnSUySGk6TD+yuSHE+bHlpbnlwyN9XOmJ2GOxB7yrmmIAPNlReXzVFizwv0tYh2
	xUlBZucCVaqqn35uNI68BrD+LkOPbQP8kRSCoHK/bvlCweeW/neYhbE0XfzZW/uZtu5XAc+7pzS
	r8ND073hU12mk19/Ij2Kd0KZYe8J3Vbs0td9gAnCrmdVomPSfcFuAaGSjYiy8KsJ5lMECbrNdtC
	uLmUhyZns=
X-Received: by 2002:a05:6870:9d0f:b0:3f5:3d0c:79ba with SMTP id 586e51a60fabf-404067ec884mr2188437fac.28.1768404531045;
        Wed, 14 Jan 2026 07:28:51 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de8cbfsm16431931fac.3.2026.01.14.07.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 07:28:50 -0800 (PST)
Message-ID: <c008dbd2-6436-40da-b5c6-f34844878a6f@kernel.dk>
Date: Wed, 14 Jan 2026 08:28:49 -0700
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
Subject: [PATCH v2] io_uring: fix IOPOLL with passthrough I/O
Cc: Yi Zhang <yi.zhang@redhat.com>, Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit improving IOPOLL made an incorrect assumption that
task_work isn't used with IOPOLL. This can cause crashes when doing
passthrough I/O on nvme, where queueing the completion task_work will
trample on the same memory that holds the completed list of requests.

Fix it up by shuffling the members around, so we're not sharing any
parts that end up getting used in this path.

Fixes: 3c7d76d6128a ("io_uring: IOPOLL polling improvements")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Link: https://lore.kernel.org/linux-block/CAHj4cs_SLPj9v9w5MgfzHKy+983enPx3ZQY2kMuMJ1202DBefw@mail.gmail.com/
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: ensure ->iopoll_start is read before doing actual polling

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e4c804f99c30..211686ad89fd 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -713,13 +713,10 @@ struct io_kiocb {
 	atomic_t			refs;
 	bool				cancel_seq_set;
 
-	/*
-	 * IOPOLL doesn't use task_work, so use the ->iopoll_node list
-	 * entry to manage pending iopoll requests.
-	 */
 	union {
 		struct io_task_work	io_task_work;
-		struct list_head	iopoll_node;
+		/* For IOPOLL setup queues, with hybrid polling */
+		u64                     iopoll_start;
 	};
 
 	union {
@@ -728,8 +725,8 @@ struct io_kiocb {
 		 * poll
 		 */
 		struct hlist_node	hash_node;
-		/* For IOPOLL setup queues, with hybrid polling */
-		u64                     iopoll_start;
+		/* IOPOLL completion handling */
+		struct list_head	iopoll_node;
 		/* for private io_kiocb freeing */
 		struct rcu_head		rcu_head;
 	};
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 307f1f39d9f3..c33c533a267e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1296,12 +1296,13 @@ static int io_uring_hybrid_poll(struct io_kiocb *req,
 				struct io_comp_batch *iob, unsigned int poll_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	u64 runtime, sleep_time;
+	u64 runtime, sleep_time, iopoll_start;
 	int ret;
 
+	iopoll_start = READ_ONCE(req->iopoll_start);
 	sleep_time = io_hybrid_iopoll_delay(ctx, req);
 	ret = io_uring_classic_poll(req, iob, poll_flags);
-	runtime = ktime_get_ns() - req->iopoll_start - sleep_time;
+	runtime = ktime_get_ns() - iopoll_start - sleep_time;
 
 	/*
 	 * Use minimum sleep time if we're polling devices with different
-- 
Jens Axboe


