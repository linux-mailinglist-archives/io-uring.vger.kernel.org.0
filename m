Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F979140125
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 01:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733222AbgAQAxj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 19:53:39 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38461 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729937AbgAQAxj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 19:53:39 -0500
Received: by mail-lj1-f196.google.com with SMTP id w1so24671371ljh.5;
        Thu, 16 Jan 2020 16:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nRLDsV5J+qkOKcJynurEZXps9+tP4i1Xe6Phm4XOTR4=;
        b=iMrhQwjWDdPKI17qs9lOaGZLJHmZhyiEvzn82Awp6aaTvIDjibKrQqROs7KVHLnDkj
         +BKr4D8ciYkZh9eGI5EnwF/l6gKa4Kn9exonPDrEe7bOJC/gvh852Epnk4F06U9Kf4i1
         8D2+59treVJTUWw81qtv/A2G88pYtJ541Y5Q7HT0QynigJoxeKacAoHWW1Ft6+89FEDq
         4P9BOc9TYT0iT/eWH9sc2GmkMt7ILDI0bbioHQP4ey4JaJZt84+cvOdC0otA2Chgrey2
         26AtZH/WryNmwS8wzeVaneTrmAx2wEHk8wnSfvGRZ5zq1bVHCz3TYJ9E1VVI6DA0eUsi
         ALBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nRLDsV5J+qkOKcJynurEZXps9+tP4i1Xe6Phm4XOTR4=;
        b=k+pGvdG/CqfJz6DaffjZADKSIdT/+BUJQaU0Bry5QvcgEfOxlkEaQt2/WQbSFGI0Ko
         SSUXhXv/XaA1mtIbrvdM1bOmUHqumWcx0nvtSoaYfnIqC7vOOhz0MTHT4sG2YHaR+Tei
         kffe/XP18QEBjpNaF7wRpO3NPN0iDCTC2jsVDbuHU7OOxpsd6/ez9IXfjRM8uHzrDOs0
         kckh7stUDPFWM4lWXNyRlFCOK8i6B5MvsFVQGIkS9Z9JFVqapjEwtfIoukgIXdGf4yPT
         8Bv7eyVS7S10gtKwWmBk2Epu5fnJlDas0tTUweF7u7Zuwggh65VxfNVmUrQZ5A8cB3Ma
         S0IQ==
X-Gm-Message-State: APjAAAUfCxthHzDjAfORVtLHF+R/+X4/uD5p0RxvQ1JhLevMFUeMPLuB
        pA1NK0aW6h7MdwXFEYntr1KwGJBd
X-Google-Smtp-Source: APXvYqy6N5uWsJX2pC47nHo5QlrWFFY2e2OPd/lAApVB9k1YS6UkqwsiTsIaBBoYfOU+3tzo+xOurQ==
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr4119536lji.274.1579222417031;
        Thu, 16 Jan 2020 16:53:37 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id r26sm11174346lfm.82.2020.01.16.16.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 16:53:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: remove extra check in __io_commit_cqring
Date:   Fri, 17 Jan 2020 03:52:46 +0300
Message-Id: <0d023acc096d63db454927590a5aca07deeac1cf.1579222330.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_commit_cqring() is almost always called when there is a change in
the rings, so the check is rather pessimising.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f9709a3a673c..ea91f4d92fc0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -859,14 +859,12 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 
-	if (ctx->cached_cq_tail != READ_ONCE(rings->cq.tail)) {
-		/* order cqe stores with ring update */
-		smp_store_release(&rings->cq.tail, ctx->cached_cq_tail);
+	/* order cqe stores with ring update */
+	smp_store_release(&rings->cq.tail, ctx->cached_cq_tail);
 
-		if (wq_has_sleeper(&ctx->cq_wait)) {
-			wake_up_interruptible(&ctx->cq_wait);
-			kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-		}
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
 	}
 }
 
-- 
2.24.0

