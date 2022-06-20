Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268FC55221B
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbiFTQT2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 12:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242819AbiFTQT1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 12:19:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B131A071
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:26 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFIWYR018798
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ol4mipg/P/3QIsNogv5iBPOSWgq9AwtSKFHifgKXD7k=;
 b=JP0iKRMhfei2miX1gDoAublUqnw5zHzY6A/jkWsLfuT4jSu85NJmCtz8NhBV9Z+VLIcN
 hRzdFYL7/jRvmiGWLfcW125POWfZNyXoxcAi3XEh1RaviIAGGOgQBH8r/FUFykc7bRgj
 jxS1tXu6GStFtD9yxTxMTA+WBV8KiZyh6v4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gscdq9se1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:25 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 09:19:24 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A04921EB9445; Mon, 20 Jun 2022 09:19:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC for-next 6/8] io_uring: move io_uring_get_opcode out of TP_printk
Date:   Mon, 20 Jun 2022 09:18:59 -0700
Message-ID: <20220620161901.1181971-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620161901.1181971-1-dylany@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6T-BdIhYwxl0h87O73STKYRp2UtaNgPN
X-Proofpoint-ORIG-GUID: 6T-BdIhYwxl0h87O73STKYRp2UtaNgPN
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The TP_printk macro's are not supposed to use custom code ([1]) or else
tools such as perf cannot use these events.

Convert the opcode string representation to use the __string wiring that
the event framework provides ([2]).

[1]: https://lwn.net/Articles/379903/
[2]: https://lwn.net/Articles/381064/

Fixes: 033b87d2 ("io_uring: use the text representation of ops in trace")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 42 +++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_urin=
g.h
index 5635912e1013..3bc8dec9acaa 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -151,6 +151,8 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__field(  unsigned int,			flags		)
 		__field(  struct io_wq_work *,		work		)
 		__field(  int,				rw		)
+
+		__string( op_str, io_uring_get_opcode(req->opcode)	)
 	),
=20
 	TP_fast_assign(
@@ -161,11 +163,13 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__entry->opcode		=3D req->opcode;
 		__entry->work		=3D &req->work;
 		__entry->rw		=3D rw;
+
+		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
=20
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%x, =
%s queue, work %p",
 		__entry->ctx, __entry->req, __entry->user_data,
-		io_uring_get_opcode(__entry->opcode),
+		__get_str(op_str),
 		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
 );
=20
@@ -188,6 +192,8 @@ TRACE_EVENT(io_uring_defer,
 		__field(  void *,		req	)
 		__field(  unsigned long long,	data	)
 		__field(  u8,			opcode	)
+
+		__string( op_str, io_uring_get_opcode(req->opcode) )
 	),
=20
 	TP_fast_assign(
@@ -195,11 +201,13 @@ TRACE_EVENT(io_uring_defer,
 		__entry->req	=3D req;
 		__entry->data	=3D req->cqe.user_data;
 		__entry->opcode	=3D req->opcode;
+
+		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
=20
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s",
 		__entry->ctx, __entry->req, __entry->data,
-		io_uring_get_opcode(__entry->opcode))
+		__get_str(op_str))
 );
