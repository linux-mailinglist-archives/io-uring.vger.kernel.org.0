Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE1764E11D
	for <lists+io-uring@lfdr.de>; Thu, 15 Dec 2022 19:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLOSlz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Dec 2022 13:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiLOSlz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Dec 2022 13:41:55 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A11515FDF
        for <io-uring@vger.kernel.org>; Thu, 15 Dec 2022 10:41:54 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFIJKSV012165
        for <io-uring@vger.kernel.org>; Thu, 15 Dec 2022 10:41:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=twW8lkEp2/M4gTKzdGhwZNpy0DBsCC2x+xCTF+N9dWs=;
 b=Tuwg2vrcy+93D/DO/OWQXPY6XAm6RuaKYFswpBH1jFfpIR8YhyU1tIaxzonAbllyLWPW
 cppL6uPnqQxzIqLZ4NRQ0hCBR5qBqR8UO00hnr78KT+cm9TTmxhBBZKfJ0elrmf3uDzQ
 yvwCgOqEFRl6CMNE4no6FrNsvOV87B/oS2KYUwmgnlM3hqNM88CrUtHmZspvxiNNgj8o
 CGmY7zlU+UyjWZkFAAatmg1roHmcxTNtQ7SAVDfg4WXDqKi6uSB4cUD0HhvQjrxJ5In7
 6n0faJ16M4JkB0e/ZWP71XwejzYgAfHwRJY5HQ56YQe2gVwQ2PlW3dVtlhNXXIMw8VF4 vw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3mg8rk869t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 15 Dec 2022 10:41:54 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 15 Dec 2022 10:41:52 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 8FFD9B73E148; Thu, 15 Dec 2022 10:41:45 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@meta.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH] io_uring: use call_rcu_hurry if signaling an eventfd
Date:   Thu, 15 Dec 2022 10:41:38 -0800
Message-ID: <20221215184138.795576-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: B5923NQDd9shj2c-PfGZatbUfwavyPcN
X-Proofpoint-ORIG-GUID: B5923NQDd9shj2c-PfGZatbUfwavyPcN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring uses call_rcu in the case it needs to signal an eventfd as a
result of an eventfd signal, since recursing eventfd signals are not
allowed. This should be calling the new call_rcu_hurry API to not delay
the signal.

Signed-off-by: Dylan Yudaken <dylany@meta.com>

Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b521186efa5c..2cb8c665bab1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -538,7 +538,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx=
)
 	} else {
 		atomic_inc(&ev_fd->refs);
 		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))
-			call_rcu(&ev_fd->rcu, io_eventfd_ops);
+			call_rcu_hurry(&ev_fd->rcu, io_eventfd_ops);
 		else
 			atomic_dec(&ev_fd->refs);
 	}

base-commit: 041fae9c105ae342a4245cf1e0dc56a23fbb9d3c
--=20
2.30.2

