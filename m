Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0276B09D2
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 14:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjCHNuw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 08:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjCHNuf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 08:50:35 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0DCBC7A4
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 05:50:29 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so2364612pjb.3
        for <io-uring@vger.kernel.org>; Wed, 08 Mar 2023 05:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678283429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rGMh7z+uu7UWSjKT1r63vloQOO9D03iCCkuaAImHSZE=;
        b=ood+JQd114oTw8IWazm67avBWKR6V6c14YJMJkcOAkP0PpHWd5KpMG/b3eRMLVojwB
         exzew6I3c8kM2IPAJCvhyRw2Uh0yzJjYcDx3Kxr4dHJ8BqKs5HuajQ3UpehfQFhgJfPV
         DU8lF1t7FRLcbXW6ki9gxFeq82aXmMsu/Y3nQb+2rP29C8BBWcz6ykcyZQtFNcYtNu7q
         iTBaRSbbqZTmTmkWWOyMrvTs7mcjWZdoqKf4ARQSL/twL5TvCt3aidsvBkGws6Udg0DF
         Tl0+chI7Vlg+t2hDS09pG8RjQDLINIu/+5px4+O18e9lDbgmyPrJXpB9jf+Fyoa9j104
         qCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678283429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGMh7z+uu7UWSjKT1r63vloQOO9D03iCCkuaAImHSZE=;
        b=CGs9jYkg3yCfpql9j+VEr6urCJCFo2RtwTAG6E/Bb5TYRE7QYIFkc4yvToW7BGr7dX
         CExoq6+tDO/Inf/TmCK7uLIarsdxla6YnQ11vk9Gb7HWSaUxECeuLCrK4a7Rdra6ee8V
         3/e3kjXjB2ozy3XWsjVziEPSBeC1G7OdvVQsTdNOYn/ZwMqHOqaHwrDZufoTL6pMY/GI
         mxI9WZ3r44pn7C4ZvB7aiuoGxEfTdmxBwKOzBpAnnDTiJua9oQM0+8j5m3rct1WhW3kQ
         I2a53ucDcRagRm3HePLKtLkIq4rHEWWSYHFnFd+N/MK5SF7jCnrIds1I48T/VtCiQPTa
         0efw==
X-Gm-Message-State: AO0yUKXoEeFXR0vbBaurlq3i3rba2DAzHfUMdhCIrj/aFjcYrekK2MVG
        +RsJrCf/WE+UV5fdiVyVI8Q04Q==
X-Google-Smtp-Source: AK7set9lQdgrJTaakA725ds5C+l02NAwzsaM59NNzmf5l27GGHx96WtdbzEDofbkDL71cZsi62pYkw==
X-Received: by 2002:a17:90a:9401:b0:237:47b0:30d3 with SMTP id r1-20020a17090a940100b0023747b030d3mr12504317pjo.4.1678283428797;
        Wed, 08 Mar 2023 05:50:28 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090a154600b002372107fc3dsm10436823pja.49.2023.03.08.05.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 05:50:28 -0800 (PST)
Message-ID: <cd4eee4d-fb29-e8b7-1212-e8840af6b44f@kernel.dk>
Date:   Wed, 8 Mar 2023 06:50:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Unexpected EINVAL when enabling cpuset in subtree_control when
 io_uring threads are running
Content-Language: en-US
To:     Daniel Dao <dqminh@cloudflare.com>
Cc:     io-uring@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/23 4:42?AM, Daniel Dao wrote:
> Hi all,
> 
> We encountered EINVAL when enabling cpuset in cgroupv2 when io_uring
> worker threads are running. Here are the steps to reproduce the failure
> on kernel 6.1.14:
> 
> 1. Remove cpuset from subtree_control
> 
>   > for d in $(find /sys/fs/cgroup/ -maxdepth 1 -type d); do echo
> '-cpuset' | sudo tee -a $d/cgroup.subtree_control; done
>   > cat /sys/fs/cgroup/cgroup.subtree_control
>   cpu io memory pids
> 
> 2. Run any applications that utilize the uring worker thread pool. I used
>    https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-io_uring-worker-pool
> 
>   > cargo run -- -a -w 2 -t 2
> 
> 3. Enabling cpuset will return EINVAL
> 
>   > echo '+cpuset' | sudo tee -a /sys/fs/cgroup/cgroup.subtree_control
>   +cpuset
>   tee: /sys/fs/cgroup/cgroup.subtree_control: Invalid argument
> 
> We traced this down to task_can_attach that will return EINVAL when it
> encounters
> kthreads with PF_NO_SETAFFINITY, which io_uring worker threads have.
> 
> This seems like an unexpected interaction when enabling cpuset for the subtrees
> that contain kthreads. We are currently considering a workaround to try to
> enable cpuset in root subtree_control before any io_uring applications
> can start,
> hence failure to enable cpuset is localized to only cgroup with
> io_uring kthreads.
> But this is cumbersome.
> 
> Any suggestions would be very much appreciated.

One important thing to note here is that io_uring workers are not
kthreads, but like kthreads, they set PF_NO_SETAFFINITY which prevents
userspace from moving them around. We do have an explicit API for
setting the affinity of workers associated with an io_uring context,
however.

But you are not the first to come across this, and I'm pondering how we
can improve this situation. io-wq blocks changing the CPU affinity
because it organizes workers within a node, but this is purely an
optimization and not integral to how it works.

One thing we could do is simply check the cpumask of the worker after it
went to sleep, and if it woke up due to a timeout (eg not to handle real
work). That'd lazily drop workers that are now not affinitized
correctly. With that, I think it'd be sane to drop the PF_NO_SETAFFINITY
mask from the worker. Something like the below, would be great if you
could test.


diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 411bb2d1acd4..669f50cb4e90 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -616,7 +616,7 @@ static int io_wqe_worker(void *data)
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	bool last_timeout = false;
+	bool exit_mask = false, last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
@@ -632,8 +632,11 @@ static int io_wqe_worker(void *data)
 			io_worker_handle_work(worker);
 
 		raw_spin_lock(&wqe->lock);
-		/* timed out, exit unless we're the last worker */
-		if (last_timeout && acct->nr_workers > 1) {
+		/*
+		 * Last sleep timed out. Exit if we're not the last worker,
+		 * or if someone modified our affinity.
+		 */
+		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
 			raw_spin_unlock(&wqe->lock);
 			__set_current_state(TASK_RUNNING);
@@ -652,7 +655,11 @@ static int io_wqe_worker(void *data)
 				continue;
 			break;
 		}
-		last_timeout = !ret;
+		if (!ret) {
+			last_timeout = true;
+			exit_mask = !cpumask_test_cpu(smp_processor_id(),
+							wqe->cpu_mask);
+		}
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
@@ -704,7 +711,6 @@ static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 	tsk->worker_private = worker;
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
-	tsk->flags |= PF_NO_SETAFFINITY;
 
 	raw_spin_lock(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);

-- 
Jens Axboe

