Return-Path: <io-uring+bounces-8537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8AB3AEE699
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E21311BC094F
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9593199947;
	Mon, 30 Jun 2025 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cD0jQz4z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC282745C
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751307339; cv=none; b=C3Nl0d3RyAGRqVC9kH4Pg8yr6KJpL7uAjxFZfyAXwz+0jKIoVhhOkwMojprdiVVeSDs2paK4IieU84fpCQpljtwLZp/u5SBvBZT53LA7UJQ23FwP8elZqqF4CxLpNbuvu1AVo9Byf3kLRzDN3Te+ZvZNahyLBtJR93V/2YdAQtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751307339; c=relaxed/simple;
	bh=ve70WjJRZxLwfbIAmx6Ml2n4dU4sH7YyzTGTKPFgEGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xvk6m4mAfyQi9sUmgroBwX0+QBmLAwL0kfRc0dhnYcHeKC127gXAQf0tx+lyZ1CALViIC6pW3o/8ENPPNDhEOW74Adxw1giHgLylfFvk69hYztfvHw6F50kuDt5pErBLmG++mLEXtUthTrodDcNavNcGsaijPzVXcMTqoCncDGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cD0jQz4z; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-74264d1832eso3107189b3a.0
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 11:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751307337; x=1751912137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkQNgfDNzCC/SpotRWrRZZPVaaEmUlOzIZv7OZJyTY8=;
        b=cD0jQz4z6X9/APM6OsrbwAX2KiCbvIp+b5Elw/Bm7OYFXUWMLqJJq4T3pm3qITBmVS
         Mp+X7QcVzFxcQfJ2jgN3ejCdldL7xOPTArFVY8O2j+bVCvvDhHL0qfEKmlxCLrbo/Nod
         M9zqRWL5bIeAnF6MLvF6auDcW6TUkQwJJh1NigZgr0uLYYgXVznhxFdkgH03n556Yq0U
         v3nkAcQ4Pdro7v+2lKTPP7oaLrTbF+urA/Y8D5pRbheNkFpQPp7jAi0fmvAhVcTlVYn1
         41RfXmsuZWttbPXZ83bWbplSKEuocMLE4l1urrRnTr3X6HwqFZlnLfQgzxDEw9c7VzLl
         Bfeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751307337; x=1751912137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkQNgfDNzCC/SpotRWrRZZPVaaEmUlOzIZv7OZJyTY8=;
        b=v0SytHtOvsynonmKXfXj0l3e78LyoJRKv/D+oroOFgfa7Y6Nnz8YbD2RzzlvSoUQ6b
         3I0OZ3tXPDbnGwSegu2mgKkk3b9nkceSwCEa3wVcRYGM+TxCwvyLGNM7x5WmbSGnym7f
         5cCSJKFYRVBq++dhpExxQHmalXmYtUQ4SEy1/22QNlIH6iRMcXNntcDys8RB5YhlG1IX
         txvKb45c0L/yejXiCkezU1t7xK4hdBcyxcNGZRg3am7AUZ8mQHHYUgv/1eQ9H0sZqJAH
         hgG5M5tU9vtDxt5xzUNVtuJw/fpSPfyQUnR/Kwbli8PtbtfYPfzVgsQDKoJAqsAGfHUv
         UFRA==
X-Gm-Message-State: AOJu0Ywf5jfsurWHSGs2C+60PCVCXp+loG0mHOxKCmXjppQ8ox6xgUp5
	GPpnCIWtXXbtH8Z0JKXKUYVcvBWeFlWKeAKTTXy/NCyIz6wxcDzTtLzKUTiGKuHz
X-Gm-Gg: ASbGncvqFJwYXc30GG8gZ5x1I+3KcTRSo7j5KQcjcGJhOp3GnQDTDxDgEPbFASg5ikd
	16UhMgHLpmHFp/NrvOLyHnCFKC3EV7MI2/FsUSFwVOfv31adexMsOfzQycaWuSSES+Ixo+I4GwM
	/EHowoxLfZzTOqr4Nxv9FFsDUUg57/g/A9tgA320uLbKVmYGR9MwfXaf6fBGjX5m0REHao5AJmq
	ya9EvrlN12q0SwvmUb+wPZl0JdLkM5eDTcHHNBc7VcuhXhIeVdurdRcnfqBR/U1e+dpoCzeGp3I
	c2MSZ1LI1wDa8gmCM1cBhhpWenw8gRrkOhcJcNWFYkI3UA==
X-Google-Smtp-Source: AGHT+IF9y4ulPPiPGuSyq7asTQUwv+0tB9puW2fCbOaY/QG1oDjLkQCPYgXbmY7nS1eU3MOXNo8GDw==
X-Received: by 2002:a05:6a00:b4d:b0:748:38fa:89bd with SMTP id d2e1a72fcca58-74af6e66382mr19084475b3a.9.1751307337237;
        Mon, 30 Jun 2025 11:15:37 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5421c59sm9505960b3a.48.2025.06.30.11.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:15:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v5 1/6] io_uring/mock: add basic infra for test mock files
Date: Mon, 30 Jun 2025 19:16:51 +0100
Message-ID: <93f21b0af58c1367a2b22635d5a7d694ad0272fc.1750599274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750599274.git.asml.silence@gmail.com>
References: <cover.1750599274.git.asml.silence@gmail.com>
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
 MAINTAINERS                             |   1 +
 include/uapi/linux/io_uring/mock_file.h |  22 ++++
 init/Kconfig                            |  11 ++
 io_uring/Makefile                       |   1 +
 io_uring/mock_file.c                    | 148 ++++++++++++++++++++++++
 5 files changed, 183 insertions(+)
 create mode 100644 include/uapi/linux/io_uring/mock_file.h
 create mode 100644 io_uring/mock_file.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a92290fffa16..088348e3b3ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12679,6 +12679,7 @@ F:	include/linux/io_uring.h
 F:	include/linux/io_uring_types.h
 F:	include/trace/events/io_uring.h
 F:	include/uapi/linux/io_uring.h
+F:	include/uapi/linux/io_uring/
 F:	io_uring/
 
 IPMI SUBSYSTEM
diff --git a/include/uapi/linux/io_uring/mock_file.h b/include/uapi/linux/io_uring/mock_file.h
new file mode 100644
index 000000000000..a44273fd526d
--- /dev/null
+++ b/include/uapi/linux/io_uring/mock_file.h
@@ -0,0 +1,22 @@
+#ifndef LINUX_IO_URING_MOCK_FILE_H
+#define LINUX_IO_URING_MOCK_FILE_H
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
diff --git a/init/Kconfig b/init/Kconfig
index af4c2f085455..c40a7c65fb4c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1801,6 +1801,17 @@ config GCOV_PROFILE_URING
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
index 000000000000..3681d0b8d8de
--- /dev/null
+++ b/io_uring/mock_file.c
@@ -0,0 +1,148 @@
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/anon_inodes.h>
+
+#include <linux/io_uring/cmd.h>
+#include <linux/io_uring_types.h>
+#include <uapi/linux/io_uring/mock_file.h>
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
+	/*
+	 * It's a testing only driver that allows exercising edge cases
+	 * that wouldn't be possible to hit otherwise.
+	 */
+	add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
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
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
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
-- 
2.49.0


