Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F33509BF2
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiDUJT4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387545AbiDUJTt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:19:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805CB11A09
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:59 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23L7Ai07007753
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=OvpskX5wjD7culEON5XL98GA5r5k8R6m/m81IDYjyjQ=;
 b=NT/b0dr9o2DbaGRdOCamlPlQidzL9kWJUAJavXx5s/MN1DSTiWs4WVcCoSZJDSsZEd/v
 4WFYyfX7eSp4EjGkGalTRRifctCpItLVQrtRMCbYoMISlhL+LXU50yFMvhhlIcKqp7xo
 YxhsEnOS/rtiBRr/donuuYLWxNLhgRh/Ul4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fj7k3hetb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:16:58 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:16:57 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id EFD7B7CA75FE; Thu, 21 Apr 2022 02:14:01 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 3/6] io_uring: rework io_uring_enter to simplify return value
Date:   Thu, 21 Apr 2022 02:13:42 -0700
Message-ID: <20220421091345.2115755-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421091345.2115755-1-dylany@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: iIAhVwGvjbO_AAS7n1sukl_g8EseZRxH
X-Proofpoint-GUID: iIAhVwGvjbO_AAS7n1sukl_g8EseZRxH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_enter returns the count submitted preferrably over an error
code. In some code paths this check is not required, so reorganise the
code so that the check is only done as needed.
This is also a prep for returning error codes only in waiting scenarios.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d654faffa486..1837b3afa47f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10843,7 +10843,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd,=
 u32, to_submit,
 		size_t, argsz)
 {
 	struct io_ring_ctx *ctx;
-	int submitted =3D 0;
 	struct fd f;
 	long ret;
=20
@@ -10906,15 +10905,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, f=
d, u32, to_submit,
 			if (ret)
 				goto out;
 		}
-		submitted =3D to_submit;
+		ret =3D to_submit;
 	} else if (to_submit) {
 		ret =3D io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
=20
 		mutex_lock(&ctx->uring_lock);
-		submitted =3D io_submit_sqes(ctx, to_submit);
-		if (submitted !=3D to_submit) {
+		ret =3D io_submit_sqes(ctx, to_submit);
+		if (ret !=3D to_submit) {
 			mutex_unlock(&ctx->uring_lock);
 			goto out;
 		}
@@ -10923,6 +10922,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd,=
 u32, to_submit,
 		mutex_unlock(&ctx->uring_lock);
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
+		int ret2;
 		if (ctx->syscall_iopoll) {
 			/*
 			 * We disallow the app entering submit/complete with
@@ -10932,22 +10932,29 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, f=
d, u32, to_submit,
 			 */
 			mutex_lock(&ctx->uring_lock);
 iopoll_locked:
-			ret =3D io_validate_ext_arg(flags, argp, argsz);
-			if (likely(!ret)) {
-				min_complete =3D min(min_complete, ctx->cq_entries);
-				ret =3D io_iopoll_check(ctx, min_complete);
+			ret2 =3D io_validate_ext_arg(flags, argp, argsz);
+			if (likely(!ret2)) {
+				min_complete =3D min(min_complete,
+						   ctx->cq_entries);
+				ret2 =3D io_iopoll_check(ctx, min_complete);
 			}
 			mutex_unlock(&ctx->uring_lock);
 		} else {
 			const sigset_t __user *sig;
 			struct __kernel_timespec __user *ts;
=20
-			ret =3D io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
-			if (unlikely(ret))
-				goto out;
-			min_complete =3D min(min_complete, ctx->cq_entries);
-			ret =3D io_cqring_wait(ctx, min_complete, sig, argsz, ts);
+			ret2 =3D io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
+			if (likely(!ret2)) {
+				min_complete =3D min(min_complete,
+						   ctx->cq_entries);
+				ret2 =3D io_cqring_wait(ctx, min_complete, sig,
+						      argsz, ts);
+			}
 		}
+
+		if (!ret)
+			ret =3D ret2;
+
 	}
=20
 out:
@@ -10955,7 +10962,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd,=
 u32, to_submit,
 out_fput:
 	if (!(flags & IORING_ENTER_REGISTERED_RING))
 		fdput(f);
-	return submitted ? submitted : ret;
+	return ret;
 }
=20
 #ifdef CONFIG_PROC_FS
--=20
2.30.2

