Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CE674FC5B
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjGLAre (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjGLArW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:47:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DEC1987
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:20 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b9d9cbcc70so5006025ad.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689122839; x=1689727639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dWVSKxrnKu5hFU+vCQFzf5LgVGgpoqEzW6iDZaj+u6I=;
        b=pOpXts18eWWzVgfvcp1gjSlrjNuWBS8ap8AAX3uZJZfqqP+3gL8MLcAIJmy8JdLwI7
         kAgvvKI+lElpiyuOIABzKxKW/9YfLkQ+KoWd8zriwzKl5/WTBrjBoG/NKbHSZNBjcz6+
         DzCtwiesO2ZhE3bssOr0dVsgabQPoqBbmrBWpXDSFW84tCSHdvnaEZen/11NCaAUIhFq
         sm5gXEoWwibq3mVuj9nW1f/EJk82UAe8fO1eeGbFZP8EotUKX7V9LEVsS76qLnSddEmY
         FAHOsXqy+1jQA2aZM0a3G80veYKKMudX9CP8VdYxvYm9XwxUk6M4b8+o2hTNPPVv0C9U
         4WlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689122840; x=1689727640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dWVSKxrnKu5hFU+vCQFzf5LgVGgpoqEzW6iDZaj+u6I=;
        b=V7U03B7ADAGaniTOvXQhohq+3bbga3SG62toiM63hS/CHFTrhC5dis3IhChers7mmR
         nWqQqolat6eJhqadUcI8AS0NjLfNbyXV9EFQNFkDe6YuANIQRAoUROGKLvl+x9pGUPPb
         jMbYvk6WZIjm2adsMc6zWkNGUNCxyUq6J6gggabsCJLnF1zQozMsbuOZYSzFRJysa48l
         492J3M1Ycd8GuOYIQxgdM5aabA+dgnP1SfThK61ezSHI0+t04XS3bG5gdJjY/4NRhVv2
         H8/Xny68Nam5sPR3nV4rSM7102hsPmExL1TFbVX/5ZWiL6h5Pew3oUUgG+/20kgu56uo
         FTlA==
X-Gm-Message-State: ABy/qLa7CAsEYJVI26deE+B6eMQ5tzSxzLUwoLG6+LUEu1D0CGSxhSB1
        0o5ugkm1Pgrv5pJxLIyX2zfZfVc0C5dN393W6n8=
X-Google-Smtp-Source: APBJJlEzylA84a9lM6BmQj4WdfDc+r9lDrVXJXDh0eEcAQi3h0fuO3XsOZah6+YncygvoD/FCTXRrw==
X-Received: by 2002:a17:902:cecd:b0:1b8:9fc4:2733 with SMTP id d13-20020a170902cecd00b001b89fc42733mr21519265plg.3.1689122839695;
        Tue, 11 Jul 2023 17:47:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902b18800b001b694140d96sm2543542plr.170.2023.07.11.17.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 17:47:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] futex: make the vectored futex operations available
Date:   Tue, 11 Jul 2023 18:47:04 -0600
Message-Id: <20230712004705.316157-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712004705.316157-1-axboe@kernel.dk>
References: <20230712004705.316157-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index ed5a7ccd2e99..b06e23c4900e 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -289,6 +289,11 @@ extern int futex_parse_waitv(struct futex_vector *futexv,
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
index dfd02ca5ecfa..b2b762acc997 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -358,7 +358,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 }
 
 /**
- * unqueue_multiple - Remove various futexes from their hash bucket
+ * futex_unqueue_multiple - Remove various futexes from their hash bucket
  * @v:	   The list of futexes to unqueue
  * @count: Number of futexes in the list
  *
@@ -368,7 +368,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
  *  - >=0 - Index of the last futex that was awoken;
  *  - -1  - No futex was awoken
  */
-static int unqueue_multiple(struct futex_vector *v, int count)
+int futex_unqueue_multiple(struct futex_vector *v, int count)
 {
 	int ret = -1, i;
 
@@ -396,7 +396,7 @@ static int unqueue_multiple(struct futex_vector *v, int count)
  *  -  0 - Success
  *  - <0 - -EFAULT, -EWOULDBLOCK or -EINVAL
  */
-static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
+int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
 {
 	struct futex_hash_bucket *hb;
 	bool retry = false;
@@ -459,7 +459,7 @@ static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *wo
 		 * was woken, we don't return error and return this index to
 		 * userspace
 		 */
-		*woken = unqueue_multiple(vs, i);
+		*woken = futex_unqueue_multiple(vs, i);
 		if (*woken >= 0)
 			return 1;
 
@@ -544,7 +544,7 @@ int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 
 		__set_current_state(TASK_RUNNING);
 
-		ret = unqueue_multiple(vs, count);
+		ret = futex_unqueue_multiple(vs, count);
 		if (ret >= 0)
 			return ret;
 
-- 
2.40.1

