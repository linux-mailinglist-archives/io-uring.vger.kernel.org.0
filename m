Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3EC631E88
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKUKg3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiKUKgI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:36:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFCF776EC
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:04 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2AKFORoA031703
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=dvEu+E82RJiWZKGF3K/9stvmM4gp2hwml7gpW0WZ6aI=;
 b=PMAUEzsQn5/33ke5XMgF+AuCU5bBohiidQnKntL5uNR1iCGGV/E9JZheFUD6kolNLN16
 ZB3yF4201UIC7oSbkR8SZVYN5ettsrSeggV7ehlbyI4gFl1yDWkfxSjbFyhwryrQYQT0
 6hVge0enxGslUu/sTPbgPuB1SejsN0zy1y0CaJefvO23jIfECjtsjFZM7NCMa0iVSWJV
 q/8GSW1K+Na3C2Un/nE2GIFY3hRIRTof6qNY5wL3GhKZN48vQdgChKKWV4QS5Al0n9p5
 39HO/b6Xr+BFDcNLZTSjpViLdlIG2fxfKC/HbMEObMnhuCjldErC7lDyvEOCqUAASuME nw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3kxuq0c52k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:03 -0800
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:36:02 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 8093C9E66F79; Mon, 21 Nov 2022 02:03:56 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 06/10] io_uring: simplify io_issue_sqe
Date:   Mon, 21 Nov 2022 02:03:49 -0800
Message-ID: <20221121100353.371865-7-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: iIWs-Q1iESQobUmksV3jlTdLMcpqhYx7
X-Proofpoint-GUID: iIWs-Q1iESQobUmksV3jlTdLMcpqhYx7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_issue_sqe can reuse __io_req_complete for completion logic

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 03946f46dadc..2177b3ef094a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1742,12 +1742,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsi=
gned int issue_flags)
 	if (creds)
 		revert_creds(creds);
=20
-	if (ret =3D=3D IOU_OK) {
-		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
-			io_req_complete_defer(req);
-		else
-			io_req_complete_post(req);
-	} else if (ret !=3D IOU_ISSUE_SKIP_COMPLETE)
+	if (ret =3D=3D IOU_OK)
+		__io_req_complete(req, issue_flags);
+	else if (ret !=3D IOU_ISSUE_SKIP_COMPLETE)
 		return ret;
=20
 	/* If the op doesn't have a file, we're not polling for it */
--=20
2.30.2

