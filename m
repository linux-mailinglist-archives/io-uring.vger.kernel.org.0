Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000AE5B5E90
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 18:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiILQxn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 12:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiILQxl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 12:53:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46693286F8
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 09:53:41 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28C8vv5s023976
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 09:53:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=6Kw/BDvffn4PftytYruFc9QNt6h0V44NwW5Z6uqGXk0=;
 b=nV94FpkPrCmCHgu0Lc014aNPvdsjlsOYKTnVrXwZahQo+gek+olVwj45uPzBeLkXw8lh
 fz/oNT6tkenrpcNKObJfHshS6tUOqgUrLEc21rAxACwRKnmf5aNHbmhbIYJ8ng+omRwq
 1sJZKPCY2bJaRpQae1LdSNJg9JUMkPJB+RY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jgrb1k2m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 09:53:40 -0700
Received: from twshared13579.04.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 09:53:39 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 46DBB206F89C; Mon, 12 Sep 2022 09:53:31 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>
CC:     <shr@fb.com>, <io-uring@vger.kernel.org>
Subject: [PATCH v1] block: blk_queue_enter() / __bio_queue_enter() must return -EAGAIN for nowait
Date:   Mon, 12 Sep 2022 09:53:25 -0700
Message-ID: <20220912165325.2858746-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1ydxG05hulY5J1izGOjKfRtliTWQ993y
X-Proofpoint-GUID: 1ydxG05hulY5J1izGOjKfRtliTWQ993y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_12,2022-09-12_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Today blk_queue_enter() and __bio_queue_enter() return -EBUSY for the
nowait code path. This is not correct: they should return -EAGAIN
instead.

This problem was detected by fio. The following command exposed the
above problem:

t/io_uring -p0 -d128 -b4096 -s32 -c32 -F1 -B0 -R0 -X1 -n24 -P1 -u1 -O0 /d=
ev/ng0n1

By applying the patch, the retry case is handled correctly in the slow
path.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 block/blk-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0d1104c5590..651057c4146b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -295,7 +295,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_r=
eq_flags_t flags)
=20
 	while (!blk_try_enter_queue(q, pm)) {
 		if (flags & BLK_MQ_REQ_NOWAIT)
-			return -EBUSY;
+			return -EAGAIN;
=20
 		/*
 		 * read pair of barrier in blk_freeze_queue_start(), we need to
@@ -325,7 +325,7 @@ int __bio_queue_enter(struct request_queue *q, struct=
 bio *bio)
 			if (test_bit(GD_DEAD, &disk->state))
 				goto dead;
 			bio_wouldblock_error(bio);
-			return -EBUSY;
+			return -EAGAIN;
 		}
=20
 		/*

base-commit: 80e78fcce86de0288793a0ef0f6acf37656ee4cf
--=20
2.30.2

