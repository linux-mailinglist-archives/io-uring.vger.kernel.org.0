Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7072B55E6B1
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346939AbiF1PE2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346420AbiF1PE1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:04:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3112B1D301
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:27 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25SAAOQ2003859
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8Zq7TPZKc2rvmmmyQR5vr3oisDAOQmxH+0ESBN1iBbc=;
 b=Fhsj9C0L3qXs+h3mxeR6O9FE/D2LMEWnowcPXmiVr8bgliBB9G1sFQya5X24l+Fdd9Tn
 HXFSTCSjxxbgXWfHd0X1ijvU517+uEgtmm0NzgV273Mxgv6KfxXRlQ+HcavRbN/p+y0m
 rtYuCSpiqxTjhZcdy2LXLBp2dMxhK8eFTuk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gywp2adku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:26 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:04:24 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C659C244BD5B; Tue, 28 Jun 2022 08:04:18 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 4/4] add IORING_RECV_MULTISHOT docs
Date:   Tue, 28 Jun 2022 08:04:14 -0700
Message-ID: <20220628150414.1386435-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628150414.1386435-1-dylany@fb.com>
References: <20220628150414.1386435-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: q-Nj-DRe5frUqJeMNUvz1iup8Neenh5F
X-Proofpoint-GUID: q-Nj-DRe5frUqJeMNUvz1iup8Neenh5F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add appropriate docs to io_uring_prep_recvmsg/io_uring_prep_recv man page=
s

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_prep_recv.3    | 15 +++++++++++++++
 man/io_uring_prep_recvmsg.3 | 15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/man/io_uring_prep_recv.3 b/man/io_uring_prep_recv.3
index 993e331..f929ec8 100644
--- a/man/io_uring_prep_recv.3
+++ b/man/io_uring_prep_recv.3
@@ -60,6 +60,21 @@ operation. If set, the socket still had data to be rea=
d after the operation
 completed. Both these flags are available since 5.19.
 .P
=20
+.TP
+.B IORING_RECV_MULTISHOT
+If set, io_uring will post a new CQE whenever data is available to read.
+The CQE will try and fill a provided buffer.
+The
+.B IORING_CQE_F_MORE
+flag will be set if the receive is still active and more CQEs will be po=
sted.
+
+It is required that the
+.B IOSQE_BUFFER_SELECT
+flag is set and that
+.B MSG_WAITALL
+is not set.
+.P
+
 .SH RETURN VALUE
 None
 .SH ERRORS
diff --git a/man/io_uring_prep_recvmsg.3 b/man/io_uring_prep_recvmsg.3
index 8c49411..74bfbc8 100644
--- a/man/io_uring_prep_recvmsg.3
+++ b/man/io_uring_prep_recvmsg.3
@@ -61,6 +61,21 @@ operation. If set, the socket still had data to be rea=
d after the operation
 completed. Both these flags are available since 5.19.
 .P
=20
+.TP
+.B IORING_RECV_MULTISHOT
+If set, io_uring will post a new CQE whenever data is available to read.
+The CQE will try and fill a provided buffer.
+The
+.B IORING_CQE_F_MORE
+flag will be set if the receive is still active and more CQEs will be po=
sted.
+
+It is required that the
+.B IOSQE_BUFFER_SELECT
+flag is set and that
+.B MSG_WAITALL
+is not set.
+.P
+
 .SH RETURN VALUE
 None
 .SH ERRORS
--=20
2.30.2

