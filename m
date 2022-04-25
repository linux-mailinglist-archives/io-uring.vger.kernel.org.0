Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DC850E8BF
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244649AbiDYSyr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244645AbiDYSyn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:54:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FACCB7C54
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:39 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHP6Je006698
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=pYa4g3addtGNqV13Mi43MvmmofNWC/HcMOY/BfkWtfo=;
 b=jmc24dSJcUAwtGHQDgv2OIc47z7xeObFflXKPMbVCo+VrM4eVtWTvbXOeb5ebzfubuYW
 xU51Vr3hEDUhoY6CjwWhu644FEaA06NVrEOPuEskBbUHZnMz5/rFoHC4aPvv+KSV0Afz
 GyHFSJXmyRo4RgJherjwAOwNigOT21Yot0Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmdgfvms9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:38 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:51:37 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 19680E1F5C88; Mon, 25 Apr 2022 11:51:31 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v4 2/6] liburing: increase mmap size for large CQE's
Date:   Mon, 25 Apr 2022 11:51:24 -0700
Message-ID: <20220425185128.2537966-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425185128.2537966-1-shr@fb.com>
References: <20220425185128.2537966-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7Yj4ETa7jrZHGzU2RDU8zOYmA_fvzQpt
X-Proofpoint-GUID: 7Yj4ETa7jrZHGzU2RDU8zOYmA_fvzQpt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This doubles the mmap size for large CQE's.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/setup.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/setup.c b/src/setup.c
index aec8b33..dd6a712 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -21,8 +21,12 @@ static int io_uring_mmap(int fd, struct io_uring_param=
s *p,
 	size_t size;
 	int ret;
=20
+	size =3D sizeof(struct io_uring_cqe);
+	if (p->flags & IORING_SETUP_CQE32)
+		size +=3D sizeof(struct io_uring_cqe);
+
 	sq->ring_sz =3D p->sq_off.array + p->sq_entries * sizeof(unsigned);
-	cq->ring_sz =3D p->cq_off.cqes + p->cq_entries * sizeof(struct io_uring=
_cqe);
+	cq->ring_sz =3D p->cq_off.cqes + p->cq_entries * size;
=20
 	if (p->features & IORING_FEAT_SINGLE_MMAP) {
 		if (cq->ring_sz > sq->ring_sz)
--=20
2.30.2

