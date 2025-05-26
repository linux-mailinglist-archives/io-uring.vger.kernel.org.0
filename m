Return-Path: <io-uring+bounces-8109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66807AC3AAD
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03FCC188B94D
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465C91C5F09;
	Mon, 26 May 2025 07:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3fUeK/4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B155198E7B
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244693; cv=none; b=ehhjfxhlpQMLb3QbN/f68EHxT4Pn6IUdaeUjZwSQ0diWnzuDZm04Q60xSoVjyFiou1+e+GNhDztedP/ilUgiRePgUH1x8M0qjWgT0iK8ggd7WhKFfJTKVQw3qpPpwKE66sQa2zPt2S6cVZqmevQaJL+bXr0xLHZ08NAIl9lR7wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244693; c=relaxed/simple;
	bh=25hVeYqds8GeKotqi3u8x+KqP3e1AuqVoC+5IqtWLmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELdrhj3RGULXKXAr+ek5qsG2b7ikKIz9JJ+XsgXLGHcr24aoMA15MXqIbBpr50UuzWVmt47c6sr7uPWp09FNSHfi93VghPZReJaOlTHSI7yBEEyTB+qGCbcRJUefDeufOS7PN6PgOVuOdEwli+CupFgwsq8GTwIq3Nso7HRmf/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R3fUeK/4; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6045e69c9a8so1898194a12.3
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244689; x=1748849489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wmUCLbigXK637uXNYg0XyjJuo15ezZUMTt3GtemALSY=;
        b=R3fUeK/43RNPiGYbCPV95LyC4YQtLgPJdx5xfKzznLbEt0OX+Lyv0fTWeU0LM1HojX
         gNyXzBiINoG0m1R6LuRZwr7Q9VE8sMxORk3vArDsIxlXfw+uDlKPfnciwwsXpliFoLbx
         I7NtWaLQ04NtZ9lGZBMHSdRNJUO2wmKzCYUuwjmrtPXNBe2h5VTYEK1SO37DrVC6wwx8
         nnmXOueUzJCqh585dJyvV1wmNWyu6QtP16yaMyEMMuRmHLkb3uiU68qwo/0lPyRedERN
         q09GzyfWBs8VEQGbplyyOSkQbdocnWDjGa13A7GtcCTUEJxsYgNb9/m5kY2ViGcEBTOT
         vPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244689; x=1748849489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wmUCLbigXK637uXNYg0XyjJuo15ezZUMTt3GtemALSY=;
        b=NZGVjGQCUJGSECb+wKLnBunjnohBiikfeWBkYnPz0uTJVQ+hLR1ZRMxe5IX/eOta8S
         eYdNWRvGdVIeVGCDBmI+RfUAFGrSbOhNwWzQ4LIEn0DrZ2g/B/31CniEr460jzLren6D
         e3RbKxrujcoVlbUZU4AZKnT29djUPbVMfL78z5lCTZwouGpQtELQOvguFBGW/yjdqTSy
         whUlPi8VKrijnJ4qCgb0OwX/0BXytWaK9lKhDDKkK5EI8UvHxrmTFtgZPCkwEfNAhQeY
         LGFTuYGMGRTb5Ru3j95s7kNXY629OlWrbvF9oe9YZmTTB72qq6QojTbKU6yURCPwSNSm
         ZLiw==
X-Gm-Message-State: AOJu0YydPF2fGaoklpFWODBrKmZjYw7Qc/25GXR2O47f4SavnKx/ACo2
	cPBPJ3MxCzn/sqrr090FDrPIEAPmQDxeq/qkm7AEaGZZETH5DZubv13lcMgyzw==
X-Gm-Gg: ASbGncsvHT8qfBG7XZuTa0BYb2UfK0iwazBtTQlH9eiW76hgAwFu37H9ZRwarzcXup1
	GZSEh16gJo6wF4gANOO35+nSvYi+9pNIRJ5ikPhkCXrH5mYaRP+zlu7opPzxDBgpvNrZY19qAGP
	uUpMa87LDWv9DjvkOartyDVGQ2FG6ymzv+ubvj1i7oVkkYMFuTOr6F/pb0OWbu4IBcE+m2Yrr11
	nCjvtuy1stcmgo5ndvz+15uzHLWPJSYg4KPjBFGY1IrtzrpAkRCi3buxJ4PrXze19JlYLzK5ONz
	2D7E4UUhIEtjEQnuKFYh48AiSC9GtTmh/B52vR8AE4JcUBXULvDC5hNVm05gmsKP
