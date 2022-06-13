Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4B7549157
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 18:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242065AbiFMPlQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 11:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351968AbiFMPjL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 11:39:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ACF15894C
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:35 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25CNZ3m9013775
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=cN7Di7G0t4/Y7+kSBh1jAsEx7pU/D5JRlNMXVfvFfcs=;
 b=qp3pkKRykBoSlCCAzzZwOkelDecPWlxE9EO3x4Xu0xnqJbdPn/vr17kBQcrbOup0HcOm
 iaol5XvYYMAMiVqnhwk1z5Q/qY32tdOH7aWyq72+9TYRNuByFlmLg0vTg9xibvR0pnl1
 HtShhEkJ9HkZxohi0JXXTfpL2zJX1r8h0vo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmq3kgeej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:12 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 13 Jun 2022 06:13:11 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 5963C19A7606; Mon, 13 Jun 2022 06:12:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 2/4] add mask parameter to io_uring_buf_ring_add
Date:   Mon, 13 Jun 2022 06:12:51 -0700
Message-ID: <20220613131253.974205-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220613131253.974205-1-dylany@fb.com>
References: <20220613131253.974205-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: tPbLNjIaBF4LkbIIJPZYlTxLWg2dUXuB
X-Proofpoint-ORIG-GUID: tPbLNjIaBF4LkbIIJPZYlTxLWg2dUXuB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_05,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Without the mask parameter, it's not feasible to use this API without
knowing where the tail is and performing some arithmetic

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_buf_ring_add.3  |  5 +++++
 man/io_uring_buf_ring_mask.3 | 27 +++++++++++++++++++++++++++
 src/include/liburing.h       | 13 +++++++++++--
 test/send_recvmsg.c          |  3 ++-
 4 files changed, 45 insertions(+), 3 deletions(-)
 create mode 100644 man/io_uring_buf_ring_mask.3

diff --git a/man/io_uring_buf_ring_add.3 b/man/io_uring_buf_ring_add.3
index 741cba6..9d8283b 100644
--- a/man/io_uring_buf_ring_add.3
+++ b/man/io_uring_buf_ring_add.3
@@ -13,6 +13,7 @@ io_uring_buf_ring_add \- add buffers to a shared buffer=
 ring
 .BI "                          void *" addr ",
 .BI "                          unsigned int " len ",
 .BI "                          unsigned short " bid ",
+.BI "                          int " mask ",
 .BI "                          int " buf_offset ");"
 .fi
 .SH DESCRIPTION
@@ -28,6 +29,9 @@ and is of
 bytes of length.
 .I bid
 is the buffer ID, which will be returned in the CQE.
+.I mask
+is the size mask of the ring, available from
+.BR io_uring_buf_ring_mask (3) .
 .I buf_offset
 is the offset to insert at from the current tail. If just one buffer is =
provided
 before the ring tail is committed with
@@ -44,5 +48,6 @@ must be incremented by one for each buffer added.
 None
 .SH SEE ALSO
 .BR io_uring_register_buf_ring (3),
+.BR io_uring_buf_ring_mask (3),
 .BR io_uring_buf_ring_advance (3),
 .BR io_uring_buf_ring_cq_advance (3)
diff --git a/man/io_uring_buf_ring_mask.3 b/man/io_uring_buf_ring_mask.3
new file mode 100644
index 0000000..9160663
--- /dev/null
+++ b/man/io_uring_buf_ring_mask.3
@@ -0,0 +1,27 @@
+.\" Copyright (C) 2022 Dylan Yudaken <dylany@fb.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_buf_ring_mask 3 "June 13, 2022" "liburing-2.2" "liburing Ma=
nual"
+.SH NAME
+io_uring_buf_ring_mask \- Calculate buffer ring mask size
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_buf_ring_mask(__u32 " ring_entries ");"
+.fi
+.SH DESCRIPTION
+.PP
+.BR io_uring_buf_ring_mask (3)
+calculates the appropriate size mask for a buffer ring.
+.IR ring_entries
+is the ring entries as specified in
+.BR io_uring_register_buf_ring (3) .
+
+.SH RETURN VALUE
+Size mask for the buffer ring.
+
+.SH SEE ALSO
+.BR io_uring_register_buf_ring (3),
+.BR io_uring_buf_ring_add (3)
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 6eece30..9beef0b 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1089,14 +1089,23 @@ static inline struct io_uring_sqe *_io_uring_get_=
sqe(struct io_uring *ring)
 	return NULL;
 }
=20
+/*
+ * Return the appropriate mask for a buffer ring of size 'ring_entries'
+ */
+static inline int io_uring_buf_ring_mask(__u32 ring_entries)
+{
+	return ring_entries - 1;
+}
+
 /*
  * Assign 'buf' with the addr/len/buffer ID supplied
  */
 static inline void io_uring_buf_ring_add(struct io_uring_buf_ring *br,
 					 void *addr, unsigned int len,
-					 unsigned short bid, int buf_offset)
+					 unsigned short bid, int mask,
+					 int buf_offset)
 {
-	struct io_uring_buf *buf =3D &br->bufs[br->tail + buf_offset];
+	struct io_uring_buf *buf =3D &br->bufs[(br->tail + buf_offset) & mask];
=20
 	buf->addr =3D (unsigned long) (uintptr_t) addr;
 	buf->len =3D len;
diff --git a/test/send_recvmsg.c b/test/send_recvmsg.c
index 44a01b0..6f18bae 100644
--- a/test/send_recvmsg.c
+++ b/test/send_recvmsg.c
@@ -199,7 +199,8 @@ static void *recv_fn(void *data)
 			}
=20
 			br =3D ptr;
-			io_uring_buf_ring_add(br, buf, sizeof(buf), BUF_BID, 0);
+			io_uring_buf_ring_add(br, buf, sizeof(buf), BUF_BID,
+					      io_uring_buf_ring_mask(1), 0);
 			io_uring_buf_ring_advance(br, 1);
 		} else {
 			struct io_uring_sqe *sqe;
--=20
2.30.2

