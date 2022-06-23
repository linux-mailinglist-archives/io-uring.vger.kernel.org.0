Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B955C5575A2
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 10:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiFWIi1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 04:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiFWIiY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 04:38:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDEA47AEF
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 01:38:22 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25N0wWrd008688
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 01:38:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=10qe7+jOLXQLVVVO5FBsRxZhJqkRHnASs+xarFqXce8=;
 b=NXQf88Be95mj7oPWkKjM0n2KOxp1Af3m+d95g9nShep9S6Stk9GNP9u7/75z9qnoI+O3
 Gj9K7RxO1f25lNN1Nqf/bDA271P9vHsHyl4D9bH8Xmz0e5S5j9oxmtcE2foujPkKPXc/
 SXt90TJHIsAlmfJ3fZNJEfBx/g97n7tTqJE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gv4qg5pr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 01:38:21 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 23 Jun 2022 01:38:21 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1892920A187E; Thu, 23 Jun 2022 01:37:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 5.19] io_uring: move io_uring_get_opcode out of TP_printk
Date:   Thu, 23 Jun 2022 01:37:43 -0700
Message-ID: <20220623083743.2648321-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: HV4uaEOiWu8vJBGVAOdz1CrO-8sVXjOt
X-Proofpoint-GUID: HV4uaEOiWu8vJBGVAOdz1CrO-8sVXjOt
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_03,2022-06-22_03,2022-06-22_01
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

Fixes: 033b87d24f72 ("io_uring: use the text representation of ops in trace=
")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---

Hi,

I think this probably should get queued up for 5.19 as it can break some us=
erspace
tooling (eg. perf) otherwise.

I've done the rebase here to 5.19, but there will be a conflict with Pavel's
"io_uring: clean up tracing events" if you apply this and rebase 5.20 on it.

Dylan

 include/trace/events/io_uring.h | 43 +++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_urin=
g.h
index 66fcc5a1a5b1..ede64cde1704 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -158,6 +158,8 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__field(  unsigned int,			flags		)
 		__field(  struct io_wq_work *,		work		)
 		__field(  int,				rw		)
+
+		__string( op_str, io_uring_get_opcode(opcode)	)
 	),
=20
 	TP_fast_assign(
@@ -168,11 +170,13 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__entry->opcode		=3D opcode;
 		__entry->work		=3D work;
 		__entry->rw		=3D rw;
+
+		__assign_str(op_str, io_uring_get_opcode(opcode));
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
@@ -198,6 +202,8 @@ TRACE_EVENT(io_uring_defer,
 		__field(  void *,		req	)
 		__field(  unsigned long long,	data	)
 		__field(  u8,			opcode	)
+
+		__string( op_str, io_uring_get_opcode(opcode) )
 	),
=20
 	TP_fast_assign(
@@ -205,11 +211,13 @@ TRACE_EVENT(io_uring_defer,
 		__entry->req	=3D req;
 		__entry->data	=3D user_data;
 		__entry->opcode	=3D opcode;
+
+		__assign_str(op_str, io_uring_get_opcode(opcode));
 	),
=20
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s",
 		__entry->ctx, __entry->req, __entry->data,
-		io_uring_get_opcode(__entry->opcode))
+		__get_str(op_str))
 );
