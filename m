Return-Path: <io-uring+bounces-2473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F7592BCDE
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 16:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D9B3B2306F
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 14:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2DE1940B2;
	Tue,  9 Jul 2024 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cldCYRWS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069D515279B;
	Tue,  9 Jul 2024 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720535239; cv=none; b=T+LP2QPCCMj/Ga7wEBYF+xepYhowro8HHe6Bwuo/XpzoFlGvwcUw8qcMD76xt7ur5F7t6wXAxE9PxYEdVUNhuIcA0cjrYZgC81/JCM4FjSuTdyVHYUvZ6cwdXrZljOfS3YwZJ6XQg4oQul930E3TqfI5X6f5G0wTNV2ACYtC4Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720535239; c=relaxed/simple;
	bh=P+TJsos0wRuICzWhaMFgjmN4/yDzbtZJ6N0VJY3WNCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvdtDkYW2/EGoPB8p/IRrXEVzob/XD8h5P92cgHrfTxVyxXWbUkFRY8hhZZFJuuZ3qIdQSXcCTTxR9bLROkHbNJGocyN6Cf2f2oaWcajSlNuwuxUw17pQTKXOVniJzt2+wR9IOa3xi+srA3f8k0nJ8z9X0yGqqsQLPcw9CpR5jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cldCYRWS; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a77baa87743so564723266b.3;
        Tue, 09 Jul 2024 07:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720535236; x=1721140036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttgYBK7CIbyCBuvHefwURr58xYqG6L2p5WKp4rRTzQk=;
        b=cldCYRWSoM/cbqcQ1kJaku6kEA6nXuQAeQVKRoI30PxzX6st9//03XoKAfcEx5bJqB
         UeWzsquVh2pmNeS0D43fJlIbYHuwm6h7iVzm1ZgMkP5n+eTSCcA0HDeUJFlkqhOgAgOx
         XEcqjYwZ+VJaWnVs9QDtbroVBoPf8jCaX4nuCiOH9Us5bESP2yvN/qVtP2jy8whWK6tP
         wuQLdlx6mYVW6NIkfenQw2exFK5tmB+aHvmcxig5nQpRQqrhn1MX3Xyk/okG4iNiHOaa
         IX3Wlee/Il0zSuTPkEi62+e7/gBy72k6AtiLZOyhgJBL6Xp/QiLsVK734Rgz2PWCkiQ0
         dT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720535236; x=1721140036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttgYBK7CIbyCBuvHefwURr58xYqG6L2p5WKp4rRTzQk=;
        b=XtLUCqM2pOZBvQDHn+5dvPomkFBI1N69bRagLn/70rGrZ0cVts5BFMD+JWbq6Gzvgf
         nZy7ZKuqGj/4A3OzswwvizfKdD5AMIyGkHY/NrUUEgDbblAk96ax/K6r6OkgeoQYRuk4
         c3HkyhcSRdDadjf/2CcGazD7yXh6FzLcUbceO6Lt4h2ur0uK9p8YFNuJAdYoBtU1JFql
         ulNIwPze5OGpu/23x5yy3+oq7CTtm13VRvMJoGnlTy2aI75ljD3rIMTIoQl6p11wa1X+
         C774af78p4Sj9LS+12qI1yCbxzUiQanqc152pyFyqCLP+JbkBWXXAG/0qGIBNenasI6f
         dKCg==
X-Forwarded-Encrypted: i=1; AJvYcCUPKzoaVM4DmfXxWrSINWctvBfdOq4A/Cyng47rZeN3agI6OIl+he81eYyZIXcjwXKQbUyeBBrWF7nGmuwZUPqPVjqJx7CfVdayMhqi
X-Gm-Message-State: AOJu0Yy8DfZS/haf3Yj/gW5VGL2+dL6g4qQzR50+ylbw1lqZnE520KN1
	e45b1Oxund0v1QXj6DH1ScbWncmNGPH8gLTxCec5EQN3rGrmzNCm35Nfhw==
X-Google-Smtp-Source: AGHT+IFnaWqj+voLe/snIcMHRpZCxkD5hkOP3UTwoJHVMVHj1VnGQCWk96AVVhz1D3MWRARgpRaikQ==
X-Received: by 2002:a17:906:f592:b0:a77:cf9d:f495 with SMTP id a640c23a62f3a-a780b7010a0mr304952766b.40.1720535235827;
        Tue, 09 Jul 2024 07:27:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a7ff21esm80649966b.135.2024.07.09.07.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 07:27:15 -0700 (PDT)
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
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 1/2] io_uring/io-wq: limit retrying worker initialisation
Date: Tue,  9 Jul 2024 15:27:18 +0100
Message-ID: <1af2a697b568f8cf77c5d527d183fa0ffe8fd9cc.1720534425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1720534425.git.asml.silence@gmail.com>
References: <cover.1720534425.git.asml.silence@gmail.com>
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


