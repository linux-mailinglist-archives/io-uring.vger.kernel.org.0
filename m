Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0184350E40C
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 17:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiDYPLN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 11:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242753AbiDYPLM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 11:11:12 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790B468F81
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 08:08:06 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23P9eb5N011793
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 08:08:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aBPXzgAor9ID7HP4sIVxr9DIdpBiUHtJ5j3QdPwb7Ng=;
 b=L7xGR/FZDQOC/hJxUwIfaTXPskw1sSwBLM1nAfaGkvJ5aeO1yOHX0euQ4tTB3GNhveH1
 ZF426k+YdQmuEIe3SQrYx7H9a6OV1HLNOXOGTMAJaf5UZdWD4yAACg1UvzSKbJF7cCty
 1h5VIBbsEvGzgS09lqLBmSzvEAUEjU3QCfQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmeyttfmn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 08:08:05 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 08:08:03 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id C82EF811B434; Mon, 25 Apr 2022 08:07:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 4/4] io_uring: use the text representation of ops in trace
Date:   Mon, 25 Apr 2022 08:07:40 -0700
Message-ID: <20220425150740.2826784-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425150740.2826784-1-dylany@fb.com>
References: <20220425150740.2826784-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: OBPRbBHwyoHoyc7cAoNFFZzIFbbafq0h
X-Proofpoint-ORIG-GUID: OBPRbBHwyoHoyc7cAoNFFZzIFbbafq0h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_08,2022-04-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is annoying to translate opcodes to textwhen tracing io_uring. Use the
io_uring_get_opcode function instead to use the text representation.

A downside here might have been that if the opcode is invalid it will not
be obvious, however the opcode is already overridden in these cases to
0 (NOP) in io_init_req(). Therefore this is a non issue.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 42 ++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index c122d2167aa4..240afbb75302 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -7,6 +7,7 @@
=20
 #include <linux/tracepoint.h>
 #include <uapi/linux/io_uring.h>
+#include <linux/io_uring.h>
=20
 struct io_wq_work;
=20
@@ -87,9 +88,11 @@ TRACE_EVENT(io_uring_register,
 		__entry->ret		=3D ret;
 	),
=20
-	TP_printk("ring %p, opcode %d, nr_user_files %d, nr_user_bufs %d, "
+	TP_printk("ring %p, opcode %s, nr_user_files %d, nr_user_bufs %d, "
 			  "ret %ld",
-			  __entry->ctx, __entry->opcode, __entry->nr_files,
+			  __entry->ctx,
+			  io_uring_get_opcode(__entry->opcode),
+			  __entry->nr_files,
 			  __entry->nr_bufs, __entry->ret)
 );
=20
@@ -169,8 +172,9 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__entry->rw		=3D rw;
 	),
=20
-	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %d, flags 0x%x=
, %s queue, work %p",
-		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
+	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%x=
, %s queue, work %p",
+		__entry->ctx, __entry->req, __entry->user_data,
+		io_uring_get_opcode(__entry->opcode),
 		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
 );
=20
@@ -205,8 +209,9 @@ TRACE_EVENT(io_uring_defer,
 		__entry->opcode	=3D opcode;
 	),
=20
-	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %d",
-		__entry->ctx, __entry->req, __entry->data, __entry->opcode)
+	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s",
+		__entry->ctx, __entry->req, __entry->data,
+		io_uring_get_opcode(__entry->opcode))
 );
=20
 /**
@@ -305,9 +310,9 @@ TRACE_EVENT(io_uring_fail_link,
 		__entry->link		=3D link;
 	),
=20
-	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %d, link %p",
-		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
-		__entry->link)
+	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, link %p",
+		__entry->ctx, __entry->req, __entry->user_data,
+		io_uring_get_opcode(__entry->opcode), __entry->link)
 );
=20
 /**
@@ -389,9 +394,9 @@ TRACE_EVENT(io_uring_submit_sqe,
 		__entry->sq_thread	=3D sq_thread;
 	),
=20
-	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %d, flags 0x%x, "
+	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%x, "
 		  "non block %d, sq_thread %d", __entry->ctx, __entry->req,
-		  __entry->user_data, __entry->opcode,
+		  __entry->user_data, io_uring_get_opcode(__entry->opcode),
 		  __entry->flags, __entry->force_nonblock, __entry->sq_thread)
 );
=20
@@ -433,8 +438,9 @@ TRACE_EVENT(io_uring_poll_arm,
 		__entry->events		=3D events;
 	),
=20
-	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %d, mask 0x%x, eve=
nts 0x%x",
-		  __entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
+	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, mask 0x%x, eve=
nts 0x%x",
+		  __entry->ctx, __entry->req, __entry->user_data,
+		  io_uring_get_opcode(__entry->opcode),
 		  __entry->mask, __entry->events)
 );
=20
@@ -470,8 +476,9 @@ TRACE_EVENT(io_uring_task_add,
 		__entry->mask		=3D mask;
 	),
=20
-	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %d, mask %x",
-		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
+	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, mask %x",
+		__entry->ctx, __entry->req, __entry->user_data,
+		io_uring_get_opcode(__entry->opcode),
 		__entry->mask)
 );
=20
@@ -530,11 +537,12 @@ TRACE_EVENT(io_uring_req_failed,
 	),
=20
 	TP_printk("ring %p, req %p, user_data 0x%llx, "
-		  "opcode %d, flags 0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
+		  "opcode %s, flags 0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
 		  "len=3D%u, rw_flags=3D0x%x, buf_index=3D%d, "
 		  "personality=3D%d, file_index=3D%d, pad=3D0x%llx/%llx, error=3D%d",
 		  __entry->ctx, __entry->req, __entry->user_data,
-		  __entry->opcode, __entry->flags, __entry->ioprio,
+		  io_uring_get_opcode(__entry->opcode),
+		  __entry->flags, __entry->ioprio,
 		  (unsigned long long)__entry->off,
 		  (unsigned long long) __entry->addr, __entry->len,
 		  __entry->op_flags,
--=20
2.30.2

