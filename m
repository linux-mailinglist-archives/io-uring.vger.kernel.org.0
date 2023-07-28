Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218D1767227
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 18:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbjG1Qng (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 12:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbjG1Qm6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 12:42:58 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89994220
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:47 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-785ccd731a7so26647439f.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690562567; x=1691167367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXSlh5iMF2cncsBboldJj3SWTlVFipNC9kJryix07S8=;
        b=uR1ssBnjeuiTE5m+B1bv8/fVJi5l51pnVmG4/EL2HyEO/5GT3XvxP+aKESMKhKlEgX
         jZie60GP1Zs56RCJUEG7Fl3y6elluyJ1bBWTmu8gm4wxHC3Ht0X2XW8Iq0nSAqg4ZMDx
         L3jL+mrawF4MCUuHLxar6LxnHgBrJI4J3KXzU1IuiXv0ivgJuxsdxGJHyW/B3uwqOyiz
         vuWprkljIdUGjE/PFrQjkroizLVTWfApqq5YggJJCfCgmVzjxTs4LtwPy25jqwMknP7a
         G+1N8neLLNkHLV0jnpbkM3i88h4gcDlyQ8S2i/5tRA2Tk8Z7+F8S56ihdnb5n9oWTYAo
         7rYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690562567; x=1691167367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OXSlh5iMF2cncsBboldJj3SWTlVFipNC9kJryix07S8=;
        b=XfJJ5Xu91hS6u9FvFIWRhf5XWYuNNZ1RA0dFKYYWfbtXgcUSDX+DG6ztunmKho9V3o
         ajadx0L1C5tjk9O6GbuXKl28R7QQ/dyCoZEIhNZ4jmefM9vXoPfoch3nxMDV+QjnbDGV
         SWpK9nTZh/lq9Gq+G17w37IAHEVPJhpbkNQWtOIdJVnfxuJA2OgXOXrv8pKbCUPNUS3d
         QZT5xBTtY/O3P7GYVNJVqHVSiL25ORnkC8aslnroHNcx4KuNJtKAz5pOJgadkHapW1xl
         W9uiN56rl+sg3MkJUDIN+x77CZ20TvjD/essm5I+UYo02PVAlaHlJHdX0BJjY4EisWJg
         hVWQ==
X-Gm-Message-State: ABy/qLbit5tRVxFZ3pKvSXiaaSAGzwPJo3Hia34SZowJf7hlu7oMhDVB
        56l9afttRVKkYIBaxxLfrn54tge0s7MdYNg5HwY=
X-Google-Smtp-Source: APBJJlFlBnnNTWUhJsxY+erh6d54s+bvd80ug2ho8FkRQYf0VeSYZ+olBr/8UMGKDweSt+ZDFNkkog==
X-Received: by 2002:a05:6602:3d5:b0:780:d65c:d78f with SMTP id g21-20020a05660203d500b00780d65cd78fmr98470iov.2.1690562566663;
        Fri, 28 Jul 2023 09:42:46 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a029a02000000b0042b37dda71asm1158808jal.136.2023.07.28.09.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:42:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/12] futex: add wake_data to struct futex_q
Date:   Fri, 28 Jul 2023 10:42:32 -0600
Message-Id: <20230728164235.1318118-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728164235.1318118-1-axboe@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk>
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

With handling multiple futex_q for waitv, we cannot easily go from the
futex_q to data related to that request or queue. Add a wake_data
argument that belongs to the wake handler assigned.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index e04c74a34832..4633c99ea4b6 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -146,6 +146,7 @@ typedef void (futex_wake_fn)(struct wake_q_head *wake_q, struct futex_q *q);
  * @task:		the task waiting on the futex
  * @lock_ptr:		the hash bucket lock
  * @wake:		the wake handler for this queue
+ * @wake_data:		data associated with the wake handler
  * @key:		the key the futex is hashed on
  * @pi_state:		optional priority inheritance state
  * @rt_waiter:		rt_waiter storage for use with requeue_pi
@@ -171,6 +172,7 @@ struct futex_q {
 	struct task_struct *task;
 	spinlock_t *lock_ptr;
 	futex_wake_fn *wake;
+	void *wake_data;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
-- 
2.40.1

