Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F98509BFD
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387523AbiDUJVE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387545AbiDUJVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:21:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A84227170
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:05 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23L7Wr5x001897
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HWfLFZ8M+yXaDWcZkFYOBinhw78LZdwWUIhw/Hk60WM=;
 b=TR0AOzCkQGSLzxhR43y8NbzeRafThQdDFcMX7SZJabfEikN5xGrD1tUDRK4tgT5vdntY
 71tu+w6zwl0i5OfgSN6gCxWCJk5wgOYasGTxbnmmplyuHaDOu3DVqQYFE4PNUmy79QSe
 5/TiKYarax2RrVAgHvDC5iMCCHKsDRHE9n8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhub7eq7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:04 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:18:03 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id D647F7CA7717; Thu, 21 Apr 2022 02:14:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 1/5] fix documentation shortenings
Date:   Thu, 21 Apr 2022 02:14:23 -0700
Message-ID: <20220421091427.2118151-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091427.2118151-1-dylany@fb.com>
References: <20220421091427.2118151-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: rUc_BMTCRmXQRAONLBex4uh9Agsi5djf
X-Proofpoint-ORIG-GUID: rUc_BMTCRmXQRAONLBex4uh9Agsi5djf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 1190d9b..676c4bc 100644
--- a/man/io_uring_wait_cqe.3
+++ b/man/io_uring_wait_cqe.3
@@ -30,6 +30,6 @@ the application can retrieve the completion with
 .SH RETURN VALUE
 On success
 .BR io_uring_wait_cqe (3)
-returns 0 and the cqe_ptr parm is filled in. On failure it returns -errn=
o.
+returns 0 and the cqe_ptr parameter is filled in. On failure it returns =
-errno.
 .SH SEE ALSO
 .BR io_uring_submit (3),  io_uring_wait_cqes(3)
diff --git a/man/io_uring_wait_cqe_nr.3 b/man/io_uring_wait_cqe_nr.3
index 3594b0b..7d4a56f 100644
--- a/man/io_uring_wait_cqe_nr.3
+++ b/man/io_uring_wait_cqe_nr.3
@@ -33,6 +33,6 @@ the application can retrieve the completion with
 .SH RETURN VALUE
 On success
 .BR io_uring_wait_cqe_nr (3)
-returns 0 and the cqe_ptr parm is filled in. On failure it returns -errn=
o.
+returns 0 and the cqe_ptr parameter is filled in. On failure it returns =
-errno.
 .SH SEE ALSO
 .BR io_uring_submit (3),  io_uring_wait_cqes (3)
diff --git a/man/io_uring_wait_cqe_timeout.3 b/man/io_uring_wait_cqe_time=
out.3
index 64e920b..f535433 100644
--- a/man/io_uring_wait_cqe_timeout.3
+++ b/man/io_uring_wait_cqe_timeout.3
@@ -34,6 +34,6 @@ calling io_uring_wait_cqes (3).
 .SH RETURN VALUE
 On success
 .BR io_uring_wait_cqes (3)
-returns 0 and the cqe_ptr parm is filled in. On failure it returns -errn=
o.
+returns 0 and the cqe_ptr parameter is filled in. On failure it returns =
-errno.
 .SH SEE ALSO
 .BR io_uring_submit (3),  io_uring_wait_cqe_timeout (3), io_uring_wait_c=
qe(3).
diff --git a/man/io_uring_wait_cqes.3 b/man/io_uring_wait_cqes.3
index a9a4a0c..2010a7b 100644
--- a/man/io_uring_wait_cqes.3
+++ b/man/io_uring_wait_cqes.3
@@ -41,6 +41,6 @@ calling io_uring_wait_cqes (3).
 .SH RETURN VALUE
 On success
 .BR io_uring_wait_cqes (3)
-returns 0 and the cqe_ptr parm is filled in. On failure it returns -errn=
o.
+returns 0 and the cqe_ptr parameter is filled in. On failure it returns =
-errno.
 .SH SEE ALSO
 .BR io_uring_submit (3),  io_uring_wait_cqe_timeout (3), io_uring_wait_c=
qe(3).
--=20
2.30.2

