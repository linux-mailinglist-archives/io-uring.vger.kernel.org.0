Return-Path: <io-uring+bounces-7928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C645AB11EA
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A9CA1B61F0A
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8038C28F95D;
	Fri,  9 May 2025 11:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mllGkYMN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A555027AC2E
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789115; cv=none; b=qhG/2jBDmyJOwHSQVWox/vL0P+wkPEFxZ3of47ColtvAgLd2BIe+Fjk8ilR9tdM8SPqFTFsvyZFd8+Rjr7mVQVGfo8ZdCdhh7xhRN2SGwXNITQH6sD16/cHB1zYIPN7PJSUceL8ovqavf6n9DF9FzfnWCzy7EMk+OsHHcjqNeSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789115; c=relaxed/simple;
	bh=iiNhkIfllxLrkup0gfhEgatf3AALGYkGkAvnuixgp3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jptj+67u5yImkm5KZiJ3RzGD8ao2ZPyzKSxh7GS/lqI6qBk3LWlD8K/ZJLwUG+uK0kNKGTBZ0t4dHBYYvWgBqzkABYjwYkhABegxjzWHbwEwu4MjstGdSbDxn4rrk3CWenTUHRnyZsCOb7vogT20n9jMwUHLNSRZs7XKzLKUKpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mllGkYMN; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ad220f139adso96506066b.1
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789110; x=1747393910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGNPKoRicqC4sOT/X5D7ep+8xCPel2T4gbtVz/uPxSY=;
        b=mllGkYMNbe65oLaQUHJLXqNRoXMdOLFHTzdadpmTTZfXw6rddeVBY1f121Iswya/tm
         ZJ+/xHWm6O9rE3CgkPcydB4qGQ4LopO89bb+ncPKg9cWjbxBU/gTWqlpvnEmNsu493zY
         CFjz8KGxBMWvZzkJgS96VLHaPobcOOiNjygE2mjf2lN8JBBSlt/Io5tmvyce5nxyC+Ro
         KXoD98KEZVS3Esagy7wcRqLEqeZrXfd/8DwqJ3ZyweK0FNlmfJw8jzCbgWR85uOGqi5S
         BIN+XlMviYL36kWPGl+4+RBRppceDPbASGqcOupH1pZJirAfHj3Ofv100Rzt0h3YwvAt
         IuBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789110; x=1747393910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGNPKoRicqC4sOT/X5D7ep+8xCPel2T4gbtVz/uPxSY=;
        b=N8ek/R1gbUWYAmdL2fsqWkUZmGG8Q0QrxpADhbvO45UOCA2I0+0BZnjHCw45vUTvSy
         +h7zm8S8F/ikpRqPxm5sHWcTjV2Dd5Hz5D9XWaNVpCKqzR/ceNUbPxXTH/7ksjuUh3Uu
         rJdDXmrfBsg+L5jDr9cu2OClM1ZdNPyTd9B0sRYQ3ZjbWTqvog8mAhqcwsKLDPEEOZCT
         JKx24LDKBsclh9Pj/oOpwJBaDhAenIC6BbgLAVYYkKknzX7ZXzrRpKqI+j1WNq+FkVnU
         TaOwgY388Ws6esixZ2XCemyggL47f4dhgKeQE7rv3femtRjTAGezcWp2gTFCSV+tFHvX
         CNUg==
X-Gm-Message-State: AOJu0Yz5QIVafb2aWb4ZAsoJnhTRIG5ZaNjp0CTERru+Sd0cDYVG8fNi
	Mq2iDwb4L3g/2OsAvcL0zUTnJARjlCAHIHsvQKzSUpQni91WbGpwbxTS9Q==
X-Gm-Gg: ASbGnct5TPda4zgwWCG9qrb5B2IOADMCp50vC3wtu3i4lY9InDx5joEF+aLmori8450
	Sk/z1iSyCFDIPNvamTpxksIHusNldagxwwmFCA9tzSVjH3CgDlsOgAXiGkl8IUY8AG1Y2KXJJyM
	dJ0mV6vw53k1jFdt6DGR9vpBcx4sHNYGC5ovWHSfBdPawhcpwLXDTCsFFWIEhSIiFCrVHH+xgbk
	v7uGR/5n79UpkyslJQVlsl08gpYZTg6q6Zs8HEcmmtD4TGL21AlubnHr7rFa+81IV4pl8oRHC3Y
	Y3p3yiwKPPda+jdsqo+pl0zF
X-Google-Smtp-Source: AGHT+IGoMDl0nxaFK8M528dg54aSdg+UajbpLstzyrYhZZagRFbFW8BDLp4Hs2Czk0fB4Z8yta3eDg==
X-Received: by 2002:a17:907:9709:b0:abf:733f:5c42 with SMTP id a640c23a62f3a-ad218ea8374mr285659766b.8.1746789110137;
        Fri, 09 May 2025 04:11:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 5/8] io_uring: consolidate drain seq checking
Date: Fri,  9 May 2025 12:12:51 +0100
Message-ID: <d4651f742e671af5b3216581e539ea5d31bc7125.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We check sequences when queuing drained requests as well when flushing
them. Instead, always queue and immediately try to flush, so that all
seq handling can be kept contained in the flushing code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e3f6914304a2..0afae33e05e6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -389,17 +389,6 @@ static void io_account_cq_overflow(struct io_ring_ctx *ctx)
 	ctx->cq_extra--;
 }
 
-static bool req_need_defer(struct io_kiocb *req, u32 seq)
-{
-	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
-	}
-
-	return false;
-}
-
 static void io_clean_op(struct io_kiocb *req)
 {
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECTED))
@@ -566,11 +555,10 @@ static bool io_drain_defer_seq(struct io_kiocb *req, u32 seq)
 	return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
 }
 
-static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
+static __cold noinline void __io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	bool drain_seen = false, first = true;
 
-	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
@@ -584,7 +572,12 @@ static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 		kfree(de);
 		first = false;
 	}
-	spin_unlock(&ctx->completion_lock);
+}
+
+static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
+{
+	guard(spinlock)(&ctx->completion_lock);
+	__io_queue_deferred(ctx);
 }
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
@@ -1668,30 +1661,26 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool drain = req->flags & IOSQE_IO_DRAIN;
 	struct io_defer_entry *de;
-	u32 seq = io_get_sequence(req);
 
-	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		io_req_defer_failed(req, -ENOMEM);
 		return;
 	}
 
-	spin_lock(&ctx->completion_lock);
-	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
-		spin_unlock(&ctx->completion_lock);
-		kfree(de);
-		ctx->drain_active = false;
-		io_req_task_queue(req);
-		return;
-	}
-
+	io_prep_async_link(req);
 	trace_io_uring_defer(req);
 	de->req = req;
-	de->seq = seq;
-	list_add_tail(&de->list, &ctx->defer_list);
-	spin_unlock(&ctx->completion_lock);
+	de->seq = io_get_sequence(req);
+
+	scoped_guard(spinlock, &ctx->completion_lock) {
+		list_add_tail(&de->list, &ctx->defer_list);
+		__io_queue_deferred(ctx);
+		if (!drain && list_empty(&ctx->defer_list))
+			ctx->drain_active = false;
+	}
 }
 
 static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
-- 
2.49.0


