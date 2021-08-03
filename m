Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A413DF071
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 16:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhHCOiI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 10:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhHCOiG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 10:38:06 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A92C061757
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 07:37:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id a20so24051357plm.0
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 07:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bauVcaFMS6kcZeuPgiriANV5sZ3dYN5fJfoW/8wu3Vg=;
        b=MGS4lSbzkWwlWD6fsf4fSUoQNfmizgbibobeySsc4FrwhUTxnpcWswOhvLnfJ3UARL
         5ArCePX4XAtR0GNfYAqM83kOeUitCRqyL0iSm0pvcAAhpKCMest/zHvT3Q2uoR5DjfS2
         bdmGpO0FpTjspBEMR+QZ3VXmx0P6JjC/nl0KY44+94jv4dF2G9Q2KAf2Ymi5WQmtMELQ
         FBWdHtYGhXA6XwtQVkxWu7BGe+gxO4a1e3n/Buz1m4lZ/9mQPu9kn4a4n6DYe9sqN41g
         Q2u1Hew9Z8qHFL2NBfP1+z6Q/wzmV0Xb1GJxv7eiRAcE0L9mF0JhSOD1lVifMUWpRGNp
         W5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bauVcaFMS6kcZeuPgiriANV5sZ3dYN5fJfoW/8wu3Vg=;
        b=iR0sppr3ogtkxlh3DUGmd7N40IueknLF1kaKRZ2/lEgzR1DA/1A/7a+HyDJyMVGOby
         zt0x37yjqHpaa/xicgxFIOPMi2R7zfMlZlYuVGZ7UA+zMqKhesKNNszqRBE9DblTKlpm
         g56fQ0cRxYvIiaIrE8cYdokhLaUoseTDqxcDPuyZORXiM31WC+jydIUVSrpNynncfJha
         t2nN29dpoSiguPhrvjbj++JgoXUgJKEAZW1NczV3V9SCnnXvm4KvWOZfWrFjzoA1htF/
         Xu6hkBdUsoKoxFfqfY6GZcwqn5RvpRGLB6REDEuQ74sIFmK/+OJv83tz4YD05oFdbE0i
         ncvw==
X-Gm-Message-State: AOAM532tQSPmSDRdtdrK/qsLu6YUc19zF5WOe26ayvB3vPENr02rg7S1
        TSPnKACyjO+Z3KSJElG94sBem8h+Wyi4VPDR
X-Google-Smtp-Source: ABdhPJw+RtRP+OgARrUmgAlK25Xn6W3Iph1vO2qLyzJsMbOynwlwcDittdPpDMzKUxn4VC90gwxOWw==
X-Received: by 2002:aa7:9af7:0:b029:3be:afdf:e75c with SMTP id y23-20020aa79af70000b02903beafdfe75cmr9571439pfp.77.1628001474454;
        Tue, 03 Aug 2021 07:37:54 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id w11sm14421126pjr.44.2021.08.03.07.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 07:37:54 -0700 (PDT)
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
From:   Jens Axboe <axboe@kernel.dk>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
Message-ID: <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
Date:   Tue, 3 Aug 2021 08:37:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/21 7:22 AM, Jens Axboe wrote:
> On 8/2/21 7:05 PM, Nadav Amit wrote:
>> Hello Jens,
>>
>> I encountered an issue, which appears to be a race between
>> io_wqe_worker() and io_wqe_wake_worker(). I am not sure how to address
>> this issue and whether I am missing something, since this seems to
>> occur in a common scenario. Your feedback (or fix ;-)) would be
>> appreciated.
>>
>> I run on 5.13 a workload that issues multiple async read operations
>> that should run concurrently. Some read operations can not complete
>> for unbounded time (e.g., read from a pipe that is never written to).
>> The problem is that occasionally another read operation that should
>> complete gets stuck. My understanding, based on debugging and the code
>> is that the following race (or similar) occurs:
>>
>>
>>   cpu0					cpu1
>>   ----					----
>> 					io_wqe_worker()
>> 					 schedule_timeout()
>> 					 // timed out
>>   io_wqe_enqueue()
>>    io_wqe_wake_worker()
>>     // work_flags & IO_WQ_WORK_CONCURRENT
>>     io_wqe_activate_free_worker()
>> 					 io_worker_exit()
>>
>>
>> Basically, io_wqe_wake_worker() can find a worker, but this worker is
>> about to exit and is not going to process further work. Once the
>> worker exits, the concurrency level decreases and async work might be
>> blocked by another work. I had a look at 5.14, but did not see
>> anything that might address this issue.
>>
>> Am I missing something?
>>
>> If not, all my ideas for a solution are either complicated (track
>> required concurrency-level) or relaxed (span another worker on
>> io_worker_exit if work_list of unbounded work is not empty).
>>
>> As said, feedback would be appreciated.
> 
> You are right that there's definitely a race here between checking the
> freelist and finding a worker, but that worker is already exiting. Let
> me mull over this a bit, I'll post something for you to try later today.

Can you try something like this? Just consider it a first tester, need
to spend a bit more time on it to ensure we fully close the gap.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index cf086b01c6c6..e2da2042ee9e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -42,6 +42,7 @@ struct io_worker {
 	refcount_t ref;
 	unsigned flags;
 	struct hlist_nulls_node nulls_node;
+	unsigned long exiting;
 	struct list_head all_list;
 	struct task_struct *task;
 	struct io_wqe *wqe;
@@ -214,15 +215,20 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
 	struct hlist_nulls_node *n;
 	struct io_worker *worker;
 
-	n = rcu_dereference(hlist_nulls_first_rcu(&wqe->free_list));
-	if (is_a_nulls(n))
-		return false;
-
-	worker = hlist_nulls_entry(n, struct io_worker, nulls_node);
-	if (io_worker_get(worker)) {
-		wake_up_process(worker->task);
+	/*
+	 * Iterate free_list and see if we can find an idle worker to
+	 * activate. If a given worker is on the free_list but in the process
+	 * of exiting, keep trying.
+	 */
+	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
+		if (!io_worker_get(worker))
+			continue;
+		if (!test_bit(0, &worker->exiting)) {
+			wake_up_process(worker->task);
+			io_worker_release(worker);
+			return true;
+		}
 		io_worker_release(worker);
-		return true;
 	}
 
 	return false;
@@ -560,8 +566,17 @@ static int io_wqe_worker(void *data)
 		if (ret)
 			continue;
 		/* timed out, exit unless we're the fixed worker */
-		if (!(worker->flags & IO_WORKER_F_FIXED))
+		if (!(worker->flags & IO_WORKER_F_FIXED)) {
+			/*
+			 * Someone elevated our refs, which could be trying
+			 * to re-activate for work. Loop one more time for
+			 * that case.
+			 */
+			if (refcount_read(&worker->ref) != 1)
+				continue;
+			set_bit(0, &worker->exiting);
 			break;
+		}
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {

-- 
Jens Axboe

