Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87D2174E49
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgCAQTq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:19:46 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42928 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgCAQTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id z11so652525wro.9;
        Sun, 01 Mar 2020 08:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9Q+jISeurYhz6U6s7pt/UwZMihLEwkSLaG3qpynjOCY=;
        b=l5oLtyTZSJJ0GkUapkKKRNyo6jp+/TgB/TxY7XLdSUQwNifqGuDbBLrgqQh9KiztfF
         8SIU85nr8MlFOzc7ZZaB1XKdgKn8lu1YqtuH3zPcObCUVGJFUWO55nEUtc3rcBE8Yti0
         DocG113MBwnMXMLNellPRDdKv01CWtG3FWhMmd+ZAER5hepVMkWLIu6pQKe9c/r6EL/e
         rndUNgbuxqolHTiibS09Ybw3UiYpoBeEqtVrkFlCD3TD6XZX+UJwvnHaxHf08WOgbYKO
         GiyWe4pa9a1wpR47o9fpAOaGqS7zaF3P1s5uoZlwu0GPq7Mn8Rpk0p3vMrgPPGOy/6pM
         UeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Q+jISeurYhz6U6s7pt/UwZMihLEwkSLaG3qpynjOCY=;
        b=HHyKxdr6TIhjl6Z10iTrU5ixv/ouEWWTkj0Pau+LjQi9xj0pzoDE7ywVeLjcDQ6wAO
         eMQ18pjuTm0NTuvK0ahPTriU2egPv1yY4yKbV+H6a7DWaoFSIRZXR98YiBVbX3njy1An
         /KsXOzXL68SCV1oGrgsGXS8evYysMPPXuzLnEeMIyn13zJP6/3g+5AQU6W4Ss9azyRUH
         2QOj4n81A22AyccNDO7lXZwFjVQ3jZHZISKuJp0edq9ag/ZxI8AbeKyFQ7eMzz+2eO/Q
         WnPfmX2V/d2E4RavcX9krPbtJ1P5fHEb9UQ5qKGjGW/EkQvmOqqF203RUuMrUrFEQ+QB
         MvvQ==
X-Gm-Message-State: APjAAAVmpXrm8sXmE17X/MayzV5EHUYVyjy6WyLSTZaqEE0gwcXpXqpj
        PowagYE6S/3Cm7z9TdZh9Xg=
X-Google-Smtp-Source: APXvYqwnS9Ufc4mkd4Je1mORHlEo7FjEB4h3SWSfRTianlv1znGeR0QZhaojeRyH8K5npYAP27ViDg==
X-Received: by 2002:a05:6000:14d:: with SMTP id r13mr16726070wrx.63.1583079583957;
        Sun, 01 Mar 2020 08:19:43 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] io-wq: io_worker_handle_work() optimise locking
Date:   Sun,  1 Mar 2020 19:18:24 +0300
Message-Id: <36973f2a05ff0f8e955113e0a14c83a425ee6498.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
References: <cover.1583078091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are 2 points:
- dependant requests are not hashed, don't lock &wqe->lock for them
- remove extra spin_lock_irq(&worker->lock) to reset worker->cur_work
to NULL, because it will be set to a dependant request in a moment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3a97d35b569e..da67c931db79 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -476,9 +476,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 	struct io_wq *wq = wqe->wq;
 
 	do {
-		struct io_wq_work *work, *old_work;
+		struct io_wq_work *work;
 		unsigned hash = -1U;
-		bool is_internal;
 
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -496,12 +495,14 @@ static void io_worker_handle_work(struct io_worker *worker)
 		spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
+		io_assign_current_work(worker, work);
 
 		/* handle a whole dependent link */
 		do {
-			io_assign_current_work(worker, work);
-			io_impersonate_work(worker, work);
+			bool is_internal;
+			struct io_wq_work *old_work;
 
+			io_impersonate_work(worker, work);
 			/*
 			 * OK to set IO_WQ_WORK_CANCEL even for uncancellable
 			 * work, the worker function will do the right thing.
@@ -515,10 +516,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 			old_work = work;
 			work->func(&work);
-
-			spin_lock_irq(&worker->lock);
-			worker->cur_work = NULL;
-			spin_unlock_irq(&worker->lock);
+			work = (old_work == work) ? NULL : work;
+			io_assign_current_work(worker, work);
 
 			if (wq->put_work && !is_internal)
 				wq->put_work(old_work);
@@ -527,11 +526,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 				spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
-				spin_unlock_irq(&wqe->lock);
 				/* dependent work is not hashed */
 				hash = -1U;
+				spin_unlock_irq(&wqe->lock);
 			}
-		} while (work && work != old_work);
+		} while (work);
 
 		spin_lock_irq(&wqe->lock);
 	} while (1);
-- 
2.24.0

