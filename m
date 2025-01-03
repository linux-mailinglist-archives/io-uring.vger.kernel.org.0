Return-Path: <io-uring+bounces-5660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D92A00AFD
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 16:03:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B891188465A
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 15:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6001FAC42;
	Fri,  3 Jan 2025 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="o4yRC+xx"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0E11FAC30
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735916571; cv=none; b=E4N8stbCnwOUdG3AzNGPs0F4frMhTg4wWNpgSrY5wEH3d8+Du1CK6aDUhVCA2o4EVQ0aoUQ+zHH6yjmEhaOjSTCw8sRkk1wln9jU16IGS6M+CA/kFXC7C7nSvK80dXVoVwsCk8Z0dn6+AQZ4Nf6YpJ3pldepz2IF2i1t/5GUSxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735916571; c=relaxed/simple;
	bh=giMEFEEAFOP4LJMoc3A1BLAawFUvReuK96IV6T9xtmI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6XyQgMF7C7fJKiWD84Ig1Eodxt4LVnB/zRFLvHppPhOpkqs3cl07fn8mh8uUdtzXc2XhZJOQt5TulGcPaVAhdyaCkHz3q4d154mRi4lyioR6WqnHCgAUfLh0vezc++p3BYw8VOLT3Oimh9NZFX4pdlNQo8WrnH86IWTM08jTjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=o4yRC+xx; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 503F0Vf8010911
	for <io-uring@vger.kernel.org>; Fri, 3 Jan 2025 07:02:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=b
	vHyemw4w4xwJUZezKNO3+boUFWVHef3Jyozxyi8FFc=; b=o4yRC+xx1SM455Uz+
	HplsPnHr0F3DzGikPWVwx/vhi+7AU4hnAe3rZoLAYvk0utgM5TIDYx2InO0PILle
	W2iGQOfzqoOLi4A5/iPHC+s7qqVAjyg9JvYa8pGRjoo8oD5WTTom2YZyKI22TfC4
	Oh7IvXQgIWW4/1k3Fg2Qnp6Wv8=
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 43xgsmrf39-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 03 Jan 2025 07:02:47 -0800 (PST)
Received: from twshared9216.15.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Fri, 3 Jan 2025 15:02:45 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id B39AAA24068D; Fri,  3 Jan 2025 15:02:34 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] btrfs: don't read from userspace twice in btrfs_uring_encoded_read()
Date: Fri, 3 Jan 2025 15:02:26 +0000
Message-ID: <20250103150233.2340306-5-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250103150233.2340306-1-maharmstone@fb.com>
References: <20250103150233.2340306-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _8FvNP1Cz6390pc0CPa-qijYR4e0HV35
X-Proofpoint-GUID: _8FvNP1Cz6390pc0CPa-qijYR4e0HV35
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

If we return -EAGAIN the first time because we need to block,
btrfs_uring_encoded_read() will get called twice. Take a copy of args,
the iovs, and the iter the first time, as by the time we are called the
second time these may have gone out of scope.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Reported-by: Jens Axboe <axboe@kernel.dk>
Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCO=
DED_READ ioctl)")
---
 fs/btrfs/ioctl.c | 125 ++++++++++++++++++++++++++---------------------
 1 file changed, 68 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7872de140489..eb7b330d7aab 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4787,25 +4787,29 @@ static int btrfs_uring_read_extent(struct kiocb *=
iocb, struct iov_iter *iter,
 	return ret;
 }
=20
+struct btrfs_uring_encoded_data {
+	struct btrfs_ioctl_encoded_io_args args;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov;
+	struct iov_iter iter;
+};
+
 static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned i=
nt issue_flags)
 {
 	size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded_io_ar=
gs, flags);
 	size_t copy_end;
-	struct btrfs_ioctl_encoded_io_args args =3D { 0 };
 	int ret;
 	u64 disk_bytenr, disk_io_size;
 	struct file *file;
 	struct btrfs_inode *inode;
 	struct btrfs_fs_info *fs_info;
 	struct extent_io_tree *io_tree;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov =3D iovstack;
-	struct iov_iter iter;
 	loff_t pos;
 	struct kiocb kiocb;
 	struct extent_state *cached_state =3D NULL;
 	u64 start, lockend;
 	void __user *sqe_addr;
