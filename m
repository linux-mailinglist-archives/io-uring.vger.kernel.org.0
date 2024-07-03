Return-Path: <io-uring+bounces-2418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 586E5924CDA
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 02:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B7361C2215E
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 00:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5754E7E6;
	Wed,  3 Jul 2024 00:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQ72qP6L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27691361;
	Wed,  3 Jul 2024 00:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719967711; cv=none; b=noVRyG36B21hXmI0vhxYGZfOgJW69HybDtdukTnZ/tZUbydzsBDQvQmSC/sz461W5lLpeoBnH1TfDqBdxaG1P6wOQcVuW4lFYdKM7FqYWEdKVlivz3KbwhctQNvJqyOan0GXDCwGDF+thlqDa558gPibleWDU0mJcC+Q2/Rh0xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719967711; c=relaxed/simple;
	bh=oWYSMtuZp1pdNBxCN7ttoYHwMtat4dDaIgcJ9Igj9CU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hyC30FdYXQoobYY66zhp9UylVJ5jtEEnPAD2l36ZYWAhSaETEjpSlCARe8SZumYNlleqkVkPoLXjhEqJlrKsH86CF/mJ/OjTJGEtdtTyiwKgCW7Gli/WHOy8mD3Uk3RDziPyDpsBnEgPZMCQWpgaRLjFRpv95jEiTGLCPxLTThU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jQ72qP6L; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7021dffc628so1032943a34.2;
        Tue, 02 Jul 2024 17:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719967709; x=1720572509; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Li3K3Uue/qNEmAx8woj0qwPhTqO5rT3fVLroOQjerg=;
        b=jQ72qP6Lk4gGXhJVBbiy/VBm2zc0oOfXDO2b92UzG+QjTtBkKKYGbAukx+32h2p2kH
         4fNjy6I2/9v+o46FmQh6x/RK2/V5IvSDC+wNXWj/z7yTAbxZ5n/AaFs6e6N6AoYb5qpQ
         d/tMq6Dr9X94osTuVEP9XfoRKPU8971oO3VkBd9ZC5N3WS+zBrBLv9nWHwE+cY8oEekD
         mjqHzmOyFo//+nPpqg6uwUai4usUJK1NsiWLOO2SJeVoqu6nP2yEF3IX8vtLxDCVZMUv
         VKyQ8Zt52OKnokfprUDzc3b9SMS8iJZUQNlU7yfGXtpknfdOAvJobXg32790+dbpQn3+
         0vLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719967709; x=1720572509;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Li3K3Uue/qNEmAx8woj0qwPhTqO5rT3fVLroOQjerg=;
        b=LF5nCczfaemnsVXAkDBe5UuiIT5kbMxW34L3Speu+tL9MpKWg3KNwftQCprDUKMWSk
         5R3GZPvJv9qcB2E2DySucalT5rTiniYfGfCz+Lt4GW32O4UjvFJS2gdRcpsXQH08/REh
         ssDeZgDcSxNJWIByA3Bvb/CWazyHWLcScFPguggir4S9XM/PjQb3XnyrlgkO9KHF9T0g
         kQemoPugobGPmgL14Jzmx7K5YGXP07haN6AfWBso7/RLiTtQJIHLXSlnPAEHIszBuIrB
         YOHH8gUycA+w4t+SZzj9k3oelFRGdmA8Qr4ed2ztEcIipcTdZmLJel/v7XPlUAv9wCF7
         2uVw==
X-Forwarded-Encrypted: i=1; AJvYcCX77KztmkwAY5eumN43RmmuHh/WY2W9eyXFsCLj/le3U+CdY5pdEgwopMWAviQF+q/3r+gyq01FyQCzYux7mXiAqiKN3uaMjP9OYhRq
X-Gm-Message-State: AOJu0Ywhq/xF8yA8W0At4hL0rEWmqyAcBJV/YG53ZrOkgdW7gR5I+PxC
	XeTWa8n9gC8/xZwBqZqMMHZc3EHMY7Peqvq8K9qbAc9/IxUig4OZ
