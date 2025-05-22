Return-Path: <io-uring+bounces-8081-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CC0AC0F7A
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 17:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4736C7A331E
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB2128FAA4;
	Thu, 22 May 2025 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHmcuMZJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8608628FAB3
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926552; cv=none; b=GAF9Us11OntOrGIBUbsA5Ft+I+KJDutdRAP30PbWoTbSXymYP+JM8D+Z78kDUCfigxH+pO/BVjq81IrprbU9alkGoMmIbPvwc9Yl6UV04SxB3y7i3Y38mnt4ad75C3+uNsdAO8u10ESz3yOlnFajlAPU74rmgbGj36BhQfTNiQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926552; c=relaxed/simple;
	bh=HJRb7M57RacP9alnQULDs7ek8EMwAc+JmzF+ReQQy7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uzn4gEB9oAyriJKJkhIkN3PqzSPE7tgn19u53pV5N51x6XefEIKPN+0XqXykuzuLrTMWJ61Q8ONgf9qmyKj60QdkZMfNdP1YKLv993tZfDENDkTliZpWlRNmCTfs7FUWRAzLEgU22vgid90mLyGq2qxUoconizYo7qtMtQRJXBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHmcuMZJ; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-601c5cd15ecso7547140a12.2
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 08:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747926548; x=1748531348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXI0h2BEqhWHU+xmD0RbFYjHlvwnZtWJE/XIuLw6PKI=;
        b=jHmcuMZJk4oaQgjYdK8ybvDeDWK/Fz5tFN4S80oo71hbQDZLdNGdkB4fT3y6Xdtv/3
         oTWGrGi51MK8pMjJ1RZrp/nyH8cMbNhjLNypIs7fSk1jn2gHEUxzBBTM9cugh3xq/hWf
         vv0q+B/ryUKGi7z8fz9q8EBTficLIKMLXQoTS81rgk3mD3lXViEX1Bz3UJYmirsW+KG3
         p0lKExJjKYA2BB4hdhDyiLy7jvVPrG1h+ItWNiLcJQy9gZXxSGTRHQzGVuz4gGH1hvoS
         yCzftzQic/om3eEwVyGMQDeCfoJL/ttmyedPNEYrISQei9odl2S4M0QfTU8rLY3EHMqg
         1JdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747926548; x=1748531348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXI0h2BEqhWHU+xmD0RbFYjHlvwnZtWJE/XIuLw6PKI=;
        b=Auqc1m9tMWOSaAJKnlnoNZrRsieDfJm9PNw83ybwPSJZ3mPmriLJdK+ip7n0bip4nl
         Wd20FRWHPVcGo6qjBnI0e6ESech3Q9z/n9hA3LAma+8bJY3WepLIsQ4nDfIcvpWodMnH
         WvnM+R28hFlNkdlUl7OIi6EVe6GqwqOpotIxDD5g9vxZadPQidPfL93uQm+1rylhMgOh
         ZaBgzdSX33tNLqSCDixpqCIRFe5r6XzYc1sYx0ylXCqDZfGqItf5Qdq7+2/CYi3zZgjk
         8wS9+50e4xc/tb2RAwUddaqdEIG3VCcUWpDAlJ3860OlpshUk47jUT2ri1nAuDMLRjsr
         YQ8Q==
X-Gm-Message-State: AOJu0Yww2hJL6j3g1xAizyscMViDUePif5fvhf9iTRWyLEPcmuC4La4i
	p19VKhLd3GLS3PA1S3lgRHBl02VHrP5DZxpzjqJB6Y6yZDnBWW/KLKdbwvoIWg==
X-Gm-Gg: ASbGncsRx/IlgYciNFlDIQ0SmBbMfrCjDz30NOTACQu2nogS3P9/ajxvkNAGhfzjNnV
	TP4SssebZQ9W7Aso7onOD3z7EVA5oh1jtf7str0mJ0jhrVybh/GhueQObw98Gk3DOrzuoWHpnjT
	iv+9kzceKytt453vv2xKVWbIgPt/D479NlqNRC5/WDww5oLORI5qxrvY/d19HmNqTxoA2xPBHg9
	KRbhWUaQtEvjnmSuJpwVwQQQE0heDAYb141pg322qFXwlrJozunQ80SggA4mNb8U+zFjXCdW6lz
	NfpJbP0Rul/SdRx/ZS82n5nXgyfAht8dpow=
X-Google-Smtp-Source: AGHT+IGGI06rNiOnMyAYcz3Q9c5mczaAkltOOW3grg2gvossPEc0RgGOoyzTeM40x8mXyIzKNVlhXw==
X-Received: by 2002:a05:6402:1e89:b0:5ff:97dd:21d6 with SMTP id 4fb4d7f45d1cf-601140a21bamr23080660a12.17.1747926547871;
        Thu, 22 May 2025 08:09:07 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:30e5])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005ae3953esm10684305a12.73.2025.05.22.08.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 08:09:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH 1/2] io_uring/mock: add basic infra for test mock files
Date: Thu, 22 May 2025 16:10:06 +0100
Message-ID: <a62df1848f5f1ccd0c5e8c07d3fce8adb67d6c3f.1747922436.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747922436.git.asml.silence@gmail.com>
References: <cover.1747922436.git.asml.silence@gmail.com>
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
index 11a739927a62..a630f369828d 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					statx.o timeout.o fdinfo.o cancel.o \
 					waitid.o register.o truncate.o \
 					memmap.o alloc_cache.o
+obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
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


