Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89A03274EA
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhB1WkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhB1WkD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:03 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7C0C061788
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:22 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id u187so9934017wmg.4
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gscA+sh4gpvBCYTgMnUomwssdAmPYcdIatFsjzX934U=;
        b=u9vGD6W8CSYGXswz0uKVJ4ww1soed54tjoTn+1IdqFB7npUSbTEugcbkaJCMiWutnm
         m60hYAs+f6Ao3fjONlKlXHgTEXXs6vz795zJTwQNo6kxaaTVpSsGXHDPND5Nk2FoYoab
         rm17OS0/unuLV1MUc/8j9mjIWqb6dvs/7V1Qe2W/CgytTmahY/kP6qlywXKLmelIZnEg
         vCAaSK6pUQV8y4WMSny6W197GVxHctOnTa4tHT13eoHaz31yJHo11/9KZWMm6RWTk/Mb
         /bOCBeJtnubqVAqIT/AiiHsqiRDz76mwJoXjkqRAGJJJnSTSBungb6dmnQ9P6V/JAKPR
         L2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gscA+sh4gpvBCYTgMnUomwssdAmPYcdIatFsjzX934U=;
        b=bUkHurnz/GeDosrfyhlPHwGoJHChPQVQkq3RBbxDmmKcqusFOHfBXts4S+L+qNJj2r
         rqkjYZguFXq9LdFFGTMBWeF6i1vZ94PkymUfluc3O7WvKwEHdwG3lq4JYSEzu/SxqMNQ
         KZwDQKTLBThywzmyiU60Mtc6BeXfTs1WPBHVZfNwi6TR4q+ohfgAWQSXJHfJ9Qo/v7Ir
         dDX1mgg9yLQc18VqYurncncgPwxGeyzYU+2dmRECicr7zwyfEMOgRU47901DqTN/IBTH
         wzbV+kN1xImAu7O2NJVvndco6RucLqNmYFwOH+T3EyBpXEEleAtaDc5uOB1vxlUfwM/e
         2R7g==
X-Gm-Message-State: AOAM530cjTo0I/Acv6O5Age0i0/nSza+EGk46hrBHaOGKWqjypPHJLHX
        P3lN3zYt+CrT4Ha7XRPlyl8=
X-Google-Smtp-Source: ABdhPJyIGlvEwsn4dhBRxGwszfDVUGgys53aUASEkRCL0FTSKltlOzFowRGnidt8nYuJmp/hsU+n3g==
X-Received: by 2002:a05:600c:4f91:: with SMTP id n17mr12982481wmq.48.1614551961485;
        Sun, 28 Feb 2021 14:39:21 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/12] io_uring: further deduplicate file slot selection
Date:   Sun, 28 Feb 2021 22:35:11 +0000
Message-Id: <6f2b93aceecf5591b845542d18babae13c8bbef0.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_fixed_file_slot() and io_file_from_index() behave pretty similarly,
DRY and call one from another.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 528ab1666eb5..e3c36c1dcfad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6080,13 +6080,19 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	}
 }
 
-static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
-					      int index)
+static inline struct file **io_fixed_file_slot(struct fixed_rsrc_data *file_data,
+					       unsigned i)
 {
 	struct fixed_rsrc_table *table;
 
-	table = &ctx->file_data->table[index >> IORING_FILE_TABLE_SHIFT];
-	return table->files[index & IORING_FILE_TABLE_MASK];
+	table = &file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+	return &table->files[i & IORING_FILE_TABLE_MASK];
+}
+
+static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
+					      int index)
+{
+	return *io_fixed_file_slot(ctx->file_data, index);
 }
 
 static struct file *io_file_get(struct io_submit_state *state,
@@ -7397,15 +7403,6 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
-static struct file **io_fixed_file_slot(struct fixed_rsrc_data *file_data,
-					unsigned i)
-{
-	struct fixed_rsrc_table *table;
-
-	table = &file_data->table[i >> IORING_FILE_TABLE_SHIFT];
-	return &table->files[i & IORING_FILE_TABLE_MASK];
-}
-
 static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_rsrc_ref_node *ref_node;
-- 
2.24.0

