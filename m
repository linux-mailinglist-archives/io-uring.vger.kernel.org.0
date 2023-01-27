Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE2D67E717
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 14:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjA0Nwu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 08:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbjA0Nwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 08:52:47 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BE07E6E9
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:44 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RAoTLS006839
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=zlkQ2rMCiHuZj7H/1REeNm44K/IpbET0dO8l4PUeygQ=;
 b=UKeVe4uiicZlJ94dyuWTqEdYmyjU3yCyVyRhugN4ptCDjxwnPR3LzP4PNM8XiIUfbT7R
 DRjzivk+6p+X5AWnF8ni9ojSttgjf+HtQY0LDiFNGrzLMruX6uXPfpyZzmsp8JMQyu6G
 GBETjU0tDETTLyGTs5zLVYzSCTEDZZk39KLfTfhaPL8XCZuO/oJ0bvfn/xjpelEIs9if
 W24czVcapTm1LDkQbagxoXUv9AnGNPxcdtycsumWtkfBLrW+G0DNhNW3pFUMTO3E2GcB
 s8ritakiPatT6/DF8p4tXb7SOGAl+w+RT7ngE95/XGsL3xSG86KxTsTPTxiyTka+SQhS kw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nbb804x1m-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:43 -0800
Received: from twshared5320.05.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 05:52:40 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 12482EA28124; Fri, 27 Jan 2023 05:52:35 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 4/4] io_uring: always go async for unsupported open flags
Date:   Fri, 27 Jan 2023 05:52:27 -0800
Message-ID: <20230127135227.3646353-5-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127135227.3646353-1-dylany@meta.com>
References: <20230127135227.3646353-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vOaL0SSKbL1XtLZT5vNxdiJKWDwBdoiW
X-Proofpoint-GUID: vOaL0SSKbL1XtLZT5vNxdiJKWDwBdoiW
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
 io_uring/openclose.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 67178e4bb282..a1b98c81a52d 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -31,6 +31,15 @@ struct io_close {
 	u32				file_slot;
 };
=20
+static bool io_openat_force_async(struct io_open *open)
+{
+	/*
+	 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
+	 * it'll always -EAGAIN
+	 */
+	return open->how.flags & (O_TRUNC | O_CREAT | O_TMPFILE);
+}
+
 static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_=
sqe *sqe)
 {
 	struct io_open *open =3D io_kiocb_to_cmd(req, struct io_open);
@@ -61,6 +70,8 @@ static int __io_openat_prep(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe
=20
 	open->nofile =3D rlimit(RLIMIT_NOFILE);
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	if (io_openat_force_async(open))
+		req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -108,12 +119,7 @@ int io_openat2(struct io_kiocb *req, unsigned int is=
sue_flags)
 	nonblock_set =3D op.open_flag & O_NONBLOCK;
 	resolve_nonblock =3D open->how.resolve & RESOLVE_CACHED;
 	if (issue_flags & IO_URING_F_NONBLOCK) {
-		/*
-		 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
-		 * it'll always -EAGAIN
-		 */
-		if (open->how.flags & (O_TRUNC | O_CREAT | O_TMPFILE))
-			return -EAGAIN;
+		WARN_ON_ONCE(io_openat_force_async(open));
 		op.lookup_flags |=3D LOOKUP_CACHED;
 		op.open_flag |=3D O_NONBLOCK;
 	}
--=20
2.30.2

