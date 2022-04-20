Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32D1509028
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381645AbiDTTSF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349026AbiDTTSD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:18:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA300BC33
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:15 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KILOGH008741
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=j4il0Wc+k65ZgaZVE1SCANOHHdTshOCogprm89wJj3w=;
 b=rq0y+YfuBNjgeJshti6vSoFZnOZmpcYxzeXkoqh5TDdwqrhWu9zO9EXvTSyLolB3gOlw
 eaa/Kb17uG51zFqguESwk7ZTENxrJZMhC7MAYA5Dqk425PHcQpHoFHqS9yBJ4Oy95ztW
 O8/ittLZQ+rP7vIAXlH3x+YwNQOVp4QYo8Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj9p1vy10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:15 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:14 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id BB37CDE0C418; Wed, 20 Apr 2022 12:14:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 10/12] io_uring: support CQE32 in /proc info
Date:   Wed, 20 Apr 2022 12:14:49 -0700
Message-ID: <20220420191451.2904439-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191451.2904439-1-shr@fb.com>
References: <20220420191451.2904439-1-shr@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: FWl-FPrdVhdP7V2NAzQcxaRE-8yuvpMZ
X-Proofpoint-GUID: FWl-FPrdVhdP7V2NAzQcxaRE-8yuvpMZ
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This exposes the extra1 and extra2 fields in the /proc output.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 366f49969b31..a5fbad91800c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11345,10 +11345,14 @@ static __cold void __io_uring_show_fdinfo(struct =
io_ring_ctx *ctx,
 	unsigned int sq_tail =3D READ_ONCE(r->sq.tail);
 	unsigned int cq_head =3D READ_ONCE(r->cq.head);
 	unsigned int cq_tail =3D READ_ONCE(r->cq.tail);
+	unsigned int cq_shift =3D 0;
 	unsigned int sq_entries, cq_entries;
 	bool has_lock;
 	unsigned int i;
=20
+	if (ctx->flags & IORING_SETUP_CQE32)
+		cq_shift =3D 1;
+
 	/*
 	 * we may get imprecise sqe and cqe info if uring is actively running
 	 * since we get cached_sq_head and cached_cq_tail without uring_lock
@@ -11381,11 +11385,18 @@ static __cold void __io_uring_show_fdinfo(struct =
io_ring_ctx *ctx,
 	cq_entries =3D min(cq_tail - cq_head, ctx->cq_entries);
 	for (i =3D 0; i < cq_entries; i++) {
 		unsigned int entry =3D i + cq_head;
-		struct io_uring_cqe *cqe =3D &r->cqes[entry & cq_mask];
+		struct io_uring_cqe *cqe =3D &r->cqes[(entry & cq_mask) << cq_shift];
=20
-		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x\n",
+		if (!(ctx->flags & IORING_SETUP_CQE32)) {
+			seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x\n",
 			   entry & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
+		} else {
+			seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x, "
+				"extra1:%llu, extra2:%llu\n",
+				entry & cq_mask, cqe->user_data, cqe->res,
+				cqe->flags, cqe->b[0].extra1, cqe->b[0].extra2);
+		}
 	}
=20
 	/*
--=20
2.30.2

