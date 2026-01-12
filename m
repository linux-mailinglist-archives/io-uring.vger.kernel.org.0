Return-Path: <io-uring+bounces-11581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A8FD11523
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 09:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EE94D3045760
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 08:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E75B3451C7;
	Mon, 12 Jan 2026 08:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Z7QVEzys"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8152630F7EB;
	Mon, 12 Jan 2026 08:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768207605; cv=none; b=WmvImEkbUkLN2N8GEv6HKv+DafgCV+sE734nBxkDxnAUzp2c79NMczu0ATTaEjCTwaP5/xn7GUV1NrGaBBER+Kw3yXkg2rBbO5/IhcPzzw/8dYT24fqHkvX/30Q+a3uGVShQ7Q6DZbgPUU6L9c0OMD/HF2/kBDv07l5lQ9cM+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768207605; c=relaxed/simple;
	bh=6W+pwhEMusJhlVoQwXujAalsQImKp8AqCknuXHetF6I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZoGet590tPJrJB1IPVB/jdnWrFFch5oPsl0uzwUQU83mtaDpG/19tZ5ugS1AOD6CUIkEVpC7jeELNYVQfLXxWyAWLIyEcPatmYGQwdEWkc50K7ETYBk9qHSkhCd6HqOfvCkZF1WFNpIpfwO5JFt+BVgOIS20phVIh+368aodzlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Z7QVEzys; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=EN
	YboWHq245XH7sMOam8C93TlN9x9lZgNl9rLntdMcc=; b=Z7QVEzysJjJdZzW30u
	zx0BwehYpjCO1rUZlYGn9k/SWBDezFc2sRwTEY7UHEle4/T+QwOt0bvQpco+1424
	/j4inmBhiHZewYznKsv/nR2t4zvkGF5VvNaGosnMcybTk1LJJSj0O7s152cPhfmP
	S+gch4qLYg8LdAI6AViXLBCrg=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDX7+bQtGRpQ4BSMg--.12084S4;
	Mon, 12 Jan 2026 16:46:12 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH 2/3] bsg: add uring_cmd support to BSG generic layer
Date: Mon, 12 Jan 2026 16:46:05 +0800
Message-Id: <20260112084606.570887-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260112084606.570887-1-yangxiuwei@kylinos.cn>
References: <20260112084606.570887-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDX7+bQtGRpQ4BSMg--.12084S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF4fCw47AF48GrWfJF47urg_yoW5tr1UpF
	WDZw4UAFWFgr18ua4DCan8Ar9Igw4kK347JFW2934Yyr9FyF9Yg3yv9r18tFy8JrZ2kayq
	q3Z29rZ8Cr1jqw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYoGQUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RTVZmlktNTuVAAA3Z

Add io_uring command handler to the generic BSG layer. This handler
validates that SQE128 and CQE32 flags are set (required for the command
structure and status information), then delegates to the SCSI-specific
handler.

The handler is registered via the file_operations.uring_cmd field.
Add function declaration in include/linux/bsg.h and a stub
implementation
in drivers/scsi/scsi_bsg.c to allow compilation.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

diff --git a/block/bsg.c b/block/bsg.c
index 72157a59b788..cdccf86b8673 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -12,6 +12,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>
+#include <linux/io_uring/cmd.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -158,11 +159,38 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 }
 
+static int bsg_uring_cmd_checks(unsigned int issue_flags)
+{
+	/* BSG passthrough requires big SQE/CQE support */
+	if ((issue_flags & (IO_URING_F_SQE128|IO_URING_F_CQE32)) !=
+	    (IO_URING_F_SQE128|IO_URING_F_CQE32))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static int bsg_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct bsg_device *bd = to_bsg_device(file_inode(ioucmd->file));
+	struct request_queue *q = bd->queue;
+	bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
+	int ret;
+
+	if (!q)
+		return -EINVAL;
+
+	ret = bsg_uring_cmd_checks(issue_flags);
+	if (ret)
+		return ret;
+
+	return scsi_bsg_uring_cmd(q, ioucmd, issue_flags, open_for_write);
+}
+
 static const struct file_operations bsg_fops = {
 	.open		=	bsg_open,
 	.release	=	bsg_release,
 	.unlocked_ioctl	=	bsg_ioctl,
 	.compat_ioctl	=	compat_ptr_ioctl,
+	.uring_cmd	=	bsg_uring_cmd,
 	.owner		=	THIS_MODULE,
 	.llseek		=	default_llseek,
 };
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index a9a9ec086a7e..4399a25990fc 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/bsg.h>
+#include <linux/io_uring/cmd.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
@@ -9,6 +10,12 @@
 
 #define uptr64(val) ((void __user *)(uintptr_t)(val))
 
+int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
+		       unsigned int issue_flags, bool open_for_write)
+{
+	return -EOPNOTSUPP;
+}
+
 static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		bool open_for_write, unsigned int timeout)
 {
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index ee2df73edf83..68ec50b5e97c 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -7,6 +7,7 @@
 struct bsg_device;
 struct device;
 struct request_queue;
+struct io_uring_cmd;
 
 typedef int (bsg_sg_io_fn)(struct request_queue *, struct sg_io_v4 *hdr,
 		bool open_for_write, unsigned int timeout);
@@ -16,4 +17,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 		bsg_sg_io_fn *sg_io_fn);
 void bsg_unregister_queue(struct bsg_device *bcd);
 
+int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
+		       unsigned int issue_flags, bool open_for_write);
+
 #endif /* _LINUX_BSG_H */
-- 
2.25.1


