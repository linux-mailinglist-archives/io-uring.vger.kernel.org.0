Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477744FE5E0
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357705AbiDLQdd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357711AbiDLQdb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:33:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6745DE6B
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:07 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CCgNs0012649
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jpJLwlCd/Lo6d9EOp1tU7k+L8lqn56Qe1VGs4ldSBt0=;
 b=lhDW+wS1PWX7Dd5U0d5//NRgork1OIGL5UlZ3DkxJHOrEGqG+gCYCAv/SvVcEgTgQX14
 S5vwRH08+ID1Yp+Qpjf9pPxN2VXUgVs+ZNZFVvbXUwIJ+abYyVPApBmOqK8GqetsPPco
 9vESh4MnV7ZgKMqu2zzMsr+1yv428IFNEyk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fd9njshmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:07 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 12 Apr 2022 09:31:01 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 398667456066; Tue, 12 Apr 2022 09:30:48 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 2/4] io_uring: verify that resv2 is 0 in io_uring_rsrc_update2
Date:   Tue, 12 Apr 2022 09:30:40 -0700
Message-ID: <20220412163042.2788062-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220412163042.2788062-1-dylany@fb.com>
References: <20220412163042.2788062-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LsNWjirxy3uUsQw2G3T6FmYzsoVvrmjc
X-Proofpoint-GUID: LsNWjirxy3uUsQw2G3T6FmYzsoVvrmjc
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

Verify that the user does not pass in anything but 0 for this field.

Fixes: 992da01aa932 ("io_uring: change registration/upd/rsrc tagging ABI"=
)
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 58bfa71fe3b6..e899192ffb77 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6839,6 +6839,7 @@ static int io_files_update(struct io_kiocb *req, un=
signed int issue_flags)
 	up.nr =3D 0;
 	up.tags =3D 0;
 	up.resv =3D 0;
+	up.resv2 =3D 0;
=20
 	io_ring_submit_lock(ctx, needs_lock);
 	ret =3D __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
@@ -11423,7 +11424,7 @@ static int io_register_files_update(struct io_rin=
g_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
-	if (up.resv)
+	if (up.resv || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
@@ -11437,7 +11438,7 @@ static int io_register_rsrc_update(struct io_ring=
_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
-	if (!up.nr || up.resv)
+	if (!up.nr || up.resv || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, type, &up, up.nr);
 }
--=20
2.30.2

