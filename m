Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49ED2509BFF
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387500AbiDUJVC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387521AbiDUJU7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:20:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE91D26559
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:02 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23L5odeq000930
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KpTp7REZeYs/YOlOhTeIUZnQ9iZmdexqGO2lpodt0bc=;
 b=J5sY2g2tdrQFZciTQ8MT8JJn9JAabNusg2WdVaVDIyH/1HQmwnguSxp1UyjV6h6pxmu3
 ZjcIoltR5lHlocQssxSGfgScC8wXnmYwNGxfZtdnWHXPsTs6mBUk/FO3o4yFSbhfardy
 8NF+xUTO4MgNDlcWv3t+98o02l26DxcggU4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj36tb6vs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:02 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:18:00 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id E23347CA771F; Thu, 21 Apr 2022 02:14:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 3/5] expose CQ ring overflow state
Date:   Thu, 21 Apr 2022 02:14:25 -0700
Message-ID: <20220421091427.2118151-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091427.2118151-1-dylany@fb.com>
References: <20220421091427.2118151-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: LhuFWs1XDiVIDH-3qzclS41z0Y2RlrKm
X-Proofpoint-ORIG-GUID: LhuFWs1XDiVIDH-3qzclS41z0Y2RlrKm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allow the application to easily view if the CQ ring is in overflow state,=
 and
also a simple method to flush overflow entries on to the CQ ring.
Explicit flushing can be useful for applications that prefer to have
reduced latency on CQs than to process as many as possible.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing.h | 10 ++++++++++
 src/queue.c            | 31 +++++++++++++++++++------------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 5c03061..16c31a4 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -135,6 +135,7 @@ int io_uring_submit_and_wait_timeout(struct io_uring =
*ring,
 				     unsigned wait_nr,
 				     struct __kernel_timespec *ts,
 				     sigset_t *sigmask);
+int io_uring_flush_overflow(struct io_uring *ring);
=20
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec =
*iovecs,
 			      unsigned nr_iovecs);
@@ -781,6 +782,15 @@ static inline unsigned io_uring_cq_ready(const struc=
t io_uring *ring)
 	return io_uring_smp_load_acquire(ring->cq.ktail) - *ring->cq.khead;
 }
=20
+/*
+ * Returns true if there are overflow entries waiting to be flushed onto
+ * the CQ ring
+ */
+static inline bool io_uring_cq_has_overflow(const struct io_uring *ring)
+{
+	return IO_URING_READ_ONCE(*ring->sq.kflags) & IORING_SQ_CQ_OVERFLOW;
+}
+
 /*
  * Returns true if the eventfd notification is currently enabled
  */
diff --git a/src/queue.c b/src/queue.c
index 856d270..bfcf11f 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -33,14 +33,10 @@ static inline bool sq_ring_needs_enter(struct io_urin=
g *ring, unsigned *flags)
 	return false;
 }
=20
-static inline bool cq_ring_needs_flush(struct io_uring *ring)
-{
-	return IO_URING_READ_ONCE(*ring->sq.kflags) & IORING_SQ_CQ_OVERFLOW;
-}
-
 static inline bool cq_ring_needs_enter(struct io_uring *ring)
 {
-	return (ring->flags & IORING_SETUP_IOPOLL) || cq_ring_needs_flush(ring)=
;
+	return (ring->flags & IORING_SETUP_IOPOLL) ||
+		io_uring_cq_has_overflow(ring);
 }
=20
 struct get_data {
@@ -123,6 +119,21 @@ int __io_uring_get_cqe(struct io_uring *ring, struct=
 io_uring_cqe **cqe_ptr,
 	return _io_uring_get_cqe(ring, cqe_ptr, &data);
 }
=20
+static int io_uring_get_events(struct io_uring *ring)
+{
+	int flags =3D IORING_ENTER_GETEVENTS;
+
+	if (ring->int_flags & INT_FLAG_REG_RING)
+		flags |=3D IORING_ENTER_REGISTERED_RING;
+	return ____sys_io_uring_enter(ring->enter_ring_fd, 0, 0, flags, NULL);
+}
+
+int io_uring_flush_overflow(struct io_uring *ring)
+{
+	return io_uring_get_events(ring);
+}
+
+
 /*
  * Fill in an array of IO completions up to count, if any are available.
  * Returns the amount of IO completions filled.
@@ -152,12 +163,8 @@ again:
 	if (overflow_checked)
 		goto done;
=20
-	if (cq_ring_needs_flush(ring)) {
-		int flags =3D IORING_ENTER_GETEVENTS;
-
-		if (ring->int_flags & INT_FLAG_REG_RING)
-			flags |=3D IORING_ENTER_REGISTERED_RING;
-		____sys_io_uring_enter(ring->enter_ring_fd, 0, 0, flags, NULL);
+	if (io_uring_cq_has_overflow(ring)) {
+		io_uring_get_events(ring);
 		overflow_checked =3D true;
 		goto again;
 	}
--=20
2.30.2

