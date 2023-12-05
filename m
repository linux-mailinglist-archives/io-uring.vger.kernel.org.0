Return-Path: <io-uring+bounces-241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D625806117
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 22:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8453B281DF3
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 21:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4A26FCD6;
	Tue,  5 Dec 2023 21:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="SCzR8FCn"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F251A5
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 13:56:28 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 3B5Lpgfq027082
	for <io-uring@vger.kernel.org>; Tue, 5 Dec 2023 13:56:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=0qcQiLXPVNu2TXjf/+LpsR/YK5GFcl+ICamtuPaACPs=;
 b=SCzR8FCnuaSq/PR7ngFAsbwDj0J/dKvyZpr+uB/WEFp/staPAmfGFqGdYbVaAGlwYqbA
 4Mm64Dot7TLFFc6EtSqDoLTN6ncruI2+mHv9jyRnA7jm3alENkvyUKYw+97s0lfJ6+D7
 V8ymebHVdbxVuIRZOdTbRZtf4vCe+7XLI3cxYHywq4yzljI9YDeHExdf6qOWroPJKX/E
 ezgwJxWhy0CnrRlf83n/LlFru31/5oS3Hur/GalI0A4siIwlRcppR1EvA+/t63SwB7h2
 P4BkB8ujvSuSMOMV8aj1hxz39CTt/ON9L/W6zqP9J2m4T/C4QKyfYAh1e0D84kGhsTdT kQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
	by m0089730.ppops.net (PPS) with ESMTPS id 3utapg0wy0-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 13:56:27 -0800
Received: from twshared6040.02.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 5 Dec 2023 13:56:20 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 2A39F22AAC695; Tue,  5 Dec 2023 13:56:02 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>
CC: <asml.silence@gmail.com>, Keith Busch <kbusch@kernel.org>,
        Jens Axboe
	<axboe@kernel.dk>
Subject: [PATCH] io_uring: save repeated issue_flags
Date: Tue, 5 Dec 2023 13:55:53 -0800
Message-ID: <20231205215553.2954630-1-kbusch@meta.com>
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
X-Proofpoint-GUID: ExSzDlmfofJOMXAY5y65XRQ2LT32uxTF
X-Proofpoint-ORIG-GUID: ExSzDlmfofJOMXAY5y65XRQ2LT32uxTF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-05_18,2023-12-05_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

No need to rebuild the issue_flags on every IO: they're always the same.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 15 ++++++++++++---
 io_uring/uring_cmd.c           |  8 +-------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index bebab36abce89..dd192d828f463 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -228,6 +228,7 @@ struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
 		unsigned int		flags;
+		unsigned int		issue_flags;
 		unsigned int		drain_next: 1;
 		unsigned int		restricted: 1;
 		unsigned int		off_timeout_used: 1;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1d254f2c997de..a338e3660ecb8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3975,11 +3975,20 @@ static __cold int io_uring_create(unsigned entrie=
s, struct io_uring_params *p,
 	 * polling again, they can rely on io_sq_thread to do polling
 	 * work, which can reduce cpu usage and uring_lock contention.
 	 */
-	if (ctx->flags & IORING_SETUP_IOPOLL &&
-	    !(ctx->flags & IORING_SETUP_SQPOLL))
-		ctx->syscall_iopoll =3D 1;
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		ctx->issue_flags |=3D IO_URING_F_SQE128;
+		if (!(ctx->flags & IORING_SETUP_SQPOLL))
+			ctx->syscall_iopoll =3D 1;
+	}
=20
 	ctx->compat =3D in_compat_syscall();
+	if (ctx->compat)
+		ctx->issue_flags |=3D IO_URING_F_COMPAT;
+	if (ctx->flags & IORING_SETUP_SQE128)
+		ctx->issue_flags |=3D IO_URING_F_SQE128;
+	if (ctx->flags & IORING_SETUP_CQE32)
+		ctx->issue_flags |=3D IO_URING_F_CQE32;
+
 	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
 		ctx->user =3D get_uid(current_user());
=20
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8a38b9f75d841..dbc0bfbfd0f05 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -158,19 +158,13 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int=
 issue_flags)
 	if (ret)
 		return ret;
=20
-	if (ctx->flags & IORING_SETUP_SQE128)
-		issue_flags |=3D IO_URING_F_SQE128;
-	if (ctx->flags & IORING_SETUP_CQE32)
-		issue_flags |=3D IO_URING_F_CQE32;
-	if (ctx->compat)
-		issue_flags |=3D IO_URING_F_COMPAT;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!file->f_op->uring_cmd_iopoll)
 			return -EOPNOTSUPP;
-		issue_flags |=3D IO_URING_F_IOPOLL;
 		req->iopoll_completed =3D 0;
 	}
=20
+	issue_flags |=3D ctx->issue_flags;
 	ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
 	if (ret =3D=3D -EAGAIN) {
 		if (!req_has_async_data(req)) {
--=20
2.34.1


