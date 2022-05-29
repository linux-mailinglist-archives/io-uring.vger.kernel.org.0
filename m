Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB9A5371C3
	for <lists+io-uring@lfdr.de>; Sun, 29 May 2022 18:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiE2QUL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 12:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiE2QUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 12:20:11 -0400
Received: from pv50p00im-ztdg10012001.me.com (pv50p00im-ztdg10012001.me.com [17.58.6.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985D652B0F
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 09:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653841210;
        bh=RUQZd9agjsKWPP1SpHb3lOd/vq21uUZQTwzQJlNo9hM=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=o6zjw6jJxqCDc01DLrUunWPF3slOV5O3Bu0CW3pDOCUEiWXR3hoZdMNt7X9a1flr1
         sYfLackPqrOkRACbGH9oNus0/Ts7WeX6dfb2A8+HWMQPrS0H4vqX6oKdavdCOT4owy
         iWBksU67XM1d0OfeqAc/hZ2SydcDKBEO4xpM5a0KsrojjxhQEs+BTWTGQDEof+rx6/
         LbLrtI2X4I3O3m+ZQrCNvjjIOGb7c8Adh9BF9+rpsqk1HnK6Miau7VdXi7O/vexQw9
         AqWrpdXyQzIqK1wtc6sLqZeUemN+PYUWhEosmLk0gzUG8hEoPeigw2ps24Hr6MBxmG
         JrSoHKG6/yaew==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10012001.me.com (Postfix) with ESMTPSA id 222EBA0354;
        Sun, 29 May 2022 16:20:07 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/2] io_uring: add an argument for io_poll_disarm()
Date:   Mon, 30 May 2022 00:19:59 +0800
Message-Id: <20220529162000.32489-2-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220529162000.32489-1-haoxu.linux@icloud.com>
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-29_03:2022-05-27,2022-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=602 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205290095
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

From: Hao Xu <howeyxu@tencent.com>

Add an argument for io_poll_disarm() for later use.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/poll.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 728f6e7b47c5..c8982c5ef0fa 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -561,8 +561,9 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 {
 	struct hlist_head *list;
 	struct io_kiocb *req;
+	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
 
-	list = &ctx->cancel_hash[hash_long(cd->data, ctx->cancel_hash_bits)];
+	list = &ctx->cancel_hash[index];
 	hlist_for_each_entry(req, list, hash_node) {
 		if (cd->data != req->cqe.user_data)
 			continue;
@@ -573,6 +574,7 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				continue;
 			req->work.cancel_seq = cd->seq;
 		}
+		cd->flags = index;
 		return req;
 	}
 	return NULL;
@@ -602,7 +604,7 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 	return NULL;
 }
 
-static bool io_poll_disarm(struct io_kiocb *req)
+static bool io_poll_disarm(struct io_kiocb *req, u32 index)
 	__must_hold(&ctx->completion_lock)
 {
 	if (!io_poll_get_ownership(req))
@@ -724,7 +726,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, true, &cd);
-	if (!preq || !io_poll_disarm(preq)) {
+	if (!preq || !io_poll_disarm(preq, cd.flags)) {
 		spin_unlock(&ctx->completion_lock);
 		ret = preq ? -EALREADY : -ENOENT;
 		goto out;
-- 
2.25.1

