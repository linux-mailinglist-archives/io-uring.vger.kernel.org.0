Return-Path: <io-uring+bounces-8104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C999AC3AA7
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9070173485
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BE0198E7B;
	Mon, 26 May 2025 07:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhEI1aBk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA040EAE7
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244685; cv=none; b=owjWnFpkY0pTc3sOd9cU+5DHcWuzjymic9l0ndcrEEhi+ZFgFU5hpaJFEXWObmk755UTQS6N0JCX8yS93FYBKzNyxJY9gqp5uJ8qabjLljNJgqYAni9mNv3gZ7pGmvtHlfWvYuUP5nK+uB3l8RL5V5xNAr9WdoRJFvmEoC75pzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244685; c=relaxed/simple;
	bh=r7hX032vYpoVFqwVBvl7JNrLGsWfqfphTCtHNWXnnYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+Ys4xjL//D5ez6oIgQF2HEmajbe+vnfhoFxBnGjo/a6HKfZc102tpyKeQiqFu6iK0kje6g8NDh5PNkc5Kl3XLYMUckb0pSVXD3+uBDXycH4t4CLy3bXGhMQqeXTZ4hoHnYNQil07GNrMiFez4AiA0PqNRQpQN4isqcKm2NmCm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhEI1aBk; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6049431b409so1308957a12.3
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244682; x=1748849482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTZtfEG/F9mb9nRG6m1Vgq5NobF87gff8YOasDV7/qs=;
        b=RhEI1aBkOijXD+TDumeIdd+Lu0ivGtctM/jyYjR9cTYcsIHmx1521BN7BXtrrcxZbP
         fmxSj7idTFGElrYZDW1KaaOs7TnrZLuEPPfSI9pQsRHnBVn/NbM+7nBVKlQ1uuxK1ohk
         o//cOXMIQFVGCn246dcZfXAPjMgtKXlG3Od030CihhifGZ6sjAcCsRxwV+KYJudTF0Ek
         NREvJZCIWm8Mw3mXn+c7WLKMJYVq2gWUTcsCgzhoDQ/ZOJcF8Z3kEsz5mqgpz5WdqVi2
         fejKYaoYeSB4pXLyGV50oNLL9KdbY6MjHpNCD5TVfIPKPvw84+CCz+WGeeS0KAewo3dJ
         t7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244682; x=1748849482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nTZtfEG/F9mb9nRG6m1Vgq5NobF87gff8YOasDV7/qs=;
        b=eW1UoZjxYJ1e/MwUN3isxsdF3HfRBbqbjtGUTFaPTQ70lCGAI6QdjB7HtcuUZk6nqS
         5ZwyLF3jcNHeTWIqn/kgO3urVJukv38X04/yhuh78uHkzBZGknbkuX4YyhRtf0fMiwHS
         3fR/p1BOwOszsgqg2ugoIPZva1Btv8ibLp/+jx70GFkVn1QIsIW0xfFVTjhvY1pkqKOn
         2bMW3gNp0O+HHjK0Q8q6J+tnYY+JoeRIlWAPmNVI6wzdbcDr26wV3n2VlNKRGP0XDhlQ
         4RcqfxoO/MDJivU4t2K82wet+O1OJW8qJHYEGSCDaIwGhp9M3e/SP6znwjvARiLO8y9N
         sSxg==
X-Gm-Message-State: AOJu0Yzvjv9pOvC2lPo054B7TMyYC2PE3Cynk61AsYfdl/mpcLagZDcY
	i+6SHznLkOoovab3ryS1vjoHOFPP//LQosQHRm5W/Jwo/QSM7PLxgwl4OtE0Ow==
X-Gm-Gg: ASbGncvndgCkpBayy9/Z2sZaMWr0xiPmKcX2r6Tgum8fpLLUOHxiQt6rnW6GtvqEJpW
	XSXrdQFjwln0g5umyZZNRoYeql/hAvB0GhnssHdeQ4JCte7WkgyBKsN4UurAm4Yrg8R22Xe7NU2
	xusKIGLHfKV4tUr3vT92DR8yAp5v0kvjK6nL0BdbBhCsKXvDW8dOWNPYjIf4Okrdn+myEkffw/i
	gbqI8AsfQtiEE+sIuD8rOU48rPBa3ao9uc2IVcelrSEoAS08iVBp+khaAUkqxYQAynULTWgWgav
	YUGObmR1uxGc+ZlZN4d6TO142gQ0KHDL85KCAS3X/FPiUeEkghoTyeKWIQF1oinx82YObQGmtyY
	=
X-Google-Smtp-Source: AGHT+IEl8VZLkG922Dik1Kz6HC47TJxF4xwlyMyoHUV7zBoq17jAHfJmk4Yzcsr5xo8Qvf/BvFmNTw==
X-Received: by 2002:a17:907:3faa:b0:ad5:8414:497 with SMTP id a640c23a62f3a-ad85b07b7acmr730993166b.16.1748244681327;
        Mon, 26 May 2025 00:31:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad8816eb7e3sm12395166b.50.2025.05.26.00.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:31:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 1/6] io_uring/mock: add basic infra for test mock files
Date: Mon, 26 May 2025 08:32:23 +0100
Message-ID: <afb91951c0bd3736191d834fca724fcd69a772c2.1748243323.git.asml.silence@gmail.com>
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

io_uring commands provide an ioctl style interface for files to
implement file specific operations. io_uring provides many features and
advanced api to commands, and it's getting hard to test as it requires
specific files/devices.

Add basic infrastucture for creating special mock files that will be
implementing the cmd api and using various io_uring features we want to
test. It'll also be useful to test some more obscure read/write/polling
edge cases in the future.

