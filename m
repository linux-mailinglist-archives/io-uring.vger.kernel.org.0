Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF5B32C996
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbhCDBJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346422AbhCDAar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:30:47 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D02AC0613E0
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:07 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id p21so17616310pgl.12
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V3yS4+HM8fGDYKqwaUKlSQjzMNLBWRv1OLyQm1ZH3Nw=;
        b=GfVBCosFIwggslvfgYx3B/ZO9UtW1uKgf6JR8r1wa/Z0OfzVVF/I9m4KL5AtRW/Qsn
         RrhwLW0AYkyaLMRkwa2zA/IsvJVWfy5r8PEdt6TGWnrrxIXuGlXEvBsObQzCvvIh4yAO
         m6x5W6h1F70HXzMYdcUTnkPn6peGIndU1rNqeRHgwgB8NdhaO/Y6ov+0DK+5dQxoN3oh
         uVt1OL66Fwh+/s/SOaFdRiiqELDCnTbYvJxkRGoQgswuONYmCCVErlT7dhLJ7SdMQFCw
         T65i1ukbP1Y496J/0ls4Y8N4jc3mGgT/I5rOeC5xcwuR/Xmdv38g5IuXL7e6O4awWA0P
         0INw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V3yS4+HM8fGDYKqwaUKlSQjzMNLBWRv1OLyQm1ZH3Nw=;
        b=RRc35udOfvbOnfCTfF6vSi5viTjt+OLkFdntXXDrryHmiOaVUGoSViC8C/MzHfLMxb
         Vt8PD56f12uFGPEwALlg3oVMXcc3Wa7CSGVxUF4s88cTYH3t63TU26oaqUpBKrFULC7g
         k7cYt1+v2iLjywZ8Lg+XpUfkw/XCWuou7jXDSUWSDUvuKPCR9CzqJxQWETlkzfNiJERy
         AupwafMjIKYY+Eq7IEpzHigKssupCDOLIIgYHnINB7s00L1ul+3JYfqyhvRphtmsvoji
         0fCN83sYSTGwLw+ZmB9RSPYtUk1w+w92K/SZplUjXbYIjHI1ltx4i0yzcRaIQQaIiXRP
         cMqw==
X-Gm-Message-State: AOAM531uLdNa3GF66AEH9+3wE5kmnShebNrYfX8zhUY1e+JsnJDVKlFe
        BAakWpBr4C15jkFy5+caPMUFkDD07h+QsNtn
X-Google-Smtp-Source: ABdhPJx/+WbnK2eJdn/yZBtH3Zo6Dv0emYEHOhxsuvH1n8xhb6oGMM1rO9bEEtHlA8vgL4adz2z3kw==
X-Received: by 2002:a63:66c7:: with SMTP id a190mr1348023pgc.117.1614817626814;
        Wed, 03 Mar 2021 16:27:06 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:06 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/33] io-wq: wait for worker startup when forking a new one
Date:   Wed,  3 Mar 2021 17:26:28 -0700
Message-Id: <20210304002700.374417-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need to have our worker count updated before continuing, to avoid
cases where we repeatedly think we need a new worker, but a fork is
already in progress.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 44e20248805a..965022fe9961 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -56,6 +56,7 @@ struct io_worker {
 	const struct cred *saved_creds;
 
 	struct completion ref_done;
+	struct completion started;
 
 	struct rcu_head rcu;
 };
@@ -267,6 +268,7 @@ static void io_worker_start(struct io_worker *worker)
 {
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	io_wqe_inc_running(worker);
+	complete(&worker->started);
 }
 
 /*
@@ -644,6 +646,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	worker->wqe = wqe;
 	spin_lock_init(&worker->lock);
 	init_completion(&worker->ref_done);
+	init_completion(&worker->started);
 
 	refcount_inc(&wq->refs);
 
@@ -656,6 +659,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		kfree(worker);
 		return false;
 	}
+	wait_for_completion(&worker->started);
 	return true;
 }
 
-- 
2.30.1

