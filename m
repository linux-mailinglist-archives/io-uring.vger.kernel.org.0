Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E7818A257
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2020 19:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgCRSaQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Mar 2020 14:30:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33406 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgCRSaQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Mar 2020 14:30:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id m5so14160012pgg.0
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2020 11:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Xv58TS79kgVAJ4pJd3MMkSr2irD5cfFy7i4FlWThJn4=;
        b=KkGbO0c1fHU/7f3krTkKKVvSHeF7/kWzKzjN77g7Ibw8bb7WVCXPwUim9b3pPO3qMH
         81PWQbZ4FsMng1hEdP71Bmt3K2EryKbmGljTyMKdgkH7cTmoGjHxkZrHgkZXmdmnCKFY
         SGQ3aHXrF2WcWUGsT8aK2MxTNr2mo/RyBeWGxJ67wS04P87moUqKV5HmTDAxbn8pdJDJ
         ddVTEdProSXmI40fFjhi1MInUUsWOpXrja91F1CpokkhFX4UHcNsjOTg1t4aTi5LMjfe
         ngdKe4XqyEqjABmsoyRVAS3Eb9e4ZXqDLdrBgvvQT+i1Rk8i9aF2L0gM5EdU+JSVA/It
         d0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Xv58TS79kgVAJ4pJd3MMkSr2irD5cfFy7i4FlWThJn4=;
        b=pAQ7rgEe2QU2V6oWErbBsPzg7jY9vcP3BBBIuuVDW+40YATrFnTx02U35RmVVk4JRQ
         /BudEa4D87LShejifCkZ6p1Gs1TzkuHHIQT7CAjpmV1rYbOR4pGrmz7HWm2IOkzdG0Yv
         RSKoxUlIuTdxmrQu6SXPz+WaVIRu7ynn3VN48nmyyTmFZYFvM5sLRbGtluCpeCCijdg+
         FcAR9RYRF0kTfW3/jIWMH0w+aXIDI9vX1t3lba1IyJHcG0ta3s/hQrD48uzmEsIBRCWF
         fm8GeVOz6N7eth35LD/F9A56tItahOFGsFNnL1Ux3NxiEYoVNjaeKhDNCwxftpQDc5mk
         czxw==
X-Gm-Message-State: ANhLgQ1O25NqypzebGJPrwTeaFI2b6zUnVYqDsCWG5q8HV0asYjPs//C
        0VXsvzaqNf0EPyeqpVD12S0No73QCx/LeQ==
X-Google-Smtp-Source: ADFU+vuoe2jS9N3RZRRJTHUr+0zAncP1yU1mAITSNhnZ6XIuP3QF0qrC+PIRxcdHM4adtgyjfCVUig==
X-Received: by 2002:a63:144e:: with SMTP id 14mr6159948pgu.264.1584556214327;
        Wed, 18 Mar 2020 11:30:14 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e6sm6551112pgu.44.2020.03.18.11.30.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 11:30:13 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC] io-wq: handle hashed writes in chains
Message-ID: <a0706109-59c3-745f-8e40-afac16700ef9@kernel.dk>
Date:   Wed, 18 Mar 2020 12:30:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RFC patch for now - I've tested it, works for me. Basically it allows
io-wq to grab a whole chain of identically hashed writes, avoiding
hammering on the wqe->lock for detaching hashed work.

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9541df2729de..d9a50670d47b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -380,32 +380,44 @@ static inline unsigned int io_get_work_hash(struct io_wq_work *work)
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
+			if (hash != -1U)
+				break;
+			wq_node_del(&wqe->work_list, &work->list, NULL);
+			ret = work;
+			break;
 		}
 
 		/* hashed, can run if not already running */
-		hash = io_get_work_hash(work);
-		if (!(wqe->hash_map & BIT(hash))) {
-			wqe->hash_map |= BIT(hash);
-			wq_node_del(&wqe->work_list, node, prev);
-			return work;
-		}
+		new_hash = io_get_work_hash(work);
+		if (hash == -1U)
+			hash = new_hash;
+		else if (hash != new_hash)
+			break;
+
+		wqe->hash_map |= BIT(hash);
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
@@ -481,6 +493,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
+	struct io_wq_work_list list = { .first = NULL, .last = NULL };
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
@@ -495,7 +508,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe);
+		work = io_get_next_work(wqe, &list);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
 		else if (!wq_list_empty(&wqe->work_list))
@@ -504,6 +517,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
+got_work:
 		io_assign_current_work(worker, work);
 
 		/* handle a whole dependent link */
@@ -530,6 +544,14 @@ static void io_worker_handle_work(struct io_worker *worker)
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

