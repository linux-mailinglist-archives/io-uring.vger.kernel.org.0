Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469AD561614
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiF3JSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiF3JSW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:18:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F2530568
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:12 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0LcSe009946
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=irR6SvpVZVmqNleVY//aMIwUIQ3Atk0PQieAabl6Uxg=;
 b=cihsG1edLd8eUXc7vD+ndkkYosOhHYC1u0oaqsRFqOO3j8t2CzqI8KO5YBHXnXgvr6qB
 NmHhryDWw5u3X/R5bt8zwEZ79dPNr5TITa4LasESKrbInXwhty+5v6ezrmXBPFrbH7mN
 ttU5rSpDaM66OjvXq+Ku8tqNClcnqPlivZ4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0tdsd116-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:12 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub102.TheFacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:11 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:11 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C1E0C259A054; Thu, 30 Jun 2022 02:14:23 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 liburing 4/7] add IORING_RECV_MULTISHOT docs
Date:   Thu, 30 Jun 2022 02:14:19 -0700
Message-ID: <20220630091422.1463570-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091422.1463570-1-dylany@fb.com>
References: <20220630091422.1463570-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YhpJ0m5Zaj5LPWiylp9gmMpaE34U1zmn
X-Proofpoint-GUID: YhpJ0m5Zaj5LPWiylp9gmMpaE34U1zmn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
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
 man/io_uring_prep_recv.3              | 22 ++++++++++++++++++++++
 man/io_uring_prep_recv_multishot.3    |  1 +
 man/io_uring_prep_recvmsg.3           | 20 ++++++++++++++++++++
 man/io_uring_prep_recvmsg_multishot.3 |  1 +
 4 files changed, 44 insertions(+)
 create mode 120000 man/io_uring_prep_recv_multishot.3
 create mode 120000 man/io_uring_prep_recvmsg_multishot.3

diff --git a/man/io_uring_prep_recv.3 b/man/io_uring_prep_recv.3
index 993e331..bcd3145 100644
--- a/man/io_uring_prep_recv.3
+++ b/man/io_uring_prep_recv.3
@@ -14,6 +14,12 @@ io_uring_prep_recv \- prepare a recv request
 .BI "                        void *" buf ","
 .BI "                        size_t " len ","
 .BI "                        int " flags ");"
+.PP
+.BI "void io_uring_prep_recv_multishot(struct io_uring_sqe *" sqe ","
+.BI "                                  int " sockfd ","
+.BI "                                  void *" buf ","
+.BI "                                  size_t " len ","
+.BI "                                  int " flags ");"
 .fi
 .SH DESCRIPTION
 .PP
@@ -36,6 +42,22 @@ This function prepares an async
 request. See that man page for details on the arguments specified to thi=
s
 prep helper.
=20
+The multishot version allows the application to issue a single receive r=
equest,
+which repeatedly posts a CQE when data is available. It requires length =
to be 0
+, the
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
+Multishot variants are available since kernel 5.20.
+
+
 After calling this function, additional io_uring internal modifier flags
 may be set in the SQE
 .I off
diff --git a/man/io_uring_prep_recv_multishot.3 b/man/io_uring_prep_recv_=
multishot.3
new file mode 120000
index 0000000..71fe277
--- /dev/null
+++ b/man/io_uring_prep_recv_multishot.3
@@ -0,0 +1 @@
+io_uring_prep_recv.3
\ No newline at end of file
diff --git a/man/io_uring_prep_recvmsg.3 b/man/io_uring_prep_recvmsg.3
index 8c49411..24c68ce 100644
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
@@ -37,6 +42,21 @@ This function prepares an async
 request. See that man page for details on the arguments specified to thi=
s
 prep helper.
=20
+The multishot version allows the application to issue a single receive r=
equest,
+which repeatedly posts a CQE when data is available. It requires length =
to be 0
+, the
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
+Multishot variants are available since kernel 5.20.
+
 After calling this function, additional io_uring internal modifier flags
 may be set in the SQE
 .I off
diff --git a/man/io_uring_prep_recvmsg_multishot.3 b/man/io_uring_prep_re=
cvmsg_multishot.3
new file mode 120000
index 0000000..cd9566f
--- /dev/null
+++ b/man/io_uring_prep_recvmsg_multishot.3
@@ -0,0 +1 @@
+io_uring_prep_recvmsg.3
\ No newline at end of file
--=20
2.30.2

