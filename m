Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6FC61383A
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiJaNlw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiJaNlt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41C8101FA
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFZhC018811
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=U7L3ksaXouKD+oVaCFiQ0CZIndC7HTcK8vsAc5fbv34=;
 b=gevDVRfJR1+zZG5vkDeh4ON7TejlkHu96fOSH8yDOIe6HLoNpkBLJbhWscAhbBjgjP/I
 ORoTnnAzIYbvQRbPNMngakG9fJBgV4STZSCqvrqHqvmDQDQ3lEmAuJqONlzEUTyFWIap
 fk4zrgSAoDEHlBxo3Js9Z6CHJN9pWFesNC+ZeOcH7s0oAG+KhmtWnSH83BE0t9rbgdP3
 6TeOhBHLjygoFYB8+52vwoWYwB2pVP8jTkdpf5N3XRllXOoQ1CH+kPDl4iwouBEmS/Q8
 sFl8MhtC4ntx4XprN04PgpJbxxT3gl0DQ5bGb4Q3oljkGOw73DtopVPPaiBwXUbUfMNZ jw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1vpwwh9-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700
Received: from twshared6758.06.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C16DA8A19650; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 05/12] io_uring: add tracing for io_uring_rsrc_retarget
Date:   Mon, 31 Oct 2022 06:41:19 -0700
Message-ID: <20221031134126.82928-6-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: vOKVqMwLxcWki8bEWpr85qKhM-JdUIx4
X-Proofpoint-ORIG-GUID: vOKVqMwLxcWki8bEWpr85qKhM-JdUIx4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_15,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add event tracing to show how many poll/wq requests were retargeted

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 include/trace/events/io_uring.h | 30 ++++++++++++++++++++++++++++++
 io_uring/rsrc.c                 |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 936fd41bf147..b47be89dd270 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -684,6 +684,36 @@ TRACE_EVENT(io_uring_local_work_run,
 	TP_printk("ring %p, count %d, loops %u", __entry->ctx, __entry->count, =
__entry->loops)
 );
=20
+/*
+ * io_uring_rsrc_retarget - ran a rsrc retarget
+ *
+ * @ctx:		pointer to a io_uring_ctx
+ * @poll:		how many retargeted that were polling
+ * @wq:			how many retargeted that were in the wq
+ *
+ */
+TRACE_EVENT(io_uring_rsrc_retarget,
+
+	TP_PROTO(void *ctx, unsigned int poll, unsigned int wq),
+
+	TP_ARGS(ctx, poll, wq),
+
+	TP_STRUCT__entry(
+		__field(void *,		ctx)
+		__field(unsigned int,	poll)
+		__field(unsigned int,	wq)
+	),
+
+	TP_fast_assign(
+		__entry->ctx		=3D ctx;
+		__entry->poll		=3D poll;
+		__entry->wq		=3D wq;
+	),
+
+	TP_printk("ring %p, poll %u, wq %u",
+		  __entry->ctx, __entry->poll, __entry->wq)
+);
+
 #endif /* _TRACE_IO_URING_H */
=20
 /* This part must be outside protection */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 40b37899e943..00402533cee5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -325,6 +325,8 @@ static void __io_rsrc_retarget_work(struct io_ring_ct=
x *ctx)
 	ctx->rsrc_cached_refs -=3D (poll_refs + data.refs);
 	while (unlikely(ctx->rsrc_cached_refs < 0))
 		io_rsrc_refs_refill(ctx);
+
+	trace_io_uring_rsrc_retarget(ctx, poll_refs, data.refs);
 }
=20
 void io_rsrc_retarget_work(struct work_struct *work)
--=20
2.30.2

