Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D809F5A63DE
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 14:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiH3Mus (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 08:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiH3Mur (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 08:50:47 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B224A6C2E
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:46 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27UBRurc009732
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PiB4E1TLr4n+pCjSR+mLg6tqXq3iq6mkgDPp7MVyPVE=;
 b=E+r1sFZAZrQ57+i/1h4uTSMQmcvEdCHXKotu85KgOS/8P5ZySzhLfNAZuaXai9Fq1v7r
 vVDUhc4taKY7WG6vqgC6jvKUK9NVyO2lBqO8axKL5jvbba2H4Zs+BT1KY2E+ckYEXefL
 +RfG9KnbROnrFoakoOjZgLBM4GBSTE9WSMg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3j9hpwgch9-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:45 -0700
Received: from twshared0646.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 05:50:41 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0A21B55BF513; Tue, 30 Aug 2022 05:50:31 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next v4 5/7] io_uring: move io_eventfd_put
Date:   Tue, 30 Aug 2022 05:50:11 -0700
Message-ID: <20220830125013.570060-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220830125013.570060-1-dylany@fb.com>
References: <20220830125013.570060-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WJm902KjIWOT_miKwvjt-gwQc1CA_D2B
X-Proofpoint-GUID: WJm902KjIWOT_miKwvjt-gwQc1CA_D2B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_07,2022-08-30_01,2022-06-22_01
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
index 9f90b0633de7..c6e416be7ed3 100644
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
@@ -2468,14 +2476,6 @@ static int io_eventfd_register(struct io_ring_ctx =
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

