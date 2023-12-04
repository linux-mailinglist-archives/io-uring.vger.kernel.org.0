Return-Path: <io-uring+bounces-214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3954A803C19
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 18:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AA911C20A84
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 17:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35E52EAE4;
	Mon,  4 Dec 2023 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nScpq9EB"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71870109
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 09:54:04 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4BCvmK032746
	for <io-uring@vger.kernel.org>; Mon, 4 Dec 2023 09:54:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=1mhGxSkWo3Ada5UDMylojLGx/+rGIOTO13l7eqsWImI=;
 b=nScpq9EBz8gEHlr+rcjAeIg+TMBdCnXxw1HZly1NzWZJeajY2bT/KHavDByvoRdkF7+Z
 FxSNEAwW3+obO+pNwTpAOPBL0aVSbIp76zaE51BFaZRONeH6CMwZNpzhnxos5BWoAN/r
 D23SPgTEAuMR0MG2tPI8S8qjMw3VHYPIYf9JElsqQ9LtCvBzcxhn4/mILZ3qVhjs2v2r
 YK9CKjchqhvlJy0YkvQ9Fb77IxB0HUW7ag4XEgjviPX803pD0L7DqP/r+0lbuYRowAl4
 YRPPLhIkHstWK3g5du81sFFDxGSDYUGm4YhL3pOVlwTZY6QyMJGbA7l2GOeg7lWpStzZ AQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3urm879ek7-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 04 Dec 2023 09:54:03 -0800
Received: from twshared15991.38.frc1.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 09:53:59 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id BD31F229B6E99; Mon,  4 Dec 2023 09:53:43 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-nvme@lists.infradead.org>, <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>,
        <asml.silence@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 1/2] iouring: one capable call per iouring instance
Date: Mon, 4 Dec 2023 09:53:41 -0800
Message-ID: <20231204175342.3418422-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6ZuteBda8Yc7ZMI73PcFjkSUtuC4TsrM
X-Proofpoint-ORIG-GUID: 6ZuteBda8Yc7ZMI73PcFjkSUtuC4TsrM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_17,2023-12-04_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

The uring_cmd operation is often used for privileged actions, so drivers
subscribing to this interface check capable() for each command. The
capable() function is not fast path friendly for many kernel configs,
and this can really harm performance. Stash the capable sys admin
attribute in the io_uring context and set a new issue_flag for the
uring_cmd interface.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h | 4 ++++
 io_uring/io_uring.c            | 1 +
 io_uring/uring_cmd.c           | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index bebab36abce89..d64d6916753f0 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -36,6 +36,9 @@ enum io_uring_cmd_flags {
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		=3D (1 << 11),
 	IO_URING_F_COMPAT		=3D (1 << 12),
+
+	/* ring validated as CAP_SYS_ADMIN capable */
+	IO_URING_F_SYS_ADMIN		=3D (1 << 13),
 };
=20
 struct io_wq_work_node {
@@ -240,6 +243,7 @@ struct io_ring_ctx {
 		unsigned int		poll_activated: 1;
 		unsigned int		drain_disabled: 1;
 		unsigned int		compat: 1;
+		unsigned int		sys_admin: 1;
=20
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1d254f2c997de..4aa10b64f539e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3980,6 +3980,7 @@ static __cold int io_uring_create(unsigned entries,=
 struct io_uring_params *p,
 		ctx->syscall_iopoll =3D 1;
=20
 	ctx->compat =3D in_compat_syscall();
+	ctx->sys_admin =3D capable(CAP_SYS_ADMIN);
 	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
 		ctx->user =3D get_uid(current_user());
=20
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8a38b9f75d841..764f0e004aa00 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -164,6 +164,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
 		issue_flags |=3D IO_URING_F_CQE32;
 	if (ctx->compat)
 		issue_flags |=3D IO_URING_F_COMPAT;
+	if (ctx->sys_admin)
+		issue_flags |=3D IO_URING_F_SYS_ADMIN;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!file->f_op->uring_cmd_iopoll)
 			return -EOPNOTSUPP;
--=20
2.34.1


