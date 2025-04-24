Return-Path: <io-uring+bounces-7700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 045EBA9ABCD
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 13:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6748C1B601FF
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 11:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF85221FAA;
	Thu, 24 Apr 2025 11:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Er0zpE09"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C04F2139D2
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 11:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745494214; cv=none; b=gJ/wvukwI3y9DY8bS2QzdJbSO+KkThGpEgV4vjHoqFHQTJ3eqCEAPFvDh4w2iLCdfKcVPkVZuHHXrA4rCMl1ILbLjwj+PCnIeb7TVion9YU5yvFSDLQ/gcvxMFndwzy76Gf/rFdXbjL7MMXf5H4xcI0rcZk7iWinzKAZHZoRktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745494214; c=relaxed/simple;
	bh=d1MlqbNIFeH+Ul++ZS0/zVHPT3UN5sv+M9W850tg9FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJBstger2sakMeA4//+1De95NoE5ldLPhdiPfGDRPMz6TV2TW/gvSN/UH2EZ7NjcKRC3JvfH0VVWis279aiDv1cspMRAsCPB7GZ7SXkBbMzV9BI4OtM2Vp2YYgo5sMNoQSW36E/K5os60JCaV+ZOp4O2IpI0UJKp4dOa6vYuavc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Er0zpE09; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac2aeada833so186738166b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 04:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745494210; x=1746099010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VIIOg6X16400H3hvjB+k8PITrxmeIP/qXAnyr6M1mNg=;
        b=Er0zpE09lpIgfE3hKGSeIVKNp0h0NgoEGMPDb9mm9V1FD7POam0PXks4+Y2l6aYkKm
         MippLtmbVjgNbfuMeCLphzB9hg7kcvH1cMYK2pvFUmNNHPVXghVshR8ebnmAXAgWr/47
         kFUTynXULz2SJCZQlOJkttiIufjq9zRQ6QKIuEJkX2zsY88ublKOWZg5dOFrfthnY1f0
         qHY2JM44ChzT5UjeCSPLnd0amZA6FMPyNNksE15KycUUPdnRTwRITdcSlZQ+oZ3EeE2z
         IZyAIA1Mds0Y8SeHFGDVuwLOb591pgWOp5Z4rZAcXwp1gHCatMCMoj2POpxKxjZNflRi
         oqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745494210; x=1746099010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VIIOg6X16400H3hvjB+k8PITrxmeIP/qXAnyr6M1mNg=;
        b=I0cgEPahmzHINPyx4dJR725z+kqommZQxT24e/+ZlBc7In511dZpgadhs5RPEfjnGv
         C7MzwhbxfLH2fKaHT8h4MjjZetYU2T+65WMUOTciH2jMy2xODOrfaPwNe3VqLzU6fO7L
         YvxxEQ1iDKhV6ClGBWLravFAT/dpZlWxTLQ4Hviw9U22LOxOdlwWOCa8fPLXB2ZKs5o3
         XoyKG1u7kVGkzn27ODP1MK/gXVbFa+MQDro+m5CrT++ylPX4xzgZZQ6gHSKLgOY9NUw0
         oQ9iX1ahhTTvbgVEewtwOjdY0t37TMPGl+D9/ir+p67GRN48+LPV0dbPm+Z17/0Z2UGg
         xQAQ==
X-Gm-Message-State: AOJu0YyOVIYB9LJlPrQcLEluisLAykwFW89S0IyoIIKGZCxCejVlCfzN
	Wq93AeK9V79akzHIqmrIdkbLAM+5KgD/rAwOY4rArAlClzBVjafycSrqVw==
X-Gm-Gg: ASbGncvpzgBrOG8mQ302A44+yREYKHfN/WAPKRXd3xhhgiYkS2Ov29bsjlPJNHvOGc8
	UKFosX0PirhJtaXKJg2BW/4lfc42Nvzl+2pMZXlTSTkOMh9uUx3ypUmPlMAnN5VjHfk/o3rOuo8
	/2kWZZpqU0NA+QZmwYe3cvRXgKdMsoF9G0cnIbn8eSFDUC0kfDq5ZIOfBd1gVKDkGWrqbDJhMqh
	J+itZKwzLKG+F79Qrk8qjVcnhusC+GxS1SOwnW9zF63O5AQ9OJNQ01W0sd1A3LQBuCDQ5qcVGdp
	CdBsAVKmKpvdvjgJAmLaVbLC
