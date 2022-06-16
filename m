Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B1654E27A
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiFPNua (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 09:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiFPNua (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 09:50:30 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A49B2CDFA
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 06:50:29 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25G5Qjpr004146
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 06:50:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=xgiT0hf9YMJns6tEeuVyRefFvM9LnCSpuA0KlLIA5d0=;
 b=WyHt7/WCy6wfmCYK2ggABsLW0KPMtxK0vaoPPnSrgKkoYV9j4PCBECFVDuFcXF4BLNFO
 WSy2jsEZ8bMC0LakD5Wqdd5Td8dQEcWBHAzHdJOSpp+Xyd3/GjN21LqtlkT+dA8gMNir
 xw0uJLMgfmaHxQI7FeA9SW5fgP25KbRfoMk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gqxc5veks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 06:50:28 -0700
Received: from twshared5131.09.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 16 Jun 2022 06:50:27 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id CC4321BD269C; Thu, 16 Jun 2022 06:50:13 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 5.19] io_uring: do not use prio task_work_add in uring_cmd
Date:   Thu, 16 Jun 2022 06:50:11 -0700
Message-ID: <20220616135011.441980-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NHKryoYpmCBM8piBTEPnqH95YfT1Z-ge
X-Proofpoint-ORIG-GUID: NHKryoYpmCBM8piBTEPnqH95YfT1Z-ge
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_09,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_task_prio_work_add has a strict assumption that it will only be
used with io_req_task_complete. There is a codepath that assumes this is
the case and will not even call the completion function if it is hit.

For uring_cmd with an arbitrary completion function change the call to th=
e
correct non-priority version.

Fixes: ee692a21e9bf8 ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3aab4182fd89..a7ac2d3bce76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5079,7 +5079,7 @@ void io_uring_cmd_complete_in_task(struct io_uring_=
cmd *ioucmd,
=20
 	req->uring_cmd.task_work_cb =3D task_work_cb;
 	req->io_task_work.func =3D io_uring_cmd_work;
-	io_req_task_prio_work_add(req);
+	io_req_task_work_add(req);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
=20

base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
--=20
2.30.2

