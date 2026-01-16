Return-Path: <io-uring+bounces-11755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 350B8D2B613
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 05:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D3567306EAF0
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 04:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF554346A05;
	Fri, 16 Jan 2026 04:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="kdtbFJDE"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1678346799;
	Fri, 16 Jan 2026 04:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537577; cv=none; b=WIGXzcN7f2dShJ6Gy8n32GnfgtmHD2kcXXHsccjAZI98pytpv+R8sflf/QU49+veczKom3scdIB8RIdKwD05sgIxvc2VhNzDe1GDtbzAuEiiUNQuK/3CBamj1ZfHPEs2iXYiQ8r4AbVcF679ghfR9RuH3aLB8IO9s1PhvszCao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537577; c=relaxed/simple;
	bh=Qr5lUgAktKOJmys6Br2iAwRK7HwEimvJRX/uXVsQDPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CTsoRyvVKFjYD2F3vW5TY0/EcdMYjN21c9Preyu2t/Cdw7QzT1KfroOgp114nZk0j+54ZOxhUrwrS4ELHQBaHqXWJwJZi+L6u6yBqRkbuqPaFtJHQJNWHiRb1PP6nEgthWHw7x/HZSw0IOddBhxRq3f+d88G4eM5XX+oXuHgFzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=kdtbFJDE; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=UM
	R+lduVQA9MwdVRpKAo5jQnt5jOvzxHNrUdndIvvwQ=; b=kdtbFJDESgSCA4Jgwo
	aGMMaBwgL2XpFtiy6MCV6gLZGooVt7vqQaKd5ktSYqUG7nsby8SQ5ptHEjCTgWvK
	FBXBhZdm6jqWziAQjtMNq3L3ZePP5wtm4IkIwLo9r5dxBmQYAiAayiumxp3dnEgb
	2oAsFaqKmsK4oMAj+D1IXoRQU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAXCLKuvWlpM1mcFw--.2330S4;
	Fri, 16 Jan 2026 12:25:23 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH v3 2/3] bsg: add uring_cmd support to BSG generic layer
Date: Fri, 16 Jan 2026 12:25:15 +0800
Message-Id: <217eb9315df1a2aea32a595a12b8a5b16ba597b5.1768536312.git.yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1768536312.git.yangxiuwei@kylinos.cn>
References: <cover.1768536312.git.yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXCLKuvWlpM1mcFw--.2330S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF47Zw45Kw4kXFWDXF48Crg_yoWrCw47pF
	WUXw45AFWFgr1Ika95Cws8Cr9Iqwn7Kay7trW2g34YyryqyF9Yg3Wv9r18tFZ3JrZFkayU
	Xrs2grZ8Cr10qw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjFAJUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhNQ4GlpvbPMqwAA3I

Add io_uring command handler to the generic BSG layer. This handler
validates that SQE128 and CQE32 flags are set (required for the command
structure and status information), then delegates to the SCSI-specific
handler.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 block/bsg.c             | 66 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_bsg.c |  7 +++++
 include/linux/bsg.h     |  4 +++
 3 files changed, 77 insertions(+)

diff --git a/block/bsg.c b/block/bsg.c
index 72157a59b788..51f9f3cc57c4 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -12,6 +12,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>
+#include <linux/io_uring/cmd.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -158,11 +159,76 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 }
 
+static int bsg_check_uring_features(unsigned int issue_flags)
+{
+	/* BSG passthrough requires big SQE/CQE support */
+	if ((issue_flags & (IO_URING_F_SQE128|IO_URING_F_CQE32)) !=
+	    (IO_URING_F_SQE128|IO_URING_F_CQE32))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static int bsg_validate_command(const struct bsg_uring_cmd *cmd)
+{
+	if (cmd->protocol != BSG_PROTOCOL_SCSI)
+		return -EINVAL;
+
+	if (cmd->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
+		if (!cmd->request || cmd->request_len == 0)
+			return -EINVAL;
+
+		if (cmd->dout_xfer_len && cmd->din_xfer_len) {
+			pr_warn_once("BIDI support in bsg has been removed.\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (cmd->dout_iovec_count > 0 || cmd->din_iovec_count > 0)
+			return -EOPNOTSUPP;
+
+		return 0;
+	} else if (cmd->subprotocol == BSG_SUB_PROTOCOL_SCSI_TRANSPORT) {
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int bsg_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct bsg_device *bd = to_bsg_device(file_inode(ioucmd->file));
+	struct request_queue *q = bd->queue;
+	bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
+	const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
+	int ret;
+
+	if (!q)
+		return -EINVAL;
+
+	ret = bsg_check_uring_features(issue_flags);
+	if (ret)
+		return ret;
+
+	ret = bsg_validate_command(cmd);
+	if (ret)
+		return ret;
+
+	if (cmd->protocol == BSG_PROTOCOL_SCSI) {
+		if (cmd->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD)
+			return scsi_bsg_uring_cmd(q, ioucmd, issue_flags, open_for_write);
+		else if (cmd->subprotocol == BSG_SUB_PROTOCOL_SCSI_TRANSPORT)
+			return -EOPNOTSUPP;
+		return -EINVAL;
+	}
+
+	return -EINVAL;
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


