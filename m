Return-Path: <io-uring+bounces-3675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3D399D894
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 22:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D28261F22025
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 20:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15F81D174F;
	Mon, 14 Oct 2024 20:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zlolkWwF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC051CDFD2
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728939267; cv=none; b=PSsBioSiC5AJWpSKvGpDzBS1xSCtPb2Z63xfH8/refCu9zZqCug1fOwsPLqp8ia5dea11zZo+cyBBL/zY8/C0XT7tZzJdlqH99EpNrt/sRxgBklJqCdJEXaPFY+6WllcCuA/qjK0vH5hYChQG8HW7do/gvm1XsD1WfXPUxumW60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728939267; c=relaxed/simple;
	bh=X6yM1ysWrwvLR/A4bHLQWE0RVyfG/maA7GFnPoGJlKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKaG2WQXIgsPsweNSwV+Gw8gftCFydQbD8EtZKDvUF2HPkKBlw55gP3xvYQ24P+OdD/DtfjEnJJGkZ9q6QbVKWNM+Y1nxOw2X6yA1md0q2DYUhRHgvVJV5eNVfONY2odjfYgWYGNopHyn2ztyV62CNqNcloTNBF3Vys7VuvnPWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zlolkWwF; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-835496c8cefso281402239f.0
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 13:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728939264; x=1729544064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbP3JkI7Mm5xzwedpdCbAEUYoYaLTWmGdma8DF8byKk=;
        b=zlolkWwFawliHk9YdzeklQSvtXG6hdNzE7iGx8TihbQwqjyOWzN+6/nJlfhSy/YRnI
         uWUeqcvRnh1TU+xfWxMSNxFpcKg6J+BQHmN11UU1L7c9DOo22IXQ3iEiD1B/stvBfpuc
         UphsB7plQXTWwpQNsCsJ4EDM2CiLw8oOE7um/RzyO165zY2Bx9V/q1/zYOLWqRzBlaEX
         QWo2nSjuPb96t5qm8++KpnQG63N4eHLEhQfkhpZU4FVoFW7agxxPVzqtArqr9kNZClj/
         2jXWMJClN3oEW+SdBlkdfu8pPx1mCSa5VyhEA54mTnjXqBVImt2ZJckUk7Uxawq8uB30
         /euw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728939264; x=1729544064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbP3JkI7Mm5xzwedpdCbAEUYoYaLTWmGdma8DF8byKk=;
        b=Zev1SDoxw8vxu9/pYvXm0KqvoNktssJVZmZnBxASBJ9alQfSEpljbxGNGgwk/Zo9ZD
         KsJiQNviFYbjs7dHX0za6BfOwUd42RABghpKj1T/RheT407cRB5T9pUhX/obcw2z6Gc5
         Dju05yRAairiOpoF1CJvNN4dXgFz9O59+8wXWTjJw+gWO4PUdxHpVZ2lEKmOB1olZ2T4
         MFx3DVi17xe1LxNGYpjx2/R66MzZ3iZsCmnRwIf0jiG/rf/GGvTgLN0hA1qwIq5IDouw
         Blv0RvjwKPh/Qglme/cyKHe9+J+sipOrgJObURSy6pg++0om9GrO8NnTC+bdfUPIZE7r
         /JhQ==
X-Gm-Message-State: AOJu0YwCPIT3IpggPkpcDrmYXld1WM+fTKu8+ZZF3vwaPHlwFCG+6FuB
	e1TqNeswAGB7K88cxg0LHV6l5PMF2Hca51FtVHYNzOBYzewR/lNTJKVVV6e8jbCKV7gOZcw2NyG
	b
X-Google-Smtp-Source: AGHT+IEewsMAewlw5yNX7Jrz3K7W1i9RSTAJy5C8cKoSmPx1CKig4Ntos3WVnFMZKt/bMWpPMq47ww==
X-Received: by 2002:a05:6e02:1a23:b0:39f:5e12:1dde with SMTP id e9e14a558f8ab-3a3b60516b2mr87456075ab.21.1728939264526;
        Mon, 14 Oct 2024 13:54:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3afdb3629sm62644895ab.21.2024.10.14.13.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 13:54:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/net: add IORING_SEND_IGNORE_INLINE support to send/sendmsg
Date: Mon, 14 Oct 2024 14:49:47 -0600
Message-ID: <20241014205416.456078-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241014205416.456078-1-axboe@kernel.dk>
References: <20241014205416.456078-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If IORING_SEND_IGNORE_INLINE is set for a send/sendmsg request, then a
successful inline completion of such a request will be ignored for a
submit_and_wait() type of submissions. In other words, if an application
submits a send for socketA with a recv for socketB, it can now do:

io_uring_submit_and_wait(ring, 1);

and have the inline send completion be ignored from the number of items
to wait for.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 7 +++++++
 io_uring/net.c                | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1967f5ab2317..e026ade027c1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -362,12 +362,19 @@ enum io_uring_op {
  *				the starting buffer ID in cqe->flags as per
  *				usual for provided buffer usage. The buffers
  *				will be	contigious from the starting buffer ID.
+ *
+ * IORING_SEND_IGNORE_INLINE	If set for a send[msg] request, then the
+ *				completion will NOT be included in the count
+ *				waited for by an application, if completed
+ *				inline as part of submission. It will still
+ *				generate a CQE.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
 #define IORING_RECVSEND_BUNDLE		(1U << 4)
+#define IORING_SEND_IGNORE_INLINE	(1U << 5)
 
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
diff --git a/io_uring/net.c b/io_uring/net.c
index 18507658a921..11ff58a5c145 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -400,7 +400,8 @@ static int io_sendmsg_prep_setup(struct io_kiocb *req, int is_msg)
 	return ret;
 }
 
-#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
+#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE | \
+			IORING_SEND_IGNORE_INLINE)
 
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -434,6 +435,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
+	if (sr->flags & IORING_SEND_IGNORE_INLINE)
+		req->flags |= REQ_F_IGNORE_INLINE;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -550,6 +553,8 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 
 	if (ret < min_ret) {
+		req->flags &= ~REQ_F_IGNORE_INLINE;
+
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
 		if (ret > 0 && io_net_retry(sock, flags)) {
@@ -647,6 +652,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	kmsg->msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &kmsg->msg);
 	if (ret < min_ret) {
+		req->flags &= ~REQ_F_IGNORE_INLINE;
+
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
 
-- 
2.45.2


