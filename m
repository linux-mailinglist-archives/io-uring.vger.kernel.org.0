Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC6E554B83
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 15:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352469AbiFVNkz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 09:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350021AbiFVNky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 09:40:54 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C84BC2E
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:49 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MBv4Hu021938
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hfwCHqWRL/G2MjEobDL/8H9IEdqoCYcuPxFEv5aNQ20=;
 b=gjB1Bg1g1/+yfQvF8IyG3xezOj93kvP1fe9ejQ0v04RiSPbgkggDYpoOei+EXefWqf1T
 5wKs9TMpZbK5BzFMnHMKDYDbLL4PZO6eAyjls/1E0J/ulHa0zZWxyXmDKwWaCO3u9DUl
 VkgYbFzVObic450xdeOvK936od0ZxPnu+hI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gv2nagjfh-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:49 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 22 Jun 2022 06:40:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id EBA8A2013AA2; Wed, 22 Jun 2022 06:40:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 7/8] io_uring: add trace event for running task work
Date:   Wed, 22 Jun 2022 06:40:27 -0700
Message-ID: <20220622134028.2013417-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622134028.2013417-1-dylany@fb.com>
References: <20220622134028.2013417-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Pmy_EFTraL4ckEmO_UQCLRIOawNzFZ0y
X-Proofpoint-GUID: Pmy_EFTraL4ckEmO_UQCLRIOawNzFZ0y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-22_04,2022-06-22_03,2022-06-22_01
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

