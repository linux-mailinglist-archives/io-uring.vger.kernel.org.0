Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21562635B4D
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbiKWLLP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237454AbiKWLKp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:10:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3957FD08A3
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:09:06 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB65dN016531
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:09:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=AjHrb9o1Ma8k9hUtX6XDKWMtxRJPGN6YQTuzWdDYyNc=;
 b=LhkHqLghNziT+b4xefIjkftn1hJA0lCcGwbMywNn0dRszCW3u5TbqwmAAd+AAzj4yDQL
 g4uV2OuNaOMDCoTRQQjdHNfZCufnUcsYW0w7V+AV7C4io9KLAD1QsCYXtKxHzy/1LXp2
 Wde6/S3TDkv8hpGPmNpsFSGyH8yFeeVIOBApKPkWBNHfnFmP4v29mCiRqukHp+eM7K6t
 6ueO9jMsSHcmlzcHPHg+1ZrkzqWAMVdxwIkLyXRsWHu8Ssl2K/kWKl6gKUzGCodm6FLG
 i2q3zYFP1NVrYaHI5OVfloP8pDv5uoyX132BKaobA6UI6gZsqxEFkzem2GcGMEr/bk5c nQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1cg3hyey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:09:05 -0800
Received: from twshared41876.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:09:04 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1B0BFA0804E1; Wed, 23 Nov 2022 03:06:28 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 13/13] io_uring: allow multishot polled reqs to defer completion
Date:   Wed, 23 Nov 2022 03:06:14 -0800
Message-ID: <20221123110614.3297343-14-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dcWpwaLje8gkprnlWmztj9yzNu3kMWS0
X-Proofpoint-GUID: dcWpwaLje8gkprnlWmztj9yzNu3kMWS0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Until now there was no reason for multishot polled requests to defer
completions as there was no functional difference. However now this will
actually defer the completions, for a performance win.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 87ea497590b5..e3f0b4728db3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1816,7 +1816,8 @@ int io_poll_issue(struct io_kiocb *req, bool *locke=
d)
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT|
+				 IO_URING_F_COMPLETE_DEFER);
 }
=20
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
--=20
2.30.2

