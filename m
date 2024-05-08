Return-Path: <io-uring+bounces-1832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 090828BFFF4
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 16:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D46F1F23AD1
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 14:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 557E17BB0F;
	Wed,  8 May 2024 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RWrCv+6q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CE4182CC
	for <io-uring@vger.kernel.org>; Wed,  8 May 2024 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715178454; cv=none; b=W60PS5uBArdLtfm3K7fO1uTfor6D1HXSJxdppAnNauHe7BwAzxzTWm/Es7Hjn3ntiDfWxheetK8QGgnX3AzmuSKvw9nHdqbAox46LggAf2x4/ANxiXcW78SYI5Jhny5Vx/0/PdICs/OugDuZHbU0JY9DEh6Q9T0HhGy7jK+hXX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715178454; c=relaxed/simple;
	bh=GXFyDkGHAJklQ8XkFA0GcrAY6q+2BKptyc8P7wz4BiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3TmONJ8TDzhGlPfZNj5mg9hDFkyOIM6D/pBuPSjd8soechq24Kmux/WjA+Wo2uVP9sJr6Bt6npk/caRaTQMbaUcuP9jUScIQj/jgjZw62Jt6KBywj/GbioX2YstDozPR7sEGMrf8Eor8Xq2EnI9CVaPGdU2VFXD6xDkqZ7ECv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RWrCv+6q; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7d9d591e660so11462539f.2
        for <io-uring@vger.kernel.org>; Wed, 08 May 2024 07:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715178450; x=1715783250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kuGxhO/l3ke6ObTpcXOcU2V2ZdgwmLVGPG3n99j8t20=;
        b=RWrCv+6qoNrLVgTUObT1Pvt8t5NupBKOJSlffIQwj8KLLdD6I8o1NPe5f6Nn7qP9Qn
         VDb0YD1/IRqJr37XsgI0W01hTAhICgnzmW033XurZ/2ynyDn/7Wwgl4S3Yvr8ioE+IuE
         KOhpPbJKYB0ebNk0dSb40wRzzWtzwnt6RwMgDTrIBsE/ZaOpaTqG2QnzURrla4/FQ22I
         UEoiIt0EAAmzu8NtU+18RZeCcPTu3nPKVcCBIb+Pwl7IObFFueYW9j5an8gmB4RJgKAM
         XbdAc8OnxWLK9YjnLC3B5JiFel5DuyoWgEdAfAzlPUFPqm6LxWYlafTnCD3dLi/vWIxp
         F6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715178450; x=1715783250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kuGxhO/l3ke6ObTpcXOcU2V2ZdgwmLVGPG3n99j8t20=;
        b=wTYy0RyGvnfEQguUe4sQxeFRvzza+7Fe7YQ9BCJhnuxgruHjO1ik3Vg7yuDHfd4Bvl
         S07hieYncMxfWahBnlxFZlaypD9RljDXAlbi2difaI0WEuNiCscu4fzA46wahw5tG/z3
         ZieK8GMBGdt2a81mFDnNlxZQMR06vp0AmtPCO0yY9UPZvBW+lACLmFH2ErpBGLpvIAk5
         GxO/Lh4h/2TbmKqyP82AUKJb6Lhh3ZphCTQVDCKbvSovfaKgu9Yl8k6T1YT6AK02jyOH
         6BiwXqgsh/5RSpDztuN9gkBCZywK0eYuZSXj4T32b/hjXKx4YxQEQTeR7eL8g4/nLOsO
         gCjg==
X-Gm-Message-State: AOJu0Yx3qccffuFXrpfX//zaM2yVe81lVQ918HuGtIwgLo85wuG0ycp3
	S8blCYuhC6KSfa+Sngxr6e7oue9KdPSrkVo5RJpceOGqNlQsWvYGRT/kOxUaQDhD6YXr2J6M58P
	K
X-Google-Smtp-Source: AGHT+IG0SOQmPo5qRDBal7QxygtYYIn18Y+fBW38P7W6wYP49allz7f73GWYW/gGHJEKMW+4j43RsA==
X-Received: by 2002:a05:6e02:1d0d:b0:36b:2ff9:9275 with SMTP id e9e14a558f8ab-36caed52f66mr30114505ab.2.1715178449983;
        Wed, 08 May 2024 07:27:29 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k10-20020a92c24a000000b0036c6ebd0455sm3180672ilo.88.2024.05.08.07.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 07:27:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/net: add IORING_ACCEPT_POLL_FIRST flag
Date: Wed,  8 May 2024 08:25:37 -0600
Message-ID: <20240508142725.91273-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240508142725.91273-1-axboe@kernel.dk>
References: <20240508142725.91273-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similarly to how polling first is supported for receive, it makes sense
to provide the same for accept. An accept operation does a lot of
expensive setup, like allocating an fd, a socket/inode, etc. If no
connection request is already pending, this is wasted and will just be
cleaned up and freed, only to retry via the usual poll trigger.

Add IORING_ACCEPT_POLL_FIRST, which tells accept to only initiate the
accept request if poll says we have something to accept.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 1 +
 io_uring/net.c                | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4a645d15516f..6dbac55f8686 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -380,6 +380,7 @@ enum io_uring_op {
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 #define IORING_ACCEPT_DONTWAIT	(1U << 1)
+#define IORING_ACCEPT_POLL_FIRST	(1U << 2)
 
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
diff --git a/io_uring/net.c b/io_uring/net.c
index 7861bc8fe8b1..070dea9a4eda 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1487,6 +1487,9 @@ void io_sendrecv_fail(struct io_kiocb *req)
 		req->cqe.flags |= IORING_CQE_F_MORE;
 }
 
+#define ACCEPT_FLAGS	(IORING_ACCEPT_MULTISHOT | IORING_ACCEPT_DONTWAIT | \
+			 IORING_ACCEPT_POLL_FIRST)
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
@@ -1499,7 +1502,7 @@ int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
 	accept->iou_flags = READ_ONCE(sqe->ioprio);
-	if (accept->iou_flags & ~(IORING_ACCEPT_MULTISHOT | IORING_ACCEPT_DONTWAIT))
+	if (accept->iou_flags & ~ACCEPT_FLAGS)
 		return -EINVAL;
 
 	accept->file_slot = READ_ONCE(sqe->file_index);
@@ -1530,6 +1533,10 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
+	if (!(req->flags & REQ_F_POLLED) &&
+	    accept->iou_flags & IORING_ACCEPT_POLL_FIRST)
+		return -EAGAIN;
+
 retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
-- 
2.43.0


