Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DF45AD3DB
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbiIEN1b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbiIEN1a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:27:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115CF4A112
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:27:29 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 284MVFAp022261
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:27:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EK9NhxtaoyAmN4a9SiaR96Y291lR6GH5HqekGq5np2o=;
 b=QCgToWaIJ5gqkSIDihCTOchYpmaK1GGNTH4M8MLgX9jvz1Resunj924ql6iX3xY/p4PW
 hUObccwlkL0+n5Z6qOFR8L5xarjo+l3MWGok+OjH+5ICfLZFOw/GxJAE/6eWzyCUPZlB
 GA323sA3/GJldk6jC04tOKfya5T4tthKpr8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jcgaeegwy-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:27:28 -0700
Received: from twshared14074.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:27:27 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 434FD5AC5176; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 07/11] update io_uring_enter.2 docs for IORING_FEAT_NODROP
Date:   Mon, 5 Sep 2022 06:22:54 -0700
Message-ID: <20220905132258.1858915-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: FBF-COkEVvzZPPGlheY3nNWk3yrT1xLk
X-Proofpoint-GUID: FBF-COkEVvzZPPGlheY3nNWk3yrT1xLk
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

