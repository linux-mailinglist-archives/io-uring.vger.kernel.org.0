Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16674351832
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhDARoR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbhDARjS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:39:18 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B101C0045FE
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:31 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x16so2104557wrn.4
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+6V1gcmMJW+HhZl07X6y1rGQPOCvMHoxbm1Z544xQLs=;
        b=GDwff2sFPPOR1eZAb10sQNwWThpZQz73olK5HdJEOpVA6+GPTR9XjX3gNjj7bs1cYu
         LOzIwLORnciOpH5UZIslTPv9o8vnGpNQibJ4Z46ry+kWaUxVGnYDPByvzMzba2SZl56Y
         TJRNgCWob90UxcVj5a5WEZ8IfNGLVaYUHY2yU4/Zm7gBX5DbI1MWJGeKd4r0dfbf1ohA
         C/BjW1ythNE911UKhmLdeQMP4zGOj1tDebzeLhLF7q3hQqakQhYlqx/jhl5fZfG9Wq4f
         jRC+sa6ULquxOpkBM/AZevBQ2wGVDJh7RGklaK2HF+qf+w2AisjdfzK721lm/2aZLQf/
         cwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+6V1gcmMJW+HhZl07X6y1rGQPOCvMHoxbm1Z544xQLs=;
        b=oH/HLujGc9L9s5S1wrcVnBS3h2/ptv/iyIPTjKzU1x/q84EcAIrmSPjMQiy8pkLX5I
         32EZx6AItFMIBh3s5pXO+nehpIF9HZgWyldoaXuhyG8nqDCCGC+t/ESHXuM/EQshIVmx
         4dldWUoCwQ+tmEDyohtUSU58zKg2SUVUnlksIEeJERzO3dXAvyNqCKiMmvpl8/fE/0U0
         ZScnqOYfo/3VKSd40cqRYAG3tDFTkDH7Jc/0DmAog7YCA45MUqJyLRJ7O7cMx2J7SvUi
         qK+N0/UCEXEED66ajzhGLsB2GlxgprS9tBw2yNKwD6LJDT50esgeMGsM0iV64S7Au452
         annA==
X-Gm-Message-State: AOAM530QkFs6MmFElYPa9ZkU7GMPCKxAW8UtXtrnu51RpVyjkmDQ53KJ
        QqZxcWzCDzskj8IF6Gi/7j6Fd6g0TC5UKQ==
X-Google-Smtp-Source: ABdhPJxWtsAW7e0+vHEQFrk/BvtktkGEo0V3o4acxCk+Ba0+Ld/4yqECCpCqNC43NdskhZgE02frLA==
X-Received: by 2002:adf:f843:: with SMTP id d3mr9994261wrq.55.1617288510369;
        Thu, 01 Apr 2021 07:48:30 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 13/26] io_uring: remove unused hash_wait
Date:   Thu,  1 Apr 2021 15:43:52 +0100
Message-Id: <e25cb83c233a5f75f15275596b49fbafbea606fa.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No users of io_uring_ctx::hash_wait left, kill it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf3eeabda71d..4314e738c2ad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -455,8 +455,6 @@ struct io_ring_ctx {
 	/* exit task_work */
 	struct callback_head		*exit_task_work;
 
-	struct wait_queue_head		hash_wait;
-
 	/* Keep this last, we don't need it for the fast path */
 	struct work_struct		exit_work;
 	struct list_head		tctx_list;
-- 
2.24.0

