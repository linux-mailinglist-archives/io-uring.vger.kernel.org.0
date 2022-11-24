Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD73A637548
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiKXJgj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiKXJge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F3C122941
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:32 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsAvp030074
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=mgxNfn3aBEluRQnXqAqEqXdRp2XqDR3ffSyAA3dJMNQ=;
 b=XsbTsTznG+V6sJCTbTb54X3PL4fSjXBt9gn2cVdbhJRdunff9PHO0ZRtDYLKZx0ja4jj
 zaezayMfDnAYlM4WqYHl8Vu36O1oZ20o/+8KCV9koF2a2uCrd6bA22NsyvJU5VkVNjw4
 iT0Eew6CeBg3EAMyb7iTcM+BWbK5ZBUIA+Q7PXqsjieG7kRs5Y7XjdewqW/3r5QfL7AV
 3V2AveSxnU3yRstMxjFpUwl6HlhUI9sRuoUN/RMfrKsdRb22ThRolPWGaKXN9PV6INWB
 qFNVJ5ucmLBVLT0E7Me6D5aRx+nLR3AZ2DLK4xY3FoPKauX0xWyQrm0mzz6qCbqwmLlw Dg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3m1c7rhj30-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:31 -0800
Received: from twshared41876.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:30 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 29262A173A0D; Thu, 24 Nov 2022 01:36:19 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 2/9] io_uring: always lock in io_apoll_task_func
Date:   Thu, 24 Nov 2022 01:35:52 -0800
Message-ID: <20221124093559.3780686-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Z_0JnM4zdQdfLXbI23D1qMg6k-nthnHX
X-Proofpoint-ORIG-GUID: Z_0JnM4zdQdfLXbI23D1qMg6k-nthnHX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is required for the failure case (io_req_complete_failed) and is
missing.

The alternative would be to only lock in the failure path, however all of
the non-error paths in io_poll_check_events that do not do not return
IOU_POLL_NO_ACTION end up locking anyway. The only extraneous lock would
be for the multishot poll overflowing the CQE ring, however multishot pol=
l
would probably benefit from being locked as it will allow completions to
be batched.

So it seems reasonable to lock always.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/poll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 4624e5eba63e..42aa10b50f6c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -308,11 +308,12 @@ static void io_apoll_task_func(struct io_kiocb *req=
, bool *locked)
 	if (ret =3D=3D IOU_POLL_NO_ACTION)
 		return;
=20
+	io_tw_lock(req->ctx, locked);
 	io_poll_remove_entries(req);
 	io_poll_tw_hash_eject(req, locked);
=20
 	if (ret =3D=3D IOU_POLL_REMOVE_POLL_USE_RES)
-		io_req_complete_post_tw(req, locked);
+		io_req_task_complete(req, locked);
 	else if (ret =3D=3D IOU_POLL_DONE)
 		io_req_task_submit(req, locked);
 	else
--=20
2.30.2

