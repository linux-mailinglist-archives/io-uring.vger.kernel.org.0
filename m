Return-Path: <io-uring+bounces-8069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBCBEAC0837
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 11:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 671834A5A7E
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 09:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE38C22259B;
	Thu, 22 May 2025 09:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="IVHfCMIh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C0E6ADD
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 09:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904994; cv=none; b=umBQcxjj/Uagsn4H6or6FxWPBmBE9HuRVn7FPVd7ysTKkoP4DX7CXHMzGu0SVYzvddkU4jqhdjS0el897r+nwhLBwoMwfQCrdrJ3/TyLbDYEuedZX3xHh0i4lpYuqwo4zOeapEv/RCWufuRn4+hqV7Atvyr7dF55z8223UC71DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904994; c=relaxed/simple;
	bh=dF/uP5pXjd9EscO+fwWm/xXuOi5KLQwO+FHfkoqyx0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jPKY3GObBR7oYY6rXB8A4lWXZ1mzZnsYndxlWSIxJhr6cZimD0GQjJzAuRf5kUJ156qSOptBitWEpli5cTgyrBc/1gOvtZk2PFjXMzkS1Jk0Kg/waMcKXYj1UYNwxMdq7j2sVX+oaVeOFjdRqCty6jRbOhz5Y1yJS/K45hNhirg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=IVHfCMIh; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-742c9563fd9so4024971b3a.3
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 02:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747904992; x=1748509792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rge6dWDyVBNHCbx4kw8ORwnxxWIHuvA7tn3/T+91Oh8=;
        b=IVHfCMIhCT3K6Wq2lxiX2ESC1rvKFTjknYyL7kkpnBx2cgCqg+CJDng+/6ENrLWFl6
         eHVdUOytafZ7K+CNVtEvlnFZldbofZdow84vgJ9OBQ3lLqX+RNAOiPaDrLhqOqxT1VY8
         IPrvrju7E5haSU32xELMoPdfWe+jblygqLh+7xRV/AVXdUDw7AzAPncrWtwlvPp1kKOA
         TRggwCr6nVeD3+ye9zxao3zx+S+85KOsO6fJQBI7LkKGYcF1XgG4jf6qBoSL4X7y1ker
         B59K8lHzAOQ0zqa/D2ZwAGDQWkXN4AVbHT28Hpfvjjqp1czNo7SwKW6SfgO8wYmEtlTH
         RrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747904992; x=1748509792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rge6dWDyVBNHCbx4kw8ORwnxxWIHuvA7tn3/T+91Oh8=;
        b=edSJhbrNdjV/csqZLkOGuOxtBReXx5Bi46rDVITRDuPuJZgL/RXRZzuzsGDqWe78Ap
         1gDdb+3nN9+AdLMFhBmtHrE31+N1GJrQou9dC1iFB8PfDHyHnoRiqghu1GBAGuuL5sZZ
         5oKWo/+lO7KUdp2dW/E2EjR/LN3F6k34jQcSjRTyR3cCATL+ku8IcIENZ7RUALaZ9C6i
         owDuXBTJUi99Hdn7kXSWXref8joQ9m94U/vxhU2XnS9jSNkIum3bxuX774AVgF+KeaXE
         uWbJbEP9F+daO21cgz1x1EwK4YjoyHS8miZTxhulrEumTpUFuW2CvjZ38jOqRUjQ0tTS
         rJAw==
X-Gm-Message-State: AOJu0YxyVg/EBB8JAbrbNN4Jkka/Qf1FAiTfsdZ20k8U64dQzCeJORbm
	yeFkssZDI/o4i214pEJxq6NpLGYKY5wF9odnpdq3ROTXNpgQBdZgwj/ISh/VqUZ55MY=
X-Gm-Gg: ASbGncvnOrtdfyn7OsDus9D7QGHvAPtgaocU68GuY3CipwHyMso1VCOf/LfhB9GnNkw
	cNYFe+tT5eQFCfd9NRTvgaKgXTq/po8viLil8CCcLZkuO1mWmGuEwp4yvDl3VKc+uQJU9d+rZ5y
	Wo0HnFlcZEHaz/0p0SxEe1d/YRJTj2AvWP7HxqNUt5VsWOdzlkSOlUnsRoCTJybG2Aifx4Wq/yG
	yieekxNJAM+O6sEHHjJjOc589EypeV7gNo5zNIIrUQhZ/pWRKwNGnpGTOsmjPU2mCBx0oWyrbbc
	NDfbJWUFpnF8K0FXQ/t4xt6JR6NKbPZdAOCB0DALXnMxJgqyJjxBTLowLNow292K9U/djEgfUHP
	fcT2ilgm2bSQHOyl9w27Ea40=
X-Google-Smtp-Source: AGHT+IFQ2P4jP3e70FjCLyQd3WfNJblm2BCs5JgboVV5KOS9TD+XyB+lw1xSrnOFtPr9F7y60IGiLw==
X-Received: by 2002:a05:6a00:4b05:b0:736:3c2f:acdd with SMTP id d2e1a72fcca58-742acce2deemr32959113b3a.14.1747904991971;
        Thu, 22 May 2025 02:09:51 -0700 (PDT)
