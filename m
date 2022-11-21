Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C835631EBC
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiKUKso (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiKUKsO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:48:14 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC072B842
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:13 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKMvgXl009589
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=N47RFG6rqxzhK9mIsH6lCWq+xQ4nDOqdeytRX15d14s=;
 b=YkJ4KadjdI/OXHVp3VCZx8zW6X0QM4cLlDTzvaq/Nac17Po1WMxKCwcU4YtQDFNvEnRM
 0Km/nXUgZX4QFmzV2dhqj1ZiMuJs2oLhbE1N+/cydDXpBYYUjJzE4QUgEjp7O42WGiCH
 CGjlL8SNn5rtNa/c1DV71Dnm3xIMsmlGQ3De4ysonyRQycUoHfx1f0YO1Tsq4c4/xHFC
 RYn4FaZg3nO68olwHhNly6oym9JFm32XxKcCnNAxTkBadVDLL5dLMO3xbp3uBxn3FSQM
 qvLdL50Qg7WJPylh8Hu9aFOMvOlIoLjxJ2+k98al0mXPk+ebC5aWdpbyNlXVc8XloOJ1 2g== 
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kxwj43q7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:48:12 -0800
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:48:11 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 301279E66F74; Mon, 21 Nov 2022 02:03:56 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 05/10] io_uring: timeout should use io_req_task_complete
Date:   Mon, 21 Nov 2022 02:03:48 -0800
Message-ID: <20221121100353.371865-6-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 7J6JfRFT6jhzcP7PV59UiD1Cri5hL8jl
X-Proofpoint-ORIG-GUID: 7J6JfRFT6jhzcP7PV59UiD1Cri5hL8jl
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

Allow timeouts to defer completions if the ring is locked

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/timeout.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index e8a8c2099480..26b61e62aa9a 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -282,12 +282,11 @@ static void io_req_task_link_timeout(struct io_kioc=
b *req, bool *locked)
 			ret =3D io_try_cancel(req->task->io_uring, &cd, issue_flags);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
-		io_req_complete_post(req);
 		io_put_req(prev);
 	} else {
 		io_req_set_res(req, -ETIME, 0);
-		io_req_complete_post(req);
 	}
+	io_req_task_complete(req, locked);
 }
=20
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
--=20
2.30.2

