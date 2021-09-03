Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCB23FFF43
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 13:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349210AbhICLgh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 07:36:37 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:56620
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235188AbhICLgg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 07:36:36 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id DFE733F230;
        Fri,  3 Sep 2021 11:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630668935;
        bh=RpO7O/bcjJi+T/4w2buAEbwHzIyG3tU0FQCVmx+2zYQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=An9LYalhwn54ptxDDDkj+aH5C6XyScm7bSIt12vTe64zvkr2Qo6Csz6tn6AipkyEF
         Woe/TqzCZ4YYtks6FAFtdu43Dwl+MyHFCD7r7C1uaVqZkNsPhKFK/DVHItHnu61NJC
         TqHOcS1V6KS/mBTd/kWVVzW47lrEAXu27aIdukolu/aevcz1Z3w0/k6nPLBjbXGBv3
         xPvVsQSeUK8gTmGmGmsA3/Mk8mtz90jy+GR3t+DwK+0BTX6vJiPqDq2NQckQGN1Qo7
         /wapxVwk092Npa4JLP53rmIC9Uss7WL26AcplPRXjUC4cDqhPLihNTmdx7WvKItIS+
         z0EMpCxK1Z53Q==
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: Fix a read of ununitialized pointer tctx
Date:   Fri,  3 Sep 2021 12:35:35 +0100
Message-Id: <20210903113535.11257-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the unlikely case where ctx->flags & IORING_SETUP_SQPOLL is true
and sqd is NULL the pointer tctx is not assigned a valid value and
can contain a garbage value when it is dereferenced. Fix this by
initializing it to NULL.

Addresses-Coverity: ("Uninitialized pointer read")
Fixes: 9e30726065ea ("io_uring: ensure IORING_REGISTER_IOWQ_MAX_WORKERS works with SQPOLL")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 132dd38e89ce..843362bebd8c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10525,7 +10525,7 @@ static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 					void __user *arg)
 {
 	struct io_sq_data *sqd = NULL;
-	struct io_uring_task *tctx;
+	struct io_uring_task *tctx = NULL;
 	__u32 new_count[2];
 	int i, ret;
 
-- 
2.32.0

