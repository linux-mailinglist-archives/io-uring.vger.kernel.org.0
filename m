Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC3F5EAA18
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiIZPRk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiIZPQs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:16:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781A427D
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:25 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28Q9OiHT020937
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=k8e9XhReGPOptOw1DYeKjrBV9CjaPrV9yHOCxxhlJFU=;
 b=lppCbCxFHVAzTHD+1WMAbeJS6i673QDtY5cBg4uEkuamPn+oy8k1FiyHHKfb38NmwmYU
 OOUITycrHWoqRVSxUOWqh8+I1CXUmhno49cHUpAs3vAPRwr4PDZb/Zi3Qiiuu1lMBsoi
 zenam7B5yS2RQyFZ1FnlwJCX79g5nanUrzc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jswjuk8w9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:24 -0700
Received: from twshared2996.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 07:03:23 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 7E8636AEBEF6; Mon, 26 Sep 2022 07:03:17 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 1/3] io_uring: register single issuer task at creation
Date:   Mon, 26 Sep 2022 07:03:02 -0700
Message-ID: <20220926140304.1973990-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220926140304.1973990-1-dylany@fb.com>
References: <20220926140304.1973990-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: LDlQn4xe-rT73bCpyjp-ywZHcAnT6GpK
X-Proofpoint-ORIG-GUID: LDlQn4xe-rT73bCpyjp-ywZHcAnT6GpK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of picking the task from the first submitter task, rather use the
creator task.
The downside of this is that users are unable to move tasks before
submitting.

However this simplifies the logic here. For example CQEs are able to be
posted by io_uring_register, which could also be from a separate
task. This could be confusing as this does not count as a submit, and so
would not be the registered task.

Additionally this removes init logic from the submission path, which can
always be a bit confusing.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2965b354efc8..3f40defd721d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3357,6 +3357,9 @@ static __cold int io_uring_create(unsigned entries,=
 struct io_uring_params *p,
 		goto err;
 	}
=20
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER)
+		ctx->submitter_task =3D get_task_struct(current);
+
 	file =3D io_uring_get_file(ctx);
 	if (IS_ERR(file)) {
 		ret =3D PTR_ERR(file);
--=20
2.30.2

