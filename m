Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702FB17910E
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 14:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388104AbgCDNPR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 08:15:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42254 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388097AbgCDNPQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 08:15:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id v11so389750wrm.9;
        Wed, 04 Mar 2020 05:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yvd1qcy7+dlyPpqW9WsWcvGKMgkr1aBgo5o930iSsj4=;
        b=pChR2iAc4G7nRIHIohmqYlndTcLbWMTRoae8Xpjq1DOB/xrztyT/PW26Oquu6JrIoP
         nXf+26eUyI5stfcgIf5X7L+AcjEvNbk9H8sB/d7ednt7nwyn2ZUZeLiRyw9E2fQ8SlUb
         zT9anY8VIzgOXxSFNfmPj/0KKLCf0F1yEzVL35uzQNlz8UfEVfZq+ltyjnLnXEOl6W3L
         XzwKZ0CTiVUp9TDYUIEaMcaqFxrkIiIVjjDD+uf6WbxWIw6sCPTN4U3A6HWXcTB03Ujm
         NZIRh7UAlTblqQdCeG8TL5t3H6ubt5zIx+aJMQ4AqfMPXuasNrT8M/ZQftFwRojh0sm2
         q3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yvd1qcy7+dlyPpqW9WsWcvGKMgkr1aBgo5o930iSsj4=;
        b=cXpz5WiwmgnNPm/E4Lz7jL5iuCq1SybdCa3gvfsgEo2oVMf6mgqw4tfjUzoEHYf0mr
         +a7iEFIJDUXdzgwJVKCA41P6lBMQFsEUpSjQMNlY7oLqwJjceZLV+btvYs6gsyPAIbUD
         YFXu+Q6gsT2uHJLVMQeBIiJ92ANXGHyvmWmWjyTd/XZFVwT4Kr/WXgpKD0S94DWuLhDi
         9Z5/QBWPeQNNaxSDDNVepUMqIOJ5G3VDrCS7UPTQtrjtUSUsT4leIXn6Os2z8yX+j31B
         X90UvNW+S4knd3E5alCZEFjwrz8gjMM4m0b/Zmxdy3325vWAGyTpTo4k+zIiT/HTl1ie
         nlyQ==
X-Gm-Message-State: ANhLgQ3vNvJK8U3jW65fWtFpPEkt68cgthESz53iW/fLRkzyvrrc3+LS
        U/yKfgVtY733e7DMzb+UyR6l9Bnv
X-Google-Smtp-Source: ADFU+vva4m9ywSSoYa2bHkt7fHmq0gxjLf7vaGuvLp55T396dvKJPg9edTGVjrr9Yed4H4BPEqwsHw==
X-Received: by 2002:adf:e74e:: with SMTP id c14mr4283728wrn.128.1583327715105;
        Wed, 04 Mar 2020 05:15:15 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id c14sm24746746wro.36.2020.03.04.05.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 05:15:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] io-wq: optimise locking in io_worker_handle_work()
Date:   Wed,  4 Mar 2020 16:14:10 +0300
Message-Id: <ca39ae1c7b5cb8c86666e3aa9b80bf191949d4c6.1583314087.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583314087.git.asml.silence@gmail.com>
References: <cover.1583314087.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are 2 optimisations:
- Now, io_worker_handler_work() do io_assign_current_work() twice per
request, and each one adds lock/unlock(worker->lock) pair. The first is
to reset worker->cur_work to NULL, and the second to set a real work
shortly after. If there is a dependant work, set it immediately, that
effectively removes the extra NULL'ing.

- And there is no use in taking wqe->lock for linked works, as they are
not hashed now. Optimise it out.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e438dc4d7cb3..473af080470a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -476,7 +476,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 	struct io_wq *wq = wqe->wq;
 
 	do {
-		struct io_wq_work *work, *old_work;
+		struct io_wq_work *work;
 		unsigned hash = -1U;
 
 		/*
@@ -495,12 +495,13 @@ static void io_worker_handle_work(struct io_worker *worker)
 		spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
+		io_assign_current_work(worker, work);
 
 		/* handle a whole dependent link */
 		do {
-			io_assign_current_work(worker, work);
-			io_impersonate_work(worker, work);
+			struct io_wq_work *old_work;
 
+			io_impersonate_work(worker, work);
 			/*
 			 * OK to set IO_WQ_WORK_CANCEL even for uncancellable
 			 * work, the worker function will do the right thing.
@@ -513,10 +514,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 			old_work = work;
 			work->func(&work);
-
-			spin_lock_irq(&worker->lock);
-			worker->cur_work = NULL;
-			spin_unlock_irq(&worker->lock);
+			work = (old_work == work) ? NULL : work;
+			io_assign_current_work(worker, work);
 
 			if (wq->put_work)
 				wq->put_work(old_work);
@@ -529,7 +528,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 				/* dependent work is not hashed */
 				hash = -1U;
 			}
-		} while (work && work != old_work);
+		} while (work);
 
 		spin_lock_irq(&wqe->lock);
 	} while (1);
-- 
2.24.0

