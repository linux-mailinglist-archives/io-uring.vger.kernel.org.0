Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AA84703F3
	for <lists+io-uring@lfdr.de>; Fri, 10 Dec 2021 16:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242897AbhLJPjA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Dec 2021 10:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242870AbhLJPi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Dec 2021 10:38:59 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA4FC061746
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 07:35:24 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x131so8735291pfc.12
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 07:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8wubDJh14uFsSMK9l72brjqbN40Kii4FAf0ApOvMg/s=;
        b=49szppwzpf8p4ufWM9362UYPd7KmwBF1nB1iAdavdbOkhDQFH5zy1qeq71MZ2ZRp/5
         UObHDO6G3m7OPz32FdnWdu7lw3rOnt8R3h2x/pZBuJzun0Io/Rtqp6VvRisG7qmaiDiB
         zf98G0zCnuiVFgXVsQ8lBl33ZmRlkwbuPBABmR1VslVGFHLAW0fFyzNeWOS9WtHaC4ZO
         zAXYlYqEm3VPqeOEi6T83KK38JlfDUTOmUdPz9SItsw7bEuo9rU4jUN+C6g8j1Jv43fP
         fDLh38H6w0fDWiqZljRn3QONpU5BReCzb6ZWWr7/f/MN2STG/uwPCCITWXmYc7gevP+g
         2VKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8wubDJh14uFsSMK9l72brjqbN40Kii4FAf0ApOvMg/s=;
        b=NR4FY1Sssa2jki04BrYxlNfDhGfNVx225t0skjDNs0MYcvwAQkvKBHtBBgyo48/2io
         1v2jAUFcKj18SKzxkTbh143RJU2IKkHnBy9HMUk78ZTjFAC+BMmE91pUBkmdASbIBRUo
         cUSlyhyuM389R/CYai7h2KoxTQfdi5CDx/+LiTPcFGMUHHAmAZohduLq9QjpS+iXgK4K
         NYKeeiGi/V99WpGUCAjuJUcfeu9RSG5FliQf/LaoPJNyQHitMyCA2LPkRTWZJWOo2WWy
         v5f6DJ05YgzbISn146FsB3kWbixwxRhdD5SOUbkRUI/QWtHmKW7FQWHhBIDqvS78rebs
         cKmQ==
X-Gm-Message-State: AOAM5338smJRYlI4ps2gm3qXZpiubiI0Hpd6FhQVfKuoyHAXZO3Ska3/
        QsGjQ1S35FpsDHyaTKecfKgcsQIhGB9qJQ==
X-Google-Smtp-Source: ABdhPJyXSA1r9PPvpuNU+VijbENJ9Sta2+GVjZXtfhUXYkN1//4pEJKLwjFJLiMsEr/7VRQPfmpk8w==
X-Received: by 2002:aa7:928b:0:b0:4a6:3de7:a813 with SMTP id j11-20020aa7928b000000b004a63de7a813mr18496865pfa.67.1639150523899;
        Fri, 10 Dec 2021 07:35:23 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id g18sm3699918pfb.103.2021.12.10.07.35.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 07:35:23 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: check for wq exit after adding new worker task_work
Message-ID: <6ec527b1-3d50-d484-912d-eff86849241d@kernel.dk>
Date:   Fri, 10 Dec 2021 08:35:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We check IO_WQ_BIT_EXIT before attempting to create a new worker, and
wq exit cancels pending work if we have any. But it's possible to have
a race between the two, where creation checks exit finding it not set,
but we're in the process of exiting. The exit side will cancel pending
creation task_work, but there's a gap where we add task_work after we've
canceled existing creations at exit time.

Fix this by checking the EXIT bit post adding the creation task_work.
If it's set, run the same cancelation that exit does.

Reported-by: syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 35da9d90df76..8d2bb818a3bb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -142,6 +142,7 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
 					struct io_cb_cancel_data *match);
 static void create_worker_cb(struct callback_head *cb);
+static void io_wq_cancel_tw_create(struct io_wq *wq);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -357,10 +358,22 @@ static bool io_queue_worker_create(struct io_worker *worker,
 	    test_and_set_bit_lock(0, &worker->create_state))
 		goto fail_release;
 
+	atomic_inc(&wq->worker_refs);
 	init_task_work(&worker->create_work, func);
 	worker->create_index = acct->index;
-	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
+	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
+		/*
+		 * EXIT may have been set after checking it above, check after
+		 * adding the task_work and remove any creation item if it is
+		 * now set. wq exit does that too, but we can have added this
+		 * work item after we canceled in io_wq_exit_workers().
+		 */
+		if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
+			io_wq_cancel_tw_create(wq);
+		io_worker_ref_put(wq);
 		return true;
+	}
+	io_worker_ref_put(wq);
 	clear_bit_unlock(0, &worker->create_state);
 fail_release:
 	io_worker_release(worker);
@@ -1196,13 +1209,9 @@ void io_wq_exit_start(struct io_wq *wq)
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
 }
 
-static void io_wq_exit_workers(struct io_wq *wq)
+static void io_wq_cancel_tw_create(struct io_wq *wq)
 {
 	struct callback_head *cb;
-	int node;
-
-	if (!wq->task)
-		return;
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
 		struct io_worker *worker;
@@ -1210,6 +1219,16 @@ static void io_wq_exit_workers(struct io_wq *wq)
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
 	}
+}
+
+static void io_wq_exit_workers(struct io_wq *wq)
+{
+	int node;
+
+	if (!wq->task)
+		return;
+
+	io_wq_cancel_tw_create(wq);
 
 	rcu_read_lock();
 	for_each_node(node) {

-- 
Jens Axboe