=20
 /**
@@ -284,6 +292,8 @@ TRACE_EVENT(io_uring_fail_link,
 		__field(  unsigned long long,	user_data	)
 		__field(  u8,			opcode		)
 		__field(  void *,		link		)
+
+		__string( op_str, io_uring_get_opcode(req->opcode) )
 	),
=20
 	TP_fast_assign(
@@ -292,11 +302,13 @@ TRACE_EVENT(io_uring_fail_link,
 		__entry->user_data	=3D req->cqe.user_data;
 		__entry->opcode		=3D req->opcode;
 		__entry->link		=3D link;
+
+		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
=20
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, link %p",
 		__entry->ctx, __entry->req, __entry->user_data,
-		io_uring_get_opcode(__entry->opcode), __entry->link)
+		__get_str(op_str), __entry->link)
 );
=20
 /**
@@ -370,6 +382,8 @@ TRACE_EVENT(io_uring_submit_sqe,
 		__field(  u32,			flags		)
 		__field(  bool,			force_nonblock	)
 		__field(  bool,			sq_thread	)
+
+		__string( op_str, io_uring_get_opcode(req->opcode) )
 	),
=20
 	TP_fast_assign(
@@ -380,11 +394,13 @@ TRACE_EVENT(io_uring_submit_sqe,
 		__entry->flags		=3D req->flags;
 		__entry->force_nonblock	=3D force_nonblock;
 		__entry->sq_thread	=3D req->ctx->flags & IORING_SETUP_SQPOLL;
+
+		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%x, "
 		  "non block %d, sq_thread %d", __entry->ctx, __entry->req,
-		  __entry->user_data, io_uring_get_opcode(__entry->opcode),
+		  __entry->user_data, __get_str(op_str),
 		  __entry->flags, __entry->force_nonblock, __entry->sq_thread)
 );
=20
@@ -411,6 +427,8 @@ TRACE_EVENT(io_uring_poll_arm,
 		__field(  u8,			opcode		)
 		__field(  int,			mask		)
 		__field(  int,			events		)
+
+		__string( op_str, io_uring_get_opcode(req->opcode) )
 	),
=20
 	TP_fast_assign(
@@ -420,11 +438,13 @@ TRACE_EVENT(io_uring_poll_arm,
 		__entry->opcode		=3D req->opcode;
 		__entry->mask		=3D mask;
 		__entry->events		=3D events;
+
+		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, mask 0x%x, event=
s 0x%x",
 		  __entry->ctx, __entry->req, __entry->user_data,
-		  io_uring_get_opcode(__entry->opcode),
+		  __get_str(op_str),
 		  __entry->mask, __entry->events)
 );
=20
@@ -447,6 +467,8 @@ TRACE_EVENT(io_uring_task_add,
 		__field(  unsigned long long,	user_data	)
 		__field(  u8,			opcode		)
 		__field(  int,			mask		)
+
+		__string( op_str, io_uring_get_opcode(req->opcode) )
 	),
=20
 	TP_fast_assign(
@@ -455,11 +477,13 @@ TRACE_EVENT(io_uring_task_add,
 		__entry->user_data	=3D req->cqe.user_data;
 		__entry->opcode		=3D req->opcode;
 		__entry->mask		=3D mask;
+
+		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, mask %x",
 		__entry->ctx, __entry->req, __entry->user_data,
-		io_uring_get_opcode(__entry->opcode),
+		__get_str(op_str),
 		__entry->mask)
 );
=20
@@ -495,6 +519,8 @@ TRACE_EVENT(io_uring_req_failed,
 		__field( u64,			pad1		)
 		__field( u64,			addr3		)
 		__field( int,			error		)
+
+		__string( op_str, io_uring_get_opcode(sqe->opcode) )
 	),
=20
 	TP_fast_assign(
@@ -514,6 +540,8 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->pad1		=3D sqe->__pad2[0];
 		__entry->addr3		=3D sqe->addr3;
 		__entry->error		=3D error;
+
+		__assign_str(op_str, io_uring_get_opcode(sqe->opcode));
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, "
@@ -522,7 +550,7 @@ TRACE_EVENT(io_uring_req_failed,
 		  "personality=3D%d, file_index=3D%d, pad=3D0x%llx, addr3=3D%llx, "
 		  "error=3D%d",
 		  __entry->ctx, __entry->req, __entry->user_data,
-		  io_uring_get_opcode(__entry->opcode),
+		  __get_str(op_str),
 		  __entry->flags, __entry->ioprio,
 		  (unsigned long long)__entry->off,
 		  (unsigned long long) __entry->addr, __entry->len,
--=20
2.30.2

