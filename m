Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79DF1A8DDF
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 23:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634011AbgDNVlk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 17:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2633993AbgDNVlD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 17:41:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847A1C061A0E;
        Tue, 14 Apr 2020 14:41:01 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k11so15734907wrp.5;
        Tue, 14 Apr 2020 14:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mdno514tf2PSHuVuETnChZVuu/ZqUVbKx1kmBsYnoUg=;
        b=ui88Oo9u+TrrHw25A+hSkE9xdjIABkkMC05IFlkQiGWW0zQ9yIvOIzcgF10e85AMYi
         LfDcbTlDxY1+TGv98kspgyn7hcgguz0RinSVY2dAH6LIVNrN3s5/tRrIRS044GeBN/oR
         fpzDqMJClZhiX1jfGcSfXZGGaYHAy+ZxWSv2dVUnULyBl0UkeaVqJtCzBENuKdWfm3oq
         tIsscWHWxH7uUgQZdeB0yx19sgZ6K+dtIyp4sowC9dSNxrdVJYVxk00j/LN/E2ju2rgM
         isYbO62+RwIqCXMXaOL4giKVEAPTTFTNshW/vhMZqFGbCGmebiD2XX3cBnaU1z6K2xiK
         rfPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mdno514tf2PSHuVuETnChZVuu/ZqUVbKx1kmBsYnoUg=;
        b=ASlrqpfdxmz8pQnjZQgXrDtutD/M27AjkgPZSnYcsbXBq2D7aBryMsnCO5U2xibZSI
         3tb+lQfKL2xcaLKVu8Ldl6+eFW9A8oZZCLvqDem0CtZ1Qi7QZw2IpMGpeBhHRIPj8yx/
         5Gh0TVevNR8smCnJ7JppX/hB2MVUbS6Qm8YL+VSJPRyLtwMWISf4WmEnO2F0HI1ihHwz
         zziWD2p/CGL80jWSu/pqBebwNSNjjFSzZ3SBJW6fe5Z7b7UTiDBmilMci+RnmbcCKwCK
         PDuU70frmurnzWLkYLltKEbLprIxRr4dm98Jt97bjeNXE/sKigaBgnanlUGGmi7vbayn
         bHGQ==
X-Gm-Message-State: AGi0PuaP7mIrvcHF0eG5oJPatOeXZj/cxUlqiArxUbE8o6SriiQFrsXu
        x9GqsC8mqQuftKSOAQNIk/kRvWG4
X-Google-Smtp-Source: APiQypJp9xV9AtaDpiWzHAIYs4f25s2P645Dqf1dLAYIXSypcRDJwhNL7/iSb2iKrXyBl4Xx/gHBSw==
X-Received: by 2002:a5d:61c5:: with SMTP id q5mr16109713wrv.260.1586900460256;
        Tue, 14 Apr 2020 14:41:00 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id l185sm20320540wml.44.2020.04.14.14.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 14:40:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] io_uring: fix cached_sq_head in io_timeout()
Date:   Wed, 15 Apr 2020 00:39:48 +0300
Message-Id: <637d5c3f98c3303d3d1ada057414e067facf4105.1586899625.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586899625.git.asml.silence@gmail.com>
References: <cover.1586899625.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_timeout() can be executed asynchronously by a worker and without
holding ctx->uring_lock

1. using ctx->cached_sq_head there is racy there
2. it should count events from a moment of timeout's submission, but
not execution

Use req->sequence.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c0cf57764329..fcc320d67606 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4673,6 +4673,7 @@ static int io_timeout(struct io_kiocb *req)
 	struct io_timeout_data *data;
 	struct list_head *entry;
 	unsigned span = 0;
+	u32 seq = req->sequence;
 
 	data = &req->io->timeout;
 
@@ -4689,7 +4690,7 @@ static int io_timeout(struct io_kiocb *req)
 		goto add;
 	}
 
-	req->sequence = ctx->cached_sq_head + count - 1;
+	req->sequence = seq + count;
 	data->seq_offset = count;
 
 	/*
@@ -4699,7 +4700,7 @@ static int io_timeout(struct io_kiocb *req)
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_prev(entry, &ctx->timeout_list) {
 		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
-		unsigned nxt_sq_head;
+		unsigned nxt_seq;
 		long long tmp, tmp_nxt;
 		u32 nxt_offset = nxt->io->timeout.seq_offset;
 
@@ -4707,18 +4708,18 @@ static int io_timeout(struct io_kiocb *req)
 			continue;
 
 		/*
-		 * Since cached_sq_head + count - 1 can overflow, use type long
+		 * Since seq + count can overflow, use type long
 		 * long to store it.
 		 */
-		tmp = (long long)ctx->cached_sq_head + count - 1;
-		nxt_sq_head = nxt->sequence - nxt_offset + 1;
-		tmp_nxt = (long long)nxt_sq_head + nxt_offset - 1;
+		tmp = (long long)seq + count;
+		nxt_seq = nxt->sequence - nxt_offset;
+		tmp_nxt = (long long)nxt_seq + nxt_offset;
 
 		/*
 		 * cached_sq_head may overflow, and it will never overflow twice
 		 * once there is some timeout req still be valid.
 		 */
-		if (ctx->cached_sq_head < nxt_sq_head)
+		if (seq < nxt_seq)
 			tmp += UINT_MAX;
 
 		if (tmp > tmp_nxt)
-- 
2.24.0

