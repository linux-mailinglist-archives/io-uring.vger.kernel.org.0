Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D66351986
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbhDARyC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236481AbhDARpK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:45:10 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF22FC0045F3
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:18 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e18so2095920wrt.6
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wSAK0e7/IBWDROvXMtOQAaYtESS5vD07LmS60Uvyj/8=;
        b=jJtoFRNE7ka5SxnJEksG4OlsxuBJXFknUK+P4MiV7vSKMQn8BzribFhkgXX0f3+cvI
         4vbqrHQ2KsmJ66LEKbN1sBdfuQkiAHzfpQy/yvL4+HXM9Ze0c3r65Ph+Y6ITYi8wYGXu
         ZgEPx21mmn/SHq1+IZXWYD4QLJLjcy32Aal9oreuC9FhSUsV82zhaQFw2lHKpDD1j6Gy
         hWrHfMhQdOKMQLf702XLyLFSLjZGYalwGs1qKNtFFPIFgIpoQI1NAURYOEofhLVoE9Dr
         lrnN9/Gh/5Tf1TGMjZ7+3aHC8w3G8G5y69KCqxmWGt1QOw6nOrUVAS/mZYejhkzkLYB4
         7ncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wSAK0e7/IBWDROvXMtOQAaYtESS5vD07LmS60Uvyj/8=;
        b=TzSeRpl/8Uum5974fY8TPu44mi5sdVfIMH5OSA3LzJNRlhgcfHP8aPJDbwTJO9/25K
         ShxBhOVcODjeZ9tc6vxxDCvqZ1GfmEcxntyja7CrI6dSKsukwPDbS+c6D4lrTCXI6FEg
         FtqkEQncN1PsBVR0OcorkejWlVaptSZIpLBKb599eY+CEtDx9kqQGc5292xl7L31QP5E
         nPHSKKiPai0rDzD9Wv6jgjfRO95GqSj8//xdOHKBz6f9EpxwGLvvUJEAV74KaTLfLlXR
         Oh15sYUxDwHfK7LkThknDCYZzbaaeHuKslsp1+4Dta63LR1WnMAvnnei1KkqUdVo1MHu
         jx2A==
X-Gm-Message-State: AOAM530nInMJYTXPDLCmAAHx8+uV5tGJDDlgbJDOcsW7c2ABIGSnUHig
        mfdQTtaWIgI4DKxLG4aTLJ0fCA7P67R0eQ==
X-Google-Smtp-Source: ABdhPJzcqhNqA0msLdefhaKwBqIvBQFuBMKze0PLB/EBRke9Pd03ZE79x1/Sr8FVsUn95jI1YiLxtw==
X-Received: by 2002:a5d:6152:: with SMTP id y18mr10224311wrt.255.1617288497694;
        Thu, 01 Apr 2021 07:48:17 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 02/26] io_uring: simplify io_rsrc_node_ref_zero
Date:   Thu,  1 Apr 2021 15:43:41 +0100
Message-Id: <3b2b23e3a1ea4bbf789cd61815d33e05d9ff945e.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
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
index 5dfd33753471..f1a96988c3f5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7565,7 +7565,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	struct io_rsrc_data *data = node->rsrc_data;
 	struct io_ring_ctx *ctx = data->ctx;
 	bool first_add = false;
-	int delay = HZ;
+	int delay;
 
 	io_rsrc_ref_lock(ctx);
 	node->done = true;
@@ -7581,13 +7581,9 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
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

