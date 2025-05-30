Return-Path: <io-uring+bounces-8127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8E9AC8A0A
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 10:37:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12A939E3D13
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 08:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A877638B;
	Fri, 30 May 2025 08:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aGHGOyKu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2CE1FF603
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594234; cv=none; b=BWlxr9DY3bvHvakKyOhe1ZBf1OMBT1xZYp/+nSqVjDd6NNLYfP/rurdVvF30OakqWlkutvnmpa5cflWzSMySAtS6juZ0RCJjNC3jYjDiJrCe1iYZtrl4MWWnmIh+Hl2bGa208zjGDX1wfCekHQN+GQlG1c49XbEXCV2W52m+y+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594234; c=relaxed/simple;
	bh=oXzYIXnBksqLTonKEN5tzH6DTJb8Wvhic1T7HrhTqFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVba/tUqdsHtygXIVe3rWZad6C0K92TDSiKAj/gBCkA64HK0RD0+3APbTYzyRDOY+W5ww+9jJ9mkZ+ESdJWBjWSHyKkg/6Idrs9uM5yP4LcdNF+c8uq1XeK7RXU9g0wtq6pEAfAx/sBhMyZlXjQg7kevcfvSDAgYcfHmDe1ljZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aGHGOyKu; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-acb5ec407b1so297247166b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 01:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748594230; x=1749199030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DPv8nJvkIWxtouW+XA1i3MQmEUBZuXoS042CEYbITX0=;
        b=aGHGOyKuGKRLJDyZHAJhWwheQsMTAKG+pIJc72wACf9ltC8mYLkgD6uIRl6j3gyHTO
         5yDgfbDEdiJdi+GAj7Sb84Fu9eYdzJAqUlqx1jkNuhHF597oCfsqR9BrGIR52fE0PXI+
         TJv0RUK2OqNfGUw1gqn40iX6QcqLhcgghY5G4+Hr/I0PgHSdg/SEjcvZc0xpNpHvlacC
         dLMi9X3VJP24K770QvxOhiRiY2ht8WN4NV7H4OrxvVXgO9TZ4FOxJpcxKWOqecguVRPF
         1ID5C9IOwhzdOcaXdaklbnyUoU9TCa3yzWwEwP1VZe2gM5CggPDr8c//a7Xh5L3QcGXG
         mzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748594230; x=1749199030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DPv8nJvkIWxtouW+XA1i3MQmEUBZuXoS042CEYbITX0=;
        b=toLmp6Y1/ELWccTq8Xh/r3i0dtB09H+E0hXQlzG0c0IKSs2Kfl/iyb6Z644rxEOl/A
         dYx/E/8rGPlIvMq/koHvpIlF4K4Rx8qe7hzFXcjGHgMzPwlHLc4bsi6xyPtKSsvQSz3X
         HY+JN4zKiaADr/DHfj6IM+la58XjCJBP4xIkMmeniTB1Pn6BS0IemfxjyZVFsXFBqQX7
         B2vu2H4LW3jg1wIJOvzsXFTn/gnn0Ry9XCLW0GetTDP9ccG0b4IzVKZQ+x1Csnk5OV0k
         P+uuBu88in3dehcK6ZcZOTfJ7y2Qjd3SGZS8tgsEX+ptQ5uD0mQdcCTvW7K3a1EGZcv3
         Fknw==
X-Gm-Message-State: AOJu0YwDus7csKt/Htr8e+JbIVJpnOr/qPkrOWRxuetG4OzGK1+L5q8O
	HnHsR90I2TmbhtMK7q/9W3Dyu6+8BkRpsXqnqpkS+hm54mv7tfctYrfP3NAP4A==
X-Gm-Gg: ASbGnct2QV9+dWylAEznz+lCzFegZugrh72dVhAB18eVqrhSrSzayT949OePL8PgAlH
	yNdvZCVf1fNcM3Iz3LvSvufYuX5JvkTMmeKr7Yke0ooqyge/BwIr6J7Z3ELCBzRbsD+j6mWiAjA
	c2GzaYYQpOuZMu1IBSn1jlB5EbUX3HlwXwxUIckkteqtrGYvtKvVjcQlUjWyooKJneq7BSSmRs2
	1mhd4XdFwT0xxRt0a4uhFjMggJfInQH1dqOmOtN85OKwf4o7axMPkNpgYta0hHPeJB20nOc7deC
	WXq9VeljFkDIZ5yglKZDRnoYQX38kMXI3t+ktiTZeCTdBbnx4D6jEM68
