Return-Path: <io-uring+bounces-3290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E66E7984550
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 14:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CF13283D2D
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 12:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C487583CD6;
	Tue, 24 Sep 2024 11:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VFwTajpM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAE3824AD
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 11:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727179197; cv=none; b=AaiwXr4nJCPTmVqvdRwhCNvue7wb3lGHSg6IEc1LQzi0pllxYC+c0Io8aFAV+lS1l+6CcQQoIvk9rHLkHszV/wxPbTjyrRzBkfE3dc413AJg0B+VcJWuxVPL3/8wtRUoUOB1xLAYSFfY1l57Pq+56ocaU5qUAvfIoFQXL/u5CN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727179197; c=relaxed/simple;
	bh=QOC/N8vk6BOMdwuxSmj3j3a/LlaCgEAbn4IyfQ/B98o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8UbQbysnxqNlfQVs+h37KtG+YeBLJRf1a6I3DLxEZ6SjskhD8eBhIKhONEFHb1v93pkMsOlQ9BMMcqazZwV0mrJ97AaRqcwLkiq0qShCv/EYCx4n4DT1WQ9n7OEp38OticB4Jk03YD9FAli2tH807umD1CIn2ZvAJn7UlzdieM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VFwTajpM; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e1d0e1bffc8so4536994276.1
        for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 04:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727179194; x=1727783994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHcPl3EZ4otcEGCvrDoTgKNq26PHxqo0jU5GtWYyTcQ=;
        b=VFwTajpM6JAnulVCkeUqvQTImxLBq99DeVEVe1xyBl8a2fklCcztS+Ud7UtDkComUc
         upjkoDbpsc4v6SGJmMNCGNmI6ci+iu27rLowLUSs41l3jisqrQPiTh+UtKGoXpIUp1hb
         AqY5DWNDrkrunZHUn/EL2342zs2UFNGnr1FXqA3KhrSWaGauC7eMxM7Xdax01ITavKzB
         I4liOcgFl5cVYQfEJ6NvuRZZ1+Ci4wc3W755vRdUlm8hxltO170Xt7QhXq1DCMuGDmUN
         lycM/EM/1i0HFjXRdj5LGnaquab1xd3h2WglzMSRVQ+7qvcYHq5KeIhBQaW3dbNLbPFl
         2aUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727179194; x=1727783994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHcPl3EZ4otcEGCvrDoTgKNq26PHxqo0jU5GtWYyTcQ=;
        b=LWrEW4vkQNTe7Vu9iSgfBrQ+jl+ve6Atx1fMgZTjvYdn/FrYUHT82495BrGxsdsC6t
         z0ritlVWD8z1brT6WUGnrI5/k5TvKlXSHe8gWlDuvALU49gkg/HTRqSFgQC/KXarLQ5o
         elLoGgA+ip/LfO2bBKOoReB8ikKsnz/OdTCMmeUfjLU84SI0I3F2RtzJGNM0xQp4wlzF
         Ls3UqIYP3jkhQb68B0p7peQr0FD8yO1eawNX3aNQqPpgFRhzRllbAcFx4d9Z+mHYqyME
         4LTHQHNkHg6DKeJdvOkyaWZmug4pyPv0alCWLyfOElclzxzQs/mPKyI6A35fNhryJtUk
         Fb+w==
X-Gm-Message-State: AOJu0YwYtyRlq+meZ818U62vdIjLIKnrKHP34AubSGM1nFu95K2ZdkMx
	EhDAgKEDSajUYwvhMM6Pztkkk/1rF/NG98IE0dUT9u8XsGVYwrSJTyhUYKFqtPiwUNbHlvFbAdn
	Ccm6KsA==
X-Google-Smtp-Source: AGHT+IFGfYh7OZPVzQIU/1KrNMvDnoD46Pl+Dul2F+GS7gAg4bRt0zK3n63BQkiuFX76s23Upw0vsg==
X-Received: by 2002:a05:6902:2613:b0:e20:2245:6fa4 with SMTP id 3f1490d57ef6-e2252fbb135mr11304261276.47.1727179194169;
        Tue, 24 Sep 2024 04:59:54 -0700 (PDT)
Received: from localhost.localdomain ([2600:381:1d13:f852:a731:c08e:e897:179a])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e2499ae6a06sm210598276.4.2024.09.24.04.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 04:59:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/msg_ring: add support for sending a sync message
Date: Tue, 24 Sep 2024 05:57:31 -0600
Message-ID: <20240924115932.116167-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240924115932.116167-1-axboe@kernel.dk>
References: <20240924115932.116167-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally MSG_RING requires both a source and a destination ring. But
some users don't always have a ring avilable to send a message from, yet
they still need to notify a target ring.

