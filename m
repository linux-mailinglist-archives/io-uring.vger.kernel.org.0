Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF702592F97
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242823AbiHONPZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242825AbiHONPQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:15:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C99AA
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:15:14 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27F9Oucg021310
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:15:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=geNmTpnjsOWYMRBUJxVvCYS4XuDc2QzfNx/AmkFBHp8=;
 b=N5TpzS3jfUEEcj/LoviAbBCzxTK1Nu6/rBD2He2rBg2C8S1HvfzDecfk1ufbZT+w/+e8
 GtLJTDgUFB2sw8Fzgo3XYCYHDqf4VjpnaCqqN8VI5VymQ1KNwHSFlQ8b1pQ/uE0Z/fVN
 FQfGOiCD1gNNjbvgby2HHWzmA4iGezXMKNk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hykfy0x67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:15:14 -0700
Received: from twshared6324.05.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:15:13 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 4C0CA49B7303; Mon, 15 Aug 2022 06:09:55 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 07/11] update io_uring_enter.2 docs for IORING_FEAT_NODROP
Date:   Mon, 15 Aug 2022 06:09:43 -0700
Message-ID: <20220815130947.1002152-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130947.1002152-1-dylany@fb.com>
References: <20220815130947.1002152-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: omJB7LsFtjthKxVPmtNfBdsBtDoMS6XX
X-Proofpoint-ORIG-GUID: omJB7LsFtjthKxVPmtNfBdsBtDoMS6XX
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

The EBUSY docs are out of date, so update them for the IORING_FEAT_NODROP
feature flag

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_enter.2 | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 6e3ffa0f5ba8..9ad6349b2c4a 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1327,7 +1327,18 @@ is a valid file descriptor, but the io_uring ring =
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

