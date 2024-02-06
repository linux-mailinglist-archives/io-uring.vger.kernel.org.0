Return-Path: <io-uring+bounces-536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D46D84BADF
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:26:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03E4FB2958D
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A75134CF4;
	Tue,  6 Feb 2024 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3co2mPRb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C29134742
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236655; cv=none; b=qd+gFtkwsjtymUeq/jfp2CPISAL+KWu5VxJJO5g9f6+nM/o3SM6sadkPuwSchp7ZbhQX6nY1ZwEC6oxabyeJ5/goYKIyuW76Vqh2zpj9QPOv7Ml//593q6S9PMFlJVKMfBHHewvz/L5d0rYbHheL4zVx9qhUF+toXXL2ixx9F34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236655; c=relaxed/simple;
	bh=/56j+vB4HnzzerVXqOnMuM20+9TN+rJNAf3Nfqps0to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlBpkVxVyGvNSAxLQe6lH2A856Zn9CFAJDLdm/PnaoCqBhmfhzUleJYe3g7D9A3wBclXm9wkqdG3SfwIA7qFQ02yfEEc5J2BpDr//4RvMQ3tK+Pcw/jQ9rFzrIXb9X/U0Dwojbnc2dFDk5OiSxMHj2kXOaJEi94Zb86qPZIKoLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3co2mPRb; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so59110439f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236652; x=1707841452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAW6bkbJaWe8E5VD7l9A+IdcMAJxrlkRYErXBCFfjXo=;
        b=3co2mPRbH0GvuPaMEM7OD7E0BmlVoNrlisGpyatvDVQNSHgn9OcxExB9BzsfrGLhZX
         SZatPBUn24M+ZA+vmga33OT405zjcY8vl0Gopmx6ULhZli9+7ypyz79XKU6n0e+RUwXo
         Es5sQ6AO3+mTXVToZySnl43+dSsa5eZnPADHtCxpsihUpsDwfMVMIlNV/gcdDbcPnmIX
         0AMphKWAuYHdTZ11FbLW8omkpnZ5rBd/F7ar783D3hPPNjW2MsxRR5wiWQiDNloNk9a9
         3YJsSptHmcRkGf2b0sdX3SxDWwxNcRzBWGSdO4aSRp/NLJvIthKZ4OVMaifc8zTH4eVY
         q1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236652; x=1707841452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WAW6bkbJaWe8E5VD7l9A+IdcMAJxrlkRYErXBCFfjXo=;
        b=swSpKW8g5NCTpiewZDLaoTev17acs6YWPKr8If+XE+DnDgjhVgcUe7LfUxqFcEtpor
         yLZPH/U2G1NbwGy8Y0KZpUkUUvfFrWb4SMZPXvXZb2nNErpTuqB/jYS2ded6CQiBlCt/
         jpkBxFmngX45ulwGBUG1xXHlBC2q2j90zk1jNAnSPXg+suusroMKejLSRhd+1RBkJCdb
         B5gzYkYwKJ63Agj+jZfNvjOg6YKsYS451qIL3M0oOaCWZnXjdK1vyka7d/IL78pvT4HE
         gtpIoZFbStRcnAim9qsfX4YH+nV9irqH9TTm+2PkEPpt493JxIFM2rmJ8eYIM+6/rprA
         XXcw==
X-Gm-Message-State: AOJu0Yy4JW90mzcXuivpwas7U1KAvX4ghnhZ60ACwZUE/7QqwnA29fKL
	NHg9tX8ljEBj1NxtD+daLraRnN+STSjX0SNRL8NovQQdOteKCFFGX4i7xD6udu5ojOU19KrUiww
	Z8zU=
X-Google-Smtp-Source: AGHT+IEmbwHmqj4n8YweiZynfDD7xM1DlTxMiLs1bq7ZuexH74RofmFAdWjE4DLBS7CoD/M1zpEzwQ==
X-Received: by 2002:a6b:f308:0:b0:7c3:f836:aed with SMTP id m8-20020a6bf308000000b007c3f8360aedmr438153ioh.0.1707236652374;
        Tue, 06 Feb 2024 08:24:12 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v17-20020a6b5b11000000b007bfe5fb5e0dsm520031ioh.51.2024.02.06.08.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:24:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring/cancel: don't default to setting req->work.cancel_seq
Date: Tue,  6 Feb 2024 09:22:49 -0700
Message-ID: <20240206162402.643507-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162402.643507-1-axboe@kernel.dk>
References: <20240206162402.643507-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just leave it unset by default, avoiding dipping into the last
cacheline (which is otherwise untouched) for the fast path of using
poll to drive networked traffic. Add a flag that tells us if the
sequence is valid or not, and then we can defer actually assigning
the flag and sequence until someone runs cancelations.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/cancel.c              |  3 +--
 io_uring/cancel.h              | 10 ++++++++++
 io_uring/io_uring.c            |  1 -
 io_uring/poll.c                |  6 +-----
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7f06cee02b58..69a043ff8460 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -464,6 +464,7 @@ enum io_req_flags {
 	REQ_F_ISREG_BIT,
 	REQ_F_POLL_NO_LAZY_BIT,
 	REQ_F_CAN_POLL_BIT,
+	REQ_F_CANCEL_SEQ_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -538,6 +539,8 @@ enum {
 	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
 	/* file is pollable */
 	REQ_F_CAN_POLL		= IO_REQ_FLAG(REQ_F_CAN_POLL_BIT),
+	/* cancel sequence is set and valid */
+	REQ_F_CANCEL_SEQ	= IO_REQ_FLAG(REQ_F_CANCEL_SEQ_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 8a8b07dfc444..acfcdd7f059a 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -58,9 +58,8 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
 check_seq:
-		if (cd->seq == req->work.cancel_seq)
+		if (io_cancel_match_sequence(req, cd->seq))
 			return false;
-		req->work.cancel_seq = cd->seq;
 	}
 
 	return true;
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index c0a8e7c520b6..76b32e65c03c 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -25,4 +25,14 @@ void init_hash_table(struct io_hash_table *table, unsigned size);
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
 
+static inline bool io_cancel_match_sequence(struct io_kiocb *req, int sequence)
+{
+	if ((req->flags & REQ_F_CANCEL_SEQ) && sequence == req->work.cancel_seq)
+		return true;
+
+	req->flags |= REQ_F_CANCEL_SEQ;
+	req->work.cancel_seq = sequence;
+	return false;
+}
+
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d0e06784926f..9b499864f10d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -463,7 +463,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
-	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 4afec733fef6..3f3380dc5f68 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -588,10 +588,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 				 struct io_poll_table *ipt, __poll_t mask,
 				 unsigned issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	INIT_HLIST_NODE(&req->hash_node);
-	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	io_init_poll_iocb(poll, mask);
 	poll->file = req->file;
 	req->apoll_events = poll->events;
@@ -818,9 +815,8 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
 			continue;
 		if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
-			if (cd->seq == req->work.cancel_seq)
+			if (io_cancel_match_sequence(req, cd->seq))
 				continue;
-			req->work.cancel_seq = cd->seq;
 		}
 		*out_bucket = hb;
 		return req;
-- 
2.43.0


