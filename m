Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB533FAEE5
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 00:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhH2WUT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Aug 2021 18:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbhH2WUT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Aug 2021 18:20:19 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BA7C061575
        for <io-uring@vger.kernel.org>; Sun, 29 Aug 2021 15:19:26 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a15so17071473iot.2
        for <io-uring@vger.kernel.org>; Sun, 29 Aug 2021 15:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BMOG4u6rE6ZM7pNRub8MnSTpaUZ7RiVHIL1hyjs+Ngc=;
        b=z214Xg9/3peMkWT3QTi9iM+wEzVUz7FzebUVIJ+bGTsKOse5sxbfEMrzOpmMb9uv3j
         3H2jb7VKuJbinrfXAYeIgAJdOb4CQAZOm9dnYEphdNe5PnrWOYUJDmmtM5fEW11QYS5z
         KMq2u4tx+azp6/vcxKu+VsrqzWpnDWIHpC6SvSrYOjVLa47q7PHXdSv+bjJIzxkeFdRX
         X0Rj/9S+ZL95T6ESQ1YxAYPobUx8z74bWitirk6WzrFElO6G70CpCh0YDiLSCcsNVB80
         HMpRC4XjNTlOGPEnWEOyFxY/pSI6jTBS2OLvA5IUnokmWzp36/khkh3D/zFJvEJmoYKo
         L5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BMOG4u6rE6ZM7pNRub8MnSTpaUZ7RiVHIL1hyjs+Ngc=;
        b=r0lpfVA1K3LkI52E0XVeOhaNcuSnK5IUqi5M3t5AYr3PljuE+TFYZHF4jnLpN6PNYu
         +h3cSuW6jVk27Fk6YX+BB2AmrfxmYEuhBxxwmsr6GRIGii6b4ynvVe96+TlsHsf2Lj99
         EXTUwqM1aKPDPPwXcjgXLfETLz2akjo57UJXZlqO9U8xunlUwSSKJAoMh5YM4cumGp4F
         LwDdPFUE+PBVtlkiUaiUaq2bvgZdR38EAoRJtXvJj4c1nlHCz1a6aK7HduZNfdUMl4pz
         9mNVH2O4ue9DQCtjhmIEawgZ7NSH48fXC1B8Y75LKtzCU+3X1BC0oW/4cvKXDwagLFQT
         3v0g==
X-Gm-Message-State: AOAM5310QxbNhidCcuSIO5abb7tZsnoCSP8yTBCf+rwXLGyH3DVdcaSn
        85qDkOj2aC9FuvD/7tMnAccwX7irW8OClw==
X-Google-Smtp-Source: ABdhPJz1M0wKgswYvyYwHpIanNMFaIgYFFIYAtmFBXu+evWV50uXC0a9j2/oQ1nPNqWpuKNl7MoTxA==
X-Received: by 2002:a05:6638:d43:: with SMTP id d3mr17370110jak.138.1630275565718;
        Sun, 29 Aug 2021 15:19:25 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h1sm6859629iow.12.2021.08.29.15.19.25
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 15:19:25 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: check max_worker limits if a worker transitions bound
 state
Message-ID: <8b32196b-0555-8179-1fa0-496b4e68ae4c@kernel.dk>
Date:   Sun, 29 Aug 2021 16:19:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For the two places where new workers are created, we diligently check if
we are allowed to create a new worker. If we're currently at the limit
of how many workers of a given type we can have, then we don't create
any new ones.

If you have a mixed workload with various types of bound and unbounded
work, then it can happen that a worker finishes one type of work and
is then transitioned to the other type. For this case, we don't check
if we are actually allowed to do so. This can cause io-wq to temporarily
exceed the allowed number of workers for a given type.

When retrieving work, check that the types match. If they don't, check
if we are allowed to transition to the other type. If not, then don't
handle the new work.

Cc: stable@vger.kernel.org
Reported-by: Johannes Lundberg <johalun0@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4b5fc621ab39..dced22288983 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -424,7 +424,31 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	spin_unlock(&wq->hash->wait.lock);
 }
 
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
+/*
+ * We can always run the work if the worker is currently the same type as
+ * the work (eg both are bound, or both are unbound). If they are not the
+ * same, only allow it if incrementing the worker count would be allowed.
+ */
+static bool io_worker_can_run_work(struct io_worker *worker,
+				   struct io_wq_work *work)
+{
+	struct io_wqe_acct *acct;
+
+	if ((worker->flags & IO_WORKER_F_BOUND) &&
+	    !(work->flags & IO_WQ_WORK_UNBOUND))
+		return true;
+	else if (!(worker->flags & IO_WORKER_F_BOUND) &&
+		 (work->flags & IO_WQ_WORK_UNBOUND))
+		return true;
+
+	/* not the same type, check if we'd go over the limit */
+	acct = io_work_get_acct(worker->wqe, work);
+	return acct->nr_workers < acct->max_workers;
+}
+
+static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
+					   struct io_worker *worker,
+					   bool *stalled)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -436,6 +460,9 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 
 		work = container_of(node, struct io_wq_work, list);
 
+		if (!io_worker_can_run_work(worker, work))
+			break;
+
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&wqe->work_list, node, prev);
@@ -462,6 +489,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 		raw_spin_unlock(&wqe->lock);
 		io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
+		*stalled = true;
 	}
 
 	return NULL;
@@ -501,6 +529,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 	do {
 		struct io_wq_work *work;
+		bool stalled;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -509,10 +538,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe);
+		stalled = false;
+		work = io_get_next_work(wqe, worker, &stalled);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
-		else if (!wq_list_empty(&wqe->work_list))
+		else if (stalled)
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		raw_spin_unlock_irq(&wqe->lock);

-- 
Jens Axboe

