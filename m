Return-Path: <io-uring+bounces-2929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F43F95D369
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 18:29:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 749BF1C238FD
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16BD18E058;
	Fri, 23 Aug 2024 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="JU2JkcdV"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB3418E035
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724430515; cv=none; b=uupGKsWq4z6bAWyGagi2/p1VL2lXJhPcNjEv2suwqRMfhkUzSEP9epFKXyEkzfqb5HhLIGOUO2LZ1zinBSLJciIkQzbl/EbJMHGTh8m/BE7cuTqhDZTSKuACdkruVV3ggWNYRPod+tqpVqf7E8PyrChQZZLexV3pNd8BFZwddNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724430515; c=relaxed/simple;
	bh=Lyc+RLgPEKaV+NIXlSBDwzjphWjNBlW7CTjNDOKuB8c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COH2js4+E1gDa4NekWFiEfze1JFsVVFQo4+73/szz7MICI6s2PZwNR2Jw//Tqo4JaAczLfiO59oL3EwntwDxTcwPShDkPaYGgCMeJzlJYg1u6SgBzeCwBfmYwN+yaZHYQKB7iaULryVJvWZmx26grNJLJxJLOnHyEM6rI99Cscw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=JU2JkcdV; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 47NB7bn4019959
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	facebook; bh=fOUw6CdGX1PPumGSGOMj1IYOV4pSLC2cZMw0P2VH6d0=; b=JU2
	JkcdVFbQ8CJ0J+PthPae3VE+WVz7jaS0/r5eGHoBN1lpNwqvv8NlHdloqWox1Q2o
	macPcAvdaPTmVu2C/DXxXJHfMvd4b2w83qXnVNFnHi/AVH14tzHUXG59ROtp67e7
	uCqmDBY7aHM47UQOVemu6M20p6L/V+FudbA0TKUY=
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 416c985qyf-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:32 -0700 (PDT)
Received: from twshared0326.08.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 23 Aug 2024 16:28:25 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 584115CB7F81; Fri, 23 Aug 2024 17:28:13 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <io-uring@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 6/6] btrfs: add io_uring interface for encoded reads
Date: Fri, 23 Aug 2024 17:27:48 +0100
Message-ID: <20240823162810.1668399-7-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240823162810.1668399-1-maharmstone@fb.com>
References: <20240823162810.1668399-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qLE7HxnpypnYYgw7zixo5UezEUVTwT_H
X-Proofpoint-GUID: qLE7HxnpypnYYgw7zixo5UezEUVTwT_H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_13,2024-08-22_01,2024-05-17_01

Adds an io_uring interface for asynchronous encoded reads, using the
same interface as for the ioctl. To use this you would use an SQE opcode
of IORING_OP_URING_CMD, the cmd_op would be BTRFS_IOC_ENCODED_READ, and
addr would point to the userspace address of the
btrfs_ioctl_encoded_io_args struct. As with the ioctl, you need to have
CAP_SYS_ADMIN for this to work.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h |  2 ++
 fs/btrfs/file.c        |  1 +
 fs/btrfs/inode.c       | 57 ++++++++++++++++++++++++++++++++++++----
 fs/btrfs/ioctl.c       | 59 ++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ioctl.h       |  3 +++
 5 files changed, 115 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index a5d786c6d7d4..62e5757d3ba2 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -620,6 +620,8 @@ struct btrfs_encoded_read_private {
 	struct btrfs_ioctl_encoded_io_args args;
 	struct file *file;
 	void __user *copy_out;
+	struct io_uring_cmd *cmd;
+	unsigned int issue_flags;
 };
=20
 ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9914419f3b7d..2db76422d126 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3769,6 +3769,7 @@ const struct file_operations btrfs_file_operations =
=3D {
 	.compat_ioctl	=3D btrfs_compat_ioctl,
 #endif
 	.remap_file_range =3D btrfs_remap_file_range,
+	.uring_cmd	=3D btrfs_uring_cmd,
 	.fop_flags	=3D FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC,
 };
=20
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1bd4c74e8c51..e4458168c340 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -34,6 +34,7 @@
 #include <linux/iomap.h>
 #include <asm/unaligned.h>
 #include <linux/fsverity.h>
+#include <linux/io_uring/cmd.h>
 #include "misc.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -9078,7 +9079,7 @@ static ssize_t btrfs_encoded_read_inline(
 	return ret;
 }
=20
-static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
+static void btrfs_encoded_read_ioctl_endio(struct btrfs_bio *bbio)
 {
 	struct btrfs_encoded_read_private *priv =3D bbio->private;
=20
@@ -9098,6 +9099,47 @@ static void btrfs_encoded_read_endio(struct btrfs_=
bio *bbio)
 	bio_put(&bbio->bio);
 }
