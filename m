Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6912BD62
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 12:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfL1LNp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 06:13:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44685 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfL1LNn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 06:13:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so28349970wrm.11;
        Sat, 28 Dec 2019 03:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YHYJcDrGIHRFm53VlzRjbvCMqJEk7QWJgVaPxjySsxc=;
        b=vh/EItAjQHTrj6A1QVr/MzFGHyyT1AZ/5rFAYS6FzVX0jGjJuT7XEYbILe0wmT223f
         JymM28x1E4Ce3elN0tD8rYghuKahsyIqZ8535CCo3MI3AWP9vwvX6BBBOR4s9VNBhchn
         VFpw2LEfI9nEIvdI8Pqwq9nk9L6hnLdRWfFEcsKpyDAvU34serb3ZHwWjNauJQR7oMH6
         3ViPay0FJPt8yHQZbJooMr8m6//bECsCcIX8jagbicuOVqIK/Md4ww3/bRZUdV6oJJFO
         XjoyrjN26SgGAufOckjNX9tcqRPeqTxmEs7gIbrFOndjU8scRk/06FaWywGNMMpz1jS8
         RM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHYJcDrGIHRFm53VlzRjbvCMqJEk7QWJgVaPxjySsxc=;
        b=XejUUGlBfDsQZdh7BHKCxCPE2ZWAp2kkTlU/P/v4T7vxMZROPtraIZGMKuae9p51mi
         PqFxA7eSfJ362ImEpS02bYaBT7seN0pi043PyeNSlZsdP/5zhpX94BhWcg5eQ7sD/+U+
         1TVay05K6/FL+F2UR1cwXTcpg6Tiayk5+nVEI9lXQxaUeTs++XwcYoLKa/CXHYvcwcqz
         9UKP8l8cbJh07XF0fzW8JjI8x4gRCfBBtkv8u+0yrJYlwxDcjLdek8B737+NOLLtVFaT
         YJTGHaHrxzXV4HGO9y88WHF5yNX4SRIeKT2Vam2kD2AmOen6li1QAQm4M6UWEZxxPIE+
         upkA==
X-Gm-Message-State: APjAAAVt9BSMEjMbEwo9Y/Va4g0gmKIU2rWLq497JQ85dMo8dbdVoBV4
        WLMFE8C2TcKdQYtTIyXp1uw=
X-Google-Smtp-Source: APXvYqwXnlafFfHpV4myorXxHzbctCqnnbxoeLtbqQwzU3btdl1WbZrKGRtpSufWrgl7Pu7p37rKdQ==
X-Received: by 2002:a5d:5283:: with SMTP id c3mr57755497wrv.148.1577531621873;
        Sat, 28 Dec 2019 03:13:41 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id q11sm37432622wrp.24.2019.12.28.03.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 03:13:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] io_uring: batch getting pcpu references
Date:   Sat, 28 Dec 2019 14:13:03 +0300
Message-Id: <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1577528535.git.asml.silence@gmail.com>
References: <cover.1577528535.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

percpu_ref_tryget() has its own overhead. Instead getting a reference
for each request, grab a bunch once per io_submit_sqes().

~5% throughput boost for a "submit and wait 128 nops" benchmark.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7fc1158bf9a4..404946080e86 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1080,9 +1080,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;
 
-	if (!percpu_ref_tryget(&ctx->refs))
-		return NULL;
-
 	if (!state) {
 		req = kmem_cache_alloc(req_cachep, gfp);
 		if (unlikely(!req))
@@ -1141,6 +1138,14 @@ static void io_free_req_many(struct io_ring_ctx *ctx, void **reqs, int *nr)
 	}
 }
 
+static void __io_req_free_empty(struct io_kiocb *req)
+{
+	if (likely(!io_is_fallback_req(req)))
+		kmem_cache_free(req_cachep, req);
+	else
+		clear_bit_unlock(0, (unsigned long *) req->ctx->fallback_req);
+}
+
 static void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1162,11 +1167,9 @@ static void __io_free_req(struct io_kiocb *req)
 			wake_up(&ctx->inflight_wait);
 		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	}
-	percpu_ref_put(&ctx->refs);
-	if (likely(!io_is_fallback_req(req)))
-		kmem_cache_free(req_cachep, req);
-	else
-		clear_bit_unlock(0, (unsigned long *) ctx->fallback_req);
+
+	percpu_ref_put(&req->ctx->refs);
+	__io_req_free_empty(req);
 }
 
 static bool io_link_cancel_timeout(struct io_kiocb *req)
@@ -4551,6 +4554,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			return -EBUSY;
 	}
 
+	if (!percpu_ref_tryget_many(&ctx->refs, nr))
+		return -EAGAIN;
+
 	if (nr > IO_PLUG_THRESHOLD) {
 		io_submit_state_start(&state, nr);
 		statep = &state;
@@ -4567,7 +4573,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 		}
 		if (!io_get_sqring(ctx, req, &sqe)) {
-			__io_free_req(req);
+			__io_req_free_empty(req);
 			break;
 		}
 
@@ -4598,6 +4604,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 	}
 
+	if (submitted != nr)
+		percpu_ref_put_many(&ctx->refs, nr - submitted);
 	if (link)
 		io_queue_link_head(link);
 	if (statep)
-- 
2.24.0

