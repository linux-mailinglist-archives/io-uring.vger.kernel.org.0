Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F21637543
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiKXJga (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiKXJg3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:29 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E07109589
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:29 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsDVY024539
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=+buD+PM5wUy6zaCH/kJrPBrEOBD7JPENkycFACOudHc=;
 b=SZTJmXXzhmC1o6eBBrAjan8GSl0FXzlbVZkL/GW2GDhd/1nx+KM9kqbDiQqNL3f2thTF
 ACnW9mh0VrEMyhlntAUTzR5C0pIfo+Titwabk4PKqWesc13+BsMGXjniHJtGnpTYFiyM
 DS2ApSVQTpY60LXgY07Z5Nf/laLjoFtq+bmUMBn2+qY++lKO6nVoSPOMzcIjlmlyPAlJ
 Wq7AW1T7sHexY+X71xnYg7YS8MSNhASu0PLTlYyR1hgqOx5DL1MpTzZibMsgcN7KuRAz
 LySFRTbXrb2MbAjV4oUNJsqv9YXRJj2NnrAr/b4xfd8301toZiI7tWcxO6rDavejoWQf lg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1cg3s8wk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:29 -0800
Received: from twshared7043.05.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:28 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id D7124A173A0A; Thu, 24 Nov 2022 01:36:18 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 1/9] io_uring: io_req_complete_post should defer if available
Date:   Thu, 24 Nov 2022 01:35:51 -0800
Message-ID: <20221124093559.3780686-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: MxDcMgOR_tS4DbI-l14HKJb0RQkgPzd2
X-Proofpoint-GUID: MxDcMgOR_tS4DbI-l14HKJb0RQkgPzd2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
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
 io_uring/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cc27413129fc..ec23ebb63489 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -852,7 +852,9 @@ static void __io_req_complete_post(struct io_kiocb *r=
eq)
=20
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (!(issue_flags & IO_URING_F_UNLOCKED) ||
+	if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
+		io_req_complete_defer(req);
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
 	    !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
 		__io_req_complete_post(req);
 	} else {
--=20
2.30.2

