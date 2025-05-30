Return-Path: <io-uring+bounces-8125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6614AC8A08
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 10:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8F671BA33BD
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 08:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAE22185BC;
	Fri, 30 May 2025 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1UubnfK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4E51FF603
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594232; cv=none; b=TcxBPc/Ol891hnBWDX3UlnrxE8ndJJ1t32hxmN2+gl39sR/NKS9iGXwvo7zIQdh1nNHFc2Zrq9RVAiBRmxFuWEuhImPSqElq5rBdknFY8dCe0fnCJJV5xQ6nTrUCEljkEvux6z/fu3Uj3K3eTVaDvrzOkXgpk2V5MbgyE6FueFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594232; c=relaxed/simple;
	bh=mP3W2T/dqzLbInOiCU0zM64/VNUOmG6uHIVcgZTusyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7KhvZaaLgQN3CghRrizCvG7j9QZ09917xH/kqtAiyXAirpCcNKnUDy4GsM88CDkFJbNhMRSJhga5r4lrOaipcO9D5DvPoA2q8yDwT6AvzxmJamPUROMFTDVcdk1hq8nA6DnbSG+vh4K+MOYPo+fNTe4ZSRxDiRR+AIz7JIG934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1UubnfK; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ad88105874aso269920466b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 01:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748594228; x=1749199028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tTM4SHtxezS7PuLKViqIneZO9yQHD5aomSIY9TgI9o=;
        b=C1UubnfKj0j5VV0KDhxucLyC1e6lN/06ALBgaC/7FrogX6AGUthl/xASwh+0++vX+4
         v6wCV/Bq4KQ9jYwR0/LHS10k5z5RivqzFjz1NpLe1mSwYQOmdoi5JOvNFZ7C+6YKKORy
         TGQTdfamOiM4QPyZift5TfpETZgOQGY+2rNPWguIpsjpFdoNNNndpd/T/B0r5vqRgb63
         9BFuVC5K7iUNR7/dwnStkSQ6q3DvfLck8PW7gbvqtrvEI5kk+Bi4++eG+irMe4gLa1vi
         RemwG2uzlNHarVdIdfGKLQO8ILPo67hmSFNz6frm4G1LsqoF9Ol0n/oigva9XM5eI9ex
         Zujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748594228; x=1749199028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tTM4SHtxezS7PuLKViqIneZO9yQHD5aomSIY9TgI9o=;
        b=vJyOAbBDKk7eMz8N1F11TlmMsY3PMfeHc9NhiROqf9opaWu2gp/JifWIU873t74YHT
         VghXnJiYWqeFBoNIxRCRsFlgliQSvuiu4f0PG+KxZx5p5Fx7loZBGsHKgJ7TjG2kyiGA
         NGeLyZkf5NIQqBPHboeCuqpUh0/QHP2D7gznNWNv73l757D7ANj9d1qktNi/7//u2O1F
         5QSoc+eO8zJIEEERRGZ8kSMJmrAsk28gWyxyCB4wHUS1gYnUwchSeA+RSTHHUgp5mLO2
         osKsY7yexx6+hZsrx+6iBELGmEqixcsFgbH/E1TUcfrU8CddIraGrfC3tnELWMrKDdGQ
         aCiw==
X-Gm-Message-State: AOJu0YyAThPK9t4WMOxV/48NKdf2jQGsNMd6q1ZO/U+xFBjVbSXmBtYu
	XbAbCcZbBvp0t07hZ089j8tfuhlunxEwj/Qg1jetWjIGuv8KlVjq0rVAxGD1bw==
X-Gm-Gg: ASbGncvSUTBf/CH2/r+mOKSgoonwvy4FMxBqf1yN011AzdI9m1QrEXU+iJcaCxQKN5M
	gFY9P2wIoZu/cSpnJYapA2uF+ZDHdtRHiZK3D031DXqPmnTz8yEKlWCV6Wxz+lU2Pt3KKMoVOMv
	Y/BLwK+8uxt20uC17lfOLJIkJsi4aeZ+LqSCDG3sxNVr/Jc31WG1lOR0NcILiiYLvA6wo7Rqbi1
	NpazcnEFTTwQhA9UELjJYtIuSdENunnUaFoudZSXOtQ3WZ9Zv08rM008tIRbdaVZpAg4TVvZrS8
	xUuPIk49j4J7HbvV6H86PWG8OCU6F8Y97urhSnkGzwxI4Q==
X-Google-Smtp-Source: AGHT+IGNHTdhogILOXHrqrLNNgvyOMQbqKyhvcf34irhSWl3+9e6I5l5bgxPAF/xugGu+UjXJqgREQ==
X-Received: by 2002:a17:907:72ce:b0:ad8:9e80:6bb4 with SMTP id a640c23a62f3a-adb322d8d94mr246409666b.20.1748594227641;
        Fri, 30 May 2025 01:37:07 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:65cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad696d1sm288126566b.161.2025.05.30.01.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 01:37:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 1/6] io_uring/mock: add basic infra for test mock files
Date: Fri, 30 May 2025 09:38:06 +0100
Message-ID: <5e09d2749eec4dead0f86aa18ae757551d9b2334.1748594274.git.asml.silence@gmail.com>
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


