Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7959507B8A
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357867AbiDSVBT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 17:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357872AbiDSVBS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 17:01:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2299F41FAD
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:33 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGdrdL021335
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=pYa4g3addtGNqV13Mi43MvmmofNWC/HcMOY/BfkWtfo=;
 b=pLgymH+Bzyic8GrbTITVs1yk23CtoK2IR1+jBNX0Ncyz5EBhmwogsyb8S/SS5zQhhxYS
 bZJCrQKIhT4rqQyCxcdTIJCv/KG3sV8Nkkv/xjESFCptDKanD61U40lDgNg3GUAWIv5q
 wziFezrxbaDl8bXMV0ZqcHhG/pJrUXuSQEo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhn52ws18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub102.TheFacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:58:32 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:58:31 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 544A4DD46118; Tue, 19 Apr 2022 13:58:26 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 2/6] liburing: increase mmap size for large CQE's
Date:   Tue, 19 Apr 2022 13:58:13 -0700
Message-ID: <20220419205817.1551377-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205817.1551377-1-shr@fb.com>
References: <20220419205817.1551377-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 8gao4c_kJwZm5cOChKPCYYLYDV4Pg4mO
X-Proofpoint-ORIG-GUID: 8gao4c_kJwZm5cOChKPCYYLYDV4Pg4mO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_08,2022-04-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

