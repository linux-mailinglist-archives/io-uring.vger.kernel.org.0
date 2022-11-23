Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB4B635B11
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbiKWLHa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbiKWLG4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:06:56 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E305A449
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:40 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB6532016526
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=N47RFG6rqxzhK9mIsH6lCWq+xQ4nDOqdeytRX15d14s=;
 b=CGizRgCg+hu9i+OFn8iVpRQGwwWQEivfCwv5Ufs0IhG3UJp6KRe9a1ykm0LjPXdqxOlf
 X7OcE3sOmGdfemayTE2Kd7LTJgVHhE+X7aqN0MKsYFk3jmxTSfEn7BVCCPIl1ZrfNvMs
 qTtHSOrhZ/DVuk4Ina6OKSjlUs7F8ouBMLDDR6BiHMwU2z91PwfrtMihtneTZ2Yx+FtA
 dVnQe0pSOKfWQyolgl0V+hhC5maraVs2q5UFQWm4xq+OryD5G4my5tBY8+D/xsOa8FFB
 EyEVJyKUvwqPCrzjFASXUc1TEd2HfX++5UZJwt83zHbksqewBBauFZ7qpcV+d6GfTwn7 pw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1cg3hy35-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:39 -0800
Received: from twshared8047.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:36 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 76D3BA0804D0; Wed, 23 Nov 2022 03:06:27 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 05/13] io_uring: timeout should use io_req_task_complete
Date:   Wed, 23 Nov 2022 03:06:06 -0800
Message-ID: <20221123110614.3297343-6-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: H5dLzbt71QmYMcQ_hBHcojO8pwF-YQKx
X-Proofpoint-GUID: H5dLzbt71QmYMcQ_hBHcojO8pwF-YQKx
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

Allow timeouts to defer completions if the ring is locked

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/timeout.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index e8a8c2099480..26b61e62aa9a 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -282,12 +282,11 @@ static void io_req_task_link_timeout(struct io_kioc=
b *req, bool *locked)
 			ret =3D io_try_cancel(req->task->io_uring, &cd, issue_flags);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
-		io_req_complete_post(req);
 		io_put_req(prev);
 	} else {
 		io_req_set_res(req, -ETIME, 0);
-		io_req_complete_post(req);
 	}
+	io_req_task_complete(req, locked);
 }
=20
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
--=20
2.30.2

