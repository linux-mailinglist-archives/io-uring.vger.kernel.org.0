Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA71507B67
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242007AbiDSU71 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 16:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiDSU70 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 16:59:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088C141608
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:43 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGdvIE011525
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+VrprB8briehC8Cavkihxpy7Ci+QY9KDkkKYtmWW9S8=;
 b=Stb15VkqB4aGBEse+2hZIyOL6cBaZ6M6LMtwo12Rg0N6MUfPtCZ7KYLyYHBxQeDH4YVK
 cfnxpy+lLlkofiwn/d4whkcgpUZ6r6MK0viz6+VnkZ1ATZ7qY69eIAjSofFHP5SSksby
 yAUD4dq5nnsmg8H+/X09EEKUUw9I92kn4oY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhjh1pddh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:56:42 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:56:41 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id EECF3DD45FE1; Tue, 19 Apr 2022 13:56:35 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v1 03/11] io_uring: change ring size calculation for CQE32
Date:   Tue, 19 Apr 2022 13:56:16 -0700
Message-ID: <20220419205624.1546079-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205624.1546079-1-shr@fb.com>
References: <20220419205624.1546079-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0xMw92qKltHDiSr4lRpTP9hTh-cOpmM3
X-Proofpoint-ORIG-GUID: 0xMw92qKltHDiSr4lRpTP9hTh-cOpmM3
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

