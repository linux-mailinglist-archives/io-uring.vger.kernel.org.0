Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D5E1D679B
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgEQLPI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgEQLPH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:15:07 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6839C061A0C;
        Sun, 17 May 2020 04:15:06 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id v5so5463638lfp.13;
        Sun, 17 May 2020 04:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ug9cBx5/9T7NfeIfM5vZh3BhF2fZGveeP0Cu7s5a0HY=;
        b=F2UANZ5ErpvD1vCEztgBMke3OySxlxHHfDbr+s49PBv6x9+6RyEExT9J3xhvKmDVTk
         ptuMBRHWa58Wt5aaCP+L4jQMcmB5GIcQQHJOTurPyx6QhpyZRZQ+XkpvGeQCCm8iPrBy
         Hr+eInpcMxjP7/a36f/shxNU6/ctCiFQnKpQgIOiaKKOho0INQ3ZSHM3mADIw3hR3kvn
         PnTsiLoBUXUK8r9ISyTJp76vC1q9lVXEFxeuJXcem7dele8b5KZoeyDGbhUd7ndzrqvj
         5tn1IP1CTeQwraHy4DOZ6Kcvqsqaf1k3dJPvL1/I8eT6cfjZdIiJCfNADDh1K023Wa1s
         P3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ug9cBx5/9T7NfeIfM5vZh3BhF2fZGveeP0Cu7s5a0HY=;
        b=jcMd3umk5hRPh3kJoxoR93zWeVfGWWjPiNQ9bpHF8z8xRyq0RgM4CKqQfOLIzQI3rO
         IMycS8mJtXulsqb1UvwOo/A0nhgy6rIBzQkQ3Utnt8Tu94yRs0g3NycCSrPAjfFlfCSN
         UldvvjAl4BHiPM6/W+mGivPo688jqLLDhelzE9eSKx+UCRQUXBaqzwXi1PTw4t8HRwsj
         HU+ghde4qLss96n8QNEqWdp7CufUqvHUFSnHlwKHJxU8pa+vV8ez8CbTgAQzuO0bycJ4
         RLS++Itzppmr3CEz4bc81s56Vih/DG0OSwgNJEZgRp8zbfYUsed0I8D2B2ta1F5dMczO
         Hj9w==
X-Gm-Message-State: AOAM533rTLrb4XWcdpnO2GfQzStlKyuk7/FGZsnw8IjNOG4kcrhlrTty
        C14Am8V2M2EFTH3rhzzAcIs=
X-Google-Smtp-Source: ABdhPJwE89XKdvNmeIzjy2cl6cG9uT1YAj2Qz3JXu1+GC/b5hXXOUFazqGzOHY9ubu/7ErjU6VJSKg==
X-Received: by 2002:a19:c64c:: with SMTP id w73mr8002030lff.67.1589714105354;
        Sun, 17 May 2020 04:15:05 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id v2sm3970990ljv.86.2020.05.17.04.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:15:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io_uring: rename io_file_put()
Date:   Sun, 17 May 2020 14:13:41 +0300
Message-Id: <b9125175eb3c0e218e4d56958df09fa0220c691c.1589713554.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589713554.git.asml.silence@gmail.com>
References: <cover.1589713554.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_file_put() deals with flushing state's file refs, adding "state" to
its name makes it a bit clearer. Also, avoid double check of
state->file in __io_file_get() in some cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 739aae7070c1..9c5a95414cbd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1999,15 +1999,19 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 		wake_up(&ctx->sqo_wait);
 }
 
-static void io_file_put(struct io_submit_state *state)
+static void __io_state_file_put(struct io_submit_state *state)
 {
-	if (state->file) {
-		int diff = state->has_refs - state->used_refs;
+	int diff = state->has_refs - state->used_refs;
 
-		if (diff)
-			fput_many(state->file, diff);
-		state->file = NULL;
-	}
+	if (diff)
+		fput_many(state->file, diff);
+	state->file = NULL;
+}
+
+static inline void io_state_file_put(struct io_submit_state *state)
+{
+	if (state->file)
+		__io_state_file_put(state);
 }
 
 /*
@@ -2026,7 +2030,7 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 			state->ios_left--;
 			return state->file;
 		}
-		io_file_put(state);
+		__io_state_file_put(state);
 	}
 	state->file = fget_many(fd, state->ios_left);
 	if (!state->file)
@@ -5799,7 +5803,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 static void io_submit_state_end(struct io_submit_state *state)
 {
 	blk_finish_plug(&state->plug);
-	io_file_put(state);
+	io_state_file_put(state);
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
 }
-- 
2.24.0

