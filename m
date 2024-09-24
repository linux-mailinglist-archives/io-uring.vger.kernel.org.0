Return-Path: <io-uring+bounces-3277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA35983C2F
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 07:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 476271C22607
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 05:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1593C488;
	Tue, 24 Sep 2024 05:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v9F8YNZy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E3236126
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 05:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727154344; cv=none; b=WbvU+Z637XQglbDw/GF14xwaXDLA4bUddzaI0p/fu+/T2GcBKb5YxkPQlrKFfKKZM9sOrZ9VDc97343x+FkTF+Gf4SjjUM2lBMja4h47dPn/SgjePVeeEfeVzddDEL9Rhuv+QpHQPysuZwxGPT5uFCHhmoJiMW41Alzcr8ZPues=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727154344; c=relaxed/simple;
	bh=XUjrVy62Z+/IwmgPj4Tgy9rwv1roi/C9vrOg8pWw3tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wne7JRy+7PFA650tM2CKlHen95VWknYhmL/q3yWmo8XroB4/C/zDZnLe04Nb0Wnec910TTh6HoXZuzoiAH2KB4VmWNJQMpXqk6TYswpKbPF0mHFQPMF932CpL2n59Md+CG7i2t0bjOiMQQexmZe5V3GQ7xAQwaMBFhqzHaKiJxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v9F8YNZy; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42cbc22e1c4so40716735e9.2
        for <io-uring@vger.kernel.org>; Mon, 23 Sep 2024 22:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727154340; x=1727759140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hg94UDj19xbQw1flt9UTw0zEA6YLJjZ4eCpweo3ak3w=;
        b=v9F8YNZyFSeYM+y+ABZJO98h0ttnu5q5IXLuagJ710sUFapEJ0eMyOc9AokHdA70et
         fo9LWNyJ8mucGs1djOiG2WEYeJw528m0T3DIt4pJ5oKA8e4r5JHrOuxFivn4zJ85aM6T
         B99VgO7Kit/dRR6THWmAN54W3yOqgDV87oxxIhGB1LFJP61C6QW1nRKFqzSXjSV6LcRV
         /7V1w2EAffBNUTSCnlbrq3K5V/8wryKviHgLk5ofSyfL7YgVNmiwoyQ2gMuBMyeHiNaS
         b2zYtDmsJXZBISKvALuxpnKVA5dCo+3nlutvG9/y0QM5yLKuARRfyYlL308mLSAjiXX7
         rxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727154340; x=1727759140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hg94UDj19xbQw1flt9UTw0zEA6YLJjZ4eCpweo3ak3w=;
        b=Zr+SzpWzSEcKbSVFIHn5qVAR/exLpXgafnxZZzwwqEx8OU4HuQCPbTO80AdV9dBDuo
         OxXwzAiuwoZ5EF3YS11N9lKv+oIgvMFJBSzUhTFzCSUJTtp9YebKSw1qGCu1uD6PudBK
         YCUcLau6Xi2kI1XkyjymBgUHnIMQvMRSgPk3vEcfsJJkc7xPzAHCwNSSaUo9BpmqFzPw
         OtVeq98Juj4wZsZeA3irpb8Z61a5qGCCbX47CwwoirpdeONANa/MmQfdanRMAecVxVu2
         qJeNdLJd6nv6ioFx3tlKwVYpdd7DJy0v1ujzOO88pAi5IFuYLXE+C9+KgrmlvAzv0c11
         LuEw==
X-Gm-Message-State: AOJu0YxY43dRrrtzKzraCBCROXlec59KAHQU909zVjf8MwN5RZdDqGVU
	U+oAoR+67mhMU4O90peRwBiPyXwO6PG/avwXqdttquIIwnAlPmtd/xkPExZmDC+QP1PG2K88Wrq
	QUg4OSmMm
X-Google-Smtp-Source: AGHT+IGuGt1+Nv9T+ET+33D3OxZ6kINrQ9QYUZ8Fca9w3gciWyLd8Hn9Xf8uDrPYKsycIh/8z8G+tQ==
X-Received: by 2002:a5d:674d:0:b0:371:8845:a3af with SMTP id ffacd0b85a97d-37a4234d323mr6407107f8f.39.1727154339894;
        Mon, 23 Sep 2024 22:05:39 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc32b694sm552480f8f.116.2024.09.23.22.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 22:05:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/msg_ring: add support for sending a sync message
Date: Mon, 23 Sep 2024 22:59:54 -0600
Message-ID: <20240924050531.39427-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240924050531.39427-1-axboe@kernel.dk>
References: <20240924050531.39427-1-axboe@kernel.dk>
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
the stack and use the normal liburing helpers to get it setup. Then it
can call:

io_uring_register(-1, IORING_REGISTER_SEND_MSG_RING, &sqe, 1);

and get the same behavior in terms of the target where a CQE is posted
with the details given in the sqe.

For now this takes a single sqe pointer argument, and hence arg must
be set to that, and nr_args must be 1. Could easily be extended to take
an array of sqes, but for now let's keep it simple.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  3 +++
 io_uring/msg_ring.c           | 27 +++++++++++++++++++++++++++
 io_uring/msg_ring.h           |  1 +
 io_uring/register.c           | 27 +++++++++++++++++++++++++++
 4 files changed, 58 insertions(+)

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
index ea4c7a7691e0..e64be6260cc6 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -333,6 +333,33 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+int io_uring_sync_msg_ring(struct io_uring_sqe *sqe)
+{
+	struct io_msg io_msg = { };
+	struct fd f;
+	int ret;
+
+	ret =__io_msg_ring_prep(&io_msg, sqe);
+	if (unlikely(ret))
+		return ret;
+
+	if (io_msg.cmd != IORING_MSG_DATA)
+		return -EINVAL;
+
+	f = fdget(sqe->fd);
+	if (!fd_file(f))
+		return -EBADF;
+
+	ret = -EBADFD;
+	if (!io_is_uring_fops(fd_file(f)))
+		goto err;
+
+	ret = __io_msg_ring_data(fd_file(f)->private_data, &io_msg, 0);
+err:
+	fdput(f);
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
index eca26d4884d9..2daa6f48a178 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -28,6 +28,7 @@
 #include "kbuf.h"
 #include "napi.h"
 #include "eventfd.h"
+#include "msg_ring.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -588,6 +589,29 @@ struct file *io_uring_register_get_file(unsigned int fd, bool registered)
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
@@ -602,6 +626,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
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


