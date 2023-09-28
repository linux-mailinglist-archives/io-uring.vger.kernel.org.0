Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A1A7B23DB
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjI1RZo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjI1RZh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7F8CC0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:34 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9ae3d7eb7e0so355435066b.0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921932; x=1696526732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/OGVEqmKZ+YrEmaYsT23Mong0SvETBYb//Qn3SwQyE=;
        b=KKqEJg5/0J2pSzaW+ZhrOc7EXQeEHD4+ZX0czpHDEl2Akr6z2EyzfaY3gmvzTugV51
         yT9gKDKV3F6sH1nBBqmN/eREyeyBM1B9tShvYz04j6lBTHtM+g/6eTJkUW/bXEoj8aEz
         xzA48gN1TZq7SPDGhqquMhbvLZaYP/7OzS8P4X8UczVzBXu7Z7tkklaO2LHtzO0dD0qf
         Ju3CGVwaA3JGw9HELFTRJ0dwxk9g/8YgqYjbJWlKN5kvUnoe9SkGMmx79kzklTs4pYNE
         uTE+7+osxZlAFdL6/wXQehY+aZOpMbXMUId2duKiF9zd56fgjWyGZxgojSe21EYCTu5X
         Fi4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921932; x=1696526732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8/OGVEqmKZ+YrEmaYsT23Mong0SvETBYb//Qn3SwQyE=;
        b=KJPonYjfjbLZmfNaUO3QCRMDsU04XsNYdejXTtOHVc5LZXK/bexEYXlW7d9aLfnjHN
         xs0bTrmOBlzA/yGekBkf4BPhJvXxvsvqN1kW0aTP9onl1Sl+c+mQqKnV6y5q7EPthB6E
         1ngFtlawfWZLEf587vk8jwgA/KpCxbpkkeSttSrXtWmpoRViA4ZDXig0ZcgnhNVVBOFw
         EcClp4xVQ/NhEH7KWEgM0keOUOM4EMd7Vtswe1d+iK9rez0P2LxYJYVhkjoSTMsaeAbY
         Ya4ctN++cvPFk+NiypnPZ3Bq1OqrEVrOx5VcFVcbUTSD5yNLqG7RayqJ5HMH4c2EHqHp
         9p2Q==
X-Gm-Message-State: AOJu0YzvnUFbTO1lyhog0CKapTQRuI27eSk8J/Ta1Il1gwwsalbi0BYG
        n6DRSvXgeIo4Jb9+Z2WHXxIqIWQ3yVua2P+/l3ikDNnz
X-Google-Smtp-Source: AGHT+IGbgJvR6igUJNoQ7t3LjqXpJkN7xLgY/4h9TC/rrsy9yWWjLSHI6P59T965jVCWQvsOiOqrEg==
X-Received: by 2002:a17:906:5352:b0:9a1:d79a:4190 with SMTP id j18-20020a170906535200b009a1d79a4190mr1460967ejo.2.1695921932053;
        Thu, 28 Sep 2023 10:25:32 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] futex: make futex_parse_waitv() available as a helper
Date:   Thu, 28 Sep 2023 11:25:15 -0600
Message-Id: <20230928172517.961093-7-axboe@kernel.dk>
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

To make it more generically useful, augment it with allowing the caller
to pass in the wake handler and wake data. Convert the futex_waitv()
syscall, passing in the default handlers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    |  5 +++++
 kernel/futex/syscalls.c | 16 +++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 76f6c2e0f539..6b6a6b3da103 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -361,6 +361,11 @@ struct futex_vector {
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
index 2b5cafdfdc50..4b6da9116aa6 100644
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
@@ -214,6 +217,8 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		futexv[i].w.val = aux.val;
 		futexv[i].w.uaddr = aux.uaddr;
 		futexv[i].q = futex_q_init;
+		futexv[i].q.wake = wake;
+		futexv[i].q.wake_data = wake_data;
 	}
 
 	return 0;
@@ -306,7 +311,8 @@ SYSCALL_DEFINE5(futex_waitv, struct futex_waitv __user *, waiters,
 		goto destroy_timer;
 	}
 
-	ret = futex_parse_waitv(futexv, waiters, nr_futexes);
+	ret = futex_parse_waitv(futexv, waiters, nr_futexes, futex_wake_mark,
+				NULL);
 	if (!ret)
 		ret = futex_wait_multiple(futexv, nr_futexes, timeout ? &to : NULL);
 
@@ -421,7 +427,7 @@ SYSCALL_DEFINE4(futex_requeue,
 	if (!waiters)
 		return -EINVAL;
 
-	ret = futex_parse_waitv(futexes, waiters, 2);
+	ret = futex_parse_waitv(futexes, waiters, 2, futex_wake_mark, NULL);
 	if (ret)
 		return ret;
 
-- 
2.40.1

