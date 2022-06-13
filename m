Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229D6549A50
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 19:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbiFMRoJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 13:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242514AbiFMRmU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 13:42:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20149674F7
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:31 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25D1c2hi004996
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1NhJdfddzkg0aEJBzsN0i2MMU4fyQbPWOLEMQ7xo/Cc=;
 b=Z4e9S0rExPJwCIMn563ZrWA4tS0k8zCPsLQejipy9s3+q33Com9g1ydPTAVrFsHznX6z
 gt7VCCNSMrsFutp+0sYkMjlqEDt44hvWbm4YPijNYVplTgjtxY3FnJyTJcyP8yag/dd6
 tYuahcBYfwKnJ7C9Gw0Qsw/XsHIk2FIJTiw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gmpj88eew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:04 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 13 Jun 2022 06:13:03 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 6388719A7608; Mon, 13 Jun 2022 06:12:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 3/4] add io_uring_buf_ring_init
Date:   Mon, 13 Jun 2022 06:12:52 -0700
Message-ID: <20220613131253.974205-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220613131253.974205-1-dylany@fb.com>
References: <20220613131253.974205-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 152RaOOOIlUMQHZmFij-k3rZwHKZiT6R
X-Proofpoint-ORIG-GUID: 152RaOOOIlUMQHZmFij-k3rZwHKZiT6R
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

Kernel expects the tail to start at 0, so provide an API to init the
ring appropriately.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_buf_ring_init.3     | 30 ++++++++++++++++++++++++++++++
 man/io_uring_register_buf_ring.3 |  5 ++++-
 src/include/liburing.h           |  5 +++++
 test/send_recvmsg.c              |  1 +
 4 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100644 man/io_uring_buf_ring_init.3

diff --git a/man/io_uring_buf_ring_init.3 b/man/io_uring_buf_ring_init.3
new file mode 100644
index 0000000..50cf69a
--- /dev/null
+++ b/man/io_uring_buf_ring_init.3
@@ -0,0 +1,30 @@
+.\" Copyright (C) 2022 Dylan Yudaken <dylany@fb.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_buf_ring_init 3 "June 13, 2022" "liburing-2.2" "liburing Ma=
nual"
+.SH NAME
+io_uring_buf_ring_init \- Initialise a  buffer ring
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_buf_ring_init(struct io_uring_buf_ring *" br ");"
+.fi
+.SH DESCRIPTION
+.PP
+.BR io_uring_buf_ring_init (3)
+initialises
+.IR br
+so that it is ready to be used. It may be called after
+.BR io_uring_register_buf_ring (3)
+but must be called before the buffer ring is used in any other way.
+
+.SH RETURN VALUE
+None
+
+.SH SEE ALSO
+.BR io_uring_register_buf_ring (3),
+.BR io_uring_buf_ring_add (3)
+.BR io_uring_buf_ring_advance (3),
+.BR io_uring_buf_ring_cq_advance (3)
diff --git a/man/io_uring_register_buf_ring.3 b/man/io_uring_register_buf=
_ring.3
index 9e0b53d..9e520bf 100644
--- a/man/io_uring_register_buf_ring.3
+++ b/man/io_uring_register_buf_ring.3
@@ -115,7 +115,9 @@ is the length of the buffer in bytes, and
 .I bid
 is the buffer ID that will be returned in the CQE once consumed.
=20
-Reserved fields must not be touched. Applications may use
+Reserved fields must not be touched. Applications must use
+.BR io_uring_buf_ring_init (3)
+to initialise the buffer ring. Applications may use
 .BR io_uring_buf_ring_add (3)
 and
 .BR io_uring_buf_ring_advance (3)
@@ -131,6 +133,7 @@ On success
 returns 0. On failure it returns
 .BR -errno .
 .SH SEE ALSO
+.BR io_uring_buf_ring_init (3),
 .BR io_uring_buf_ring_add (3),
 .BR io_uring_buf_ring_advance (3),
 .BR io_uring_buf_ring_cq_advance (3)
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 9beef0b..c31ece2 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1097,6 +1097,11 @@ static inline int io_uring_buf_ring_mask(__u32 rin=
g_entries)
 	return ring_entries - 1;
 }
=20
+static inline void io_uring_buf_ring_init(struct io_uring_buf_ring *br)
+{
+	br->tail =3D 0;
+}
+
 /*
  * Assign 'buf' with the addr/len/buffer ID supplied
  */
diff --git a/test/send_recvmsg.c b/test/send_recvmsg.c
index 6f18bae..cce6c45 100644
--- a/test/send_recvmsg.c
+++ b/test/send_recvmsg.c
@@ -199,6 +199,7 @@ static void *recv_fn(void *data)
 			}
=20
 			br =3D ptr;
+			io_uring_buf_ring_init(br);
 			io_uring_buf_ring_add(br, buf, sizeof(buf), BUF_BID,
 					      io_uring_buf_ring_mask(1), 0);
 			io_uring_buf_ring_advance(br, 1);
--=20
2.30.2

