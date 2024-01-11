Return-Path: <io-uring+bounces-391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3077982B618
	for <lists+io-uring@lfdr.de>; Thu, 11 Jan 2024 21:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2C851F2063A
	for <lists+io-uring@lfdr.de>; Thu, 11 Jan 2024 20:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E311E4A6;
	Thu, 11 Jan 2024 20:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oK+ZHOZN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4CD57320
	for <io-uring@vger.kernel.org>; Thu, 11 Jan 2024 20:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7bb5be6742fso67507939f.1
        for <io-uring@vger.kernel.org>; Thu, 11 Jan 2024 12:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705005447; x=1705610247; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+JGOtMTWV3OqbcmLwDN3Bz+xOi7JRUTL3UhvMXpKgZw=;
        b=oK+ZHOZNAcpCi0V396bzQDtEETl+7CghEHIC7VCV5XX/UZKeB4EeUHQdiSiNHbfGKr
         iPzUofxkzxxASRqokSvzQo4Bl6vlyltrTSnWxBBGRBFv6s7eBMmUKdYGNhw6YnDjfOAn
         1KgsYdxlBRQK0N9iP2tNDFx0Gf4EOwnp8nPhY/4kub5eW1gPx2/gAoXL0+m0ZhjYaQGq
         YwIwZfGWEGWhC/JUpREHwqYDOrzaedDuV+2odR9O9dT/fugemKfN7YkDAWKGEBthQGPI
         05YCmt9kvHRWJk+Y285QhX7MfiuLXicC/8k+G9Q/wrlPL8ufMgbxpkyVe1zuikgN1ySB
         HoGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705005447; x=1705610247;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+JGOtMTWV3OqbcmLwDN3Bz+xOi7JRUTL3UhvMXpKgZw=;
        b=TCKQcVmcsANjL/uSC3PH6Y7Xq2oZJXkysPOFGpesYZ8PMiUle7KKL/AvTwREls7ZeF
         bCJQVxMLq0SthvYwNqv/yvnEBP6/lTDgu3shckmsMYTBkj27Ig7NmXB/c4MDAo1ph6lI
         vlZJhMG8tPJQ/sow/1tYFTv3ZuNfGyQTyMPGfqU7rzo6799X9/jpsv/ZOVG7Dn/FyxMx
         c+7F0JGOdztMqv2U8+aJzKlZL5vpfNzHk1UCmLW9i1o1F+p9y4ZnTQkxkepQ8Hi4r5qh
         Ui4vgI/YMr8rKwaVjIey4qZJt5xyeEn0u/cflhaVl+ruhy+dRzvI81R73icfWUI9/pQj
         WCog==
X-Gm-Message-State: AOJu0YxqRMeO0VDBHEcbBPdid/1S72u9E/bYkA17fIdp/njwHuzsAPJi
	/3imSePlCXBqwTcRRV39m3hFoqjySexZLPpMPRVYRx+qXAGStw==
X-Google-Smtp-Source: AGHT+IHQHr/gslk4bzEOcLoaUz4floJqyVKZk/PHAv0TbWde++oNPyei81KZwY9xuHDZPaiyO89fDw==
X-Received: by 2002:a6b:4f04:0:b0:7be:f413:e410 with SMTP id d4-20020a6b4f04000000b007bef413e410mr453734iob.2.1705005447122;
        Thu, 11 Jan 2024 12:37:27 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d25-20020a5d8899000000b007bef967dddesm427771ioo.48.2024.01.11.12.37.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 12:37:26 -0800 (PST)
Message-ID: <14052c5f-0ef7-4e19-9dbf-fdb5d8e7a557@kernel.dk>
Date: Thu, 11 Jan 2024 13:37:25 -0700
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
Subject: [PATCH] io_uring/rsrc: improve code generation for fixed file
 assignment
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For the normal read/write path, we have already locked the ring
submission side when assigning the file. This causes branch
mispredictions when we then check and try and lock again in
io_req_set_rsrc_node(). As this is a very hot path, this matters.

Add a basic helper that already assumes we already have it locked,
and use that in io_file_get_fixed().

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4afb911fc042..50c9f04bc193 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2000,9 +2000,10 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 		goto out;
 	fd = array_index_nospec(fd, ctx->nr_user_files);
 	slot = io_fixed_file_slot(&ctx->file_table, fd);
-	file = io_slot_file(slot);
+	if (!req->rsrc_node)
+		__io_req_set_rsrc_node(req, ctx);
 	req->flags |= io_slot_flags(slot);
-	io_req_set_rsrc_node(req, ctx, 0);
+	file = io_slot_file(slot);
 out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 7238b9cfe33b..c6f199bbee28 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -102,17 +102,21 @@ static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx,
 	node->refs++;
 }
 
+static inline void __io_req_set_rsrc_node(struct io_kiocb *req,
+					  struct io_ring_ctx *ctx)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+	req->rsrc_node = ctx->rsrc_node;
+	io_charge_rsrc_node(ctx, ctx->rsrc_node);
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 					struct io_ring_ctx *ctx,
 					unsigned int issue_flags)
 {
 	if (!req->rsrc_node) {
 		io_ring_submit_lock(ctx, issue_flags);
-
-		lockdep_assert_held(&ctx->uring_lock);
-
-		req->rsrc_node = ctx->rsrc_node;
-		io_charge_rsrc_node(ctx, ctx->rsrc_node);
+		__io_req_set_rsrc_node(req, ctx);
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }

-- 
Jens Axboe