X-Google-Smtp-Source: AGHT+IENN4H9kSMk0VFCYJURv0An43PH3jvbgEuSF2G6kzDSIq0Xl8mX3NgKQBvSU0kEeCuxqsIsKw==
X-Received: by 2002:a17:907:728d:b0:ad5:a29c:efed with SMTP id a640c23a62f3a-adb36bf1c29mr130149866b.33.1748594230178;
        Fri, 30 May 2025 01:37:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:65cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad696d1sm288126566b.161.2025.05.30.01.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 01:37:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 3/6] io_uring/mock: add sync read/write
Date: Fri, 30 May 2025 09:38:08 +0100
Message-ID: <249ba1467b6e8591a4fe7b2af3232e3f8b3ba472.1748594274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748594274.git.asml.silence@gmail.com>
References: <cover.1748594274.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for synchronous zero read/write for mock files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 67 ++++++++++++++++++++++++++++++++++++++++----
 io_uring/mock_file.h |  4 ++-
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 6d6100052a26..f606e1d03113 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -9,6 +9,10 @@
 #include <linux/io_uring_types.h>
 #include "mock_file.h"
 
+struct io_mock_file {
+	size_t size;
+};
+
 #define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
 
 static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
@@ -82,18 +86,59 @@ static int io_mock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -ENOTSUPP;
 }
 
+static ssize_t io_mock_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct io_mock_file *mf = iocb->ki_filp->private_data;
+	size_t len = iov_iter_count(to);
+
+	if (iocb->ki_pos + len > mf->size)
+		return -EINVAL;
+	return iov_iter_zero(len, to);
+}
+
+static ssize_t io_mock_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct io_mock_file *mf = iocb->ki_filp->private_data;
+	size_t len = iov_iter_count(from);
+
+	if (iocb->ki_pos + len > mf->size)
+		return -EINVAL;
+	iov_iter_advance(from, len);
+	return len;
+}
+
+static loff_t io_mock_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct io_mock_file *mf = file->private_data;
+
+	return fixed_size_llseek(file, offset, whence, mf->size);
+}
+
+static int io_mock_release(struct inode *inode, struct file *file)
+{
+	struct io_mock_file *mf = file->private_data;
+
+	kfree(mf);
+	return 0;
+}
+
 static const struct file_operations io_mock_fops = {
 	.owner		= THIS_MODULE,
+	.release	= io_mock_release,
 	.uring_cmd	= io_mock_cmd,
+	.read_iter	= io_mock_read_iter,
+	.write_iter	= io_mock_write_iter,
+	.llseek		= io_mock_llseek,
 };
 
 static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	const struct io_uring_sqe *sqe = cmd->sqe;
 	struct io_uring_mock_create mc, __user *uarg;
+	struct io_mock_file *mf = NULL;
 	struct file *file = NULL;
 	size_t uarg_size;
-	int fd, ret;
+	int fd = -1, ret;
 
 	uarg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	uarg_size = READ_ONCE(sqe->len);
@@ -108,18 +153,28 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 		return -EFAULT;
 	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)) || mc.flags)
 		return -EINVAL;
+	if (mc.file_size > SZ_1G)
+		return -EINVAL;
+	mf = kzalloc(sizeof(*mf), GFP_KERNEL_ACCOUNT);
+	if (!mf)
+		return -ENOMEM;
 
-	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	ret = fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
 	if (fd < 0)
-		return fd;
+		goto fail;
 
+	mf->size = mc.file_size;
 	file = anon_inode_create_getfile("[io_uring_mock]", &io_mock_fops,
-					 NULL, O_RDWR | O_CLOEXEC, NULL);
+					 mf, O_RDWR | O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto fail;
 	}
 
+	file->f_mode |= FMODE_READ | FMODE_CAN_READ |
+			FMODE_WRITE | FMODE_CAN_WRITE |
+			FMODE_LSEEK;
+
 	mc.out_fd = fd;
 	if (copy_to_user(uarg, &mc, uarg_size)) {
 		fput(file);
@@ -130,7 +185,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	fd_install(fd, file);
 	return 0;
 fail:
-	put_unused_fd(fd);
+	if (fd >= 0)
+		put_unused_fd(fd);
+	kfree(mf);
 	return ret;
 }
 
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index 8475dfd827e9..dc6cc343410d 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -5,6 +5,7 @@
 
 enum {
 	IORING_MOCK_FEAT_CMD_COPY,
+	IORING_MOCK_FEAT_RW_ZERO,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -17,7 +18,8 @@ struct io_uring_mock_probe {
 struct io_uring_mock_create {
 	__u32		out_fd;
 	__u32		flags;
-	__u64		__resv[15];
+	__u64		file_size;
+	__u64		__resv[14];
 };
 
 enum {
-- 
2.49.0


