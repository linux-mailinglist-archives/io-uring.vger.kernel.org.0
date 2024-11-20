Return-Path: <io-uring+bounces-4876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0278C9D3F9B
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 17:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7BCF283DF2
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9A915534B;
	Wed, 20 Nov 2024 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="g2DR4Wid"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A481537C3
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 16:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118572; cv=none; b=THAE53yw0t9yjOEiRuRklFubtt4koMhucbSlvePaZHvqsyodFmfnBFXi1427ZGlduWr+2S0gtwZeBtZXZtb672C+oR4X/sRSKgJj5CcdNoYtrwC5IwIcn7ZW54CFGIiXHKzrarD1qH2cU1wvGZUUGqJgBSylD4en+aC+mOKAWFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118572; c=relaxed/simple;
	bh=SArvkKX+eUh1k2w3UgZUnVcZu9g794+5MmvLb4vFg8w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lmZ5wdxtmI7Z0HQLUYiQHufY+gmGxwCOZ26Gg4MV6oMKQ9Se/R+vnsQTQWkOMBtK2I+RKk82YOe3/1rsj3O/sVSoLibppqHCgAz87ls8rTH++6NOAc37mahbwUOSTPZJmvGLlOECsbHwUuLfj8PX0NYShJ9G9oYYOtj9kJO4jRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=g2DR4Wid; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AKEoVAf025849
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:02:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=R
	bvMsElVpqyZcqbGCI1OvWgHU3KT2k3j7E+hA4yfClM=; b=g2DR4WidoWu1QSb2v
	Ilqm0injSjbYEvj3MTYuIP2MQv9AfvV3WYTHwnAoNjRTAeC+1iig4F77OucOubgb
	416VJMG1OxedJVwE8swrA0ZNJ3jTobHaf+39zazX9kYEX50+uP/aHKBNn/AzMa77
	KyeaH2Et3vdMAHbRi5CQA9U7oE=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 431dmc9xem-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:02:49 -0800 (PST)
Received: from twshared22725.15.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 20 Nov 2024 16:02:44 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id D084C8D1CF0B; Wed, 20 Nov 2024 16:02:35 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 4/4] btrfs: don't read from userspace twice in btrfs_uring_encoded_read()
Date: Wed, 20 Nov 2024 16:02:22 +0000
Message-ID: <20241120160231.1106844-4-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241120160231.1106844-1-maharmstone@fb.com>
References: <20241120160231.1106844-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ke4Ljv_KQ1eK-RgnxUsmsM6wablOVzN4
X-Proofpoint-GUID: ke4Ljv_KQ1eK-RgnxUsmsM6wablOVzN4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

