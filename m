Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5F53F7D7
	for <lists+io-uring@lfdr.de>; Tue,  7 Jun 2022 10:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbiFGIGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 04:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238024AbiFGIGq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 04:06:46 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB46B82F1;
        Tue,  7 Jun 2022 01:06:44 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654589202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RkLnU8BX1gl8psHZPmN10zKlj7zdxAeaXWQrglTE4fE=;
        b=Cd3KYch3FJFW7iw6PqMlDjONThZ+ckBbn78xiRnrhCbsrx5zukS64v+DCg3maMbbHOq//G
        iOdXayAe0kWLBpTMQgkoL/E89JnbfCl1Wu+J2cDUDXjcgSdSS9XAEI0JVl6SYsf6GSxjqd
        asSsKCT9mpcXwRlAiRoz9jqAqL8yqH8=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH 3/5] splice: support nonblock for splice from pipe to pipe
Date:   Tue,  7 Jun 2022 16:06:17 +0800
Message-Id: <20220607080619.513187-4-hao.xu@linux.dev>
In-Reply-To: <20220607080619.513187-1-hao.xu@linux.dev>
References: <20220607080619.513187-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

When SPLICE_F_NONBLOCK is set, splice() still may be blocked by pipe
lock in pipe to pipe scenario. Add trylock logic to make it more
nonblock

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/splice.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 047b79db8eb5..b087e00ed079 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1372,7 +1372,12 @@ static int ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 		return 0;
 
 	ret = 0;
-	pipe_lock(pipe);
+	if (flags & SPLICE_F_NONBLOCK) {
+		if (!pipe_trylock(pipe))
+			return -EAGAIN;
+	} else {
+		pipe_lock(pipe);
+	}
 
 	while (pipe_empty(pipe->head, pipe->tail)) {
 		if (signal_pending(current)) {
@@ -1408,7 +1413,12 @@ static int opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 		return 0;
 
 	ret = 0;
-	pipe_lock(pipe);
+	if (flags & SPLICE_F_NONBLOCK) {
+		if (!pipe_trylock(pipe))
+			return -EAGAIN;
+	} else {
+		pipe_lock(pipe);
+	}
 
 	while (pipe_full(pipe->head, pipe->tail, pipe->max_usage)) {
 		if (!pipe->readers) {
@@ -1460,7 +1470,12 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 	 * grabbing by pipe info address. Otherwise two different processes
 	 * could deadlock (one doing tee from A -> B, the other from B -> A).
 	 */
-	pipe_double_lock(ipipe, opipe);
+	if (flags & SPLICE_F_NONBLOCK) {
+		if (!pipe_double_trylock(ipipe, opipe))
+			return -EAGAIN;
+	} else {
+		pipe_double_lock(ipipe, opipe);
+	}
 
 	i_tail = ipipe->tail;
 	i_mask = ipipe->ring_size - 1;
-- 
2.25.1

