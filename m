Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E729E75BA73
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjGTWTe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjGTWTa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:30 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A8F2D60
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:20 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-682ae5d4184so279565b3a.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891559; x=1690496359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lq7tP5scFTqDKeEjsRY7Tfz3Q9kMITKiPWmV0T5QGyI=;
        b=Ij/3TH98pX57tuhiixNKQRc8HG3f1pLySWMkiQRMx0ya7gGEJJughG99K6FG+ADm99
         k1clK8HPB0W80Nm8zNcMrBX0UepmGEfetXzk+5oX/eztboEINLcNw7kQtngebfFcg0GW
         uEUqQMxMYYFogtJgl5/EOBLwKGcvxHIc6u7FmSkOIsXrytbzinUkVM/aHYnOecxJ8UD/
         Ye1GaP44TIGKKrqu42h3JkB4BwtzpWgh62s072aFBVidVez+nxUYmpjKomhHNPrmiOdd
         jE7djQNZCMY64RPzI0k6mVYx7K2VDFylXEOhlZtVF6c6zqdGeJmNFEmUeQexuOxtBEtX
         eCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891559; x=1690496359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lq7tP5scFTqDKeEjsRY7Tfz3Q9kMITKiPWmV0T5QGyI=;
        b=OCm8OJsKPn4NYhn8tllQdkSpeuUe/BMHGmEYQfX7JHkGysQlkVXHdX0RyTthl2eCMB
         Qw0+GIY57rNzoF3O5EffzhMWVGks1wlGn6TGScSMgiGwmE22nUL8btmn4HBrwlmdPorI
         h9wHBm3tAOcpUIJuqKNwinvpdl4eXpDbe1enCQCLj3GB2FD3USRdC8bq0k2KY2G9km/x
         OuNN3ba2abNMIdYC+tVD5yosOYQFcEcwlcRZFiuqNtmwI6zQO7sMcNKKriIe3yi+A750
         8nwB2J4bRtHGvCis6oDWFUHSXbtPUuXJBYfAA0s2LRtRh0DJLz8OZJ8hb/Iv4b0twju8
         tuEQ==
X-Gm-Message-State: ABy/qLaOMUO5i0NYUkjtTMpq3qkYUWfilRQoOTGmZ7KjlQQP5X4YlQpq
        kRf2bbhhTImdlU3+i2Z4vB6kGJ1QPQj/74zb4NM=
X-Google-Smtp-Source: APBJJlGgnq9cFs6XgobATsTjtEsTTzRagoTDGJ0Q2WImkj5xxjljEUzmAOSf6XA/e4Fzuexwafs+vw==
X-Received: by 2002:a05:6a20:6a1d:b0:137:4fd0:e2e1 with SMTP id p29-20020a056a206a1d00b001374fd0e2e1mr276021pzk.4.1689891559262;
        Thu, 20 Jul 2023 15:19:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/10] futex: make the vectored futex operations available
Date:   Thu, 20 Jul 2023 16:18:57 -0600
Message-Id: <20230720221858.135240-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720221858.135240-1-axboe@kernel.dk>
References: <20230720221858.135240-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rename unqueue_multiple() as futex_unqueue_multiple(), and make both
that and futex_wait_multiple_setup() available for external users. This
is in preparation for wiring up vectored waits in io_uring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    |  5 +++++
 kernel/futex/waitwake.c | 10 +++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 3536d21adff9..faf84915acb2 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -332,6 +332,11 @@ extern int futex_parse_waitv(struct futex_vector *futexv,
 			     unsigned int nr_futexes, futex_wake_fn *wake,
 			     void *wake_data);
 
+extern int futex_wait_multiple_setup(struct futex_vector *vs, int count,
+				     int *woken);
+
+extern int futex_unqueue_multiple(struct futex_vector *v, int count);
+
 extern int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 			       struct hrtimer_sleeper *to);
 
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 86f67f652b95..6c8fb7300558 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -369,7 +369,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 }
 
 /**
- * unqueue_multiple - Remove various futexes from their hash bucket
+ * futex_unqueue_multiple - Remove various futexes from their hash bucket
  * @v:	   The list of futexes to unqueue
  * @count: Number of futexes in the list
  *
@@ -379,7 +379,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
  *  - >=0 - Index of the last futex that was awoken;
  *  - -1  - No futex was awoken
  */
-static int unqueue_multiple(struct futex_vector *v, int count)
+int futex_unqueue_multiple(struct futex_vector *v, int count)
 {
 	int ret = -1, i;
 
@@ -407,7 +407,7 @@ static int unqueue_multiple(struct futex_vector *v, int count)
  *  -  0 - Success
  *  - <0 - -EFAULT, -EWOULDBLOCK or -EINVAL
  */
-static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
+int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
 {
 	struct futex_hash_bucket *hb;
 	bool retry = false;
@@ -469,7 +469,7 @@ static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *wo
 		 * was woken, we don't return error and return this index to
 		 * userspace
 		 */
-		*woken = unqueue_multiple(vs, i);
+		*woken = futex_unqueue_multiple(vs, i);
 		if (*woken >= 0)
 			return 1;
 
@@ -554,7 +554,7 @@ int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 
 		__set_current_state(TASK_RUNNING);
 
-		ret = unqueue_multiple(vs, count);
+		ret = futex_unqueue_multiple(vs, count);
 		if (ret >= 0)
 			return ret;
 
-- 
2.40.1

