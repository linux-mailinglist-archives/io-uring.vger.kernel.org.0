Return-Path: <io-uring+bounces-5523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2059F559A
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 19:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15E6D188618F
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 18:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551BF1F866E;
	Tue, 17 Dec 2024 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="Fp0/9Kn5"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E7050276
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 18:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458538; cv=none; b=Bh9mpVuhQGeiayPs8ls+sCvyfq6CcfBO2pTffomwHNcjh7uxg4Lj8MGA39zfz/VTZb5tUZoBp3BOAZ7nAeEqYmruLLtMkZi/Ix8xTMWKZ5Oy7ikQSyGgVfAlKxIo7Q6jV6juxgNR8fgDvulMYEDTwaDO/5508y4W+R02+kZOAx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458538; c=relaxed/simple;
	bh=5yqhbwARB2dfOC2OxL9NeLiIhrPSsYRRj4S+/+XGylE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b03Rh2ZaeC4D2Qz/HhrmnD9yo2haannSXWMzMxhAzpF/w4J/UhRQUWM8TjJMcQybOHTWVx9n5xq5H2gtMwzq+cEvaEyblrJ+E4bsmts+nmI9sgQgrjJtuzOFxUMGNlZumi/klvhoe3t8XvgpLwKd5VPkOmlFZVPsn1czizMiI48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=Fp0/9Kn5; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHI1CDo010924
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 10:02:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=1
	YMYRxo9wVOGVZereeoruzokqxg0JBG4GmlvMe9HwW8=; b=Fp0/9Kn5oqdNSRw2o
	Yj8r0oExDPuDGv+inWcoij4RzJHebRyhZnl+ycQHBqqX2ZufJrNLCbYdFNpM/SxR
	v0BWzy28FUyg1spLNW6z1U6DCwatUVt7POGnVm9PNpF5aRhAg67USJceyfmV1rli
	K90KNn8REQSxVmocQC2QbN4yRk=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43ke7480dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 10:02:15 -0800 (PST)
Received: from twshared18153.09.ash9.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 17 Dec 2024 18:02:14 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 5B5A89A41152; Tue, 17 Dec 2024 18:02:12 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 4/4] btrfs: don't read from userspace twice in btrfs_uring_encoded_read()
Date: Tue, 17 Dec 2024 18:02:02 +0000
Message-ID: <20241217180210.4044318-4-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241217180210.4044318-1-maharmstone@fb.com>
References: <20241217180210.4044318-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 2uITFNg9wkJvCq2WGwMev5vYqgHTkJGn
X-Proofpoint-ORIG-GUID: 2uITFNg9wkJvCq2WGwMev5vYqgHTkJGn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

If we return -EAGAIN the first time because we need to block,
btrfs_uring_encoded_read() will get called twice. Take a copy of args
the first time, to prevent userspace from messing around with it.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Reported-by: Jens Axboe <axboe@kernel.dk>
Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCO=
DED_READ ioctl)")
---
 fs/btrfs/ioctl.c | 74 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7872de140489..da91cdb88324 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4791,7 +4791,7 @@ static int btrfs_uring_encoded_read(struct io_uring=
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
@@ -4806,6 +4806,7 @@ static int btrfs_uring_encoded_read(struct io_uring=
_cmd *cmd, unsigned int issue
 	struct extent_state *cached_state =3D NULL;
 	u64 start, lockend;
 	void __user *sqe_addr;
+	struct io_uring_cmd_data *data =3D io_uring_cmd_get_async_data(cmd);
=20
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret =3D -EPERM;
@@ -4819,32 +4820,53 @@ static int btrfs_uring_encoded_read(struct io_uri=
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
+	args =3D data->op_data;
+
+	if (!args) {
+		args =3D kzalloc(sizeof(*args), GFP_NOFS);
+		if (!args) {
+			ret =3D -ENOMEM;
 			goto out_acct;
 		}
-	}
=20
-	if (args.flags !=3D 0)
-		return -EINVAL;
+		data->op_data =3D args;
=20
-	ret =3D import_iovec(ITER_DEST, args.iov, args.iovcnt, ARRAY_SIZE(iovst=
ack),
+		if (issue_flags & IO_URING_F_COMPAT) {
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
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
+#endif
+		} else {
+			if (copy_from_user(args, sqe_addr, copy_end)) {
+				ret =3D -EFAULT;
+				goto out_acct;
+			}
+		}
+
+		if (args->flags !=3D 0) {
+			ret =3D -EINVAL;
+			goto out_acct;
+		}
+	}
+
+	ret =3D import_iovec(ITER_DEST, args->iov, args->iovcnt, ARRAY_SIZE(iov=
stack),
 			   &iov, &iter);
 	if (ret < 0)
 		goto out_acct;
@@ -4854,8 +4876,8 @@ static int btrfs_uring_encoded_read(struct io_uring=
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
@@ -4868,15 +4890,15 @@ static int btrfs_uring_encoded_read(struct io_uri=
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
@@ -4893,7 +4915,7 @@ static int btrfs_uring_encoded_read(struct io_uring=
_cmd *cmd, unsigned int issue
 		 * undo this.
 		 */
 		if (!iov) {
-			iov =3D kmemdup(iovstack, sizeof(struct iovec) * args.iovcnt,
+			iov =3D kmemdup(iovstack, sizeof(struct iovec) * args->iovcnt,
 				      GFP_NOFS);
 			if (!iov) {
 				unlock_extent(io_tree, start, lockend, &cached_state);
@@ -4906,13 +4928,13 @@ static int btrfs_uring_encoded_read(struct io_uri=
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


