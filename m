Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E39718A846
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2020 23:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCRWdv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Mar 2020 18:33:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35501 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCRWdv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Mar 2020 18:33:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id 7so81914pgr.2
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2020 15:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Taql9EYKlVSCNiwUC9EKtHFQixRKepu7LJ2bKYMM9s0=;
        b=YJCC3m6CrBlpd2QgKCfp2aSd/5istfQq+UXj0AU2QRG470A5FUNv7xvuXUIPO3A9kx
         abKAmXJ2VC1WlNwzBZLRWVWDDnQJj4XAgWS8cr6B8hcSiO7+zigMPum1KJZJRyFUl/+N
         k5mIIHNo6fQYLI0CzxdCj7C1chSGRuYtC3pyyQGpzD8aeWnReI5LTclMPIDWvNPlZLcd
         ivyQamXpA7A7Oeswlts0bBoIqwh9MivcHymFsraioa6bJ+d2qavFHGr3s4yqP8gW0Q6N
         6pyHGBkDcN8tPpQ3QJyy1PxqOfYetyxI/gnjSJo7FYLQCtlKgqz7c98XX0ZkeOYl5blP
         vV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Taql9EYKlVSCNiwUC9EKtHFQixRKepu7LJ2bKYMM9s0=;
        b=qVozpdH1RIHVEsi4w9GDz5VtoZ3vnsOzIv5NPN5MLNxeFTuKX6PG32dh5quHc2Yzao
         VZtgo5M/P/f/ORoq4vVpt+oIwXbPVlToAdcq5rQIEwUz0AslCLQCDtGTH3SQhnXkB+D0
         dfr3OkF+B2yDzk9Dh52GdkXt8xlD59abU3gODC/3XuDVUU+fS8V8DeKiJWZ6I/0iIr9I
         wCU21Mz6mc0LAXPVJzU2uXznKt4C1UeWr8YN285ilGn73U1in8J5qop0GHYVxBZpgUJs
         2LUAIOwWLBcmbhXRKhL+qxIRhE42Z+hAckP1yiqQUp5myqlMWZKU5PgfW8R45hU/kIPN
         NtHA==
X-Gm-Message-State: ANhLgQ0+wfq3I5CJAYfzkbCSYOVO4amuZluwdN08A0YKzxUTgSwNZsDz
        V4b1mi5WXlJL2LdtOVXH6oPXULRQC/mj3Q==
X-Google-Smtp-Source: ADFU+vsSgCSvFISkCsiy1woC9krbLLR55RndKOlg22dmGnYmQXO0FV4PCKG4yrK4BuTdGAVr4lol6g==
X-Received: by 2002:aa7:9145:: with SMTP id 5mr601347pfi.74.1584570828637;
        Wed, 18 Mar 2020 15:33:48 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z7sm72548pfz.24.2020.03.18.15.33.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 15:33:48 -0700 (PDT)
Subject: Re: [PATCH RFC] io-wq: handle hashed writes in chains
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <a0706109-59c3-745f-8e40-afac16700ef9@kernel.dk>
Message-ID: <b9b3c8a2-98a4-3429-2a9c-44f195c50ab3@kernel.dk>
Date:   Wed, 18 Mar 2020 16:33:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a0706109-59c3-745f-8e40-afac16700ef9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/20 12:30 PM, Jens Axboe wrote:
> RFC patch for now - I've tested it, works for me. Basically it allows
> io-wq to grab a whole chain of identically hashed writes, avoiding
> hammering on the wqe->lock for detaching hashed work.

Here's a v2. Changes:

- Fix overlapped hashed work, if we restarted
- Wake new worker if we have mixed hashed/unhashed. Unhashed work
  can always proceed, and if the hashed work is all done without
  needing IO, then unhashed should not have to wait.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9541df2729de..674be5a3841b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -380,32 +380,56 @@ static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 	return work->flags >> IO_WQ_HASH_SHIFT;
 }
 
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
+static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
+					   struct io_wq_work_list *list)
 	__must_hold(wqe->lock)
 {
-	struct io_wq_work_node *node, *prev;
-	struct io_wq_work *work;
-	unsigned int hash;
+	struct io_wq_work *work, *ret;
+	unsigned int new_hash, hash = -1U;
 
-	wq_list_for_each(node, prev, &wqe->work_list) {
-		work = container_of(node, struct io_wq_work, list);
+	ret = NULL;
+	while (!wq_list_empty(&wqe->work_list)) {
+		work = container_of(wqe->work_list.first, struct io_wq_work,
+					list);
 
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
-			wq_node_del(&wqe->work_list, node, prev);
-			return work;
+			/* already have hashed work, let new worker get this */
+			if (ret) {
+				struct io_wqe_acct *acct;
+
+				/* get new worker for unhashed, if none now */
+				acct = io_work_get_acct(wqe, work);
+				if (!atomic_read(&acct->nr_running))
+					io_wqe_wake_worker(wqe, acct);
+				break;
+			}
+			wq_node_del(&wqe->work_list, &work->list, NULL);
+			ret = work;
+			break;
 		}
 
 		/* hashed, can run if not already running */
-		hash = io_get_work_hash(work);
-		if (!(wqe->hash_map & BIT(hash))) {
+		new_hash = io_get_work_hash(work);
+		if (wqe->hash_map & BIT(new_hash))
+			break;
+
+		if (hash == -1U) {
+			hash = new_hash;
 			wqe->hash_map |= BIT(hash);
-			wq_node_del(&wqe->work_list, node, prev);
-			return work;
+		} else if (hash != new_hash) {
+			break;
 		}
+
+		wq_node_del(&wqe->work_list, &work->list, NULL);
+		/* return first node, add subsequent same hash to the list */
+		if (ret)
+			wq_list_add_tail(&work->list, list);
+		else
+			ret = work;
 	}
 
-	return NULL;
+	return ret;
 }
 
 static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
@@ -481,6 +505,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
+	struct io_wq_work_list list = { .first = NULL, .last = NULL };
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
@@ -495,7 +520,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe);
+		work = io_get_next_work(wqe, &list);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
 		else if (!wq_list_empty(&wqe->work_list))
@@ -504,6 +529,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
+got_work:
 		io_assign_current_work(worker, work);
 
 		/* handle a whole dependent link */
@@ -530,6 +556,14 @@ static void io_worker_handle_work(struct io_worker *worker)
 				work = NULL;
 			}
 			if (hash != -1U) {
+				if (!wq_list_empty(&list)) {
+					work = container_of(list.first,
+							    struct io_wq_work,
+							    list);
+					wq_node_del(&list, &work->list, NULL);
+					goto got_work;
+				}
+
 				spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;

-- 
Jens Axboe

