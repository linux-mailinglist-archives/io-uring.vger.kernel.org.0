Return-Path: <io-uring+bounces-5809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04AA5A09865
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 18:24:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 453E516A1B5
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 17:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E9A2139DD;
	Fri, 10 Jan 2025 17:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="KqTFebvE"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840BD2139CB
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736529888; cv=none; b=NAEqJbQmul7f059OjaXSwuaHbLAfEi+Nk+uQiQ8eHiUPM3zCimw93zHxYmMRCVRwzxMBtJ484f4RfnJmHmrZZWKFDeuDBmLpSD5I8uq4eE2A1eZsFGV6qsk2E3lSlurnAGBzgrbCGD2or8nuNCq8siHYCT0JqrfALnMsQGskJm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736529888; c=relaxed/simple;
	bh=rm2GUyK7cZmml3nr2aID+eKZ9qn0cAw2D4cRtFjyZyM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ctn8A/HzTxAB+1qCSPrgN5yfPnk8s9/pAzGiQikJ9yhq+Uu8uvIeJcPl/bT63uFLtk4ZPvxZphssabBu4YCtlSHlKWe0qfqL4KSDuwbUL/qOhAbFVsp0bKZDuU6mAl12RjdOCShrz6ALdRiUK0sJeUODHpdOIHtpSH2WWdiqvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=KqTFebvE; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AFeJIA021600
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 09:24:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=DYjWamaSskYa44dSOgrWRgU
	dbBapwGJgFqLaPb/kYhQ=; b=KqTFebvEjrLicanoCIC1+TmmI6zcK6teC68YDSv
	FCFIAn3mLMVBO8z+2EU7zUe9lkYDOu3oDjCmKIfOrEjJHPFcC9r7r2rBw9ZjlilX
	Y1lKiYy4AnSkX/Hb8Wgwm+9zjinfGqEyir4YQFaoLFNDGPkNNtNfVc5gJEdUjTnI
	gN4E=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4436d6rqak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 09:24:45 -0800 (PST)
Received: from twshared3815.08.ash9.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Fri, 10 Jan 2025 17:24:44 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id A293CA5960CA; Fri, 10 Jan 2025 17:24:31 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH v2] btrfs: add io_uring interface for encoded writes
Date: Fri, 10 Jan 2025 17:23:52 +0000
Message-ID: <20250110172427.1834686-1-maharmstone@fb.com>
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
X-Proofpoint-GUID: iIIJGkfa5FCxMZnL_r7oCOD1QrEaQ3D7
X-Proofpoint-ORIG-GUID: iIIJGkfa5FCxMZnL_r7oCOD1QrEaQ3D7
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
Changelog:
* Version 2: switched to using io_uring_cmd_get_async_data, so that we
only copy from userspace once

 fs/btrfs/ioctl.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72c1d44c5c1d..5a0e9199851b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4941,6 +4941,128 @@ static int btrfs_uring_encoded_read(struct io_uri=
ng_cmd *cmd, unsigned int issue
 	return ret;
 }
=20
+static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned =
int issue_flags)
+{
+	loff_t pos;
+	struct kiocb kiocb;
+	struct file *file;
+	ssize_t ret;
+	void __user *sqe_addr;
+	struct btrfs_uring_encoded_data *data =3D io_uring_cmd_get_async_data(c=
md)->op_data;
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
+	if (!data) {
+		data =3D kzalloc(sizeof(*data), GFP_NOFS);
+		if (!data) {
+			ret =3D -ENOMEM;
+			goto out_acct;
+		}
+
+		io_uring_cmd_get_async_data(cmd)->op_data =3D data;
+
+		if (issue_flags & IO_URING_F_COMPAT) {
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+			struct btrfs_ioctl_encoded_io_args_32 args32;
+
+			if (copy_from_user(&args32, sqe_addr, sizeof(args32))) {
+				ret =3D -EFAULT;
+				goto out_acct;
+			}
+			data->args.iov =3D compat_ptr(args32.iov);
+			data->args.iovcnt =3D args32.iovcnt;
+			data->args.offset =3D args32.offset;
+			data->args.flags =3D args32.flags;
+			data->args.len =3D args32.len;
+			data->args.unencoded_len =3D args32.unencoded_len;
+			data->args.unencoded_offset =3D args32.unencoded_offset;
+			data->args.compression =3D args32.compression;
+			data->args.encryption =3D args32.encryption;
+			memcpy(data->args.reserved, args32.reserved,
+			       sizeof(data->args.reserved));
+#else
+			ret =3D -ENOTTY;
+			goto out_acct;
+#endif
+		} else {
+			if (copy_from_user(&data->args, sqe_addr, sizeof(data->args))) {
+				ret =3D -EFAULT;
+				goto out_acct;
+			}
+		}
+
+		ret =3D -EINVAL;
+		if (data->args.flags !=3D 0)
+			goto out_acct;
+		if (memchr_inv(data->args.reserved, 0, sizeof(data->args.reserved)))
+			goto out_acct;
+		if (data->args.compression =3D=3D BTRFS_ENCODED_IO_COMPRESSION_NONE &&
+		    data->args.encryption =3D=3D BTRFS_ENCODED_IO_ENCRYPTION_NONE)
+			goto out_acct;
+		if (data->args.compression >=3D BTRFS_ENCODED_IO_COMPRESSION_TYPES ||
+		    data->args.encryption >=3D BTRFS_ENCODED_IO_ENCRYPTION_TYPES)
+			goto out_acct;
+		if (data->args.unencoded_offset > data->args.unencoded_len)
+			goto out_acct;
+		if (data->args.len > data->args.unencoded_len - data->args.unencoded_o=
ffset)
+			goto out_acct;
+
+		data->iov =3D data->iovstack;
+		ret =3D import_iovec(ITER_SOURCE, data->args.iov, data->args.iovcnt,
+				   ARRAY_SIZE(data->iovstack), &data->iov,
+				   &data->iter);
+		if (ret < 0)
+			goto out_acct;
+
+		if (iov_iter_count(&data->iter) =3D=3D 0) {
+			ret =3D 0;
+			goto out_iov;
+		}
+	}
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		ret =3D -EAGAIN;
+		goto out_acct;
+	}
+
+	pos =3D data->args.offset;
+	ret =3D rw_verify_area(WRITE, file, &pos, data->args.len);
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
+	ret =3D btrfs_do_write_iter(&kiocb, &data->iter, &data->args);
+	if (ret > 0)
+		fsnotify_modify(file);
+
+	file_end_write(file);
+out_iov:
+	kfree(data->iov);
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
@@ -4949,6 +5071,12 @@ int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsi=
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


