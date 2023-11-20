Return-Path: <io-uring+bounces-106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 969D57F201F
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 23:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EC88282358
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 22:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B755639857;
	Mon, 20 Nov 2023 22:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nX/ZSYLO"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA8ADC
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:19:39 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AKMEM6l017953
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:19:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=laTxXOcgEIUw6wcBHM/GL0uL98TPZ5ULK0qkern8GYo=;
 b=nX/ZSYLO/Mx8oh2fNiCfEGMphDgWNTGu1c8HMKhQqV3XcjcxYf0xwRE0JY8AavRiNGq9
 1bNLlpqrJtQSDFBKzsoqMHj0k/z2Hqu0iQ2Ru+lrukILz0WkYOLULYlIunKH5QEtcuVw
 +AVwAGKYmJkiObimZHV5qZxM4yZoDzms70F88EVuCTeklSuutVZnPqYG48p10Xygpm5T
 IZOzwKmL7mJeEtqNexV4xfAGI3Zg/IXszXGIbO8r42Y8H7EAwQGBnmytdC/G5gPauYhh
 x0psv6XPVCsLGf9nRemjEDcU1aRmYi0BMJyUt5x9kCo10uwI2TjBmvg+CJIRKUcO+L6h Og== 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ugg2g02ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:19:38 -0800
Received: from twshared32169.15.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 14:18:34 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 8432B21F1842B; Mon, 20 Nov 2023 14:18:32 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <asml.silence@gmail.com>, <axboe@kernel.dk>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH] io_uring: fix off-by one bvec index
Date: Mon, 20 Nov 2023 14:18:31 -0800
Message-ID: <20231120221831.2646460-1-kbusch@meta.com>
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
X-Proofpoint-GUID: 7IdA__lH59qftnL2lAscEbtZX1Vnv73m
X-Proofpoint-ORIG-GUID: 7IdA__lH59qftnL2lAscEbtZX1Vnv73m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-20_22,2023-11-20_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

If the offset equals the bv_len of the first registered bvec, then the
request does not include any of that first bvec. Skip it so that drivers
don't have to deal with a zero length bvec, which was observed to break
NVMe's PRP list creation.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7034be555334d..f521c5965a933 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1258,7 +1258,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter=
,
 		 */
 		const struct bio_vec *bvec =3D imu->bvec;
=20
-		if (offset <=3D bvec->bv_len) {
+		if (offset < bvec->bv_len) {
 			/*
 			 * Note, huge pages buffers consists of one large
 			 * bvec entry and should always go this way. The other
--=20
2.34.1


