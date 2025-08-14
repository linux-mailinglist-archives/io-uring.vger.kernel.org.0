Return-Path: <io-uring+bounces-8959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1009B269D9
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 16:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1859626216
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 14:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C351DB34B;
	Thu, 14 Aug 2025 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHqzTfmh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3776E1DF248
	for <io-uring@vger.kernel.org>; Thu, 14 Aug 2025 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755182425; cv=none; b=pDnN3sf1+E0sgTPNerqlppzUIXvUeFeN+tj4Qv9j5OOHVP5SrPWGKKpGxLJlCHHYbJlNju8r8EvgNnck5JigVpZo9E4irIIrRslR11Hs9KAPC1VzVMWZBlVHVWsm1fPcqEU3+dyQDeNvp21MpuulFHfe4wbg7b04ZcUVYo83vXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755182425; c=relaxed/simple;
	bh=jlng0mo9BxIkM6MSv3DbQitpyZu7/QLOYxbFwsjg7XU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JiWoDS8RpSO89+AaBEhWlmK+L5BtD6T6kkRJ26cdLtDGfV3P87zEerb9hdZEvMJytaTJfPmMwbb6F/Ma2ZVitIenzOLvF3FVse42x08LojOaZm4VY18dkt+fGjCE4EWTLnoBSprk59f7YuZPEtnWB2/PuKxT5Fm0xGcmawdJiwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mHqzTfmh; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b065d59so5400235e9.1
        for <io-uring@vger.kernel.org>; Thu, 14 Aug 2025 07:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755182422; x=1755787222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zyL33FYbgmmm9+2CHpls4Lxj4cKhi0029oIk4HZ+JmQ=;
        b=mHqzTfmhuYV7GMWu/nZRCci77Zw2bO3NOKqMlYC/Q086FOWZ8eMXvDIMuEsrh4JVBJ
         G8ZNnibMwKRK3LUzf0HKw/uSEZRvU6rRYgpPuTsCEJcO9iEJ+N0GYSvfOL5g2G0bGj0t
         vwYY/zMr1gcIpQ9NdPSqQ7vo2/byzKpe4iBDXJvwMgBLLgERqazTnVxowzQubKxnOK4I
         4AZ3dIuADISkPpyeUNpnFMho7mLS31/w35FRFz1IgA0pVfjxsRAOsgb7TUkCCVzvVhsO
         1YzusKkzn6aVEzitll4ugM6N0Bu3OGoOpCEc7JURlTwJ/iPg3ZVPJhJFg3i+cXw9P76w
         ferQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755182422; x=1755787222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zyL33FYbgmmm9+2CHpls4Lxj4cKhi0029oIk4HZ+JmQ=;
        b=JWJ4YXnQzZPjsVts/S5arPLj4S/XGqo1ovs2Mo3ULt+ajl8pmfFnRY8uEMyF5zYCMc
         En69+wZLmnZbtgGRDq1dAR8cNwWiMZ8A8iFvJPY/9Dk4a0zkLIqnJByyrouQWOYmrpxB
         4lBA+nTQadL4qaXIRmgUcnbpAokgRH7HViapDCm0qKgEu8nU39N3Gv+SeZusjuvyIxGZ
         R+BxWukRSwXneWyT9vmMuzCUqW9yMYoOE4Dxy2GD82lz/vAFfGR6O9BvpASZSa8b2V3E
         BV4E26ZI/ZxohptkJCkyK5XZSDRFm6jANdX/ViMh1u2QyBX5l+S8WNX/d65qfW4xDjAM
         XU6A==
X-Gm-Message-State: AOJu0Yx8O1O5ApRm2TGJogfnpkEf/iA18JOXP2hoae/rEPVi2rBybny4
	ao3PYtzbUODRKImbihdKdK+2Iv6gvlARfJxFRQg4O7aaGPAY3a98QRHbzr0pEw==
