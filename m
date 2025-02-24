Return-Path: <io-uring+bounces-6710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45490A42F16
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:31:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E79616E9F9
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7071632C8;
	Mon, 24 Feb 2025 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="mI1qOJ8u"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE602487BF
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 21:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432688; cv=none; b=crv0vsKcTgsDgk2i2xyJPjFCcYhqOvH0aA6nSRzK2y+RQpbCAgE4lQhEirKhr2S/Ciemj+Ff0cIhXs7Yy7jPKFV2kOD0K0ibU2lYVmF740Yo+IVBr05kb1LmC/OrbZcRo0Crs2qnWLvJa7o21sxqtAyZW7c0x+Tt1R6q7CZzJ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432688; c=relaxed/simple;
	bh=Ge431Po1ujRaRqKpPyxwV/no1ZsNP+WgRZlxPZWkCAc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QKakKF6CKPXKbLoksrLNPKHBbR1Fs8sIwjUwwxqjvEBX0f5Gz+zK0nvNAGHyQX2hytD0/ProcjjA4ErB6flNR7+c8mEx7rTe+wU/G00S4WTyu6MNUybn09uS6WifxT47UO4mqPVIZwf7FwQRlgHpYgJtLTJpvWzDGOLuNCnxNYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=mI1qOJ8u; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OFDHRX023683
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=qUmUHHe0j+uWHLe+m4CdCPyVThJx6/A6xtMjccdwVVg=; b=mI1qOJ8ucNXD
	qpn3JCGX/3GKQUjFHlhIvOKojh5R+l1OcKjfPlkPFRcQlShoJY16NhVf3V1w2xGh
	0cw2z6hxBFQazhZtqw/EZ8i7orAnm3G1akV5fAlv4GxEMVf/L6si6sWUuJNfL0mU
	2TIjPGllK6tKMdqtgjw5AfymhMOJKG8dQQ3Suq73ULXK9OuLlfSQMYJ7HyX/mMFH
	wwG5wD0IexIbo5qvkZv0BducOmlVV9VMqHDBMEUcJJEtn1+prRnsz8DogCxwyrAl
	QpW9cOzemlugYwAO4O57fcHGLspDRy/jLWZ//qCfFvUMUKm1ZBQKR29ZlgWpV4H8
	Y+LDEgtK0g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 450tdcufr4-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:25 -0800 (PST)
Received: from twshared9216.15.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 24 Feb 2025 21:31:15 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 5A97D1868C4EB; Mon, 24 Feb 2025 13:31:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 02/11] io_uring/nop: reuse req->buf_index
Date: Mon, 24 Feb 2025 13:31:07 -0800
Message-ID: <20250224213116.3509093-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250224213116.3509093-1-kbusch@meta.com>
References: <20250224213116.3509093-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: bEAaTAbz1YQWbYVnJ-AGhRaprJjEvN9D
X-Proofpoint-ORIG-GUID: bEAaTAbz1YQWbYVnJ-AGhRaprJjEvN9D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_10,2025-02-24_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

There is already a field in io_kiocb that can store a registered buffer
index, use that instead of stashing the value into struct io_nop.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/nop.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/io_uring/nop.c b/io_uring/nop.c
index 5e5196df650a1..ea539531cb5f6 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -16,7 +16,6 @@ struct io_nop {
 	struct file     *file;
 	int             result;
 	int		fd;
-	int		buffer;
 	unsigned int	flags;
 };
=20
@@ -40,9 +39,7 @@ int io_nop_prep(struct io_kiocb *req, const struct io_u=
ring_sqe *sqe)
 	else
 		nop->fd =3D -1;
 	if (nop->flags & IORING_NOP_FIXED_BUFFER)
-		nop->buffer =3D READ_ONCE(sqe->buf_index);
-	else
-		nop->buffer =3D -1;
+		req->buf_index =3D READ_ONCE(sqe->buf_index);
 	return 0;
 }
=20
@@ -69,7 +66,7 @@ int io_nop(struct io_kiocb *req, unsigned int issue_fla=
gs)
=20
 		ret =3D -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, nop->buffer);
+		node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
 		if (node) {
 			io_req_assign_buf_node(req, node);
 			ret =3D 0;
--=20
2.43.5


