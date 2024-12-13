Return-Path: <io-uring+bounces-5490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E45819F1532
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 19:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5B83283CB7
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 18:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70F2183CD6;
	Fri, 13 Dec 2024 18:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="BLrTd2Vx"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C6A1547CA
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 18:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734115525; cv=none; b=YUWzKOz3QzQgtF2tKmhpt7Ngh2ww/b4qfqp2Vi2IM3bFbAxAg0pViQAScjZekdPjvG9P4es3AHm78tgvxrGagxovc+j+2zSfud3zEiDtjo8b5hQdQXzt81SD1X/EPYQlRbX607SnJb1L7XTGRjsDOM5tkAwwBm7lDSsgh9Y/izk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734115525; c=relaxed/simple;
	bh=4aahraanp2aCJrcRzQapKIxEIMyGrSTQXlPaesbo4pY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h6OJT6Igmvxar5P4BTa9y2YgIOFJM8RTarOhlQn9kdY2f1FK0bu0y4CJFFcsxJ2cL4vyJJ/a5GZEHtc190iSfXqtFZS0QXOsM+4N320cRpMzIUTsNNRQpFK6WrCuvmx3sVqfJwnWB3yZtHV3aApzQL5qHxFEI4WPViLNgADT1yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=BLrTd2Vx; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BDIT5Iv017057
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 10:45:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=s
	tGux1wet2iWTlhX6o4p5IkYLm9U0F7/7qdrSdQL2xQ=; b=BLrTd2Vx9xo+/MnSz
	kytxnaX2FMv84QoS/CD0WrQ5jWxwk1YQVcSk5F2SHXzxQeyyEntTe+m06piv0Vtl
	DR2dRDLG68nTAt2NrC7ncKLodTBB8Ij4/RWNQtrSw9FsbPvzBi0jtBO+dxY/WVDL
	5nZPr18jQWqAls7IowoLZT5wP4=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43gnxy248y-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 10:45:23 -0800 (PST)
Received: from twshared46479.39.frc1.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Dec 2024 18:45:03 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id CDC669868CB6; Fri, 13 Dec 2024 18:44:50 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 2/3] io_uring/cmd: add per-op data to struct io_uring_cmd_data
Date: Fri, 13 Dec 2024 18:44:29 +0000
Message-ID: <20241213184444.2112559-2-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241213184444.2112559-1-maharmstone@fb.com>
References: <20241213184444.2112559-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cqxfSSxigHI-rc7K4nP7gxmaW0MOY9EF
X-Proofpoint-ORIG-GUID: cqxfSSxigHI-rc7K4nP7gxmaW0MOY9EF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Jens Axboe <axboe@kernel.dk>

In case an op handler for ->uring_cmd() needs stable storage for user
data, it can allocate io_uring_cmd_data->op_data and use it for the
duration of the request. When the request gets cleaned up, uring_cmd
will free it automatically.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring/cmd.h |  1 +
 io_uring/uring_cmd.c         | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 61f97a398e9d..a65c7043078f 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -20,6 +20,7 @@ struct io_uring_cmd {
=20
 struct io_uring_cmd_data {
 	struct io_uring_sqe	sqes[2];
+	void			*op_data;
 };
=20
 static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sq=
e)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 629cb4266da6..ce7726a04883 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -23,12 +23,16 @@ static struct io_uring_cmd_data *io_uring_async_get(s=
truct io_kiocb *req)
=20
 	cache =3D io_alloc_cache_get(&ctx->uring_cache);
 	if (cache) {
+		cache->op_data =3D NULL;
 		req->flags |=3D REQ_F_ASYNC_DATA;
 		req->async_data =3D cache;
 		return cache;
 	}
-	if (!io_alloc_async_data(req))
-		return req->async_data;
+	if (!io_alloc_async_data(req)) {
+		cache =3D req->async_data;
+		cache->op_data =3D NULL;
+		return cache;
+	}
 	return NULL;
 }
=20
@@ -37,6 +41,11 @@ static void io_req_uring_cleanup(struct io_kiocb *req,=
 unsigned int issue_flags)
 	struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_uring_cm=
d);
 	struct io_uring_cmd_data *cache =3D req->async_data;
=20
+	if (cache->op_data) {
+		kfree(cache->op_data);
+		cache->op_data =3D NULL;
+	}
+
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return;
 	if (io_alloc_cache_put(&req->ctx->uring_cache, cache)) {
--=20
2.45.2


