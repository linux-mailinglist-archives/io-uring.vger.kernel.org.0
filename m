Return-Path: <io-uring+bounces-6644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0031AA41089
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 18:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1B8F7A92C6
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 17:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D293013E898;
	Sun, 23 Feb 2025 17:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4jZSkkH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3A513B2A9
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 17:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740332528; cv=none; b=JUO8EfBPzO0srN3Bp21DFbplJ6IJBI3hvzFN66Ryy5Eq5HpeCWlUcV9h2o+hLDuelgClApN32eRYbmcgHP07scmCwvqmtSv3Dls5K1ZgICM8NoH2HWEJhAPR+J12GVKqnyfcHPFJ+7VKv6CSjCJhqGGxuBsLj5q02uMQaseBZxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740332528; c=relaxed/simple;
	bh=hraXz+H83tSWDQc0X/Fb8vXtFjpTGH/TvI5QUUiEoxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UmtrwL5i6J0Z0XHm3uAejYq8ux+U8LsTqIRB4a5I+T9SZ/Zd+U9D7Aj4j9q5PozEg6iIMQ7/Gq5T7brdFFfMJkNecGSd00S7vqKcZ9h+estfXAOub62o91TVpKsPoMXbnAXSKH2dB8mIR2BQPn+/KVW2KDnCXO4R1WYN/Wamv3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l4jZSkkH; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38f3ac22948so1798194f8f.0
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 09:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740332523; x=1740937323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bp/c71pp4cUP+Q5XhkGEkyY9b1dEIZtbSJC0+31Xmy0=;
        b=l4jZSkkHXzzkrN5YZPsiJkjff+yjNtYe3NrrBkaEbMGscdI6XwYVHy61T6WbJlv4N5
         88dgkWLpAc5ZIgb+yWsyjhuRul/OtpEAupD9zgEscxMIydWj/w5FBKQROAVfaEoB4XL6
         9H6rmml0rSwntOas63kwdcQD2QDi49Rdi6Wlg6wfd/bPnO5GvbHJ9lsKyXjKvUgmJabR
         UC8AQVyGzWB3SFRgVk1FkfR8jq21KZJCPAY8+XTFEkZ4u0WQmwTv5cm24u/bt3h0JWDQ
         sGq10TDyGNUeSo8wYTjjWjYmsi7oTsdc6qTJUq/wel8v1S8NphG/0F6WvsPGhGKXPMir
         U8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740332523; x=1740937323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bp/c71pp4cUP+Q5XhkGEkyY9b1dEIZtbSJC0+31Xmy0=;
        b=nufPVbR8XXDIEEy2xwYSTuvSi4Ua5xpBBH4BqGOTBLqCj5nJe+Pceqt9H4VTidECbl
         Qe9PjFLEYLTR6bXFnfHh6ggFv/Kq+C7z+5HK2dm1b/ORfM+RCKMQRtQeIAn5z9EY8eZv
         8I7OKNiI007j+jjC811htRKFkEvt8y80ZunLbv0Z7hxQebANuty2kbyBd/ttMNjp+vjb
         wg8ttBg06rYVDqGRO1mo6UhtryKG6gw3F3oHQv7HPSTbCF9wzy17p2fC33tlpbLazxrp
         p/g+hTR4kUcCGj/WTtTs1LBfSUp57qU0qJrze9qhw16o4VQVWXvEccofIVcNHU3Knx9K
         WCdw==
X-Gm-Message-State: AOJu0Yx+9OLf5tlYr5YN6cEjnZWYSjpQq5OMOp7d20b9TObr3KLKu6m2
	DN0Gj7ct9U0MyD/ajHvYAe/OcQAVYk+OIekpw/a9MOul1PoUlpQNSxGc0Q==
X-Gm-Gg: ASbGncvdr95UYN2aXWyXYqofUW5aeel6A3HSh/w8FrUPNHP04mlqYb0rrpKHJCwLhjW
	xLHynptxq87FhVGdhVMGDBqFr0uQPIRUFH5aN5czI3+6udLGVFB9sHMWZmj6F/CCttq8A939N8W
	vBNLh/m2kl8hm1toyqAkap9ealaoY0eK79iZcW1kOd3UueAzp5l460QEOHnYUS/5CZ9BHXYE+uf
	vzPlGr77vACIkSixK6CU3rhzKhGG219AadvRUpVhjFajrg1BfOOAkwBTGYfztu8aNBvdLBgzZRT
	RLO0ky0QkVJpsTHUcFKzNHZxkxKrHS6t38Fd1qo=
X-Google-Smtp-Source: AGHT+IHJCN7/E31CxYlKd9C6DmH3xhiH3aOLDx5cZegD7PlV96vIy1RTnr8gmb75Dgsi34V2RTXKHQ==
X-Received: by 2002:adf:ec8f:0:b0:38d:dfdc:52a2 with SMTP id ffacd0b85a97d-38f6f093973mr7469765f8f.40.1740332522936;
        Sun, 23 Feb 2025 09:42:02 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5f4fsm29411860f8f.78.2025.02.23.09.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 09:42:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: compile out compat param passing
Date: Sun, 23 Feb 2025 17:43:00 +0000
Message-ID: <f03a112031e9d25f10bca0a3d0b7e4406fc3618e.1740332075.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Even when COMPAT is compiled out, we still have to pass
ctx->compat to __import_iovec(). Replace the read with an indirection
with a constant when the kernel doesn't support compat.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 5 +++++
 io_uring/rw.c       | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 650f81dac5d0..da71067a10bc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -147,6 +147,11 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 #endif
 }
 
+static inline bool io_is_compat(struct io_ring_ctx *ctx)
+{
+	return IS_ENABLED(CONFIG_COMPAT) && ctx->compat;
+}
+
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
 	__io_req_task_work_add(req, 0);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 16f12f94943f..c3849a370a2e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -75,7 +75,7 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
 		return -EINVAL;
 
 #ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
+	if (io_is_compat(req->ctx))
 		return io_iov_compat_buffer_select_prep(rw);
 #endif
 
@@ -120,7 +120,7 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
 		nr_segs = 1;
 	}
 	ret = __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->iter,
-				req->ctx->compat);
+				io_is_compat(req->ctx));
 	if (unlikely(ret < 0))
 		return ret;
 	if (iov) {
-- 
2.48.1


