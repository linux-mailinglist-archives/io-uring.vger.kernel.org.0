Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58369635B15
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbiKWLHb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237680AbiKWLG6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:06:58 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A802156EF3
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:42 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB4PXp007756
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=xrpdzGsOSo95/SQ7TUl7Ka4Y4KT5Qjp35Cxs0HYJzks=;
 b=frfT+yJOmmO3XGeBCnr0KAZgGqnXtFZl9h2WYsNW8QAJZ52G8p5WfbWsieDFVq0x5hYR
 oixAm/VjIM0yEyZVb9XHZeu5qVIW5XFw3mig4nnklsfO3UAadgoZQhtUHxyeeyKcCjr1
 VH8uEOD4NDye+TWHKBnibfHeosoOeXBmvNblXebESlXjzTMtuNp1MLJrL4Fu2yWa7uUX
 9S/w+Jf/EHtcZk3cLELTar6Sb+tivmakfu7xt9WxtWKyZ0Yt/8qYBPjMo9/YaucAPCuL
 A6dKkvy9Nakl9FNlFvsC9OJgeqeS+0f7ywo4pSqOjjrWUeuC5D/lar3ZIiu8myrC58lN uA== 
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m17esbjnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:42 -0800
Received: from twshared0705.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:40 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 81F2BA0804BA; Wed, 23 Nov 2022 03:06:26 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 02/13] io_uring: __io_req_complete should defer if available
Date:   Wed, 23 Nov 2022 03:06:03 -0800
Message-ID: <20221123110614.3297343-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ChHLSGDhSq5mK2ou5QAxPDtQjnXG1B4X
X-Proofpoint-ORIG-GUID: ChHLSGDhSq5mK2ou5QAxPDtQjnXG1B4X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For consistency always defer completion if specified in the issue flags.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e40d7b3404eb..0741a728fb6a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -858,7 +858,10 @@ void io_req_complete_post(struct io_kiocb *req)
=20
 inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags=
)
 {
-	io_req_complete_post(req);
+	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
+		io_req_complete_defer(req);
+	else
+		io_req_complete_post(req);
 }
=20
 void io_req_complete_failed(struct io_kiocb *req, s32 res)
--=20
2.30.2

