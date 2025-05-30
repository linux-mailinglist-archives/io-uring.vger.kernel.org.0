Return-Path: <io-uring+bounces-8142-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD50AC8FC5
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:20:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03D3D1C25163
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E0C22F386;
	Fri, 30 May 2025 12:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dYQ1vgfF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AC133987
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 12:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748609460; cv=none; b=mkeqLCa1DH8VNcwQLn7JMyQtASKp9Q6PmS1rbVjRB4L3w9P8n4lgrlyw5EhpE9om7vDE70FGzp7F4KDOCfiLdMD0MPNWkP8uvR8yIYyiPBivdb9d4E1nJtWsP1J7SaOxHUr+AgHxa+cGlvMaN7sJKVjhCcsWYpqDLsVT75cHceY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748609460; c=relaxed/simple;
	bh=a+aSB8E5eetUw5oSyh9p60XT0M5YUE9q/diohBy6eKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kf54FmtjdSVwndcj3Bil09lEIPHhBQmVFboGwiQyGY+XqZ5RlC8bcOV/+b8swz5IYg5sb2cgZikI5SZ+iXN2iGGH55pKX2VDgBqGgWiimNxFF5nDxYmUtCLVpgaOO9Hs4v7rW2VjkjL1D6ucdoTu5dQIIsWJNvmAWDgWMEBIQRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dYQ1vgfF; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-604f26055c6so5738752a12.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 05:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748609457; x=1749214257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KN2tv1yUoADwZrtKlLg/4WS1fD1m0PB+MJt5S+/GNsM=;
        b=dYQ1vgfFu0Lx4GX74Z4sHDElhGVk1ndXjnf6I9EmwSgUfzdoWTTiUijUZVP1bO1q3w
         THZfG7T0X1KiH3LqpLoZKILPcUj/WPvn9KZzWWTvzTTPgaDiTbegftAVX2oRBF0hGioz
         7MGVgVbGenxYecnooAVtQCzgg++DGuvxFfybEvTmPrdlgy9BfEo4ZoaReYAYaPknK4Do
         HCYMD6OIgNHNkAZf0ZEceN00l4njc5ashyUrY64J0GjKzv+9fwacgSeZI0f2inOAOKwf
         cWp43oFqXSbgao+sO0RxkUT9d6l0NkrtAuuD6GxJK4TTaFhWcVk0ReRKoRsJExz3kFrW
         lGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748609457; x=1749214257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KN2tv1yUoADwZrtKlLg/4WS1fD1m0PB+MJt5S+/GNsM=;
        b=oDnWMkit8GUj2nTectNWO7SnPBosfStyBttgVpZxrg6wuXgWUhkcLnDnDeGRqj3eE4
         kOdMdodCnxHbOlgQPRslcwLrlaeJJhDIWqZzfryoxPrvq4fuDkySVAW5LXbGNEFKOcyc
         iieUSpDpHbIlIVSWYo/is8i7P4s8WqaeHcZB1DlgOcRHt5MxnBVaBFkahfsnjCV3oYX8
         xYohNvqoEW3WlcHPKAECKrBUpbbtyqzJgFHLkDOHoTUnx7woj1E0p8IfhL1I4rzzEeAF
         GhGfUC29g3pxx0KDcWn4XGCVf6movRBzyyy0U9Dd4soYj4YoWJW85/OoPeiIFVi+UbTd
         5Lpg==
X-Gm-Message-State: AOJu0YzaPynq2RnxJ8U/UJouEVjtTD3FPcj7W3Cq7aDD3ECYnJOiaIQy
	RCps5B/kKroyjigtZAP6E0ovuK2fJGSFokYNl5QGLpHHKfKScYg3UQj3Jwr+ZA==
X-Gm-Gg: ASbGnct/vIvsSeJWwj5YrQRWjVxOzvR5wEDLKYseQws8TKlJGm3jVHvXuAGfbsmy/Gu
	bQhg62pSk3HRMi8E9EAcSSs4zfXFTj6JWc9LG9au6TJfdKNB/qvmR2sS+43fRAsYH7PvZsn5PfN
	Gj6OqPD7B4mnQzuqJ8LIxA8sqZPjSmcAk+cqsrdDISrHPrEj2hczRt/jdRVEPA7XXSS1JnllrXU
	lH0MjQP+qDrs7VcjL/Doa06wujoYVcpCs86Dhcqx+WKAzU2TpxBp+cl0a9wS0nRhj1DYjSkj50U
	C06luab8Wm1hxtSpH7fJfF2H94/dNn9KT5k=
X-Google-Smtp-Source: AGHT+IFjj+/ivSVojD50YPwnzkB7fG/R7SVqU6io44xybuUZzudLw6t+jC3nE8x5V33IZ9G6zHj28A==
X-Received: by 2002:a17:907:3d9f:b0:aca:95eb:12e with SMTP id a640c23a62f3a-adb32ca4c4bmr249733766b.24.1748609456511;
        Fri, 30 May 2025 05:50:56 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39420sm323234266b.136.2025.05.30.05.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:50:55 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
Date: Fri, 30 May 2025 13:51:58 +0100
Message-ID: <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748609413.git.asml.silence@gmail.com>
References: <cover.1748609413.git.asml.silence@gmail.com>
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
 io_uring/mock_file.c | 142 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/mock_file.h |  22 +++++++
 4 files changed, 176 insertions(+)
 create mode 100644 io_uring/mock_file.c
 create mode 100644 io_uring/mock_file.h

diff --git a/init/Kconfig b/init/Kconfig
index 63f5974b9fa6..9e8a5b810804 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
 	  the io_uring subsystem, hence this should only be enabled for
 	  specific test purposes.
 
+config IO_URING_MOCK_FILE
+	tristate "Enable io_uring mock files (Experimental)" if EXPERT
+	default n
+	depends on IO_URING && KASAN
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
index 000000000000..3bb5614c85f1
--- /dev/null
+++ b/io_uring/mock_file.c
@@ -0,0 +1,142 @@
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
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
new file mode 100644
index 000000000000..8b00045480cd
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
-- 
2.49.0


