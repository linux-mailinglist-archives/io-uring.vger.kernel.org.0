Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF860FAB8
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 16:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiJ0Opg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 10:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbiJ0OpS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 10:45:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB635143E
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:47 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RCQiFv028594
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=12liYapi0VFx3n1Mqiv8jke831v291xACgfAGon9CDk=;
 b=m/2rF6IMe66uOzT8PJ3zddaB/4TXTLkLha5ZBYjs9Qfu1Bi0SYL3vnziXPiB5Rlv1dQ1
 CzCNtBr8lmSWgmtkMqFvws9XclSZwEfowqjqC32RgybjVGAS2J5OsAh2z376pN0l0g2b
 0eydZv7nXH0wqBtbVqfat4KwAVA9/355pxjo+u/wOYZjwKwtIVhVmCw7yYzhSyk+O4DK
 ZhGu77cyIsOikrc41q3g/dPmk7EDyEFF6U8KZpfRYxc9G2omt8hPEMqY8V/gZUBquCxB
 dY8PdawBa9TprvsKINKadUTAeb0RecRIUY9vZCh/WMMj3QJKe/riPycg+74S+FPlN8aH QQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kfagyhnrm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:47 -0700
Received: from twshared3704.02.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:44:46 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id EDD038673CB2; Thu, 27 Oct 2022 07:44:34 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH 1/2] io_uring: use io_run_local_work_locked helper
Date:   Thu, 27 Oct 2022 07:44:28 -0700
Message-ID: <20221027144429.3971400-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221027144429.3971400-1-dylany@meta.com>
References: <20221027144429.3971400-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: UXjdHdXg-nLDqc5pNC3udn8wXRyNgqD4
X-Proofpoint-ORIG-GUID: UXjdHdXg-nLDqc5pNC3udn8wXRyNgqD4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

prefer to use io_run_local_work_locked helper for consistency

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cc16e39b27f..8a0ce7379e89 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1446,8 +1446,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx,=
 long min)
 		    io_task_work_pending(ctx)) {
 			u32 tail =3D ctx->cached_cq_tail;
=20
-			if (!llist_empty(&ctx->work_llist))
-				__io_run_local_work(ctx, true);
+			(void) io_run_local_work_locked(ctx);
=20
 			if (task_work_pending(current) ||
 			    wq_list_empty(&ctx->iopoll_list)) {
--=20
2.30.2