+	struct btrfs_uring_encoded_data *data =3D io_uring_cmd_get_async_data(c=
md)->op_data;
=20
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret =3D -EPERM;
@@ -4819,43 +4823,64 @@ static int btrfs_uring_encoded_read(struct io_uri=
ng_cmd *cmd, unsigned int issue
=20
 	if (issue_flags & IO_URING_F_COMPAT) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
-		struct btrfs_ioctl_encoded_io_args_32 args32;
-
 		copy_end =3D offsetofend(struct btrfs_ioctl_encoded_io_args_32, flags)=
;
-		if (copy_from_user(&args32, sqe_addr, copy_end)) {
-			ret =3D -EFAULT;
-			goto out_acct;
-		}
-		args.iov =3D compat_ptr(args32.iov);
-		args.iovcnt =3D args32.iovcnt;
-		args.offset =3D args32.offset;
-		args.flags =3D args32.flags;
 #else
 		return -ENOTTY;
 #endif
 	} else {
 		copy_end =3D copy_end_kernel;
-		if (copy_from_user(&args, sqe_addr, copy_end)) {
-			ret =3D -EFAULT;
+	}
+
+	if (!data) {
+		data =3D kzalloc(sizeof(*data), GFP_NOFS);
+		if (!data) {
+			ret =3D -ENOMEM;
 			goto out_acct;
 		}
-	}
=20
-	if (args.flags !=3D 0)
-		return -EINVAL;
+		io_uring_cmd_get_async_data(cmd)->op_data =3D data;
=20
-	ret =3D import_iovec(ITER_DEST, args.iov, args.iovcnt, ARRAY_SIZE(iovst=
ack),
-			   &iov, &iter);
-	if (ret < 0)
-		goto out_acct;
+		if (issue_flags & IO_URING_F_COMPAT) {
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+			struct btrfs_ioctl_encoded_io_args_32 args32;
=20
-	if (iov_iter_count(&iter) =3D=3D 0) {
-		ret =3D 0;
-		goto out_free;
+			if (copy_from_user(&args32, sqe_addr, copy_end)) {
+				ret =3D -EFAULT;
+				goto out_acct;
+			}
+
+			data->args.iov =3D compat_ptr(args32.iov);
+			data->args.iovcnt =3D args32.iovcnt;
+			data->args.offset =3D args32.offset;
+			data->args.flags =3D args32.flags;
+#endif
+		} else {
+			if (copy_from_user(&data->args, sqe_addr, copy_end)) {
+				ret =3D -EFAULT;
+				goto out_acct;
+			}
+		}
+
+		if (data->args.flags !=3D 0) {
+			ret =3D -EINVAL;
+			goto out_acct;
+		}
+
+		data->iov =3D data->iovstack;
+		ret =3D import_iovec(ITER_DEST, data->args.iov, data->args.iovcnt,
+				   ARRAY_SIZE(data->iovstack), &data->iov,
+				   &data->iter);
+		if (ret < 0)
+			goto out_acct;
+
+		if (iov_iter_count(&data->iter) =3D=3D 0) {
+			ret =3D 0;
+			goto out_free;
+		}
 	}
=20
-	pos =3D args.offset;
-	ret =3D rw_verify_area(READ, file, &pos, args.len);
+	pos =3D data->args.offset;
+	ret =3D rw_verify_area(READ, file, &pos, data->args.len);
 	if (ret < 0)
 		goto out_free;
=20
@@ -4868,15 +4893,16 @@ static int btrfs_uring_encoded_read(struct io_uri=
ng_cmd *cmd, unsigned int issue
 	start =3D ALIGN_DOWN(pos, fs_info->sectorsize);
 	lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
=20
-	ret =3D btrfs_encoded_read(&kiocb, &iter, &args, &cached_state,
-				 &disk_bytenr, &disk_io_size);
+	ret =3D btrfs_encoded_read(&kiocb, &data->iter, &data->args,
+				 &cached_state, &disk_bytenr, &disk_io_size);
 	if (ret < 0 && ret !=3D -EIOCBQUEUED)
 		goto out_free;
=20
 	file_accessed(file);
=20
-	if (copy_to_user(sqe_addr + copy_end, (const char *)&args + copy_end_ke=
rnel,
-			 sizeof(args) - copy_end_kernel)) {
+	if (copy_to_user(sqe_addr + copy_end,
+			 (const char *)&data->args + copy_end_kernel,
+			 sizeof(data->args) - copy_end_kernel)) {
 		if (ret =3D=3D -EIOCBQUEUED) {
 			unlock_extent(io_tree, start, lockend, &cached_state);
 			btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
@@ -4886,39 +4912,24 @@ static int btrfs_uring_encoded_read(struct io_uri=
ng_cmd *cmd, unsigned int issue
 	}
=20
 	if (ret =3D=3D -EIOCBQUEUED) {
-		u64 count;
-
-		/*
-		 * If we've optimized things by storing the iovecs on the stack,
-		 * undo this.
-		 */
-		if (!iov) {
-			iov =3D kmemdup(iovstack, sizeof(struct iovec) * args.iovcnt,
-				      GFP_NOFS);
-			if (!iov) {
-				unlock_extent(io_tree, start, lockend, &cached_state);
-				btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
-				ret =3D -ENOMEM;
-				goto out_acct;
-			}
-		}
-
-		count =3D min_t(u64, iov_iter_count(&iter), disk_io_size);
+		u64 count =3D min_t(u64, iov_iter_count(&data->iter),
+				  disk_io_size);
=20
 		/* Match ioctl by not returning past EOF if uncompressed. */
-		if (!args.compression)
-			count =3D min_t(u64, count, args.len);
+		if (!data->args.compression)
+			count =3D min_t(u64, count, data->args.len);
=20
-		ret =3D btrfs_uring_read_extent(&kiocb, &iter, start, lockend,
-					      cached_state, disk_bytenr,
-					      disk_io_size, count,
-					      args.compression, iov, cmd);
+		ret =3D btrfs_uring_read_extent(&kiocb, &data->iter, start,
+					      lockend, cached_state,
+					      disk_bytenr, disk_io_size, count,
+					      data->args.compression,
+					      data->iov, cmd);
=20
 		goto out_acct;
 	}
=20
 out_free:
-	kfree(iov);
+	kfree(data->iov);
=20
 out_acct:
 	if (ret > 0)
--=20
2.45.2


