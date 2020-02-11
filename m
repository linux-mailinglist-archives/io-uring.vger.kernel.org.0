Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D88159939
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 19:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgBKS6r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 13:58:47 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:38723 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729777AbgBKS6q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 13:58:46 -0500
Received: by mail-il1-f196.google.com with SMTP id f5so4391015ilq.5
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 10:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B1uzJNm/aA9BhJwr/0ANfXClWCnPPvQDspUqYSYoRYg=;
        b=xxhIMISJjONVU82Y+suEqj/drqY0BxTzx3C4ebawEn9017YQIjF+XbL7cBstfugr/F
         XHnGUFepu4n0HHMmumQB97Qti73YXqW0mAvy5NjNh2vnN6uCPMJzqSdS1Lg5aTzY7HR/
         wOm19Idfy684aTPfDGvcZYiAVvU4g3PemjdJk+TTN35BAxWpsIAh32u0112o5ZLRZc3z
         Vme/lcAbYoilMXPHteutuCKrrkU+1XtGTQFGdCKO0EXwjD3oOd1n9u/LeFq3tSthEcNz
         6mr64fXbE4dm0Y00ViHrvAPBojIHf/+N0yi1IOq8tUb8zTCU5v5A032+Td6AvbkqPpl+
         8Fyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B1uzJNm/aA9BhJwr/0ANfXClWCnPPvQDspUqYSYoRYg=;
        b=Y3MX77HkIkdVJlaOPwuFUJz0J0mV2+SFeCPQ4qKsxLtZsEaxc3e0uq9siAri186ARP
         iiA0R0N7XFY9qgcZEYV+aSkiphElxdORTMeam9CvhkWnHknfkQHUkZ8D3BGKxngrXTeq
         E/hIxCj9E9sWjQXNe7b5n+bdHtcxG7entwM2yMIz4vtPBH6Bt/HR5JWR/EevdleRNAlV
         VHS/Iy1ShwtdYbAc3g1rdEll7YaR4FvpAxEzAUs9xW3WCzlMy/r0z0Bsq0ukyjcnx3xh
         IkdIOfYRnivy5YdtwyqLkAP0JjDPyTP0/Z0KlamqTMkKJa4EmjmhP3I5UtZXDvLBFQRY
         Iddw==
X-Gm-Message-State: APjAAAUFVQLWQih5o+ItiaGuAUVGPsv4cDqzXIDOjcmhZjq9RT6TNuaV
        Iw4hUUq0ml7HiEX41bk9NpomvA==
X-Google-Smtp-Source: APXvYqyO4U8foXeVKvKw1sAj6rMqRFFg9XnWNDgo81nInkTfg8RhsYxni/88W1hgIofNcNVBePKgEA==
X-Received: by 2002:a05:6e02:5c1:: with SMTP id l1mr7313984ils.281.1581447524941;
        Tue, 11 Feb 2020 10:58:44 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l3sm1549348ilq.56.2020.02.11.10.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 10:58:44 -0800 (PST)
Subject: Re: Kernel BUG when registering the ring
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
 <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk>
 <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
 <c192d9b8-fab9-1c29-7266-acd48b380338@kernel.dk>
 <CAD-J=zYUCFG=RTf=d98sBD=M4yg+i=qag2X9JxFa-KW0Un19Qw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <059cfdbf-bcfe-5680-9b0a-45a720cf65c5@kernel.dk>
Date:   Tue, 11 Feb 2020 11:58:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zYUCFG=RTf=d98sBD=M4yg+i=qag2X9JxFa-KW0Un19Qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/20 6:01 AM, Glauber Costa wrote:
> This works.

Can you try this one as well?


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 182aa17dc2ca..2d741fb76098 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -699,11 +699,16 @@ static int io_wq_manager(void *data)
 	/* create fixed workers */
 	refcount_set(&wq->refs, workers_to_create);
 	for_each_node(node) {
+		if (!node_online(node))
+			continue;
 		if (!create_io_worker(wq, wq->wqes[node], IO_WQ_ACCT_BOUND))
 			goto err;
 		workers_to_create--;
 	}
 
+	while (workers_to_create--)
+		refcount_dec(&wq->refs);
+
 	complete(&wq->done);
 
 	while (!kthread_should_stop()) {
@@ -711,6 +716,9 @@ static int io_wq_manager(void *data)
 			struct io_wqe *wqe = wq->wqes[node];
 			bool fork_worker[2] = { false, false };
 
+			if (!node_online(node))
+				continue;
+
 			spin_lock_irq(&wqe->lock);
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_BOUND))
 				fork_worker[IO_WQ_ACCT_BOUND] = true;
@@ -849,6 +857,8 @@ void io_wq_cancel_all(struct io_wq *wq)
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		if (!node_online(node))
+			continue;
 		io_wq_for_each_worker(wqe, io_wqe_worker_send_sig, NULL);
 	}
 	rcu_read_unlock();
@@ -929,6 +939,8 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		if (!node_online(node))
+			continue;
 		ret = io_wqe_cancel_cb_work(wqe, cancel, data);
 		if (ret != IO_WQ_CANCEL_NOTFOUND)
 			break;
@@ -1021,6 +1033,8 @@ enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		if (!node_online(node))
+			continue;
 		ret = io_wqe_cancel_work(wqe, &match);
 		if (ret != IO_WQ_CANCEL_NOTFOUND)
 			break;
@@ -1050,6 +1064,8 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		if (!node_online(node))
+			continue;
 		ret = io_wqe_cancel_work(wqe, &match);
 		if (ret != IO_WQ_CANCEL_NOTFOUND)
 			break;
@@ -1084,6 +1100,8 @@ void io_wq_flush(struct io_wq *wq)
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		if (!node_online(node))
+			continue;
 		init_completion(&data.done);
 		INIT_IO_WORK(&data.work, io_wq_flush_func);
 		data.work.flags |= IO_WQ_WORK_INTERNAL;
@@ -1115,12 +1133,15 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	for_each_node(node) {
 		struct io_wqe *wqe;
+		int alloc_node = node;
 
-		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, node);
+		if (!node_online(alloc_node))
+			alloc_node = NUMA_NO_NODE;
+		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
 		if (!wqe)
 			goto err;
 		wq->wqes[node] = wqe;
-		wqe->node = node;
+		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
 		if (wq->user) {
@@ -1128,7 +1149,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 					task_rlimit(current, RLIMIT_NPROC);
 		}
 		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
-		wqe->node = node;
 		wqe->wq = wq;
 		spin_lock_init(&wqe->lock);
 		INIT_WQ_LIST(&wqe->work_list);
@@ -1184,8 +1204,11 @@ static void __io_wq_destroy(struct io_wq *wq)
 		kthread_stop(wq->manager);
 
 	rcu_read_lock();
-	for_each_node(node)
+	for_each_node(node) {
+		if (!node_online(node))
+			continue;
 		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
+	}
 	rcu_read_unlock();
 
 	wait_for_completion(&wq->done);

-- 
Jens Axboe

