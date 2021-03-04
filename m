Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4224A32C994
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbhCDBJ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243506AbhCDAbM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:31:12 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CDBC0613E4
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:11 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id d12so14986787pfo.7
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yn62TpTCyjDLV+uTyom45Heg/K5sRxz00O/Yz4bwAiM=;
        b=dG7IE5XD1WwgPs3c46/XED1XHS8uw1x9RFLd6uDWbpO8lJeUfnGz6OFTwf9dg3K43s
         vCe8EV0hsS11YUmHDBgbuYrERsbPgFvoZA2m4GGEKiZvfrKRn1m8hLPbwW0Q8ZRmji8y
         HJE+tZnvB1TAzlQhq3bzIFJhQsAga0VRS0g2/IYzpFLy8S6mrMIkBPS+K9OolicsBDyH
         kqwwO8FuAmHer9sITxGbj7RCgCBUCfLESOj/bgWH55WUu9RlAOxfNAkRFgI7MestVGX8
         A0VYWCaJ1sUyg/a6NU+ktc24QfoJgxH4FvnABAysJP4WApxA4ca0YyKGSgCc8cinItCw
         X6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yn62TpTCyjDLV+uTyom45Heg/K5sRxz00O/Yz4bwAiM=;
        b=YN3n42X34F8btenZXyClOTtFgE1fz+mK1x8p0efKBvs08Zk4QuurP3nraSoXcYW1lo
         UCY/XOZg4neRPu98hCYJ8pafVpfXO3mlpSMkPRnIk+LKCLmf121hV32ml3V/Xclxcvc3
         LmLyORT4DbjAbt1GjPCXM2Xf/cl2puCn7NXKqdPGP80v8GN72thwJMI5T0aag+KmeO8V
         ASDdCxa6ndPYoTqwtWltkEvIeIYc0d4zen8b+Mt5QIo7wqM5qA3YAJZT94FsFiWVJ41j
         KqtyN7QMEnU2tmNZuAy4b95JY1Y71UxiiqWCAhf6ETWgGDwqBS/BVUMVUr7kZsMv8sVD
         Z4zg==
X-Gm-Message-State: AOAM531jdk0qVXVPMER2/Zwzxh1DUV2JOnd84fPeDmhKEvTeoebvBjFv
        th5C3SWxTSphAOzDwz4uYhg4043cAuqSnQTB
X-Google-Smtp-Source: ABdhPJxQhGcGyUHcXv3VNB5shkHFQ2xfn1mB7en8JqRIgHSOCJ6QNVwZ5qYPUaTPSP7nntr6e8uONg==
X-Received: by 2002:a63:5044:: with SMTP id q4mr1336860pgl.178.1614817630419;
        Wed, 03 Mar 2021 16:27:10 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/33] io-wq: rename wq->done completion to wq->started
Date:   Wed,  3 Mar 2021 17:26:31 -0700
Message-Id: <20210304002700.374417-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a leftover from a different use cases, it's used to wait for
the manager to startup. Rename it as such.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d2b55ac817ef..a8ddca62f59e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -118,7 +118,7 @@ struct io_wq {
 	struct io_wq_hash *hash;
 
 	refcount_t refs;
-	struct completion done;
+	struct completion started;
 
 	atomic_t worker_refs;
 	struct completion worker_done;
@@ -749,7 +749,7 @@ static int io_wq_manager(void *data)
 	current->flags |= PF_IO_WORKER;
 	wq->manager = current;
 
-	complete(&wq->done);
+	complete(&wq->started);
 
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -813,7 +813,7 @@ static int io_wq_fork_manager(struct io_wq *wq)
 	ret = io_wq_fork_thread(io_wq_manager, wq);
 	current->flags &= ~PF_IO_WORKER;
 	if (ret >= 0) {
-		wait_for_completion(&wq->done);
+		wait_for_completion(&wq->started);
 		return 0;
 	}
 
@@ -1058,7 +1058,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	}
 
 	wq->task_pid = current->pid;
-	init_completion(&wq->done);
+	init_completion(&wq->started);
 	refcount_set(&wq->refs, 1);
 
 	init_completion(&wq->worker_done);
-- 
2.30.1

