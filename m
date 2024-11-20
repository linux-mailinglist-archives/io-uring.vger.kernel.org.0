Return-Path: <io-uring+bounces-4874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D0E9D3F97
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 17:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D9A21F243B2
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBD614C5BD;
	Wed, 20 Nov 2024 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="dC0uwMr8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC4B1465BA
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118569; cv=none; b=EHPPh2MEE18AYTI0sMBHFgNM43j4PAlkO1D2LJ7Fd9xwJWA98Lx27s8CvlwXigxU9NmCJtF5Skoi7w/pFfy+6GXQMfi1QTXDXC24wOyv7J3bfYJK0PYfJkKmM7HdjaB7hpM3oJoFPANKNXXsfgiZ/A1euMoueRZ4Cx8b5B912kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118569; c=relaxed/simple;
	bh=1gNfZ505ibvsgNS6WpjiRwdrqa5Jys2ZXGnGL7iyDcM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tn74kLUmdSqAY1q9NkzNBT9x9yxbmcpWvm3QOPaZbdKYvWoCF5sb+HTtVECCpGCLJFz+Mk1ekHldlpbxHNhL643kMlg1X2Jpt7BLuGz2UD3Rz4a94/4HVCpZmmMYOkMjaKligY/lg4Avt0LEs4wZRfqtzpX1uWg+LlfAE3VinBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=dC0uwMr8; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 4AKEoUTU016111
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:02:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=d
	IGHM51+R6qC+5eive0P5RjdQ15p2Itoc8OfyySEVFE=; b=dC0uwMr8R+0CP4dxP
	S0cP2jpEar3U5eZ6P0oSp3juPCdnK3ht0Q7B5UZ5CgpEvgN8sW5oSbNbhlFRwWUz
	2BqAFNCTsHCuj1FVAKkhO7gvHOvLPM8/1sLWp1UnnH0NoxckNFoUJHSV6CCTFWQ5
	JtyUIyJDJ4Bj0O5GLCvSgxyijA=
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4315534917-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:02:46 -0800 (PST)
Received: from twshared22725.15.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 20 Nov 2024 16:02:44 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id CC5DB8D1CF09; Wed, 20 Nov 2024 16:02:35 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/cmd: add per-op data to struct io_uring_cmd_data
Date: Wed, 20 Nov 2024 16:02:21 +0000
Message-ID: <20241120160231.1106844-3-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241120160231.1106844-1-maharmstone@fb.com>
References: <20241120160231.1106844-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: T2owa_8geVpotId4Z_6qghPieS_KJpj4
X-Proofpoint-ORIG-GUID: T2owa_8geVpotId4Z_6qghPieS_KJpj4
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
index 24cff2b9b9d4..3df6636ec3a3 100644
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
index eefc203a1214..019d6f49ff20 100644
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


