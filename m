Return-Path: <io-uring+bounces-4278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CCF59B7F99
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 17:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23E92B2126A
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA29199FB8;
	Thu, 31 Oct 2024 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="cfgn1NQa"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2272136664
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730390667; cv=none; b=B8qcwd9nb47LTORh9T2zO/IdzixBB1d8QaZZ7GPOYvuQAayq2J1V/ZsYPmKGFyhgHI++lMbxPZ7Pu/dEhWeT+KzmHgZfpMAE11gQhscRm8wpj14LpRpV+cMfO299fwTXNhVRtlTD6PqJAzUVzaiH6wuolTqcd4nX7EVq6uAv2xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730390667; c=relaxed/simple;
	bh=XN+2Yk42uikd83U03e0sIPMDI+3XjH8QEDDQiDRBWQM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bae5wEIY20J2hUftGBsfzsrcu8UO/tQhDgILRqYmpFxUZ7SvFb3YdrtRExUBGXOdCpd9f8pUbb8kpKNJ12EDBieDvKI9bU/f6dxcNxXWrb2Cb4847UInwIy2P8OD8LmKh48PHnzOBNkE8iAF+bMqWYuPgE/1+/TIDRTSFW7rByE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=cfgn1NQa; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 49VDWrER032587
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 09:04:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=JKI+zzZCIDnbRBAPv5ZAA3d
	VKc0TkOgaI1dqIImtvbs=; b=cfgn1NQaBIl7Lky0OnZFk6xQzZ9/tSx729bgk/S
	mrMJgoXq5/jZSQNQV+W5ZtlC+BC8vjWvdtDFtlIyfOGkiwMG7GCsDftAI0BIwxGd
	4S/gp6pi8rTpEZ0aOGrc9Vl99FGPUwpLwKM/HG2g0m/f8HEOO/lj4xNuLQmOu2L1
	9kkY=
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 42mavd1cwa-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 09:04:24 -0700 (PDT)
Received: from twshared19620.08.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Thu, 31 Oct 2024 16:04:22 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 458BB8400837; Thu, 31 Oct 2024 16:04:10 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <io-uring@vger.kernel.org>, Mark Harmstone <maharmstone@fb.com>,
        Pavel
 Begunkov <asml.silence@gmail.com>
Subject: [PATCH] btrfs: add struct io_btrfs_cmd as type for io_uring_cmd_to_pdu()
Date: Thu, 31 Oct 2024 16:03:56 +0000
Message-ID: <20241031160400.3412499-1-maharmstone@fb.com>
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
X-Proofpoint-ORIG-GUID: LMD0aHw8VV4uHy5JC1bCttneY0UR8xmt
X-Proofpoint-GUID: LMD0aHw8VV4uHy5JC1bCttneY0UR8xmt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Add struct io_btrfs_cmd as a wrapper type for io_uring_cmd_to_pdu(),
rather than using a raw pointer.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/btrfs/ioctl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cf63264a3a60..27a9342cd91c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4740,9 +4740,14 @@ struct btrfs_uring_priv {
 	bool compressed;
 };
=20
+struct io_btrfs_cmd {
+	struct btrfs_uring_priv *priv;
+};
+
 static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned=
 int issue_flags)
 {
-	struct btrfs_uring_priv *priv =3D *io_uring_cmd_to_pdu(cmd, struct btrf=
s_uring_priv *);
+	struct io_btrfs_cmd *bc =3D io_uring_cmd_to_pdu(cmd, struct io_btrfs_cm=
d);
+	struct btrfs_uring_priv *priv =3D bc->priv;
 	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->iocb.ki_filp));
 	struct extent_io_tree *io_tree =3D &inode->io_tree;
 	unsigned long index;
@@ -4796,10 +4801,11 @@ static void btrfs_uring_read_finished(struct io_u=
ring_cmd *cmd, unsigned int iss
 void btrfs_uring_read_extent_endio(void *ctx, int err)
 {
 	struct btrfs_uring_priv *priv =3D ctx;
+	struct io_btrfs_cmd *bc =3D io_uring_cmd_to_pdu(priv->cmd, struct io_bt=
rfs_cmd);
=20
 	priv->err =3D err;
+	bc->priv =3D priv;
=20
-	*io_uring_cmd_to_pdu(priv->cmd, struct btrfs_uring_priv *) =3D priv;
 	io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring_read_finished);
 }
=20
--=20
2.45.2


