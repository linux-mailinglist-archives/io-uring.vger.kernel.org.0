Return-Path: <io-uring+bounces-4574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 141E59C25E8
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 20:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D15E728216A
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 19:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E3C1AA1D3;
	Fri,  8 Nov 2024 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="hGF1m/4D"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E6E366
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731095673; cv=none; b=kPVzXdWUz9uzgBBBtIjb30PxfpxfKXrcTxi5e6iohj4IKdbNmDzck++UC+NE02x6mpcDL1q5AzosoGjUsXuTIzXGHLw7TKWxZk3AdJKRru2wHoDMoWBH6/EjCBBVpsw3V8aisX1NJP8GLUuBoRAVb6FTireN9ztpoCjNGRAu+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731095673; c=relaxed/simple;
	bh=7rsmAZLqnfg5iG0cF30bwwfecPgaDzQkot2fv4NAoLA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cdeg5lVUjR8LYZKwA/tuP/DUEopge2Mcbzxpd6W/Fn5xDV0tHg+qdTtWnUNL/+WbOdcbiTajiaXAHBebVi4wyIjtpoAedwAk59hyRj6r8QpBIZ7UegGXdc+rt4YB7z2zLaene9J8vi+TxXSpoS9Zz5Qy6qHWDIMHHmQOpZ23c6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=hGF1m/4D; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8JGi9t005101
	for <io-uring@vger.kernel.org>; Fri, 8 Nov 2024 11:54:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=YqSGEoSorOIfZ+D3KP3w6kJH+XkPq69QfKBXOE1ZvWs=; b=hGF1m/4DiLkI
	eYkCs6UqltqrIKqbFsDI02vlpDHQmo+ssekJoq6/9nr0HKilRoQVFlKfpK7/omkM
	qn3IAp1QHgntPGeZIajqELbMSq0tlqHaNGDClQRTxbwS9EER0k8TgPwJYZR1THaD
	/Fhy5kcNj+RjhRqJ0P6XiDZI1Ky0qeHX2PxrTft6FpO80DaW/QtwDcO0/spjZ964
	g1yYxJ4C3MXm6LE2oeX0rlWq6A0gHDWSbPG02uN0z6h3IZNqqhueFQa70upLyNUf
	KFQMcuw0Jekp6GWYEpEgapdyKohG6Y0Wog7Wehsk2agVGBBfg/+ZDOoI1v9w5ghL
	DAgrFVsxkw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42srnp08je-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 08 Nov 2024 11:54:31 -0800 (PST)
Received: from twshared10900.35.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 8 Nov 2024 19:54:06 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 3C66114E3A02B; Fri,  8 Nov 2024 11:36:58 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>
CC: <hch@lst.de>, <martin.petersen@oracle.com>, <asml.silence@gmail.com>,
        <javier.gonz@samsung.com>, <joshi.k@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCHv11 1/9] block: use generic u16 for write hints
Date: Fri, 8 Nov 2024 11:36:21 -0800
Message-ID: <20241108193629.3817619-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241108193629.3817619-1-kbusch@meta.com>
References: <20241108193629.3817619-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0l915u-74PzaquInEDAeyXbd4kYCEHAc
X-Proofpoint-ORIG-GUID: 0l915u-74PzaquInEDAeyXbd4kYCEHAc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

This is still backwards compatible with lifetime hints. It just doesn't
constrain the hints to that definition. Using this type doesn't change
the size of either bio or request.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/blk-mq.h    | 3 +--
 include/linux/blk_types.h | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2035fad3131fb..08ed7b5c4dbbf 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -8,7 +8,6 @@
 #include <linux/scatterlist.h>
 #include <linux/prefetch.h>
 #include <linux/srcu.h>
-#include <linux/rw_hint.h>
=20
 struct blk_mq_tags;
 struct blk_flush_queue;
@@ -156,7 +155,7 @@ struct request {
 	struct blk_crypto_keyslot *crypt_keyslot;
 #endif
=20
-	enum rw_hint write_hint;
+	unsigned short write_hint;
 	unsigned short ioprio;
=20
 	enum mq_rq_state state;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dce7615c35e7e..6737795220e18 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -10,7 +10,6 @@
 #include <linux/bvec.h>
 #include <linux/device.h>
 #include <linux/ktime.h>
-#include <linux/rw_hint.h>
=20
 struct bio_set;
 struct bio;
@@ -219,7 +218,7 @@ struct bio {
 						 */
 	unsigned short		bi_flags;	/* BIO_* below */
 	unsigned short		bi_ioprio;
-	enum rw_hint		bi_write_hint;
+	unsigned short		bi_write_hint;
 	blk_status_t		bi_status;
 	atomic_t		__bi_remaining;
=20
--=20
2.43.5


