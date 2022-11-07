Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF27661F3BC
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 13:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiKGMw5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 07:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiKGMw4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 07:52:56 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2C3B4A9
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 04:52:55 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A7AhtmW008247
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 04:52:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=FUeqoODRlOr1v5SfWTCyNFQ9US62qxvJYbuCNILGR0o=;
 b=WXwteOlr6a+7eUYFvLtBjo4iMxgc+TJWygV24C+MjxUxuZCD+eTMkZ4dr6lVVy6ZvJlx
 apn5ZOGjQBq9KkRS/lFpOuYEpbUTerKWLVI8sbp8Z3boioH427DpkhprXDr/d8EycdF8
 iU/7q7x4uZa+KCAKzdTZAq0opnH1AVBFGCpXX9poPTrC2/NE+/mbE7roSenJL71CsNe4
 5EV7cg8t2WXq1yl4zuliIRUbD9fbgZka7e8X7CpLiiRgl5AXP7KmCmol/VMF50VStp6W
 EFC8kDBggTol+NUS4DVnvAJWOFDi0yrTVeKoCDOZn8VbuspdyDZokj3F/rccESNGgfDB hQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3knkb7xb56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 04:52:54 -0800
Received: from twshared2001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 04:52:53 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 4E8ED90D69EC; Mon,  7 Nov 2022 04:52:45 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 3/4] io_uring: allow multishot recv CQEs to overflow
Date:   Mon, 7 Nov 2022 04:52:35 -0800
Message-ID: <20221107125236.260132-4-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107125236.260132-1-dylany@meta.com>
References: <20221107125236.260132-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: TGuD-ZsFf30cG8ezE_QorJuf-3Muxtui
X-Proofpoint-ORIG-GUID: TGuD-ZsFf30cG8ezE_QorJuf-3Muxtui
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_05,2022-11-07_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With commit aa1df3a360a0 ("io_uring: fix CQE reordering"), there are
stronger guarantees for overflow ordering. Specifically ensuring that
userspace will not receive out of order receive CQEs. Therefore this is
not needed any more for recv/recvmsg.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/net.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0d77ddcce0af..4b79b61f5597 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -603,15 +603,11 @@ static inline bool io_recv_finish(struct io_kiocb *=
req, int *ret,
=20
 	if (!mshot_finished) {
 		if (io_post_aux_cqe(req->ctx, req->cqe.user_data, *ret,
-				    cflags | IORING_CQE_F_MORE, false)) {
+				    cflags | IORING_CQE_F_MORE, true)) {
 			io_recv_prep_retry(req);
 			return false;
 		}
-		/*
-		 * Otherwise stop multishot but use the current result.
-		 * Probably will end up going into overflow, but this means
-		 * we cannot trust the ordering anymore
-		 */
+		/* Otherwise stop multishot but use the current result. */
 	}
=20
 	io_req_set_res(req, *ret, cflags);
--=20
2.30.2