If we return -EAGAIN the first time because we need to block,
btrfs_uring_encoded_read() will get called twice. Take a copy of args
the first time, to prevent userspace from messing around with it.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/ioctl.c | 74 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 488dcd022dea..97f7812cbf7c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4873,7 +4873,7 @@ static int btrfs_uring_encoded_read(struct io_uring=
_cmd *cmd, unsigned int issue
 {
 	size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded_io_ar=
gs, flags);
 	size_t copy_end;
-	struct btrfs_ioctl_encoded_io_args args =3D { 0 };
+	struct btrfs_ioctl_encoded_io_args *args;
 	int ret;
 	u64 disk_bytenr, disk_io_size;
 	struct file *file;
@@ -4888,6 +4888,9 @@ static int btrfs_uring_encoded_read(struct io_uring=
_cmd *cmd, unsigned int issue
 	struct extent_state *cached_state =3D NULL;
 	u64 start, lockend;
 	void __user *sqe_addr;
+	struct io_kiocb *req =3D cmd_to_io_kiocb(cmd);
+	struct io_uring_cmd_data *data =3D req->async_data;
+	bool need_copy =3D false;
=20
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret =3D -EPERM;
@@ -4899,34 +4902,55 @@ static int btrfs_uring_encoded_read(struct io_uri=
ng_cmd *cmd, unsigned int issue
 	io_tree =3D &inode->io_tree;
 	sqe_addr =3D u64_to_user_ptr(READ_ONCE(cmd->sqe->addr));
=20
+	if (!data->op_data) {
+		data->op_data =3D kzalloc(sizeof(*args), GFP_NOFS);
+		if (!data->op_data) {
+			ret =3D -ENOMEM;
+			goto out_acct;
+		}
+
+		need_copy =3D true;
+	}
+
+	args =3D data->op_data;
+
 	if (issue_flags & IO_URING_F_COMPAT) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
-		struct btrfs_ioctl_encoded_io_args_32 args32;
-
 		copy_end =3D offsetofend(struct btrfs_ioctl_encoded_io_args_32, flags)=
;
-		if (copy_from_user(&args32, sqe_addr, copy_end)) {
-			ret =3D -EFAULT;
-			goto out_acct;
+
+		if (need_copy) {
+			struct btrfs_ioctl_encoded_io_args_32 args32;
+
+			if (copy_from_user(&args32, sqe_addr, copy_end)) {
+				ret =3D -EFAULT;
+				goto out_acct;
+			}
+
+			args->iov =3D compat_ptr(args32.iov);
+			args->iovcnt =3D args32.iovcnt;
+			args->offset =3D args32.offset;
+			args->flags =3D args32.flags;
 		}
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
-			goto out_acct;
+
+		if (need_copy) {
+			if (copy_from_user(args, sqe_addr, copy_end)) {
+				ret =3D -EFAULT;
+				goto out_acct;
+			}
 		}
 	}
=20
-	if (args.flags !=3D 0)
-		return -EINVAL;
+	if (args->flags !=3D 0) {
+		ret =3D -EINVAL;
+		goto out_acct;
+	}
=20
-	ret =3D import_iovec(ITER_DEST, args.iov, args.iovcnt, ARRAY_SIZE(iovst=
ack),
+	ret =3D import_iovec(ITER_DEST, args->iov, args->iovcnt, ARRAY_SIZE(iov=
stack),
 			   &iov, &iter);
 	if (ret < 0)
 		goto out_acct;
@@ -4936,8 +4960,8 @@ static int btrfs_uring_encoded_read(struct io_uring=
_cmd *cmd, unsigned int issue
 		goto out_free;
 	}
=20
-	pos =3D args.offset;
-	ret =3D rw_verify_area(READ, file, &pos, args.len);
+	pos =3D args->offset;
+	ret =3D rw_verify_area(READ, file, &pos, args->len);
 	if (ret < 0)
 		goto out_free;
=20
@@ -4950,15 +4974,15 @@ static int btrfs_uring_encoded_read(struct io_uri=
ng_cmd *cmd, unsigned int issue
 	start =3D ALIGN_DOWN(pos, fs_info->sectorsize);
 	lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
=20
-	ret =3D btrfs_encoded_read(&kiocb, &iter, &args, &cached_state,
+	ret =3D btrfs_encoded_read(&kiocb, &iter, args, &cached_state,
 				 &disk_bytenr, &disk_io_size);
 	if (ret < 0 && ret !=3D -EIOCBQUEUED)
 		goto out_free;
=20
 	file_accessed(file);
=20
-	if (copy_to_user(sqe_addr + copy_end, (const char *)&args + copy_end_ke=
rnel,
-			 sizeof(args) - copy_end_kernel)) {
+	if (copy_to_user(sqe_addr + copy_end, (const char *)args + copy_end_ker=
nel,
+			 sizeof(*args) - copy_end_kernel)) {
 		if (ret =3D=3D -EIOCBQUEUED) {
 			unlock_extent(io_tree, start, lockend, &cached_state);
 			btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
@@ -4975,7 +4999,7 @@ static int btrfs_uring_encoded_read(struct io_uring=
_cmd *cmd, unsigned int issue
 		 * undo this.
 		 */
 		if (!iov) {
-			iov =3D kmemdup(iovstack, sizeof(struct iovec) * args.iovcnt,
+			iov =3D kmemdup(iovstack, sizeof(struct iovec) * args->iovcnt,
 				      GFP_NOFS);
 			if (!iov) {
 				unlock_extent(io_tree, start, lockend, &cached_state);
@@ -4988,13 +5012,13 @@ static int btrfs_uring_encoded_read(struct io_uri=
ng_cmd *cmd, unsigned int issue
 		count =3D min_t(u64, iov_iter_count(&iter), disk_io_size);
=20
 		/* Match ioctl by not returning past EOF if uncompressed. */
-		if (!args.compression)
-			count =3D min_t(u64, count, args.len);
+		if (!args->compression)
+			count =3D min_t(u64, count, args->len);
=20
 		ret =3D btrfs_uring_read_extent(&kiocb, &iter, start, lockend,
 					      cached_state, disk_bytenr,
 					      disk_io_size, count,
-					      args.compression, iov, cmd);
+					      args->compression, iov, cmd);
=20
 		goto out_acct;
 	}
--=20
2.45.2


