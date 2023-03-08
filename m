Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9586B0B23
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 15:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbjCHO25 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 09:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjCHO2l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 09:28:41 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01508231E4
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 06:28:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so2556347pjh.0
        for <io-uring@vger.kernel.org>; Wed, 08 Mar 2023 06:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678285671;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qdTcUtO9YdJ502BWWJ304B8x/esaHYegipQ+3wcllh8=;
        b=rhe9FgTCNWQY79XM8WDAYF3FM60RFR/v1pK4Ol/zR/4u6rTMr0DzUe4mIQKOHkk5zZ
         PLvd6ys3g2BzIMWd8SQ7tQO9OiAIbRXPhbjQSzwRV7KcB2NBbVAWVmeNDxIYqIu8NQHw
         krZRnWD82bIfNJo7hLPAxhJFk4HAxO1EQefaoetULcCGxRJCSvpE2CLDDLbmFHNsn/Dz
         Bk7rlKo/SqRRsLfSb+0fRYvnuwyASlqboKaK7bVJXoGqgKGoaEjxMVifcjeEZZmHsH8C
         2LyPXGyEYH/68Q8wRdIOJIRyvF0WsbeNObZwVUyABFqbowscrlT47WuScTix49WZX5uk
         dHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678285671;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qdTcUtO9YdJ502BWWJ304B8x/esaHYegipQ+3wcllh8=;
        b=QBs2O3ulYR0Ac0it2Xo25PPJAiawkaxkKCsiPrr/qdIQVrBDT/5/ncRtiMU2/uuOFd
         KcIrImwFSjkDQF+PdS7OOj44Gbpxaq7Mr8N3Jp8ork8dTriN4WNwK+lK9C3lRkBl0LeQ
         f2JqR8E42LR6ojPQ7ESo92teEDuXm5p2vrgdL71SKNSOfFXcwX0iQF+E9FeLm/cqhRQB
         IoE/5R1rULehAiNC/M8wQzfoXl0ZJw14KDtyX7G8+TFWQq6suLEdNcFnaoWscaHlJ6Cr
         3WCMH9QnLU2AvIMzkxwfBtKyg7QIr6/ZS8I+diaPSqD37wn9Djt9mqLIDT3M8uCHoa5F
         cL6Q==
X-Gm-Message-State: AO0yUKU5lekKdDLe8PlDul8NHIfOnqq2RVO3b74lBQMR8sdt3grtSGra
        L99zwMbD9hmC5eg5ov+T5agr/U/SKZ2+8ii3b7Y=
X-Google-Smtp-Source: AK7set+Jx6SE+YfwASEE69N/9PYI1trTqv52eXJUOrZPuj8bdzQJx0ILZLeNmeqMZBi2B5YlzAf4kQ==
X-Received: by 2002:a05:6a20:7d88:b0:cd:345e:5b10 with SMTP id v8-20020a056a207d8800b000cd345e5b10mr3001837pzj.5.1678285670954;
        Wed, 08 Mar 2023 06:27:50 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id p6-20020a631e46000000b00502ecb91940sm9265198pgm.55.2023.03.08.06.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 06:27:50 -0800 (PST)
Message-ID: <0f0e791b-8eb8-fbb2-ea94-837645037fae@kernel.dk>
Date:   Wed, 8 Mar 2023 07:27:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Daniel Dao <dqminh@cloudflare.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq
 workers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Every now and then reports come in that are puzzled on why changing
affinity on the io-wq workers fails with EINVAL. This happens because they
set PF_NO_SETAFFINITY as part of their creation, as io-wq organizes
workers into groups based on what CPU they are running on.

However, this is purely an optimization and not a functional requirement.
We can allow setting affinity, and just lazily update our worker to wqe
mappings. If a given io-wq thread times out, it normally exits if there's
no more work to do. The exception is if it's the last worker available.
For the timeout case, check the affinity of the worker against group mask
and exit even if it's the last worker. New workers should be created with
the right mask and in the right location.

Reported-by:Daniel Dao <dqminh@cloudflare.com>
Link: https://lore.kernel.org/io-uring/CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 411bb2d1acd4..f81c0a7136a5 100644
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
+			exit_mask = !cpumask_test_cpu(raw_smp_processor_id(),
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