X-Gm-Gg: ASbGnctcjQKN7shrLs2o/IKgHb+zeXDU+dDrZIoLUb7x42i6NwiuzoL67Hlp3jCbCtn
	HH2LlXUrmvv9wSIl8QTccIaMRdC2xJX8WJ1BMK9p2VzH+2ydq0m5TGS4bXCusSdx2o6ouMqQ3ld
	4Ok+gFZbWlitcoiegEyRPoywdQEBXXLjWv2clkm0xU+/+olqkMPeUoaY34SOF5YODzTpzfzYr7y
	Yvys28Sxhn3bGd0T40XmISXkscIzVx+y04+SRN6bUlaMK7xedZvoIA3h0zLTqXpjTDCZgRe528Y
	35W10HpzGPple9n5c/qvZ9zYWnpbbNu9OUUS9P7YGI3BtWKBrcp/FtLMr2cs2ierisgqa5NGe8p
	qrXyFbg==
X-Google-Smtp-Source: AGHT+IFW8D4RyCJ15eVXE60giO8IZhaBUh6Ii23bHlXG0t5jrcPViVdfpRmySZtvlgFoDYh1kvSBCQ==
X-Received: by 2002:a05:600c:4fc9:b0:459:d645:bff7 with SMTP id 5b1f17b1804b1-45a1b628712mr30290175e9.12.1755182421738;
        Thu, 14 Aug 2025 07:40:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:64dc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm24542575e9.21.2025.08.14.07.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 07:40:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: add request poisoning
Date: Thu, 14 Aug 2025 15:41:27 +0100
Message-ID: <b98edbb8ec4495b053dfb11cb3588f17f5253b6e.1755182071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Poison various request fields on free. __io_req_caches_free() is a slow
path, so can be done unconditionally, but gate it on kasan for
io_req_add_to_cache(). Note that some fields are logically retained
between cache allocations and can't be poisoned in
io_req_add_to_cache().

Ideally, it'd be replaced with KASAN'ed caches, but that can't be
enabled because of some synchronisation nuances.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/poison.h |  3 +++
 io_uring/io_uring.c    | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 8ca2235f78d5..299e2dd7da6d 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -90,4 +90,7 @@
 /********** lib/stackdepot.c **********/
 #define STACK_DEPOT_POISON ((void *)(0xD390 + POISON_POINTER_DELTA))
 
+/********** io_uring/ **********/
+#define IO_URING_PTR_POISON ((void *)(0x1091UL + POISON_POINTER_DELTA))
+
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ef69dd58734..e6f2353f7460 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -179,6 +179,26 @@ static const struct ctl_table kernel_io_uring_disabled_table[] = {
 };
 #endif
 
+static void io_poison_cached_req(struct io_kiocb *req)
+{
+	req->ctx = IO_URING_PTR_POISON;
+	req->tctx = IO_URING_PTR_POISON;
+	req->file = IO_URING_PTR_POISON;
+	req->apoll = IO_URING_PTR_POISON;
+	req->async_data = IO_URING_PTR_POISON;
+	req->creds = IO_URING_PTR_POISON;
+	req->io_task_work.func = IO_URING_PTR_POISON;
+}
+
+static void io_poison_req(struct io_kiocb *req)
+{
+	io_poison_cached_req(req);
+	req->kbuf = IO_URING_PTR_POISON;
+	req->comp_list.next = IO_URING_PTR_POISON;
+	req->file_node = IO_URING_PTR_POISON;
+	req->link = IO_URING_PTR_POISON;
+}
+
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 {
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
@@ -235,6 +255,8 @@ static inline void req_fail_link_node(struct io_kiocb *req, int res)
 
 static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
+	if (IS_ENABLED(CONFIG_KASAN))
+		io_poison_cached_req(req);
 	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 }
 
@@ -2766,6 +2788,7 @@ static __cold void __io_req_caches_free(struct io_ring_ctx *ctx)
 
 	while (!io_req_cache_empty(ctx)) {
 		req = io_extract_req(ctx);
+		io_poison_req(req);
 		kmem_cache_free(req_cachep, req);
 		nr++;
 	}
-- 
2.49.0


