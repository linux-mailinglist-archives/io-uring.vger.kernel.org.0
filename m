Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D9D54747C
	for <lists+io-uring@lfdr.de>; Sat, 11 Jun 2022 14:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiFKMWm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jun 2022 08:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiFKMWl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jun 2022 08:22:41 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBFF183AA
        for <io-uring@vger.kernel.org>; Sat, 11 Jun 2022 05:22:39 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654950157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cF5VLqZazzAXFMPFgW6edUuYNdGOTMIng7AFwFbNHPE=;
        b=jBI9wyes8Rvh1aTOl4RpBf4yzcz7MxZCtp7v/MfCjWmJ7kSDPGhUndQS+J/BBHCwNdGJCT
        FDRnYccyeq+JapEHmXpPeZHGAAOhgH8U/+izFUjE1SySVJdPzInK/ro2YqLOqUjRWnNSJN
        nhx7X+BD+VaLKsvjtY8pa7cg1QdlsGE=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-5.20 1/6] io_uring: poll: remove unnecessary req->ref set
Date:   Sat, 11 Jun 2022 20:22:19 +0800
Message-Id: <20220611122224.941800-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

We now don't need to set req->refcount for poll requests since the
reworked poll code ensures no request release race.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/poll.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0df5eca93b16..73584c4e3e9b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -683,7 +683,6 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
 		return -EINVAL;
 
-	io_req_set_refcount(req);
 	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
-- 
2.25.1

