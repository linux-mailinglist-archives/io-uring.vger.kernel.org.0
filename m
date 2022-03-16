Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB1B4DADD2
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 10:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355043AbiCPJxg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 05:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344258AbiCPJxe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 05:53:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8AA6579A
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 02:52:14 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22FNka4Q007982
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 02:52:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=rwN7J1TrjvPZU4XC4jebgUZ0fGhffKTR8VOhVgHILvQ=;
 b=m5T71jqLjATEEbBI2eNS3FjXfD9TfdndRHS74fUvMo5AHXbJhD/n7OGNDD24N08IDFEC
 z2F07cMBIqdmejSHey9HjebIl2mCbjmb2n2en0yh9zpc5+rskl4Q1gOjzzR9HpVQbQk9
 ZPvfweCl1s2l0Z/3DnEEq9yXTNImFMk7n3Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3etj2ujbgu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 02:52:13 -0700
Received: from twshared11703.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 02:52:11 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 82EAA5C245BB; Wed, 16 Mar 2022 02:52:07 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2] io_uring: make tracing format consistent
Date:   Wed, 16 Mar 2022 02:52:04 -0700
Message-ID: <20220316095204.2191498-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: yqSPYsXhRJ4PwsnF61M5kt6i6Ta9-e3j
X-Proofpoint-ORIG-GUID: yqSPYsXhRJ4PwsnF61M5kt6i6Ta9-e3j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_03,2022-03-15_01,2022-02-23_01
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

Change user_data to 0x%llx and flags to 0x%x everywhere. The '0x' is
useful to disambiguate for example "user_data 100".

Additionally remove the '=3D' for flags in io_uring_req_failed, again for=
 consistency.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---

v2: move everything to hex

 include/trace/events/io_uring.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 18d4341c581c..cddf5b6fbeb4 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -44,7 +44,7 @@ TRACE_EVENT(io_uring_create,
 		__entry->flags		=3D flags;
 	),
=20
-	TP_printk("ring %p, fd %d sq size %d, cq size %d, flags %d",
+	TP_printk("ring %p, fd %d sq size %d, cq size %d, flags 0x%x",
 			  __entry->ctx, __entry->fd, __entry->sq_entries,
 			  __entry->cq_entries, __entry->flags)
 );
@@ -125,7 +125,7 @@ TRACE_EVENT(io_uring_file_get,
 		__entry->fd		=3D fd;
 	),
=20
-	TP_printk("ring %p, req %p, user_data %llu, fd %d",
+	TP_printk("ring %p, req %p, user_data 0x%llx, fd %d",
 		__entry->ctx, __entry->req, __entry->user_data, __entry->fd)
 );
=20
@@ -169,7 +169,7 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__entry->rw		=3D rw;
 	),
=20
-	TP_printk("ring %p, request %p, user_data %llu, opcode %d, flags %d, %s=
 queue, work %p",
+	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %d, flags 0x%x=
, %s queue, work %p",
 		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
 		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
 );
@@ -205,7 +205,7 @@ TRACE_EVENT(io_uring_defer,
 		__entry->opcode	=3D opcode;
 	),
=20
-	TP_printk("ring %p, request %p, user_data %llu, opcode %d",
+	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %d",
 		__entry->ctx, __entry->req, __entry->data, __entry->opcode)
 );
=20
@@ -305,7 +305,7 @@ TRACE_EVENT(io_uring_fail_link,
 		__entry->link		=3D link;
 	),
=20
-	TP_printk("ring %p, request %p, user_data %llu, opcode %d, link %p",
+	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %d, link %p",
 		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
 		__entry->link)
 );
@@ -342,9 +342,9 @@ TRACE_EVENT(io_uring_complete,
 		__entry->cflags		=3D cflags;
 	),
=20
-	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags %x",
+	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x",
 		__entry->ctx, __entry->req,
-		(unsigned long long)__entry->user_data,
+		__entry->user_data,
 		__entry->res, __entry->cflags)
 );
=20
@@ -389,7 +389,7 @@ TRACE_EVENT(io_uring_submit_sqe,
 		__entry->sq_thread	=3D sq_thread;
 	),
=20
-	TP_printk("ring %p, req %p, user_data %llu, opcode %d, flags %u, "
+	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %d, flags 0x%x, "
 		  "non block %d, sq_thread %d", __entry->ctx, __entry->req,
 		  __entry->user_data, __entry->opcode,
 		  __entry->flags, __entry->force_nonblock, __entry->sq_thread)
@@ -433,7 +433,7 @@ TRACE_EVENT(io_uring_poll_arm,
 		__entry->events		=3D events;
 	),
=20
-	TP_printk("ring %p, req %p, user_data %llu, opcode %d, mask 0x%x, event=
s 0x%x",
+	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %d, mask 0x%x, eve=
nts 0x%x",
 		  __entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
 		  __entry->mask, __entry->events)
 );
@@ -470,7 +470,7 @@ TRACE_EVENT(io_uring_task_add,
 		__entry->mask		=3D mask;
 	),
=20
-	TP_printk("ring %p, req %p, user_data %llu, opcode %d, mask %x",
+	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %d, mask %x",
 		__entry->ctx, __entry->req, __entry->user_data, __entry->opcode,
 		__entry->mask)
 );
@@ -529,8 +529,8 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->error		=3D error;
 	),
=20
-	TP_printk("ring %p, req %p, user_data %llu, "
-		"op %d, flags=3D0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
+	TP_printk("ring %p, req %p, user_data 0x%llx, "
+		"op %d, flags 0x%x, prio=3D%d, off=3D%llu, addr=3D%llu, "
 		  "len=3D%u, rw_flags=3D0x%x, buf_index=3D%d, "
 		  "personality=3D%d, file_index=3D%d, pad=3D0x%llx/%llx, error=3D%d",
 		  __entry->ctx, __entry->req, __entry->user_data,

base-commit: f3b6a41eb2bbdf545a42e54d637c34f4b1fdf5b9
--=20
2.30.2

