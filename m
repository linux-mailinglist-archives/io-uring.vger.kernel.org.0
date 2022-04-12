Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480994FE5E2
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiDLQdj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357690AbiDLQd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:33:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933135E16F
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:04 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CChTCQ013738
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=baEaCrnLBHjc8dj+cmCnEDyggTYvxeftZ9u5tqzYlTQ=;
 b=WL6IG/v+96ZbexC5BmYEsm9xxAiTaY3eamthvpYVTqKiZsXSI5a2Gi3l8YHyzrhE6DBq
 BjvDqx39p/bCZpr5BpSh6iIL/oEjxT2ZlP/uvFK7ciIMe1eNV4Ay1EinpGHGjNrDd2Gq
 C8g47Au16XQ3NEUuOs4fmDGmn/SHnC7GRJw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fd9njshky-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:31:04 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 12 Apr 2022 09:31:02 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id A736C745606C; Tue, 12 Apr 2022 09:30:48 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 3/4] io_uring: verify resv is 0 in ringfd register/unregister
Date:   Tue, 12 Apr 2022 09:30:41 -0700
Message-ID: <20220412163042.2788062-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220412163042.2788062-1-dylany@fb.com>
References: <20220412163042.2788062-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wFSsLT0t4tHxKelOAx25EFroDObcyL9x
X-Proofpoint-GUID: wFSsLT0t4tHxKelOAx25EFroDObcyL9x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Only allow resv field to be 0 in struct io_uring_rsrc_update user
arguments.

Fixes: e7a6c00dc77a ("io_uring: add support for registering ring file des=
criptors")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e899192ffb77..a84bfec97d0d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10533,6 +10533,11 @@ static int io_ringfd_register(struct io_ring_ctx=
 *ctx, void __user *__arg,
 			break;
 		}
=20
+		if (reg.resv) {
+			ret =3D -EINVAL;
+			break;
+		}
+
 		if (reg.offset =3D=3D -1U) {
 			start =3D 0;
 			end =3D IO_RINGFD_REG_MAX;
@@ -10579,7 +10584,7 @@ static int io_ringfd_unregister(struct io_ring_ct=
x *ctx, void __user *__arg,
 			ret =3D -EFAULT;
 			break;
 		}
-		if (reg.offset >=3D IO_RINGFD_REG_MAX) {
+		if (reg.resv || reg.offset >=3D IO_RINGFD_REG_MAX) {
 			ret =3D -EINVAL;
 			break;
 		}
--=20
2.30.2

