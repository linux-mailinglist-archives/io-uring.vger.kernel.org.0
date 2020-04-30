Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFCF1C0682
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2020 21:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgD3Tck (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Apr 2020 15:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgD3Tc3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Apr 2020 15:32:29 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F4EC035495;
        Thu, 30 Apr 2020 12:32:28 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z6so3454831wml.2;
        Thu, 30 Apr 2020 12:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NqvUEoit9P+cpSl6nYi0nxVzc/4LWISaQv+Z+9RKBic=;
        b=ugvEiDv4uJ50G9ECpsXW77N8GR9G2OYI1Bx1JWXCqiRYIfGRe3ZIADdX3eHA0HbYtr
         NpuJrUkxapdnkXT82XlNUdc7umgOrMnaDHIJWUoIZRyS63JHUzdupOXTxr/R3ljEe2de
         h1ojessGkRDd9UtORS+nZkS7N+4PZfa1sbYmlCfMpXHwY+D/4ZMfQC817re9sAV9gWD5
         JoTf6O99UC+dngpULkaZYTDE1nr/HpHM4Tt6SAg03ncRvVxss/rf8Y9ufdUyXk7JlFAA
         L1NZxyBf3JxQMxdTrkNcbDA9MHVfwNt91Pm8Wl7YnH22TzBmB5q9x8tF9lXGjh1r2FeX
         zW3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NqvUEoit9P+cpSl6nYi0nxVzc/4LWISaQv+Z+9RKBic=;
        b=irbT5XOCIp7X/5GdJZHl5/gF+0L5WH6tfdkBfI9yFA+bMItTtJ/QbVpkinj2hWe9xo
         dmmk5CPdPnHzWBk1nG/94l74tyhbQPusQ8hTIpl6qYPSDfopYuL5up+Dsg8WvADTVjsQ
         jbKMwrn1J2YLLHk47ed0nY9BAMMRNqZXLPrDbm3ujpi8tF1VPZvPw+fFBVS2Ujn+7lHu
         zxc+K6TOsX+kZ8x47E8ZCPmXD5TNvzruZuBL1j57Lxqhg4O79qMBeS8wqqCd59eccJH/
         2AkrM6jgh3igay0QWQDix5GhpUP92doJ7Bem7J2vwf3bvwSz5Qs48TsNvm4QuuQyl9ae
         nP6A==
X-Gm-Message-State: AGi0PuasVV1DpSH+yXxQLCIRjbKfnIE8WAgfp3gPj2cKUjSGARqysAXB
        eYf5+3cbBVjeviB2fN8s5uQFWjI/
X-Google-Smtp-Source: APiQypKnaO0GEo57412SWqh2djAMIR+mjnRI2ETYvmbpg6yy+Cb21M3QDJL/rductp/TeOeDRM66sA==
X-Received: by 2002:a1c:7715:: with SMTP id t21mr150525wmi.182.1588275147391;
        Thu, 30 Apr 2020 12:32:27 -0700 (PDT)
Received: from localhost.localdomain ([109.126.131.64])
        by smtp.gmail.com with ESMTPSA id h188sm917002wme.8.2020.04.30.12.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 12:32:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] io_uring: don't trigger timeout with another t-out
Date:   Thu, 30 Apr 2020 22:31:09 +0300
Message-Id: <2fd19ca7ea8ce47a19802abf38d64a1460c9002f.1588253029.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588253029.git.asml.silence@gmail.com>
References: <cover.1588253029.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When deciding whether to fire a timeout basing on number of completions,
ignore CQEs emitted by other timeouts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 006ac57af842..fb8ec4b00375 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1098,33 +1098,20 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
-static inline bool io_check_in_range(u32 pos, u32 start, u32 end)
-{
-	/* if @end < @start, check for [end, MAX_UINT] + [MAX_UINT, start] */
-	return (pos - start) <= (end - start);
-}
-
 static void __io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	u32 end, start;
-
-	start = end = ctx->cached_cq_tail;
 	do {
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 							struct io_kiocb, list);
 
 		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
 			break;
-		/*
-		 * multiple timeouts may have the same target,
-		 * check that @req is in [first_tail, cur_tail]
-		 */
-		if (!io_check_in_range(req->timeout.target_seq, start, end))
+		if (req->timeout.target_seq != ctx->cached_cq_tail
+					- atomic_read(&ctx->cq_timeouts))
 			break;
 
 		list_del_init(&req->list);
 		io_kill_timeout(req);
-		end = ctx->cached_cq_tail;
 	} while (!list_empty(&ctx->timeout_list));
 }
 
@@ -4688,7 +4675,7 @@ static int io_timeout(struct io_kiocb *req)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail;
+	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 	req->timeout.target_seq = tail + off;
 
 	/*
-- 
2.24.0

