Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3166154F941
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382226AbiFQOgP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiFQOgO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:36:14 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CE75251A
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:36:13 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655476572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=64bRr+iDqyfH1wO0tT7e5eLQdiOXDFN5WM+1JyA/3AQ=;
        b=b+ZvkFVIxmRaPMaPMTzqdZk7VEJAaxkw8tXvNBOZ3EmDhBQeeEaPEO3MfrmCei7CIfUPMX
        pJhAKwj3B8IUm8GRHErMZhXadBxf11Yqf6jJH1vXBn8GS41Moj9Avs/ccHpvClSo78hYkK
        h1qtCWU7mPXbJtdmMYDxzkK7J2WTQ98=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/3] Fix incorrect close in test for multishot accept
Date:   Fri, 17 Jun 2022 22:36:01 +0800
Message-Id: <20220617143603.179277-2-hao.xu@linux.dev>
In-Reply-To: <20220617143603.179277-1-hao.xu@linux.dev>
References: <20220617143603.179277-1-hao.xu@linux.dev>
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

From: Donald Hunter <donald.hunter@gmail.com>

This fixes a bug in accept_conn handling in the accept tests that caused it
to incorrectly skip the multishot tests and also lose the warning message
to a closed stdout. This can be seen in the strace output below.

close(1)                                = 0
io_uring_setup(32, { ...
...
write(1, "Fixed Multishot Accept not suppo"..., 47) = -1 EINVAL

Unfortunately this exposes a a bug with gcc -O2 where multishot_mask logic
gets optimized incorrectly and "Fixed Multishot Accept misses events" is
wrongly reported. I am investigating this separately.

Fixes: 66cf84527c34 ("test/accept.c: add test for multishot mode accept")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 test/accept.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index 4e2f58767b3c..c6654baa3925 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -103,7 +103,7 @@ static void queue_accept_conn(struct io_uring *ring, int fd,
 	}
 }
 
-static int accept_conn(struct io_uring *ring, int fixed_idx)
+static int accept_conn(struct io_uring *ring, int fixed_idx, bool multishot)
 {
 	struct io_uring_cqe *cqe;
 	int ret;
@@ -115,8 +115,10 @@ static int accept_conn(struct io_uring *ring, int fixed_idx)
 
 	if (fixed_idx >= 0) {
 		if (ret > 0) {
-			close(ret);
-			return -EINVAL;
+			if (!multishot) {
+				close(ret);
+				return -EINVAL;
+			}
 		} else if (!ret) {
 			ret = fixed_idx;
 		}
@@ -208,7 +210,7 @@ static int test_loop(struct io_uring *ring,
 		queue_accept_conn(ring, recv_s0, args);
 
 	for (i = 0; i < MAX_FDS; i++) {
-		s_fd[i] = accept_conn(ring, args.fixed ? 0 : -1);
+		s_fd[i] = accept_conn(ring, args.fixed ? 0 : -1, multishot);
 		if (s_fd[i] == -EINVAL) {
 			if (args.accept_should_error)
 				goto out;
-- 
2.25.1

