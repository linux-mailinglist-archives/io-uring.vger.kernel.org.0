Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E2434234D
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhCSR1I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhCSR1A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:27:00 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14468C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:00 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x16so9881546wrn.4
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OdQGGorz94vXj/m/Yfj5OfcOGQrwoO8Zu82Lhqx2OnE=;
        b=THQMelOt1ZfYpNoomtU9R3LAOR854mdRLs+d/mfOMs0fToo9VW9Uxb1Fiiw28o6dDZ
         Xl51QfOn+RY2TwELOHDnxoJROOpFTIUBPX7lWLLrMUXfc6AYGfT/Rc1rxLxzj1ytIPrV
         6qZCdfYClMUIB5l6Y5GwD6ycGuOZ7+1ekWh8nI72q7UQ92RK1YpPy+kRBRE+EPEC+r2q
         LRvC3QPXVath1cJK/lH/7dtwfT7WLf0YqUe1Mqln465OrOAfsd3f/m1+5I7UWtFpSHQ/
         FkRI78w+2oTJIQWgKHBwbRO9XrNeWJBn5jDXbIU4Quelacz437/QQ2NiTr14NsZi+zic
         moIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OdQGGorz94vXj/m/Yfj5OfcOGQrwoO8Zu82Lhqx2OnE=;
        b=G+DN6mV6Woj3GLgp3jg9P2MnNPPq1StCdDILz4OZJHbDccCroNdD1QCiYT5c8tsVmS
         bujVezR0lByh9SdjaEWGecta0eQXiauiwSLaOUtccikgim2CSDTsfS1HyiVGpXdPgzIg
         ikW3cfaBtaGpDkqxbUJgzMjznBqZVqPIt/VEE5EPRdkqSVzZPpyyOce3TOH1haKtZUAh
         Lj/kxD1tgLNs94HMVHWXLzllVY5cTMQ43jEVCAS0X7L5YZpQQbqwKRYJVbNwyMXgkoGR
         lVPAnxnepQyg+uYN+yBVmqSS4T1+HeqwxztG2TtzjxyX/PEhFXCH8xqqgjGaMMUvqIZk
         R2ug==
X-Gm-Message-State: AOAM5330B+ybxfyTBxPCzCbMWCBoZtsYHihTMapowjeXVKaWDSYrZTBl
        3lzYmL308eV3Nedmc75q5PgM1G1XgFrLjg==
X-Google-Smtp-Source: ABdhPJxVFHXgeQTLzd9vMUehTqRVWfW2mMzp3Q9bp/ZbprrNkfWTUVMa+xgdv2ROsHYHu2RWwRv7tA==
X-Received: by 2002:adf:f005:: with SMTP id j5mr5472504wro.423.1616174818915;
        Fri, 19 Mar 2021 10:26:58 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/16] io_uring: inline io_put_req and friends
Date:   Fri, 19 Mar 2021 17:22:37 +0000
Message-Id: <f333ff5bcd51416e900a349f6573645ee6f0b7da.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

One big omission is that io_put_req() haven't been marked inline, and at
least gcc 9 doesn't inline it, not to mention that it's really hot and
extra function call is intolerable, especially when it doesn't put a
final ref.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6655246287f3..10d0e3c6537c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2186,7 +2186,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
  */
-static struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
+static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = NULL;
 
@@ -2197,7 +2197,7 @@ static struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 	return nxt;
 }
 
-static void io_put_req(struct io_kiocb *req)
+static inline void io_put_req(struct io_kiocb *req)
 {
 	if (req_ref_put_and_test(req))
 		io_free_req(req);
-- 
2.24.0

