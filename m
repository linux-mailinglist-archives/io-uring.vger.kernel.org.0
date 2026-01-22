Return-Path: <io-uring+bounces-11878-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EO6qLuqEcWk1IAAAu9opvQ
	(envelope-from <io-uring+bounces-11878-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 03:01:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5955960A44
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 03:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CB4F74452BC
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 01:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BA7350D51;
	Thu, 22 Jan 2026 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JlMmTyaL"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100EF30FC0A;
	Thu, 22 Jan 2026 01:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047062; cv=none; b=MSWYysp62Gc8tl6pN61K0G4P5gBU463lMagFlfHHQqrobsxAmoXsyyOgyhnMc+xoSRDSaYfiteyMpEhes/ETpqMkiOtrziLC+pp+Y6N4gnxetzVIbv7JMc0TdQfwxcRDkFFdFn5v1aBS6HFvyYufECMy+ZLcN8zDOP1NbaVah8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047062; c=relaxed/simple;
	bh=lfIZ0jLgNaPiUGeahP7quzvZsc98nU1fXjHqcw7F7SI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zng2unYnvdsx23kxBHE4uOYPtppcLKCSmE7COyeBshi/LOWss+IvXlJciYtVGN4IZpH7JIHlMDOeu1Ti2M/ZnG5iMQ5T7PrrdUu+GkVwLPRqJicwMQYrz5isAMaTzAnvOTuMcy7U7Atx4EsxKmbdUQmwJXi1OfTpPMEa9hUA0Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JlMmTyaL; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=/M
	hUP/Dt1xuSF8G/z5gorE/OvykSN+Jce9zGGcqcsd8=; b=JlMmTyaLw6JjF0K7xs
	kXfT10SpoUfDImQ+GbU07oox7cHjzLUjKsEGP4Yu3/N6sQ2ob65XJklt1uw5fpFL
	H42QVR7JPXk1edKP8sOshBHZqpUAzo34Y8M2Zus3gIZimN1gquywhsHZ26QfxJFy
	0oaOYIhk6GyTLZYU8Bg9Ye2/w=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgBHTZvng3Fp059XOA--.28408S4;
	Thu, 22 Jan 2026 09:56:59 +0800 (CST)
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
Subject: [RFC PATCH v4 2/3] bsg: add uring_cmd support to BSG generic layer
Date: Thu, 22 Jan 2026 09:56:52 +0800
Message-Id: <20260122015653.703188-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260122015653.703188-1-yangxiuwei@kylinos.cn>
References: <20260122015653.703188-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgBHTZvng3Fp059XOA--.28408S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3XFWxJFW8XF4xuF48XF1kKrg_yoW7Cr1DpF
	WrXa15JrWFgr4xuFZ8JFs8Cr9Igw48K3yxJFyI934YkrnFyr9Yqr1kuFy0qFWrJrWkCayY
	qanYqrWDCr18Aw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjv38UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gvRYmlxg+tZgQAA36
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11878-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:mid,kylinos.cn:email,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 5955960A44
X-Rspamd-Action: no action

Add io_uring command handler to the generic BSG layer. This handler
validates SQE128/CQE32 flags and command structure, then delegates to
the protocol-specific handler via a callback function pointer registered
during bsg_register_queue().

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 block/bsg-lib.c         |  2 +-
 block/bsg.c             | 35 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_bsg.c | 10 +++++++++-
 include/linux/bsg.h     |  6 +++++-
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 9ceb5d0832f5..f8d0b6d5bf82 100644
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
index 72157a59b788..0bd9186a9139 100644
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
@@ -158,11 +160,40 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
+	if (!q)
+		return -EINVAL;
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
@@ -187,7 +218,8 @@ void bsg_unregister_queue(struct bsg_device *bd)
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
 struct bsg_device *bsg_register_queue(struct request_queue *q,
-		struct device *parent, const char *name, bsg_sg_io_fn *sg_io_fn)
+		struct device *parent, const char *name, bsg_sg_io_fn *sg_io_fn,
+		bsg_uring_cmd_fn *uring_cmd_fn)
 {
 	struct bsg_device *bd;
 	int ret;
@@ -199,6 +231,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
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


