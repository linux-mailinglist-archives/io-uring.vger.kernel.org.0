Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2031A750E4B
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbjGLQWE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjGLQVg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:21:36 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CED22D60
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:36 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so65584939f.0
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689178833; x=1689783633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5pADeT4G6dWswC8nfrVWgC9Alv6DnXYYp25ShjDEu0=;
        b=z8EvYG8S5XMLJha2b8s+8bz5IUiF5XfCeUz1Lnp7n4DrQRmF83P+RZiMKgmaAu34cu
         wAf+IrXZud92EHRWW4zLUBHPk253rBGs5nNVbk+i1qg43rSCdGPjI/U0gW3GmYBgeOkL
         nvqb19xvJaLyNDVVzGsz31D+fD0LcUj5IYcklQ62cTIYH7ysoGImt4PFNIN2IMVi9gLG
         ltz8U1WpFlDd7BwHemLRWsuv+0h62Ry5VqxNmLKdJz6VA6A8ArKVOp/1V/DZrQZZpnhZ
         ywZqYnr9YW6B1HD65lN0nq9lSOdkzH3vhlXyzPppn5czxqNPgN1Q6iYKLQg3ce6yQBIb
         Uwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178833; x=1689783633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5pADeT4G6dWswC8nfrVWgC9Alv6DnXYYp25ShjDEu0=;
        b=WEyWac3RwLFstbetgx8s/WNkIMc9VDzVFHDaW/g7iTVGVZXNJqkyGmKqynICVYf6C4
         n2hCQ7WLLO3b4VlUKsYm66Qo7i9wXvfeb+L+siqYeZWauZXZ+OQvTzYiByNYU6/K9Kbh
         KAKFceFmpm5ijPgTOOMqsQPp/lkUltnfxxShfmEIykWoA95ah9lG71MhEOqYqFTYw/I+
         bAXaluoaIUMQa49ezqpVUHiXfiLVrr9TaHtibaKlikKlUpFhjVrdJCQ7BTpnRQSYnFWr
         VyDwi1DpmxooG8Iq/IOimDifYpfVP1GTpSsmiY8w8W6LGI0M+J0KDDQHyR5JEGBveXMs
         G+0g==
X-Gm-Message-State: ABy/qLb2UN/kT8laRQbXnfdf028mPMJj1bdVfKvjUa2Nh4o7nMtVvfX+
        hkJIE8gd9EZTwS8mhGTPYCuTCSYIVPvEBB2MFLk=
X-Google-Smtp-Source: APBJJlFIgL3Q6E03BeWweMkrBPA7hLAuK52KjyI1H6j5d36IcKUKjULD2Rm3pUAvQ4qn6ziBH8VntQ==
X-Received: by 2002:a05:6602:3993:b0:780:c6bb:ad8d with SMTP id bw19-20020a056602399300b00780c6bbad8dmr20527642iob.0.1689178833263;
        Wed, 12 Jul 2023 09:20:33 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x24-20020a029718000000b0042aec33bc26sm1328775jai.18.2023.07.12.09.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:20:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] futex: make the vectored futex operations available
Date:   Wed, 12 Jul 2023 10:20:16 -0600
Message-Id: <20230712162017.391843-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712162017.391843-1-axboe@kernel.dk>
References: <20230712162017.391843-1-axboe@kernel.dk>
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
index f6598d8451fb..4d73d2978e50 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -290,6 +290,11 @@ extern int futex_parse_waitv(struct futex_vector *futexv,
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
index f8fb6550061d..0383da9f737f 100644
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

