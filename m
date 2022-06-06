Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D4353E346
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiFFG5c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiFFG5a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:57:30 -0400
Received: from pv50p00im-tydg10021701.me.com (pv50p00im-tydg10021701.me.com [17.58.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC77D2252F
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1654498649;
        bh=HmqCm3jsk86bBku9zLqGwcnIjX8bpYn784c41oZDIN4=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=khkJeOBKXGYf9GUhpALPRzf2nPmYRcjKg7bvmaB6hTa0bj3o/axJkqCXoK20wlMXD
         g8BGhQxgPu/up2SiC6f1x83BUvRwYqdVls7ilSzRZW1mFY7XNL2SP9Z9x5AVM69SN9
         DnQfnJugpv309S/zYXNG2rtyKi2IrzEBmIlP+98doPr1mDWX44+Sr/sGq099knIU1s
         SSJXVkf10jxIpEed3b9zVWF2Uf1cCixIbE2HtZMqpugAAQQbFRMXr8Mpl1FiejDwsX
         bdFq5bz2xvwRRdExbB8LUXageHVuc42KbhNDKYvaQ8sEWzq/erhVyayf2qA16kdnam
         AdNRVETLbjVPw==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10021701.me.com (Postfix) with ESMTPSA id 0A3893A0D86;
        Mon,  6 Jun 2022 06:57:26 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/3] io_uring: add hash_index and its logic to track req in cancel_hash
Date:   Mon,  6 Jun 2022 14:57:14 +0800
Message-Id: <20220606065716.270879-2-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606065716.270879-1-haoxu.linux@icloud.com>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_02:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=680 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2206060031
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

Add a new member hash_index in struct io_kiocb to track the req index
in cancel_hash array. This is needed in later patches.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io_uring_types.h | 1 +
 io_uring/poll.c           | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 7c22cf35a7e2..2041ee83467d 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -474,6 +474,7 @@ struct io_kiocb {
 			u64		extra2;
 		};
 	};
+	unsigned int			hash_index;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0df5eca93b16..95e28f32b49c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -74,8 +74,10 @@ static void io_poll_req_insert(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct hlist_head *list;
+	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
 
-	list = &ctx->cancel_hash[hash_long(req->cqe.user_data, ctx->cancel_hash_bits)];
+	req->hash_index = index;
+	list = &ctx->cancel_hash[index];
 	hlist_add_head(&req->hash_node, list);
 }
 
-- 
2.25.1

