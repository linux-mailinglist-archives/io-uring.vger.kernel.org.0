Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA59D5A932F
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbiIAJdU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiIAJdS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:18 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C672133F22
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:17 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2819Wfcx002750
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=m62++QvGAP5QwAjoFNb2kAM9wf7HOkGZQ/S9Zn7QLXQ=;
 b=IgWSqXgZDB1ruHgZ3zFBkevm/gnT0uFqneSVLNaJJ//7yAtY8NpKviV7Lx1tsCx9+zWw
 2P2DAzDmP/Kc1wtWmC5kNbBlpoiEt7NWQ9YW32DF6glJ+iOeAXV3izO33ZBjfenclHHI
 BF6FNb5EkgQ3X2gZFLsYrjOP3jLYicwQt2Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jat6s003c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:16 -0700
Received: from twshared11415.03.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:14 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A66AF57693F4; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 03/12] add io_uring_submit_and_get_events and io_uring_get_events
Date:   Thu, 1 Sep 2022 02:32:54 -0700
Message-ID: <20220901093303.1974274-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: amwacZ_Ezfvn6FgtIERnn-s1utL2CENY
X-Proofpoint-ORIG-GUID: amwacZ_Ezfvn6FgtIERnn-s1utL2CENY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
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
 src/queue.c            | 26 ++++++++++++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 6e868472b77a..3c5097b255de 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -202,6 +202,8 @@ int io_uring_register_file_alloc_range(struct io_urin=
g *ring,
 int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
 				    struct io_uring_notification_slot *slots);
 int io_uring_unregister_notifications(struct io_uring *ring);
+int io_uring_get_events(struct io_uring *ring);
+int io_uring_submit_and_get_events(struct io_uring *ring);
=20
 /*
  * io_uring syscalls.
diff --git a/src/queue.c b/src/queue.c
index a670a8ecd20d..b012a3dd950b 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -130,6 +130,15 @@ int __io_uring_get_cqe(struct io_uring *ring, struct=
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
@@ -164,11 +173,7 @@ again:
 		return 0;
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
@@ -340,9 +345,9 @@ int io_uring_wait_cqe_timeout(struct io_uring *ring,
  * Returns number of sqes submitted
  */
 static int __io_uring_submit(struct io_uring *ring, unsigned submitted,
-			     unsigned wait_nr)
+			     unsigned wait_nr, bool getevents)
 {
-	bool cq_needs_enter =3D wait_nr || cq_ring_needs_enter(ring);
+	bool cq_needs_enter =3D getevents || wait_nr || cq_ring_needs_enter(rin=
g);
 	unsigned flags;
 	int ret;
=20
@@ -363,7 +368,7 @@ static int __io_uring_submit(struct io_uring *ring, u=
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
@@ -386,6 +391,11 @@ int io_uring_submit_and_wait(struct io_uring *ring, =
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

