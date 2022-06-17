Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642BE54F942
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382540AbiFQOgR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382489AbiFQOgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:36:16 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A99052503
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:36:16 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655476574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RpRiEjMgcQKmsW3ofTJbI8Kbvqq/wtPru8rRbhucdFM=;
        b=mf31KgnDJefDddlY9SyG1eaf0/gbnsarP+OUYv48IKMnUyLJzCuScvNTlONk/xzlIckKpp
        ZnfIvPJ3CzPfq3cJgPz/mmXX4doXy443U+Ddj8GkfwmDaP0ypIz6bUO8de5RjL89VXLZKF
        S8FM3mDL/dCgnOdi+5tQQ3lX4VXLqrc=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/3] test/accept: fix minus one error when calculating multishot_mask
Date:   Fri, 17 Jun 2022 22:36:02 +0800
Message-Id: <20220617143603.179277-3-hao.xu@linux.dev>
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

From: Hao Xu <howeyxu@tencent.com>

We don't need to minus one for the s_fd[i] since the returned cqe.res
is already the fixed file table slot which is indexed from zero.

Fixes: 66cf84527c34 ("test/accept.c: add test for multishot mode accept")
Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 test/accept.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/accept.c b/test/accept.c
index c6654baa3925..b322c018c7a9 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -241,7 +241,7 @@ static int test_loop(struct io_uring *ring,
 					i, s_fd[i]);
 				goto err;
 			}
-			multishot_mask |= (1 << (s_fd[i] - 1));
+			multishot_mask |= (1U << s_fd[i]);
 		}
 		if (!multishot)
 			break;
-- 
2.25.1

