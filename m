Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3123223F4
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhBWCAf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhBWCAc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:00:32 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF51C06178B
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:51 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id 7so21017621wrz.0
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sXZojVqlHeNZnJMAkjTkqRa+ROEbpyhnF8arLc0vvFE=;
        b=Gh3N/oAAGwBY/W4YRyF1jsEOZR0agMYkG6Ugg9KH5RdrXAYL/9D7sOMmP1ZZNcsWHP
         IaOSl4xTI6LCY+qpIQ3pqhTtbY5wxE0dr5p6n5R+ihPm3JV4cyfwAqMVyDy92f9sZJOO
         s/91+3JymNSBH7hxukKtW2GubCPcuynxVOa00KDi5yxuNaYkmtMYZ5/E8fvzn4aIuEf7
         +utNcqgI5c6Gh949MoKThKo+R7qcWCGM6CyIMj63UdEglAJJN8rh/K9QQybBWFxHOqWo
         siRQxjbfUwnzxdkyziQCY3sreq8EXlGq6ZqyMyA5OOuU93ia2i3GFqjxScVL/gRPW+DC
         Ix7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sXZojVqlHeNZnJMAkjTkqRa+ROEbpyhnF8arLc0vvFE=;
        b=KuKycmECQZT0k74xbTPesFXheo77uGpyYX23QadG0NI/9y/KaozFTcXdkbuN52Xklq
         HYU/Bi/ODlJxQjFlcneBb/d3jI1xLPOYn/V21/JbALb74tdtXw5Kq91wC+AMQk+3rmUm
         HItijKzHn/P+9A5UE+MM7Qmyr/1Nwjd0ZYtLECX3tWjF4Uuodh5f2+HZRii4d0BaKS33
         Hm7uVpKangYWsnU90mer7p+jlBh0PDCYOQoHHhZyfWezn/FvoTWQQrHZI7zs1SgCx/Zo
         gD7lg8+hu61Qc0dZjIE/4ZgeH2aSC+Db0PxSCw4dgGOpsO7wZzMo2mVQQVMjwgokYtNe
         6AHA==
X-Gm-Message-State: AOAM531pAcVW91Mlk7Pyz3pfRi9Lk11ibOgdE1C0/uuWSFRsTQ1njg1/
        KBUp0yKucmLhdVfP45X5FFA=
X-Google-Smtp-Source: ABdhPJyrop3TMdTTeghU0EpdsXAgVNvTMkAmkOWV7ZRcgyZZ2agIbC2xdnhcFiPSgdHKbObKemOKbA==
X-Received: by 2002:adf:8185:: with SMTP id 5mr24561533wra.288.1614045589893;
        Mon, 22 Feb 2021 17:59:49 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/13] io_uring: further deduplicate file slot selection
Date:   Tue, 23 Feb 2021 01:55:39 +0000
Message-Id: <c876d6b589158b375105b4910580b9d55f9856f0.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
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
index aa2ad863af96..0f85506448ac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6107,13 +6107,19 @@ static void io_wq_submit_work(struct io_wq_work *work)
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
@@ -7422,15 +7428,6 @@ static void io_rsrc_put_work(struct work_struct *work)
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

