Return-Path: <io-uring+bounces-6130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC0E5A1C5DA
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2025 00:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E805E167398
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 23:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D631DC9BB;
	Sat, 25 Jan 2025 23:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="yHMXZCUM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5C428382
	for <io-uring@vger.kernel.org>; Sat, 25 Jan 2025 23:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737847732; cv=none; b=TpURwedh5C0wvwEf9gt84RVxjg89Kc77tBlvYlcEzbzTjzgFwwbptM3XJxD9yNlkVwykNVmxC//laCuM14hBQbkpuJ1XyOhHSi2iAc9s9LyCcisZZc98pv/c4CaB6s5CrPa9xJS4TxHKbKStP6wO3qiUZPyDFXmtFOCNl3bxub4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737847732; c=relaxed/simple;
	bh=G+tUC0f3mz4wDv8ec0oi2mTL05Vsk+tba2HbpxnXgNo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S7TvtzyRtnho63z6AEvy//7uoOpKbWseQsHMXy3Qz1/veld9emxI40875HOV7niUmIaIlU43VcYFaQ4s3oz9vZLkmTUxGHcXoSYd5Z7Nv3qQbr49UUOmNeV9x4q90Uio6yD6TfRP488bJdy41fhsINzMha/kmusSsdZIvCUwnjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=yHMXZCUM; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2164b1f05caso56402905ad.3
        for <io-uring@vger.kernel.org>; Sat, 25 Jan 2025 15:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1737847729; x=1738452529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IliF+Bv/sVisP9lZ6WrM4MwssKqrEeG8oNSkL9Tke+A=;
        b=yHMXZCUM/qSVlSYgjQLV9QbffKWQc6q60S84FW1GOX0rdA1dUIkAtqCAlKs4LsW+JL
         dwujT/A0UQnW+CZfjCFGFXAMwlSBUHV/29f0Qwn7oQ+AvRbpClBNSUllKIwRr/Mnqhwa
         HkQuHU04oV0Q0gbDKamMuFERmLPMhcmKkm1q/htMnqvW1WPUFNsRyoe3rp/BqiPwc7j8
         Yaa0R3L9WiccnEWJAUP3xYemFMnnr5euvMYofl9Ycdw8qNiTIWTHNCgBEXjoxH9mVDAT
         t2XU8I/uMyA+ye33WMG9+7+bYqWTgEZFwsSqvklDUac+L5GGiTQKI8Xla3B+mKg2LSkf
         R1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737847729; x=1738452529;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IliF+Bv/sVisP9lZ6WrM4MwssKqrEeG8oNSkL9Tke+A=;
        b=g8bhfFdFEJbU/06ZAHsNzFc4qx1CHJq+ivvFwoh1zknEpNUa9dBAhNiPK4guvOQN70
         XARkd/LZpB7/WO3jAAf1bOh7zPkYpRKQpPW2RFerrkIp0B5XN1SHWCbDfmmIq5KOKa1I
         ZrvPlN7uZMroYhN7pn60GVm9uMJc4H76qQ1My3cJ4doc0IQsrdRcNXCUYFZkMpazGKZJ
         OOei5MMe3dgybZkyB4oMrEvaMXImx9cJaafLk44tu5rjCf6KdavMcjc3iiFcN0/bxSsz
         Q7GkrYrz9rzHDh8BFrHiWEIjQ/UmNbBzZZIDGh67gK1QBRth8AQ6XQCOPaMgRB0x9TGq
         tjng==
X-Gm-Message-State: AOJu0YyOIpuQenMV9DlglDQdeJkRGgbbgvBFQABxsltR75YMJbB6ReKx
	lz5L9Q0A6o/nzf37z7cKqzok4sN2NZe8zGGFG5ZPEzFKM6lDEXvtGLIqZbndZqNgrFJLhT+8YMd
	m/EY=
X-Gm-Gg: ASbGncsXgRindQ576Lvbqi9DOxgwcrkd/WxlAz2fqQsxnagoCTyDn67OBtimDqDkCV+
	1s9p6It3YOA1zcpuQdq6ZxsGwi4cq+wZc8XZFdzd0LmRNnTIY2uReLeRj/R0qWwzwh6IGRLbRJW
	fsXKAyOVCZFQoOwEhJfRiQj54ioCi/YS8GTyZ5jbWlak7pp2zyLM6LARmOhe4b4HULc6/S5kj+e
	HhF9e/r1bFPCnOGqx1v3gjxFlxlBsXDejopvV+1kUiyW+tuyBvUtGKX2YJszDqHaq9AmhOz+42R
	cg3FxL+JBgvd/IpY8IU294lrEUf3aqD73ZwdOjldudE=
X-Google-Smtp-Source: AGHT+IGi/IzyVFVAgiko2XcrB+AYIXSckWw/IGBE7luDs4rmorgYOff0seKx9KteymiS5w87R3M98Q==
X-Received: by 2002:a17:903:2406:b0:215:9ea1:e95e with SMTP id d9443c01a7336-21c353ed537mr519354175ad.13.1737847729341;
        Sat, 25 Jan 2025 15:28:49 -0800 (PST)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea5546sm37716615ad.98.2025.01.25.15.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 15:28:48 -0800 (PST)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: io-uring <io-uring@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	lizetao <lizetao1@huawei.com>
Cc: Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH v4] io_uring/futex: Factor out common free logic into io_free_ifd()
Date: Sat, 25 Jan 2025 23:28:26 +0000
Message-ID: <20250125232828.10228-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces io_free_ifd() that try to cache or free
io_futex_data. It could be used for completion. It also could be used
for error path in io_futex_wait(). Old code just release the ifd but it
could be cached.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
v2: use io_free_ifd() for completion
v3: format, inline, remove reduntant init.
v4: inline static -> static inline format
---
 io_uring/futex.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index e29662f039e1..6d724435cf23 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -44,6 +44,12 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->futex_cache, kfree);
 }
 
+static inline void io_free_ifd(struct io_ring_ctx *ctx, struct io_futex_data *ifd)
+{
+	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
+		kfree(ifd);
+}
+
 static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	req->async_data = NULL;
@@ -57,8 +63,7 @@ static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, ts);
-	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
-		kfree(ifd);
+	io_free_ifd(ctx, ifd);
 	__io_futex_complete(req, ts);
 }
 
@@ -321,7 +326,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_futex_data *ifd = NULL;
+	struct io_futex_data *ifd;
 	struct futex_hash_bucket *hb;
 	int ret;
 
@@ -353,13 +358,13 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
+	io_free_ifd(ctx, ifd);
 done_unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
 done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	kfree(ifd);
 	return IOU_OK;
 }
 
-- 
2.43.0


