Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36235812F1
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 14:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiGZMPf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 08:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbiGZMPe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 08:15:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429562E9F2
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:31 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q0rSab010441
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=821pu2G9kGNqXC97bqubOwgp5SaO+E5RJACeXsN0nqE=;
 b=E8Touh3rP4DWL6DGIJaIvnQmbrvSe04aK6C+QZPj8FdWLfU2Tl1rApRMQwFpX0fmbiv9
 W4l5udUbNgUwdlimBACPwphFXXx3Go5mACw80FAChN+bW+XlP4FPr2wSrrAxMnsTpyEQ
 UndfuTMG13+5lDoMKLXWWa6skqle85TklIQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hhxbwny67-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:30 -0700
Received: from twshared1866.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 05:15:28 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 249AE397A792; Tue, 26 Jul 2022 05:15:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 4/5] add documentation for multishot recvmsg
Date:   Tue, 26 Jul 2022 05:15:01 -0700
Message-ID: <20220726121502.1958288-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220726121502.1958288-1-dylany@fb.com>
References: <20220726121502.1958288-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: a37C6OhJs51ZBoBJIBTWeozqxFoT2_c7
X-Proofpoint-ORIG-GUID: a37C6OhJs51ZBoBJIBTWeozqxFoT2_c7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add missing documentation for new multishot recvmsg API

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_prep_recvmsg.3           | 30 +++++++++++
 man/io_uring_prep_recvmsg_multishot.3 |  1 +
 man/io_uring_recvmsg_cmsg_firsthdr.3  |  1 +
 man/io_uring_recvmsg_cmsg_nexthdr.3   |  1 +
 man/io_uring_recvmsg_name.3           |  1 +
 man/io_uring_recvmsg_out.3            | 78 +++++++++++++++++++++++++++
 man/io_uring_recvmsg_payload.3        |  1 +
 man/io_uring_recvmsg_payload_length.3 |  1 +
 man/io_uring_recvmsg_validate.3       |  1 +
 9 files changed, 115 insertions(+)
 create mode 120000 man/io_uring_prep_recvmsg_multishot.3
 create mode 120000 man/io_uring_recvmsg_cmsg_firsthdr.3
 create mode 120000 man/io_uring_recvmsg_cmsg_nexthdr.3
 create mode 120000 man/io_uring_recvmsg_name.3
 create mode 100644 man/io_uring_recvmsg_out.3
 create mode 120000 man/io_uring_recvmsg_payload.3
 create mode 120000 man/io_uring_recvmsg_payload_length.3
 create mode 120000 man/io_uring_recvmsg_validate.3

diff --git a/man/io_uring_prep_recvmsg.3 b/man/io_uring_prep_recvmsg.3
index f64326be0a99..07096ee4826c 100644
--- a/man/io_uring_prep_recvmsg.3
+++ b/man/io_uring_prep_recvmsg.3
@@ -15,6 +15,11 @@ io_uring_prep_recvmsg \- prepare a recvmsg request
 .BI "                           int " fd ","
 .BI "                           struct msghdr *" msg ","
 .BI "                           unsigned " flags ");"
+.PP
+.BI "void io_uring_prep_recvmsg_multishot(struct io_uring_sqe *" sqe ","
+.BI "                                     int " fd ","
+.BI "                                     struct msghdr *" msg ","
+.BI "                                     unsigned " flags ");"
 .fi
 .SH DESCRIPTION
 .PP
@@ -37,6 +42,31 @@ This function prepares an async
 request. See that man page for details on the arguments specified to thi=
s
 prep helper.
=20
+The multishot version allows the application to issue a single receive r=
equest,
+which repeatedly posts a CQE when data is available. It requires the
+.B IOSQE_BUFFER_SELECT
+flag to be set and no
+.B MSG_WAITALL
+flag to be set.
+Therefore each CQE will take a buffer out of a provided buffer pool for =
receiving.
+The application should check the flags of each CQE, regardless of it's r=
esult.
+If a posted CQE does not have the
+.B IORING_CQE_F_MORE
+flag set then the multishot receive will be done and the application sho=
uld issue a
+new request.
+
+Unlike
+.BR recvmsg (2)
+, multishot recvmsg will prepend a
+.I struct io_uring_recvmsg_out
+which describes the layout of the rest of the buffer in combination with=
 the initial
+.I struct msghdr
+submitted with the request. See
+.B io_uring_recvmsg_out (3)
+for more information on accessing the data.
+
+Multishot variants are available since kernel 5.20.
+
 After calling this function, additional io_uring internal modifier flags
 may be set in the SQE
 .I ioprio