X-Google-Smtp-Source: AGHT+IFnR90y/UWzRTxn6+f//DkShfSMuu0fAlZVjU/nRyYxHF5aJnYtWr1fiWqGECCBg0DY6r0+JA==
X-Received: by 2002:a17:906:7314:b0:ad2:3371:55cd with SMTP id a640c23a62f3a-ad85b0a7e72mr795905666b.5.1748244689410;
        Mon, 26 May 2025 00:31:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad8816eb7e3sm12395166b.50.2025.05.26.00.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:31:28 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 6/6] io_uring: add trivial poll handler
Date: Mon, 26 May 2025 08:32:28 +0100
Message-ID: <fccc2fdd47b7c40fd5abee54e1001a484cf795b6.1748243323.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748243323.git.asml.silence@gmail.com>
References: <cover.1748243323.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a flag that enables polling on the mock file. For now it's trivially
says that there is always data available, it'll be extended in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 36 ++++++++++++++++++++++++++++++++++--
 io_uring/mock_file.h |  2 ++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 321d02f923af..79a729953529 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -6,6 +6,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
+#include <linux/poll.h>
 
 #include <linux/io_uring/cmd.h>
 #include <linux/io_uring_types.h>
@@ -20,6 +21,8 @@ struct io_mock_iocb {
 struct io_mock_file {
 	size_t			size;
 	u64			rw_delay_ns;
+	bool			pollable;
+	struct wait_queue_head	poll_wq;
 };
 
 #define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
@@ -161,6 +164,18 @@ static loff_t io_mock_llseek(struct file *file, loff_t offset, int whence)
 	return fixed_size_llseek(file, offset, whence, mf->size);
 }
 
+static __poll_t io_mock_poll(struct file *file, struct poll_table_struct *pt)
+{
+	struct io_mock_file *mf = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &mf->poll_wq, pt);
+
+	mask |= EPOLLOUT | EPOLLWRNORM;
+	mask |= EPOLLIN | EPOLLRDNORM;
+	return mask;
+}
+
 static const struct file_operations io_mock_fops = {
 	.owner		= THIS_MODULE,
 	.uring_cmd	= io_mock_cmd,
@@ -169,10 +184,21 @@ static const struct file_operations io_mock_fops = {
 	.llseek		= io_mock_llseek,
 };
 
-#define IO_VALID_CREATE_FLAGS (IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
+static const struct file_operations io_mock_poll_fops = {
+	.owner		= THIS_MODULE,
+	.uring_cmd	= io_mock_cmd,
+	.read_iter	= io_mock_read_iter,
+	.write_iter	= io_mock_write_iter,
+	.llseek		= io_mock_llseek,
+	.poll		= io_mock_poll,
+};
+
+#define IO_VALID_CREATE_FLAGS (IORING_MOCK_CREATE_F_SUPPORT_NOWAIT | \
+				IORING_MOCK_CREATE_F_POLL)
 
 static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
+	const struct file_operations *fops = &io_mock_fops;
 	const struct io_uring_sqe *sqe = cmd->sqe;
 	struct io_uring_mock_create mc, __user *uarg;
 	struct io_mock_file *mf = NULL;
@@ -208,9 +234,15 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	if (fd < 0)
 		goto fail;
 
+	init_waitqueue_head(&mf->poll_wq);
 	mf->size = mc.file_size;
 	mf->rw_delay_ns = mc.rw_delay_ns;
-	file = anon_inode_create_getfile("[io_uring_mock]", &io_mock_fops,
+	if (mc.flags & IORING_MOCK_CREATE_F_POLL) {
+		fops = &io_mock_poll_fops;
+		mf->pollable = true;
+	}
+
+	file = anon_inode_create_getfile("[io_uring_mock]", fops,
 					 mf, O_RDWR | O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index 65ed71ca3a8f..7fa71145850a 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -8,6 +8,7 @@ enum {
 	IORING_MOCK_FEAT_RW_ZERO,
 	IORING_MOCK_FEAT_RW_NOWAIT,
 	IORING_MOCK_FEAT_RW_ASYNC,
+	IORING_MOCK_FEAT_POLL,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -19,6 +20,7 @@ struct io_uring_mock_probe {
 
 enum {
 	IORING_MOCK_CREATE_F_SUPPORT_NOWAIT			= 1,
+	IORING_MOCK_CREATE_F_POLL				= 2,
 };
 
 struct io_uring_mock_create {
-- 
2.49.0


