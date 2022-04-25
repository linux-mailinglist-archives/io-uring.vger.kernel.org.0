Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F21050E833
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244400AbiDYS3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240345AbiDYS3A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:29:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EB11CFF4
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:55 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHP6cY006771
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+VrprB8briehC8Cavkihxpy7Ci+QY9KDkkKYtmWW9S8=;
 b=K79BXbWWQ42x+GZQaYsDjlRPVVN/YRcmjkAB+P6ejydSiSfJJ24w43qiGNFd0KvuYjJK
 80kE3TFyTCwwXo/lcmQV0l1fTBjtbmJNKKP8a0R9fIGl+AZlAk/Z150/WxbLkAzDtDo1
 IP9f13fiEUrK5TtsSXKQlR8PC4IIQWLFsOI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmdgfvd4m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:55 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:25:51 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 29C00E1F2A59; Mon, 25 Apr 2022 11:25:41 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 03/12] io_uring: change ring size calculation for CQE32
Date:   Mon, 25 Apr 2022 11:25:21 -0700
Message-ID: <20220425182530.2442911-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425182530.2442911-1-shr@fb.com>
References: <20220425182530.2442911-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: X_tGSBZatE5yB04EyNESjPFSTY2ojOxp
X-Proofpoint-GUID: X_tGSBZatE5yB04EyNESjPFSTY2ojOxp
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

This changes the function rings_size to take large CQE's into account.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf2b02518332..9712483d3a17 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9693,8 +9693,8 @@ static void *io_mem_alloc(size_t size)
 	return (void *) __get_free_pages(gfp, get_order(size));
 }
=20
-static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries=
,
-				size_t *sq_offset)
+static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq=
_entries,
+				unsigned int cq_entries, size_t *sq_offset)
 {
 	struct io_rings *rings;
 	size_t off, sq_array_size;
@@ -9702,6 +9702,10 @@ static unsigned long rings_size(unsigned sq_entrie=
s, unsigned cq_entries,
 	off =3D struct_size(rings, cqes, cq_entries);
 	if (off =3D=3D SIZE_MAX)
 		return SIZE_MAX;
+	if (ctx->flags & IORING_SETUP_CQE32) {
+		if (check_shl_overflow(off, 1, &off))
+			return SIZE_MAX;
+	}
=20
 #ifdef CONFIG_SMP
 	off =3D ALIGN(off, SMP_CACHE_BYTES);
@@ -11365,7 +11369,7 @@ static __cold int io_allocate_scq_urings(struct i=
o_ring_ctx *ctx,
 	ctx->sq_entries =3D p->sq_entries;
 	ctx->cq_entries =3D p->cq_entries;
=20
-	size =3D rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
+	size =3D rings_size(ctx, p->sq_entries, p->cq_entries, &sq_array_offset=
);
 	if (size =3D=3D SIZE_MAX)
 		return -EOVERFLOW;
=20
--=20
2.30.2

