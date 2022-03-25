Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284464E7017
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 10:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357486AbiCYJjh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 05:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344774AbiCYJjg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 05:39:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D127BF0E
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 02:38:02 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22P0IVNt019693
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 02:38:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=IP8RlgxW78D3dT1a2Qmy6FPJNK1PR9pohxV0VZBaHpw=;
 b=aM/0U8nISL4UOnEPl/rDKADq+CwjNZ3Uf0YjMS5o9EAlZpQWeMvDxAjw2N4M7ArHfZao
 8Awzegj2R+zwyBrsPazKp1dEjPLDsXqW4tWr+EN/CECeefaPOyG94FfBeHnA+G01EDre
 uqqMs0VAc1HAUzeoVOAKlJIfNRD9SVNsRG4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f0n7a7t72-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 02:38:02 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Mar 2022 02:38:00 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 0B6F76493A4A; Fri, 25 Mar 2022 02:37:58 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH] io_uring: enable EPOLLEXCLUSIVE for accept poll
Date:   Fri, 25 Mar 2022 02:37:55 -0700
Message-ID: <20220325093755.4123343-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: uuPLyY7h3PGtyRAR_XHd5jxgg1b-b89G
X-Proofpoint-ORIG-GUID: uuPLyY7h3PGtyRAR_XHd5jxgg1b-b89G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_02,2022-03-24_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When polling sockets for accept, use EPOLLEXCLUSIVE. This is helpful
when multiple accept SQEs are submitted.

For O_NONBLOCK sockets multiple queued SQEs would previously have all
completed at once, but most with -EAGAIN as the result. Now only one
wakes up and completes.

For sockets without O_NONBLOCK there is no user facing change, but
internally the extra requests would previously be queued onto a worker
thread as they would wake up with no connection waiting, and be
punted. Now they do not wake up unnecessarily.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 63299896555d..fced35d3ee85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -968,6 +968,7 @@ struct io_op_def {
 	/* set if opcode supports polled "wait" */
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
+	unsigned		poll_exclusive : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
 	/* do prep async if is going to be punted */
@@ -1062,6 +1063,7 @@ static const struct io_op_def io_op_defs[] =3D {
 		.needs_file		=3D 1,
 		.unbound_nonreg_file	=3D 1,
 		.pollin			=3D 1,
+		.poll_exclusive		=3D 1,
 	},
 	[IORING_OP_ASYNC_CANCEL] =3D {
 		.audit_skip		=3D 1,
@@ -6280,7 +6282,8 @@ static int io_arm_poll_handler(struct io_kiocb *req=
, unsigned issue_flags)
 	} else {
 		mask |=3D POLLOUT | POLLWRNORM;
 	}
-
+	if (def->poll_exclusive)
+		mask |=3D EPOLLEXCLUSIVE;
 	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
 	    !list_empty(&ctx->apoll_cache)) {
 		apoll =3D list_first_entry(&ctx->apoll_cache, struct async_poll,

base-commit: 6d4809f49bec8dc3b244debcb97f78239e52f5bb
--=20
2.30.2