=20
 /**
@@ -298,6 +306,8 @@ TRACE_EVENT(io_uring_fail_link,
 		__field(  unsigned long long,	user_data	)
 		__field(  u8,			opcode		)
 		__field(  void *,		link		)
+
+		__string( op_str, io_uring_get_opcode(opcode) )
 	),
=20
 	TP_fast_assign(
@@ -306,11 +316,13 @@ TRACE_EVENT(io_uring_fail_link,
 		__entry->user_data	=3D user_data;
 		__entry->opcode		=3D opcode;
 		__entry->link		=3D link;
+
+		__assign_str(op_str, io_uring_get_opcode(opcode));
 	),
=20
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, link %p",
 		__entry->ctx, __entry->req, __entry->user_data,
-		io_uring_get_opcode(__entry->opcode), __entry->link)
+		__get_str(op_str), __entry->link)
 );
=20
 /**
@@ -390,6 +402,8 @@ TRACE_EVENT(io_uring_submit_sqe,
 		__field(  u32,			flags		)
 		__field(  bool,			force_nonblock	)
 		__field(  bool,			sq_thread	)
+
+		__string( op_str, io_uring_get_opcode(opcode) )
 	),
=20
 	TP_fast_assign(
@@ -399,12 +413,13 @@ TRACE_EVENT(io_uring_submit_sqe,
 		__entry->opcode		=3D opcode;
 		__entry->flags		=3D flags;
 		__entry->force_nonblock	=3D force_nonblock;
-		__entry->sq_thread	=3D sq_thread;
+
+		__assign_str(op_str, io_uring_get_opcode(opcode));
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%x, "
 		  "non block %d, sq_thread %d", __entry->ctx, __entry->req,
-		  __entry->user_data, io_uring_get_opcode(__entry->opcode),
+		  __entry->user_data, __get_str(op_str),
 		  __entry->flags, __entry->force_nonblock, __entry->sq_thread)
 );
=20
@@ -435,6 +450,8 @@ TRACE_EVENT(io_uring_poll_arm,
 		__field(  u8,			opcode		)
 		__field(  int,			mask		)
 		__field(  int,			events		)
+
+		__string( op_str, io_uring_get_opcode(opcode) )
 	),
=20
 	TP_fast_assign(
@@ -444,11 +461,13 @@ TRACE_EVENT(io_uring_poll_arm,
 		__entry->opcode		=3D opcode;
 		__entry->mask		=3D mask;
 		__entry->events		=3D events;
+
+		__assign_str(op_str, io_uring_get_opcode(opcode));
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
@@ -474,6 +493,8 @@ TRACE_EVENT(io_uring_task_add,
 		__field(  unsigned long long,	user_data	)
 		__field(  u8,			opcode		)
 		__field(  int,			mask		)
+
+		__string( op_str, io_uring_get_opcode(opcode) )
 	),
=20
 	TP_fast_assign(
@@ -482,11 +503,13 @@ TRACE_EVENT(io_uring_task_add,
 		__entry->user_data	=3D user_data;
 		__entry->opcode		=3D opcode;
 		__entry->mask		=3D mask;
+
+		__assign_str(op_str, io_uring_get_opcode(opcode));
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, mask %x",
 		__entry->ctx, __entry->req, __entry->user_data,
-		io_uring_get_opcode(__entry->opcode),
+		__get_str(op_str),
 		__entry->mask)
 );
=20
@@ -523,6 +546,8 @@ TRACE_EVENT(io_uring_req_failed,
 		__field( u64,			pad1		)
 		__field( u64,			addr3		)
 		__field( int,			error		)
+
+		__string( op_str, io_uring_get_opcode(sqe->opcode) )
 	),
=20
 	TP_fast_assign(
@@ -542,6 +567,8 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->pad1		=3D sqe->__pad2[0];
 		__entry->addr3		=3D sqe->addr3;
 		__entry->error		=3D error;
+
+		__assign_str(op_str, io_uring_get_opcode(sqe->opcode));
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, "
@@ -550,7 +577,7 @@ TRACE_EVENT(io_uring_req_failed,
 		  "personality=3D%d, file_index=3D%d, pad=3D0x%llx, addr3=3D%llx, "
 		  "error=3D%d",
 		  __entry->ctx, __entry->req, __entry->user_data,
-		  io_uring_get_opcode(__entry->opcode),
+		  __get_str(op_str),
 		  __entry->flags, __entry->ioprio,
 		  (unsigned long long)__entry->off,
 		  (unsigned long long) __entry->addr, __entry->len,

base-commit: c0737fa9a5a5cf5a053bcc983f72d58919b997c6
--=20
2.30.2

