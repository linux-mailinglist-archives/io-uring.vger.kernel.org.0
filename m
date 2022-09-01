Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9555A9331
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiIAJd1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiIAJd0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:26 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4B01314DE
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:24 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2819Wfd1002750
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EK9NhxtaoyAmN4a9SiaR96Y291lR6GH5HqekGq5np2o=;
 b=D9WgXD4tDVZWePMlhM1CpIsbCBe0grlwYP2cDeNc44E0fM8wbYZc9q/L054aHcpdGxIz
 PTjqUvIDnrJ9Ba9rMQ2sBJTGSk+n4k1VchhSu/q1IhRWfgPOX0YCc1LBG+CgcaWwoYiI
 4E1RJ73POndUEWTS2B/BEq6d5XQbuFzNQjg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jat6s0040-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:23 -0700
Received: from twshared0646.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:22 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C0DCE57693FC; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 07/12] update io_uring_enter.2 docs for IORING_FEAT_NODROP
Date:   Thu, 1 Sep 2022 02:32:58 -0700
Message-ID: <20220901093303.1974274-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901093303.1974274-1-dylany@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: PvN-Nl86LZdMquk6qwvXLow3P0LnZ_B2
X-Proofpoint-ORIG-GUID: PvN-Nl86LZdMquk6qwvXLow3P0LnZ_B2
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

The EBUSY docs are out of date, so update them for the IORING_FEAT_NODROP
feature flag

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_enter.2 | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 1a9311e20357..4d8d488b5c1f 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1330,7 +1330,18 @@ is a valid file descriptor, but the io_uring ring =
is not in the right state
 for details on how to enable the ring.
 .TP
 .B EBUSY
-The application is attempting to overcommit the number of requests it ca=
n have
+If the
+.B IORING_FEAT_NODROP
+feature flag is set, then
+.B EBUSY
+will be returned if there were overflow entries,
+.B IORING_ENTER_GETEVENTS
+flag is set and not all of the overflow entries were able to be flushed =
to
+the CQ ring.
+
+Without
+.B IORING_FEAT_NODROP
+the application is attempting to overcommit the number of requests it ca=
n have
 pending. The application should wait for some completions and try again.=
 May
 occur if the application tries to queue more requests than we have room =
for in
 the CQ ring, or if the application attempts to wait for more events with=
out
--=20
2.30.2

