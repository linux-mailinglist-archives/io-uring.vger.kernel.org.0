Return-Path: <io-uring+bounces-4626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFC99C5D56
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 17:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFD0B281874
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 16:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A17D205E3F;
	Tue, 12 Nov 2024 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="fAx2Nj8j"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBE01FF606
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731429064; cv=none; b=rrtvnrqK//fASFgTZXyYG9cbE5e6aAaqDXPKJ91E4inxhnT9tx0ADNJd9NNmW5mD+kSqHSswsTZE3WdQV66jN614WdpO0yGfSuq949Hy4QaxGGzW4Xn6mwScXqNcr5vEkZLU7YkuTP3KStvLOhRRJLkI0wo66tEByqOvF+Gn3d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731429064; c=relaxed/simple;
	bh=VNWs4lJ7gieJ8qYMcGgkoiMsOw2wzlQrK2uG6cSAcNg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eqxBSCUyYmJDHiYAbq+sxeEuE90UxJq8eTmbLYZxpF8sdUsSmW9ccGYJL4vPdWLU1wdU0VdHlUN0n+F81iDLjhYCYi28hwshEWPDkb/0FZ2lvBULM6hs9XLxvYepLOEXsf7Os3qPCC4lakgSsC+MP/CKUgtmzntCyrP0TEGzSc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=fAx2Nj8j; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACEmL38022180
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 08:31:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=NSnTXW6rmt53Ko8ssjbFmfR
	0T1sJIyfSFre9XduMcJQ=; b=fAx2Nj8jUgisR19iUYyYpnWygJiLVrpVDV3MAZJ
	bFDVTVFBqwmaGIYUQDEK294RdSP3UdbDrbbjp7QPQu1Rwlag2QxFtl618gSaeR/y
	r3+XjNhg8Rp6AWnmN8VdUC6XJ56nsS5WuwWPd/3bv4zmcXI43hiou0zmqRUwStp2
	SCjY=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42v93p0w4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 08:30:59 -0800 (PST)
Received: from twshared18321.17.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 12 Nov 2024 16:30:59 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id B72418966EE1; Tue, 12 Nov 2024 16:30:51 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH] btrfs: add io_uring interface for encoded writes
Date: Tue, 12 Nov 2024 16:29:55 +0000
Message-ID: <20241112163021.1948119-1-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: QKb8GD4fuCJgbJwUHp_cwopiVSpvSceI
X-Proofpoint-ORIG-GUID: QKb8GD4fuCJgbJwUHp_cwopiVSpvSceI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Add an io_uring interface for encoded writes, with the same parameters
as the BTRFS_IOC_ENCODED_WRITE ioctl.

As with the encoded reads code, there's a test program for this at
https://github.com/maharmstone/io_uring-encoded, and I'll get this
worked into an fstest.

How io_uring works is that it initially calls btrfs_uring_cmd with the
IO_URING_F_NONBLOCK flag set, and if we return -EAGAIN it tries again in
a kthread with the flag cleared.

Ideally we'd honour this and call try_lock etc., but there's still a lot
of work to be done to create non-blocking versions of all the functions
in our write path. Instead, just validate the input in
btrfs_uring_encoded_write() on the first pass and return -EAGAIN, with a
view to properly optimizing the happy path later on.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/ioctl.c | 116 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6478216305c7..37578270686a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5030,6 +5030,116 @@ static int btrfs_uring_encoded_read(struct io_uri=
ng_cmd *cmd, unsigned int issue
 	return ret;
 }
