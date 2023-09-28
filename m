Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43077B23DE
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjI1RZz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbjI1RZi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:38 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83703CC6
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:35 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9b2c5664cb4so29725866b.1
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921933; x=1696526733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMx5R6E0R0h9+pd+QZi7bIoYwQS8EWnvSyRr5gNA3m0=;
        b=x5KmuZolHfI6zmMIvBkqCBB0NojKGYm/Ej/lsp06NKUeAtEv3Axen0d35ZtfRu2/YL
         93crRONQeATlgUnZBlr6Sy52uIdIdTs6B9Fx+NiJrmJ0mibrbtEK9l4YYNY7Il4q+njd
         OxJQTtMb7L6UIQcU0wSBRJ02NNFh4twwp4Dt8kRDAaJlWoa+hAdykwZBoN2w38iltlAN
         y8+Lc4o1+QVgA2Oc7vqliXG/OuMbCOheRMrF5glK9DBZexIYUfavQV4Tox6nNgE4HBZZ
         E7S64ApXCTyIRVbqaU0i6gSdk1KERTeEjpsGWEELiuUfhTwfckiJoYB+jDXGKLkH0Aii
         nw5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921933; x=1696526733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMx5R6E0R0h9+pd+QZi7bIoYwQS8EWnvSyRr5gNA3m0=;
        b=YitGEFVMlSzW5XAMBYWhIRwuwUfUW0ZzcBmARFxcD/6HZCLHXKOyqtDTFnilqEkuGR
         CAg2FCOOU7ON0atyBfBl3j+oamqg2QW8OyBV3DZj+AHD3cx5aeWwSvgvem6+SseeOD0m
         Au3FM4Ck5eDkw1gC8iY7MmAVBZI/oDgCcGYTM5xQ5V3gFGDtO039oZOV97jCrbfM0JVY
         XXXVGNexg4VYoTfTte+4mW0IyBgp9z4IhPYFUUe5LUDFlzLtjTcmzdSt8P8HLONdEXWx
         3UHdbdAZOxTgGUwYAx0etRH6o8BB+2v0Znph/FcFeHLLaxwy8gbTDzYNPKhwZuTYMKzB
         nQPA==
X-Gm-Message-State: AOJu0Ywkkuxvs5X2Ng30UkddgDDVB86/PiPABYpXwevEZOgEWQ8/+Tfk
        TIoLjMD0HaUI/xYtS8kVOw6UNuGImuZRS+T8Q4ZlYeaU
X-Google-Smtp-Source: AGHT+IHa3Y9Bw3hn4IrDS6VS6xTff2Gj6P6+DF3gCheqbj1zXStjS6Sn/03mJnzS1w+wQW5J4kl0TQ==
X-Received: by 2002:a17:906:25d:b0:9b2:bf2d:6b65 with SMTP id 29-20020a170906025d00b009b2bf2d6b65mr2106678ejl.4.1695921933527;
        Thu, 28 Sep 2023 10:25:33 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] futex: make the vectored futex operations available
Date:   Thu, 28 Sep 2023 11:25:16 -0600
Message-Id: <20230928172517.961093-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230928172517.961093-1-axboe@kernel.dk>
References: <20230928172517.961093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 6b6a6b3da103..8b195d06f4e8 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -366,6 +366,11 @@ extern int futex_parse_waitv(struct futex_vector *futexv,
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
index 6fcf5f723719..61b112897a84 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -372,7 +372,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 }
 
 /**
- * unqueue_multiple - Remove various futexes from their hash bucket
+ * futex_unqueue_multiple - Remove various futexes from their hash bucket
  * @v:	   The list of futexes to unqueue
  * @count: Number of futexes in the list
  *
@@ -382,7 +382,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
  *  - >=0 - Index of the last futex that was awoken;
  *  - -1  - No futex was awoken
  */
-static int unqueue_multiple(struct futex_vector *v, int count)
+int futex_unqueue_multiple(struct futex_vector *v, int count)
 {
 	int ret = -1, i;
 
@@ -410,7 +410,7 @@ static int unqueue_multiple(struct futex_vector *v, int count)
  *  -  0 - Success
  *  - <0 - -EFAULT, -EWOULDBLOCK or -EINVAL
  */
-static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
+int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
 {
 	struct futex_hash_bucket *hb;
 	bool retry = false;
@@ -472,7 +472,7 @@ static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *wo
 		 * was woken, we don't return error and return this index to
 		 * userspace
 		 */
-		*woken = unqueue_multiple(vs, i);
+		*woken = futex_unqueue_multiple(vs, i);
 		if (*woken >= 0)
 			return 1;
 
@@ -557,7 +557,7 @@ int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 
 		__set_current_state(TASK_RUNNING);
 
-		ret = unqueue_multiple(vs, count);
+		ret = futex_unqueue_multiple(vs, count);
 		if (ret >= 0)
 			return ret;
 
-- 
2.40.1

