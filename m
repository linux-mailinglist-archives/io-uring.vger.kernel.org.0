Return-Path: <io-uring+bounces-577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EACB484CFA5
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 18:19:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2955D1C21E61
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA2B7811EC;
	Wed,  7 Feb 2024 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M3nelOSY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02806823D9
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 17:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326390; cv=none; b=STePHle7zCByi2WAMXUjVg5I1J5LtIhH6dVRbe3RLUERvbE8IYDSIfBPStLOUwvrw5s0F66+ytEFHKnybvW0z6dC9c+C4glX9VIs7m/kOS9vo46OiHro4PalUkftQD1a7m09KcU/DzJebs40MMD93NYAEH8xAkDXfafLFMPGDDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326390; c=relaxed/simple;
	bh=Vx2z+uKGYqAboyyvt/fRTruzvgWgXrTGSrxi8X8tqm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6H56WNZ8lJCO3AM6Io8oqwQCB5DGGPwnFEkJy2C7vbnEfvhJct8c3sh8s3EDbZ02TjTbTAyfAgNAKBMBT9FVrM0J+ffY6BbnInwvfTo9c7tfhxFvfOkjbEv2VT6zB42IaV/8BVIbONjAKhhTTuLrdps8PO5KgTG6n9je3536Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M3nelOSY; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-363ce7a4823so1208595ab.0
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 09:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707326387; x=1707931187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0u+eIWzkQ4RfJkBwW7+VLDljeFRsQAnKe6PYkaLIvo=;
        b=M3nelOSY06VjrBvu4ihUcZhJxXWJMqVxnRPyqVvVyWKaQTBydJbxLRYr0SmtB19I61
         JvTHYAVMHMpLxrCsOewKsq/JcRiHi7uy82xPLrZQqhvMWpcY4mMeZ9hGENJXgyNMbitn
         8c/VBoO6am4QuCgERkN+NPs60Ch2A5WCbiHEWZ/0PBtQRDmCbetk5rg/qLVYrDnyg1LF
         R2KHNAHKSyi8QrPKP+a9xKBdn4bky2C/HJAeix6x5XtnnFO3pER3zug0poVuRvvbGze2
         tYylZ8zD8I6mBw1aAW7o/gDXnbDCb/rXh6JPh7poiM4dabFSykahhv5s2f290fJ1qk64
         2nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326387; x=1707931187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0u+eIWzkQ4RfJkBwW7+VLDljeFRsQAnKe6PYkaLIvo=;
        b=rDTdpzR+tAP+nJTDwmRY9FL7w0OHGEW+kgr+IYAyDtalBQB8s00VLEDPvw7q/M0VU0
         V+kzZv0fjD2WHzp/xjJz08plhhHAu3FLJWQHbcL84JUNB7QDg7qFrcVr5x7OUPb3IymT
         2lV4rSvE7lh70frCF7yyrYrZEsG0vhN2v4qz+MgPIfuvHO0m6BbQzffvnp1KPm5Vz3p2
         z214HDsmGjCoRpIFrJkRyCaxi67Jw0mD8QFaK78HYUbeakgPclSsCtXKUkhiOCYQy3yY
         8SRYBY9YBfe+EaLoKYq7rNuqYWHKssVNHYu6E225UNw4pWvy4SjCEaZ2yc/hW7fL0Ypp
         QIjg==
X-Gm-Message-State: AOJu0YwmY3C7nNp8KmcwG5mHoRI8OADqi58TOxd/uTdBvbufk04ISI+b
	eOVPgG4w6UsDktIVK9URaKYVzn+SGFdhLotn/SEbfOQI0tcO/wZxITYpDzF0UnArrfcBoJwS4Gi
	wRkE=
X-Google-Smtp-Source: AGHT+IFMcJyYz1ZfvNNdLAPGFscCz9QhBJBkOeq1LVGqeqAvdsiKH6GBuwfdGasrvnYTLhkOA9RZug==
X-Received: by 2002:a6b:3e42:0:b0:7c4:606:6501 with SMTP id l63-20020a6b3e42000000b007c406066501mr610204ioa.2.1707326387542;
        Wed, 07 Feb 2024 09:19:47 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g22-20020a6b7616000000b007bc4622d199sm421131iom.22.2024.02.07.09.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:19:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring: add io_file_can_poll() helper
