Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624A6638795
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 11:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiKYKee (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 05:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiKYKed (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 05:34:33 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D19331369
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:32 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APA8pL7027508
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=zRnNbzQplCPqbQ8YDFhZkzknA3sqTPe8tykIwMwY438=;
 b=EpLs3eODaHvYn8+hIfOjWs1OAEmNlRnNnSnKnqdZLVNQiwZZT8yfPKM0xnqz6dUZVRMF
 Gsso7QMykWwex9yGdp1i8eCicNeKopX2HdQl7mo8KU6HvlkDqv+xk9/G5/cmlln3J4PE
 J/PSTPMCFrTUWRT0BGfMYasyTqsgNURDjDfTiI3BLV/nx9tv9KBM527mxP2PP3foyd9Z
 nTGRUlVEUdDG5IqVgX43XyvQyofU/R7aeLzYUqC14xsuTc+B5AQfsHFf2l0/O1wGflO/
 JqKs8bFiEly1MNbaYm59618VmEAPiRZ1hf5wl52PQXYMK+A9NGt4PDSSjuvvHk0RtiQu fw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m2upf84eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:31 -0800
Received: from twshared8047.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 02:34:30 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E71C8A283EC9; Fri, 25 Nov 2022 02:34:20 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 2/3] io_uring: spelling fix
Date:   Fri, 25 Nov 2022 02:34:11 -0800
Message-ID: <20221125103412.1425305-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221125103412.1425305-1-dylany@meta.com>
References: <20221125103412.1425305-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: e0-qjlRvi7nPKJD7QLy7F4YvxOvZAZrO
X-Proofpoint-ORIG-GUID: e0-qjlRvi7nPKJD7QLy7F4YvxOvZAZrO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

s/pushs/pushes/

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 38589cf380d1..c1e84ef84bea 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2708,7 +2708,7 @@ static __poll_t io_uring_poll(struct file *file, po=
ll_table *wait)
 	 * lock(&ep->mtx);
 	 *
 	 * Users may get EPOLLIN meanwhile seeing nothing in cqring, this
-	 * pushs them to do the flush.
+	 * pushes them to do the flush.
 	 */
=20
 	if (io_cqring_events(ctx) || io_has_work(ctx))
--=20
2.30.2

