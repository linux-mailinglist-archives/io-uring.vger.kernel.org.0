Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED9A61F362
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 13:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiKGMeG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 07:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbiKGMeF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 07:34:05 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8790DDFB3
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 04:34:04 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75wXVv010941
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 04:34:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=zX4SYK4qzQGo7IBmJQCn7maiNIh5nF/9k0AMjP0axow=;
 b=Z/TESsZFVLg/v2iAzXj1La8XcGJmQpK6Q9F0EvcuM0aQjzwEbGOdsOgQ0sKxOXXVJ34B
 IAhBHBwG4OqrQ4xzcB5nr7KYgb6hlDHJo83Vmssg1XUxMgUhVuJyrJfqNptTS7XA/Tab
 O/77ePKtbWfp/u6IjKcMXTWYFpOyzUf3hbOybobTpeTB920LiPGeqcnNCZ0QhquCgwYo
 5zn+Xh+KZbqC5G2QiRXSf2rergZkcutZH1F9QecbrVSclYSVSl5hIt/JJI5VjrX6z5td
 TANP8ZVFAsMjJNmOQv2Ha56+eTIbAGT/rI1tf8hcaeT847NMehBXGhPX7NrxS5N+46jq Lw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knk5med5n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 04:34:03 -0800
Received: from twshared14438.02.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 04:34:02 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 6625390D0FF1; Mon,  7 Nov 2022 04:33:50 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next] io_uring: do not always force run task_work in io_uring_register
Date:   Mon, 7 Nov 2022 04:33:49 -0800
Message-ID: <20221107123349.4106213-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dnj1VCOdb27gZNTtvNyz7D5_QQSPj6UJ
X-Proofpoint-GUID: dnj1VCOdb27gZNTtvNyz7D5_QQSPj6UJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_05,2022-11-07_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Running task work when not needed can unnecessarily delay
operations. Specifically IORING_SETUP_DEFER_TASKRUN tries to avoid runnin=
g
task work until the user requests it. Therefore do not run it in
io_uring_register any more.

The one catch is that io_rsrc_ref_quiesce expects it to have run in order
to process all outstanding references, and so reorder it's loop to do thi=
s.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---

Note: I will send a separate liburing test case that would fail without t=
he
changes to io_rsrc_ref_quiesce.


 io_uring/io_uring.c | 2 --
 io_uring/rsrc.c     | 7 ++++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db0dec120f09..112a5918e653 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4050,8 +4050,6 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd=
, unsigned int, opcode,
=20
 	ctx =3D f.file->private_data;
=20
-	io_run_task_work_ctx(ctx);
-
 	mutex_lock(&ctx->uring_lock);
 	ret =3D __io_uring_register(ctx, opcode, arg, nr_args);
 	mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 55d4ab96fb92..187f1c83e779 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -321,6 +321,11 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc=
_data *data,
 		if (atomic_dec_and_test(&data->refs))
 			break;
 		mutex_unlock(&ctx->uring_lock);
+
+		ret =3D io_run_task_work_sig(ctx);
+		if (ret < 0)
+			goto reinit;
+
 		flush_delayed_work(&ctx->rsrc_put_work);
 		ret =3D wait_for_completion_interruptible(&data->done);
 		if (!ret) {
@@ -336,12 +341,12 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsr=
c_data *data,
 			}
 		}
=20
+reinit:
 		atomic_inc(&data->refs);
 		/* wait for all works potentially completing data->done */
 		flush_delayed_work(&ctx->rsrc_put_work);
 		reinit_completion(&data->done);
=20
-		ret =3D io_run_task_work_sig(ctx);
 		mutex_lock(&ctx->uring_lock);
 	} while (ret >=3D 0);
 	data->quiesce =3D false;

base-commit: 765d0e263fccc8b22efef8258c3260e9d0ecf632
--=20
2.30.2

