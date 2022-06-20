Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F1E552217
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 18:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiFTQTW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 12:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244092AbiFTQTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 12:19:20 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41B81A394
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:19 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFI9tE007343
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hfwCHqWRL/G2MjEobDL/8H9IEdqoCYcuPxFEv5aNQ20=;
 b=FZ0dk5qe4K4rkW+maSbsejzY1ty6Tt2/ug6VgtickeZq5sqmnL7nHBkL/Tkwj59tjy91
 kJjntOLCWPAbm0bTXlQDDHkW8bxhqU+eRei9hrQYH94SSVY6wbf3bLOHc2Xt/IBqi5c5
 29KMvhGXI3mAANXonILP9lITtuOHVZtlzaU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gttyngmye-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:18 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 09:19:17 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B09F51EB9447; Mon, 20 Jun 2022 09:19:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC for-next 7/8] io_uring: add trace event for running task work
Date:   Mon, 20 Jun 2022 09:19:00 -0700
Message-ID: <20220620161901.1181971-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620161901.1181971-1-dylany@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: y1Unt_2vR78SAKCIrp_Ir_iMbNHhQF5r
X-Proofpoint-ORIG-GUID: y1Unt_2vR78SAKCIrp_Ir_iMbNHhQF5r
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

This is useful for investigating if task_work is batching

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/trace/events/io_uring.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 3bc8dec9acaa..918e3a43e4b2 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -600,6 +600,36 @@ TRACE_EVENT(io_uring_cqe_overflow,
 		  __entry->cflags, __entry->ocqe)
 );
=20
+/*
+ * io_uring_task_work_run - ran task work
+ *
+ * @tctx:		pointer to a io_uring_task
+ * @count:		how many functions it ran
+ * @loops:		how many loops it ran
+ *
+ */
+TRACE_EVENT(io_uring_task_work_run,
+
+	TP_PROTO(void *tctx, unsigned int count, unsigned int loops),
+
+	TP_ARGS(tctx, count, loops),
+
+	TP_STRUCT__entry (
+		__field(  void *,		tctx		)
+		__field(  unsigned int,		count		)
+		__field(  unsigned int,		loops		)
+	),
+
+	TP_fast_assign(
+		__entry->tctx		=3D tctx;
+		__entry->count		=3D count;
+		__entry->loops		=3D loops;
+	),
+
+	TP_printk("tctx %p, count %u, loops %u",
+		 __entry->tctx, __entry->count, __entry->loops)
+);
+
 #endif /* _TRACE_IO_URING_H */
=20
 /* This part must be outside protection */
--=20
2.30.2

