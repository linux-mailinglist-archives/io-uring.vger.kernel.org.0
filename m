Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA04495F16
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 13:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiAUMjO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 07:39:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46314 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233043AbiAUMjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jan 2022 07:39:14 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L058Cb030354
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 04:39:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=MJjM5p5VnqbQ71P414wy7rrUk33WFWhLW1RkDAtznEg=;
 b=XIwv43f+wBt5VB25kSrTkHZ97QW8uJJ0EXY1JFNkzOmpXAFu2csT7XsvYBq21ZL0uAyV
 z+Tp7vy55voJAH8fSvmX6Xf0DFab3k5k2UtFs7AKx9pdxATxB0jE52bYm8cSYMK5bAvK
 gsVa+b4MpeIkJpu5IiekvYDpduYY9CXnZAI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqhyr2x3p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 04:39:13 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 21 Jan 2022 04:39:11 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 962312C3B749; Fri, 21 Jan 2022 04:39:05 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH] io_uring: fix bug in slow unregistering of nodes
Date:   Fri, 21 Jan 2022 04:38:56 -0800
Message-ID: <20220121123856.3557884-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6RIE5hDBA0_oaDcz1yNChRKgLcDooz2S
X-Proofpoint-GUID: 6RIE5hDBA0_oaDcz1yNChRKgLcDooz2S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 mlxlogscore=748 lowpriorityscore=0 adultscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210085
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In some cases io_rsrc_ref_quiesce will call io_rsrc_node_switch_start,
and then immediately flush the delayed work queue &ctx->rsrc_put_work.

However the percpu_ref_put does not immediately destroy the node, it
will be called asynchronously via RCU. That ends up with
io_rsrc_node_ref_zero only being called after rsrc_put_work has been
flushed, and so the process ends up sleeping for 1 second unnecessarily.

This patch executes the put code immediately if we are busy
quiescing.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e54c4127422e..dd4c801c7afd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7822,10 +7822,15 @@ static __cold void io_rsrc_node_ref_zero(struct p=
ercpu_ref *ref)
 	struct io_ring_ctx *ctx =3D node->rsrc_data->ctx;
 	unsigned long flags;
 	bool first_add =3D false;
+	unsigned long delay =3D HZ;
=20
 	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
 	node->done =3D true;
=20
+	/* if we are mid-quiesce then do not delay */
+	if (node->rsrc_data->quiesce)
+		delay =3D 0;
+
 	while (!list_empty(&ctx->rsrc_ref_list)) {
 		node =3D list_first_entry(&ctx->rsrc_ref_list,
 					    struct io_rsrc_node, node);
@@ -7838,7 +7843,7 @@ static __cold void io_rsrc_node_ref_zero(struct per=
cpu_ref *ref)
 	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
=20
 	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
=20
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
--=20
2.30.2

