Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6920119FE68
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 21:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgDFTs7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 15:48:59 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32921 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFTs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 15:48:59 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay1so269068plb.0
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2020 12:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P3DAhQdZsB2ntsSBEchLsUstvGbBE01XERokq0+hOgU=;
        b=1QtI5WBISVHV7N9bSpbzx/cZ+YANxdVRJ7sD2UZlHUZMvRhW7vDavbq8RtPCa2DUuJ
         mMB/zmvImz3D+hwM39yOnbYqUZKRvVlbiGKGDyvNSkj9RiyoajfOvID8gHvoDeSJPMFG
         b8KxdUiE82lHja8vHugppzR/87AOxD5eDgBbfaoUAOLXQ1j9zrCRhea5FDXP1WmRQXVh
         TziA9waCPPW7WZYxtrO3pyLKkhrjqGyljKTUiLtqILE56iIrB7aPuf/aziGFXfSv5X1m
         6O6PieDITbdm5dbKzXFm1LnMRyYkriDsT1shAuUQ+BTYTQimVglXZ/szEHn8UIWE8g1n
         6FRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P3DAhQdZsB2ntsSBEchLsUstvGbBE01XERokq0+hOgU=;
        b=mgM7Nkq8PxKustB0FPngofHtOApBHCFBlAaBS76ctqapjBejujHX5u+djjhF+cBEyu
         1oolUKW1W+jXElfi8vV3g61Mn9G66adAhM2d9IamVVmBj6RUz1SonqAv5p+7caNvRhyw
         FG4K4tLvZCt+bKJCPcuq0tDYnRysJDoncQGa47hH9EFFQv6fNxmJ5mJ/n29IpR5h47Tm
         ifSvywclcSKXEHU5U3iuaz093PJnAq+3FgnAe2o3p9l9yZg9zMDIvU/04qynshic4pMc
         BVjFHXCLt1ot8dJCrxsA8598wV2alYQ12v4f1drudtpYSB7/iiuybKpNwXQ3mzWzo51H
         hqAg==
X-Gm-Message-State: AGi0PubA6u3Lp0s9B4LtmoxP8Ny3C7MkRVF44X5p1UPG8R+jIEELCAb2
        tWihdLYcIE4a+yIY4s/5c0BVBQ4I/cp8hw==
X-Google-Smtp-Source: APiQypIfxtFrhkUqHcoNqtY3zaYVKGxe7PWmaaPDwfzkRh7NW3KuZyVufjUBgCiig/m/1MzR/5Czag==
X-Received: by 2002:a17:902:8f8b:: with SMTP id z11mr10808582plo.189.1586202537588;
        Mon, 06 Apr 2020 12:48:57 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:7d7c:3a38:f0f8:3951])
        by smtp.gmail.com with ESMTPSA id g11sm362620pjs.17.2020.04.06.12.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:48:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] task_work: add task_work_pending() helper
Date:   Mon,  6 Apr 2020 13:48:50 -0600
Message-Id: <20200406194853.9896-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200406194853.9896-1-axboe@kernel.dk>
References: <20200406194853.9896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Various callsites currently check current->task_works != NULL to know
when to run work. Add a helper that we use internally for that. This is
in preparation for also not running if exit queue has been queued.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/task_work.h | 13 ++++++++++++-
 kernel/task_work.c        |  2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index bd9a6a91c097..54c911bbf754 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -15,7 +15,18 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 
 int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
-void task_work_run(void);
+void __task_work_run(void);
+
+static inline bool task_work_pending(void)
+{
+	return current->task_works;
+}
+
+static inline void task_work_run(void)
+{
+	if (task_work_pending())
+		__task_work_run();
+}
 
 static inline void exit_task_work(struct task_struct *task)
 {
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 825f28259a19..9620333423a3 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -87,7 +87,7 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
  * it exits. In the latter case task_work_add() can no longer add the
  * new work after task_work_run() returns.
  */
-void task_work_run(void)
+void __task_work_run(void)
 {
 	struct task_struct *task = current;
 	struct callback_head *work, *head, *next;
-- 
2.26.0

