Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55ACF4DA435
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 21:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351737AbiCOUuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 16:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241084AbiCOUuB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 16:50:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F00221273
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 13:48:49 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FGWaTF003133
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 13:48:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=GfW2Z2sEMsdKvPg8IyIDC8UxCnLYmvtdKxDDLVFMWMA=;
 b=rmOqRoap4PMedM9wxBaXWXJtB71V9ftOQ6h5KkOh/LBy1Bf3HBp6FudtakSUkKt8YReP
 oKEO+1KIO0Iq2jNZ5Qg/IUREnqdabkjFJAqrk5Hy3jl6xq8vqxgjuXPVB9/xh/8UC7r1
 z/P22OEmg1mKj9K9zOTO5Rc6hFLytSYF9w0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3et8vraq4e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 13:48:48 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 13:48:46 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id A5EB35BA5138; Tue, 15 Mar 2022 13:48:34 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH] io_uring: make tracing format consistent
Date:   Tue, 15 Mar 2022 13:48:29 -0700
Message-ID: <20220315204829.2908979-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2symC_GU0Kbg9dQpmfTeI_Og6DOtfvzH
X-Proofpoint-GUID: 2symC_GU0Kbg9dQpmfTeI_Og6DOtfvzH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_10,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make the tracing formatting for user_data and flags consistent.

Having consistent formatting allows one for example to grep for a specifi=
c
user_data/flags and be able to trace a single sqe through easily.

Change user_data to be %llu everywhere, and flags to be %u. Additionally
remove the '=3D' for flags in io_uring_req_failed, again for consistency.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 18d4341c581c..92446436b3ac 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -327,11 +327,11 @@ TRACE_EVENT(io_uring_complete,
 	TP_ARGS(ctx, req, user_data, res, cflags),
=20
 	TP_STRUCT__entry (
-		__field(  void *,	ctx		)
-		__field(  void *,	req		)
-		__field(  u64,		user_data	)
-		__field(  int,		res		)
-		__field(  unsigned,	cflags		)
+		__field(  void *,		ctx		)
+		__field(  void *,		req		)
+		__field(  unsigned long long, 	user_data	)
+		__field(  int,			res		)
+		__field(  unsigned,		cflags		)
 	),
=20
 	TP_fast_assign(
@@ -342,9 +342,9 @@ TRACE_EVENT(io_uring_complete,
 		__entry->cflags		=3D cflags;
 	),
=20
-	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags %x",
+	TP_printk("ring %p, req %p, user_data %llu, result %d, cflags %u",
 		__entry->ctx, __entry->req,
-		(unsigned long long)__entry->user_data,
+		__entry->user_data,
 		__entry->res, __entry->cflags)
 );
=20
@@ -530,7 +530,7 @@ TRACE_EVENT(io_uring_req_failed,
 	),
=20
 	TP_printk("ring %p, req %p, user_data %llu, "
-		"op %d, flags=3D0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
+		"op %d, flags %u, prio=3D%d, off=3D%llu, addr=3D%llu, "
 		  "len=3D%u, rw_flags=3D0x%x, buf_index=3D%d, "
 		  "personality=3D%d, file_index=3D%d, pad=3D0x%llx/%llx, error=3D%d",
 		  __entry->ctx, __entry->req, __entry->user_data,

base-commit: f3b6a41eb2bbdf545a42e54d637c34f4b1fdf5b9
--=20
2.30.2

