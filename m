Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3D05AD3CB
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbiIENZG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbiIENZE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:25:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10C2186E9
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:25:02 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 285BZMXE031641
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:25:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=WXn5jQ5WJCURHwV9rZatQXxT6A/uG/brVfpgetXdZFA=;
 b=AlpJvAJzfuWWbWfFI66wlsfoPTrCRqzBA+ufaXxxvk/dxlF6Ojlj3dls5q4QAbSZecPn
 Tp+y8zu/w+1dkHmKSG7FCdzM3p/uUrc+cViiAbXzi2ZVU+6guyplGIdoF7jnjZ+rCSPD
 RHzSVyWI0aNSX43o624DRdU/qTfnFOZJuUI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jcgaeegkn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:25:02 -0700
Received: from twshared8288.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:25:01 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1FD6D5AC516E; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 03/11] add io_uring_submit_and_get_events and io_uring_get_events
Date:   Mon, 5 Sep 2022 06:22:50 -0700
Message-ID: <20220905132258.1858915-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NSKTn3QWwPNCuXuu519YWc9SCaIYBUgM
X-Proofpoint-GUID: NSKTn3QWwPNCuXuu519YWc9SCaIYBUgM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_02,2022-06-22_01
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
 man/io_uring_get_events.3            | 32 ++++++++++++++++++++++++++++
 man/io_uring_submit_and_get_events.3 | 31 +++++++++++++++++++++++++++
 src/include/liburing.h               |  3 +++
 src/liburing.map                     |  2 ++
 src/queue.c                          | 26 +++++++++++++++-------
 5 files changed, 86 insertions(+), 8 deletions(-)
 create mode 100644 man/io_uring_get_events.3
 create mode 100644 man/io_uring_submit_and_get_events.3

diff --git a/man/io_uring_get_events.3 b/man/io_uring_get_events.3
new file mode 100644
index 000000000000..2ac3e070473e
--- /dev/null
+++ b/man/io_uring_get_events.3
@@ -0,0 +1,32 @@
+.\" Copyright (C) 2022 Dylan Yudaken
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_get_events 3 "September 5, 2022" "liburing-2.3" "liburing M=
anual"
+.SH NAME
+io_uring_get_events \- Flush outstanding requests to CQE ring
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_get_events(struct io_uring *" ring ");"
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_get_events (3)
+function runs outstanding work and flushes completion events to the CQE =
ring.
+
+There can be events needing to be flushed if the ring was full and had o=
verflowed.
+Alternatively if the ring was setup with the
+.BR IORING_SETUP_DEFER_TASKRUN
+flag then this will process outstanding tasks, possibly resulting in mor=
e CQEs.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_get_events (3)
+returns 0. On failure it returns
+.BR -errno .
+.SH SEE ALSO
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit_and_get_events (3)
diff --git a/man/io_uring_submit_and_get_events.3 b/man/io_uring_submit_a=
nd_get_events.3
new file mode 100644
index 000000000000..9e143d1dff47
--- /dev/null
+++ b/man/io_uring_submit_and_get_events.3
@@ -0,0 +1,31 @@
+.\" Copyright (C), 2022  dylany
+.\" You may distribute this file under the terms of the GNU Free
+.\" Documentation License.
+.TH io_uring_submit_and_get_events 3 "September 5, 2022" "liburing-2.3" =
"liburing Manual"
+.SH NAME
+io_uring_submit_and_get_events \- submit requests to the submission queu=
e and flush completions
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_submit_and_get_events(struct io_uring *" ring ");"
+.fi
+
+.SH DESCRIPTION
+The
+.BR io_uring_submit_and_get_events (3)
+function submits the next events to the submission queue as with
+.BR io_uring_submit (3) .
+After submission it will flush CQEs as with
+.BR io_uring_get_events (3) .
+
+The benefit of this function is that it does both with only one system c=
all.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_submit_and_get_events (3)
+returns the number of submitted submission queue entries. On failure it =
returns
+.BR -errno .
+.SH SEE ALSO
+.BR io_uring_submit (3),
+.BR io_uring_get_events (3)
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 15e93f5bfb4e..765375cb5c6a 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -235,6 +235,9 @@ int io_uring_register_sync_cancel(struct io_uring *ri=
ng,
 int io_uring_register_file_alloc_range(struct io_uring *ring,
 					unsigned off, unsigned len);
=20
+int io_uring_get_events(struct io_uring *ring);
+int io_uring_submit_and_get_events(struct io_uring *ring);
+
 /*
  * io_uring syscalls.
  */
diff --git a/src/liburing.map b/src/liburing.map
index 8573dfc69cf9..5d08857ff906 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -66,4 +66,6 @@ LIBURING_2.3 {
 		io_uring_enter2;
 		io_uring_setup;
 		io_uring_register;
+		io_uring_get_events;
+		io_uring_submit_and_get_events;
 } LIBURING_2.2;
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

