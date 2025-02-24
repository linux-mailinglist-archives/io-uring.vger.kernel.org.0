Return-Path: <io-uring+bounces-6721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69894A42F39
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D4C43B12B9
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3B01DF969;
	Mon, 24 Feb 2025 21:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cv774OZn"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A7A1FCFC6
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 21:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432705; cv=none; b=FQo+aTDlwUeT82mNQh0Afb6CqfKWGUhrwmfM8CKlaff6L2ATs3CkclPE5GDT0H/pRLju3oFcRpKxPtQcVo3mvf7d+3lurlI8u0VCJnNT9wACTb+xpq5wE44gC0i8VQRb5gjurXyoYMfc3AoAvmfvMLuTHzP3MiURAAz+QZ68sn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432705; c=relaxed/simple;
	bh=OhH73J9J+vByXQd0nSIiVg8cPPHIHgcXH0YZ6SZvhoI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DCq+HiN7wALluNkrEkXnME/1jbrXmOHZ6JikTC+Gc5+59ER0wefTKWcfgE+x2Xhc20urdgmbMBqbjYT0AEwXnf/7/CQX9Gn9bdXpsTfbgtdaPI1P6k2LFi5EjmlQSxZKoqer3/pvNk2EcPb4lGwN49oWwJKcBbI1JDS5ZU9OWC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cv774OZn; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OIuNtl016161
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=z3zE/JpygxHalJZkRBF5AYpcbJa/t5fQiwdoTI91yjM=; b=cv774OZnFZJJ
	xaT3mzejKLW50qQ1lsvvYwAnJRN0XwtwgzevbrVdil0QRtk7O03rimJqAgVWNl/p
	Iln3qoVBQGHBJyPNO48EHJJvZ3VwfT6JjfrBp3Fr+p485fIGSx4giXcrvUWRlZEu
	o85Z1w5rNzyY6yX8PxiuxpUqLTVesNgJ6wiV5MQexfWYlAfFSmPMm2EWdypNVtuB
	xaOa3XmnLve0Re72ZPq51/OB0XMgYqSWjdiYwI/XsJp89rL5BKW046lg9t6d2T1o
	MD924ZW6h7+jFDsNpi61X9SUDv0pwf++QS1rg+3n5l9AQi/TBtoUcXinG092IlJ2
	xuu9DPcPcA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 450xg0s6up-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:43 -0800 (PST)
Received: from twshared11082.06.ash8.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 24 Feb 2025 21:31:24 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 64C8E1868C4ED; Mon, 24 Feb 2025 13:31:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 03/11] io_uring/net: reuse req->buf_index for sendzc
Date: Mon, 24 Feb 2025 13:31:08 -0800
Message-ID: <20250224213116.3509093-4-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: kDhE8SPmrUAfCxZExJyKOuiPWiMsCKYv
X-Proofpoint-GUID: kDhE8SPmrUAfCxZExJyKOuiPWiMsCKYv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_10,2025-02-24_02,2024-11-22_01

From: Pavel Begunkov <asml.silence@gmail.com>

There is already a field in io_kiocb that can store a registered buffer
index, use that instead of stashing the value into struct io_sr_msg.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 173546415ed17..fa35a6b58d472 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -76,7 +76,6 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
-	u16				buf_index;
 	bool				retry;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
@@ -1371,7 +1370,7 @@ int io_send_zc_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
=20
 	zc->len =3D READ_ONCE(sqe->len);
 	zc->msg_flags =3D READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCO=
PY;
-	zc->buf_index =3D READ_ONCE(sqe->buf_index);
+	req->buf_index =3D READ_ONCE(sqe->buf_index);
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |=3D REQ_F_NOWAIT;
=20
@@ -1447,7 +1446,7 @@ static int io_send_zc_import(struct io_kiocb *req, =
unsigned int issue_flags)
=20
 		ret =3D -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, sr->buf_index);
+		node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
 		if (node) {
 			io_req_assign_buf_node(sr->notif, node);
 			ret =3D 0;
--=20
2.43.5