diff --git a/man/io_uring_prep_recvmsg_multishot.3 b/man/io_uring_prep_re=
cvmsg_multishot.3
new file mode 120000
index 000000000000..cd9566f2c2be
--- /dev/null
+++ b/man/io_uring_prep_recvmsg_multishot.3
@@ -0,0 +1 @@
+io_uring_prep_recvmsg.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_cmsg_firsthdr.3 b/man/io_uring_recvmsg_=
cmsg_firsthdr.3
new file mode 120000
index 000000000000..8eb17436288d
--- /dev/null
+++ b/man/io_uring_recvmsg_cmsg_firsthdr.3
@@ -0,0 +1 @@
+io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_cmsg_nexthdr.3 b/man/io_uring_recvmsg_c=
msg_nexthdr.3
new file mode 120000
index 000000000000..8eb17436288d
--- /dev/null
+++ b/man/io_uring_recvmsg_cmsg_nexthdr.3
@@ -0,0 +1 @@
+io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_name.3 b/man/io_uring_recvmsg_name.3
new file mode 120000
index 000000000000..8eb17436288d
--- /dev/null
+++ b/man/io_uring_recvmsg_name.3
@@ -0,0 +1 @@
+io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_out.3 b/man/io_uring_recvmsg_out.3
new file mode 100644
index 000000000000..60f92619d566
--- /dev/null
+++ b/man/io_uring_recvmsg_out.3
@@ -0,0 +1,78 @@
+.\" Copyright (C), 2022  Dylan Yudaken <dylany@fb.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_recvmsg_out 3 "Julyu 26, 2022" "liburing-2.2" "liburing Man=
ual"
+.SH NAME
+io_uring_recvmsg_out - access data from multishot recvmsg
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "struct io_uring_recvmsg_out *io_uring_recvmsg_validate(void *" buf =
","
+.BI "                                                       int " buf_le=
n ","
+.BI "                                                       struct msghd=
r *" msgh ");"
+.PP
+.BI "void *io_uring_recvmsg_name(struct io_uring_recvmsg_out *" o ");"
+.PP
+.BI "struct cmsghdr *io_uring_recvmsg_cmsg_firsthdr(struct io_uring_recv=
msg_out * " o ","
+.BI "                                                struct msghdr *" ms=
gh ");"
+.BI "struct cmsghdr *io_uring_recvmsg_cmsg_nexthdr(struct io_uring_recvm=
sg_out * " o ","
+.BI "                                              struct msghdr *" msgh=
 ","
+.BI "                                              struct cmsghdr *" cms=
g ");"
+.PP
+.BI "void *io_uring_recvmsg_payload(struct io_uring_recvmsg_out * " o ",=
"
+.BI "                               struct msghdr *" msgh ");"
+.BI "unsigned int io_uring_recvmsg_payload_length(struct io_uring_recvms=
g_out *" o ","
+.BI "                                             int " buf_len ","
+.BI "                                             struct msghdr *" msgh =
");"
+.PP
+.fi
+
+.SH DESCRIPTION
+
+These functions are used to access data in the payload delivered by
+.BR io_uring_prep_recv_multishot (3)
+.
+.PP
+.BR io_uring_recvmsg_validate (3)
+will validate a buffer delivered by
+.BR io_uring_prep_recv_multishot (3)
+and extract the
+.I io_uring_recvmsg_out
+if it is valid, returning a pointer to it or else NULL.
+.PP
+The structure is defined as follows:
+.PP
+.in +4n
+.EX
+
+struct io_uring_recvmsg_out {
+        __u32 namelen;    /* Name byte count as would have been populate=
d
+                           * by recvmsg(2) */
+        __u32 controllen; /* Control byte count */
+        __u32 payloadlen; /* Payload byte count as would have been retur=
ned
+                           * by recvmsg(2) */
+        __u32 flags;      /* Flags result as would have been populated
+                           * by recvmsg(2) */
+};
+
+.IP * 3
+.BR io_uring_recvmsg_name (3)
+returns a pointer to the name in the buffer.
+.IP *
+.BR io_uring_recvmsg_cmsg_firsthdr (3)
+returns a pointer to the first cmsg in the buffer, or NULL.
+.IP *
+.BR io_uring_recvmsg_cmsg_nexthdr (3)
+returns a pointer to the next cmsg in the buffer, or NULL.
+.IP *
+.BR io_uring_recvmsg_payload (3)
+returns a pointer to the payload in the buffer.
+.IP *
+.BR io_uring_recvmsg_payload_length (3)
+Calculates the usable payload length in bytes.
+
+
+.SH "SEE ALSO"
+.BR io_uring_prep_recv_multishot (3)
diff --git a/man/io_uring_recvmsg_payload.3 b/man/io_uring_recvmsg_payloa=
d.3
new file mode 120000
index 000000000000..8eb17436288d
--- /dev/null
+++ b/man/io_uring_recvmsg_payload.3
@@ -0,0 +1 @@
+io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_payload_length.3 b/man/io_uring_recvmsg=
_payload_length.3
new file mode 120000
index 000000000000..8eb17436288d
--- /dev/null
+++ b/man/io_uring_recvmsg_payload_length.3
@@ -0,0 +1 @@
+io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_validate.3 b/man/io_uring_recvmsg_valid=
ate.3
new file mode 120000
index 000000000000..8eb17436288d
--- /dev/null
+++ b/man/io_uring_recvmsg_validate.3
@@ -0,0 +1 @@
+io_uring_recvmsg_out.3
\ No newline at end of file
--=20
2.30.2

