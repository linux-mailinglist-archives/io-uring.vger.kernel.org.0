Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EABB4FE5E3
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357653AbiDLQdf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357687AbiDLQd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:33:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2775DE7B
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:00 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23C3cmBY027695
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/xid/OpYx6XCeq/M4GKH/83yAYcqpeMppbcM1h1pC9A=;
 b=dXr07BQTNyBfiETeamRqkqnDYW/klgyTd7oLea0vjuEwKXNTTSMFlnPE2vP7dDwTqPJq
 WDE4a3R4OiM/fHOx3iHGWemGNKTQYnCEM9cr8oCRif4PCzsJT5Tej0qTUXQz01iJJrjm
 YgVIjnOd5rYrSzJaCopGwBuVuEtHQajhbZI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fd1pwkhjc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:30:59 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 12 Apr 2022 09:30:58 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 97FA07456064; Tue, 12 Apr 2022 09:30:47 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 1/4] io_uring: move io_uring_rsrc_update2 validation
Date:   Tue, 12 Apr 2022 09:30:39 -0700
Message-ID: <20220412163042.2788062-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220412163042.2788062-1-dylany@fb.com>
References: <20220412163042.2788062-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: jX-VDh7LeSh3vynA3GCmOF1QCT1GCjNT
X-Proofpoint-ORIG-GUID: jX-VDh7LeSh3vynA3GCmOF1QCT1GCjNT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move validation to be more consistently straight after
copy_from_user. This is already done in io_register_rsrc_update and so
this removes that redundant check.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8a931eb8a3a6..58bfa71fe3b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11398,8 +11398,6 @@ static int __io_register_rsrc_update(struct io_ri=
ng_ctx *ctx, unsigned type,
 	__u32 tmp;
 	int err;
=20
-	if (up->resv)
-		return -EINVAL;
 	if (check_add_overflow(up->offset, nr_args, &tmp))
 		return -EOVERFLOW;
 	err =3D io_rsrc_node_switch_start(ctx);
@@ -11425,6 +11423,8 @@ static int io_register_files_update(struct io_rin=
g_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
+	if (up.resv)
+		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
=20
--=20
2.30.2

