Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCB2631EBB
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiKUKsn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiKUKsM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:48:12 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C448F00C
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:11 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKKSpRP019456
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=qSmCXqBquJPBd/4bCImrTAvqiQHok6YchcnHrDYQvYI=;
 b=LWIQr6TtLeoid+UH3bc6e6P+5EVRVv4FDHHB59ReXXCj9UuOUrFBmNSkDT5EK9ekMYNi
 kK3vIyXtC8gl+rIUJcMzerM6xbg65LSzopsh8i7CIeCuOQI56YNtuaMGyqWEe7l15FKW
 8IQrDQzGWycC6DosYJqW2nOQpXLJ85QYCRK56bvQN7I4GjVDToCfiIXXUjgbtdznjjoF
 cfC0najcIXjUqfmmYUjeS0HYUL6sb2yWo2VwMt1pLaSvG7hnKsScGPkijwTjuZGcGBwg
 K0E+zPd4VQR2KPEEX4FHqg6no2S7p+XS5495pw/nan3nUxRha4eUSIO4C95tPqG9DAXX Mw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kxv2r3w7s-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:11 -0800
Received: from twshared10308.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:48:07 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1ACED9E66F6B; Mon, 21 Nov 2022 02:03:54 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 02/10] io_uring: __io_req_complete should defer if available
Date:   Mon, 21 Nov 2022 02:03:45 -0800
Message-ID: <20221121100353.371865-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IhJf0_Qc-ZJQzWuW4d1BkbPnwV1iwt4-
X-Proofpoint-GUID: IhJf0_Qc-ZJQzWuW4d1BkbPnwV1iwt4-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index f15aca039db6..208afb944b0c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -862,7 +862,10 @@ void io_req_complete_post(struct io_kiocb *req)
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

