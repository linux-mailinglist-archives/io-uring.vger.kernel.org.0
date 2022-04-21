Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802AC509C0E
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387452AbiDUJT6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387543AbiDUJTt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:19:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DEB25EAE
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:57 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23L0VLYx019884
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mjM0wwI9pOqSPCCC1KVwggul7a+EfCAqQSAjGkjuJtg=;
 b=Sx64OVf8J+WH+y0eMsjwIVf5rQ0Q4rYMvJdDeS+OFZfhyJte/5yXAf0oPhy5gqetuKol
 WqmEp/iVaO4YgLwHD4K3vsqLwM0LtCB8i66aIxch6f46po9+6a02CScUq5nMLsF+Sxv6
 ELgjr9IBarWVwaNykaJbdM/CwJ3VyB6K8+A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fjvsvstve-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:56 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:16:54 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id DF8B97CA75FA; Thu, 21 Apr 2022 02:14:01 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 1/6] io_uring: add trace support for CQE overflow
Date:   Thu, 21 Apr 2022 02:13:40 -0700
Message-ID: <20220421091345.2115755-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091345.2115755-1-dylany@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 9cWwF9P1Gcc8bkGAnv6O4w7yJUgfZV3Q
X-Proofpoint-ORIG-GUID: 9cWwF9P1Gcc8bkGAnv6O4w7yJUgfZV3Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add trace function for overflowing CQ ring.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 42 ++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index cddf5b6fbeb4..42534ec2ab9d 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -530,7 +530,7 @@ TRACE_EVENT(io_uring_req_failed,
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, "
-		"op %d, flags 0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
+		  "op %d, flags 0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
 		  "len=3D%u, rw_flags=3D0x%x, buf_index=3D%d, "
 		  "personality=3D%d, file_index=3D%d, pad=3D0x%llx/%llx, error=3D%d",
 		  __entry->ctx, __entry->req, __entry->user_data,
@@ -543,6 +543,46 @@ TRACE_EVENT(io_uring_req_failed,
 		  (unsigned long long) __entry->pad2, __entry->error)
 );
=20
+
+/*
+ * io_uring_cqe_overflow - a CQE overflowed
+ *
+ * @ctx:		pointer to a ring context structure
+ * @user_data:		user data associated with the request
+ * @res:		CQE result
+ * @cflags:		CQE flags
+ * @ocqe:		pointer to the overflow cqe (if available)
+ *
+ */
+TRACE_EVENT(io_uring_cqe_overflow,
+
+	TP_PROTO(void *ctx, unsigned long long user_data, s32 res, u32 cflags,
+		 void *ocqe),
+
+	TP_ARGS(ctx, user_data, res, cflags, ocqe),
+
+	TP_STRUCT__entry (
+		__field(  void *,		ctx		)
+		__field(  unsigned long long,	user_data	)
+		__field(  s32,			res		)
+		__field(  u32,			cflags		)
+		__field(  void *,		ocqe		)
+	),
+
+	TP_fast_assign(
+		__entry->ctx		=3D ctx;
+		__entry->user_data	=3D user_data;
+		__entry->res		=3D res;
+		__entry->cflags		=3D cflags;
+		__entry->ocqe		=3D ocqe;
+	),
+
+	TP_printk("ring %p, user_data 0x%llx, res %d, flags %x, "
+		  "overflow_cqe %p",
+		  __entry->ctx, __entry->user_data, __entry->res,
+		  __entry->cflags, __entry->ocqe)
+);
+
 #endif /* _TRACE_IO_URING_H */
=20
 /* This part must be outside protection */
--=20
2.30.2

