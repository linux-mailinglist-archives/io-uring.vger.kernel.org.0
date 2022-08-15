Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCD9592FBF
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiHONVY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiHONVX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:21:23 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57343167D8
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:22 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27EMGK74029646
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=k9ci0eMEfBDIeBu6pA0QpnCc7qgjYYbmfDDJ3sQDK7Y=;
 b=XrEAgMCJrRCSSqUexqXBrrtq3Hqgc2/fV1DUKN6VGHQIx+TPBgNL5iPiJjn2N2reRDyj
 98rprynbQzsb2nPEZuxDAhVa1rcRRJ4jS5j+CPgnAPum17dkWlAloSWtYF+TySna/Nql
 RqGvWLtAnUjsWOz2o6mKpQQIdTIcvgr97As= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hx9pyj4qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:21 -0700
Received: from twshared6324.05.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:21:20 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 351BA49B72F3; Mon, 15 Aug 2022 06:09:55 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 06/11] fix documentation shortenings
Date:   Mon, 15 Aug 2022 06:09:42 -0700
Message-ID: <20220815130947.1002152-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130947.1002152-1-dylany@fb.com>
References: <20220815130947.1002152-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: caZn3aXJupqHv1MfHFO_Ee-ogKd62Syk
X-Proofpoint-ORIG-GUID: caZn3aXJupqHv1MfHFO_Ee-ogKd62Syk
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

'parm' probably was intended to be param, but parameter is more explicit,
so change it.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_wait_cqe.3         | 2 +-
 man/io_uring_wait_cqe_nr.3      | 2 +-
 man/io_uring_wait_cqe_timeout.3 | 2 +-
 man/io_uring_wait_cqes.3        | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/man/io_uring_wait_cqe.3 b/man/io_uring_wait_cqe.3
index c115f6fc3c59..d1d0c8d6c513 100644
--- a/man/io_uring_wait_cqe.3
+++ b/man/io_uring_wait_cqe.3
@@ -31,7 +31,7 @@ the application can retrieve the completion with
 .SH RETURN VALUE
 On success
 .BR io_uring_wait_cqe (3)
-returns 0 and the cqe_ptr parm is filled in. On failure it returns
+returns 0 and the cqe_ptr parameter is filled in. On failure it returns
 .BR -errno .
 The return value indicates the result of waiting for a CQE, and it has n=
o
 relation to the CQE result itself.
diff --git a/man/io_uring_wait_cqe_nr.3 b/man/io_uring_wait_cqe_nr.3
index 5a4a5d587250..7b7c598d9e8e 100644
--- a/man/io_uring_wait_cqe_nr.3
+++ b/man/io_uring_wait_cqe_nr.3
@@ -34,7 +34,7 @@ the application can retrieve the completion with
 .SH RETURN VALUE
 On success
 .BR io_uring_wait_cqe_nr (3)
-returns 0 and the cqe_ptr parm is filled in. On failure it returns
+returns 0 and the cqe_ptr parameter is filled in. On failure it returns
 .BR -errno .
 The return value indicates the result of waiting for a CQE, and it has n=
o
 relation to the CQE result itself.
diff --git a/man/io_uring_wait_cqe_timeout.3 b/man/io_uring_wait_cqe_time=
out.3
index 965fc3254ac9..3d5cf3c06fd5 100644
--- a/man/io_uring_wait_cqe_timeout.3
+++ b/man/io_uring_wait_cqe_timeout.3
@@ -43,7 +43,7 @@ when waiting for a request.
 .SH RETURN VALUE
 On success
 .BR io_uring_wait_cqes (3)
-returns 0 and the cqe_ptr parm is filled in. On failure it returns
+returns 0 and the cqe_ptr parameter is filled in. On failure it returns
 .BR -errno .
 The return value indicates the result of waiting for a CQE, and it has n=
o
 relation to the CQE result itself.
diff --git a/man/io_uring_wait_cqes.3 b/man/io_uring_wait_cqes.3
index b771ebe44331..6ec6ec2c3757 100644
--- a/man/io_uring_wait_cqes.3
+++ b/man/io_uring_wait_cqes.3
@@ -48,7 +48,7 @@ when waiting for a request.
 .SH RETURN VALUE
 On success
 .BR io_uring_wait_cqes (3)
-returns 0 and the cqe_ptr parm is filled in. On failure it returns
+returns 0 and the cqe_ptr parameter is filled in. On failure it returns
 .BR -errno .
 .SH SEE ALSO
 .BR io_uring_submit (3),
--=20
2.30.2