Suggested-by: chase xd <sl1589472800@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 init/Kconfig         |  11 ++++
 io_uring/Makefile    |   1 +
 io_uring/mock_file.c | 139 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/mock_file.h |  22 +++++++
 4 files changed, 173 insertions(+)
 create mode 100644 io_uring/mock_file.c
 create mode 100644 io_uring/mock_file.h

diff --git a/init/Kconfig b/init/Kconfig
index 63f5974b9fa6..856b37c2de8d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
 	  the io_uring subsystem, hence this should only be enabled for
 	  specific test purposes.
 
+config IO_URING_MOCK_FILE
+	tristate "Enable io_uring mock files (Experimental)" if EXPERT
+	default n
+	depends on IO_URING
+	help
+	  Enable mock files for io_uring subststem testing. The ABI might
+	  still change, so it's still experimental and should only be enabled
+	  for specific test purposes.
+
+	  If unsure, say N.
+
 config ADVISE_SYSCALLS
 	bool "Enable madvise/fadvise syscalls" if EXPERT
 	default y
diff --git a/io_uring/Makefile b/io_uring/Makefile
index d97c6b51d584..b3f1bd492804 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_EPOLL)		+= epoll.o
 obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
+obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
new file mode 100644
index 000000000000..e8ec0aeddbae
--- /dev/null
+++ b/io_uring/mock_file.c
@@ -0,0 +1,139 @@
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/anon_inodes.h>
+
+#include <linux/io_uring/cmd.h>
+#include <linux/io_uring_types.h>
+#include "mock_file.h"
+
+static int io_mock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	return -ENOTSUPP;
+}
+
+static const struct file_operations io_mock_fops = {
+	.owner		= THIS_MODULE,
+	.uring_cmd	= io_mock_cmd,
+};
+
+static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	struct io_uring_mock_create mc, __user *uarg;
+	struct file *file = NULL;
+	size_t uarg_size;
+	int fd, ret;
+
+	uarg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	uarg_size = READ_ONCE(sqe->len);
+
+	if (sqe->ioprio || sqe->__pad1 || sqe->addr3 || sqe->file_index)
+		return -EINVAL;
+	if (uarg_size != sizeof(mc))
+		return -EINVAL;
+
+	memset(&mc, 0, sizeof(mc));
+	if (copy_from_user(&mc, uarg, uarg_size))
+		return -EFAULT;
+	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)) || mc.flags)
+		return -EINVAL;
+
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	file = anon_inode_create_getfile("[io_uring_mock]", &io_mock_fops,
+					 NULL, O_RDWR | O_CLOEXEC, NULL);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto fail;
+	}
+
+	mc.out_fd = fd;
+	if (copy_to_user(uarg, &mc, uarg_size)) {
+		fput(file);
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	fd_install(fd, file);
+	return 0;
+fail:
+	put_unused_fd(fd);
+	return ret;
+}
+
+static int io_probe_mock(struct io_uring_cmd *cmd)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	struct io_uring_mock_probe mp, __user *uarg;
+	size_t uarg_size;
+
+	uarg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	uarg_size = READ_ONCE(sqe->len);
+
+	if (sqe->ioprio || sqe->__pad1 || sqe->addr3 || sqe->file_index ||
+	    uarg_size != sizeof(mp))
+		return -EINVAL;
+
+	memset(&mp, 0, sizeof(mp));
+	if (copy_from_user(&mp, uarg, uarg_size))
+		return -EFAULT;
+	if (!mem_is_zero(&mp, sizeof(mp)))
+		return -EINVAL;
+
+	mp.features = 0;
+
+	if (copy_to_user(uarg, &mp, uarg_size))
+		return -EFAULT;
+	return 0;
+}
+
+static int iou_mock_mgr_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	switch (cmd->cmd_op) {
+	case IORING_MOCK_MGR_CMD_PROBE:
+		return io_probe_mock(cmd);
+	case IORING_MOCK_MGR_CMD_CREATE:
+		return io_create_mock_file(cmd, issue_flags);
+	}
+	return -EOPNOTSUPP;
+}
+
+static const struct file_operations iou_mock_dev_fops = {
+	.owner		= THIS_MODULE,
+	.uring_cmd	= iou_mock_mgr_cmd,
+};
+
+static struct miscdevice iou_mock_miscdev = {
+	.minor			= MISC_DYNAMIC_MINOR,
+	.name			= "io_uring_mock",
+	.fops			= &iou_mock_dev_fops,
+};
+
+static int __init io_mock_init(void)
+{
+	int ret;
+
+	ret = misc_register(&iou_mock_miscdev);
+	if (ret < 0) {
+		pr_err("Could not initialize io_uring mock device\n");
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit io_mock_exit(void)
+{
+	misc_deregister(&iou_mock_miscdev);
+}
+
+module_init(io_mock_init)
+module_exit(io_mock_exit)
+
+MODULE_AUTHOR("Pavel Begunkov <asml.silence@gmail.com>");
+MODULE_DESCRIPTION("io_uring mock file");
+MODULE_LICENSE("GPL");
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
new file mode 100644
index 000000000000..de7318a5b1f1
--- /dev/null
+++ b/io_uring/mock_file.h
@@ -0,0 +1,22 @@
+#ifndef IOU_MOCK_H
+#define IOU_MOCK_H
+
+#include <linux/types.h>
+
+struct io_uring_mock_probe {
+	__u64		features;
+	__u64		__resv[9];
+};
+
+struct io_uring_mock_create {
+	__u32		out_fd;
+	__u32		flags;
+	__u64		__resv[15];
+};
+
+enum {
+	IORING_MOCK_MGR_CMD_PROBE,
+	IORING_MOCK_MGR_CMD_CREATE,
+};
+
+#endif
\ No newline at end of file
-- 
2.49.0


