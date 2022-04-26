Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC6C5106B1
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbiDZSYy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiDZSYx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:24:53 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B9344F0
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:45 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQaie011703
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dB8+MrD5O9wi0ghEOijaYM33MpOL8F3wv6twB5MDRiQ=;
 b=JiHDFo8Q33K0l/J9VLk/8PkW5n4BiCwFYgs6SAwNP1rPDWUi6E0Gi6uD/gbApCRJvCzp
 1/EfmRD2gNW6bWLR3INIbIOgxgNyJSy3fyoLvso12v2I/sKTZfkMQmdczQ3+1JY8Uj1c
 HUCqHcRHNiSVGCK2mjNXtCf2Nc4drT+Xkso= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmeyu3yk2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:21:44 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:21:42 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 4FBB9E2E5692; Tue, 26 Apr 2022 11:21:36 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v4 03/12] io_uring: change ring size calculation for CQE32
Date:   Tue, 26 Apr 2022 11:21:25 -0700
Message-ID: <20220426182134.136504-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426182134.136504-1-shr@fb.com>
References: <20220426182134.136504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: lAbfdShEzAwRIVN4nrpQMi0RSZhb-_Rc
X-Proofpoint-ORIG-GUID: lAbfdShEzAwRIVN4nrpQMi0RSZhb-_Rc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
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

