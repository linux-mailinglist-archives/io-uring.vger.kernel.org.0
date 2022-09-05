Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6604B5AD3DE
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiIEN1Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiIEN1W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:27:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E141848E8E
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:27:21 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 284MVFAh022261
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:27:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ii840Xnp00Mo5nDn8OqcgKZ9ucEMuml7pYD+plSRjno=;
 b=qXXPVDMIB2vjPvMxzcsb6i/I9BM4XW8K/zkgXM+xBCEoLn+rC2kznA2oKr/BwcQfjfwA
 aTuBxZQZy/Oqk2SK7gef4jJDFj8llq69+cD1MW3GqRqDcRRZ1M6OVfxaj8HX1hUEwEmk
 AfWQ7HtUn6KH88EmweIhTY28wZnUT27MIwg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jcgaeegwy-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:27:21 -0700
Received: from twshared3888.09.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:27:20 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 5166D5AC517B; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 09/11] expose CQ ring overflow state
Date:   Mon, 5 Sep 2022 06:22:56 -0700
Message-ID: <20220905132258.1858915-10-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: pfo8JoBye0edUtGZrl_eYtg9LLcS8DX_
X-Proofpoint-GUID: pfo8JoBye0edUtGZrl_eYtg9LLcS8DX_
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

Allow the application to easily view if the CQ ring is in overflow state =
in
case it would like to explicitly flush using io_uring_get_events.

Explicit flushing can be useful for applications that prefer to have
reduced latency on CQs than to process as many as possible.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_cq_has_overflow.3 | 25 +++++++++++++++++++++++++
 man/io_uring_get_events.3      |  3 ++-
 src/include/liburing.h         |  9 +++++++++
 3 files changed, 36 insertions(+), 1 deletion(-)
 create mode 100644 man/io_uring_cq_has_overflow.3

diff --git a/man/io_uring_cq_has_overflow.3 b/man/io_uring_cq_has_overflo=
w.3
new file mode 100644
index 000000000000..e5b352a4f86a
--- /dev/null
+++ b/man/io_uring_cq_has_overflow.3
@@ -0,0 +1,25 @@
+.\" Copyright (C) 2022 Dylan Yudaken <dylany@fb.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_cq_has_overflow 3 "September 5, 2022" "liburing-2.3" "libur=
ing Manual"
+.SH NAME
+io_uring_cq_has_overflow \- returns if there are overflow entries waitin=
g to move to the CQ ring
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "bool io_uring_cq_has_overflow(const struct io_uring *" ring ");"
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_cq_has_overflow (3)
+function informs the application if CQ entries have overflowed and are w=
aiting to be flushed to
+the CQ ring. For example using
+.BR io_uring_get_events (3)
+.
+.SH RETURN VALUE
+True if there are CQ entries waiting to be flushed to the CQ ring.
+.SH SEE ALSO
+.BR io_uring_get_events (3)
diff --git a/man/io_uring_get_events.3 b/man/io_uring_get_events.3
index 2ac3e070473e..f2415423953c 100644
--- a/man/io_uring_get_events.3
+++ b/man/io_uring_get_events.3
@@ -29,4 +29,5 @@ returns 0. On failure it returns
 .BR -errno .
 .SH SEE ALSO
 .BR io_uring_get_sqe (3),
-.BR io_uring_submit_and_get_events (3)
+.BR io_uring_submit_and_get_events (3),
+.BR io_uring_cq_has_overflow (3)
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 765375cb5c6a..ae25e2199264 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1098,6 +1098,15 @@ static inline unsigned io_uring_cq_ready(const str=
uct io_uring *ring)
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
--=20
2.30.2

