Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCF24E6555
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 15:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiCXOgY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 10:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349229AbiCXOgY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 10:36:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2219F1106
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:34:51 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22O8WoF3001644
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:34:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=KPUU1Du5qm7t4SwXQqJ6rzZvy6wrLHAy8CRb5xEndfg=;
 b=bk+vxsKvjeZmx8A8PymiL8i40j5UokRJJeMbluqaDCAfkRgl7bkbry+MmRryg6xFtpg2
 XgavdAka1Ev96ZxBXxVCc7VR+2C76C+TtOyL/vk4pG2+nPr0Vw50TkZqwRlEZZY9gAjQ
 HZn3n0MSyjX4bQsKN9udAS+l4iQkTafuKX8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f0n7a1tne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:34:51 -0700
Received: from twshared37304.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 07:34:50 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 2603C63CAFE7; Thu, 24 Mar 2022 07:34:38 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH] io_uring: allow async accept on O_NONBLOCK sockets
Date:   Thu, 24 Mar 2022 07:34:35 -0700
Message-ID: <20220324143435.2875844-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 08d_JB4aWfVsegqP6LMaE2PJezx2ZLzf
X-Proofpoint-ORIG-GUID: 08d_JB4aWfVsegqP6LMaE2PJezx2ZLzf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_04,2022-03-24_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do not set REQ_F_NOWAIT if the socket is non blocking. When enabled this
causes the accept to immediately post a CQE with EAGAIN, which means you
cannot perform an accept SQE on a NONBLOCK socket asynchronously.

By removing the flag if there is no pending accept then poll is armed as
usual and when a connection comes in the CQE is posted.

note: If multiple accepts are queued up, then when a single connection
comes in they all complete, one with the connection, and the remaining
with EAGAIN. This could be improved in the future but will require a lot
of io_uring changes.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 88556e654c5a..a2a71e76e0da 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5603,9 +5603,6 @@ static int io_accept(struct io_kiocb *req, unsigned=
 int issue_flags)
 	struct file *file;
 	int ret, fd;
=20
-	if (req->file->f_flags & O_NONBLOCK)
-		req->flags |=3D REQ_F_NOWAIT;
-
 	if (!fixed) {
 		fd =3D __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))

base-commit: 8a3e8ee56417f5e0e66580d93941ed9d6f4c8274
--=20
2.30.2

