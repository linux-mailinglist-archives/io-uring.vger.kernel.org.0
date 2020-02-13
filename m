Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CDA15C145
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2020 16:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgBMPUr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 10:20:47 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33089 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgBMPUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Feb 2020 10:20:46 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so6902301ioh.0
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2020 07:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nloK1kNuszkkk3Q3bpclBNBDkSPe3qso9Gh+hFyx+gc=;
        b=cbDpy9xA77/NUILaM6G7RGGPl60mtjkLIUbxL3WNj5n3ppxKoPm5VjYFoo71paGvgR
         ECb3uGlby2wqDtW8+EwBpfYGX+ClNQozCPOPnSyyhHKIV/deMYpJMTwbidUNgm26/eqv
         hLndpvfO8Bcsr/hmoM5Tj7aD2jXG9f3Jdm9ya8zQQ6l8jwqt2FW/utH/vI5TQgdKkevr
         fMwzxDoS7MxYqUz8MlEA1oQDGkZMQOsFGR3VFhZ+8/3At5Xhzu80R5AO+G6e0iYdCMun
         psrRTqnIrDl3DpcoJCQeGDAr3Iww/ukmAA22XAOtxGI7oLv7Z7ozGMt0kJs7L/1jfYNX
         xckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nloK1kNuszkkk3Q3bpclBNBDkSPe3qso9Gh+hFyx+gc=;
        b=S9GCbI4DiZE8jbqSktWwqvptHrPuC6znHyfRS9APnu7dEqZGxID9jdOeKY31/NXzxP
         vFFc1htyQrNSA7iiCZqAD60Y+4LaU6ArzTS7JjaBNJBtWA0io6WkJL/3oe/3Nk4+mmlx
         vtkQrckctzhNny9Lr+QtJhmMhrfQbSJbEe8aG6Xi7ptMYQypXxa8iyN4g6GwRK6MFuBk
         PbPVa6ffNhX98ICmugj9WmEmjgIKYHwd/YQc4U89YjipX2zzZxkO8NJMKbQhYKwQtEyR
         WM+pXoI8aeZ2enIEw6BMuDfKjfpzIIpzQ2dQoKDneYon4WKuJgWdhSxN67c8czGanJsW
         xnJg==
X-Gm-Message-State: APjAAAU6IwLqo2x4oNx8lQJD24pLnsdaP3/MxtrmwKpScAFUrgU34ekD
        wOXF+HKyHrQ0uBM5ta8JGgxVwg==
X-Google-Smtp-Source: APXvYqwwEvVQZGkSVQQZmfRswavIkIclX2E7uQtANrBjYu4zDDRazE9ExGpnaGarU3TnwKMrLDBDsA==
X-Received: by 2002:a6b:bd04:: with SMTP id n4mr742848iof.196.1581607244431;
        Thu, 13 Feb 2020 07:20:44 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a82sm946403ill.38.2020.02.13.07.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 07:20:44 -0800 (PST)
Subject: Re: Kernel BUG when registering the ring
To:     Jann Horn <jannh@google.com>
Cc:     Glauber Costa <glauber@scylladb.com>,
        io-uring <io-uring@vger.kernel.org>,
        Avi Kivity <avi@scylladb.com>
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
 <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk>
 <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
 <c192d9b8-fab9-1c29-7266-acd48b380338@kernel.dk>
 <CAD-J=zYUCFG=RTf=d98sBD=M4yg+i=qag2X9JxFa-KW0Un19Qw@mail.gmail.com>
 <059cfdbf-bcfe-5680-9b0a-45a720cf65c5@kernel.dk>
 <CAG48ez0ffvnfnPEemkKn1ZkGE-uAsAyBcAeJWdJ8j-eVeyaxfQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bb412ce9-7bb4-f279-e475-757e6829f47c@kernel.dk>
Date:   Thu, 13 Feb 2020 08:20:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez0ffvnfnPEemkKn1ZkGE-uAsAyBcAeJWdJ8j-eVeyaxfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/20 3:31 PM, Jann Horn wrote:
> On Tue, Feb 11, 2020 at 7:58 PM Jens Axboe <axboe@kernel.dk> wrote:
> [...]
>> @@ -849,6 +857,8 @@ void io_wq_cancel_all(struct io_wq *wq)
>>         for_each_node(node) {
>>                 struct io_wqe *wqe = wq->wqes[node];
>>
>> +               if (!node_online(node))
>> +                       continue;
>>                 io_wq_for_each_worker(wqe, io_wqe_worker_send_sig, NULL);
>>         }
>>         rcu_read_unlock();
> 
> What is this going to do if a NUMA node is marked as offline (through
> a call to node_set_offline() from try_offline_node()) while it has a
> worker running, and then afterwards, with the worker still running,
> io_wq_cancel_all() is executed? Is that going to potentially hang
> because some op is still executing on that node's worker? Or is there
> a reason why that can't happen?

I folded in this incremental last night, I think it's a better
approach as well.

> [...]
>> @@ -1084,6 +1100,8 @@ void io_wq_flush(struct io_wq *wq)
>>         for_each_node(node) {
>>                 struct io_wqe *wqe = wq->wqes[node];
>>
>> +               if (!node_online(node))
>> +                       continue;
>>                 init_completion(&data.done);
>>                 INIT_IO_WORK(&data.work, io_wq_flush_func);
>>                 data.work.flags |= IO_WQ_WORK_INTERNAL;
> 
> (io_wq_flush() is dead code since 05f3fb3c5397, right? Are there plans
> to use it again?)

Should probably just be removed for now, I generally don't like carrying
dead code. It's easy enough to bring back if we need it, though I suspect
if we do need it, we'll probably make it work like the workqueue
flushing where we guarantee existing work is done at that point.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2d741fb76098..0a5ab1a8f69a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -837,7 +837,9 @@ static bool io_wq_for_each_worker(struct io_wqe *wqe,
 
 	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
 		if (io_worker_get(worker)) {
-			ret = func(worker, data);
+			/* no task if node is/was offline */
+			if (worker->task)
+				ret = func(worker, data);
 			io_worker_release(worker);
 			if (ret)
 				break;
@@ -857,8 +859,6 @@ void io_wq_cancel_all(struct io_wq *wq)
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (!node_online(node))
-			continue;
 		io_wq_for_each_worker(wqe, io_wqe_worker_send_sig, NULL);
 	}
 	rcu_read_unlock();
@@ -939,8 +939,6 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (!node_online(node))
-			continue;
 		ret = io_wqe_cancel_cb_work(wqe, cancel, data);
 		if (ret != IO_WQ_CANCEL_NOTFOUND)
 			break;
@@ -1033,8 +1031,6 @@ enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (!node_online(node))
-			continue;
 		ret = io_wqe_cancel_work(wqe, &match);
 		if (ret != IO_WQ_CANCEL_NOTFOUND)
 			break;
@@ -1064,8 +1060,6 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (!node_online(node))
-			continue;
 		ret = io_wqe_cancel_work(wqe, &match);
 		if (ret != IO_WQ_CANCEL_NOTFOUND)
 			break;
@@ -1204,11 +1198,8 @@ static void __io_wq_destroy(struct io_wq *wq)
 		kthread_stop(wq->manager);
 
 	rcu_read_lock();
-	for_each_node(node) {
-		if (!node_online(node))
-			continue;
+	for_each_node(node)
 		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
-	}
 	rcu_read_unlock();
 
 	wait_for_completion(&wq->done);

-- 
Jens Axboe

