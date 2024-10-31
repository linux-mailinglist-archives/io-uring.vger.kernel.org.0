Return-Path: <io-uring+bounces-4282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D52D79B802D
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 17:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C4531F212D0
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C5019F47A;
	Thu, 31 Oct 2024 16:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="YmCFQf0f"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EFB1386C9
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 16:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730392392; cv=none; b=HPU26TM2cX3yh9iOZUTK0pA1fCv8CBrbECOXYKJVwN2nadI0EdjY7syjmJGeD7EwdY4Hhz1BNJMPy+5df6ZQHwO06y3ZpNOW3jTmvvp8tB9H9wx8tYYsefVeZGvM4cY/QYuAbOMU3N+FI2kROoWHOCzb3RbJraKjKY9pLChvjpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730392392; c=relaxed/simple;
	bh=xikFq93FY6IkyG4gy9dDcY6kw+kFCBf3DpB6Nc9EhWc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lSMKmYeMvQ6bxj0XdfzjpNdMLHUeabKgq3wEMUPxeEYFOJLsD6NSZhssCj69RSI1mOdgkPX5akBcOhtu/WuTCau5AOweEO9uFSqAtwwcNOtcwYVzwAOBoPevQC/YWxDqXZPO8wkPwRv7r/UKQCjhGQNkjxARJ/E5tnamUZgUrII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=YmCFQf0f; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49VDVpaK003194
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 09:33:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=/u9KkKOhXWizie9P+ax9UK6
	debEdPhtL/cUJoUMTd6M=; b=YmCFQf0fBMlUEy0e7nSAYSUvcvTo8VSTBo6qjMQ
	Bh2kZ+GD7c0EF0yfjJQaVxTb472voCyiFL3O09Es81W+pJpobr02AX6ubbl25D9/
	X1srCNFghg/twM1NTrN1OYmFmobn1NTMjGeGAey1DwS9CZRQbF1Si/XxeOw95qWt
	1zh0=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42m6bdu3yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 09:33:08 -0700 (PDT)
Received: from twshared15700.17.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Thu, 31 Oct 2024 16:33:07 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 2A4578404305; Thu, 31 Oct 2024 16:33:04 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <io-uring@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/2] io_uring/cmd: let cmds to know about dying task
Date: Thu, 31 Oct 2024 16:32:51 +0000
Message-ID: <20241031163257.3616106-1-maharmstone@fb.com>
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
X-Proofpoint-GUID: YdToMa5FXCiUO123gkbg2Rx8dIEB0b8q
X-Proofpoint-ORIG-GUID: YdToMa5FXCiUO123gkbg2Rx8dIEB0b8q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Pavel Begunkov <asml.silence@gmail.com>

When the taks that submitted a request is dying, a task work for that
request might get run by a kernel thread or even worse by a half
dismantled task. We can't just cancel the task work without running the
callback as the cmd might need to do some clean up, so pass a flag
instead. If set, it's not safe to access any task resources and the
callback is expected to cancel the cmd ASAP.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/uring_cmd.c           | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 4b9ba523978d..2ee5dc105b58 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		=3D (1 << 11),
 	IO_URING_F_COMPAT		=3D (1 << 12),
+	IO_URING_F_TASK_DEAD		=3D (1 << 13),
 };
=20
 struct io_wq_work_node {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 39c3c816ec78..78a8ba5d39ae 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *=
ts)
 {
 	struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_uring_cm=
d);
+	unsigned int flags =3D IO_URING_F_COMPLETE_DEFER;
+
+	if (req->task !=3D current)
+		flags |=3D IO_URING_F_TASK_DEAD;
=20
 	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
+	ioucmd->task_work_cb(ioucmd, flags);
 }
=20
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
--=20
2.45.2