=20
+static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned =
int issue_flags)
+{
+	struct btrfs_ioctl_encoded_io_args args;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov =3D iovstack;
+	struct iov_iter iter;
+	loff_t pos;
+	struct kiocb kiocb;
+	struct file *file;
+	ssize_t ret;
+	void __user *sqe_addr;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		ret =3D -EPERM;
+		goto out_acct;
+	}
+
+	file =3D cmd->file;
+	sqe_addr =3D u64_to_user_ptr(READ_ONCE(cmd->sqe->addr));
+
+	if (!(file->f_mode & FMODE_WRITE)) {
+		ret =3D -EBADF;
+		goto out_acct;
+	}
+
+	if (issue_flags & IO_URING_F_COMPAT) {
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+		struct btrfs_ioctl_encoded_io_args_32 args32;
+
+		if (copy_from_user(&args32, sqe_addr, sizeof(args32))) {
+			ret =3D -EFAULT;
+			goto out_acct;
+		}
+		args.iov =3D compat_ptr(args32.iov);
+		args.iovcnt =3D args32.iovcnt;
+		args.offset =3D args32.offset;
+		args.flags =3D args32.flags;
+		args.len =3D args32.len;
+		args.unencoded_len =3D args32.unencoded_len;
+		args.unencoded_offset =3D args32.unencoded_offset;
+		args.compression =3D args32.compression;
+		args.encryption =3D args32.encryption;
+		memcpy(args.reserved, args32.reserved, sizeof(args.reserved));
+#else
+		return -ENOTTY;
+#endif
+	} else {
+		if (copy_from_user(&args, sqe_addr, sizeof(args))) {
+			ret =3D -EFAULT;
+			goto out_acct;
+		}
+	}
+
+	ret =3D -EINVAL;
+	if (args.flags !=3D 0)
+		goto out_acct;
+	if (memchr_inv(args.reserved, 0, sizeof(args.reserved)))
+		goto out_acct;
+	if (args.compression =3D=3D BTRFS_ENCODED_IO_COMPRESSION_NONE &&
+	    args.encryption =3D=3D BTRFS_ENCODED_IO_ENCRYPTION_NONE)
+		goto out_acct;
+	if (args.compression >=3D BTRFS_ENCODED_IO_COMPRESSION_TYPES ||
+	    args.encryption >=3D BTRFS_ENCODED_IO_ENCRYPTION_TYPES)
+		goto out_acct;
+	if (args.unencoded_offset > args.unencoded_len)
+		goto out_acct;
+	if (args.len > args.unencoded_len - args.unencoded_offset)
+		goto out_acct;
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		ret =3D -EAGAIN;
+		goto out_acct;
+	}
+
+	ret =3D import_iovec(ITER_SOURCE, args.iov, args.iovcnt, ARRAY_SIZE(iov=
stack),
+			   &iov, &iter);
+	if (ret < 0)
+		goto out_acct;
+
+	if (iov_iter_count(&iter) =3D=3D 0) {
+		ret =3D 0;
+		goto out_iov;
+	}
+	pos =3D args.offset;
+	ret =3D rw_verify_area(WRITE, file, &pos, args.len);
+	if (ret < 0)
+		goto out_iov;
+
+	init_sync_kiocb(&kiocb, file);
+	ret =3D kiocb_set_rw_flags(&kiocb, 0, WRITE);
+	if (ret)
+		goto out_iov;
+	kiocb.ki_pos =3D pos;
+
+	file_start_write(file);
+
+	ret =3D btrfs_do_write_iter(&kiocb, &iter, &args);
+	if (ret > 0)
+		fsnotify_modify(file);
+
+	file_end_write(file);
+out_iov:
+	kfree(iov);
+out_acct:
+	if (ret > 0)
+		add_wchar(current, ret);
+	inc_syscw(current);
+	return ret;
+}
+
 int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	switch (cmd->cmd_op) {
@@ -5038,6 +5148,12 @@ int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsi=
gned int issue_flags)
 	case BTRFS_IOC_ENCODED_READ_32:
 #endif
 		return btrfs_uring_encoded_read(cmd, issue_flags);
+
+	case BTRFS_IOC_ENCODED_WRITE:
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+	case BTRFS_IOC_ENCODED_WRITE_32:
+#endif
+		return btrfs_uring_encoded_write(cmd, issue_flags);
 	}
=20
 	return -EINVAL;
--=20
2.45.2


