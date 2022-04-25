Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED7450E82A
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbiDYS3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244394AbiDYS3y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:29:54 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D182494F
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:49 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHP3rg019233
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=pYa4g3addtGNqV13Mi43MvmmofNWC/HcMOY/BfkWtfo=;
 b=IALaEtbpYJ0rpoq+gO2xrfTHhrcKXWLHSK31P+30SVITGq3uCOMwcs/KceAPjHEq1ceI
 s+Es/bIPOfZMQvCbDns+bp6vOn6zRfurK5Zz7sI82bmHhA70jPzzMlBOyYtW+CMIHeFm
 LMrlH190yrUSGbaG45Zyymm7MHLKoWSANHI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmf6v3wrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:48 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:26:47 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A7826E1F2B2F; Mon, 25 Apr 2022 11:26:43 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v3 2/6] liburing: increase mmap size for large CQE's
Date:   Mon, 25 Apr 2022 11:26:35 -0700
Message-ID: <20220425182639.2446370-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425182639.2446370-1-shr@fb.com>
References: <20220425182639.2446370-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Tke61sEV66d1tm42TB8i3I1ZzB2or-Wy
X-Proofpoint-ORIG-GUID: Tke61sEV66d1tm42TB8i3I1ZzB2or-Wy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