Received: from HTW5T2C6VL.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a98a3331sm11199788b3a.178.2025.05.22.02.09.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 May 2025 02:09:51 -0700 (PDT)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Fengnan Chang <changfengnan@bytedance.com>,
	Diangang Li <lidiangang@bytedance.com>
Subject: [RFC PATCH] io_uring: fix io worker thread that keeps creating and destroying
Date: Thu, 22 May 2025 17:09:09 +0800
Message-Id: <20250522090909.73212-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running fio with buffer io and stable iops, I observed that
part of io_worker threads keeps creating and destroying.
Using this command can reproduce:
fio --ioengine=io_uring --rw=randrw --bs=4k --direct=0 --size=100G
--iodepth=256 --filename=/data03/fio-rand-read --name=test
ps -L -p pid, you can see about 256 io_worker threads, and thread
id keeps changing.
And I do some debugging, most workers create happen in
create_worker_cb. In create_worker_cb, if all workers have gone to
sleep, and we have more work, we try to create new worker (let's
call it worker B) to handle it.  And when new work comes,
io_wq_enqueue will activate free worker (let's call it worker A) or
create new one. It may cause worker A and B compete for one work.
Since buffered write is hashed work, buffered write to a given file
is serialized, only one worker gets the work in the end, the other
worker goes to sleep. After repeating it many times, a lot of
io_worker threads created, handles a few works or even no work to
handle,and exit.
There are several solutions:
1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
create worker too, remove create worker action in create_worker_cb
is fine, maybe affect performance?
2. When wq->hash->map bit is set, insert hashed work item, new work
only put in wq->hash_tail, not link to work_list,
io_worker_handle_work need to check hash_tail after a whole dependent
link, io_acct_run_queue will return false when new work insert, no
new thread will be created either in io_wqe_dec_running.
3. Check is there only one hash bucket in io_wqe_dec_running. If only
one hash bucket, don't create worker, io_wq_enqueue will handle it.

I choose plan 3 to avoid this problem. After my test, there is no
performance degradation.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Signed-off-by: Diangang Li <lidiangang@bytedance.com>
---
 io_uring/io-wq.c | 73 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 19 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 04a75d666195..37723a785204 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -412,25 +412,6 @@ static bool io_queue_worker_create(struct io_worker *worker,
 	return false;
 }
 
-static void io_wq_dec_running(struct io_worker *worker)
-{
-	struct io_wq_acct *acct = io_wq_get_acct(worker);
-	struct io_wq *wq = worker->wq;
-
-	if (!test_bit(IO_WORKER_F_UP, &worker->flags))
-		return;
-
-	if (!atomic_dec_and_test(&acct->nr_running))
-		return;
-	if (!io_acct_run_queue(acct))
-		return;
-
-	raw_spin_unlock(&acct->lock);
-	atomic_inc(&acct->nr_running);
-	atomic_inc(&wq->worker_refs);
-	io_queue_worker_create(worker, acct, create_worker_cb);
-}
-
 /*
  * Worker will start processing some work. Move it to the busy list, if
  * it's currently on the freelist
@@ -484,6 +465,60 @@ static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
 	return ret;
 }
 
+static  bool only_one_hashed_work(struct io_wq_acct *acct,
+				struct io_wq *wq)
+	__must_hold(acct->lock)
+{
+	struct io_wq_work_node *node, *prev;
+	struct io_wq_work *work, *tail;
+	unsigned int len = 0;
+
+	wq_list_for_each(node, prev, &acct->work_list) {
+		unsigned int work_flags;
+		unsigned int hash;
+
+		work = container_of(node, struct io_wq_work, list);
+		len += 1;
+		if (len > 1)
+			return false;
+		/* not hashed, can run anytime */
+		work_flags = atomic_read(&work->flags);
+		if (!__io_wq_is_hashed(work_flags))
+			return false;
+
+		hash = __io_get_work_hash(work_flags);
+		/* all items with this hash lie in [work, tail] */
+		tail = wq->hash_tail[hash];
+		/* fast forward to a next hash, for-each will fix up @prev */
+		node = &tail->list;
+	}
+
+	return true;
+}
+
+static void io_wq_dec_running(struct io_worker *worker)
+{
+	struct io_wq_acct *acct = io_wq_get_acct(worker);
+	struct io_wq *wq = worker->wq;
+
+	if (!test_bit(IO_WORKER_F_UP, &worker->flags))
+		return;
+
+	if (!atomic_dec_and_test(&acct->nr_running))
+		return;
+	if (!io_acct_run_queue(acct))
+		return;
+	if (only_one_hashed_work(acct, wq)) {
+		raw_spin_unlock(&acct->lock);
+		return;
+	}
+
+	raw_spin_unlock(&acct->lock);
+	atomic_inc(&acct->nr_running);
+	atomic_inc(&wq->worker_refs);
+	io_queue_worker_create(worker, acct, create_worker_cb);
+}
+
 static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 					   struct io_wq *wq)
 	__must_hold(acct->lock)
-- 
2.20.1


