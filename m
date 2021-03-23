Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BF0346328
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 16:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhCWPlS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 11:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbhCWPlK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 11:41:10 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F063C061765
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:09 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id d191so11298830wmd.2
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1lgdxUViKuWWIDdG438HIIaVZgn63bsbSOyXiDdZOLw=;
        b=eWGOeH5AXPvYEF6sBcH6CQLjywBSe9Esg009nEbkn/+XBKoJzJUXedqwZj2PLaDDTi
         BNT8iZqhKas+kvjN6upYmDL61DS236WSsxZx+y19T3kiSGcKQHhRIzwi9hqkQvv1StRt
         mmMCI1fTn2lGCDsjAyQ9Lj/p9FOsoEDt/6avUyyz5qMi23PXBhzAf5UrJkqb7SMx3Onm
         5YEnv5zWKj9D7WoWppOJXlf0vb+Eqw5+ZEWRSuRQYOVAxeZDEZT0/21wVf2Y1fLGiorJ
         aZRYw1TqDU7vzhdoWKw7YU+h17nQLpfIC66ChUgF9RiwFaV1UH1040nbURTUZVFZH3Ey
         /Lww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1lgdxUViKuWWIDdG438HIIaVZgn63bsbSOyXiDdZOLw=;
        b=UBipnYmzjbs3Kb59Ia/noZ7jRF3TtUbl/7i9dBezrFJHiT/lAcNXRrjA5gKTveQ7YB
         dHXsTmKlD4OewagVHlsy4S2ZioDhgUFKEG+bLBSesrHEQUcP5HJ4T5z7pFhZsuj15YKM
         FXN27u8sWapc0GxWtDF0PpwCfdVLv76tmG6V2euI0KMYgfe8VS8WJDU5rb+Ls3+dvEwP
         1lncflmUIdmkFY5NcDG9XlymPmx/8paSiZuHtSTGgvHjXlBn8xDPRgGPwajxujR9NWx3
         Ic3hZhPFFqDGW6wUz8NjgNwzN/wIql3g7Lvp4W3HtPvVtOpLJQF1GhLxd1s5p9Yol4yt
         /J3A==
X-Gm-Message-State: AOAM533lrLEf2vPij6Fu+sPG/YgljpopZq7R52UCvV6bwY/UEcJIA3H9
        PFnrcVEwap/5wcjymIVvj/ikxTmd9A/3RA==
X-Google-Smtp-Source: ABdhPJyIJMRibUFwZel4HZhswEihP2liqc7DxZRvkZRk6y3oTXJmuts0E4txteS8VbA1Ev6Sv+N6oA==
X-Received: by 2002:a1c:e482:: with SMTP id b124mr3883359wmh.70.1616514068098;
        Tue, 23 Mar 2021 08:41:08 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id u2sm24493271wrp.12.2021.03.23.08.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:41:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/7] io_uring: simplify io_rsrc_node_ref_zero
Date:   Tue, 23 Mar 2021 15:36:53 +0000
Message-Id: <b589ce62c73cd9a65858ac8ce4e2e5846b43ec0e.1616513699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616513699.git.asml.silence@gmail.com>
References: <cover.1616513699.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace queue_delayed_work() with mod_delayed_work() in
io_rsrc_node_ref_zero() as the later one can schedule a new work, and
cleanup it further for better readability.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2ecb21ba0ca4..8c5fd7a8f31d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7448,7 +7448,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	struct io_rsrc_data *data = node->rsrc_data;
 	struct io_ring_ctx *ctx = data->ctx;
 	bool first_add = false;
-	int delay = HZ;
+	int delay;
 
 	io_rsrc_ref_lock(ctx);
 	node->done = true;
@@ -7464,13 +7464,9 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	}
 	io_rsrc_ref_unlock(ctx);
 
-	if (percpu_ref_is_dying(&data->refs))
-		delay = 0;
-
-	if (!delay)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, 0);
-	else if (first_add)
-		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
+	delay = percpu_ref_is_dying(&data->refs) ? 0 : HZ;
+	if (first_add || !delay)
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-- 
2.24.0

