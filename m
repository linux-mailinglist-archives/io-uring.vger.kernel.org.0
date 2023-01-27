Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0678567E71B
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 14:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbjA0Nwz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 08:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjA0Nwy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 08:52:54 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94DB1EBE5
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:52 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RDflPf000991
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=pDdjWZuRAr2WvLqA9Yvug8ikTXNDs4lLRULP1xcj01I=;
 b=POQSYnAMFYO/4hhdrgo1j5LvIWpVOhmXdQI1NIlV6AjCsDovb/RQQEbPtJqcIBT+Z6oP
 Pr08FE8wAvdI2NQap6htO7zjr6lvCW97nDL7ijY5ZFHphGhqJDMpPjwifnD5T9lnuEZI
 b6IbPbe/Vay0R1Se03uBASU83s6cSHUI+s5zUHVIp29tDntEmAhJxVkrDXihYy3bXozB
 7TTxq41YB6eMEzZZfCMykvNH1ayvQ02IxBSml3k2172P1udIbrgHa8MKo0+D/gN5Lqdv
 zQOjEwwBBGNiN9TPvsrbbm2Y3WLIdNJzVaJfGGAS7z60sdEYMiwiUNMIMY3Of6rvw+bw YQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nbw3dne44-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:52 -0800
Received: from twshared24547.08.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 05:52:46 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 099C7EA28123; Fri, 27 Jan 2023 05:52:34 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 3/4] io_uring: always go async for unsupported fadvise flags
Date:   Fri, 27 Jan 2023 05:52:26 -0800
Message-ID: <20230127135227.3646353-4-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127135227.3646353-1-dylany@meta.com>
References: <20230127135227.3646353-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: hhKDrM9C2otHXIL99TlPQr9fRGCV36ql
X-Proofpoint-GUID: hhKDrM9C2otHXIL99TlPQr9fRGCV36ql
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_08,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No point in issuing -> return -EAGAIN -> go async, when it can be done up=
front.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/advise.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/io_uring/advise.c b/io_uring/advise.c
index cf600579bffe..7085804c513c 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -62,6 +62,18 @@ int io_madvise(struct io_kiocb *req, unsigned int issu=
e_flags)
 #endif
 }
=20
+static bool io_fadvise_force_async(struct io_fadvise *fa)
+{
+	switch (fa->advice) {
+	case POSIX_FADV_NORMAL:
+	case POSIX_FADV_RANDOM:
+	case POSIX_FADV_SEQUENTIAL:
+		return false;
+	default:
+		return true;
+	}
+}
+
 int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe=
)
 {
 	struct io_fadvise *fa =3D io_kiocb_to_cmd(req, struct io_fadvise);
@@ -72,6 +84,8 @@ int io_fadvise_prep(struct io_kiocb *req, const struct =
io_uring_sqe *sqe)
 	fa->offset =3D READ_ONCE(sqe->off);
 	fa->len =3D READ_ONCE(sqe->len);
 	fa->advice =3D READ_ONCE(sqe->fadvise_advice);
+	if (io_fadvise_force_async(fa))
+		req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -80,16 +94,7 @@ int io_fadvise(struct io_kiocb *req, unsigned int issu=
e_flags)
 	struct io_fadvise *fa =3D io_kiocb_to_cmd(req, struct io_fadvise);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK) {
-		switch (fa->advice) {
-		case POSIX_FADV_NORMAL:
-		case POSIX_FADV_RANDOM:
-		case POSIX_FADV_SEQUENTIAL:
-			break;
-		default:
-			return -EAGAIN;
-		}
-	}
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK && io_fadvise_force_asyn=
c(fa));
=20
 	ret =3D vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
 	if (ret < 0)
--=20
2.30.2

