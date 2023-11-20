Return-Path: <io-uring+bounces-109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDBA7F207D
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 23:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE0F5282852
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 22:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8AD20322;
	Mon, 20 Nov 2023 22:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="hz+peIQe"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB2CCB
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:11 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AKMU69V019936
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=M8htFuQxJZG8po3RKf01MkNCd95IOJcyvkzSlqSB8p8=;
 b=hz+peIQeEw8s600s1PMM1jXSo7qiyIicDQcL8d6fEIOp/kLCERoxeGhtGcbyg/M+qWh9
 zIN2oNHRJy3ASLw3Vx8p8E3fUyfQN+BGI0ldsXLdC1OvvbW9Fwrt6wGjrYiaWdYVe0QM
 SeARvza7NZS1Sj9S0/dkjR7miEPADxcI9oGi/hDRyo4fe0EFnCKnkdL7Fgg419oQQqWD
 wUFW3cB1ULtnaSaxh0VabgFGD4kdjJ3a+0obn6Q5/3RuL0fSfLZNZERymHvl8k0JiT+H
 NfJ/U7NMj8ycETi3iLsuVEptlOJsT7IRF8YMAzsfp1KkhdA4UKJl50KY1m1n/8fMo2ms Dg== 
Received: from mail.thefacebook.com ([163.114.132.120])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ugg9xr3ck-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:11 -0800
Received: from twshared22605.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 14:41:09 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 8AA0521F1B1A8; Mon, 20 Nov 2023 14:40:59 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 1/5] bvec: introduce multi-page bvec iterating
Date: Mon, 20 Nov 2023 14:40:54 -0800
Message-ID: <20231120224058.2750705-2-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231120224058.2750705-1-kbusch@meta.com>
References: <20231120224058.2750705-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ocfDB0Z6QhnGi6f1ywlhsTRmPVy3XUjm
X-Proofpoint-GUID: ocfDB0Z6QhnGi6f1ywlhsTRmPVy3XUjm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-20_22,2023-11-20_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

Some bio_vec iterators can handle physically contiguous memory and have
no need to split bvec consideration on page boundaries.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/bvec.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 555aae5448ae4..9364c258513e0 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -184,6 +184,12 @@ static inline void bvec_iter_advance_single(const st=
ruct bio_vec *bv,
 		((bvl =3D bvec_iter_bvec((bio_vec), (iter))), 1);	\
 	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
=20
+#define for_each_mp_bvec(bvl, bio_vec, iter, start)			\
+	for (iter =3D (start);						\
+	     (iter).bi_size &&						\
+		((bvl =3D mp_bvec_iter_bvec((bio_vec), (iter))), 1);	\
+	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
+
 /* for iterating one bio from start to end */
 #define BVEC_ITER_ALL_INIT (struct bvec_iter)				\
 {									\
--=20
2.34.1


