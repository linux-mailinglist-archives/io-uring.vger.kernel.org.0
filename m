Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9911592FAB
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiHONTi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242921AbiHONPe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:15:34 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4150765C
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:15:28 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FBOhhS007878
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:15:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NpQXEqs1qk3NnqzrOfsWsfDkvZfdNBDU2CTMUlPf+N4=;
 b=KMa7EurGBBgXYZ5xmGmwFVRLg8i7p6O9DglFfbzfF59iGJRI1jOE+xlPUnBSRAkf/pHc
 SvH4Xe8rASNbzoZq5dCJ1eOUV4zsSNKwdq+iifCKT9BNxrmjj2I7e5HaFZJ/6GGTPNdT
 8D86yfTFnfkpHHlIybvreda0PMBDmignV+E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hyn83rfwb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:15:27 -0700
Received: from twshared0646.06.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:15:26 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0F85349B72DE; Mon, 15 Aug 2022 06:09:55 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 02/11] add io_uring_submit_and_get_events and io_uring_get_events
Date:   Mon, 15 Aug 2022 06:09:38 -0700
Message-ID: <20220815130947.1002152-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130947.1002152-1-dylany@fb.com>
References: <20220815130947.1002152-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0s0HfNL6QbC2h1HbfFLgVLnum2Ee_Arr
X-Proofpoint-GUID: 0s0HfNL6QbC2h1HbfFLgVLnum2Ee_Arr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With deferred task running, we would like to be able to combine submit
with get events (regardless of if there are CQE's available), or if there
is nothing to submit then simply do an enter with IORING_ENTER_GETEVENTS
set, in order to process any available work.

Expose these APIs

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing.h |  2 ++
 src/queue.c            | 28 +++++++++++++++++++---------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 06f4a50bacb1..6b25c358c63f 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -192,6 +192,8 @@ int io_uring_register_file_alloc_range(struct io_urin=
g *ring,
 int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
 				    struct io_uring_notification_slot *slots);
 int io_uring_unregister_notifications(struct io_uring *ring);
+int io_uring_get_events(struct io_uring *ring);
+int io_uring_submit_and_get_events(struct io_uring *ring);
=20
 /*
  * Helper for the peek/wait single cqe functions. Exported because of th=
at,
diff --git a/src/queue.c b/src/queue.c
index 72cc77b9f0d0..216f29a8afef 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -124,6 +124,15 @@ int __io_uring_get_cqe(struct io_uring *ring, struct=
 io_uring_cqe **cqe_ptr,
 	return _io_uring_get_cqe(ring, cqe_ptr, &data);
 }
=20
+int io_uring_get_events(struct io_uring *ring)
+{
+	int flags =3D IORING_ENTER_GETEVENTS;
+
+	if (ring->int_flags & INT_FLAG_REG_RING)
+		flags |=3D IORING_ENTER_REGISTERED_RING;
+	return __sys_io_uring_enter(ring->enter_ring_fd, 0, 0, flags, NULL);
+}
+
 /*
  * Fill in an array of IO completions up to count, if any are available.
  * Returns the amount of IO completions filled.
@@ -158,11 +167,7 @@ again:
 		goto done;
=20
 	if (cq_ring_needs_flush(ring)) {
-		int flags =3D IORING_ENTER_GETEVENTS;
-
-		if (ring->int_flags & INT_FLAG_REG_RING)
-			flags |=3D IORING_ENTER_REGISTERED_RING;
-		__sys_io_uring_enter(ring->enter_ring_fd, 0, 0, flags, NULL);
+		io_uring_get_events(ring);
 		overflow_checked =3D true;
 		goto again;
 	}
@@ -348,14 +353,14 @@ int io_uring_wait_cqe_timeout(struct io_uring *ring=
,
  * Returns number of sqes submitted
  */
 static int __io_uring_submit(struct io_uring *ring, unsigned submitted,
-			     unsigned wait_nr)
+			     unsigned wait_nr, bool getevents)
 {
 	unsigned flags;
 	int ret;
=20
 	flags =3D 0;
-	if (sq_ring_needs_enter(ring, &flags) || wait_nr) {
-		if (wait_nr || (ring->flags & IORING_SETUP_IOPOLL))
+	if (getevents || sq_ring_needs_enter(ring, &flags) || wait_nr) {
+		if (getevents || wait_nr || (ring->flags & IORING_SETUP_IOPOLL))
 			flags |=3D IORING_ENTER_GETEVENTS;
 		if (ring->int_flags & INT_FLAG_REG_RING)
 			flags |=3D IORING_ENTER_REGISTERED_RING;
@@ -370,7 +375,7 @@ static int __io_uring_submit(struct io_uring *ring, u=
nsigned submitted,
=20
 static int __io_uring_submit_and_wait(struct io_uring *ring, unsigned wa=
it_nr)
 {
-	return __io_uring_submit(ring, __io_uring_flush_sq(ring), wait_nr);
+	return __io_uring_submit(ring, __io_uring_flush_sq(ring), wait_nr, fals=
e);
 }
=20
 /*
@@ -393,6 +398,11 @@ int io_uring_submit_and_wait(struct io_uring *ring, =
unsigned wait_nr)
 	return __io_uring_submit_and_wait(ring, wait_nr);
 }
=20
+int io_uring_submit_and_get_events(struct io_uring *ring)
+{
+	return __io_uring_submit(ring, __io_uring_flush_sq(ring), 0, true);
+}
+
 #ifdef LIBURING_INTERNAL
 struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
 {
--=20
2.30.2

