Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F73509C19
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387533AbiDUJVA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387498AbiDUJUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:20:51 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D6725C50
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:02 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23L8YGac001004
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dpD9FHtQD3nrZ59IB47xv/oFqNDxosTOjrs20MindVw=;
 b=rJXS1kAyy43goa3N5dwxm2vMGrXhJaI69tm5v19VtcVQnHCilWHqhlpzQnu3uOwu1TCJ
 vjVHd3QtVDJTCZMY2QbszKTFjwNwdmX8MHy4EHK735jlewI5o9vCCguNQmj4b0ARH6ZQ
 9dYnZgJkdlrtQRgP+Xoh92uOBFfTEsrH57Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj36tb6vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:01 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:18:00 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id EB3337CA7722; Thu, 21 Apr 2022 02:14:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 4/5] add docs for overflow lost errors
Date:   Thu, 21 Apr 2022 02:14:26 -0700
Message-ID: <20220421091427.2118151-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091427.2118151-1-dylany@fb.com>
References: <20220421091427.2118151-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 3XHS_SEo_biM2awDUqLe11zyTQYiUBnd
X-Proofpoint-ORIG-GUID: 3XHS_SEo_biM2awDUqLe11zyTQYiUBnd
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

Add man docs for return values indicating a CQE was lost.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_enter.2 | 11 +++++++++++
 man/io_uring_setup.2 | 11 +++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 3112355..15ef9d1 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1326,6 +1326,17 @@ is a valid file descriptor, but the io_uring ring =
is not in the right state
 .BR io_uring_register (2)
 for details on how to enable the ring.
 .TP
+.B EBADR
+At least one CQE was dropped even with the
+.B IORING_FEAT_NODROP
+feature, and there are no otherwise available CQEs. This clears the erro=
r state
+and so with no other changes the next call to
+.BR io_uring_setup (2)
+will not have this error. This error should be extremely rare and indica=
tes the
+machine is running critically low on memory and. It may be reasonable fo=
r the
+application to terminate running unless it is able to safely handle any =
CQE
+being lost.
+.TP
 .B EBUSY
 If the
 .B IORING_FEAT_NODROP
diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index f3911af..2f617c1 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -218,7 +218,7 @@ call. The SQEs must still be allocated separately. Th=
is brings the necessary
 calls down from three to two. Available since kernel 5.4.
 .TP
 .B IORING_FEAT_NODROP
-If this flag is set, io_uring supports never dropping completion events.
+If this flag is set, io_uring supports almost never dropping completion =
events.
 If a completion event occurs and the CQ ring is full, the kernel stores
 the event internally until such a time that the CQ ring has room for mor=
e
 entries. If this overflow condition is entered, attempting to submit mor=
e
@@ -226,7 +226,14 @@ IO will fail with the
 .B -EBUSY
 error value, if it can't flush the overflown events to the CQ ring. If t=
his
 happens, the application must reap events from the CQ ring and attempt t=
he
-submit again. Available since kernel 5.5.
+submit again. If the kernel has no free memory to store the event intern=
ally
+it will be visible by an increase in the overflow value on the cqring.
+Available since kernel 5.5. Additionally
+.BR io_uring_enter (2)
+will return
+.B -EBADR
+the next time it would otherwise sleep waiting for completions (since ke=
rnel 5.19).
+
 .TP
 .B IORING_FEAT_SUBMIT_STABLE
 If this flag is set, applications can be certain that any data for
--=20
2.30.2

