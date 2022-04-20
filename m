Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510DC50902F
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349026AbiDTTS0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379219AbiDTTSX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:18:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25285340F6
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:35 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KILOBP018240
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=SlaX8PQbpOXceceSt/V8HyxEEK54AqkgMhOz5u9VzoY=;
 b=komeG1BVrAV4uwnzTcLMcpuRuI5QXa5JDf9qIt3EQ3UqX1HN4GyQM91CZsxiFd8YNM8i
 3dS2idpwgIcei+TF8RKhaq8XWtQSY2wi/Yg+0Ls/redp15dkFxVGFBBNJbV6RngHEcli
 CYa1kw/ppAzp969Rkl00ZZed6j6caOZhnGc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhkk2cswp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:34 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:33 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 65520DE0C4B9; Wed, 20 Apr 2022 12:15:27 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 4/6] liburing: index large CQE's correctly
Date:   Wed, 20 Apr 2022 12:15:22 -0700
Message-ID: <20220420191524.2906409-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191524.2906409-1-shr@fb.com>
References: <20220420191524.2906409-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: j_PTqz7BQz5Jw9Itwy8wXN7HuaIfp-NM
X-Proofpoint-ORIG-GUID: j_PTqz7BQz5Jw9Itwy8wXN7HuaIfp-NM
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

Large CQE's need to take into account that each CQE has double the size.
When the CQE array is indexed, the offset into the array needs to be
changed accordingly.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing.h | 18 ++++++++++++++++--
 src/queue.c            |  6 +++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index c01c231..317963c 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -188,6 +188,16 @@ int __io_uring_get_cqe(struct io_uring *ring,
=20
 #define LIBURING_UDATA_TIMEOUT	((__u64) -1)
=20
+/*
+ * Calculates the step size for CQE iteration.
+ * 	For standard CQE's its 1, for big CQE's its two.
+ */
+#define io_uring_cqe_shift(ring)					\
+	(!!((ring)->flags & IORING_SETUP_CQE32))
+
+#define io_uring_cqe_index(ring,ptr,mask)				\
+	(((ptr) & (mask)) << io_uring_cqe_shift(ring))
+
 #define io_uring_for_each_cqe(ring, head, cqe)				\
 	/*								\
 	 * io_uring_smp_load_acquire() enforces the order of tail	\
@@ -195,7 +205,7 @@ int __io_uring_get_cqe(struct io_uring *ring,
 	 */								\
 	for (head =3D *(ring)->cq.khead;					\
 	     (cqe =3D (head !=3D io_uring_smp_load_acquire((ring)->cq.ktail) ? =
\
-		&(ring)->cq.cqes[head & (*(ring)->cq.kring_mask)] : NULL)); \
+		&(ring)->cq.cqes[io_uring_cqe_index(ring, head, *(ring)->cq.kring_mask=
)] : NULL)); \
 	     head++)							\
=20
 /*
@@ -844,6 +854,10 @@ static inline int __io_uring_peek_cqe(struct io_urin=
g *ring,
 	int err =3D 0;
 	unsigned available;
 	unsigned mask =3D *ring->cq.kring_mask;
+	int shift =3D 0;
+
+	if (ring->flags & IORING_SETUP_CQE32)
+		shift =3D 1;
=20
 	do {
 		unsigned tail =3D io_uring_smp_load_acquire(ring->cq.ktail);
@@ -854,7 +868,7 @@ static inline int __io_uring_peek_cqe(struct io_uring=
 *ring,
 		if (!available)
 			break;
=20
-		cqe =3D &ring->cq.cqes[head & mask];
+		cqe =3D &ring->cq.cqes[(head & mask) << shift];
 		if (!(ring->features & IORING_FEAT_EXT_ARG) &&
 				cqe->user_data =3D=3D LIBURING_UDATA_TIMEOUT) {
 			if (cqe->res < 0)
diff --git a/src/queue.c b/src/queue.c
index 2f85756..4ad41fc 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -132,6 +132,10 @@ unsigned io_uring_peek_batch_cqe(struct io_uring *ri=
ng,
 {
 	unsigned ready;
 	bool overflow_checked =3D false;
+	int shift =3D 0;
+
+	if (ring->flags & IORING_SETUP_CQE32)
+		shift =3D 1;
=20
 again:
 	ready =3D io_uring_cq_ready(ring);
@@ -144,7 +148,7 @@ again:
 		count =3D count > ready ? ready : count;
 		last =3D head + count;
 		for (;head !=3D last; head++, i++)
-			cqes[i] =3D &ring->cq.cqes[head & mask];
+			cqes[i] =3D &ring->cq.cqes[(head & mask) << shift];
=20
 		return count;
 	}
--=20
2.30.2