X-Google-Smtp-Source: AGHT+IFyZmgHLfQT5e4GaADa1uPszSgUDKe0JfMIVfMZGyL+kw8NMOJ3lhOoqDW9XdNRXXFvBU1xFw==
X-Received: by 2002:a17:907:1b09:b0:acb:a7f6:3b7a with SMTP id a640c23a62f3a-ace5a27b3f6mr182795966b.10.1745494210070;
        Thu, 24 Apr 2025 04:30:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c716])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59c26316sm93675266b.151.2025.04.24.04.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 04:30:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring/eventfd: dedup signalling helpers
Date: Thu, 24 Apr 2025 12:31:16 +0100
Message-ID: <5beecd4da65d8d2d83df499196f84b329387f6a2.1745493845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745493845.git.asml.silence@gmail.com>
References: <cover.1745493845.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate io_eventfd_flush_signal() and io_eventfd_signal(). Not much
of a difference for now, but it prepares it for following changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/eventfd.c  | 26 +++++++++-----------------
 io_uring/eventfd.h  |  3 +--
 io_uring/io_uring.c |  4 ++--
 3 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 100d5da94cb9..a9da2d0d7510 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -112,23 +112,16 @@ static struct io_ev_fd *io_eventfd_grab(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-void io_eventfd_signal(struct io_ring_ctx *ctx)
+void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event)
 {
+	bool skip = false, put_ref = true;
 	struct io_ev_fd *ev_fd;
 
 	ev_fd = io_eventfd_grab(ctx);
-	if (ev_fd)
-		io_eventfd_release(ev_fd, __io_eventfd_signal(ev_fd));
-}
-
-void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
-{
-	struct io_ev_fd *ev_fd;
-
-	ev_fd = io_eventfd_grab(ctx);
-	if (ev_fd) {
-		bool skip, put_ref = true;
+	if (!ev_fd)
+		return;
 
+	if (cqe_event) {
 		/*
 		 * Eventfd should only get triggered when at least one event
 		 * has been posted. Some applications rely on the eventfd
@@ -142,12 +135,11 @@ void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 		skip = ctx->cached_cq_tail == ev_fd->last_cq_tail;
 		ev_fd->last_cq_tail = ctx->cached_cq_tail;
 		spin_unlock(&ctx->completion_lock);
-
-		if (!skip)
-			put_ref = __io_eventfd_signal(ev_fd);
-
-		io_eventfd_release(ev_fd, put_ref);
 	}
+
+	if (!skip)
+		put_ref = __io_eventfd_signal(ev_fd);
+	io_eventfd_release(ev_fd, put_ref);
 }
 
 int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
diff --git a/io_uring/eventfd.h b/io_uring/eventfd.h
index d394f49c6321..e2f1985c2cf9 100644
--- a/io_uring/eventfd.h
+++ b/io_uring/eventfd.h
@@ -4,5 +4,4 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int eventfd_async);
 int io_eventfd_unregister(struct io_ring_ctx *ctx);
 
-void io_eventfd_flush_signal(struct io_ring_ctx *ctx);
-void io_eventfd_signal(struct io_ring_ctx *ctx);
+void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7099b488c5e1..33d1a6b29b46 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -584,7 +584,7 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 	if (ctx->drain_active)
 		io_queue_deferred(ctx);
 	if (ctx->has_evfd)
-		io_eventfd_flush_signal(ctx);
+		io_eventfd_signal(ctx, true);
 }
 
 static inline void __io_cq_lock(struct io_ring_ctx *ctx)
@@ -1204,7 +1204,7 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
-			io_eventfd_signal(ctx);
+			io_eventfd_signal(ctx, false);
 	}
 
 	nr_wait = atomic_read(&ctx->cq_wait_nr);
-- 
2.48.1