=20
+static inline struct btrfs_encoded_read_private *btrfs_uring_encoded_rea=
d_pdu(
+		struct io_uring_cmd *cmd)
+{
+	return *(struct btrfs_encoded_read_private **)cmd->pdu;
+}
+static void btrfs_finish_uring_encoded_read(struct io_uring_cmd *cmd,
+					    unsigned int issue_flags)
+{
+	struct btrfs_encoded_read_private *priv;
+	ssize_t ret;
+
+	priv =3D btrfs_uring_encoded_read_pdu(cmd);
+	ret =3D btrfs_encoded_read_finish(priv, -EIOCBQUEUED);
+
+	io_uring_cmd_done(priv->cmd, ret, 0, priv->issue_flags);
+
+	kfree(priv);
+}
+
+static void btrfs_encoded_read_uring_endio(struct btrfs_bio *bbio)
+{
+	struct btrfs_encoded_read_private *priv =3D bbio->private;
+
+	if (bbio->bio.bi_status) {
+		/*
+		 * The memory barrier implied by the atomic_dec_return() here
+		 * pairs with the memory barrier implied by the
+		 * atomic_dec_return() or io_wait_event() in
+		 * btrfs_encoded_read_regular_fill_pages() to ensure that this
+		 * write is observed before the load of status in
+		 * btrfs_encoded_read_regular_fill_pages().
+		 */
+		WRITE_ONCE(priv->status, bbio->bio.bi_status);
+	}
+	if (!atomic_dec_return(&priv->pending)) {
+		io_uring_cmd_complete_in_task(priv->cmd,
+					      btrfs_finish_uring_encoded_read);
+	}
+	bio_put(&bbio->bio);
+}
+
 static void _btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *i=
node,
 					u64 file_offset, u64 disk_bytenr,
 					u64 disk_io_size,
@@ -9106,11 +9148,16 @@ static void _btrfs_encoded_read_regular_fill_page=
s(struct btrfs_inode *inode,
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
 	unsigned long i =3D 0;
 	struct btrfs_bio *bbio;
+	btrfs_bio_end_io_t cb;
=20
-	init_waitqueue_head(&priv->wait);
+	if (priv->cmd) {
+		cb =3D btrfs_encoded_read_uring_endio;
+	} else {
+		init_waitqueue_head(&priv->wait);
+		cb =3D btrfs_encoded_read_ioctl_endio;
+	}
=20
-	bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-			       btrfs_encoded_read_endio, priv);
+	bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info, cb, priv);
 	bbio->bio.bi_iter.bi_sector =3D disk_bytenr >> SECTOR_SHIFT;
 	bbio->inode =3D inode;
=20
@@ -9122,7 +9169,7 @@ static void _btrfs_encoded_read_regular_fill_pages(=
struct btrfs_inode *inode,
 			btrfs_submit_bio(bbio, 0);
=20
 			bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-					       btrfs_encoded_read_endio, priv);
+					       cb, priv);
 			bbio->bio.bi_iter.bi_sector =3D disk_bytenr >> SECTOR_SHIFT;
 			bbio->inode =3D inode;
 			continue;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c1886209933a..85a512a9ca64 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -29,6 +29,7 @@
 #include <linux/fileattr.h>
 #include <linux/fsverity.h>
 #include <linux/sched/xacct.h>
+#include <linux/io_uring/cmd.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "export.h"
@@ -4509,8 +4510,8 @@ static int _btrfs_ioctl_send(struct btrfs_inode *in=
ode, void __user *argp, bool
 	return ret;
 }
=20
-static ssize_t btrfs_encoded_read_finish(struct btrfs_encoded_read_priva=
te *priv,
-					 ssize_t ret)
+ssize_t btrfs_encoded_read_finish(struct btrfs_encoded_read_private *pri=
v,
+				  ssize_t ret)
 {
 	size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded_io_ar=
gs,
 					     flags);
@@ -4725,6 +4726,60 @@ static int btrfs_ioctl_encoded_write(struct file *=
file, void __user *argp, bool
 	return ret;
 }
=20
+static void btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
+				     unsigned int issue_flags)
+{
+	ssize_t ret;
+	void __user *argp =3D (void __user *)(uintptr_t)cmd->sqe->addr;
+	struct btrfs_encoded_read_private *priv;
+	bool compat =3D issue_flags & IO_URING_F_COMPAT;
+
+	priv =3D kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret =3D -ENOMEM;
+		goto out_uring;
+	}
+
+	ret =3D btrfs_prepare_encoded_read(priv, cmd->file, compat, argp);
+	if (ret)
+		goto out_finish;
+
+	if (iov_iter_count(&priv->iter) =3D=3D 0) {
+		ret =3D 0;
+		goto out_finish;
+	}
+
+	*(struct btrfs_encoded_read_private **)cmd->pdu =3D priv;
+	priv->cmd =3D cmd;
+	priv->issue_flags =3D issue_flags;
+	ret =3D btrfs_encoded_read(priv);
+
+	if (ret =3D=3D -EIOCBQUEUED && atomic_dec_return(&priv->pending))
+		return;
+
+out_finish:
+	ret =3D btrfs_encoded_read_finish(priv, ret);
+	kfree(priv);
+
+out_uring:
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
+}
+
+int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	switch (cmd->cmd_op) {
+	case BTRFS_IOC_ENCODED_READ:
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+	case BTRFS_IOC_ENCODED_READ_32:
+#endif
+		btrfs_uring_encoded_read(cmd, issue_flags);
+		return -EIOCBQUEUED;
+	}
+
+	io_uring_cmd_done(cmd, -EINVAL, 0, issue_flags);
+	return -EIOCBQUEUED;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 19cd26b0244a..9d1522de79d3 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -22,5 +22,8 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *in=
ode);
 int __pure btrfs_is_empty_uuid(const u8 *uuid);
 void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 				     struct btrfs_ioctl_balance_args *bargs);
+int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+ssize_t btrfs_encoded_read_finish(struct btrfs_encoded_read_private *pri=
v,
+				  ssize_t ret);
=20
 #endif
--=20
2.44.2


