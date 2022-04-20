Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C47D50902A
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348745AbiDTTSG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381682AbiDTTSD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:18:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0751FBE05
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:15 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23KILPh8007963
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nORLf+uPFQYhrqpCSrBdO1fsG3fimeGxuaLEalXTdjU=;
 b=eLbXf49llbqQKx5ItjK0INENiZYASi0om6h81JSVgXrgWD1zlE1SfnYwu3FDgd6fo9bN
 aszlTratF/7y5VL5OqD+AStQZJ7OVz8EfgdP+kvWcEdgk5TSCuwRPYFKzUuj6kVkj8aV
 FglT/9jB32zTNFV0WvUJYfypO9mEF1JxXBI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fj7k3dfjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:15 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:14 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C6513DE0C41C; Wed, 20 Apr 2022 12:14:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 12/12] io_uring: support CQE32 for nop operation
Date:   Wed, 20 Apr 2022 12:14:51 -0700
Message-ID: <20220420191451.2904439-13-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191451.2904439-1-shr@fb.com>
References: <20220420191451.2904439-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nabzp8-bFGNI2zpJHWCa8FXipiRsvv0U
X-Proofpoint-GUID: nabzp8-bFGNI2zpJHWCa8FXipiRsvv0U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for filling the extra1 and extra2 fields for large
CQE's.

Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8bdf253b9462..3855148b6774 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -744,6 +744,12 @@ struct io_msg {
 	u32 len;
 };
=20
+struct io_nop {
+	struct file			*file;
+	u64				extra1;
+	u64				extra2;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -937,6 +943,7 @@ struct io_kiocb {
 		struct io_msg		msg;
 		struct io_xattr		xattr;
 		struct io_socket	sock;
+		struct io_nop		nop;
 	};
=20
 	u8				opcode;
@@ -4863,6 +4870,19 @@ static int io_splice(struct io_kiocb *req, unsigne=
d int issue_flags)
 	return 0;
 }
=20
+static int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *=
sqe)
+{
+	/*
+	 * If the ring is setup with CQE32, relay back addr/addr
+	 */
+	if (req->ctx->flags & IORING_SETUP_CQE32) {
+		req->nop.extra1 =3D READ_ONCE(sqe->addr);
+		req->nop.extra2 =3D READ_ONCE(sqe->addr2);
+	}
+
+	return 0;
+}
+
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
@@ -4873,7 +4893,11 @@ static int io_nop(struct io_kiocb *req, unsigned i=
nt issue_flags)
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
=20
-	__io_req_complete(req, issue_flags, 0, 0);
+	if (!(ctx->flags & IORING_SETUP_CQE32))
+		__io_req_complete(req, issue_flags, 0, 0);
+	else
+		__io_req_complete32(req, issue_flags, 0, 0, req->nop.extra1,
+					req->nop.extra2);
 	return 0;
 }
=20
@@ -7345,7 +7369,7 @@ static int io_req_prep(struct io_kiocb *req, const =
struct io_uring_sqe *sqe)
 {
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-		return 0;
+		return io_nop_prep(req, sqe);
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
--=20
2.30.2

