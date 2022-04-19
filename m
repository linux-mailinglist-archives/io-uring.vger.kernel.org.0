Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9FA507B8F
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357876AbiDSVBU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 17:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357875AbiDSVBS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 17:01:18 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A013841FAE
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:33 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGe4W4017910
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=WVbI536hoxZ1wYZdlP7VE8Hmy7spTZOU9Wd2P1breuE=;
 b=dDj2/vSHR2pxPnL9dJCdwZsUK1FB1q9iZ1tFLle5+XXsIc2FtL7lWfUlXl41r/BrORNm
 Px3NhdooEBano+JRW4i8Giqlny/4pYUovfJiXQ78MLdi8En7zbVxWH6pz1IIL84ly1gp
 gH95XVoZlHcLs2wYYd/jykHvY2dXVz2+rxk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhn50wth0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub203.TheFacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:58:31 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:58:31 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 5BE36DD4611A; Tue, 19 Apr 2022 13:58:26 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 3/6] liburing: return correct ring size for large CQE's
Date:   Tue, 19 Apr 2022 13:58:14 -0700
Message-ID: <20220419205817.1551377-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205817.1551377-1-shr@fb.com>
References: <20220419205817.1551377-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: xoqWVExbHut-1wOiWvZKNR5nWiHfLE4Y
X-Proofpoint-ORIG-GUID: xoqWVExbHut-1wOiWvZKNR5nWiHfLE4Y
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

Return the correct ring_size when large CQE's are used.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/setup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/setup.c b/src/setup.c
index dd6a712..d2adc7f 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -257,8 +257,11 @@ static size_t rings_size(struct io_uring_params *p, =
unsigned entries,
 {
 	size_t pages, sq_size, cq_size;
=20
-	cq_size =3D KRING_SIZE;
-	cq_size +=3D cq_entries * sizeof(struct io_uring_cqe);
+	cq_size =3D sizeof(struct io_uring_cqe);
+	if (p->flags & IORING_SETUP_CQE32)
+		cq_size +=3D sizeof(struct io_uring_cqe);
+	cq_size *=3D cq_entries;
+	cq_size +=3D KRING_SIZE;
 	cq_size =3D (cq_size + 63) & ~63UL;
 	pages =3D (size_t) 1 << npages(cq_size, page_size);
=20
--=20
2.30.2

