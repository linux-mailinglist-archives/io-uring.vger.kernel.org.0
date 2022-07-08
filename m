Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7DB56C0B1
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 20:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbiGHSTA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 14:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238535AbiGHSSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 14:18:54 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA114823B0
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 11:18:53 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268HAatO027372
        for <io-uring@vger.kernel.org>; Fri, 8 Jul 2022 11:18:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=lgcixcPTzwnEb+MWYgxBSwdUAkCiiDjL6xo5mS4d2w4=;
 b=fRtfEihPBbKOVWpjil52uDyJVPZhPMl5x8J8xS251lF1xUDXy/Ygy+LriXOl2DoeUKNs
 uRE62feq0RSJvhvG5EVKRjtvMSdwL0Vjq4EPNKCLfFEOfP53yI4rsJ+tNnDoI+HemUL7
 ZNQS7H7XhfNtyDuEry6oOxWh+wyX71On94A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h6eg1ky5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 11:18:52 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 8 Jul 2022 11:18:51 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 49AD12B9EC58; Fri,  8 Jul 2022 11:18:43 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 4/4] io_uring: move netmsg recycling into io_uring cleanup
Date:   Fri, 8 Jul 2022 11:18:38 -0700
Message-ID: <20220708181838.1495428-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220708181838.1495428-1-dylany@fb.com>
References: <20220708181838.1495428-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: GZ3rZkJv6jImhti-lLFuOFA-kZ1mbTyI
X-Proofpoint-GUID: GZ3rZkJv6jImhti-lLFuOFA-kZ1mbTyI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_14,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Specifically will be useful for multishot as the lifetime of a request is
a bit more complicated, but generally makes things a bit neater.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/net.c   | 10 ++++------
 io_uring/net.h   |  1 +
 io_uring/opdef.c |  2 ++
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 997c17512694..c1cbafe96c63 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -98,18 +98,18 @@ static bool io_net_retry(struct socket *sock, int fla=
gs)
 	return sock->type =3D=3D SOCK_STREAM || sock->type =3D=3D SOCK_SEQPACKE=
T;
 }
=20
-static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_f=
lags)
+bool io_netmsg_recycle(struct io_kiocb *req)
 {
 	struct io_async_msghdr *hdr =3D req->async_data;
=20
-	if (!hdr || issue_flags & IO_URING_F_UNLOCKED)
-		return;
-
 	if (io_alloc_cache_store(&req->ctx->netmsg_cache)) {
 		hlist_add_head(&hdr->cache_list, &req->ctx->netmsg_cache.list);
 		req->async_data =3D NULL;
 		req->flags &=3D ~REQ_F_ASYNC_DATA;
+		return true;
 	}
+
+	return false;
 }
=20
 static struct io_async_msghdr *io_recvmsg_alloc_async(struct io_kiocb *r=
eq,
@@ -261,7 +261,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &=3D ~REQ_F_NEED_CLEANUP;
-	io_netmsg_recycle(req, issue_flags);
 	if (ret >=3D 0)
 		ret +=3D sr->done_io;
 	else if (sr->done_io)
@@ -583,7 +582,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
-	io_netmsg_recycle(req, issue_flags);
 	req->flags &=3D ~REQ_F_NEED_CLEANUP;
 	if (ret > 0)
 		ret +=3D sr->done_io;
diff --git a/io_uring/net.h b/io_uring/net.h
index 576efb602c7f..c5a897e61f10 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -44,6 +44,7 @@ int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe=
);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
=20
+bool io_netmsg_recycle(struct io_kiocb *req);
 void io_flush_netmsg_cache(struct io_ring_ctx *ctx);
 #else
 static inline void io_flush_netmsg_cache(struct io_ring_ctx *ctx)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a7b84b43e6c2..b525e37f397a 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -153,6 +153,7 @@ const struct io_op_def io_op_defs[] =3D {
 		.issue			=3D io_sendmsg,
 		.prep_async		=3D io_sendmsg_prep_async,
 		.cleanup		=3D io_sendmsg_recvmsg_cleanup,
+		.recycle_async		=3D io_netmsg_recycle,
 #else
 		.prep			=3D io_eopnotsupp_prep,
 #endif
@@ -170,6 +171,7 @@ const struct io_op_def io_op_defs[] =3D {
 		.issue			=3D io_recvmsg,
 		.prep_async		=3D io_recvmsg_prep_async,
 		.cleanup		=3D io_sendmsg_recvmsg_cleanup,
+		.recycle_async		=3D io_netmsg_recycle,
 #else
 		.prep			=3D io_eopnotsupp_prep,
 #endif
--=20
2.30.2

