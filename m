Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376AF433F4D
	for <lists+io-uring@lfdr.de>; Tue, 19 Oct 2021 21:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhJSTe1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 15:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbhJSTe0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 15:34:26 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE81C06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 12:32:13 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id a140-20020a1c7f92000000b0030d8315b593so4939604wmd.5
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 12:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tkjmSEDF4BeLNLaZLLfDpEya2OB0ozRvDR8UieFq8mw=;
        b=Yil3QonhCubkflZWTCT6PED2dijn3NwuH0fylKSJWbl59+moYkXfuYG4EuqaYIJ3o6
         D9sPwO7CR8xB6Lu+19pfn29P1EM3ci3PWhYZ9KdfbIeaEelCv+cU+3mlqskiUMoDRytY
         Q/hu8pgAJh/nrDPK/g5J9LWTizbR7e5ec79LCORyT/i3hZT+1053ta8+wd3V17UowLhQ
         uVmucyYrCl058k0U11M2auFVCk7v+7kJqmr6P7LlXS/8BjRUG9Ej2If5nMlwcuTyeRiE
         DkpwipSvZy/xRCjBRtLhhNehq+Mvu4siowKPVYtXjYMh7AH4KhImfuh/aAZRJePcfyp4
         hBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tkjmSEDF4BeLNLaZLLfDpEya2OB0ozRvDR8UieFq8mw=;
        b=5OyyULtTNMkfp1DbjNY9mduZGxkzRuuyVVz88L7OpgJScAIGtKgRs/rTsaG7GaGT1/
         3b9zsTZOYu61fKdFsxgsYJwZXmyePczJsPdUR1aMBxyXy8NljFemCcSEFwgRs2QyBF+P
         VCELy0N+UcCFe4gOizk4lPcuE8OQRfuNKh/eUbG+qpzSyvD0qkzf08M2PmyHJAgPD1l/
         IKqFn85/YQLkKc4+Gnv11XtGeX1Spl/aj8ZoWL+4yvjvtju23XGceiXD+7bk6SKTgAIV
         pT8yKcY9SQVLFtoAlyqR44s33Mjp1YbGMUhaTP2q6mBYhG1bTueDdeUWhfRTGZUO25cE
         7cZA==
X-Gm-Message-State: AOAM532hyTbXXET4TsPl90qTvNGryjdJeBzIU8EpAjeyYpWP/uoNRIq1
        alUkNi6wG36hJZTTznCEsUXp5xx0Y/uNOw==
X-Google-Smtp-Source: ABdhPJyxcqLQ+eHbsmUnfJzfF9ixWVmt6WtMEF3kdyqXtvwl0zD/kNNYfyI1pScO22iOBWaJ4n5Pzg==
X-Received: by 2002:adf:a51e:: with SMTP id i30mr47278273wrb.206.1634671931581;
        Tue, 19 Oct 2021 12:32:11 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id z1sm5990056wre.21.2021.10.19.12.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 12:32:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.15] io-wq: max_worker fixes
Date:   Tue, 19 Oct 2021 20:31:26 +0100
Message-Id: <11f90e6b49410b7d1a88f5d04fb8d95bb86b8cf3.1634671835.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First, fix nr_workers checks against max_workers, with max_worker
registration, it may pretty easily happen that nr_workers > max_workers.

Also, synchronise writing to acct->max_worker with wqe->lock. It's not
an actual problem, but as we don't care about io_wqe_create_worker(),
it's better than WRITE_ONCE()/READ_ONCE().

Fixes: 2e480058ddc2 ("io-wq: provide a way to limit max number of workers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 811299ac9684..cdf1719f6be6 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -253,7 +253,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 		pr_warn_once("io-wq is not configured for unbound workers");
 
 	raw_spin_lock(&wqe->lock);
-	if (acct->nr_workers == acct->max_workers) {
+	if (acct->nr_workers >= acct->max_workers) {
 		raw_spin_unlock(&wqe->lock);
 		return true;
 	}
@@ -1290,15 +1290,18 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 
 	rcu_read_lock();
 	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
 		struct io_wqe_acct *acct;
 
+		raw_spin_lock(&wqe->lock);
 		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-			acct = &wq->wqes[node]->acct[i];
+			acct = &wqe->acct[i];
 			prev = max_t(int, acct->max_workers, prev);
 			if (new_count[i])
 				acct->max_workers = new_count[i];
 			new_count[i] = prev;
 		}
+		raw_spin_unlock(&wqe->lock);
 	}
 	rcu_read_unlock();
 	return 0;
-- 
2.33.0

