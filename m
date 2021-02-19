Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40FA31FD99
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhBSRKh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBSRKg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:36 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59B5C06178B
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:21 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id a7so6323182iok.12
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q9hgfhuN9gZBrzS7BAt0V6CDx4lU2AnH1RyAIwy8kus=;
        b=xYiGOVBlSkA1hifgnzcb0Gk24Tzb3O/+UI3HvWOAluTIlXkIuj/Ej7mkvXpWR5ElBp
         pt1W4xR8MYuFuSfvqEm2+CEHRAau4TUdxVHtWhWojTmLYsMfPGkk7VGwCUU1P8NDl9C/
         nTqUnUEJ8JuXQrX2TjNC1JjteRdGxL30Gpw7pdVCU/ckploG1i6YG4rE8lyRT/OWfweS
         z5VUsT7h0bRrPVDzNTHbXQ18lHba4TTQVvtYtCF/opwy7DJwndwneMolooPuCRY0zg5U
         XVQlFc7L+WjVoIVC1jW5yHVk2P3r0WadHm27TaeF/T6sYlA3Yu6tSRqLCIKDe58qvCQt
         pLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q9hgfhuN9gZBrzS7BAt0V6CDx4lU2AnH1RyAIwy8kus=;
        b=BqsZvU1bvxqmInBA1ZgmObLE4VEi35oH9UNXsQMwu+nut7fOcUooJ2gFqGCcXkPC3p
         dPAScKj3vbYlhvxnEaGyixTK/ySOxyWs26o/lfNe/Q0TF031fay1iCGXypzLRYVBKm7p
         GuxIkTcrocqbFvl0cPEJhebRy7pjIDE7h0lNRB6hGwwXBxDhZIfyIRazz9N7CelvzlVU
         Df5LqjlNmDusce8Samn89Czwhcuqo/civa2g3YzMIOdqfpNX8Ds0Vskli1DsKXKy3OKK
         IEGnYjT1Ykxgheq+btv80K8mubfD1C6lZU4qlk5Hz51ReVyVkKEU6IviG9B6BKNpSweR
         iTkA==
X-Gm-Message-State: AOAM533JsDHNciEPuZwgNVHNNlBhocftRK+DbldHhxClV+pjI6FDzwsa
        dhqPGvrIIZSIdf91KjM8sy/AcWmTIL+9h05V
X-Google-Smtp-Source: ABdhPJzAHoj3IgvBnlXS18d2DWLFvrLZ8CTP1z/bG5awGz/QxhCtKAg2jfEt5hhx162dTzNRuzSloQ==
X-Received: by 2002:a05:6638:385:: with SMTP id y5mr2969057jap.43.1613754620798;
        Fri, 19 Feb 2021 09:10:20 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/18] io-wq: get rid of wq->use_refs
Date:   Fri, 19 Feb 2021 10:09:56 -0700
Message-Id: <20210219171010.281878-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't support attach anymore, so doesn't make sense to carry the
use_refs reference count. Get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 19 +------------------
 fs/io-wq.h |  1 -
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e9e218274c76..0c47febfed9b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -122,8 +122,6 @@ struct io_wq {
 	struct completion done;
 
 	struct hlist_node cpuhp_node;
-
-	refcount_t use_refs;
 };
 
 static enum cpuhp_state io_wq_online;
@@ -1086,7 +1084,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			ret = -ENOMEM;
 			goto err;
 		}
-		refcount_set(&wq->use_refs, 1);
 		reinit_completion(&wq->done);
 		return wq;
 	}
@@ -1104,15 +1101,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	return ERR_PTR(ret);
 }
 
-bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
-{
-	if (data->free_work != wq->free_work || data->do_work != wq->do_work)
-		return false;
-
-	return refcount_inc_not_zero(&wq->use_refs);
-}
-
-static void __io_wq_destroy(struct io_wq *wq)
+void io_wq_destroy(struct io_wq *wq)
 {
 	int node;
 
@@ -1135,12 +1124,6 @@ static void __io_wq_destroy(struct io_wq *wq)
 	kfree(wq);
 }
 
-void io_wq_destroy(struct io_wq *wq)
-{
-	if (refcount_dec_and_test(&wq->use_refs))
-		__io_wq_destroy(wq);
-}
-
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
 {
 	struct task_struct *task = worker->task;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index a1610702f222..d2cf284b4641 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -108,7 +108,6 @@ struct io_wq_data {
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
-bool io_wq_get(struct io_wq *wq, struct io_wq_data *data);
 void io_wq_destroy(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
-- 
2.30.0

