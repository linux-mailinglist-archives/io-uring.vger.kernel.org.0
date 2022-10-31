Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12EB613839
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiJaNlw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiJaNlt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7441101F9
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFlun017676
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=+NkB8T1Po+tB+NzCUUiTtsUN5Agdo5SQlSRuA8WLxo4=;
 b=nbusQJdXHHnLHzMCjW/cjNsLXkeCvTp6o8A8I5twY66xqkN2b5b3raaQCCTvLmziwfJJ
 asiwW47RDmJHgR3xYJTOR8m0Co7PTs9UeDeuakMl0aTURjHb0mtHsg3coY7vjvcs/yWV
 jVyqyCwJdLcpybSg1d94hQwDhyfPUCw4WtD6TQzcHSQzGE9QnASm5XSR/uDXHH1Gtrv+
 dkEdI5LYSDBGyRAVLQZP4a3kaeUxtTdMS5CJYrPPs8LzguStuUI469XoiK8rECjZ8Su1
 czAKXLDO+DevcFQ5Y6cvA+wxQOL1/GyXFsm6In5URuTrCwSNdG4bMFSNcyWcHHLzICXh yA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kgygu6djh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:48 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub204.TheFacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:47 -0700
Received: from twshared6758.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id BAA7D8A1964E; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 04/12] io_uring: reschedule retargeting at shutdown of ring
Date:   Mon, 31 Oct 2022 06:41:18 -0700
Message-ID: <20221031134126.82928-5-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0ubRqP8FvBiDEsTCUEac340z3VAMNUcJ
X-Proofpoint-GUID: 0ubRqP8FvBiDEsTCUEac340z3VAMNUcJ
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

When the ring shuts down, instead of waiting for the work to release it's
reference, just reschedule it to now and get the reference back that way.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c |  1 +
 io_uring/rsrc.c     | 26 +++++++++++++++++++++-----
 io_uring/rsrc.h     |  1 +
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ea2260359c56..32eb305c4ce7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2751,6 +2751,7 @@ static __cold void io_ring_exit_work(struct work_st=
ruct *work)
 		}
=20
 		io_req_caches_free(ctx);
+		io_rsrc_retarget_exiting(ctx);
=20
 		if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
 			/* there is little hope left, don't run it too often */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8d0d40713a63..40b37899e943 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -248,12 +248,20 @@ static unsigned int io_rsrc_retarget_table(struct i=
o_ring_ctx *ctx,
 	return refs;
 }
=20
-static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx)
+static void io_rsrc_retarget_schedule(struct io_ring_ctx *ctx, bool dela=
y)
 	__must_hold(&ctx->uring_lock)
 {
-	percpu_ref_get(&ctx->refs);
-	mod_delayed_work(system_wq, &ctx->rsrc_retarget_work, 60 * HZ);
-	ctx->rsrc_retarget_scheduled =3D true;
+	unsigned long del;
+
+	if (delay)
+		del =3D 60 * HZ;
+	else
+		del =3D 0;
+
+	if (likely(!mod_delayed_work(system_wq, &ctx->rsrc_retarget_work, del))=
) {
+		percpu_ref_get(&ctx->refs);
+		ctx->rsrc_retarget_scheduled =3D true;
+	}
 }
=20
 static void io_retarget_rsrc_wq_cb(struct io_wq_work *work, void *data)
@@ -332,6 +340,14 @@ void io_rsrc_retarget_work(struct work_struct *work)
 	percpu_ref_put(&ctx->refs);
 }
=20
+void io_rsrc_retarget_exiting(struct io_ring_ctx *ctx)
+{
+	mutex_lock(&ctx->uring_lock);
+	if (ctx->rsrc_retarget_scheduled)
+		io_rsrc_retarget_schedule(ctx, false);
+	mutex_unlock(&ctx->uring_lock);
+}
+
 void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
 	if (data && !atomic_dec_and_test(&data->refs))
@@ -414,7 +430,7 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		percpu_ref_kill(&rsrc_node->refs);
 		ctx->rsrc_node =3D NULL;
 		if (!ctx->rsrc_retarget_scheduled)
-			io_rsrc_retarget_schedule(ctx);
+			io_rsrc_retarget_schedule(ctx, true);
 	}
=20
 	if (!ctx->rsrc_node) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 2b94df8fd9e8..93c66475796e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -55,6 +55,7 @@ struct io_mapped_ubuf {
=20
 void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_retarget_work(struct work_struct *work);
+void io_rsrc_retarget_exiting(struct io_ring_ctx *ctx);
 void io_rsrc_refs_refill(struct io_ring_ctx *ctx);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
 void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
--=20
2.30.2

