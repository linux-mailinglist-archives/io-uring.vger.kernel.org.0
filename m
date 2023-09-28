Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC23D7B23D6
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbjI1RZh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjI1RZf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:35 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293ACCEF
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:33 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9b27f99a356so225172866b.0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921930; x=1696526730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/TGT+v2onwhR3DWI/C2XC90jEj/DLLYrXKmnR2IfXs=;
        b=chyq2RM7TRkMav4kl6LfB1ZA12RrnS94Jl+ADgBTqgzkD5nViYFBMNoWTo4ueBForF
         lzmlvsruUlaqklO8yLHrznKdhJMy2EBRos31/CMC++Zh0/i/cHFjNxJaZ03bxRfuU2yy
         zyxNmJ7HQy1+5/hu0r0Y77IiVN1n7SLdx2VcI8qEMTgRcFlW7P/8UK8IK5HTs5JuQLSE
         U4yRErpwg5506oVIvt4+v/fWS3TdAytsAD0yrlT3UC04hxiJInYJ1z39DuoI7r+YRebr
         aU9+DFuNOYzkoE85VRhrWlFdqn4bJGjHyjVbGDTeywWVOShPaNDz/dmHhVKVgOorqeDT
         +maQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921930; x=1696526730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/TGT+v2onwhR3DWI/C2XC90jEj/DLLYrXKmnR2IfXs=;
        b=N1SWXieT+oHh3pjOluQbyhaAwyWML+raOghNplQXhYpR37HSHXASz4ed3/gZFCAJah
         SQf+DzyGWOeX3wiM7iHy3JNfmTNYxjcgj/CGCtJHTyW3M1OcOomIBt8De7tTWOFAew69
         g+hXzqBt1ejXhyLzOqax9DJtKOU48hH9x5pYwWQ300Ibsph+82L9h1kly4VqAKfzwT+r
         dAZuofRRWGS0/uojqEbnZVqpbpgRrwKmbukpr47+dFWafEjHdoS7gANqtdv0zuE14B5U
         gMTZSCjEfP8jNdNtkVkI+H1I0JaOJQvc9ZMjYXIw5rOnZv/PoxdXPqXfYhwUgG9ARlnh
         WeKg==
X-Gm-Message-State: AOJu0YzLQ/KYw+k9Hh9ljz1QKRf85pXqfzwkmOqFQerrLrLwJafpooqG
        kH3xMcWNKhdl2F1YDgR7qCEEBPYEdpP8FE2mUWLwfqcf
X-Google-Smtp-Source: AGHT+IH0euAGYjrCZbgJ8RFIhz/xz08t6fWykn21eNHckLKUHkkweKDGKXgPC/XNOmxmryeAGfBWbA==
X-Received: by 2002:a17:906:5185:b0:9ae:50de:1aaf with SMTP id y5-20020a170906518500b009ae50de1aafmr1750879ejk.4.1695921930540;
        Thu, 28 Sep 2023 10:25:30 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] futex: add wake_data to struct futex_q
Date:   Thu, 28 Sep 2023 11:25:14 -0600
Message-Id: <20230928172517.961093-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230928172517.961093-1-axboe@kernel.dk>
References: <20230928172517.961093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With handling multiple futex_q for waitv, we cannot easily go from the
futex_q to data related to that request or queue. Add a wake_data
argument that belongs to the wake handler assigned.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 33835b81e0c3..76f6c2e0f539 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -148,6 +148,7 @@ typedef void (futex_wake_fn)(struct wake_q_head *wake_q, struct futex_q *q);
  * @task:		the task waiting on the futex
  * @lock_ptr:		the hash bucket lock
  * @wake:		the wake handler for this queue
+ * @wake_data:		data associated with the wake handler
  * @key:		the key the futex is hashed on
  * @pi_state:		optional priority inheritance state
  * @rt_waiter:		rt_waiter storage for use with requeue_pi
@@ -173,6 +174,7 @@ struct futex_q {
 	struct task_struct *task;
 	spinlock_t *lock_ptr;
 	futex_wake_fn *wake;
+	void *wake_data;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
-- 
2.40.1

