Return-Path: <io-uring+bounces-11724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1A7D2204A
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 02:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A538301818C
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 01:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63DB3212549;
	Thu, 15 Jan 2026 01:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="b4DVBNjl"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3100122A1D5;
	Thu, 15 Jan 2026 01:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440342; cv=none; b=flBTDPuWBjexgkW1BCyUJvGbzJoLAUJGKgggcl2spFUj/MiL8GIYbiNQBRveiZTieTGXOgLRv9iV2cNGMe1oMixlW1xi2tbWU+rMmSKnx+Hc3NAQafNAtC2WxWQ0iTq5xt/2HFoh6JvY9nVGKrt1LPQEaM/85QHdUygx6pPLNEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440342; c=relaxed/simple;
	bh=wbQb3CWmge51BOfTCPtb1lZhfFw2tuZcZ68aEpFTtpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TEGNDlIT4FZZSMltEFZytDBltdFg4dBGeY570UAeA9pxG53wuwUS6I+UfPmRCF+w990zevbTwyFBPMsKQ3IPMg65Al7Gklqnw2ccgi5CJ1xOyfGAgQGlBlFBJve15d+ldzLwQSJVBqEM3P+5v8NS6oTwv64xQc+LyNCWHgQjXus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=b4DVBNjl; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=xJ
	P+lwfqKpPR76hZePl+UKdzGq7g6uGlNER0Vnei9Sk=; b=b4DVBNjlYUfZ1M7NhJ
	5IRykggcd1rT3nFyqgR+VKVoq8XiI8xhN6zxvNbGIlmHLSoHFia3AhPfryIDm857
	1AC3X16iy6w7cFn6duzi9pCJD0D3BPEGyE3EGRGAtKBDdNUq4sdYrosd067K8Hd9
	5RzPoY4iLWqYtz0kO73boT0GE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wAnDqzXQWhp5NZdGA--.64S4;
	Thu, 15 Jan 2026 09:24:44 +0800 (CST)
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
Subject: [RFC PATCH v2 2/3] bsg: add uring_cmd support to BSG generic layer
Date: Thu, 15 Jan 2026 09:24:36 +0800
Message-Id: <7b27926e3ce532df32988e9b5b5fce247d20eb89.1768439194.git.yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1768439194.git.yangxiuwei@kylinos.cn>
References: <cover.1768439194.git.yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnDqzXQWhp5NZdGA--.64S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF47Zw45Kw43GF4xWF48JFb_yoW5uFyrpF
	WDZa15AFWFgr1xuas8Jan8Ar9Igw4kK347JFW2934Yyr9FyF9Yq34v9r18tFW8JrZFkayq
	q3Za9rZ8Cr1jqw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jj5l8UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRz7jGloQdw0xgAA3E

Add io_uring command handler to the generic BSG layer. This handler
validates that SQE128 and CQE32 flags are set (required for the command
structure and status information), then delegates to the SCSI-specific
handler.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 block/bsg.c             | 28 ++++++++++++++++++++++++++++
 drivers/scsi/scsi_bsg.c |  7 +++++++
 include/linux/bsg.h     |  4 ++++
 3 files changed, 39 insertions(+)

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


