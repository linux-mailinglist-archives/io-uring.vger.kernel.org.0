Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92FE50E83A
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbiDYS3L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244397AbiDYS3G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:29:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E6D21833
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:00 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHPGCc031685
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dVtUF55jtgEmVrBg6DLq2P86ucjfdRAqoPrT/PGz08Y=;
 b=FM+ceT3R7vdDHi+wgWrB0g/zGGrJkaQy8Al8csqAfzfBiWwSfbtb4a5Bm2rm1e2XnjtK
 elpRW82AXvGVi/7x/dyvQI7tXjNi1h1UvtP8WY3agaCBtVHwcBE4iBEnzJtiThAPrXWw
 VgNzy+U7JcaVj4j3Lpg1geUmYxJMa6UGQWk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmf5f437c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:59 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:25:58 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 59490E1F2A67; Mon, 25 Apr 2022 11:25:41 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v3 10/12] io_uring: support CQE32 in /proc info
Date:   Mon, 25 Apr 2022 11:25:28 -0700
Message-ID: <20220425182530.2442911-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425182530.2442911-1-shr@fb.com>
References: <20220425182530.2442911-1-shr@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fSeF_uYae4sSJe97KO_ksCkUHXdgwJzr
X-Proofpoint-ORIG-GUID: fSeF_uYae4sSJe97KO_ksCkUHXdgwJzr
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
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

This exposes the extra1 and extra2 fields in the /proc output.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9dd075e39850..e1b84204b0ab 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11354,10 +11354,15 @@ static __cold void __io_uring_show_fdinfo(struct =
io_ring_ctx *ctx,
 	unsigned int sq_tail =3D READ_ONCE(r->sq.tail);
 	unsigned int cq_head =3D READ_ONCE(r->cq.head);
 	unsigned int cq_tail =3D READ_ONCE(r->cq.tail);
+	unsigned int cq_shift =3D 0;
 	unsigned int sq_entries, cq_entries;
 	bool has_lock;
+	bool is_cqe32 =3D (ctx->flags & IORING_SETUP_CQE32);
 	unsigned int i;
=20
+	if (is_cqe32)
+		cq_shift =3D 1;
+
 	/*
 	 * we may get imprecise sqe and cqe info if uring is actively running
 	 * since we get cached_sq_head and cached_cq_tail without uring_lock
@@ -11390,11 +11395,18 @@ static __cold void __io_uring_show_fdinfo(struct =
io_ring_ctx *ctx,
 	cq_entries =3D min(cq_tail - cq_head, ctx->cq_entries);
 	for (i =3D 0; i < cq_entries; i++) {
 		unsigned int entry =3D i + cq_head;
-		struct io_uring_cqe *cqe =3D &r->cqes[entry & cq_mask];
+		struct io_uring_cqe *cqe =3D &r->cqes[(entry & cq_mask) << cq_shift];
=20
-		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x\n",
+		if (!is_cqe32) {
+			seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x\n",
 			   entry & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
+		} else {
+			seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x, "
+				"extra1:%llu, extra2:%llu\n",
+				entry & cq_mask, cqe->user_data, cqe->res,
+				cqe->flags, cqe->big_cqe[0], cqe->big_cqe[1]);
+		}
 	}
=20
 	/*
--=20
2.30.2

