Return-Path: <io-uring+bounces-5606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C93709FCBF1
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 17:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55FE71882A73
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 16:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D535258;
	Thu, 26 Dec 2024 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iw8ADVVX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0BAEC5
	for <io-uring@vger.kernel.org>; Thu, 26 Dec 2024 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735231727; cv=none; b=eT39YyscI6HArIxG628IM7SCrKcMEIrgym1iMokJJfyyTbqNTmpxNiT1m24djikq59a2RT1Y56PMdNLy/qTdAcuqVHm5Rr4B9VcDFdcPnxzQpxQgY9PG9ztImLtzZnDlJqQOpMd1BpvzT/5qWkrOuaKskM2P5Q8cCI7yoM4z+GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735231727; c=relaxed/simple;
	bh=y50Q7JSYEBWCvnm/itlmAHLXrlvDX5/6wcV2RjvjFlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RUvIAfCCR42eG3N9zwFU3NP4VeJemeIiJfaCHT8QmyGb+1pNwVNC2iBQ6LUXxeG5zJ25CC6DojD0KAS+IW/tYWMpgfed2HqDZ0qP2Sgfc+y4tpvLVbSnzzMNi75r7ARaVOw/Sgs0emSxP+PamKtG3aAcZsltepsiHESB7bClQc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iw8ADVVX; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aabfb33aff8so1156980666b.0
        for <io-uring@vger.kernel.org>; Thu, 26 Dec 2024 08:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735231724; x=1735836524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z3/fwzhk/iUJlY8C2c4OnK82rxR48Cr0nCcv7JoE2Sc=;
        b=iw8ADVVXRHxhDX2bnvzvC3b5iJIgN931wrlBMHE/R82fosyXFW0BqfWCeqrDE5Udb/
         Ba6MjSZ/ncIKflgEGGxDZfR71dlLvOoV3P6IRmCEg3U3MfsuYqh/QSdV9UVm4W7pz9sO
         iSRQgppNoZBi0uJh3idjxlmepnOUBuBvcqGFiKZ84As88hDLH8Kvvm3O7TSFJhNpXTD9
         vfSoQsf4eTV1pCG1znH8rnbgJEqGqtk017pF/MXvRLW89eCeyDUAd4KbGadQfVZH/DK5
         h9wPBOJ9NhPkwZ0w5z9+GEU/86DvH02gsBXB3ApekU9wokIsHzV+RUKyTadJF35Pvt2b
         eO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735231724; x=1735836524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z3/fwzhk/iUJlY8C2c4OnK82rxR48Cr0nCcv7JoE2Sc=;
        b=TcBW661rASz9K3gBpVDDEo2CYHES09wMXW8Tv2klk7Iqes5c4GqVKayHQ0+MPiMgnK
         /QE9I1eZfnqzrKaiMA27gEMgQv4jATdJf4YR2bxpjR0hn6K6BPqikUUn9bkqiuf/qSh4
         0wWgf0JgQps1WCKdhMI7Ya5V0ba5MxdpHxg6xUmR9FqGhZzvhtNBWcd1RP97rcjssSTB
         xinuhi/f2e084Q0JaocL+MhsO2lBCFH63txjr63+qv1QCLZ+ZC4TsH6DlGX1HOJeRU4d
         UmxoJZ3jGbiCymN30p4Gftd9AFyy0Ev/loXnEbC7Lgk39r8q3CYjKdCW3uzrpdo0xrPi
         5UGw==
X-Gm-Message-State: AOJu0YynJzzhm/ryaCdREUwWDUfMrNs9tx6GhvCvuA4X/KStwQS5l9TT
	iOLB3EQ7ePOP8g7QfIx87bmkm0loRDmd4GdO1vABj/tO4i2S+4XjEyXcIQ==
X-Gm-Gg: ASbGnctPQjK5BN+ifhQUg5vZ0QvRmPO+2lNdB9bL4qXDINmDGayE4/NY55Jj6ZmFDXq
	BRyMQXV7CVp4rtL4FJJZydQEtgPvqHvQUGqh2b2Nz4WYJJjuGjeKIOHbTy+a+JQdgcbbE8egtEK
	QwbeQA5MVHSoOSqxqxFh9wYyQdND5h4tQT9jcwIa1OV2IJEWC77U9CBFReO/Ftix8Lqrj0GI/+I
	ZVRIwXL/FwMOzZa5icQFKFysrRb73H97FibFv5gqMpHtIahqvrevUotrbJ5Ju4dFBdJYA==
X-Google-Smtp-Source: AGHT+IGKyJ3Kp+FUFVscOrBKgl6wV75SajfzX6LIicj62NCC/5KDOHUM7ZotZHwfto0VrpKGpYOS1g==
X-Received: by 2002:a17:907:d9e:b0:aa6:7c36:3428 with SMTP id a640c23a62f3a-aac26bd5317mr2386442466b.0.1735231723615;
        Thu, 26 Dec 2024 08:48:43 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.252])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f0159f1sm976442366b.154.2024.12.26.08.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2024 08:48:43 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 1/1] io_uring/sqpoll: fix sqpoll error handling races
Date: Thu, 26 Dec 2024 16:49:23 +0000
Message-ID: <0f2f1aa5729332612bd01fe0f2f385fd1f06ce7c.1735231717.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BUG: KASAN: slab-use-after-free in __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
Call Trace:
<TASK>
...
_raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
class_raw_spinlock_irqsave_constructor include/linux/spinlock.h:551 [inline]
try_to_wake_up+0xb5/0x23c0 kernel/sched/core.c:4205
io_sq_thread_park+0xac/0xe0 io_uring/sqpoll.c:55
io_sq_thread_finish+0x6b/0x310 io_uring/sqpoll.c:96
io_sq_offload_create+0x162/0x11d0 io_uring/sqpoll.c:497
io_uring_create io_uring/io_uring.c:3724 [inline]
io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
...

Kun Hu reports that the SQPOLL creating error path has UAF, which
happens if io_uring_alloc_task_context() fails and then io_sq_thread()
manages to run and complete before the rest of error handling code,
which means io_sq_thread_finish() is looking at already killed task.

Cc: stable@vger.kernel.org
Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/sqpoll.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 6df5e649c413..9e5bd79fd2b5 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -405,6 +405,7 @@ void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 				struct io_uring_params *p)
 {
+	struct task_struct *task_to_put = NULL;
 	int ret;
 
 	/* Retain compatibility with failing for an invalid attach attempt */
@@ -480,6 +481,7 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 		}
 
 		sqd->thread = tsk;
+		task_to_put = get_task_struct(tsk);
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
 		if (ret)
@@ -490,11 +492,15 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
+	if (task_to_put)
+		put_task_struct(task_to_put);
 	return 0;
 err_sqpoll:
 	complete(&ctx->sq_data->exited);
 err:
 	io_sq_thread_finish(ctx);
+	if (task_to_put)
+		put_task_struct(task_to_put);
 	return ret;
 }
 
-- 
2.47.1


