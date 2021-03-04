Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C3932C9B0
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhCDBJ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349771AbhCDAbr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:31:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C03C0613B7
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:12 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id c19so5288574pjq.3
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Bx2m+qW/WCY/cUohcjcsKVRmnwAX9bE127HkQbJKuA=;
        b=0GkoFXG+mfc0QB7yuNwA4wmntz4GjWpEEa59MaTTtogMjBfpHNKkMVO1W7/hSNnghl
         AiBuwt3BVKbTCylr6w6azSsAF55yuXeHel7JhNRFiRKKnmkh1ZJjQLVYd9dnyjl/G1JP
         Rs5MnDmYdoVUgkc3gWEAKFyoHEI5KIkC4Uys7Iw3RmD3wTSX9VDLNopwrfr+xDfk581M
         3GQcePqwek5vtVxCI8i1Gj0Bbfq28s21+tfCjW71sR8K0meblbTAl71jTVrXnCK3bzj5
         jKfCeQRSoVfGrs+BMbb+mueVTMFnYAX6/nB4kW6mBksRsHIF+/tkzm3FNB39c1Bdp2yr
         gX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Bx2m+qW/WCY/cUohcjcsKVRmnwAX9bE127HkQbJKuA=;
        b=I8v6TwGAPJ2vKjO+sOod8MxqSCh8jHj2spNSjWuSeZItgizgG8lkj0fe+VC0pGlpcE
         QHRi846GNB6JOEzz1OUitS7BsHlTDvOE+m465iKlClqNcYlQTivEjccroZfr3I77I1XO
         mAdja70C5c7tx0VIQpF/wA5dZGDS+JLzMRKznl4Av6p7KaX/F+nK2oH9unO+50NJpPuq
         adzaI4xR1qaatSACAkg3fOBtsM/8+5smHxgVTZJV3v6JBhDSjSJMglrIo+RfC3CBMTKd
         frLjIazuRIyo71/4fTRpIUUzYvKBgQExqh4c81uQF8i7QXjSLWpCAnpLAaEqIgUQzrby
         Us+A==
X-Gm-Message-State: AOAM532KOqK6p3m2n3V4OSEvsgpSicUzIRREOwEUghiViNxBTfWyB1NM
        TU/pj/cE4IRfWo/nRmIHyPFEdw0SeMHZlMZo
X-Google-Smtp-Source: ABdhPJxBjd/OwcsEsWljSybD1cVnav8PflkRKJcrup10yU98HHCiV7u7w1jn5bFEIoNRl20nIzc0Wg==
X-Received: by 2002:a17:902:6b85:b029:e5:b91c:a265 with SMTP id p5-20020a1709026b85b02900e5b91ca265mr1497692plk.63.1614817631657;
        Wed, 03 Mar 2021 16:27:11 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/33] io-wq: wait for manager exit on wq destroy
Date:   Wed,  3 Mar 2021 17:26:32 -0700
Message-Id: <20210304002700.374417-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The manager waits for the workers, hence the manager is always valid if
workers are running. Now also have wq destroy wait for the manager on
exit, so we now everything is gone.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a8ddca62f59e..9e52a9877905 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -119,6 +119,7 @@ struct io_wq {
 
 	refcount_t refs;
 	struct completion started;
+	struct completion exited;
 
 	atomic_t worker_refs;
 	struct completion worker_done;
@@ -764,6 +765,7 @@ static int io_wq_manager(void *data)
 	if (atomic_read(&wq->worker_refs))
 		wait_for_completion(&wq->worker_done);
 	wq->manager = NULL;
+	complete(&wq->exited);
 	io_wq_put(wq);
 	do_exit(0);
 }
@@ -1059,6 +1061,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	wq->task_pid = current->pid;
 	init_completion(&wq->started);
+	init_completion(&wq->exited);
 	refcount_set(&wq->refs, 1);
 
 	init_completion(&wq->worker_done);
@@ -1088,8 +1091,10 @@ static void io_wq_destroy(struct io_wq *wq)
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-	if (wq->manager)
+	if (wq->manager) {
 		wake_up_process(wq->manager);
+		wait_for_completion(&wq->exited);
+	}
 
 	rcu_read_lock();
 	for_each_node(node)
-- 
2.30.1

