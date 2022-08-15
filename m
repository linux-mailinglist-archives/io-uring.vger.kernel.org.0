Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA37592F76
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbiHONMU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242685AbiHONMS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:12:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7AC17057
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:16 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27F9QUo2026724
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=91dHoMzh5UndC2wHuZYuVqMRFnFIjaZ+zV7d4uf9Nwo=;
 b=XaBPEEoCKmdS7Gb9O+oi0lvNZojcAIMXddg78Cxc3cktiRQxpD+8fAglZEPAQH7hMwoo
 UULMY4hsGD69BsbDCUUTjizQyjtu+BbtHmchDLtO8X5QRXasfQe+FTjx1Cj37Mva8G6p
 4LI3c0G9OWJtb4Qqe02ZablD0eXVFRxdyMQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hykfy0wq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:15 -0700
Received: from twshared25684.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:12:14 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id EA70E49B6CBB; Mon, 15 Aug 2022 06:09:15 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 6/7] io_uring: move io_eventfd_put
Date:   Mon, 15 Aug 2022 06:09:10 -0700
Message-ID: <20220815130911.988014-7-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130911.988014-1-dylany@fb.com>
References: <20220815130911.988014-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fbY_3vQ7LzZgbNsxOX_-52gZi411nAbj
X-Proofpoint-ORIG-GUID: fbY_3vQ7LzZgbNsxOX_-52gZi411nAbj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Non functional change: move this function above io_eventfd_signal so it
can be used from there

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 35edeed1bcc1..70fa075c6887 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -478,6 +478,14 @@ static __cold void io_queue_deferred(struct io_ring_=
ctx *ctx)
 	}
 }
=20
+static void io_eventfd_put(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd =3D container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
+}
+
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd;
@@ -2452,14 +2460,6 @@ static int io_eventfd_register(struct io_ring_ctx =
*ctx, void __user *arg,
 	return 0;
 }
=20
-static void io_eventfd_put(struct rcu_head *rcu)
-{
-	struct io_ev_fd *ev_fd =3D container_of(rcu, struct io_ev_fd, rcu);
-
-	eventfd_ctx_put(ev_fd->cq_ev_fd);
-	kfree(ev_fd);
-}
-
 static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd;
--=20
2.30.2

