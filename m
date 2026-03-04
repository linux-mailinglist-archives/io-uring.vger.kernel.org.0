Return-Path: <io-uring+bounces-12549-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0IJ9B4fnp2mDlgAAu9opvQ
	(envelope-from <io-uring+bounces-12549-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 09:04:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFD11FC207
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 09:04:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4A805301492B
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 08:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7283890FF;
	Wed,  4 Mar 2026 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LWA1MmP6"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A3F3890FA;
	Wed,  4 Mar 2026 08:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772611449; cv=none; b=CxnKvjtp+aceQY7FteDWmA+RsYeT81pIg47XEBiORdiTOaCqLGVaUuZ+qXNwh6jyr5N/ItXNkKMNN2q2/xwGqD/ld3aoHUwnqj++jnYwc21xf+LjKvcKvYiVEtpC6GNpYkSLe/yBmhbCQSgs0+qn2auP48alKRbfl0dqvu4KDDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772611449; c=relaxed/simple;
	bh=w5vyPlIfOAMnbGPPUCuguXE4vYVsW8ud2BcFogYfJXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lNGDAPZhKf5fis9CQOa+uOqTngOSDSFX2qWhXq53z+allLna+AMUlQjCdsyMCocg5LESOkEiiV6qT/cjl95cb/AMggfxp/XJwcErEyTq0o6uSm2pbmlZejVlqCC8Fd/QtDmqRlLII5gWSab5jmfVpb8YS7miKL3OfK5aVjrpb1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LWA1MmP6; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=js
	Rq3aKCns44BgXCd6DPRxFhJT1owmPQTzZLhub7kdU=; b=LWA1MmP6NHNOoGrbiq
	YHL8w+O4A7fv44Ga0pyORbyYeOVVbgneTK/zQAtDFqNZE3xrh1fqWXZvf4l1Mt/G
	xXXBmWASiXPENt5gGNSEw+fCkNaumSSvaFyCxg1qc9ZB1brzrJ/spQ0xqjixoqjY
	4JcXn2WP2mvW5KxN8zuGYiG4c=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3CvhD56dpCDV7PA--.26869S4;
	Wed, 04 Mar 2026 16:03:24 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v5 2/3] bsg: add io_uring command support to generic layer
Date: Wed,  4 Mar 2026 16:03:12 +0800
Message-Id: <20260304080313.675768-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3CvhD56dpCDV7PA--.26869S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxKFWrtw4rJr4kuFyftw17trb_yoW7CryrpF
	WrXa15JrWFgr4xua98JFs8Jr9Iqw48K3yxJFyI9345KrnFyr9Yqr1kuFy0qFWrJrWkCayY
	qanYqrWDCr1UAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j47KxUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gxR4Wmn50yeBgAA3r
X-Rspamd-Queue-Id: 1CFD11FC207
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12549-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add an io_uring command handler to the generic BSG layer. The new
.uring_cmd file operation validates io_uring features and delegates
handling to a per-queue bsg_uring_cmd_fn callback.

Extend bsg_register_queue() so transport drivers can register both
sg_io and io_uring command handlers.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 block/bsg-lib.c         |  2 +-
 block/bsg.c             | 32 +++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_bsg.c | 10 +++++++++-
 include/linux/bsg.h     |  6 +++++-
 4 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 20cd0ef3c394..fdb4b290ca68 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -393,7 +393,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
-	bset->bd = bsg_register_queue(q, dev, name, bsg_transport_sg_io_fn);
+	bset->bd = bsg_register_queue(q, dev, name, bsg_transport_sg_io_fn, NULL);
 	if (IS_ERR(bset->bd)) {
 		ret = PTR_ERR(bset->bd);
 		goto out_cleanup_queue;
diff --git a/block/bsg.c b/block/bsg.c
index e0af6206ed28..8f23296a7033 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -12,6 +12,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>
+#include <linux/io_uring/cmd.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -28,6 +29,7 @@ struct bsg_device {
 	unsigned int timeout;
 	unsigned int reserved_size;
 	bsg_sg_io_fn *sg_io_fn;
+	bsg_uring_cmd_fn *uring_cmd_fn;
 };
 
 static inline struct bsg_device *to_bsg_device(struct inode *inode)
@@ -158,11 +160,37 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
+static int bsg_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct bsg_device *bd = to_bsg_device(file_inode(ioucmd->file));
+	struct request_queue *q = bd->queue;
+	bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
+	int ret;
+
+	ret = bsg_check_uring_features(issue_flags);
+	if (ret)
+		return ret;
+
+	if (bd->uring_cmd_fn)
+		return bd->uring_cmd_fn(q, ioucmd, issue_flags, open_for_write);
+	return -EOPNOTSUPP;
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
@@ -187,7 +215,8 @@ void bsg_unregister_queue(struct bsg_device *bd)
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
 struct bsg_device *bsg_register_queue(struct request_queue *q,
-		struct device *parent, const char *name, bsg_sg_io_fn *sg_io_fn)
+		struct device *parent, const char *name, bsg_sg_io_fn *sg_io_fn,
+		bsg_uring_cmd_fn *uring_cmd_fn)
 {
 	struct bsg_device *bd;
 	int ret;
@@ -199,6 +228,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	bd->reserved_size = INT_MAX;
 	bd->queue = q;
 	bd->sg_io_fn = sg_io_fn;
+	bd->uring_cmd_fn = uring_cmd_fn;
 
 	ret = ida_alloc_max(&bsg_minor_ida, BSG_MAX_DEVS - 1, GFP_KERNEL);
 	if (ret < 0) {
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index a9a9ec086a7e..4d57e524e141 100644
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
 
+static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
+			       unsigned int issue_flags, bool open_for_write)
+{
+	return -EOPNOTSUPP;
+}
+
 static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		bool open_for_write, unsigned int timeout)
 {
@@ -99,5 +106,6 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 struct bsg_device *scsi_bsg_register_queue(struct scsi_device *sdev)
 {
 	return bsg_register_queue(sdev->request_queue, &sdev->sdev_gendev,
-			dev_name(&sdev->sdev_gendev), scsi_bsg_sg_io_fn);
+			dev_name(&sdev->sdev_gendev), scsi_bsg_sg_io_fn,
+			scsi_bsg_uring_cmd);
 }
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index ee2df73edf83..162730bfc2d8 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -7,13 +7,17 @@
 struct bsg_device;
 struct device;
 struct request_queue;
+struct io_uring_cmd;
 
 typedef int (bsg_sg_io_fn)(struct request_queue *, struct sg_io_v4 *hdr,
 		bool open_for_write, unsigned int timeout);
 
+typedef int (bsg_uring_cmd_fn)(struct request_queue *q, struct io_uring_cmd *ioucmd,
+			       unsigned int issue_flags, bool open_for_write);
+
 struct bsg_device *bsg_register_queue(struct request_queue *q,
 		struct device *parent, const char *name,
-		bsg_sg_io_fn *sg_io_fn);
+		bsg_sg_io_fn *sg_io_fn, bsg_uring_cmd_fn *uring_cmd_fn);
 void bsg_unregister_queue(struct bsg_device *bcd);
 
 #endif /* _LINUX_BSG_H */
-- 
2.25.1


