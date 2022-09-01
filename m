Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EF95A9333
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiIAJd2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiIAJd0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03F5133F0B
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:25 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2811Hd9F000343
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vGyofClJsXWSVgIvO7mgfI8ilfFPtKCRWqY+kse1jg0=;
 b=AyvGr6DTbbgD6QDuEx/szfnVspdJPL1yVx2nVb5ObYLjj5TvsEobohCdmdxWidWL7N8l
 Gh/0N3H3R4cfdebIt+Ez0I9f74WAqUt/sw+P9h1a7/8L5bJn5qFq2thFTnn/230Ezr18
 YwSrH4ZVzpSljYYulE6EcgzQmC169U+VktQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j9nks4yt0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:25 -0700
Received: from twshared8442.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:23 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C90E95769400; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 08/12] add docs for overflow lost errors
Date:   Thu, 1 Sep 2022 02:32:59 -0700
Message-ID: <20220901093303.1974274-9-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NTz0Wgx_0zbNKYS-mrgog0LTNRAxHNlk
X-Proofpoint-ORIG-GUID: NTz0Wgx_0zbNKYS-mrgog0LTNRAxHNlk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 4d8d488b5c1f..3c4aa04016cf 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1329,6 +1329,17 @@ is a valid file descriptor, but the io_uring ring =
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
index 01eb70d95292..41c9e5f269c5 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -298,7 +298,7 @@ call. The SQEs must still be allocated separately. Th=
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
@@ -306,7 +306,14 @@ IO will fail with the
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

