Return-Path: <io-uring+bounces-2458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3EB9298DD
	for <lists+io-uring@lfdr.de>; Sun,  7 Jul 2024 18:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A623B23BDA
	for <lists+io-uring@lfdr.de>; Sun,  7 Jul 2024 16:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93EB41C63;
	Sun,  7 Jul 2024 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPZYCClK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C7145BF1;
	Sun,  7 Jul 2024 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720369936; cv=none; b=S0M7HBMNsFfqoAzhS2J9siX6ZEgSzuD0R4Q/sGpFEkfvarh57em+b0gYxBqngBZts3R2sFKoifGMXjSndDfuGLFtCfdBZl+oqFFG3oczSe54I+jklbEKhEZNLMVaGkRPKqSZfEgNqfvNNuR5RPhYC2k1XAGrqXIXC2Klo4kqqkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720369936; c=relaxed/simple;
	bh=P+TJsos0wRuICzWhaMFgjmN4/yDzbtZJ6N0VJY3WNCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yv579bh6xBQpqW4/HF6h3N4hy4dQzbVRUAnHEUCiqgmU/wwBMTNShc4fNqGDySckHPLPwzS/HDClp/H3xgOcTqX552LRLh2esrwHDnmJAsP0dKqy7ESg8fqNkIvJGjGKWYg4C238fGRTEY2RV1ybXY1Mnf8l8QdC9mhVon+1zjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPZYCClK; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-426526d31a3so13428085e9.1;
        Sun, 07 Jul 2024 09:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720369933; x=1720974733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttgYBK7CIbyCBuvHefwURr58xYqG6L2p5WKp4rRTzQk=;
        b=NPZYCClKAvuT2t/NZf7TU5d6W0DaARUVGuU7QKJo3cIJPiZDsZuonTb6WARqmnn2UU
         Beq8eCTp1PK+Fici3Ewr4fGzwtE5lEt/wm7DIcwsDUOeO9jOIy3hihShRSQpSnLl4y65
         OmwO9GrygHOQDCxDgjEQrwgDSflWrlTHP1ABH/Jt4pBVjTRu4L3CUffEOQpF5J9LaWrl
         IaGD1dIKV0XtyVUz7HxVVCbl+1G4qoU8XwA300w6zEreaXaNVj4N+qlCXEakTttNU6//
         NESpQZK9SQ23BTLYfW/GYpjrBv0nvMpATwGsl01LH3j7EiU7yoUrOBZ54jAFITPNwjrC
         1VAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720369933; x=1720974733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttgYBK7CIbyCBuvHefwURr58xYqG6L2p5WKp4rRTzQk=;
        b=wgqlBLnjR3Md1H7jWv7m8VAHXg07xCVC1PLcNJxtN8XuVE1N1xsStqIVYzuCr0dY54
         RuMuKSimGVtnjt3pKso4E4r11mplx41fxXJtL13UqF9A+RIBNQvKrf3Ji4X6JBGvhbKR
         bdquiMSqWzKlY4a2HXl3h1Z+QPA72ZulHwSUhDUMYhiXz2dyrke5W0Ezjm0QpQpgGr0q
         fA+ANj2e2UOAnka5LR6z+lizzz0icbRHOQlzyD4fIVe6mUnZZmpPMtFRN605J0cUFq2h
         nYjCWMa6mYILd52f//TrR9ybiOR5F4sxjyhrCmQFaWJOxcysGDeRTle/IikQdBbxz2OG
         KA1g==
X-Forwarded-Encrypted: i=1; AJvYcCXADxOO0hd7D3PL5oXQ7yWz2kbA8BQEFFg+QYD6BjMkMTLWJok1wAvez7pogKxjYOOIPZePPu6BsaZy/VS0mr3GA/FGcbzVZ/+h/b2B
X-Gm-Message-State: AOJu0YxBXGi3fUsA4pymZs/VDs/h+IrGcvTDBpHTUk+v6LPbvn3YKJRk
	EaF3yosHVN46XgViFYy5dcMEoZ4Dg9AbtkHDdog3dwkDs7XFO80yEuNgkw==
X-Google-Smtp-Source: AGHT+IHcRGxDvEPgGFfogi371R45iMoEIDY0q+k1pqC79kdLTi8dpgOgxL3ldaHyg6IUDVzZWHo0uQ==
X-Received: by 2002:a05:600c:4207:b0:426:5440:854f with SMTP id 5b1f17b1804b1-4265440881fmr51309915e9.25.1720369932568;
        Sun, 07 Jul 2024 09:32:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4264a1e8014sm134335215e9.21.2024.07.07.09.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jul 2024 09:32:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>
Subject: [PATCH 1/2] io_uring/io-wq: limit retrying worker initialisation
Date: Sun,  7 Jul 2024 17:32:10 +0100
Message-ID: <1af2a697b568f8cf77c5d527d183fa0ffe8fd9cc.1720368770.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1720368770.git.asml.silence@gmail.com>
References: <cover.1720368770.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If io-wq worker creation fails, we retry it by queueing up a task_work.
tasK_work is needed because it should be done from the user process
context. The problem is that retries are not limited, and if queueing a
task_work is the reason for the failure, we might get into an infinite
loop.

It doesn't seem to happen now but it will with the following patch
executing task_work in the freezing loop. For now, arbitrarily limit the
number of attempts to create a worker.

Cc: stable@vger.kernel.org
Fixes: 3146cba99aa28 ("io-wq: make worker creation resilient against signals")
Reported-by: Julian Orth <ju.orth@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io-wq.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 913c92249522..f1e7c670add8 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -23,6 +23,7 @@
 #include "io_uring.h"
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
+#define WORKER_INIT_LIMIT	3
 
 enum {
 	IO_WORKER_F_UP		= 0,	/* up and active */
@@ -58,6 +59,7 @@ struct io_worker {
 
 	unsigned long create_state;
 	struct callback_head create_work;
+	int init_retries;
 
 	union {
 		struct rcu_head rcu;
@@ -745,7 +747,7 @@ static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
 	return true;
 }
 
-static inline bool io_should_retry_thread(long err)
+static inline bool io_should_retry_thread(struct io_worker *worker, long err)
 {
 	/*
 	 * Prevent perpetual task_work retry, if the task (or its group) is
@@ -753,6 +755,8 @@ static inline bool io_should_retry_thread(long err)
 	 */
 	if (fatal_signal_pending(current))
 		return false;
+	if (worker->init_retries++ >= WORKER_INIT_LIMIT)
+		return false;
 
 	switch (err) {
 	case -EAGAIN:
@@ -779,7 +783,7 @@ static void create_worker_cont(struct callback_head *cb)
 		io_init_new_worker(wq, worker, tsk);
 		io_worker_release(worker);
 		return;
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 		atomic_dec(&acct->nr_running);
@@ -846,7 +850,7 @@ static bool create_io_worker(struct io_wq *wq, int index)
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wq, worker, tsk);
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		kfree(worker);
 		goto fail;
 	} else {
-- 
2.44.0