X-Google-Smtp-Source: AGHT+IGE37cgZq3LE0NZaCz+m7LS6PUY2cEAveg7UCUE4CXD/YmIbu7cgbbVm4lju8pbSA4JGkdBDA==
X-Received: by 2002:a05:6830:2056:b0:702:1de0:9a4a with SMTP id 46e09a7af769-7021de0a7f6mr5366692a34.29.1719967708719;
        Tue, 02 Jul 2024 17:48:28 -0700 (PDT)
Received: from [127.0.1.1] (107-197-105-120.lightspeed.sntcca.sbcglobal.net. [107.197.105.120])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-70208090725sm1273321a34.39.2024.07.02.17.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 17:48:28 -0700 (PDT)
From: Pei Li <peili.dev@gmail.com>
Date: Tue, 02 Jul 2024 17:48:27 -0700
Subject: [PATCH] io_uring: Fix WARNING in io_cqring_event_overflow
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240702-bug9-v1-1-475cb52d3ee6@gmail.com>
X-B4-Tracking: v=1; b=H4sIANqfhGYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDcwMj3aTSdEvdxBSLRGMzMwvDVKMUJaDSgqLUtMwKsDHRsbW1AN+eV1p
 WAAAA
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com, 
 linux-kernel-mentees@lists.linuxfoundation.org, 
 syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com, 
 Pei Li <peili.dev@gmail.com>
X-Mailer: b4 0.15-dev-13183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719967707; l=2240;
 i=peili.dev@gmail.com; s=20240625; h=from:subject:message-id;
 bh=oWYSMtuZp1pdNBxCN7ttoYHwMtat4dDaIgcJ9Igj9CU=;
 b=2CTRcQ59Jslvl+23lIw2OKiISOO9WIwUSDXNtWtmPaj+xHfnXlASeBeCMeVeuBYShg9TeHBp2
 jWp00+/6ZKGBVpFs/19fR+hino0mbkb7//PSP31OjHtZ5912tcbwIQR
X-Developer-Key: i=peili.dev@gmail.com; a=ed25519;
 pk=I6GWb2uGzELGH5iqJTSK9VwaErhEZ2z2abryRD6a+4Q=

Acquire ctx->completion_lock in io_add_aux_cqe().

syzbot reports a warning message in io_cqring_event_overflow(). We were
supposed to hold ctx->completion_lock before entering this function, but
instead we did not.

This patch acquires and releases ctx->completion_lock when entering and
exiting io_add_aux_cqe().

Fixes: f33096a3c99c ("io_uring: add io_add_aux_cqe() helper")
Reported-by: syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f7f9c893345c5c615d34
Signed-off-by: Pei Li <peili.dev@gmail.com>
---
syzbot reports a warning message in io_cqring_event_overflow(). We were
supposed to hold ctx->completion_lock before entering this function, but
instead we did not.

The call stack is as follows:

Call Trace:
 <TASK>
 __io_post_aux_cqe io_uring/io_uring.c:816 [inline]
 io_add_aux_cqe+0x27c/0x320 io_uring/io_uring.c:837
 io_msg_tw_complete+0x9d/0x4d0 io_uring/msg_ring.c:78
 io_fallback_req_func+0xce/0x1c0 io_uring/io_uring.c:256
 process_one_work kernel/workqueue.c:3224 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3305
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3383
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:144
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

In io_add_aux_cqe(), we should acquire this lock beforehead.

This patch acquires and releases ctx->completion_lock when entering and
exiting io_add_aux_cqe().
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4e2836c9b7bf..0f62332e95ff 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -834,8 +834,10 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
  */
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
+	io_cq_lock(ctx);
 	__io_post_aux_cqe(ctx, user_data, res, cflags);
 	ctx->submit_state.cq_flush = true;
+	io_cq_unlock_post(ctx);
 }
 
 /*

---
base-commit: 74564adfd3521d9e322cfc345fdc132df80f3c79
change-id: 20240702-bug9-ad8a36681e2d

Best regards,
-- 
Pei Li <peili.dev@gmail.com>