Date: Wed,  7 Feb 2024 10:17:37 -0700
Message-ID: <20240207171941.1091453-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240207171941.1091453-1-axboe@kernel.dk>
References: <20240207171941.1091453-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds a flag to avoid dipping dereferencing file and then f_op to
figure out if the file has a poll handler defined or not. We generally
call this at least twice for networked workloads, and if using ring
provided buffers, we do it on every buffer selection. Particularly the
latter is troublesome, as it's otherwise a very fast operation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            |  2 +-
 io_uring/io_uring.h            | 12 ++++++++++++
 io_uring/kbuf.c                |  2 +-
 io_uring/poll.c                |  2 +-
 io_uring/rw.c                  |  6 +++---
 6 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e19698daae1a..4ddc7b3168f3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -464,6 +464,7 @@ enum {
 	REQ_F_ISREG_BIT,
 	REQ_F_POLL_NO_LAZY_BIT,
 	REQ_F_CANCEL_SEQ_BIT,
+	REQ_F_CAN_POLL_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -538,6 +539,8 @@ enum {
 	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
 	/* cancel sequence is set and valid */
 	REQ_F_CANCEL_SEQ	= IO_REQ_FLAG(REQ_F_CANCEL_SEQ_BIT),
+	/* file is pollable */
+	REQ_F_CAN_POLL		= IO_REQ_FLAG(REQ_F_CAN_POLL_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fd552b260eef..17bd16be1dfd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1968,7 +1968,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	if (req->flags & REQ_F_FORCE_ASYNC) {
 		bool opcode_poll = def->pollin || def->pollout;
 
-		if (opcode_poll && file_can_poll(req->file)) {
+		if (opcode_poll && io_file_can_poll(req)) {
 			needs_poll = true;
 			issue_flags |= IO_URING_F_NONBLOCK;
 		}
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d5495710c178..2952551fe345 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -5,6 +5,7 @@
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/kasan.h>
+#include <linux/poll.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
@@ -398,4 +399,15 @@ static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
 		return 2 * sizeof(struct io_uring_sqe);
 	return sizeof(struct io_uring_sqe);
 }
+
+static inline bool io_file_can_poll(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_CAN_POLL)
+		return true;
+	if (file_can_poll(req->file)) {
+		req->flags |= REQ_F_CAN_POLL;
+		return true;
+	}
+	return false;
+}
 #endif
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 18df5a9d2f5e..71880615bb78 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -180,7 +180,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
 
-	if (issue_flags & IO_URING_F_UNLOCKED || !file_can_poll(req->file)) {
+	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
 		 * If we came in unlocked, we have no choice but to consume the
 		 * buffer here, otherwise nothing ensures that the buffer won't
diff --git a/io_uring/poll.c b/io_uring/poll.c
index c2b0a2d0762b..3f3380dc5f68 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -724,7 +724,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
-	if (!file_can_poll(req->file))
+	if (!io_file_can_poll(req))
 		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..0fb7a045163a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -682,7 +682,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	 * just use poll if we can, and don't attempt if the fs doesn't
 	 * support callback based unlocks
 	 */
-	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
+	if (io_file_can_poll(req) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
 	wait->wait.func = io_async_buf_func;
@@ -831,7 +831,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * If we can poll, just do that. For a vectored read, we'll
 		 * need to copy state first.
 		 */
-		if (file_can_poll(req->file) && !io_issue_defs[req->opcode].vectored)
+		if (io_file_can_poll(req) && !io_issue_defs[req->opcode].vectored)
 			return -EAGAIN;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -930,7 +930,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	/*
 	 * Multishot MUST be used on a pollable file
 	 */
-	if (!file_can_poll(req->file))
+	if (!io_file_can_poll(req))
 		return -EBADFD;
 
 	ret = __io_read(req, issue_flags);
-- 
2.43.0