Add support for using io_uring_register(2) without having a source ring,
using a file descriptor of -1 for that. Internally those are called
blind registration opcodes. Implement IORING_REGISTER_SEND_MSG_RING as a
blind opcode, which simply takes an sqe that the application can put on
the stack and use the normal liburing helpers to initialize it. Then the
app can call:

io_uring_register(-1, IORING_REGISTER_SEND_MSG_RING, &sqe, 1);

and get the same behavior in terms of the target, where a CQE is posted
with the details given in the sqe.

For now this takes a single sqe pointer argument, and hence arg must
be set to that, and nr_args must be 1. Could easily be extended to take
an array of sqes, but for now let's keep it simple.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  3 +++
 io_uring/msg_ring.c           | 29 +++++++++++++++++++++++++++++
 io_uring/msg_ring.h           |  1 +
 io_uring/register.c           | 30 ++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1fe79e750470..86cb385fe0b5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -612,6 +612,9 @@ enum io_uring_register_op {
 	/* clone registered buffers from source ring to current ring */
 	IORING_REGISTER_CLONE_BUFFERS		= 30,
 
+	/* send MSG_RING without having a ring */
+	IORING_REGISTER_SEND_MSG_RING		= 31,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index b8c527f08cd5..edea1ffd501c 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -331,6 +331,35 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+int io_uring_sync_msg_ring(struct io_uring_sqe *sqe)
+{
+	struct io_msg io_msg = { };
+	struct fd f;
+	int ret;
+
+	ret = __io_msg_ring_prep(&io_msg, sqe);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * Only data sending supported, not IORING_MSG_SEND_FD as that one
+	 * doesn't make sense without a source ring to send files from.
+	 */
+	if (io_msg.cmd != IORING_MSG_DATA)
+		return -EINVAL;
+
+	ret = -EBADF;
+	f = fdget(sqe->fd);
+	if (fd_file(f)) {
+		ret = -EBADFD;
+		if (io_is_uring_fops(fd_file(f)))
+			ret = __io_msg_ring_data(fd_file(f)->private_data,
+						 &io_msg, IO_URING_F_UNLOCKED);
+		fdput(f);
+	}
+	return ret;
+}
+
 void io_msg_cache_free(const void *entry)
 {
 	struct io_kiocb *req = (struct io_kiocb *) entry;
diff --git a/io_uring/msg_ring.h b/io_uring/msg_ring.h
index 3030f3942f0f..38e7f8f0c944 100644
--- a/io_uring/msg_ring.h
+++ b/io_uring/msg_ring.h
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+int io_uring_sync_msg_ring(struct io_uring_sqe *sqe);
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags);
 void io_msg_ring_cleanup(struct io_kiocb *req);
diff --git a/io_uring/register.c b/io_uring/register.c
index eca26d4884d9..52b2f9b74af8 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -28,6 +28,7 @@
 #include "kbuf.h"
 #include "napi.h"
 #include "eventfd.h"
+#include "msg_ring.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -588,6 +589,32 @@ struct file *io_uring_register_get_file(unsigned int fd, bool registered)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+/*
+ * "blind" registration opcodes are ones where there's no ring given, and
+ * hence the source fd must be -1.
+ */
+static int io_uring_register_blind(unsigned int opcode, void __user *arg,
+				   unsigned int nr_args)
+{
+	switch (opcode) {
+	case IORING_REGISTER_SEND_MSG_RING: {
+		struct io_uring_sqe sqe;
+
+		if (!arg || nr_args != 1)
+			return -EINVAL;
+		if (copy_from_user(&sqe, arg, sizeof(sqe)))
+			return -EFAULT;
+		/* no flags supported */
+		if (sqe.flags)
+			return -EINVAL;
+		if (sqe.opcode == IORING_OP_MSG_RING)
+			return io_uring_sync_msg_ring(&sqe);
+		}
+	}
+
+	return -EINVAL;
+}
+
 SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 		void __user *, arg, unsigned int, nr_args)
 {
@@ -602,6 +629,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	if (opcode >= IORING_REGISTER_LAST)
 		return -EINVAL;
 
+	if (fd == -1)
+		return io_uring_register_blind(opcode, arg, nr_args);
+
 	file = io_uring_register_get_file(fd, use_registered_ring);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
-- 
2.45.2


