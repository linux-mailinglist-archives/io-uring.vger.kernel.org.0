Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E5A750E4A
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbjGLQWE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjGLQVg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:21:36 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19932D5F
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:35 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-785ccd731a7so75963739f.0
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689178832; x=1689783632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=77utXKVr289Xtr5SK547E9baZFV+ka7R8kIV3jn3wns=;
        b=gI7rciFjThQqgqqmYCaizMxtrpZSxtzzwsi+S4mnL2b5gO6BE9BzQPtDNH/9CnF1R2
         TYsXynQEGEhMXgqSFBIM0A+iqu1UDPWYs12q2bd/tt0VFJAGL57hR6qvo/h/CmfGDniL
         Iq9oXIMhd347hbYW0TO+mD1BeprT8njB6m1kIWXvitA8yTVsonbh9Cp+iIP1ew+yPVko
         lBhPsCWnpvbHm9FMXAHpbMtI9sBUBC0Ko3W2X04aQziXeH5Fozi4QVVWyhMwrQ4tUT5o
         eD71S3XbQ2wgGPMoqSoi6AdlIQlnbPHk/YsuhIdOQJkgt/luk+Xr2sL3LPqrwph437eG
         PzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178832; x=1689783632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=77utXKVr289Xtr5SK547E9baZFV+ka7R8kIV3jn3wns=;
        b=jxtke17P8VGApNFBVw3Uf3ULPyozeAASj5V3FibZQOtv77hM7JNDYrTnmPNtbyR2bX
         xUKGnx3ZbUpPJQyDU/Deu701MuVwGH1opXJ4saohpIgLEccRCCuIXbqtAMv2SGd1mK56
         stIe6Dd0iLNzLJF6BGdd3pDxFlHO4QrDoVQpa8NhyvzT05bUsLdL7hVK5b1mzDehqPdR
         ejHauKZIq/lPZvauljZ9KTto2FATM/xCydDzAC4u5ntox/UjJtBvCcEGWRXU0TUL4cHb
         g/yozcfn77QhL7zgVE5Fh/PgwFTlZo4diXjvg/gHsUlHSvHM2CIQs6vsrxohz6knwqGu
         yVuQ==
X-Gm-Message-State: ABy/qLZiVNRSPiaC24pfnGZ9bEgdqIXgCbXD7XJjIZWgUicQnWlPF9CY
        AaXZXXnZbK8qS1cC7pq3ZNK+r5BkiBOuTMZl3gk=
X-Google-Smtp-Source: APBJJlH06yLgDahSs0qD1tZReckWNo0TVLhdg4jwmBuajcUVoiSOQHr6O3rmk1lUs1zb3/yCDPdADQ==
X-Received: by 2002:a05:6602:2f14:b0:783:6ec1:65f6 with SMTP id q20-20020a0566022f1400b007836ec165f6mr24774001iow.1.1689178831951;
        Wed, 12 Jul 2023 09:20:31 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x24-20020a029718000000b0042aec33bc26sm1328775jai.18.2023.07.12.09.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:20:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] futex: make futex_parse_waitv() available as a helper
Date:   Wed, 12 Jul 2023 10:20:15 -0600
Message-Id: <20230712162017.391843-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712162017.391843-1-axboe@kernel.dk>
References: <20230712162017.391843-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

To make it more generically useful, augment it with allowing the caller
to pass in the wake handler and wake data. Convert the futex_waitv()
syscall, passing in the default handlers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    |  5 +++++
 kernel/futex/syscalls.c | 14 ++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 24180a95bdc8..f6598d8451fb 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -285,6 +285,11 @@ struct futex_vector {
 	struct futex_q q;
 };
 
+extern int futex_parse_waitv(struct futex_vector *futexv,
+			     struct futex_waitv __user *uwaitv,
+			     unsigned int nr_futexes, futex_wake_fn *wake,
+			     void *wake_data);
+
 extern int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 			       struct hrtimer_sleeper *to);
 
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 0b63d5bcdc77..fc3cdd0fefab 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -184,12 +184,15 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
  * @futexv:	Kernel side list of waiters to be filled
  * @uwaitv:     Userspace list to be parsed
  * @nr_futexes: Length of futexv
+ * @wake:	Wake to call when futex is woken
+ * @wake_data:	Data for the wake handler
  *
  * Return: Error code on failure, 0 on success
  */
-static int futex_parse_waitv(struct futex_vector *futexv,
-			     struct futex_waitv __user *uwaitv,
-			     unsigned int nr_futexes)
+int futex_parse_waitv(struct futex_vector *futexv,
+		      struct futex_waitv __user *uwaitv,
+		      unsigned int nr_futexes, futex_wake_fn *wake,
+		      void *wake_data)
 {
 	struct futex_waitv aux;
 	unsigned int i;
@@ -208,6 +211,8 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		futexv[i].w.val = aux.val;
 		futexv[i].w.uaddr = aux.uaddr;
 		futexv[i].q = futex_q_init;
+		futexv[i].q.wake = wake;
+		futexv[i].q.wake_data = wake_data;
 	}
 
 	return 0;
@@ -284,7 +289,8 @@ SYSCALL_DEFINE5(futex_waitv, struct futex_waitv __user *, waiters,
 		goto destroy_timer;
 	}
 
-	ret = futex_parse_waitv(futexv, waiters, nr_futexes);
+	ret = futex_parse_waitv(futexv, waiters, nr_futexes, futex_wake_mark,
+				NULL);
 	if (!ret)
 		ret = futex_wait_multiple(futexv, nr_futexes, timeout ? &to : NULL);
 
-- 
2.40.1

