Return-Path: <io-uring+bounces-4812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D44A9D215C
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 09:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB6721F22848
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 08:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F01C15530B;
	Tue, 19 Nov 2024 08:13:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B051531DB
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 08:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732003983; cv=none; b=uKpq3euMSeRtW7oBZFmpRKQZ9n7TRF3oUkt+eXS5cjCz/Ct7fIU0QU/BYfdvP05veE3T6R27AOwwU8O5Il8H0s8s0b41DD21eqXAsqAUodHsdPbNQ5yqHyc++GEJq4AUBOXQdjiKpEDhzX80WU6SPDHlbIgg/4QAyw8S2vtKax4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732003983; c=relaxed/simple;
	bh=0aVAyt2qiEol8CHPUUrHtI8kvCy6TQKS0MMJYVoNQ9k=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IGzWyb+thRM2a7GQXiwxUZI8ybxGfnswt0JLApgiwOe4GRZZ8AWa/O0QAcOCICSVgL8bQWQOjnD+TdUPiF/yjC3mHJAaGRC6wSHfBq4EBVl+xw3rPu2YFMn9KaoSvg8FOE4q7Uim/wPfnMUGTgRo84m6HWwrCYTkZisnpqs3pfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XsxzD3HHqzQppq;
	Tue, 19 Nov 2024 16:11:36 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (unknown [7.221.188.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 9730C1800F2;
	Tue, 19 Nov 2024 16:12:57 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100011.china.huawei.com (7.221.188.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 19 Nov 2024 16:12:57 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Tue, 19 Nov 2024 16:12:57 +0800
From: lizetao <lizetao1@huawei.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "asml.silence@gmail.com"
	<asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: [PATCH -next] io_uring: add support for fchmod
Thread-Topic: [PATCH -next] io_uring: add support for fchmod
Thread-Index: Ads6Wn5Us6O6He9UT4KWT2JV2JtSNw==
Date: Tue, 19 Nov 2024 08:12:57 +0000
Message-ID: <e291085644e14b3eb4d1c3995098bf4e@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Adds support for doing chmod through io_uring. IORING_OP_FCHMOD behaves lik=
e fchmod(2) and takes the same arguments.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/fs.c                 | 32 ++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  3 +++
 io_uring/opdef.c              |  8 ++++++++
 4 files changed, 44 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h =
index 5d08435b95a8..de5cce11f937 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -262,6 +262,7 @@ enum io_uring_op {
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
+	IORING_OP_FCHMOD,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/fs.c b/io_uring/fs.c index eccea851dd5a..835f66fb75ff=
 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -47,6 +47,11 @@ struct io_link {
 	int				flags;
 };
=20
+struct io_fchmod {
+	struct file			*file;
+	umode_t				mode;
+};
+
 int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)=
  {
 	struct io_rename *ren =3D io_kiocb_to_cmd(req, struct io_rename); @@ -291=
,3 +296,30 @@ void io_link_cleanup(struct io_kiocb *req)
 	putname(sl->oldpath);
 	putname(sl->newpath);
 }
+
+int io_fchmod_prep(struct io_kiocb *req, const struct io_uring_sqe=20
+*sqe) {
+	struct io_fchmod *fc =3D io_kiocb_to_cmd(req, struct io_fchmod);
+
+	if (unlikely(sqe->off || sqe->addr || sqe->rw_flags ||
+		     sqe->buf_index || sqe->splice_fd_in))
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	fc->mode =3D READ_ONCE(sqe->len);
+	req->flags |=3D REQ_F_FORCE_ASYNC;
+	return 0;
+}
+
+int io_fchmod(struct io_kiocb *req, unsigned int issue_flags) {
+	struct io_fchmod *fc =3D io_kiocb_to_cmd(req, struct io_fchmod);
+	int ret;
+
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+
+	ret =3D vfs_fchmod(req->file, fc->mode);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/fs.h b/io_uring/fs.h index 0bb5efe3d6bb..bc7d95e77b2f=
 100644
--- a/io_uring/fs.h
+++ b/io_uring/fs.h
@@ -18,3 +18,6 @@ int io_symlinkat(struct io_kiocb *req, unsigned int issue=
_flags);  int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sq=
e *sqe);  int io_linkat(struct io_kiocb *req, unsigned int issue_flags);  v=
oid io_link_cleanup(struct io_kiocb *req);
+
+int io_fchmod_prep(struct io_kiocb *req, const struct io_uring_sqe=20
+*sqe); int io_fchmod(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c index 3de75eca1c92..eb5bf8=
31513c 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -515,6 +515,11 @@ const struct io_issue_def io_issue_defs[] =3D {
 		.prep			=3D io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_FCHMOD] =3D {
+		.needs_file		=3D 1,
+		.prep			=3D io_fchmod_prep,
+		.issue			=3D io_fchmod,
+	},
 };
=20
 const struct io_cold_def io_cold_defs[] =3D { @@ -744,6 +749,9 @@ const st=
ruct io_cold_def io_cold_defs[] =3D {
 	[IORING_OP_LISTEN] =3D {
 		.name			=3D "LISTEN",
 	},
+	[IORING_OP_FCHMOD] =3D {
+		.name			=3D "FCHMOD",
+	},
 };
=20
 const char *io_uring_get_opcode(u8 opcode)
--
2.34.1


